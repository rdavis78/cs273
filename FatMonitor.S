//FatMonitor.S    
//Purpose: Determine body how high body fat is of a person based on gender, age and fat
//Author: Rylee Davis
//Date: Sept. 17, 2019
//Input: gender, age and body fat
//Output: Light blinks indicating whether the user has low, normal, high, or very high body fat

/*Questions:
 * 1) Green light 
 * 2) All lights
 * 3) Green light
 * 4) Green light
 */

/*What I learned:
 * branches can only reach so far without using a bridge
 * blink is a keyword
 * how to understand brlo and brsh better
 */

#
# Global data (gender, age, fat)
#

  .data
    .comm gender,1
    .global gender
    .comm age,1
    .global age
    .comm fat,1
    .global fat

//program code for lightup
  .text
    .global lightup

lightup:
    ldi r18, 0b00110001
    out 0x04, r18 //0x04 is I/O address of DDRB
    out 0x05, r18 //0x05 is I/O address of PORTB
  
    lds r19, gender //stores variable gender
    lds r20, age //stores variable age
    lds r21, fat //stores variable fat
  
    cpi r19, 1
    breq female //if user inputs 1, program goes to female
  
    cpi r19, 2
    breq ml //if user inputs 2, program goes to male

    jmp exit1    
ml:
  jmp male

#
# Program for female
#

female:
    cpi r20, 20 //if age < 20, go to f20
    brlo f20 
  
    cpi r20, 40 //if < 40, go to f2040
    brlo f2040
  
    cpi r20, 60 //if < 60, go to f4060
    brlo f4060
  
    cpi r20, 80 //if < 80, go to f6080
    brlo f6080

    cpi r20, 80 //if >= 80, go to f80
    brsh f80

f20: //female under 20
    ldi r18, 0b00000000 //do nothing for ages under 20
    out 0x04, r18
    out 0x05, r18
    ret

f80: //female >= 80
    ldi r18, 0b00000000 //do nothing for ages 80 and over
    out 0x04, r18
    out 0x05, r18
    ret

f2040: //ages 20-39
    cpi r21, 21 //if < 21 go to lowfat
    brlo lowfat
    cpi r21, 33 //if < 33 go to normfat
    brlo normfat
    cpi r21, 39 //if < 39 go to highfat
    brlo veryfat
    cpi r21, 39 //if >= 39 go to extrafat
    brsh extrafat

f4060: //ages 40-59
    cpi r21, 23 //if < 23 go to lowfat blue
    brlo lowfat
    cpi r21, 34 //if < 34 go to normfat green
    brlo normfat
    cpi r21, 40 //if < 40 go to highfat
    brlo veryfat
    cpi r21, 40 //if >= 40 go to extrafat
    brsh extrafat

f6080: //ages 60-79
    cpi r21, 24 //if < 24 go to lowfat
    brlo lowfat
    cpi r21, 36 //if < 36 go to normfat
    brlo normfat
    cpi r21, 42 //if < 42 go to highfat
    brlo veryfat
    cpi r21, 42 //if >= 42 go to extrafat
    brsh extrafat
    
#
# Program for fats
#

lowfat: //if bodyfat is low, go to blink and make blue light blink
    ldi r18, 0b00100000
    out 0x04, r18
    out 0x05, r18
    jmp blink1

normfat: //if bodyfat is normal, go to blink and make green light blink
    ldi r18, 0b00010000
    out 0x04, r18
    out 0x05, r18
    jmp blink1

veryfat: //if bodyfat is high, go to blink and make red light blink
    ldi r18, 0b00000001
    out 0x04, r18
    out 0x05, r18
    jmp blink1
  
extrafat: //if bodyfat is very high, turn on all three LEDs
    ldi r18, 0b00110001
    out 0x04, r18
    out 0x05, r18
    ret

#
# Program for male
#

male:
    cpi r20, 20 //if age < 20, go to m20
    brlo m20
  
    cpi r20, 40 //if < 40, go to m2040
    brlo m2040
  
    cpi r20, 60 //if < 60, go to m4060
    brlo m4060
  
    cpi r20, 80 //if < 80, go to m6080
    brlo m6080

    cpi r20, 80 //if >= 80, go to m80
    brsh m80
    
m20: //male under 20
    ldi r18, 0b00000000 //do nothing for ages lower than 20
    out 0x04, r18
    out 0x05, r18
    ret

m80: //male >= 80
    ldi r18, 0b00000000 //do nothing for ages 80 and over
    out 0x04, r18
    out 0x05, r18
    ret

m2040: //ages 20-39
    cpi r21, 8 //if less than 8 go to lowfat
    brlo lowfat
    //we know it's greater than 8 here
    cpi r21, 20  //if < 20 go to normfat
    brlo normfat
    cpi r21, 25 //if < 25 go to veryfat
    brlo veryfat
    cpi r21, 25 //if >= 25 go to extrafat
    brsh extrafat

m4060: //ages 40-59
    cpi r21, 11 //if less than 11 go to lowfat
    brlo lowfat
    cpi r21, 22 //if < 22 go to normfat
    brlo normfat
    cpi r21, 28 //if < 28 go to veryfat
    brlo veryfat
    cpi r21, 28 //if >= 28 go to extrafat
    brsh extrafat

m6080: //60-79
    cpi r21, 13 //if < 13 go to lowfat
    brlo lowfat
    cpi r21, 25 //if < 25 go to normfat
    brlo normfat
    cpi r21, 30 //if < 30 go to veryfat
    brlo veryfat
    cpi r21, 30 //if >= 30 go to extrafat
    brsh extrafat

//for exceptions
exit1:
    ret   

//precondition is r18 has the pattern for blink1
blink1:  //R20 is the blink vector
      ldi    r16, 50
all:  mov    r17, r18 //copy information from r18 to r17
      out    0x05, r17
      ldi    r22, 0xff
dl1:  ldi    r23, 0xff
dl2:  nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      dec    r23
      brne   dl2
      dec    r22
      brne   dl1
      ldi    r17, 0x00
      out    0x05, r17
      ldi    r22, 0xff
dl3:  ldi    r23, 0xff
dl4:  nop
      nop
      nop
      nop
      dec    r23
      brne   dl4
      dec    r22
      brne   dl3
      dec    r16
      brne   all
      ret

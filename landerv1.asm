; 10 SYS (2080)

*=$0801

     BYTE $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $38, $30, $29, $00, $00, $00

*=$2a80
incbin    "lander.spt",1,3,true
          



*=$0820
          jmp  gamestart 
          
playerxfrac
          brk

playerxlo
          brk

playerxhi
          brk
          
playeryfrac
          brk
          
playery
          brk
          
playerspno
          byte 0

playercolour
          brk
          
thrustspno
          byte 1
          
thrustframeno
          brk
          
thrustcolour
          brk
          
manuovercolour
          brk
         
verticalvelocity
          brk
          
verticalvelocityfrac
          brk

gravity
          brk
          
gravityfrac
          brk
          
thrust
          brk
          
thrustfrac
          brk
                    
horizontalvelocity
          brk
          
horizontalvelocityfrac
          brk
          
horizontalinertia
          brk
          
horizontalinertiafrac
          brk
          
lives
          brk
                    
thrust1spno
          byte 1
         
thrust2spno
          byte 2
          
thrust1col
          brk
          
thrust2col
          brk
          
playercol
          brk
          
plup
          brk
          
pldn
          brk
          
plle
          brk
          
plri
          brk

incasm    "libconstants.asm"
incasm    "libmath.asm"
incasm    "libinput.asm"
incasm    "libsprite.asm"
incasm    "libscreen.asm"
incasm    "libprint.asm"
          

gamestart
          jsr  setupsprites
          jsr  setupkeys 
          jsr  initgame
          
mainloop
          libscreen_wait_v 251       
          lda  #1
          sta  extcol
          jsr  readinput 
          jsr  updatespriteposition 
          
          lda  #0        
          sta  extcol
          jmp  mainloop  
;          rts
initgame
          lda  #black   
          sta  bgcol0    
          sta  extcol    
          lda  #yellow
          sta  646       
          lda  #0        
          sta  verticalvelocity
          sta  horizontalvelocity
          sta  gravity   
          sta  thrust
          sta  horizontalinertia
          
          lda  #1        
          sta  gravityfrac
          sta  horizontalinertiafrac
          lda  #4        
          sta  thrustfrac
          
          rts
          
setupsprites
          lda  #100      
          sta  playerxlo   
          sta  playery   
          lda  #white    
          sta  playercolour 
          lda  #red      
          sta  thrust1col
          lda  #yellow   
          sta  thrust2col
          lda  #0        
          sta  playerspno
          sta  playerxhi 
          
          
          lda  vicirq    
          ora  #2        
          sta  vicirq    
          
          libsprite_enable_av playerspno,true
          libsprite_setframe_av playerspno,0  
          libsprite_setposition_aaaa playerspno,playerxhi,playerxlo,playery
          

          rts
          
setupkeys
          lda  0         
          sta  198 
      
keyup     lda  197       
          cmp  #64       
          beq  keyup
          sta  plup      

keydn     lda  197       
          cmp  #64       
          beq  keydn     
          cmp  plup      
          beq  keydn 
          sta  pldn      
          
keyle     lda  197
          cmp  #64       
          beq  keyle     
          cmp  plup      
          beq  keyle     
          cmp  pldn      
          beq  keyle     
          sta  plle      

keyri     lda  197
          cmp  #64       
          beq  keyri     
          cmp  plup      
          beq  keyri     
          cmp  pldn      
          beq  keyri     
          cmp  plle      
          beq  keyri     
          sta  plri      

          rts
          
readinput
          lda  197
          cmp  plle      
          bne  testright 
          libmath_sub16bit_aaa horizontalvelocityfrac,horizontalinertiafrac,horizontalvelocityfrac

testright
          cmp  plri      
          bne  testup    
          libmath_add16bit_aaa horizontalvelocityfrac,horizontalinertiafrac,horizontalvelocityfrac

testup
          cmp  plup      
          bne  noinput  
          libmath_sub16bit_aaa verticalvelocityfrac,thrustfrac,verticalvelocityfrac
          jmp  bypassgravity
noinput
          libmath_add16bit_aaa verticalvelocityfrac,gravityfrac,verticalvelocityfrac

bypassgravity
          lda  verticalvelocity
          cmp  #2        
          bne  inputfinish
          
          lda  #1        
          sta  verticalvelocity
          lda  #0        
          sta  verticalvelocityfrac
          
inputfinish
          rts
          
updatespriteposition 

;          libmath_add8bit_aaa playery,verticalvelocity,playery
          libmath_add16bit_aaa playeryfrac, verticalvelocityfrac, playeryfrac
          libmath_add16bit_aaa playerxfrac, horizontalvelocityfrac, playerxfrac

;          libsprite_setframe_aa thrustspno,thrustframeno
;          libsprite_setframe_aa manuoverspno, manuoverframeno

;          libsprite_setposition_aaaa playerspno,playerxhi,playerxlo,playery
;          libsprite_setposition_aaaa thrustspno,playerxhi,playerxlo,playery
;          libsprite_setposition_aaaa manuoverspno, playerxhi,playerxlo,playery
          libsprite_setposition_aaaa playerspno,playerxhi,playerxlo,playery

          rts

import os 

import random
import pygame
import time
import random
from pygame import mixer
import datetime

pygame.init()



x = input('Enter your name:')


def sort_text_document():
    file = open('Players.txt',"r")
    data = file.readlines()
    data.sort()
    file.close()
    file = open('Players.txt',"w")
    for i in range(len(data)):
        file.write(data[i])
    file.close()







background_image=pygame.image.load('image.jpg')
dis_width = 1200
dis_height = 700

#create the screen
screen=pygame.display.set_mode((dis_width,dis_height))


#caption and icon
pygame.display.set_caption('Rapid - Fire by Andrei Istrate')
icon=pygame.image.load('rsz_1rsz_aim.png')
pygame.display.set_icon(icon)


def show_background():
    background_image=pygame.image.load('image.jpg')
    screen.blit(background_image,(0,0))
 

def show_bottom_panel():
    panel_image = pygame.image.load('stone.jpg')
    screen.blit(panel_image,(0,dis_height-90))


def show_up_panel():
    panel_image = pygame.image.load('rsz_stone.jpg')
    screen.blit(panel_image,(0,0))


#target
targetImg = []
target_x = []
target_y = []
target_radius = 50
target_x_change = []
target_y_change = []
number_of_targets = 10
target_speed = 1

# combo target
comboImg = []
combo_x = []
combo_y = []
combo_radius = 30
combo_x_change = []
combo_y_change = []
number_of_combos = 10
combo_speed = 1

total_targets = number_of_targets + number_of_combos
total_points_left = number_of_targets*1 + number_of_combos*2



for i in range(number_of_targets):
    targetImg.append(pygame.image.load('target.png'))
    target_x.append(random.randint(30,1150))
    target_y.append(random.randint(30,560))
    target_x_change.append(target_speed)
    target_y_change.append(target_speed)


for i in range(number_of_combos):
    comboImg.append(pygame.image.load('rsz_1rsz_aim.png'))
    combo_x.append(random.randint(30,1150))
    combo_y.append(random.randint(30,560))
    combo_x_change.append(combo_speed)
    combo_y_change.append(combo_speed)


running=True
clock = pygame.time.Clock()
font_style = pygame.font.SysFont(None, 50)

#Background music
mixer.music.load('Landis x Breikthru - The Moment ft. Saint Wade (Official Audio).mp3')
mixer.music.play(-1)


#display score

score_value=0
font = pygame.font.Font('freesansbold.ttf',32)
testX = 10
testY = dis_height - 80

def show_score(x,y):
    score = font.render("Score : " + str(score_value) ,True ,(255,255,255))
    screen.blit(score,(x,y))


def show_targets_left(x,y):
    targets_left = font.render("Targets left :" + str(total_targets),True,(246,10,10))
    screen.blit(targets_left,(x,y))


def show_total_points_left(x,y):
    points_left = font.render(str(total_points_left) + " points left to win",True,(255,255,255))
    screen.blit(points_left,(x,y))


def show_copyright(x,y):
    copyright_text = font.render("Press ESC to forfeit !",True,(255,255,255))
    screen.blit(copyright_text,(x,y))



def show_level0(x,y):
    lvl0 = font.render("LEVEL 0",True,(255,255,255))
    screen.blit(lvl0,(x,y))


def show_level1(x,y):
    lvl1 = font.render("LEVEL 1",True,(255,255,255))
    screen.blit(lvl1,(x,y))



def show_level2(x,y):
    lvl2 = font.render("LEVEL 2",True,(255,255,255))
    screen.blit(lvl2,(x,y))



def show_level3(x,y):
    lvl3 = font.render("LEVEL 3",True,(255,255,255))
    screen.blit(lvl3,(x,y))



def show_message(x,y):
    message1 = font.render("Press ESC to forfeit",True,(255,255,255))
    screen.blit(message1,(x,y))



def message(msg,color):
    mesg = font_style.render(msg, True, color)
    screen.blit(mesg, [dis_width/2 - 300, dis_height/2])
   

def show_name_at_the_end():
    name = font.render(x,True,(255,255,255))
    screen.blit(name,(0,0))

#Menu with button

def draw_menu():
    menu_screen=pygame.display.set_mode((dis_width,dis_height))
    menu_background_image=pygame.image.load('image.jpg')
    screen.blit(menu_background_image,(0,0))
    

    #font = pygame.font.Font(None, 32)
    #clock = pygame.time.Clock()
    #input_box = pygame.Rect(100, 560, 140, 32)
    #color_inactive = pygame.Color('lightskyblue3')
    #color_active = pygame.Color('dodgerblue2')
    #color = color_inactive
    #active = False
    #text = ''
    

    #for event in pygame.event.get():
     #   if event.type == pygame.MOUSEBUTTONDOWN:
                # If the user clicked on the input_box rect.
     #       if input_box.collidepoint(event.pos):
                    # Toggle the active variable.
     #           active = not active
     #       else:
     #           active = False
                # Change the current color of the input box.
     #       color = color_active if active else color_inactive
     #   if event.type == pygame.KEYDOWN:
     #       if active:
     #           if event.key == pygame.K_RETURN:
     #               print(text)
     #               text = ''
     #           elif event.key == pygame.K_BACKSPACE:
     #               text = text[:-1]
     #           else:
     #               text += event.unicode

    #txt_surface = font.render(text,True,color)
    #txt_surface = font.render(text, True, color)
    # Resize the box if the text is too long.
    #width = max(200, txt_surface.get_width()+10)
    
    #input_box.w = width
    # Blit the text.
    #menu_screen.blit(txt_surface, (input_box.x+5, input_box.y+5))
        # Blit the input_box rect.
    #pygame.draw.rect(menu_screen, color, input_box, 2)

    #pygame.display.flip()
    #clock.tick(30)
    pygame.draw.rect(menu_screen,(255,255,255),(290,340,620,50),5) 
    message("Press SPACEBAR to start the game !",(255,255,255))
    

    pygame.display.flip()
    state = pygame.key.get_pressed()
    if state[pygame.K_SPACE]:
        return "S"


def draw_win():
    win_screen=pygame.display.set_mode((dis_width,dis_height))
    #win_screen.fill((0,0,255))
    show_background()
    message("     You won ! Press ESC to quit",(255,204,229))
    show_name_at_the_end()
    pygame.display.update()



def draw_lose():
    lose_screen = pygame.display.set_mode((dis_width,dis_height))
    show_background()
    message("    YOU LOST...Press ESC to quit",(255,204,229))
    show_name_at_the_end()
    pygame.display.update()
    



# necesita explicatie ! :
def check_target(x,y):
    
    mouse_pressed=pygame.mouse.get_pressed()
    mouse_x,mouse_y = pygame.mouse.get_pos()
    #click_sound = mixer.Sound('rico3.wav')
    if (x-mouse_x)*(x-mouse_x) + (y-mouse_y)*(y-mouse_y) <= target_radius * target_radius and mouse_pressed[0] :
        #click_sound.play()
        return True
    else:
        return False


def check_combo(x,y):
    mouse_pressed=pygame.mouse.get_pressed()
    mouse_x,mouse_y = pygame.mouse.get_pos()
    #click_sound = mixer.Sound('rico3.wav')
    if (x-mouse_x)*(x-mouse_x) + (y-mouse_y)*(y-mouse_y) <= combo_radius * target_radius and mouse_pressed[0] :
        #click_sound.play()
        return True
    else:
        return False


def show_target(x,y,i):
    if(check_target(x,y) == False):
        screen.blit(targetImg[i],(x,y))


def show_combo(x,y,i):
    if(check_combo(x,y) == False):
        screen.blit(comboImg[i],(x,y))
    


def check_escape():
    escape=pygame.key.get_pressed()
    if escape[pygame.K_ESCAPE]:
        return "E"


def check_enter():
    enter = pygame.key.get_pressed()
    if enter[pygame.K_BACKSPACE]:
        return "ENTER"



#start_timer
clock = pygame.time.Clock()
counter, text = 25, '25'.rjust(5)
pygame.time.set_timer(pygame.USEREVENT, 1000)

def check_counter():
    if(counter <= -1):
        return True

time_left = font.render("Time left : ",True ,(255,255,255))
time_left_x = testX
time_left_y = testY + 40





def draw_game():
    global score_value
    global testX
    global testY
    global target_speed
    global start_time
    global counter
    global text
    global time_left
    global time_left_x
    global time_left_y
    global dis_height
    global dis_width
    global combo_speed
    global total_targets
    global total_points_left
    
    
    show_background()
    show_bottom_panel()
    show_up_panel()
    show_targets_left(300,time_left_y)
    #show_message(0,time_left_y)
    for e in pygame.event.get():
        if e.type == pygame.USEREVENT: 
            counter -= 1
            if counter == 0 :   
                pygame.mixer.music.stop()
                mixer.music.load('Game Over Super Mario Bros..mp3')
                mixer.music.play(-1)
                f = open("Players.txt","a")
                f.write(x)
                f.write(" <-----> ")
                f.write(str(score_value))
                f.write("\n")
                f.close()
                sort_text_document()
            text = str(counter).rjust(5)
        if e.type==pygame.QUIT:
                running=False

    screen.blit(time_left,(time_left_x,time_left_y))
    screen.blit(font.render(text, True, (255,255,255)), (150, time_left_y))

    clock.tick(60)

    show_score(testX,testY)
    show_total_points_left(300,testY)
    show_copyright(750,640)

    # Difficulty depending on player's score and target_movement 
    if(score_value >= 0 and score_value < 5):
        show_level0(dis_width/2-100,0)
    if(score_value >= 5 and score_value < 10):   
        target_speed = 2
        combo_speed = 2
        show_level1(dis_width/2 - 100,0)
    if(score_value >= 10 and score_value <35):
        target_speed = 3
        combo_speed = 3
        show_level2(dis_width/2 - 100,0)
    if(score_value >=35):
        target_speed = 5
        combo_speed = 5
        show_level3(dis_width/2 - 100,0)
    for i in range(number_of_targets):
        if check_target(target_x[i],target_y[i]) == True:
            target_x[i] = -1000000
            target_y[i] = 1000000
            target_x_change[i] = 0
            target_y_change[i] = 0
            total_targets -= 1
            score_value = score_value + 1
            total_points_left-=1
            if total_targets == 0:
                pygame.mixer.music.stop()
                mixer.music.load('intro-uefa-champions-league2.mp3')
                mixer.music.play(-1)
                counter = 1000
                f = open("Players.txt","a")
                f.write(x)
                f.write(" <-----> ")
                f.write(str(score_value))
                f.write("\n")
                f.close()
                sort_text_document()
        else:
            show_target(target_x[i],target_y[i],i)
        target_x[i] +=target_x_change[i]
        target_y[i] +=target_y_change[i]
      #  dis_width = 1200
      #  dis_height = 700
        if target_x[i] <= 30:
            target_x_change[i] = target_speed
        elif target_x[i] >= 1130:
            target_x_change[i] = -target_speed
        if target_y[i] <= 30:  #30
            target_y_change[i] = target_speed
        elif target_y[i] >= dis_height/5*4:
            target_y_change[i] =-target_speed
    #combos
    for i in range(number_of_combos):
        if check_combo(combo_x[i],combo_y[i]) == True:
            combo_x[i] = -100000
            combo_y[i] = -100000
            combo_x_change[i] = 0
            combo_y_change[i] = 0
            total_targets -= 1
            total_points_left-=2
            score_value = score_value + 2
            if total_targets == 0:
                pygame.mixer.music.stop()
                mixer.music.load('intro-uefa-champions-league2.mp3')
                mixer.music.play(-1)
                counter = 1000
                f = open("Players.txt","a")
                f.write(x)
                f.write(" <-----> ")
                f.write(str(score_value))
                f.write("\n")
                f.close()
                sort_text_document()
        else:
            show_combo(combo_x[i],combo_y[i],i)
        combo_x[i] +=combo_x_change[i]
        combo_y[i] +=combo_y_change[i]

        if combo_x[i] <= 30:
            combo_x_change[i] = combo_speed
        elif combo_x[i] >= 1130:
            combo_x_change[i] = -combo_speed
        if combo_y[i] <= 30:
            combo_y_change[i] = combo_speed
        elif combo_y[i] >= dis_height/5*4:
            combo_y_change[i] =-combo_speed




while running == True:

    option = draw_menu()
    if quit == True:
        pygame.quit()
        break
    if option == "S":
        while True:
            draw_game()
            #if datetime.datetime.utcnow() > timer_stop:
             #   print ("Ai avut " + str(seconds) + " secunde . Timpul tau a expirat !")
              #  quit = True
               # break
            if check_escape() == "E" :
                quit = True
                break
            elif total_targets == 0 :                
                draw_win()
                if check_escape() == "E" :
                    quit = True
                    break
            elif check_counter() == True:
                draw_lose()
                if check_escape() == "E" :
                    quit = True
                    break
            pygame.display.update()
           
       
    
    
pygame.quit()








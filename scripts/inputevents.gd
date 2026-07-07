extends LineEdit

func _gui_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			accept_event()
		elif event.keycode == KEY_TAB:
			$"..".tab_autofill()
		elif !$"..".timer_active:
			if !$"..".is_first_letter:
				accept_event()


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		$".".grab_focus()

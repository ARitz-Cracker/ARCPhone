ARCPhone.TileBase = {}
ARCPhone.TileBase.tile = true
ARCPhone.TileBase.x = 48
ARCPhone.TileBase.y = 48
ARCPhone.TileBase.w = 16
ARCPhone.TileBase.h = 16
ARCPhone.TileBase.color = color_white
ARCPhone.TileBase.tex = false
ARCPhone.TileBase.mat = false
ARCPhone.TileBase.drawfunc_override = false
ARCPhone.TileBase.drawfunc = false
ARCPhone.TileBase.text = ""
ARCPhone.TileBase.OnPressed = NULLFUNC -- (self)
ARCPhone.TileBase.OnUnPressed = NULLFUNC -- (self)
ARCPhone.TileBase.OnSelected = NULLFUNC -- (self)
ARCPhone.TileBase.OnUnSelected = NULLFUNC -- (self)
function ARCPhone.NewAppTile(app)
	local tab = table.Copy(ARCPhone.TileBase)
	tab.App = app
	return tab
end

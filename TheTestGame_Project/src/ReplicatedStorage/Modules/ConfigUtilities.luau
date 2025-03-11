--!strict

local ConfigUtilities = {}

ConfigUtilities.VlueType = { --[VlueType] = name
	Bool = "BoolValue",
	CFrame = "CFrameValue",
	Int = "IntValue",
	Number = "NumberValue",
	Object = "ObjectValue",
	String = "StringValue",
}

function ConfigUtilities.GetSceneValue(parent: Instance, valueName: string, valueType: string): any?
	local valueObject = parent:FindFirstChild(valueName)

	if not valueObject then
		warn(`{valueObject.Name}({valueObject.ClassName}) not set`)
		return nil
	end

	if not valueObject:IsA(valueType) then
		warn(`{valueObject.Name}({valueObject.ClassName}) is not «{valueType}»`)
		return nil
	end

	local value: any? = valueObject.Value

	return value
end

return ConfigUtilities

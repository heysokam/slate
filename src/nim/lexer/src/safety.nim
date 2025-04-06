{.pragma: mmsafe, raises:[].}
type DoesAlloc * = object of RootEffect
{.pragma: noalloc, forbids: [DoesAlloc].}
{.pragma: mmnone, mmsafe, noalloc, gcsafe.}


# someEntryFile.nim.cfg
#_____________________________
# # Our Best friend. We like him
# --mm:none
# # His bully group of friends :(
# --d:useMalloc
# --threads:off
# --warningAsError:GcMem:on
#
#
# # Our other good friends.
# # Help us know what we do wrong.
# --warningAsError:UnreachableCode:on
# --warningAsError:UnusedImport:on
# --hintAsError:DuplicateModuleImport:on
# --hintAsError:XDeclaredButNotUsed:on
#
# # Nim does not define this, so we do
# # Useful for integration with arc/orc
# --d:gcnone
#_____________________________

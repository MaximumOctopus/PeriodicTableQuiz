// (c) Paul Alan Freshney 2006-2007
//
//  Created: October 26th 2006
// Modified: March 22nd 2008
//
//
// 1150

unit utility;

interface

uses shellapi, sysutils, classes, Controls, Contnrs, math;

type
 PSearchRecPTE = ^TSearchRecPTE;
 TSearchRecPTE = record
                   ElementID : integer;
                   FilePath : string;
                   count    : array[0..19] of integer;
                 end;

 TElectron  = record
                angle : integer;
                originoffset : integer;
              end;

 TFlashData = record
                elementid : integer;
                count : integer;
                oldcolour : integer;
              end;

 TConstants = record
                name : string;
                symbol : string;
                value : string;
                units : string;
              end;

 TPTESettings = record
                  g_AutoSaveLayout : boolean;
                  // ===========================================
                  graph_GradientT       : integer;
                  graph_GradientB       : integer;
                  graph_BarColor        : integer;
                  graph_BarChoiceSingle : boolean;
                  // ===========================================
                  scaleGradient         : integer;
                  // ===========================================
                  colors_ElementTypes   : array[1..11] of integer;
                  colour_Periods        : array[1..9] of integer;
                  colour_Groups         : array[1..18] of integer;
                  // ===========================================
                  ShowOnThisDay         : boolean;
                  // ===========================================
                  LanguageID            : integer;
                  LanguageSymbol        : string;
                end;

 TElementStruct = record
                    Name           : string;
                    Neutrons       : integer;
                    Shell          : string[18];
                    DiscoDate      : string;
                    Properties     : array[1..36] of double;
                    IonEnergies    : array[1..10] of integer;
                    ElectronConfig : string;
                    MagneticOrder  : string;
                    IsoAbundance   : TStringList;
                    XrayMAC        : TStringList;
                  end;

 TMoleculeObject = class(TObject)
                     Name    : string;
                     Formula : string;
                     Links   : string;
                     Atoms   : TStringList;
                   end;

  TChemicalObject = class(TObject)
    RealName   : string;
    Formula    : string;
    CASID      : string;
    OtherNames : TStringList;
  end;

  TMapData   = record
                  Colour   : integer;
                  Name     : string;
                  Code     : string;
                  Elements : string;
                end;

const
  ptDate    : string = 'May 3rd 2009';
  ptVersion : string = '1.7.1';

  ColElementSolid  : integer = $007798DB;
  ColElementLiquid : integer = $00BEE2B8;
  ColElementGas    : integer = $00A8D9D6;

  ScaleGradientImages : array[1..8] of string = ('Blue', 'ColdHot', 'Green', 'Purple', 'Red', 'Spectrum', 'Sun Burst', 'WhiteRed');

  Months              : array[1..12] of string = ('January', 'February', 'March', 'April', 'May', 'June',
                                                 'July', 'August', 'September', 'October', 'November', 'December');  

  HelpFiles : array[1..5] of string = ('graph.htm',
                                       'search.htm',
                                       'atomicradius.htm',
                                       'electronshell.htm',
                                       'temp.htm');

  ElementListFiles : array[1..31] of string = ('idx_byabundanceec.htm',
                                               'idx_byabundancesun.htm',
                                               'idx_byabundanceuni.htm',
                                               'idx_byabundanceha.htm',
                                               'idx_byam.htm',
                                               'idx_byan.htm',
                                               'idx_byar.htm',
                                               'idx_byav.htm',
                                               'idx_bybh.htm',
                                               'idx_bybp.htm',
                                               'idx_bydate.htm',
                                               'idx_bydensity.htm',
                                               'idx_bydiscoverer.htm',
                                               'idx_byelcon.htm',
                                               'idx_byenps.htm',
                                               'idx_byeof.htm',
                                               'idx_byeov.htm',
                                               'idx_byhc.htm',
                                               'idx_bylocation.htm',
                                               'idx_bymp.htm',
                                               'idx_byname.htm',
                                               'idx_bysymbol.htm',
                                               'idx_bythcon.htm',
                                               'idx_bythex.htm',
                                               'idx_bybm.htm',
                                               'idx_bypr.htm',
                                               'idx_bysm.htm',
                                               'idx_byvh.htm',
                                               'idx_byym.htm',
                                               'idx_bysos.htm',
                                               'idx_byelres.htm');

  ElementSymbol : array[1..120] of string[3] =
                 ('H', 'He','Li','Be','B','C','N','O','F','Ne',
                  'Na','Mg','Al','Si','P','S','Cl','Ar','K','Ca',
                  'Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn',
                  'Ga','Ge','As','Se','Br','Kr','Rb','Sr','Y','Zr',
                  'Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In','Sn',
                  'Sb','Te','I','Xe','Cs','Ba','La','Ce','Pr','Nd',
                  'Pm','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb',
                  'Lu','Hf','Ta','W','Re','Os','Ir','Pt','Au','Hg',
                  'Tl','Pb','Bi','Po','At','Rn','Fr','Ra','Ac','Th',
                  'Pa','U','Np','Pu','Am','Cm','Bk','Cf','Es','Fm',
                  'Md','No','Lr','Rf','Db','Sg','Bh','Hs','Mt','Ds',
                  'Rg','Cp','Uut','Uuq','Uup','Uuh','Uus','Uuo',
                  'D', 'T');

  ElementGroup : array[1..118] of byte =
                  (1,18,
                   1, 2, 0, 0, 0, 0,17,18,
                   1, 2, 0, 0, 0, 0,17,18,
                   1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,17,18,
                   1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,17,18,
                   1, 2,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19, 0,0,0,0,0,0,0,0,0,0,0,0,0,17,18,
                   1, 2,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

  ElementState : array[1..118] of byte =
                  (1,1,
                   2,2,2,2,1,1,1,1,
                   2,2,2,2,2,2,1,1,
                   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,1,
                   2,2,2,2,2,2,4,2,2,2,2,2,2,2,2,2,2,1,
                   2,2,2,2,2,2,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,2,2,2,1,
                   2,2,2,2,2,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4);

  ElementOccurrence : array[1..118] of byte =
                   (1,1,
                    1,1,1,1,1,1,1,1,
                    1,1,1,1,1,1,1,1,
                    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
                    1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,
                    1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,
                    3,3,3,1,3,1,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);

  ElementBlock : array[1..118] of byte =
                   (1,1,
                    1,1,2,2,2,2,2,2,
                    1,1,2,2,2,2,2,2,
                    1,1,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,
                    1,1,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,
                    1,1,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,
                    1,1,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2);

  ElementGS : array[1..118] of byte =
                   (4,4,
                    1,1,1,4,4,1,1,4,
                    1,1,1,1,1,3,1,4,
                    1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,1,4,
                    1,1,1,1,1,2,5,2,2,2,3,3,3,3,3,3,1,4,
                    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,1,4,
                    5,5,5,1,5,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5);

 ElementRadioactive : array[1..118] of byte =
                  (0,0,
                   0,0,0,0,0,0,0,0,
                   0,0,0,0,0,0,0,0,
                   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                   0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,
                   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);

  ElementTypes : array[1..118] of integer = (4,6,
                                          7,2,5,4,4,4,3,6,
                                          7,2,8,5,4,4,3,6,
                                          7,2,1,1,1,1,1,1,1,1,1,1,8,5,5,4,3,6,
                                          7,2,1,1,1,1,1,1,1,1,1,1,8,8,5,5,3,6,
                                          7,2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,1,1,1,1,1,1,1,1,1,8,8,8,5,3,6,
                                          7,2,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11);

  ElementsAlphabetical : array[0..8, 1..118] of byte = ((89, 13, 95, 51, 18, 33, 85, 56, 97, 4, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 17, 24, 27, 29, 96, 110, 105, 66, 99, 68, 63, 100, 9, 87, 31, 64, 32, 79, 72, 108, 2, 67, 1, 49, 53, 77, 26, 36, 57, 103, 82, 3, 71, 12, 25, 109,
                                                         101, 80, 42, 60, 10, 93, 28, 41, 7, 102, 76, 8, 46, 15, 78, 94, 84, 19, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 21, 106, 34, 14, 47, 11, 38, 16, 73, 43, 52, 65, 81, 90, 69, 50, 22, 74, 112, 116, 118, 115, 114, 117, 113,
                                                         92, 23, 54, 70, 39, 30, 40),
                                                        (89, 13, 95, 51, 18, 33, 85, 56, 97, 4, 83, 107, 5, 35, 48, 20, 98, 58, 55, 17, 24, 96, 110, 105, 66, 99, 68, 63, 100, 9, 15, 87, 64, 31, 32, 79, 72, 108, 2, 67, 26, 49, 77, 53, 19, 27, 6, 29, 36, 80, 57, 103, 3, 82, 71, 12, 25, 109,
                                                         101, 42, 11, 60, 10, 93, 28, 41, 102, 76, 46, 78, 94, 84, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 21, 106, 34, 14, 7, 38, 73, 43, 52, 65, 81, 90, 69, 50, 22, 112, 116, 118, 115, 114, 117, 113, 92, 23, 1, 74, 54, 70, 39, 47,
                                                         30, 40, 8, 16),
                                                        (89, 13, 95, 51, 47, 18, 33, 85, 7, 56, 97, 4, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 17, 24, 27, 29, 96, 110, 105, 66, 99, 68, 50, 63, 100, 26, 9, 87, 64, 31, 32, 72, 108, 2, 67, 1, 49, 53, 77, 36, 57, 103, 3, 71, 12, 25, 109, 101,
                                                         80, 42, 60, 10, 93, 28, 41, 102, 79, 76, 8, 46, 15, 78, 82, 94, 84, 19, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 21, 106, 34, 14, 11, 16, 38, 73, 43, 52, 65, 81, 90, 69, 22, 74, 112, 116, 118, 115, 114, 117, 113, 92, 23,
                                                         54, 70, 39, 30, 40),
                                                        (89, 13, 95, 51, 18, 33, 85, 56, 97, 4, 83, 82, 107, 5, 35, 48, 20, 98, 55, 58, 17, 24, 27, 96, 110, 105, 66, 99, 26, 68, 63, 100, 9, 87, 64, 31, 32, 79, 72, 108, 2, 67, 49, 53, 77, 19, 6, 36, 29, 57, 103, 3, 71, 12, 25, 109,
                                                         101, 42, 11, 60, 10, 93, 28, 41, 102, 76, 46, 15, 78, 94, 84, 59, 61, 91, 80, 88, 86, 75, 45, 111, 37, 44, 104, 62, 8, 21, 16, 106, 34, 47, 14, 7, 38, 73, 43, 52, 65, 81, 90, 69, 22, 112, 116, 118, 115, 114, 117, 113, 92, 3,
                                                         1, 74, 54, 70, 39, 30, 50, 40),
                                                        (72, 13, 95, 51, 47, 18, 33, 85, 89, 7, 56, 4, 97, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 17, 27, 36, 24, 96, 66, 105, 99, 2, 68, 63, 100, 26, 9, 15, 87, 64, 31, 32, 108, 1, 49, 53, 77, 70, 39, 57, 103, 3, 71, 12, 25, 109, 101, 80,
                                                         42, 60, 10, 93, 28, 41, 102, 67, 79, 76, 8, 46, 82, 78, 94, 84, 19, 59, 61, 91, 88, 86, 29, 75, 45, 110, 111, 37, 44, 104, 62, 21, 106, 34, 14, 11, 16, 50, 38, 81, 73, 43, 52, 65, 22, 90, 69, 74, 112, 116, 118, 115, 114, 117, 113,
                                                         92, 23, 54, 30, 40),
                                                        (89, 13, 95, 51, 18, 33, 85, 56, 4, 97, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 82, 17, 27, 29, 24, 96, 110, 66, 105, 99, 16, 68, 21, 50, 38, 63, 100, 26, 9, 15, 87, 64, 31, 32, 72, 108, 2, 1, 67, 49, 53, 77, 70, 39, 36, 57, 103, 3,
                                                         71, 12, 25, 109, 101, 80, 42, 60, 10, 93, 41, 28, 7, 102, 76, 79, 8, 46, 78, 94, 84, 19, 47, 61, 59, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 106, 34, 14, 11, 81, 73, 43, 52, 65, 22, 90, 69, 74, 112, 116, 118, 115, 114, 117, 113,
                                                         92, 23, 54, 30, 40),
                                                        (89, 13, 95, 51, 18, 33, 85, 16, 56, 4, 97, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 30, 40, 17, 27, 29, 24, 96, 110, 66, 105, 99, 68, 21, 50, 38, 63, 100, 9, 15, 87, 64, 31, 32, 72, 108, 2, 1, 26, 67, 49, 77, 36, 57, 103, 3, 71, 12,
                                                         25, 109, 101, 80, 42, 60, 10, 93, 41, 28, 7, 102, 79, 76, 8, 46, 47, 78, 82, 94, 84, 19, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 106, 34, 14, 11, 81, 73, 43, 52, 65, 22, 90, 69, 112, 116, 118, 115, 114, 117, 113, 92, 23,
                                                         74, 54, 53, 70, 39),
                                                        (89, 13, 95, 51, 18, 33, 85, 56, 97, 4, 82, 107, 5, 35, 98, 58, 55, 96, 110, 105, 66, 99, 68, 63, 100, 9, 15, 87, 64, 31, 32, 79, 72, 108, 2, 67, 49, 77, 26, 48, 20, 19, 14, 17, 27, 6, 29, 24, 36, 7, 80, 53, 57, 103, 3, 71, 12,
                                                         25, 109, 101, 42, 11, 60, 10, 93, 28, 41, 102, 76, 46, 78, 94, 84, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 106, 34, 47, 21, 38, 16, 8, 81, 73, 43, 52, 50, 65, 22, 90, 69, 112, 116, 118, 115, 114, 117, 113, 92, 23, 1, 83,
                                                         74, 54, 70, 39, 30, 40),
                                                        (89, 13, 95, 51, 18, 33, 85, 56, 97, 4, 83, 107, 5, 35, 48, 20, 98, 6, 58, 55, 17, 24, 27, 29, 96, 110, 105, 66, 99, 68, 63, 100, 9, 87, 31, 64, 32, 79, 72, 108, 2, 67, 1, 49, 53, 77, 26, 36, 57, 103, 82, 3, 71, 12, 25, 109,
                                                         101, 80, 42, 60, 10, 93, 28, 41, 7, 102, 76, 8, 46, 15, 78, 94, 84, 19, 59, 61, 91, 88, 86, 75, 45, 111, 37, 44, 104, 62, 21, 106, 34, 14, 47, 11, 38, 16, 73, 43, 52, 65, 81, 90, 69, 50, 22, 74, 112, 116, 118, 115, 114, 117, 113,
                                                         92, 23, 54, 70, 39, 30, 40));

  PTGraphLayout : array[1..9, 1..18] of integer = ((  1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   2),
                                                   (  3,   4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   5,   6,   7,   8,   9,  10),
                                                   ( 11,  12,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  13,  14,  15,  16,  17,  18),
                                                   ( 19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36),
                                                   ( 37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54),
                                                   ( 55,  56,  57,  72,  73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,  85,  86),
                                                   ( 87,  88,  89, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118),
                                                   (  0,   0,   0,  58,  59,  60,  61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,   0),
                                                   (  0,   0,   0,  90,  91,  92,  93,  94,  95,  96,  97,  98,  99, 100, 101, 102, 103,   0));

  StateColours : array[1..5] of integer = ($c0c0FF, $c0ffff, $c0ffc0, $ffffc0, $ffc0c0);                                          

  _BoilingPoint               = 1;
  _MeltingPoint               = 2;
  _AtomicMass                 = 3;
  _HeatCapacity               = 4;
  _ThermalConductivity        = 5;
  _ThermalExpansion           = 6;
  _Density                    = 7;
  _ElectricalConductivity     = 8;
  _Electronegativity          = 9;
  _EnthalpyFusion             = 10;
  _EnthalpyVaporisation       = 11;
  _AbundanceUniverse          = 12;
  _AbundanceSun               = 13;
  _AbundanceEarthsCrust       = 14;
  _AbundanceHumanWeight       = 15;
  _AbundanceHumanAtoms        = 16;
  _ElectricalResistivity      = 17;
  _BulkModulus                = 18;
  _ShearModulus               = 19;
  _YoungsModulus              = 20;
  _BrinellHardness            = 21;
  _VickersHardness            = 22;
  _PoissonRatio               = 23;
  _SpeedofSound               = 24;
  _DiscoveryDate              = 25;
  _AtomicVolume               = 26;
  _MassMagneticSusc           = 27;
  _MolarMagneticSusc          = 28;
  _EnthalpyAtomization        = 29;
  _ValenceElectronPotential   = 30;
  _AtomicRadius               = 31;
  _AtomicRadiusBohr           = 32;
  _AtomicRadiusCovalent       = 33;
  _AtomicRadiusVanDerWaals    = 34;
  _AtomicRadiusTriple         = 35;
  _AtomicRadiusMetallic       = 36;

  XUNDEFINED = 0;
  XUPPERCASE = 1;
  XLOWERCASE = 2;
  XNUMERIC   = 3;

  FORMTYPE_DATAWINDOW      = $FF01;
  FORMTYPE_PTWINDOW        = $FF02;
  FORMTYPE_GRAPHWINDOW     = $FF03;
  FORMTYPE_SEARCHWINDOW    = $FF04;
  FORMTYPE_ATOMICSTRUCTURE = $FF05;
  FORMTYPE_ATOMICRADIUS    = $FF06;
  FORMTYPE_MEDIAWINDOW     = $FF07;
  FORMTYPE_DOCUMENTWINDOW  = $FF08;
  FORMTYPE_NOTESWINDOW     = $FF09;
  FORMTYPE_TOOLBOXWINDOW   = $FF0A;
  FORMTYPE_QUERYWINDOW     = $FF0B;
  FORMTYPE_ELECTRONWINDOW  = $FF0C;
  FORMTYPE_CALCWINDOW      = $FF0D;
  FORMTYPE_HELPWINDOW      = $FF0E;
  FORMTYPE_MOLECULEWINDOW  = $FF0F;
  FORMTYPE_MOVIEWINDOW     = $FF10;
  FORMTYPE_COUNTRYWINDOW   = $FF11;

  DataWindow_WIDTH             = 384;
  DataWindow_HEIGHT            = 522;
  PTWindow_WIDTH               = 632;
  PTWindow_HEIGHT              = 638;
  GraphWindow_WIDTH            = 666;
  GraphWindow_HEIGHT           = 460;
  SearchWindow_WIDTH           = 620;
  SearchWindow_HEIGHT          = 482;
  AtomicStructureWindow_WIDTH  = 425;
  AtomicStructureWindow_HEIGHT = 483;
  AtomicRadiusWindow_WIDTH     = 417;
  AtomicRadiusWindow_HEIGHT    = 468;
  MediaWindow_WIDTH            = 634;
  MediaWindow_HEIGHT           = 651;
  DocumentWindow_WIDTH         = 620;
  DocumentWindow_HEIGHT        = 600;
  ToolboxWindow_WIDTH          = 672;
  ToolboxWindow_HEIGHT         = 522;
  NotesWindow_WIDTH            = 231;
  NotesWindow_HEIGHT           = 454;
  QueryWindow_WIDTH            = 400;
  QueryWindow_HEIGHT           = 500;
  ElectronWindow_WIDTH         = 571;
  ElectronWindow_HEIGHT        = 293;
  CalcWindow_WIDTH             = 615;
  CalcWindow_HEIGHT            = 418;
  HelpWindow_WIDTH             = 583;
  HelpWindow_HEIGHT            = 450;
  MovieWindow_WIDTH            = 504;
  MovieWindow_HEIGHT           = 497;
  MoleculeWindow_WIDTH         = 589;
  MoleculeWindow_HEIGHT        = 480;
  CountryWindow_WIDTH          = 589;
  CountryWindow_HEIGHT         = 480;

  UniversalGasConstant         : double = 8.314472;

  CountryCount = 138;

 var
  CurrentLanguage  : integer;
  RunFrom          : string;
  PTFormatSettings : TFormatSettings;
  UserSettings     : TPTESettings;
  Elements         : array[1..120] of TElementStruct;
  PropertiesMin    : array[1..36] of double;
  PropertiesMax    : array[1..36] of double;
  PropertiesCoeff  : array[1..36] of double;

  ilTWG        : TImageList;
  ilOrbitals   : TImageList;
  ilSpectraA, ilSpectraE : TImageList;

  ImageInfo   : array[1..96] of TStringList;
  ImageTitles : array[1..96] of TStringList;
  ImageText   : array[1..96] of TStringList;

  QDescriptions : TStringList;

  BiographyList : TStringList;
  DocumentList  : TStringList;
  GlossaryList  : TStringList;
  ConstantList  : TStringList;
  EquationList  : TStringList;
  PropertyText  : TStringList;

  SearchHistory : TStringList;

  TypeStore : array[1..118] of integer;

  Gradient      : array[0..255] of integer;

  ChemicalList : TObjectList;
  MoleculeList : TObjectList;

  MapData          : array[1..CountryCount] of TMapData;

  // == language data ==========================================================
  Lang_DataWindow      : array[1..34] of string;
  Lang_PTWindow        : array[1..41] of string;
  Lang_GraphWindow     : array[1..35] of string;
  Lang_SearchWindow    : array[1..25] of string;
  Lang_AtomicStructure : array[1..2] of string;
  Lang_AtomicRadius    : array[1..6] of string;
  Lang_MediaWindow     : array[1..6] of string;

  StateText        : array[1..3, 1..5] of string;
  // ===========================================================================

procedure InitializeStuff;
function SetupFormatSettings: boolean;
function GetLanguageSymbol(languageindex : integer): string;
procedure LoadFullTitles;
procedure LoadConstants;
function ExecuteFile(bob : THandle; const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
function StripFileExtension(s : string): string;
function LoadUnicodeFile(filename : string): WideString;

function GlossaryTitleFromSmallTitle(st : WideString): WideString;
function BiographyTitleFromSmallTitle(st : WideString): WideString;
function DocumentTitleFromSmallTitle(st : WideString): WideString;

function AfterSlash(s : string): string;
function BeforeSlash(s : string): string;
function ConvertValueToHTML(s : string): string;
function ConvertValueToSN(s : string): string;
function ConvertFormulaToHTML(formula : string): string;
function GetAtomicNumber(s : string): integer;
function PadString(ps : string; maxlength : integer; initialstring : string): string;
function GetUnits(propertyid : integer): string;
function GetPropertyName(propertyid : integer): string;

function WhatIsNext(s : char): integer;
function SymbolToAN(s : string): integer;
function FitToSizeL(s : string; padlength : integer): string;
function FitToSizeR(s : string; padlength : integer): string;
function IsNumber(s : string): boolean;
function IsLetter(s : char): boolean;
function IsUpperCase(s : char): boolean;
function IsLowerCase(s : char): boolean;
function RoundThis(xold, xnew : string): string;

function GetConstantName(s : string): string;
function GetConstantValue(s : string): string;
function GetConstantUnits(s : string): string;
function GetConstantUncertainty(s : string): string;

function AlphaListLookup(element : integer): integer;

function ColourToCountryIndex(colour : integer): integer;
function CountryCodeToName(code : string): string;

implementation

procedure InitializeStuff;
 begin
  BiographyList :=TStringList.Create;
  DocumentList  :=TStringList.Create;
  GlossaryList  :=TStringList.Create;
  ConstantList  :=TStringList.Create;
  EquationList  :=TStringList.Create;
  PropertyText  :=TStringList.Create;

  SearchHistory :=TStringList.Create;

  QDescriptions :=TStringList.Create;
end;

function SetupFormatSettings: boolean;
 begin
  GetLocaleFormatSettings(0, PTFormatSettings);

  //this is kind of magic, so leave it alone!
  PTFormatSettings.DecimalSeparator :='.';
  PTFormatSettings.ThousandSeparator :=',';
end;

function GetLanguageSymbol(languageindex : integer): string;
 begin
   Case languageindex of
    0 : result:='EN';
    1 : result:='NL';
    2 : result:='FR';
    3 : result:='DE';
    4 : result:='IT';
    5 : result:='PT';
    6 : result:='ES';
    7 : result:='SW';
    8 : result:='CZ';
    9 : result:='AR';    
  else
    result:='EN';
  end;
end;

function GlossaryTitleFromSmallTitle(st : WideString): WideString;
 var
  t,i : integer;
  s : WideString;

 begin
  st:=st+'/';
  s:='';

  for t:=0 to GlossaryList.Count-1 do begin
    if pos(st, GlossaryList[t])=1 then begin
      i:=Pos('/', GlossaryList[t]);
      s:=Copy(GlossaryList[t], i+1, Length(GlossaryList[t])-i);
    end;
  end;

  Result:=s;
end;

function BiographyTitleFromSmallTitle(st : WideString): WideString;
 var
  t,i : integer;
  s : string;

 begin
  st:=st+'/';
  s:='';

  for t:=0 to BiographyList.Count-1 do begin
    if pos(st, BiographyList[t])=1 then begin
      i:=Pos('/', BiographyList[t]);
      s:=Copy(BiographyList[t], i+1, Length(BiographyList[t])-i);
    end;
  end;

  Result:=s;
end;

function DocumentTitleFromSmallTitle(st : WideString): WideString;
 var
  t,i : integer;
  s : string;

 begin
  st:=st+'/';
  s:='';

  for t:=0 to DocumentList.Count-1 do begin
    if pos(st, DocumentList[t])=1 then begin
      i:=Pos('/', DocumentList[t]);
      s:=Copy(DocumentList[t], i+1, Length(DocumentList[t])-i);
    end;
  end;

  Result:=s;
end;

procedure LoadFullTitles;
 var
  temps : WideString;
  ws,ws2 : WideString;
  t,ce : integer;

 begin
  FileMode:=fmOpenRead;

  ws:=LoadUnicodeFile(RunFrom+'data\'+UserSettings.LanguageSymbol+'\language\glossarytext.txt');

  ws2:='';

  for t:=1 to length(ws) do begin
    if ws[t]=':' then begin
      GlossaryList.Add(ws2);

      ws2:='';
    end
    else begin
      if ws2='' then
        ws2:=WideUpperCase(ws[t])   // uppercases the first character
      else
        ws2:=ws2+ws[t];
    end;
  end;

  // ==================================================================

  ws:=LoadUnicodeFile(RunFrom+'data\'+UserSettings.LanguageSymbol+'\language\biographytext.txt');

  ws2:='';

  for t:=1 to length(ws) do begin
    if ws[t]=':' then begin
      BiographyList.Add(ws2);

      ws2:='';
    end
    else begin
      if ws2='' then
        ws2:=WideUpperCase(ws[t])   // uppercases the first character
      else
        ws2:=ws2+ws[t];
    end;
  end;

  // ==================================================================

  ws:=LoadUnicodeFile(RunFrom+'data\'+UserSettings.LanguageSymbol+'\language\documenttext.txt');

  ws2:='';

  for t:=1 to length(ws) do begin
    if ws[t]=':' then begin
      DocumentList.Add(ws2);

      ws2:='';
    end
    else begin
      if ws2='' then
        ws2:=WideUpperCase(ws[t])   // uppercases the first character
      else
        ws2:=ws2+ws[t];
    end;
  end;

  // ===================================================================
  // Process Media Stuff
  // ===================================================================

  ws:=LoadUnicodeFile(RunFrom+'data\'+UserSettings.LanguageSymbol+'\language\imagetext.txt');

  temps:='';
  ce:=0;
  for t:=1 to length(ws) do begin
    if ws[t]='/' then begin
      ce:=StrToInt(temps);
      temps:='';
      ImageInfo[ce]  :=TStringList.Create;
      ImageTitles[ce]:=TStringList.Create;
      ImageText[ce]  :=TStringList.Create;
    end
    else if ws[t]=':' then begin
      ImageInfo[ce].Add(temps);
      temps:='';
    end
    else if ws[t]='*' then begin
      ImageTitles[ce].Add(temps);
      temps:='';
    end
    else if ws[t]='@' then begin
      ImageText[ce].Add(temps);
      temps:='';
    end
    else
      temps:=temps+ws[t];
  end;
end;

procedure LoadConstants;
 var
  tf : File of byte;
  s : string;
  x : byte;

 begin
  ConstantList:=TStringList.Create;

  AssignFile(tf, RunFrom+'data\'+UserSettings.LanguageSymbol+'\language\referencetext.txt');
  Reset(tf);

  while not(eof(tf)) do begin
    read(tf, x);
    if x=ord('@') then begin
      s[1]:=UpCase(s[1]);
      ConstantList.Add(s);

      s:='';
    end
    else
      s:=s+Chr(x);
  end;

  CloseFile(tf);
end;

function ExecuteFile(bob : THandle; const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
 var
  zFileName, zParams, zDir: array[0..254] of Char;

 begin
  Result := ShellExecute(bob, nil, StrPCopy(zFileName, FileName), StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function AfterSlash(s : string): string;
 var
  idx : integer;

 begin
  idx:=pos('/', s);

  Result:=copy(s, idx+1, length(s)-idx);
end;

function BeforeSlash(s : string): string;
 var
  idx : integer;

 begin
  idx:=pos('/', s);

  Result:=copy(s, 1, idx-1);
end;

function ConvertValueToHTML(s : string): string;
 var
  ns : string;
  t : integer;
  insup : boolean;

 begin
  ns:='';
  insup:=False;

  for t:=1 to length(s) do begin
    if s[t]='^' then begin
      ns:=ns+'<sup>';
      insup:=true;
    end
    else if s[t]=' ' then begin
      if insup then begin
        ns:=ns+'</sup>';
        insup:=false;
      end;

      ns:=ns+' ';
    end
    else
      ns:=ns+s[t];
  end;

  if insup then
    ns:=ns+'</sup>';

  Result:=ns;
end;

// convert to scientific notation
function ConvertValueToSN(s : string): string;
 var
  i : integer;
  ts : string;

 begin
  i:=Pos(' x 10^', s);

  if i<>0 then begin
    ts:='';

    ts:=Copy(s, 1, i-1)+'e';

    i:=i+6;
    while s[i]<>' ' do begin
      ts:=ts+s[i];

      inc(i);
    end;

  end
  else begin
    i:=1;
    ts:='';

    while s[i]<>' ' do begin
      ts:=ts+s[i];

      inc(i);
    end;
  end;

  Result:=ts;
end;

function StripFileExtension(s : string): string;
 var
  ts : string;
  i,x : integer;

 begin
  i:=Pos('.', s);
  ts:=s;

  if i<>0 then begin
    ts:='';

    for x:=1 to i-1 do
      ts:=ts+s[x];
  end;

  Result:=ts;
end;

function LoadUnicodeFile(filename : string): WideString;
 var
  fs: TFileStream;
  w: Word;
  ws: WideString;
  S: string;
  i: Integer;

 begin
  fs := TFileStream.Create(filename, fmOpenRead);

  {stream can contain unicode characters - we must check before parse}
  fs.Read(w, SizeOf(w));
  case w of
      $FEFF, {UTF-16 little endian}
      $FFFE: {UTF-16 big  endian}
             begin
               if (fs.Size > fs.Position) then
               begin
                 i := fs.Size - fs.Position;
                 SetLength(ws, i div 2);
                 fs.Read(ws[1], i);
                 if (w = $FFFE) then
                 begin
                   for i := 1 to Length(ws) do
                     ws[i] := WideChar(Swap(Word(ws[i])));
                 end;
               end;
             end;
    else
      {restore position}
      fs.Seek(-SizeOf(w), soFromCurrent);
      SetString(S, nil, 4);
      fs.Read(Pointer(S)^, 4);
      ws := S
    end;

  {close file}
  fs.Free;

  Result:=ws;
end;

function PadString(ps : string; maxlength : integer; initialstring : string): string;
 var
  t : integer;

 begin
  if length(initialstring)>=maxlength then
    Result:=initialstring
  else begin
    for t:=1 to maxlength-length(initialstring) do
      initialstring:=ps+initialstring;

    Result:=initialstring;      
  end;
end;

function GetAtomicNumber(s : string): integer;
 var
  t,i : integer;

 begin
  if (Ord(s[1])>=48) and (Ord(s[1])<=57) then begin
    Result:=StrToInt(s);
  end
  else begin
    i:=-1;

    s:=UpperCase(s);

    for t:=1 to 118 do begin
      if UpperCase(Elements[t].Name)=s then
        i:=t;
    end;

    if i=-1 then begin
      for t:=1 to 118 do begin
        if UpperCase(ElementSymbol[t])=s then
          i:=t;
      end;
    end;

    Result:=i;
  end;
end;

function WhatIsNext(s : char): integer;
 var
  idx : integer;

 begin
  idx:=0;

  if ((Ord(s)>=65) and (Ord(s)<=90)) then
    idx:=XUPPERCASE
  else if ((Ord(s)>=97) and (Ord(s)<=122)) then
    idx:=XLOWERCASE
  else if ((Ord(s)>=48) and (Ord(s)<=57)) then
    idx:=XNUMERIC;

  Result:=idx;
end;

function SymbolToAN(s : string): integer;
 var
  idx,i : integer;

 begin
  i:=1;
  idx:=0;

  while (i<=118) and (idx=0) do begin
    if ElementSymbol[i]=s then idx:=i;

    inc(i);
  end;

  Result:=idx;
end;

function FitToSizeL(s : string; padlength : integer): string;
 var
  t : integer;
  ss : string;

 begin
  ss:='';
  for t:=length(s)+1 to padlength do
    ss:=ss+' ';

  Result:=ss+s;
end;

function FitToSizeR(s : string; padlength : integer): string;
 var
  t : integer;

 begin
  for t:=length(s)+1 to padlength do
    s:=s+' ';

  Result:=s;
end;

function IsNumber(s : string): boolean;
 var
  t : integer;

 begin
  Result:=True;

  for t:=1 to length(s) do begin
    if ((Ord(s[t])<48) or (Ord(s[t])>57)) then
      Result:=False;
  end;
end;

function IsLetter(s : char): boolean;
 begin
  if ((Ord(s)>=65) and (Ord(s)<=90)) or
     ((Ord(s)>=97) and (Ord(s)<=122)) then
    Result:=True
  else
    Result:=False;
end;

function IsUpperCase(s : char): boolean;
 begin
  if ((Ord(s)>=65) and (Ord(s)<=90)) then
    Result:=True
  else
    Result:=False;
end;

function IsLowerCase(s : char): boolean;
 begin
  if ((Ord(s)>=97) and (Ord(s)<=122)) then
    Result:=True
  else
    Result:=False;
end;

function GetConstantName(s : string): string;
  var
  i : integer;

  begin
   i:=Pos('*', s);
   Result:=Copy(s, 1, i-1);
 end;

function GetConstantValue(s : string): string;
 var
  i,t : integer;

 begin
  i:=Pos(':', s);
  t:=Pos(';', s);

  Result:=Copy(s, i+1, t-(i+1));
end;

function GetConstantUnits(s : string): string;
 var
  i,t : integer;

 begin
  i:=Pos(';', s);
  t:=Pos('#', s);  

  Result:=Copy(s, i+1, t-(i+1));
end;

function GetConstantUncertainty(s : string): string;
 var
  i : integer;

 begin
  i:=Pos('#', s);

  Result:=Copy(s, i+1, length(s)-i);
end;

function ConvertFormulaToHTML(formula : string): string;
 var
  t : integer;
  subon, supon : boolean;
  s : string;
  cxc : char;

 begin
  s:='';
  subon:=False;
  supon:=False;

  for t:=1 to length(formula) do begin
    cxc:=formula[t];

    if IsLetter(cxc) then begin
      if subon then begin
        s:=s+'</sub>';
        subon:=False;
      end;

      s:=s+cxc;
    end
    else if IsNumber(cxc) then begin
      if (subon=False) and (supon=False) and (formula[t-1]<>'.') then begin
        s:=s+'<sub>';
        subon:=True;
      end;

      s:=s+cxc;
    end
    else if (cxc='(') or (cxc=')') then begin
      if subon then begin
        s:=s+'</sub>';
        subon:=False;
      end;

      s:=s+cxc;
    end
    else if (cxc='^') then begin
      if subon then begin
        s:=s+'</sub>';
        subon:=False;
      end;

      supon:=True;

      s:=s+'<sup>';
    end
    else if (cxc='.') then begin
      if subon then begin
        s:=s+'</sub>';
        subon:=False;
      end;

      s:=s+'.';
    end    
    else
      s:=s+cxc;
  end;

  if supon then
    s:=s+'</sup>';

  if subon then
    s:=s+'</sub>';    

  Result:=s;  
end;

function GetUnits(propertyid : integer): string;
 begin
  Result:='UNKNOWN!';

  case propertyid of
    1,2           : Result:='K';
    3             : Result:='g/mol';
    4             : Result:='J/mol/K';
    5             : Result:='W/m/K';
    6             : Result:='um/m/K';
    7,26          : Result:='g/cm^3';
    8             : Result:='10^6/cm/ohm';
    9,23,27,28    : Result:='';
    10,11,29      : Result:='kJ/mol';
    12..14        : Result:='ppm';
    15,16         : Result:='ppb';
    17            : Result:='ohm/m';
    18..20        : Result:='GPa';
    21,22         : Result:='MPa';
    24            : Result:='m/s';
    25            : Result:='year';
    30            : Result:='-eV';
    31..36        : Result:='pm';
  end;
end;

function GetPropertyName(propertyid : integer): string;
 begin
  Result:='UNKNOWN!';

  case propertyid of
    1  : Result:=PropertyText[9];    // boiling point
    2  : Result:=PropertyText[18];   // melting point
    3  : Result:=PropertyText[5];    // atomic mass
    4  : Result:=PropertyText[17];   // heat capacity
    5  : Result:=PropertyText[24];   // thermal conductivity
    6  : Result:=PropertyText[25];   // thermal expansion
    7  : Result:=PropertyText[11];   // density
    8  : Result:=PropertyText[13];   // electrical conductivity
    9  : Result:=PropertyText[14];   // electronegativity
    10 : Result:=PropertyText[15];   // enthalpy of fusion
    11 : Result:=PropertyText[16];   // enthalpy of vaporisation
    12 : Result:=PropertyText[2];    // abundance universe
    13 : Result:=PropertyText[1];    // abundance sun
    14 : Result:=PropertyText[0];    // abundance earths crust
    15 : Result:=PropertyText[29];   // abundance human weight
    16 : Result:=PropertyText[3];    // abundance human atoms
    17 : Result:=PropertyText[30];   // electrical resistivity
    18 : Result:=PropertyText[10];   // bulk modulus
    19 : Result:=PropertyText[21];   // shear modulus
    20 : Result:=PropertyText[27];   // youngs modulus
    21 : Result:=PropertyText[8];    // brinell hardness
    22 : Result:=PropertyText[26];   // vickers hardness
    23 : Result:=PropertyText[20];   // poisson ratio
    24 : Result:=PropertyText[22];   // speed of sound
    25 : Result:=PropertyText[28];   // discovery date
    26 : Result:=PropertyText[7];    //atomic volume
    27 : Result:=PropertyText[36];   // mass mag sus
    28 : Result:=PropertyText[37];   // molar mag susc
    29 : Result:=PropertyText[38];   // enthalpy of atomization
    30 : Result:=PropertyText[39];   // valence electron potential
    31 : Result:=PropertyText[6];    // atomic radius
    32 : Result:=PropertyText[31];   // ar bohr
    33 : Result:=PropertyText[32];   // ar covalent
    34 : Result:=PropertyText[33];   // ar van der waals
    35 : Result:=PropertyText[34];   // ar triple
    36 : Result:=PropertyText[35];   // ar metallic
  end;
end;

function AlphaListLookup(element : integer): integer;
 var
  t: integer;

 begin
  Result:=1;

  for t:=1 to 118 do begin
    if element=ElementsAlphabetical[CurrentLanguage][t] then
      Result:=t;
  end;          
end;

function RoundThis(xold, xnew : string): string;
 var
  i : integer;
  z : integer;

 begin
  i:=Pos('.', xnew);
  if i<>0 then begin
    z:=-(length(xnew)-i);
    Result:=FloatToStr(RoundTo(StrToFloat(xold, PTFormatSettings), z));
  end
  else
    Result:=xnew;
end;

function ColourToCountryIndex(colour : integer): integer;
 var
  idx, t : integer;

 begin
  idx:=-1;
  for t:=1 to CountryCount do begin
    if MapData[t].Colour=colour then
      idx:=t;
  end;

  Result:=idx;
end;

function CountryCodeToName(code : string): string;
 var
  t : integer;

 begin
  Result:='UNKNOWN!';

  code:=UpperCase(code);
  
  for t:=1 to CountryCount do begin
    if MapData[t].Code=code then
      Result:=MapData[t].Name;
  end;
end;

end.

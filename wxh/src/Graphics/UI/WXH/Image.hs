--------------------------------------------------------------------------------
{-| Module      :  Image
    Copyright   :  (c) Daan Leijen 2003
    License     :  wxWindows

    Maintainer  :  daan@cs.uu.nl
    Stability   :  provisional
    Portability :  portable
-}
--------------------------------------------------------------------------------
module Graphics.UI.WXH.Image
    ( -- * Images
      frameSetIconFromFile
    , bitmapCreateFromFile
      -- * Helpers
    , imageTypeFromExtension
    , imageTypeFromFileName
    ) where

import Char( toLower )
import Graphics.UI.WXH.WxcTypes
import Graphics.UI.WXH.WxcDefs
import Graphics.UI.WXH.WxcClasses
import Graphics.UI.WXH.Types


-- | Set the icon of a frame.
frameSetIconFromFile :: Frame a -> FilePath -> IO ()
frameSetIconFromFile f fname
  = bracket (iconCreateLoad fname (imageTypeFromFileName fname) sizeNull)
            (iconDelete)
            (frameSetIcon f)

-- | Load a bitmap from an image file (gif, jpg, png, etc.) Raises an IO exception
-- when the file is not found or if the format is not supported.
bitmapCreateFromFile :: FilePath -> IO (Bitmap ())
bitmapCreateFromFile fname
  = do bm <- bitmapCreateLoad fname (imageTypeFromFileName fname)
       ok <- bitmapOk bm
       if (ok)
        then return bm
        else do bitmapDelete bm
                ioError (userError ("unable to load image: " ++ show fname))

-- | Get an image type from a file name.
imageTypeFromFileName :: String -> BitFlag
imageTypeFromFileName fname
  = imageTypeFromExtension (map toLower (reverse (takeWhile (/= '.') (reverse fname))))

-- | Get an image type from a file extension.
imageTypeFromExtension :: String -> BitFlag
imageTypeFromExtension ext
  = case ext of
      "jpg"   -> wxBITMAP_TYPE_JPEG
      "jpeg"  -> wxBITMAP_TYPE_JPEG
      "gif"   -> wxBITMAP_TYPE_GIF
      "bmp"   -> wxBITMAP_TYPE_BMP
      "png"   -> wxBITMAP_TYPE_PNG
      "xpm"   -> wxBITMAP_TYPE_XPM
      "xbm"   -> wxBITMAP_TYPE_XBM
      "pcx"   -> wxBITMAP_TYPE_PCX
      "ico"   -> wxBITMAP_TYPE_ICO
      "tif"   -> wxBITMAP_TYPE_TIF
      "tiff"  -> wxBITMAP_TYPE_TIF
      "pnm"   -> wxBITMAP_TYPE_PNM
      "pict"  -> wxBITMAP_TYPE_PICT
      "icon"  -> wxBITMAP_TYPE_ICON
      other   -> wxBITMAP_TYPE_ANY
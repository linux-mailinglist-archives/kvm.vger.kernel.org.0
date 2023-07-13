Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E15752466
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjGMN47 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Jul 2023 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjGMN46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 09:56:58 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD829273C;
        Thu, 13 Jul 2023 06:56:30 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1qJwo0-003uyK-7j; Thu, 13 Jul 2023 15:56:28 +0200
Received: from p57bd9f0d.dip0.t-ipconnect.de ([87.189.159.13] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1qJwnz-002qWA-Vd; Thu, 13 Jul 2023 15:56:28 +0200
Message-ID: <6d04a1b87a9820d8ae23191092665f2dcb17ce19.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 08/18] sh: Assign FB_MODE_IS_UNKNOWN to struct
 fb_videomode.flag
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Thomas Zimmermann <tzimmermann@suse.de>, deller@gmx.de,
        javierm@redhat.com
Cc:     linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Date:   Thu, 13 Jul 2023 15:56:26 +0200
In-Reply-To: <4622810f8bceb66f212fa09d34b10f0d2d71a35d.camel@physik.fu-berlin.de>
References: <20230713130338.31086-1-tzimmermann@suse.de>
         <20230713130338.31086-9-tzimmermann@suse.de>
         <4622810f8bceb66f212fa09d34b10f0d2d71a35d.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.159.13
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas!

On Thu, 2023-07-13 at 15:53 +0200, John Paul Adrian Glaubitz wrote:
> On Thu, 2023-07-13 at 14:58 +0200, Thomas Zimmermann wrote:
> > Assign FB_MODE_IS_UNKNOWN to sh7763fb_videomode.flag instead of
> > FBINFO_FLAG_DEFAULT. Both are 0, so the stored value does not change.
> > 
> > FBINFO_FLAG_DEFAULT is a flag for a framebuffer in struct fb_info.
> > Flags for videomodes are prefixed with FB_MODE_.
> > 
> > v2:
> > 	* assign FB_MODE_IS_UNKNOWN (Adrian)
> > 
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Rich Felker <dalias@libc.org>
> > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > ---
> >  arch/sh/boards/mach-sh7763rdp/setup.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/sh/boards/mach-sh7763rdp/setup.c b/arch/sh/boards/mach-sh7763rdp/setup.c
> > index 97e715e4e9b3..e25193001ea0 100644
> > --- a/arch/sh/boards/mach-sh7763rdp/setup.c
> > +++ b/arch/sh/boards/mach-sh7763rdp/setup.c
> > @@ -119,7 +119,7 @@ static struct fb_videomode sh7763fb_videomode = {
> >  	.vsync_len = 1,
> >  	.sync = 0,
> >  	.vmode = FB_VMODE_NONINTERLACED,
> > -	.flag = FBINFO_FLAG_DEFAULT,
> > +	.flag = FB_MODE_IS_UNKNOWN,
> >  };
> >  
> >  static struct sh7760fb_platdata sh7763fb_def_pdata = {
> 
> Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

Ah, just one tiny request: Could you change the subject to include the
board name, i.e.:

	sh: mach-sh7763rdp: Assign FB_MODE_IS_UNKNOWN to struct fb_videomode.flag

?

I wasn't paying close attention to the path of the file being changed when
I first looked at your patch. Sorry for that.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

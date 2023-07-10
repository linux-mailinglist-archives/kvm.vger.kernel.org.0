Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237AC74D7F8
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjGJNnM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 10 Jul 2023 09:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjGJNm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 09:42:56 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F163CBA;
        Mon, 10 Jul 2023 06:42:54 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1qIrA9-000zai-Vg; Mon, 10 Jul 2023 15:42:50 +0200
Received: from p57bd95f7.dip0.t-ipconnect.de ([87.189.149.247] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1qIrA9-001iVF-NK; Mon, 10 Jul 2023 15:42:49 +0200
Message-ID: <0a47ed93fe90a77180533f8c2e42e402827e8f1c.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 08/17] arch/sh: Do not assign FBINFO_FLAG_DEFAULT to
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
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Date:   Mon, 10 Jul 2023 15:42:48 +0200
In-Reply-To: <20230710130113.14563-9-tzimmermann@suse.de>
References: <20230710130113.14563-1-tzimmermann@suse.de>
         <20230710130113.14563-9-tzimmermann@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.149.247
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

On Mon, 2023-07-10 at 14:50 +0200, Thomas Zimmermann wrote:
> FBINFO_FLAG_DEFAULT is a flag for a framebuffer in struct fb_info.
> Flags for videomodes are prefixed with FB_MODE_. FBINFO_FLAG_DEFAULT
> is 0 and the static declaration already clears the memory area of
> sh7763fb_videomode. So remove the assignment.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> ---
>  arch/sh/boards/mach-sh7763rdp/setup.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/sh/boards/mach-sh7763rdp/setup.c b/arch/sh/boards/mach-sh7763rdp/setup.c
> index 97e715e4e9b3..345f2b76c85a 100644
> --- a/arch/sh/boards/mach-sh7763rdp/setup.c
> +++ b/arch/sh/boards/mach-sh7763rdp/setup.c
> @@ -119,7 +119,6 @@ static struct fb_videomode sh7763fb_videomode = {
>  	.vsync_len = 1,
>  	.sync = 0,
>  	.vmode = FB_VMODE_NONINTERLACED,
> -	.flag = FBINFO_FLAG_DEFAULT,
>  };
>  
>  static struct sh7760fb_platdata sh7763fb_def_pdata = {

I would argue that the current code is more readable that your proposed change.

I agree that it's a no-op, but code is not just about functionality but also
readability, isn't it?

Also, I prefer "sh:" as the architecture prefix, not "arch/sh:".

Thanks,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

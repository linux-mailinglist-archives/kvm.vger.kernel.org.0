Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FBA74F454
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjGKQE7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 11 Jul 2023 12:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGKQE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:04:58 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936F9B;
        Tue, 11 Jul 2023 09:04:57 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3a3b7fafd61so4811049b6e.2;
        Tue, 11 Jul 2023 09:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689091496; x=1691683496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7zt5pO69xVTkx3WPA+RT/byFcn7lDWoK0rY+7VhmSY=;
        b=iswsFtqDQPyT+TBcWW9QuGDGaoW9J/WE0dqbVdW2lfs12vS3rfmijgYd7SLjJaAZof
         XrOA3Ce8j04eGTsHS0Su3Ums7ze/i5HjohDwArrnndmRTVthDeIbZwyx3B8m/WhvRyiH
         +WD6q+Yw6Wdhpyk6f4NdBf53b4KwSZZW79ntkAzhvTfxY5DevdIf4OYcS4K8KJ5ImYAK
         d0yLaq6Wr9s0xPEsx1ibL8amzrO2DVIg+c0UdkMkjfL/vv1G+grw1dffrkMy2k7htxrv
         mKKRbhVCl01GHUU8Gy1vOOWvrdulGqP6pNvwrHuOSdfo7NCTPzVy6tbmPBxui2bayy5Z
         QlbQ==
X-Gm-Message-State: ABy/qLaK8gquVnCuVL57J8lg01orhIsLWN3Ym5o+LUzt1oQh62+gFMGt
        /pX0cEOryUFqmyZQJa8MIV1pi+WPYs8PTg==
X-Google-Smtp-Source: APBJJlELsv1YirHZDxBK1svirqsvA2URB3xoL7T7MpgJRuIfE7H6LFZcm35pIOmp1dGUcJI/gbeLwg==
X-Received: by 2002:a05:6808:190b:b0:3a3:aedd:6b21 with SMTP id bf11-20020a056808190b00b003a3aedd6b21mr21095471oib.39.1689091496363;
        Tue, 11 Jul 2023 09:04:56 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id u13-20020a056808000d00b003a371c611f6sm1005829oic.18.2023.07.11.09.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 09:04:56 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3a04e5baffcso4806589b6e.3;
        Tue, 11 Jul 2023 09:04:56 -0700 (PDT)
X-Received: by 2002:a05:6358:4198:b0:132:7a2e:87bc with SMTP id
 w24-20020a056358419800b001327a2e87bcmr13654687rwc.5.1689091495810; Tue, 11
 Jul 2023 09:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230710130113.14563-1-tzimmermann@suse.de> <20230710171903.GA14712@ravnborg.org>
 <ab92f8d9-36ab-06bc-b85b-d52b7a1bfe9a@suse.de> <20230711144744.GA117276@ravnborg.org>
 <bf439387-6b13-0fd9-f61b-1a5cbf731187@gmx.de>
In-Reply-To: <bf439387-6b13-0fd9-f61b-1a5cbf731187@gmx.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jul 2023 18:04:41 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXnTDK6uZNhNR=NFTiy4F+2nLJd1E47vDoXUV3zFSCGOA@mail.gmail.com>
Message-ID: <CAMuHMdXnTDK6uZNhNR=NFTiy4F+2nLJd1E47vDoXUV3zFSCGOA@mail.gmail.com>
Subject: Re: [PATCH 00/17] fbdev: Remove FBINFO_DEFAULT and
 FBINFO_FLAG_DEFAULT flags
To:     Helge Deller <deller@gmx.de>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-geode@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-nvidia@lists.surfsouth.com, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Helge,

On Tue, Jul 11, 2023 at 5:26 PM Helge Deller <deller@gmx.de> wrote:
> On 7/11/23 16:47, Sam Ravnborg wrote:
> > On Tue, Jul 11, 2023 at 08:24:40AM +0200, Thomas Zimmermann wrote:
> >> Am 10.07.23 um 19:19 schrieb Sam Ravnborg:
> >>> On Mon, Jul 10, 2023 at 02:50:04PM +0200, Thomas Zimmermann wrote:
> >>>> Remove the unused flags FBINFO_DEFAULT and FBINFO_FLAG_DEFAULT from
> >>>> fbdev and drivers, as briefly discussed at [1]. Both flags were maybe
> >>>> useful when fbdev had special handling for driver modules. With
> >>>> commit 376b3ff54c9a ("fbdev: Nuke FBINFO_MODULE"), they are both 0
> >>>> and have no further effect.
> >>>>
> >>>> Patches 1 to 7 remove FBINFO_DEFAULT from drivers. Patches 2 to 5
> >>>> split this by the way the fb_info struct is being allocated. All flags
> >>>> are cleared to zero during the allocation.
> >>>>
> >>>> Patches 8 to 16 do the same for FBINFO_FLAG_DEFAULT. Patch 8 fixes
> >>>> an actual bug in how arch/sh uses the tokne for struct fb_videomode,
> >>>> which is unrelated.
> >>>>
> >>>> Patch 17 removes both flag constants from <linux/fb.h>
> >>>
> >>> We have a few more flags that are unused - should they be nuked too?
> >>> FBINFO_HWACCEL_FILLRECT
> >>> FBINFO_HWACCEL_ROTATE
> >>> FBINFO_HWACCEL_XPAN
> >>
> >> It seems those are there for completeness. Nothing sets _ROTATE,
>
> I think some fbdev drivers had hardware acceleration for ROTATE in the
> past. HWACCEL_XPAN is still in some drivers.
>
> >> the others are simply never checked. According to the comments,
> >> some are required, some are optional. I don't know what that
> >> means.
>
> I think it's OK if you remove those flags which aren't used anywhere,
> e.g. FBINFO_HWACCEL_ROTATE.

Indeed.

> >> IIRC there were complains about performance when Daniel tried to remove
> >> fbcon acceleration, so not all _HWACCEL_ flags are unneeded.
>
> Correct. I think COPYAREA and FILLRECT are the bare minimum to accelerate
> fbcon, IMAGEBLIT is for showing the tux penguin (?),
> XPAN/YPAN and YWRAP for some hardware screen panning needed by some drivers
> (not sure if this is still used as I don't have such hardware, Geert?).

Yes, they are used.  Anything that is handled in drivers/video/fbdev/core/
is used:

$ git grep  HWACCEL_ -- drivers/video/fbdev/core/
drivers/video/fbdev/core/fbcon.c:       if ((info->flags &
FBINFO_HWACCEL_COPYAREA) &&
drivers/video/fbdev/core/fbcon.c:           !(info->flags &
FBINFO_HWACCEL_DISABLED))
drivers/video/fbdev/core/fbcon.c:       int good_pan = (cap &
FBINFO_HWACCEL_YPAN) &&
drivers/video/fbdev/core/fbcon.c:       int good_wrap = (cap &
FBINFO_HWACCEL_YWRAP) &&
drivers/video/fbdev/core/fbcon.c:       int fast_copyarea = (cap &
FBINFO_HWACCEL_COPYAREA) &&
drivers/video/fbdev/core/fbcon.c:               !(cap &
FBINFO_HWACCEL_DISABLED);
drivers/video/fbdev/core/fbcon.c:       int fast_imageblit = (cap &
FBINFO_HWACCEL_IMAGEBLIT) &&
drivers/video/fbdev/core/fbcon.c:               !(cap &
FBINFO_HWACCEL_DISABLED);

BTW, I'm surprised FBINFO_HWACCEL_FILLRECT is not handled.
But looking at the full history, it never was...

> >> Leaving them in for reference/completeness might be an option; or not. I
> >> have no strong feelings about those flags.
>
> I'd say drop FBINFO_HWACCEL_ROTATE at least ?

Agreed.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

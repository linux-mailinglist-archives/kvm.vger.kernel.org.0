Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260F275375E
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbjGNKEW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jul 2023 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjGNKEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:04:21 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127E1989;
        Fri, 14 Jul 2023 03:04:20 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1b730eb017bso1347303fac.1;
        Fri, 14 Jul 2023 03:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689329059; x=1691921059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbFWyufa2I/dKrp5bYUBMB1ESShCcC04UZ0ziSB/4oc=;
        b=WfuT62NAV/KEOKYAM9BHIMuHz6YRXnm7xoKdh+sZy9BOPjP8rgufGPlDP3wS4WSFx4
         h7WbwjM0kI1vmGswHdrRNY5eqObFdrhpyeePmwzSkCxyCGkNNK5apfe0Z3voHsdHJJT7
         tb6Wg0LNGs25QAQAkX1XSj9Lv613AXcD2pv8ijii7HM/KEiU5vWBLmIpKnDt7TvPxi9j
         jSRmulr3xPLJCqwO+J5vysW5lDYIzj+df7ZTVf41ctwTsFcqgHpieUKAnTIIAuUgzyEC
         qS4C0mddn/PtCJYOIsVReiT5jNn1mRz1CkNrgm0WViRn1vCY19+z6c3ymeQehI9SFa8v
         1S1A==
X-Gm-Message-State: ABy/qLasugcuzUO4sK3pOfm7xGhSQJ3QJrvNl2FH27Eqqm1CcAc7M6Zu
        vOT1Owh1jKH/iaOREVbj2jd+9zh/u3Ruvg==
X-Google-Smtp-Source: APBJJlHiD3v2u63KmBepFncsWakaeIp+xHYTm685RSMvB9XoC7cFtMO4232Sujt30xadpzbv8+Rh9w==
X-Received: by 2002:a05:6870:b48b:b0:1b0:7078:58ad with SMTP id y11-20020a056870b48b00b001b0707858admr5618059oap.38.1689329059529;
        Fri, 14 Jul 2023 03:04:19 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id t2-20020a056870e74200b001a697e75260sm3776688oak.58.2023.07.14.03.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 03:04:18 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6b711c3ad1fso1399321a34.0;
        Fri, 14 Jul 2023 03:04:18 -0700 (PDT)
X-Received: by 2002:a05:6358:591d:b0:135:43da:b16d with SMTP id
 g29-20020a056358591d00b0013543dab16dmr4868202rwf.11.1689329058168; Fri, 14
 Jul 2023 03:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230714075155.5686-1-tzimmermann@suse.de>
In-Reply-To: <20230714075155.5686-1-tzimmermann@suse.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Jul 2023 12:04:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWoeyJPAgPgFi545SJFcaVCgZi1-zW2N5cBeU9BnHgo1w@mail.gmail.com>
Message-ID: <CAMuHMdWoeyJPAgPgFi545SJFcaVCgZi1-zW2N5cBeU9BnHgo1w@mail.gmail.com>
Subject: Re: [PATCH v3 00/18] fbdev: Remove FBINFO_DEFAULT and
 FBINFO_FLAG_DEFAULT flags
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Fri, Jul 14, 2023 at 9:53 AM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Remove the unused flags FBINFO_DEFAULT and FBINFO_FLAG_DEFAULT from
> fbdev and drivers, as briefly discussed at [1]. Both flags were maybe
> useful when fbdev had special handling for driver modules. With
> commit 376b3ff54c9a ("fbdev: Nuke FBINFO_MODULE"), they are both 0
> and have no further effect.
>
> Patches 1 to 7 remove FBINFO_DEFAULT from drivers. Patches 2 to 5
> split this by the way the fb_info struct is being allocated. All flags
> are cleared to zero during the allocation.
>
> Patches 8 to 16 do the same for FBINFO_FLAG_DEFAULT. Patch 8 fixes
> an actual bug in how arch/sh uses the token for struct fb_videomode,
> which is unrelated.
>
> Patch 17 removes both flag constants from <linux/fb.h> and patch 18
> documents the zero'ed memory returned by framebuffer_alloc().
>
> v3:
>         * sh: include board name in commit message (Adrian)
>         * docs: reword text (Miguel)

Thanks for the update!

>   fbdev: Remove flag FBINFO_DEFAULT from fbdev drivers
>   fbdev: Remove flag FBINFO_DEFAULT from fbdev drivers
>   fbdev: Remove flag FBINFO_DEFAULT from fbdev drivers
>   fbdev: Remove flag FBINFO_DEFAULT from fbdev drivers

Four patches with the exact same one-line summary. Please make them
unique.

>   fbdev: Remove flag FBINFO_FLAG_DEFAULT from fbdev drivers
>   fbdev: Remove flag FBINFO_FLAG_DEFAULT from fbdev drivers

Two patches with the exact same one-line summary. Please make them
unique.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

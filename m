Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249BD52EC7E
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349482AbiETMqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348109AbiETMqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:46:36 -0400
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E75C84F;
        Fri, 20 May 2022 05:46:35 -0700 (PDT)
Received: by mail-qk1-f178.google.com with SMTP id g207so3970013qke.7;
        Fri, 20 May 2022 05:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhZYflED6/DiNr1feOC9OhkU49iweDam4jS4WznrIsk=;
        b=P3H251hbfEKCS0STYhh+ttBN6k4JmCVqAIgJw2sY6OCa/0DUJ8nnJvDHC0OMbW5njm
         X32Why/FWk49NtmkhlOE/5/vqT3kuE6mcXD7QY9xafdbxyWvySw8uD3zS3v2olp7uAS6
         j0IarfLosYyy803yAOymeMM5cblvWe8InrjXH7ugU2lEDXkhASGKcg78A6DGHkPcXgzj
         D/N8WUK9EkOsRFwQivqRztuGL7H75e4wpRL3WIVeyV5HvpXG5cz2ss7hsEHLbPMNc25a
         dtLfDYEYyrc64d/zMzldBS1QQ8j4b2F27w/Xbs9iLo4aPlDUZCu6wqafCCSDD0j6AMjW
         tOrQ==
X-Gm-Message-State: AOAM531N30c3giO9I5iF4yRTinkq8xX4RxQtR39Uev507e8OssJLZL9n
        Ucz0Zrl6t0T1ejPS+ksdhrai4BRKeGs0mw==
X-Google-Smtp-Source: ABdhPJzQr1I56C3kTXejdctJYTvYMH8Xf51D+8crHXB+jVEBShmCHRyrvEprSSKn1QJ+AoaLhmGh7g==
X-Received: by 2002:a05:620a:454f:b0:6a0:5212:96d2 with SMTP id u15-20020a05620a454f00b006a0521296d2mr6187861qkp.603.1653050793932;
        Fri, 20 May 2022 05:46:33 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id 202-20020a3703d3000000b0069fc13ce213sm3111969qkd.68.2022.05.20.05.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:46:33 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id j2so14097403ybu.0;
        Fri, 20 May 2022 05:46:32 -0700 (PDT)
X-Received: by 2002:a05:6902:389:b0:633:31c1:d0f7 with SMTP id
 f9-20020a056902038900b0063331c1d0f7mr9068692ybs.543.1653050792549; Fri, 20
 May 2022 05:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com> <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
 <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
In-Reply-To: <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 14:46:20 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVx7r-4TVV9uVJppT-7ZAriov01BUNk4ghU9Bs4uY28vQ@mail.gmail.com>
Message-ID: <CAMuHMdVx7r-4TVV9uVJppT-7ZAriov01BUNk4ghU9Bs4uY28vQ@mail.gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION 736ee37e2e8eed7fe48d0a37ee5a709514d478b3
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-staging@lists.linux.dev,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>, linux-nvme@lists.infradead.org,
        linux-hwmon@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-sparse@vger.kernel.org,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 2:40 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, May 19, 2022 at 8:48 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > On 5/18/22 17:55, kernel test robot wrote:
> > > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > > branch HEAD: 736ee37e2e8eed7fe48d0a37ee5a709514d478b3  Add linux-next specific files for 20220518
> > >
> > > Error/Warning reports:
> > >
> > > https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
> > > https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
> > > https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
> > > https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
> > > https://lore.kernel.org/linux-mm/202205190527.o9wVEvHI-lkp@intel.com
> > >
> > > Error/Warning: (recently discovered and may have been fixed)
> > >
> > [ .. ]
> > > drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
> > > drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
> >
> > This is getting tiresome. Every driver using outb() on m68k will
> > experience that "problem". As far as I can see, it is caused by
> >
> > #define out_8(addr,b) (void)((*(__force volatile u8 *) (unsigned long)(addr)) = (b))
> >
> > in arch/m68k/include/asm/raw_io.h. I have no idea what the
> > "(void)" is for,
>
> The "(void)" makes sure there is no return value.
> Which matters if the result of a function returning void is propagated
> to another function returning void.

Which, FTR, sparse also doesn't like:

    error: return expression in void function

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

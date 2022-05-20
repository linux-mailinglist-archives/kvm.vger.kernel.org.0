Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF752EC4F
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349378AbiETMkj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 20 May 2022 08:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349254AbiETMkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:40:35 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193871649AF;
        Fri, 20 May 2022 05:40:34 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id y15so2511169qtx.4;
        Fri, 20 May 2022 05:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AW3WbgwLSP0WZKYPK3Y6DQ8WAhPkJkHKkMhSdaktb4M=;
        b=ci526RxuduDAZtSAK1B75bBv5EU8oW/UM99VYulFLoW0SXbQKgheOVlkKITJCSIzWo
         KCVz8Vbz8LaRCqZmvBTadqD+PqharqnlSlidLU6xr6EOm9vs5pKDcTLMUkT2wXlf4f7i
         qqIzhB1wg3g1HIZYq3ruMU4yVVHRsFvGKUkz/N2X61c3RLAmNF21M+sqaaXD3FhwywJU
         HvrRlvPft9vzFShBS37mBjfVMrN9Opl+rT57FeeAjjiPWxqMsCI9LOuH+BVg3DSXekJ5
         rdXI41P0lEYLKmucAsODcq8p1ryDd8kAhmngpcoPYk8kr/+gNMcniyrGrb+pTdkVk1yc
         exMQ==
X-Gm-Message-State: AOAM531GwRBYfXAHVFdPGs/6F76fA6xx6W9WD+dbC/e2iDHZXot+Yx6y
        iz3Hcl1LWgbGk4vj9t3tbqhNNOfDbDMAAQ==
X-Google-Smtp-Source: ABdhPJwlffsHGkLQuTm/hpnqLikeezIRbe5GuMm2uJSZ35XfJGXdhcJxKEOaW3CdGTte+VCjB79OLQ==
X-Received: by 2002:a05:622a:1654:b0:2f3:deaa:4d53 with SMTP id y20-20020a05622a165400b002f3deaa4d53mr7354433qtj.232.1653050432999;
        Fri, 20 May 2022 05:40:32 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id i18-20020ac84f52000000b002f9114d2ebcsm2627854qtw.17.2022.05.20.05.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:40:32 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2ff90e0937aso11101967b3.4;
        Fri, 20 May 2022 05:40:32 -0700 (PDT)
X-Received: by 2002:a81:9b0c:0:b0:2f4:c522:7d3c with SMTP id
 s12-20020a819b0c000000b002f4c5227d3cmr9969695ywg.316.1653050431948; Fri, 20
 May 2022 05:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com> <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
In-Reply-To: <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 14:40:20 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
Message-ID: <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
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

Hi Günter

On Thu, May 19, 2022 at 8:48 AM Guenter Roeck <linux@roeck-us.net> wrote:
> On 5/18/22 17:55, kernel test robot wrote:
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > branch HEAD: 736ee37e2e8eed7fe48d0a37ee5a709514d478b3  Add linux-next specific files for 20220518
> >
> > Error/Warning reports:
> >
> > https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
> > https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
> > https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
> > https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
> > https://lore.kernel.org/linux-mm/202205190527.o9wVEvHI-lkp@intel.com
> >
> > Error/Warning: (recently discovered and may have been fixed)
> >
> [ .. ]
> > drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
> > drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
>
> This is getting tiresome. Every driver using outb() on m68k will
> experience that "problem". As far as I can see, it is caused by
>
> #define out_8(addr,b) (void)((*(__force volatile u8 *) (unsigned long)(addr)) = (b))
>
> in arch/m68k/include/asm/raw_io.h. I have no idea what the
> "(void)" is for,

The "(void)" makes sure there is no return value.
Which matters if the result of a function returning void is propagated
to another function returning void.

> but removing it "fixes" the problem.

This introduces new problems (m68k all{mod,yes}config):

    In file included from arch/m68k/include/asm/io_mm.h:25,
                     from arch/m68k/include/asm/io.h:8,
                     from include/linux/io.h:13,
                     from include/linux/of_address.h:7,
                     from drivers/gpu/drm/msm/adreno/adreno_gpu.c:13:
    drivers/gpu/drm/msm/adreno/a6xx_gmu.h: In function ‘gmu_write_rscc’:
    arch/m68k/include/asm/raw_io.h:34:80: error: ‘return’ with a
value, in function returning void [-Werror=return-type]
       34 | #define out_le32(addr,l) ((*(__force volatile __le32 *)
(unsigned long)(addr)) = cpu_to_le32(l))
          |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
    arch/m68k/include/asm/io_mm.h:397:26: note: in expansion of macro ‘out_le32’
      397 | #define writel(val,addr) out_le32((addr),(val))
          |                          ^~~~~~~~
    drivers/gpu/drm/msm/msm_drv.h:468:32: note: in expansion of macro ‘writel’
      468 | #define msm_writel(data, addr) writel((data), (addr))
          |                                ^~~~~~
    /drivers/gpu/drm/msm/adreno/a6xx_gmu.h:141:9: note: in expansion
of macro ‘msm_writel’
      141 |  return msm_writel(value, gmu->rscc + (offset << 2));
          |         ^~~~~~~~~~
    In file included from drivers/gpu/drm/msm/adreno/a6xx_gpu.h:11,
                     from drivers/gpu/drm/msm/adreno/adreno_gpu.c:20:
    drivers/gpu/drm/msm/adreno/a6xx_gmu.h:139:20: note: declared here
      139 | static inline void gmu_write_rscc(struct a6xx_gmu *gmu,
u32 offset, u32 value)
          |                    ^~~~~~~~~~~~~~

These can be fixed using e.g. (there are more in the Adreno driver):

     static inline void gmu_write(struct a6xx_gmu *gmu, u32 offset, u32 value)
     {
    -       return msm_writel(value, gmu->mmio + (offset << 2));
    +       msm_writel(value, gmu->mmio + (offset << 2));
     }

> Either case, this is not a problem with the nct6775 driver,
> nor is it a new problem.

Indeed.

For the sparse people:

The full error is:

        drivers/net/appletalk/cops.c:382:17: error: incompatible types
in conditional expression (different base types):
        drivers/net/appletalk/cops.c:382:17:    unsigned char
        drivers/net/appletalk/cops.c:382:17:    void

Basically, sparse doesn't like "a ? b : c", if the return types of
b and c don't match, even if the resulting value is not used.

E.g. outb() on m68k:

    #define outb(val, port) (((port) < 1024 && ISA_TYPE ==
ISA_TYPE_ENEC) ? isa_rom_outb((val), (port)) : isa_outb((val),
(port)))

where isa_rom_outb() leads to rom_out_8() returning u8, while
isa_outb() leads to the out_8() that includes the cast to void.

So the best solution seems to be to add more "(void)" casts, to e.g.
rom_out_8() and friends?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F78BACE8
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 05:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405659AbfIWDjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Sep 2019 23:39:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42878 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404054AbfIWDjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Sep 2019 23:39:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id n14so12171384wrw.9
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2019 20:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aW5JAQkQgpvqTjYjNxgV8q6UjWSZi6NlskA09iDonQI=;
        b=ThCt24HNfG5UA4GZNfmLY2rU4yX1Uu8S5olqh71hBvnVMmYi4He3jQPWcvcHcgunvY
         ePdoJ1Jd3k6WpFIwnL+6w590IMFQcsO65bY2obQZ9U5W7FvdKVM2oFBlsmPKyjarFp9O
         BymdKJId+cdGvIlMabnANJjHMKPv3HE8t+xFFfztPQXJUMRTRoIu2aiayGgOHp8Mkkcj
         juZ54TxLZhUtxXUMAQVUwwJjkewLON9rTptWzP//4Pf8/d15/40jOkOQ3vzB783VFVQD
         22Je84qniXInOMqQoyBzh5EYsy+EoKjBhYxOyHLT8sx71mykqdC7zF29NoHeCfu7dsnc
         D3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aW5JAQkQgpvqTjYjNxgV8q6UjWSZi6NlskA09iDonQI=;
        b=jUISw+RbuEP29Lt5EDoHLMfeUJls8sQ1EGJ45cG2B6PFJAUEh8Dl+VZx194Z3dilMg
         T/kDVWh6wxodtwo8RSsUC5g2edjK10JQZzuYzfwSlbTA+0/diTNFpqbaX2OK4SwBac5I
         tF9yq1i21Y/yATHyfcD5p2PUfAVACtA1oHwOGfX3DOBQKpVcGt8U3Lq02YPl9yDr83mw
         boFsE59BuIL2T9MpsaPWZDhEUCcCLpUI3Un4aUxycBpFg7s76r6hUQNnBG/Yocb3fHtd
         C/zWW3ewTpPou0u26ko7TxJWUHy21gNpjXXQGgjx/qi9JycbHfJOwMEox8gPiYOlIjIK
         x8Xg==
X-Gm-Message-State: APjAAAXo/iC3N23dbehkmj5Bjj/it8gIeHOVsBduvSlSDmBapLio5//2
        0F7BCMlYABjFj/2fM7rMUEFgfHInlJI3FfbRr7vhDA==
X-Google-Smtp-Source: APXvYqze7ymtwFE7RXpx3rSb3D6YCBPqL4OJZrzyaon1IurzPabwrovG7laL5kGgnAiE4PvAgT4b6LHpYqC1DXUVtRE=
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr19124674wrx.309.1569209987215;
 Sun, 22 Sep 2019 20:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-4-anup.patel@wdc.com>
 <alpine.DEB.2.21.9999.1909210245000.2030@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.1909210245000.2030@viisi.sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 23 Sep 2019 09:09:35 +0530
Message-ID: <CAAhSdy1GAncwc1zd2jtacWD4wN=hWPBXruKoh4F-pw88HuWPpw@mail.gmail.com>
Subject: Re: [PATCH v7 02/21] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 21, 2019 at 3:31 PM Paul Walmsley <paul.walmsley@sifive.com> wrote:
>
> Hi Anup,
>
> Thanks for changing this to use a bitmap.  A few comments below -
>
> On Wed, 4 Sep 2019, Anup Patel wrote:
>
> > This patch adds riscv_isa bitmap which represents Host ISA features
> > common across all Host CPUs. The riscv_isa is not same as elf_hwcap
> > because elf_hwcap will only have ISA features relevant for user-space
> > apps whereas riscv_isa will have ISA features relevant to both kernel
> > and user-space apps.
> >
> > One of the use-case for riscv_isa bitmap is in KVM hypervisor where
> > we will use it to do following operations:
> >
> > 1. Check whether hypervisor extension is available
> > 2. Find ISA features that need to be virtualized (e.g. floating
> >    point support, vector extension, etc.)
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > Reviewed-by: Alexander Graf <graf@amazon.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 26 +++++++++++
> >  arch/riscv/kernel/cpufeature.c | 79 ++++++++++++++++++++++++++++++++--
> >  2 files changed, 102 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 7ecb7c6a57b1..9b657375aa51 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -8,6 +8,7 @@
> >  #ifndef __ASM_HWCAP_H
> >  #define __ASM_HWCAP_H
> >
> > +#include <linux/bits.h>
> >  #include <uapi/asm/hwcap.h>
> >
> >  #ifndef __ASSEMBLY__
> > @@ -22,5 +23,30 @@ enum {
> >  };
> >
> >  extern unsigned long elf_hwcap;
> > +
> > +#define RISCV_ISA_EXT_a              ('a' - 'a')
> > +#define RISCV_ISA_EXT_c              ('c' - 'a')
> > +#define RISCV_ISA_EXT_d              ('d' - 'a')
> > +#define RISCV_ISA_EXT_f              ('f' - 'a')
> > +#define RISCV_ISA_EXT_h              ('h' - 'a')
> > +#define RISCV_ISA_EXT_i              ('i' - 'a')
> > +#define RISCV_ISA_EXT_m              ('m' - 'a')
> > +#define RISCV_ISA_EXT_s              ('s' - 'a')
> > +#define RISCV_ISA_EXT_u              ('u' - 'a')
> > +#define RISCV_ISA_EXT_zicsr  (('z' - 'a') + 1)
> > +#define RISCV_ISA_EXT_zifencei       (('z' - 'a') + 2)
> > +#define RISCV_ISA_EXT_zam    (('z' - 'a') + 3)
> > +#define RISCV_ISA_EXT_ztso   (('z' - 'a') + 4)
>
> If we add the Z extensions here, it's probably best if we drop Zam from
> this list.  The rationale is, as maintainers, we're planning to hold off
> on merging any support for extensions or modules that aren't in the
> "frozen" or "ratified" states, and according to the RISC-V specs, Zicsr,
> Zifencei, and Ztso are all either frozen or ratified.  However, see
> below -

No problem, I will remove Zam define.

Please add documentation under Documentation/riscv regarding the
policy of not merging support for RISC-V extensions which aren't in
"frozen" or "ratified" state.

>
> > +
> > +#define RISCV_ISA_EXT_MAX    256
> > +
> > +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
> > +
> > +#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
> > +
> > +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit);
> > +#define riscv_isa_extension_available(isa_bitmap, ext)       \
> > +     __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
> > +
> >  #endif
> >  #endif
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index b1ade9a49347..4ce71ce5e290 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -6,21 +6,64 @@
> >   * Copyright (C) 2017 SiFive
> >   */
> >
> > +#include <linux/bitmap.h>
> >  #include <linux/of.h>
> >  #include <asm/processor.h>
> >  #include <asm/hwcap.h>
> >  #include <asm/smp.h>
> >
> >  unsigned long elf_hwcap __read_mostly;
> > +
> > +/* Host ISA bitmap */
> > +static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
> > +
> >  #ifdef CONFIG_FPU
> >  bool has_fpu __read_mostly;
> >  #endif
> >
> > +/**
> > + * riscv_isa_extension_base - Get base extension word
> > + *
> > + * @isa_bitmap ISA bitmap to use
> > + * @returns base extension word as unsigned long value
> > + *
> > + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> > + */
>
> Am happy to see comments that can be automatically parsed, but could you
> reformat them into kernel-doc format?
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/doc-guide/kernel-doc.rst

Sure, I will update comments as-per kernel-doc.rst.

>
> > +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap)
> > +{
> > +     if (!isa_bitmap)
> > +             return riscv_isa[0];
> > +     return isa_bitmap[0];
> > +}
> > +EXPORT_SYMBOL_GPL(riscv_isa_extension_base);
> > +
> > +/**
> > + * __riscv_isa_extension_available - Check whether given extension
> > + * is available or not
> > + *
> > + * @isa_bitmap ISA bitmap to use
> > + * @bit bit position of the desired extension
> > + * @returns true or false
> > + *
> > + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> > + */
>
> Same comment as above.

Okay, I will update.

>
> > +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit)
> > +{
> > +     const unsigned long *bmap = (isa_bitmap) ? isa_bitmap : riscv_isa;
> > +
> > +     if (bit >= RISCV_ISA_EXT_MAX)
> > +             return false;
> > +
> > +     return test_bit(bit, bmap) ? true : false;
> > +}
> > +EXPORT_SYMBOL_GPL(__riscv_isa_extension_available);
> > +
> >  void riscv_fill_hwcap(void)
> >  {
> >       struct device_node *node;
> >       const char *isa;
> > -     size_t i;
> > +     char print_str[BITS_PER_LONG+1];
> > +     size_t i, j, isa_len;
> >       static unsigned long isa2hwcap[256] = {0};
> >
> >       isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
> > @@ -32,8 +75,11 @@ void riscv_fill_hwcap(void)
> >
> >       elf_hwcap = 0;
> >
> > +     bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
> > +
> >       for_each_of_cpu_node(node) {
> >               unsigned long this_hwcap = 0;
> > +             unsigned long this_isa = 0;
> >
> >               if (riscv_of_processor_hartid(node) < 0)
> >                       continue;
> > @@ -43,8 +89,20 @@ void riscv_fill_hwcap(void)
> >                       continue;
> >               }
> >
> > -             for (i = 0; i < strlen(isa); ++i)
> > +             i = 0;
> > +             isa_len = strlen(isa);
> > +#if defined(CONFIG_32BIT)
> > +             if (!strncmp(isa, "rv32", 4))
> > +                     i += 4;
> > +#elif defined(CONFIG_64BIT)
> > +             if (!strncmp(isa, "rv64", 4))
> > +                     i += 4;
> > +#endif
> > +             for (; i < isa_len; ++i) {
> >                       this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
> > +                     if ('a' <= isa[i] && isa[i] <= 'z')
> > +                             this_isa |= (1UL << (isa[i] - 'a'));
>
> Continuing from the earlier comment, this code won't properly handle the X
> and Z prefix extensions.  So maybe for the time being, we should just drop
> the lines mentioned earlier that imply that we can parse Z-prefix
> extensions, and change this line so it ignores X and Z letters?
>
> Then a subsequent patch can add support for more complicated extension
> string parsing.

Okay, we sill not parse 'x' and 'z' bits (which can be added later for
X and Z prefix extensions).

>
>
> > +             }
> >
> >               /*
> >                * All "okay" hart should have same isa. Set HWCAP based on
> > @@ -55,6 +113,11 @@ void riscv_fill_hwcap(void)
> >                       elf_hwcap &= this_hwcap;
> >               else
> >                       elf_hwcap = this_hwcap;
> > +
> > +             if (riscv_isa[0])
> > +                     riscv_isa[0] &= this_isa;
> > +             else
> > +                     riscv_isa[0] = this_isa;
> >       }
> >
> >       /* We don't support systems with F but without D, so mask those out
> > @@ -64,7 +127,17 @@ void riscv_fill_hwcap(void)
> >               elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
> >       }
> >
> > -     pr_info("elf_hwcap is 0x%lx\n", elf_hwcap);
> > +     memset(print_str, 0, sizeof(print_str));
> > +     for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> > +             if (riscv_isa[0] & BIT_MASK(i))
> > +                     print_str[j++] = (char)('a' + i);
> > +     pr_info("riscv: ISA extensions %s\n", print_str);
> > +
> > +     memset(print_str, 0, sizeof(print_str));
> > +     for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> > +             if (elf_hwcap & BIT_MASK(i))
> > +                     print_str[j++] = (char)('a' + i);
> > +     pr_info("riscv: ELF capabilities %s\n", print_str);
> >
> >  #ifdef CONFIG_FPU
> >       if (elf_hwcap & (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D))
> > --
> > 2.17.1
> >
> >
>
>
> - Paul

Regards,
Anup

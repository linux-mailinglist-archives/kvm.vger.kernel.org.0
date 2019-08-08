Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B7858D9
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 06:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfHHEDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 00:03:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41853 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfHHEDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 00:03:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so90195535wrm.8
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 21:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctJbyyLwMP33agpqVGwypoXkfgT1J1HH/9FLl/LJj1E=;
        b=KiSioMKNVN4ckpn8lnAwBaU6vzjJcekS1R/mBbo7BENCM1p+lGjM0wRNn7LoOrcsY/
         4Az7FsmY8J+KmoB48yp9wEkKP/2TVdnRE13YG37np981m95paFbIFBNIX9jWfP+8mdWL
         zt7EglsdAHDzomvMfKWoBOE+oJqZKzSKcPPoSijpHJzAO6usjfnybEdOGVArQTCPyy00
         zPMFjwngMiybaGqgu1KLzpxGk0LpAoxtKp+1mvTtFRHJSsG7MchyJhE0fM2UCRWqg9kI
         6Z3IzAtm5fBQI0LEGpeelBNiPG35J/bEYBt79E2Xb3y0FjE0f39uxUGdKj+UcKIO6VbA
         wWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctJbyyLwMP33agpqVGwypoXkfgT1J1HH/9FLl/LJj1E=;
        b=dKoM2lm4DGUuFyCIt0RxkxAJYz95zfmPYv/NpEZdvBA1Zf6dgWIIbvTnyF4wU7agyg
         DZ2ojIZ43EAsK7yYWyIcouPQq3tKjzeKCpRDy9Rek3Bc81R1tcd4v8Xwrg2bbJnM1abb
         rM7pKTqj07hppPtVK23uR4VEcCNPo5mjmdH1pXlpC+zyiXwgz+/fvHM1GYnTNR31nNa9
         02H9TVHfQs9ANyDXk9llt/EmE9nhjAJGILKXl3iyOTHFINv3dDDRItBDbRSzyUpzo5EI
         2duuN798yfHFlf/IffD8aEjjXiBlihMtJqJaNr5razkKN3RbTOGGf1d1l9gadJHXu69S
         wVfg==
X-Gm-Message-State: APjAAAVKgzjb3ERdfn/UKhjRabFGhVzDp2igqUjaw46o7V7akkQsmvQb
        SO/tS2Mgj0S07gp+1YKMwQOVTxOa67PvnLNUqcNUWA==
X-Google-Smtp-Source: APXvYqw+zr7sYUMpcCIs/Nf6nfkGt6pARCHzcNVZrVf/9qmDgATyGTeI1/I6LnEk4AcCJNQErEzeObSpUsbjJkqmB9A=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr13203226wra.328.1565237023085;
 Wed, 07 Aug 2019 21:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190807122726.81544-1-anup.patel@wdc.com> <20190807122726.81544-3-anup.patel@wdc.com>
 <750dc9365c02d20616ae8ca22ac454d0e54e994e.camel@wdc.com>
In-Reply-To: <750dc9365c02d20616ae8ca22ac454d0e54e994e.camel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 8 Aug 2019 09:33:31 +0530
Message-ID: <CAAhSdy0_pR6aZj5R=EYnoa94BDgXfCDujOV+bBHRhMCyKAbb9A@mail.gmail.com>
Subject: Re: [PATCH v4 02/20] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
To:     Atish Patra <Atish.Patra@wdc.com>
Cc:     "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 8, 2019 at 12:18 AM Atish Patra <Atish.Patra@wdc.com> wrote:
>
> On Wed, 2019-08-07 at 12:28 +0000, Anup Patel wrote:
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
> > ---
> >  arch/riscv/include/asm/hwcap.h | 26 +++++++++++
> >  arch/riscv/kernel/cpufeature.c | 79
> > ++++++++++++++++++++++++++++++++--
> >  2 files changed, 102 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h
> > b/arch/riscv/include/asm/hwcap.h
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
>
> As per the discussion in following threads, 'S' & 'U' are not valid ISA
> extensions. So we should drop them from here as well.
>
> http://lists.infradead.org/pipermail/linux-riscv/2019-August/005771.html
>
> https://lists.nongnu.org/archive/html/qemu-devel/2019-08/msg01217.html

I disagree because we are not checking or enforcing required ISA features
here.

The asm/hwcap.h should define all possible feature and extension bits
defined by the RISC-V spec.

The 's' and 'u' bits in ISA mean that S-mode and U-mode are supported.
These bits are defined in RISC-V privileged spec as well.

Regards,
Anup

>
>
> > +#define RISCV_ISA_EXT_zicsr  (('z' - 'a') + 1)
> > +#define RISCV_ISA_EXT_zifencei       (('z' - 'a') + 2)
> > +#define RISCV_ISA_EXT_zam    (('z' - 'a') + 3)
> > +#define RISCV_ISA_EXT_ztso   (('z' - 'a') + 4)
> > +
> > +#define RISCV_ISA_EXT_MAX    256
> > +
> > +unsigned long riscv_isa_extension_base(const unsigned long
> > *isa_bitmap);
> > +
> > +#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
> > +
> > +bool __riscv_isa_extension_available(const unsigned long
> > *isa_bitmap, int bit);
> > +#define riscv_isa_extension_available(isa_bitmap, ext)       \
> > +     __riscv_isa_extension_available(isa_bitmap,
> > RISCV_ISA_EXT_##ext)
> > +
> >  #endif
> >  #endif
> > diff --git a/arch/riscv/kernel/cpufeature.c
> > b/arch/riscv/kernel/cpufeature.c
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
> > +unsigned long riscv_isa_extension_base(const unsigned long
> > *isa_bitmap)
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
> > +bool __riscv_isa_extension_available(const unsigned long
> > *isa_bitmap, int bit)
> > +{
> > +     const unsigned long *bmap = (isa_bitmap) ? isa_bitmap :
> > riscv_isa;
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
> >                       this_hwcap |= isa2hwcap[(unsigned
> > char)(isa[i])];
> > +                     if ('a' <= isa[i] && isa[i] <= 'z')
> > +                             this_isa |= (1UL << (isa[i] - 'a'));
> > +             }
> >
> >               /*
> >                * All "okay" hart should have same isa. Set HWCAP
> > based on
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
> >       /* We don't support systems with F but without D, so mask those
> > out
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
>
> --
> Regards,
> Atish

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD614041E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 07:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgAQGpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 01:45:42 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54038 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgAQGpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 01:45:42 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so6261043wmc.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 22:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kT8tPUK6L9PWUiDm45+TRBWNAtdOjta2epvvVWDmezc=;
        b=SQawDGAIAEIs1WOeVH1PHqR1VSCqOB2JGqvm8JqWCTXIEJYs+XDb3yQ1CoB4z6K4Oo
         hC+0oUX1Z9XPJTxiasveFeoF80IUp/DLBkcMLp5iVPLnr/Q4ssVFwDeMDb3Qlua/eCAl
         /d+R2/V4skTQPhkRUms2glAGzO7b1kv4YptoN+uE/sOzeNAnM6HGUSy77sTdcE0mzHFW
         nzrtI9qA5fAzW7Aof36k4JPJOwZEmz++tFsedySP1b6/NufnUdkqRZo6osv187KK6+67
         sW7Hp6SkoZ5punhiVxEs2CEauJLEjYe8s3mDvzLUaOD23g+D7yh0ELSo7D4Kuw1SO6cb
         AD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kT8tPUK6L9PWUiDm45+TRBWNAtdOjta2epvvVWDmezc=;
        b=lTzmqTGbAgLR4qPEqLMz8R/tlpcrbErSn3KzeQjKatnQIebL4DLA3q2OGERghmtXeY
         1BNVPYiJzWIjgMH1z2LDWgXtVE9XFIVAUqhtmCvlg+lSrr+/ZvybMX3u1uoYH1IpmUA0
         K2NufczYkT2bwqDlCIv2R4r2WLt3IBqb9ktv256oAW5z36quxQ3xZcpr5QIlQUkSYRFu
         5D/vModOirADsQYvK9JDaOkTgyKAZQaheNrh71tAmPkKWVGYeDAE0JB+Pr06wsFE4nXn
         0o8Z70ZBU9xadQqVcXmvA79qOYSIjkqV8gMIJ8wzTUvp8r5R5aEaUTJZyFNpoQZQKzwp
         fhKw==
X-Gm-Message-State: APjAAAXf4dwRJz5nCjP9nUyyQvq7lGxDpAhsoDQvaE/k6+beE97u0qOC
        TX9dgaXKaqW73o95in9beJdBhjxUbTrQmH/GjrQabg==
X-Google-Smtp-Source: APXvYqzm7mbKYpIzCReRqg4cthTMWToH3MI9+VF8y4RoSICRSnCExf7Y/HnStY9c+nfE2sTYD5et+fdqX9huvxTQqXs=
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr2971942wmd.102.1579243539254;
 Thu, 16 Jan 2020 22:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20191223113443.68969-1-anup.patel@wdc.com> <20191223113443.68969-3-anup.patel@wdc.com>
 <mhng-24b22694-82f4-467b-b6a9-0fb2e186d3f2@palmerdabbelt-glaptop>
In-Reply-To: <mhng-24b22694-82f4-467b-b6a9-0fb2e186d3f2@palmerdabbelt-glaptop>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 17 Jan 2020 12:15:28 +0530
Message-ID: <CAAhSdy1MxVMm+7kxD3zE--_tzLk-pA0NOe_C54n6vbB4YxxrrQ@mail.gmail.com>
Subject: Re: [PATCH v10 02/19] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>, Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 17, 2020 at 1:21 AM Palmer Dabbelt <palmerdabbelt@google.com> wrote:
>
> On Mon, 23 Dec 2019 03:35:26 PST (-0800), Anup Patel wrote:
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
> >  arch/riscv/include/asm/hwcap.h | 22 +++++++++
> >  arch/riscv/kernel/cpufeature.c | 83 ++++++++++++++++++++++++++++++++--
> >  2 files changed, 102 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 1bb0cd04aec3..5589c012e004 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -8,6 +8,7 @@
> >  #ifndef _ASM_RISCV_HWCAP_H
> >  #define _ASM_RISCV_HWCAP_H
> >
> > +#include <linux/bits.h>
> >  #include <uapi/asm/hwcap.h>
> >
> >  #ifndef __ASSEMBLY__
> > @@ -22,6 +23,27 @@ enum {
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
> Unfortunately the ISA doesn't really work this way any more: the single-letter
> extensions are just aliases for longer extension strings, each of which
> represents a single instruction.  I know we're saddled with some ABI that looks
> this way, but I really don't want to add new code that depends on these defunct
> assumptions -- there isn't that much in Linux right now, but there's a lot in
> the FSF toolchain and getting that all out is going to be a long project.

Yes, I am aware of this.

Paul had raised similar concerns so we are using bitmap to tackle this

For example:
BIT['h' - 'a'] represents whether 'h' extension is present or not
In future, when we have incremental hxyz change in 'h' extension
we will assign some bitpostion Bhxyz for this and BIT[Bhxyz]
will represent whether 'hxyz' is present or not.

>
> > +
> > +#define RISCV_ISA_EXT_MAX    256
>
> Why so big?  It looks like the rest of the code just touches the first word,
> and most of that is explicit.

Please see previous comment.

Here 256 is a ballpark size of bitmap. If you have any preferences then
I can change to that value. I am sure this value will change in the future.

>
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
> >
> >  #endif /* _ASM_RISCV_HWCAP_H */
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index 0b40705567b7..e172a2322b34 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -6,6 +6,7 @@
> >   * Copyright (C) 2017 SiFive
> >   */
> >
> > +#include <linux/bitmap.h>
> >  #include <linux/of.h>
> >  #include <asm/processor.h>
> >  #include <asm/hwcap.h>
> > @@ -13,15 +14,57 @@
> >  #include <asm/switch_to.h>
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
> > + * riscv_isa_extension_base() - Get base extension word
> > + *
> > + * @isa_bitmap: ISA bitmap to use
> > + * Return: base extension word as unsigned long value
> > + *
> > + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> > + */
> > +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap)
> > +{
> > +     if (!isa_bitmap)
> > +             return riscv_isa[0];
> > +     return isa_bitmap[0];
> > +}
> > +EXPORT_SYMBOL_GPL(riscv_isa_extension_base);
>
> This isn't used, which makes it hard to review.  Can you please split out the
> changes that don't depend on the V extension to come out of draft?  That would
> make it easier to take some of the code early, which lets us keep around less
> diff.

This is used by KVM RISC-V patches hence it is part of KVM RISC-V series.

>
> > +
> > +/**
> > + * __riscv_isa_extension_available() - Check whether given extension
> > + * is available or not
> > + *
> > + * @isa_bitmap: ISA bitmap to use
> > + * @bit: bit position of the desired extension
> > + * Return: true or false
> > + *
> > + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> > + */
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
> > +     char print_str[BITS_PER_LONG + 1];
> > +     size_t i, j, isa_len;
> >       static unsigned long isa2hwcap[256] = {0};
> >
> >       isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
> > @@ -33,8 +76,11 @@ void riscv_fill_hwcap(void)
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
> > @@ -42,8 +88,24 @@ void riscv_fill_hwcap(void)
> >               if (riscv_read_check_isa(node, &isa) < 0)
> >                       continue;
> >
> > -             for (i = 0; i < strlen(isa); ++i)
> > +             i = 0;
> > +             isa_len = strlen(isa);
> > +#if IS_ENABLED(CONFIG_32BIT)
> > +             if (!strncmp(isa, "rv32", 4))
> > +                     i += 4;
> > +#elif IS_ENABLED(CONFIG_64BIT)
> > +             if (!strncmp(isa, "rv64", 4))
> > +                     i += 4;
>
> We shouldn't be accepting arbitrary inputs and attempting to correct them, just
> enforce that an actual ISA string is provided and check it against what the
> kernel can support.

I agree that ISA string parsing is not perfect and will improve over time but
ISA bitmap should have all the features set as provided via CPU DT nodes.

We allow KVM RISC-V initialization to proceed only when 'H' extension is
supported.

>
> > +#endif
> > +             for (; i < isa_len; ++i) {
> >                       this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
> > +                     /*
> > +                      * TODO: X, Y and Z extension parsing for Host ISA
> > +                      * bitmap will be added in-future.
> > +                      */
> > +                     if ('a' <= isa[i] && isa[i] < 'x')
> > +                             this_isa |= (1UL << (isa[i] - 'a'));
> > +             }
> >
> >               /*
> >                * All "okay" hart should have same isa. Set HWCAP based on
> > @@ -54,6 +116,11 @@ void riscv_fill_hwcap(void)
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
> > @@ -63,7 +130,17 @@ void riscv_fill_hwcap(void)
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

Regards,
Anup

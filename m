Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2064B79E5
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390449AbfISM4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:56:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45294 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390440AbfISM4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:56:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so2942158wrm.12
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 05:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbuzH0daMt+MsoMW45qZdAf/7ra0L3lDjQjOsI2VHWQ=;
        b=oBEzttwMR9rbIp1WYQ0uoKtd9fQVsAyv5adJg6k2jsN17FRK/uMFdPM+iWYhwyHUgY
         Wv9otQwbkODuQaxad4JWGpV+NnSTy0AfrrK7qT/2Mq1omJkblCtRPp0vvickWuGdaEAo
         9LwjkJo26aBKXkTzaguMdcy5yUjl0IFXDDEg5CshxjaSKj8PDWoO5cf1IWeIlv817pWl
         GnFeewZA9/Mdg5g4HJZ0UuYrwLJvgs1twQCCW1q/dEnO7Yl7KGVIfz57DQCCrjeFEzHv
         zt4PnAUp2JurM57cC4gFbCpH/qTbDXQlHCYpUwhhYXCFflKZubX3QVAjqvoPmuALF7VR
         afzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbuzH0daMt+MsoMW45qZdAf/7ra0L3lDjQjOsI2VHWQ=;
        b=XSdmgk5xMp3ZtgutZaxeKNRlXoI6jyq6y4El/nU17qwdO3B4VBQCEIFjxlhHL9SZMl
         G5CCbkn1fcqetYF55YBdUptFL0oUJ8BTfdHunRyx8heIOW3MqtNboT61XxBlo8Szp/tW
         mK565Ck3H2PY0UeZUoQD8ApQ9qy5QFMfgpfrep7tmMcEkVyHWOmy12nRxaZelZAULrtT
         5vr5Mv1rqyIRUmRGTJdpAO0iI4frisbDchXn624+SNxLGjRS2xhS5AqkmY7wJK2F7nox
         rk+By33/sO/ND+cpu4SzXIlQWKXxZKIGBTMORF1FddYxJib7Hr976up6GH2p0P7Iha68
         YiBw==
X-Gm-Message-State: APjAAAVdFyMG5YQrNeBQz2Tfd+E6qBfEZU1VuY29abFMrma8zIIQ9kjQ
        Tw0aAV9hVuURcyD4Vw4n57+ZIayFvhEFtJWa96clLw==
X-Google-Smtp-Source: APXvYqxO8H0t5ovhrPmidpWD1aY3uJm4qdbUX/FofBcjV1DfA+0t9o9O4kMGJdkYbxAEiOpYaWykN8tDWG7Vnyi6zxc=
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr6556036wrw.328.1568897774029;
 Thu, 19 Sep 2019 05:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-4-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-4-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 19 Sep 2019 18:26:02 +0530
Message-ID: <CAAhSdy1n34wi9iR-QViBFo_ApQx-2R6Jkd8Zpvyt9aLB91jDSw@mail.gmail.com>
Subject: Re: [PATCH v7 02/21] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
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

Hi Paul,

On Wed, Sep 4, 2019 at 9:43 PM Anup Patel <Anup.Patel@wdc.com> wrote:
>
> This patch adds riscv_isa bitmap which represents Host ISA features
> common across all Host CPUs. The riscv_isa is not same as elf_hwcap
> because elf_hwcap will only have ISA features relevant for user-space
> apps whereas riscv_isa will have ISA features relevant to both kernel
> and user-space apps.
>
> One of the use-case for riscv_isa bitmap is in KVM hypervisor where
> we will use it to do following operations:
>
> 1. Check whether hypervisor extension is available
> 2. Find ISA features that need to be virtualized (e.g. floating
>    point support, vector extension, etc.)

I had addressed your previous comments on this patch by
making riscv_isa as bitmap to cover Z-extensions.

Please review it again.

Regards,
Anup

>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 26 +++++++++++
>  arch/riscv/kernel/cpufeature.c | 79 ++++++++++++++++++++++++++++++++--
>  2 files changed, 102 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 7ecb7c6a57b1..9b657375aa51 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -8,6 +8,7 @@
>  #ifndef __ASM_HWCAP_H
>  #define __ASM_HWCAP_H
>
> +#include <linux/bits.h>
>  #include <uapi/asm/hwcap.h>
>
>  #ifndef __ASSEMBLY__
> @@ -22,5 +23,30 @@ enum {
>  };
>
>  extern unsigned long elf_hwcap;
> +
> +#define RISCV_ISA_EXT_a                ('a' - 'a')
> +#define RISCV_ISA_EXT_c                ('c' - 'a')
> +#define RISCV_ISA_EXT_d                ('d' - 'a')
> +#define RISCV_ISA_EXT_f                ('f' - 'a')
> +#define RISCV_ISA_EXT_h                ('h' - 'a')
> +#define RISCV_ISA_EXT_i                ('i' - 'a')
> +#define RISCV_ISA_EXT_m                ('m' - 'a')
> +#define RISCV_ISA_EXT_s                ('s' - 'a')
> +#define RISCV_ISA_EXT_u                ('u' - 'a')
> +#define RISCV_ISA_EXT_zicsr    (('z' - 'a') + 1)
> +#define RISCV_ISA_EXT_zifencei (('z' - 'a') + 2)
> +#define RISCV_ISA_EXT_zam      (('z' - 'a') + 3)
> +#define RISCV_ISA_EXT_ztso     (('z' - 'a') + 4)
> +
> +#define RISCV_ISA_EXT_MAX      256
> +
> +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
> +
> +#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
> +
> +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit);
> +#define riscv_isa_extension_available(isa_bitmap, ext) \
> +       __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
> +
>  #endif
>  #endif
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index b1ade9a49347..4ce71ce5e290 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -6,21 +6,64 @@
>   * Copyright (C) 2017 SiFive
>   */
>
> +#include <linux/bitmap.h>
>  #include <linux/of.h>
>  #include <asm/processor.h>
>  #include <asm/hwcap.h>
>  #include <asm/smp.h>
>
>  unsigned long elf_hwcap __read_mostly;
> +
> +/* Host ISA bitmap */
> +static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
> +
>  #ifdef CONFIG_FPU
>  bool has_fpu __read_mostly;
>  #endif
>
> +/**
> + * riscv_isa_extension_base - Get base extension word
> + *
> + * @isa_bitmap ISA bitmap to use
> + * @returns base extension word as unsigned long value
> + *
> + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> + */
> +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap)
> +{
> +       if (!isa_bitmap)
> +               return riscv_isa[0];
> +       return isa_bitmap[0];
> +}
> +EXPORT_SYMBOL_GPL(riscv_isa_extension_base);
> +
> +/**
> + * __riscv_isa_extension_available - Check whether given extension
> + * is available or not
> + *
> + * @isa_bitmap ISA bitmap to use
> + * @bit bit position of the desired extension
> + * @returns true or false
> + *
> + * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
> + */
> +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit)
> +{
> +       const unsigned long *bmap = (isa_bitmap) ? isa_bitmap : riscv_isa;
> +
> +       if (bit >= RISCV_ISA_EXT_MAX)
> +               return false;
> +
> +       return test_bit(bit, bmap) ? true : false;
> +}
> +EXPORT_SYMBOL_GPL(__riscv_isa_extension_available);
> +
>  void riscv_fill_hwcap(void)
>  {
>         struct device_node *node;
>         const char *isa;
> -       size_t i;
> +       char print_str[BITS_PER_LONG+1];
> +       size_t i, j, isa_len;
>         static unsigned long isa2hwcap[256] = {0};
>
>         isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
> @@ -32,8 +75,11 @@ void riscv_fill_hwcap(void)
>
>         elf_hwcap = 0;
>
> +       bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
> +
>         for_each_of_cpu_node(node) {
>                 unsigned long this_hwcap = 0;
> +               unsigned long this_isa = 0;
>
>                 if (riscv_of_processor_hartid(node) < 0)
>                         continue;
> @@ -43,8 +89,20 @@ void riscv_fill_hwcap(void)
>                         continue;
>                 }
>
> -               for (i = 0; i < strlen(isa); ++i)
> +               i = 0;
> +               isa_len = strlen(isa);
> +#if defined(CONFIG_32BIT)
> +               if (!strncmp(isa, "rv32", 4))
> +                       i += 4;
> +#elif defined(CONFIG_64BIT)
> +               if (!strncmp(isa, "rv64", 4))
> +                       i += 4;
> +#endif
> +               for (; i < isa_len; ++i) {
>                         this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
> +                       if ('a' <= isa[i] && isa[i] <= 'z')
> +                               this_isa |= (1UL << (isa[i] - 'a'));
> +               }
>
>                 /*
>                  * All "okay" hart should have same isa. Set HWCAP based on
> @@ -55,6 +113,11 @@ void riscv_fill_hwcap(void)
>                         elf_hwcap &= this_hwcap;
>                 else
>                         elf_hwcap = this_hwcap;
> +
> +               if (riscv_isa[0])
> +                       riscv_isa[0] &= this_isa;
> +               else
> +                       riscv_isa[0] = this_isa;
>         }
>
>         /* We don't support systems with F but without D, so mask those out
> @@ -64,7 +127,17 @@ void riscv_fill_hwcap(void)
>                 elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
>         }
>
> -       pr_info("elf_hwcap is 0x%lx\n", elf_hwcap);
> +       memset(print_str, 0, sizeof(print_str));
> +       for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> +               if (riscv_isa[0] & BIT_MASK(i))
> +                       print_str[j++] = (char)('a' + i);
> +       pr_info("riscv: ISA extensions %s\n", print_str);
> +
> +       memset(print_str, 0, sizeof(print_str));
> +       for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> +               if (elf_hwcap & BIT_MASK(i))
> +                       print_str[j++] = (char)('a' + i);
> +       pr_info("riscv: ELF capabilities %s\n", print_str);
>
>  #ifdef CONFIG_FPU
>         if (elf_hwcap & (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D))
> --
> 2.17.1
>

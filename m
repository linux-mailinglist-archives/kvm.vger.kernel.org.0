Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4DDA7BD
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 10:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408376AbfJQIss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 04:48:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52961 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408336AbfJQIsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 04:48:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so1650422wmh.2
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 01:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ABLJXVRMPFM4pBjF5MtvPjsU9wNvxgGgz98k9KABKpI=;
        b=PF17a64CORHUVSvDRifR6t0U+QaHY0SKqGdGnvTTcrru79sqhAAXGH6HSdjaq2cdjS
         CcpHuf6rNGpuxa+PlYMxn4isoV+C0Et/4/tzdrMj9uG0vH6zebbqfsSph3nVP0TQFysU
         H1Jy6snrhBE4ar/G+trpHXjpEurwRgcecMUgiTGghi0y/soPmKbpHz9hbQDdfzQ7XjyD
         hU2CZO7bChiJGKt7E2qHxoqBfSu4cIODG1cVG/ULE+s/5m+1rFnxqIF2spLdv3gGM4D5
         X2nnwbiYmVsRCF1psZaQPuYGRZv3brqDQ4+fR6y5qPYW5DZxtvX60CTeDwCBoO653he/
         EmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABLJXVRMPFM4pBjF5MtvPjsU9wNvxgGgz98k9KABKpI=;
        b=GvdPqlXUZnpjzyJMO4DsHUJ9AYvN9fUY0ZNrFbeaEtpEroAkky6Bm64wO94GOUllOF
         ME0bT0b5kLclnb2lopoEQFDeRiNUlGFhBbeT5KaHaoI8Puv8D5cJUEhDiO9bRBssMpah
         d5rKgx8fVSOzDIeITpj4hNspADKNNPgFYHWx+Et+1JYdK8vmd4uo08YqADZ8Aw/kGDsh
         HagbwoNNwxAnLPGea23H4aRZJj+scaUC9GhbOiA/mQcHbOP2jXlup7tPEohc+E9DsCgV
         KKKgUNBZ5C3p6N1la9mo/EB+sRacyOp05wAIuvCpKx9hhFpswM+Ys/ce5N78B3S0w1F0
         /rEQ==
X-Gm-Message-State: APjAAAWkWIm5Ab5R3ebMZES9ZXNFhNlCOeMvo84VUxRWKkyzQsQTJR/u
        RS8qbGEGBL6qcfneh/F3kX1Z4dV6XqiTor4oE94ePQ==
X-Google-Smtp-Source: APXvYqwwEer8++JvoI8Wa9EUAhuZDuzD4ABKrqyb2q4mQEDHCVptVgwsYmWiFSo0tLUhjapJgLK3/nQr4MSfWYqwX8Q=
X-Received: by 2002:a1c:a697:: with SMTP id p145mr1734740wme.24.1571302124460;
 Thu, 17 Oct 2019 01:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160649.24622-1-anup.patel@wdc.com> <20191016160649.24622-2-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-2-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 17 Oct 2019 14:18:33 +0530
Message-ID: <CAAhSdy3xV0UjDKUgHoKbyoeV5kaC9rVSy=qoBpF=XrrbT=W=-Q@mail.gmail.com>
Subject: Re: [PATCH v9 01/22] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
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

On Wed, Oct 16, 2019 at 9:38 PM Anup Patel <Anup.Patel@wdc.com> wrote:
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
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Can you consider this patch for Linux-5.4-rcX ??

Regards,
Anup

> ---
>  arch/riscv/include/asm/hwcap.h | 22 +++++++++
>  arch/riscv/kernel/cpufeature.c | 83 ++++++++++++++++++++++++++++++++--
>  2 files changed, 102 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 7ecb7c6a57b1..5989dd4426d1 100644
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
> @@ -22,5 +23,26 @@ enum {
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
> index eaad5aa07403..64068d36658d 100644
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
> + * riscv_isa_extension_base() - Get base extension word
> + *
> + * @isa_bitmap: ISA bitmap to use
> + * Return: base extension word as unsigned long value
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
> + * __riscv_isa_extension_available() - Check whether given extension
> + * is available or not
> + *
> + * @isa_bitmap: ISA bitmap to use
> + * @bit: bit position of the desired extension
> + * Return: true or false
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
> @@ -41,8 +87,24 @@ void riscv_fill_hwcap(void)
>                 if (riscv_read_check_isa(node, &isa) < 0)
>                         continue;
>
> -               for (i = 0; i < strlen(isa); ++i)
> +               i = 0;
> +               isa_len = strlen(isa);
> +#if IS_ENABLED(CONFIG_32BIT)
> +               if (!strncmp(isa, "rv32", 4))
> +                       i += 4;
> +#elif IS_ENABLED(CONFIG_64BIT)
> +               if (!strncmp(isa, "rv64", 4))
> +                       i += 4;
> +#endif
> +               for (; i < isa_len; ++i) {
>                         this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
> +                       /*
> +                        * TODO: X, Y and Z extension parsing for Host ISA
> +                        * bitmap will be added in-future.
> +                        */
> +                       if ('a' <= isa[i] && isa[i] < 'x')
> +                               this_isa |= (1UL << (isa[i] - 'a'));
> +               }
>
>                 /*
>                  * All "okay" hart should have same isa. Set HWCAP based on
> @@ -53,6 +115,11 @@ void riscv_fill_hwcap(void)
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
> @@ -62,7 +129,17 @@ void riscv_fill_hwcap(void)
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

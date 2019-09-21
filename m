Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8139DB9D3E
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407390AbfIUKBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Sep 2019 06:01:36 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46741 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405440AbfIUKBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Sep 2019 06:01:36 -0400
Received: by mail-ot1-f65.google.com with SMTP id f21so8231489otl.13
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2019 03:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=IH+HLtM3m/3AdPUwWj10yu5azF09YSyrzk+IE7lz+/c=;
        b=Fjk5VEoH5TXP2GebQ8rtvVO7k9C2SXvanErm1z29Ux6o9KEmemDWy4J5YavIqS1uhz
         ciEkXtoyKr9e0ZEDCPCY3hR1EHJw+u2cLLz+NLb4Mue3jxoRiONck0rrPTK9sSX7DgAA
         0oSzI8Gky1LOekb3pThUJsHuuLUvQ5ZW4Nd06XqXZwjZwjoc/McC+6yjy9/gujgon9Mn
         4l+iuQeFGCkuofllZWdd9TewxT7mZmI0dGTmdqTOKUh7U9WyN3+YUXgIG7hxs+vHZFap
         ZeZMaadQmZPnKHajASa834VOs1nMVjtUJfOU4eaHrEtjrU3cqmRHqtgGhWFAcZ5SsHyw
         9JiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=IH+HLtM3m/3AdPUwWj10yu5azF09YSyrzk+IE7lz+/c=;
        b=KTLBkIqv/nNXG6sLXeNsOGBkkTUcAQnX7N3sOltjpFLIzGs1hicPLNLRwmDPIteTmX
         CgscP0bnqDIEyxCHctuewN7OKr4ZmscFlcOmLs6Ww7q25KrgK+NNkA17x1hBP4NVbZ1Y
         M9w0nbsyWJsNgPRXyVtI+a5XLX0Nrdf0y/2RwAVn3qYiJ4v+5Y8ehYbYfv78HfF6xq48
         wx6odwY/IVaTBbJbIfJ6CNerFmDMEaZ4KMCfehl9BdLTTV0U+G4RGAhUKEtFeAhG8oh+
         dMfvZDvMhd5NoSq2qtOebxMvl+FLg8SguUsNksmuKrzhN/mLlKpeDOAjuUQo3oqeG9C7
         BsXA==
X-Gm-Message-State: APjAAAVD2Wm4lkAWdodMzcdOxCDYvTy++TUlFTqKAk9T3lnMNCJJ2ee3
        1ELBGOC1jx8SUD1egCEXaltONQ==
X-Google-Smtp-Source: APXvYqzpSdwksOxrecA2OELNPx8yrVtpI8N9Oju4ihq+H1WOvzlOgo63k6TAq41Ye4rLUkc7UInGjg==
X-Received: by 2002:a05:6830:1e2b:: with SMTP id t11mr4492721otr.119.1569060094783;
        Sat, 21 Sep 2019 03:01:34 -0700 (PDT)
Received: from localhost (184.sub-174-206-23.myvzw.com. [174.206.23.184])
        by smtp.gmail.com with ESMTPSA id l17sm1309105oic.24.2019.09.21.03.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 03:01:34 -0700 (PDT)
Date:   Sat, 21 Sep 2019 03:01:27 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Anup Patel <Anup.Patel@wdc.com>
cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 02/21] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
In-Reply-To: <20190904161245.111924-4-anup.patel@wdc.com>
Message-ID: <alpine.DEB.2.21.9999.1909210245000.2030@viisi.sifive.com>
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-4-anup.patel@wdc.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anup,

Thanks for changing this to use a bitmap.  A few comments below -

On Wed, 4 Sep 2019, Anup Patel wrote:

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
> +#define RISCV_ISA_EXT_a		('a' - 'a')
> +#define RISCV_ISA_EXT_c		('c' - 'a')
> +#define RISCV_ISA_EXT_d		('d' - 'a')
> +#define RISCV_ISA_EXT_f		('f' - 'a')
> +#define RISCV_ISA_EXT_h		('h' - 'a')
> +#define RISCV_ISA_EXT_i		('i' - 'a')
> +#define RISCV_ISA_EXT_m		('m' - 'a')
> +#define RISCV_ISA_EXT_s		('s' - 'a')
> +#define RISCV_ISA_EXT_u		('u' - 'a')
> +#define RISCV_ISA_EXT_zicsr	(('z' - 'a') + 1)
> +#define RISCV_ISA_EXT_zifencei	(('z' - 'a') + 2)
> +#define RISCV_ISA_EXT_zam	(('z' - 'a') + 3)
> +#define RISCV_ISA_EXT_ztso	(('z' - 'a') + 4)

If we add the Z extensions here, it's probably best if we drop Zam from 
this list.  The rationale is, as maintainers, we're planning to hold off 
on merging any support for extensions or modules that aren't in the 
"frozen" or "ratified" states, and according to the RISC-V specs, Zicsr, 
Zifencei, and Ztso are all either frozen or ratified.  However, see 
below -

> +
> +#define RISCV_ISA_EXT_MAX	256
> +
> +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
> +
> +#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
> +
> +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit);
> +#define riscv_isa_extension_available(isa_bitmap, ext)	\
> +	__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
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

Am happy to see comments that can be automatically parsed, but could you 
reformat them into kernel-doc format? 

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/doc-guide/kernel-doc.rst

> +unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap)
> +{
> +	if (!isa_bitmap)
> +		return riscv_isa[0];
> +	return isa_bitmap[0];
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

Same comment as above.

> +bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit)
> +{
> +	const unsigned long *bmap = (isa_bitmap) ? isa_bitmap : riscv_isa;
> +
> +	if (bit >= RISCV_ISA_EXT_MAX)
> +		return false;
> +
> +	return test_bit(bit, bmap) ? true : false;
> +}
> +EXPORT_SYMBOL_GPL(__riscv_isa_extension_available);
> +
>  void riscv_fill_hwcap(void)
>  {
>  	struct device_node *node;
>  	const char *isa;
> -	size_t i;
> +	char print_str[BITS_PER_LONG+1];
> +	size_t i, j, isa_len;
>  	static unsigned long isa2hwcap[256] = {0};
>  
>  	isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
> @@ -32,8 +75,11 @@ void riscv_fill_hwcap(void)
>  
>  	elf_hwcap = 0;
>  
> +	bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
> +
>  	for_each_of_cpu_node(node) {
>  		unsigned long this_hwcap = 0;
> +		unsigned long this_isa = 0;
>  
>  		if (riscv_of_processor_hartid(node) < 0)
>  			continue;
> @@ -43,8 +89,20 @@ void riscv_fill_hwcap(void)
>  			continue;
>  		}
>  
> -		for (i = 0; i < strlen(isa); ++i)
> +		i = 0;
> +		isa_len = strlen(isa);
> +#if defined(CONFIG_32BIT)
> +		if (!strncmp(isa, "rv32", 4))
> +			i += 4;
> +#elif defined(CONFIG_64BIT)
> +		if (!strncmp(isa, "rv64", 4))
> +			i += 4;
> +#endif
> +		for (; i < isa_len; ++i) {
>  			this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
> +			if ('a' <= isa[i] && isa[i] <= 'z')
> +				this_isa |= (1UL << (isa[i] - 'a'));

Continuing from the earlier comment, this code won't properly handle the X 
and Z prefix extensions.  So maybe for the time being, we should just drop 
the lines mentioned earlier that imply that we can parse Z-prefix 
extensions, and change this line so it ignores X and Z letters?

Then a subsequent patch can add support for more complicated extension 
string parsing.


> +		}
>  
>  		/*
>  		 * All "okay" hart should have same isa. Set HWCAP based on
> @@ -55,6 +113,11 @@ void riscv_fill_hwcap(void)
>  			elf_hwcap &= this_hwcap;
>  		else
>  			elf_hwcap = this_hwcap;
> +
> +		if (riscv_isa[0])
> +			riscv_isa[0] &= this_isa;
> +		else
> +			riscv_isa[0] = this_isa;
>  	}
>  
>  	/* We don't support systems with F but without D, so mask those out
> @@ -64,7 +127,17 @@ void riscv_fill_hwcap(void)
>  		elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
>  	}
>  
> -	pr_info("elf_hwcap is 0x%lx\n", elf_hwcap);
> +	memset(print_str, 0, sizeof(print_str));
> +	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> +		if (riscv_isa[0] & BIT_MASK(i))
> +			print_str[j++] = (char)('a' + i);
> +	pr_info("riscv: ISA extensions %s\n", print_str);
> +
> +	memset(print_str, 0, sizeof(print_str));
> +	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
> +		if (elf_hwcap & BIT_MASK(i))
> +			print_str[j++] = (char)('a' + i);
> +	pr_info("riscv: ELF capabilities %s\n", print_str);
>  
>  #ifdef CONFIG_FPU
>  	if (elf_hwcap & (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D))
> -- 
> 2.17.1
> 
> 


- Paul

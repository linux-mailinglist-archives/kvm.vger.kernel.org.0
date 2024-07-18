Return-Path: <kvm+bounces-21854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 318CD9350CB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 18:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 546521C21313
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 16:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B5B145338;
	Thu, 18 Jul 2024 16:43:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0510F7407A;
	Thu, 18 Jul 2024 16:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321001; cv=none; b=fiALR8xqkRNecXEdSyzB5pW7kMHE0xxwpqeaKg2onco8Ericy4uQLIiyr9ol9t09XLcYNkNKl5BU6sNml9aOj+1HatN1c/72j0Ueplp7sZwhXMoPTAQTWaVtWD8oa5tsSM8OsGBLXkJAOdnSiysbYblhYF24Oe9n/7Y175xDKfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321001; c=relaxed/simple;
	bh=3K2FoxZJI8IVfJ/Ojm3BQv5IdOA4of5foZBfiZTHiTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZbacA5U4dSH3uJraWrDli4Lx6PHFkEnNCxpmFsFOt6isN/9UQtUIHWMUnzBOdSscgf9KDZbOyDZ2wj8xbfhRvhi+yHAMxy9S//+EuM6LK4S2LjqryhoWfJu2oDSI/CLgai4hDrMUhSV2CRSI4dQbS6QFnYdNcFeuLkF/5Mec6FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B39ED1BF205;
	Thu, 18 Jul 2024 16:43:05 +0000 (UTC)
Message-ID: <6ad0c386-6777-4467-bab4-8fba149f3bfe@ghiti.fr>
Date: Thu, 18 Jul 2024 18:43:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/4] RISC-V: Add Svade and Svadu Extensions Support
Content-Language: en-US
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 Conor Dooley <conor.dooley@microchip.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Atish Patra <atishp@rivosinc.com>, Samuel Ortiz <sameo@rivosinc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Leonardo Bras <leobras@redhat.com>,
 Charlie Jenkins <charlie@rivosinc.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jisheng Zhang <jszhang@kernel.org>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-2-yongxuan.wang@sifive.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240712083850.4242-2-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Yong-Xuan,

On 12/07/2024 10:38, Yong-Xuan Wang wrote:
> Svade and Svadu extensions represent two schemes for managing the PTE A/D
> bits. When the PTE A/D bits need to be set, Svade extension intdicates
> that a related page fault will be raised. In contrast, the Svadu extension
> supports hardware updating of PTE A/D bits. Since the Svade extension is
> mandatory and the Svadu extension is optional in RVA23 profile, by default
> the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> when only Svadu is present in DT.
>
> This patch detects Svade and Svadu extensions from DT and adds
> arch_has_hw_pte_young() to enable optimization in MGLRU and
> __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> support.
>
> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/Kconfig               |  1 +
>   arch/riscv/include/asm/csr.h     |  1 +
>   arch/riscv/include/asm/hwcap.h   |  2 ++
>   arch/riscv/include/asm/pgtable.h | 13 ++++++++++++-
>   arch/riscv/kernel/cpufeature.c   | 32 ++++++++++++++++++++++++++++++++
>   5 files changed, 48 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 0525ee2d63c7..3d705e28ff85 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -36,6 +36,7 @@ config RISCV
>   	select ARCH_HAS_PMEM_API
>   	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>   	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_HW_PTE_YOUNG
>   	select ARCH_HAS_SET_DIRECT_MAP if MMU
>   	select ARCH_HAS_SET_MEMORY if MMU
>   	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 25966995da04..524cd4131c71 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -195,6 +195,7 @@
>   /* xENVCFG flags */
>   #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>   #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>   #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>   #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>   #define ENVCFG_CBIE_SHIFT		4
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index e17d0078a651..35d7aa49785d 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -81,6 +81,8 @@
>   #define RISCV_ISA_EXT_ZTSO		72
>   #define RISCV_ISA_EXT_ZACAS		73
>   #define RISCV_ISA_EXT_XANDESPMU		74
> +#define RISCV_ISA_EXT_SVADE             75
> +#define RISCV_ISA_EXT_SVADU		76
>   
>   #define RISCV_ISA_EXT_XLINUXENVCFG	127
>   
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index aad8b8ca51f1..ec0cdacd7da0 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -120,6 +120,7 @@
>   #include <asm/tlbflush.h>
>   #include <linux/mm_types.h>
>   #include <asm/compat.h>
> +#include <asm/cpufeature.h>
>   
>   #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>   
> @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
>   }
>   
>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
> -#include <asm/cpufeature.h>
>   
>   static __always_inline bool has_svnapot(void)
>   {
> @@ -624,6 +624,17 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>   	return __pgprot(prot);
>   }
>   
> +/*
> + * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
> + * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
> + * DT.
> + */
> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> +static inline bool arch_has_hw_pte_young(void)
> +{
> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> +}
> +
>   /*
>    * THP functions
>    */
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 5ef48cb20ee1..b2c3fe945e89 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>   	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>   	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>   	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> +	__RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
> +	__RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
>   	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>   	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>   	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> @@ -554,6 +556,21 @@ static void __init riscv_fill_hwcap_from_isa_string(unsigned long *isa2hwcap)
>   			clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
>   		}
>   
> +		/*
> +		 * When neither Svade nor Svadu present in DT, it is technically
> +		 * unknown whether the platform uses Svade or Svadu. Supervisor may
> +		 * assume Svade to be present and enabled or it can discover based
> +		 * on mvendorid, marchid, and mimpid. When both Svade and Svadu present
> +		 * in DT, supervisor must assume Svadu turned-off at boot time. To use
> +		 * Svadu, supervisor must explicitly enable it using the SBI FWFT extension.
> +		 */
> +		if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> +		    !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> +			set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> +		else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> +			 test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> +			clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> +
>   		/*
>   		 * All "okay" hart should have same isa. Set HWCAP based on
>   		 * common capabilities of every "okay" hart, in case they don't
> @@ -619,6 +636,21 @@ static int __init riscv_fill_hwcap_from_ext_list(unsigned long *isa2hwcap)
>   
>   		of_node_put(cpu_node);
>   
> +		/*
> +		 * When neither Svade nor Svadu present in DT, it is technically
> +		 * unknown whether the platform uses Svade or Svadu. Supervisor may
> +		 * assume Svade to be present and enabled or it can discover based
> +		 * on mvendorid, marchid, and mimpid. When both Svade and Svadu present
> +		 * in DT, supervisor must assume Svadu turned-off at boot time. To use
> +		 * Svadu, supervisor must explicitly enable it using the SBI FWFT extension.
> +		 */
> +		if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> +		    !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> +			set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> +		else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> +			 test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> +			clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> +
>   		/*
>   		 * All "okay" harts should have same isa. Set HWCAP based on
>   		 * common capabilities of every "okay" hart, in case they don't.


Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex



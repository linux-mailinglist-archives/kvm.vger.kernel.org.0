Return-Path: <kvm+bounces-45087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 718E4AA5F3D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F7759C18BC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDB61AB6F1;
	Thu,  1 May 2025 13:33:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128501A314A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106409; cv=none; b=h6MP2bYHtXs/SzbsmYi9Ch2V+t1lDhG/fgWG3KwxSUKy7LlC/t/YtOqlPS2ZpIXkF4DXLu443fNC+h72wDyLEExaFtE9JQVq2nv5VmK5EgUc0tdrn755rudf1PAWFOy/z7YKiTrtOExvaajlSJhiSyFJulZP9c3XnXjpNBrWc5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106409; c=relaxed/simple;
	bh=gIw0yVMmwINoqVcG8GDhGRlFwrbyuTi70escyHOEk/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+3EMyFf8KJjHFyvsWCY830HUb0mKVQztVlnGbeVfMNbCMXrVf2lrhloS+5H62Gg0CEhWkuVaC8OMzX6eiyGy9HkGEwaXgT7E9W4lsZWendUz9RJQHpKaa/rc3fM4xmQkqslndQJcUh6RL5EJJU+1Aa/02IXkUXcLGuaVrXtf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B891A168F;
	Thu,  1 May 2025 06:33:19 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DA993F5A1;
	Thu,  1 May 2025 06:33:25 -0700 (PDT)
Date: Thu, 1 May 2025 14:33:22 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 28/42] KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
Message-ID: <20250501133322.GJ1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-29-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-29-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:22PM +0100, Marc Zyngier wrote:
> We do not have a computed table for HCRX_EL2, so statically define
> the bits we know about. A warning will fire if the architecture
> grows bits that are not handled yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_arm.h | 18 ++++++++++++++----
>  arch/arm64/kvm/emulate-nested.c  |  5 +++++
>  arch/arm64/kvm/nested.c          |  4 ++--
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index e7c73d16cd451..52b3aeb19efc6 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -315,10 +315,20 @@
>  				 GENMASK(19, 18) |	\
>  				 GENMASK(15, 0))
>  
> -/* Polarity masks for HCRX_EL2 */
> -#define __HCRX_EL2_RES0         HCRX_EL2_RES0
> -#define __HCRX_EL2_MASK		(BIT(6))
> -#define __HCRX_EL2_nMASK	~(__HCRX_EL2_RES0 | __HCRX_EL2_MASK)
> +/*
> + * Polarity masks for HCRX_EL2, limited to the bits that we know about
> + * at this point in time. It doesn't mean that we actually *handle*
> + * them, but that at least those that are not advertised to a guest
> + * will be RES0 for that guest.
> + */
> +#define __HCRX_EL2_MASK		(BIT_ULL(6))
> +#define __HCRX_EL2_nMASK	(GENMASK_ULL(24, 14) | \
> +				 GENMASK_ULL(11, 7)  | \
> +				 GENMASK_ULL(5, 0))
> +#define __HCRX_EL2_RES0		~(__HCRX_EL2_nMASK | __HCRX_EL2_MASK)
> +#define __HCRX_EL2_RES1		~(__HCRX_EL2_nMASK | \
> +				  __HCRX_EL2_MASK  | \
> +				  __HCRX_EL2_RES0)

Convoluted way of writing 0, but it makes sense!

>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index c30d970bf81cb..c581cf29bc59e 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2157,6 +2157,7 @@ int __init populate_nv_trap_config(void)
>  	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
>  	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
>  	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
> +	BUILD_BUG_ON(__HCRX_EL2_MASK & __HCRX_EL2_nMASK);
>  
>  	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
>  		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
> @@ -2182,6 +2183,10 @@ int __init populate_nv_trap_config(void)
>  		}
>  	}
>  
> +	if (__HCRX_EL2_RES0 != HCRX_EL2_RES0)
> +		kvm_info("Sanitised HCR_EL2_RES0 = %016llx, expecting %016llx\n",
> +			 __HCRX_EL2_RES0, HCRX_EL2_RES0);
> +
>  	kvm_info("nv: %ld coarse grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_cgt));
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 479ffd25eea63..666df85230c9b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1058,8 +1058,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
>  
>  	/* HCRX_EL2 */
> -	res0 = HCRX_EL2_RES0;
> -	res1 = HCRX_EL2_RES1;
> +	res0 = __HCRX_EL2_RES0;
> +	res1 = __HCRX_EL2_RES1;
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
>  		res0 |= HCRX_EL2_PACMEn;
>  	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
> -- 
> 2.39.2
> 


Return-Path: <kvm+bounces-40750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5312A5BA6A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65A0E189168F
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10F5224224;
	Tue, 11 Mar 2025 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jLxCzslc"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6E71EB9E8
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741680321; cv=none; b=rQwI81cvADIi7EX9eFYJ5cI+bpidqQy9WKe3izJMgso+V4K49Bf/2ArlDzI0Lxwux617fRoE08rtUvCfBUrO3T8tqzTQLR0AryUDpHrg/384PGVJFd1BFNoIQkXCLrQkun0ub0ybIb5yRnxyz6X4j84nMSSkslnc1PYY8pjIMcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741680321; c=relaxed/simple;
	bh=f9GgyKlgz40K7OCYckltu7XNEMChc55zyDT/Pqpng3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O57IOO+lb7EQ5wwf3Bo3BZtFC2UdKETyfkPlKK030VXPcriEt7nK3jbarZ8Ga9QOjYiaxjoueSxkFFnD83pJ409CyWGVOy+e39E75sXnQ4VgzKAlrRe3QHFZklzm4iT2/EYZjlPRPR8Z/bAmGTlQtceyYkd0pVMfY/OBvfiCb40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jLxCzslc; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 11 Mar 2025 01:05:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741680316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RAYFqIJlHKyWKw1zT75h7lHBHX+DTmxUr/wIvnOdyrw=;
	b=jLxCzslcec0OsCOjhfULLAcEuIzEXocTLubSRZU/3vUw9+V04MLn0CDiJpn8y/UDUQTjcM
	F0x5lUrgtOVBgvhQdSd5XwGyt41o2YYaT69wqIUhUi8I2Uf778+xbFbeOBwM0r2VB6O08H
	tLdmKd+OjG4x7OEMdOrRxpHNCf6drp8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zhenyu Ye <yezhenyu2@huawei.com>
Cc: maz@kernel.org, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, joey.gouly@arm.com,
	linux-kernel@vger.kernel.org, xiexiangyou@huawei.com,
	zhengchuan@huawei.com, wangzhou1@hisilicon.com,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 3/5] arm64/kvm: using ioctl to enable/disable the
 HDBSS feature
Message-ID: <Z8_usklidqnerurc@linux.dev>
References: <20250311040321.1460-1-yezhenyu2@huawei.com>
 <20250311040321.1460-4-yezhenyu2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311040321.1460-4-yezhenyu2@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 11, 2025 at 12:03:19PM +0800, Zhenyu Ye wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d919557af5e5..bd73ee92b12c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -787,6 +787,12 @@ struct kvm_vcpu_arch {
>  
>  	/* Per-vcpu CCSIDR override or NULL */
>  	u32 *ccsidr;
> +
> +	/* HDBSS registers info */
> +	struct {
> +		u64 br_el2;
> +		u64 prod_el2;
> +	} hdbss;

I'm not a fan of storing the raw system register values in the vCPU
struct. I'd rather we kept track of the buffer base address, size, and
index as three separate fields.

>  };
>  
>  /*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index b98ac6aa631f..ed5b68c2085e 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -330,6 +330,18 @@ static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
>  	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>  }
>  
> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	if (!vcpu->kvm->enable_hdbss)
> +		return;
> +
> +	write_sysreg_s(vcpu->arch.hdbss.br_el2, SYS_HDBSSBR_EL2);
> +	write_sysreg_s(vcpu->arch.hdbss.prod_el2, SYS_HDBSSPROD_EL2);
> +
> +	dsb(sy);
> +	isb();

What are you synchronizing against here? dsb(sy) is a *huge* hammer. A
dsb() in this context would only make sense if there were pending stores
to the dirty tracking structure, which ought not be the case at load.

Also keep in mind the EL1&0 regime is out of context...

> +}
> +
>  static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>  {
>  	return container_of(mmu->arch, struct kvm, arch);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b727772c06fb..3040eac74f8c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1105,6 +1105,18 @@
>  #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>  					       GCS_CAP_VALID_TOKEN)
>  
> +/*
> + * Definitions for the HDBSS feature
> + */
> +#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
> +
> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
> +				 ((sz) << HDBSSBR_EL2_SZ_SHIFT))
> +#define HDBSSBR_BADDR(br)	((br) & GENMASK(55, (12 + HDBSSBR_SZ(br))))
> +#define HDBSSBR_SZ(br)		(((br) & HDBSSBR_EL2_SZ_MASK) >> HDBSSBR_EL2_SZ_SHIFT)
> +
> +#define HDBSSPROD_IDX(prod)	(((prod) & HDBSSPROD_EL2_INDEX_MASK) >> HDBSSPROD_EL2_INDEX_SHIFT)
> +
>  #define ARM64_FEATURE_FIELD_BITS	4
>  
>  /* Defined for compatibility only, do not add new users. */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0160b4924351..825cfef3b1c2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -80,6 +80,70 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
>  
> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
> +				    struct kvm_enable_cap *cap)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +	struct page *hdbss_pg;
> +	int size = cap->args[0];
> +
> +	if (!system_supports_hdbss()) {
> +		kvm_err("This system does not support HDBSS!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (size < 0 || size > HDBSS_MAX_SIZE) {
> +		kvm_err("Invalid HDBSS buffer size: %d!\n", size);
> +		return -EINVAL;
> +	}
> +
> +	/* Enable the HDBSS feature if size > 0, otherwise disable it. */
> +	if (size) {
> +		kvm->enable_hdbss = true;
> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;

Nothing prevents a vCPU from using a VTCR value with HDBSS enabled
before a tracking structure has been allocated.

> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			hdbss_pg = alloc_pages(GFP_KERNEL, size);

GFP_KERNEL_ACCOUNT

> +			if (!hdbss_pg) {
> +				kvm_err("Alloc HDBSS buffer failed!\n");
> +				return -EINVAL;
> +			}

enable_hdbss and vtcr aren't cleaned up in this case, and EINVAL is an
inappopriate return for a failed memory allocation.

> +			vcpu->arch.hdbss.br_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), size);
> +			vcpu->arch.hdbss.prod_el2 = 0;
> +
> +			/*
> +			 * We should kick vcpus out of guest mode here to
> +			 * load new vtcr value to vtcr_el2 register when
> +			 * re-enter guest mode.
> +			 */
> +			kvm_vcpu_kick(vcpu);

VTCR_EL2 is configured on vcpu_load() for VHE. How is this expected to
work?

> +		}
> +
> +		kvm_info("Enable HDBSS success, HDBSS buffer size: %d\n", size);

Drop the debugging printks.

> +	} else if (kvm->enable_hdbss) {
> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			/* Kick vcpus to flush hdbss buffer. */
> +			kvm_vcpu_kick(vcpu);
> +
> +			hdbss_pg = phys_to_page(HDBSSBR_BADDR(vcpu->arch.hdbss.br_el2));
> +			if (hdbss_pg)
> +				__free_pages(hdbss_pg, HDBSSBR_SZ(vcpu->arch.hdbss.br_el2));
> +
> +			vcpu->arch.hdbss.br_el2 = 0;
> +			vcpu->arch.hdbss.prod_el2 = 0;
> +		}
> +
> +		kvm->enable_hdbss = false;
> +		kvm_info("Disable HDBSS success\n");
> +	}
> +
> +	return 0;
> +}
> +
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			    struct kvm_enable_cap *cap)
>  {
> @@ -125,6 +189,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->slots_lock);
>  		break;
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -393,6 +460,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
>  		r = BIT(0);
>  		break;
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		r = system_supports_hdbss();
> +		break;

I'm not sure this is creating the right abstraction for userspace. At
least for the dirty bitmap, this is exposing an implementation detail to
the VMM.

You could, perhaps, associate the dirty tracking structure with a
similar concept (e.g. vCPU dirty rings) available to userspace.

>  	default:
>  		r = 0;
>  	}
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 647737d6e8d0..6b633a219e4d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -256,6 +256,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  	__vcpu_load_switch_sysregs(vcpu);
>  	__vcpu_load_activate_traps(vcpu);
>  	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
> +	__load_hdbss(vcpu);
>  }
>  
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f55b0c7b11d..9c11e2292b1e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1703,6 +1703,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (writable)
>  		prot |= KVM_PGTABLE_PROT_W;
>  
> +	if (kvm->enable_hdbss && logging_active)
> +		prot |= KVM_PGTABLE_PROT_DBM;
> +

We should set DBM if the mapping is PTE sized. That way you can
potentially avoid faults for pages that precede the dirty tracking
enable.

Thanks,
Oliver


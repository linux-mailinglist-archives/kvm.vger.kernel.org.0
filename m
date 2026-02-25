Return-Path: <kvm+bounces-71862-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMmSL5s3n2m5ZQQAu9opvQ
	(envelope-from <kvm+bounces-71862-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:55:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBC219BD6C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 867D83084F2B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42EC23ECBFC;
	Wed, 25 Feb 2026 17:54:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E0D3E9590;
	Wed, 25 Feb 2026 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042098; cv=none; b=mWz/ygpCOJnksPc+MH+xQFqX/OaL6g3i6aLucvGrSIbAJ2F9rrpUsMuWavm9gz6Uq1FK5+6mjug6u3UznSCi56Ks2yQJrH2eA/OHNiDaRVVKw71Nh2nP8c42wrPOgP+u583fRq2RpbuX3f6rKnY4b2a+9xf5JTQXgwzVdmF+9+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042098; c=relaxed/simple;
	bh=wmmRsmNbX1VVdCQXpl1CyDiba5KcFA/5yxIPpYQuUks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=M2oWfHmBAR59LNHNBZ7B2eE4cskIod4Q6zPE8f31Otn9zivc/W0FvwhDey8hPAbrxfszhe+Pqwukj5i0c7r7PFV/gpt77FjA2RGYafcnGEfRQ1vUYPDw7xmy/WPr1054UslDcNaEh0Zrzubp4KsK+EPGa3esJnZlWiQlvzdifp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BBAA15A1;
	Wed, 25 Feb 2026 09:47:04 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 805893F62B;
	Wed, 25 Feb 2026 09:47:07 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF events
Date: Wed, 25 Feb 2026 17:46:58 +0000
Message-ID: <aZ81kn2PLuf5Ifm5@devkitleo>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225040421.2683931-5-zhengtian10@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <20260225040421.2683931-5-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71862-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leo.bras@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email]
X-Rspamd-Queue-Id: 5EBC219BD6C
X-Rspamd-Action: no action

Hi Tian, eillon,

On Wed, Feb 25, 2026 at 12:04:20PM +0800, Tian Zheng wrote:
> From: eillon <yezhenyu2@huawei.com>
> 
> HDBSS is enabled via an ioctl from userspace (e.g. QEMU) at the start of
> migration. This feature is only supported in VHE mode.

I wonder if it would not be better just to use the feature if available, 
instead of needing to have userspace enabling it.

> Initially, S2 PTEs doesn't contain the DBM attribute. During migration,
> write faults are handled by user_mem_abort, which relaxes permissions
> and adds the DBM bit when HDBSS is active. Once DBM is set, subsequent
> writes no longer trap, as the hardware automatically transitions the page
> from writable-clean to writable-dirty.

That way we have to actually take a fault for every write you do after 
migration starts.

What if, instead, we put the DBM bit in every memory faulted as writable 
(or better, due to a write fault), so from the beginning of the VM we 
know if memory is RO, WC (writable-clean) or WD (writable-dirty).

On top of that, we don't actually have to take faults when migration 
starts, as HDBSS is tracking it all.

> 
> KVM does not scan S2 page tables to consume DBM.

You mean dirty pages?
If so, it will actually use dirty-log or dirty-rings to track the dirty 
pages, and not scan S2 on every iteration.

> Instead, when HDBSS is
> enabled, the hardware observes the clean->dirty transition and records
> the corresponding page into the HDBSS buffer.
> 
> During sync_dirty_log, KVM kicks all vCPUs to force VM-Exit, ensuring
> that check_vcpu_requests flushes the HDBSS buffer and propagates the
> accumulated dirty information into the userspace-visible dirty bitmap.
> 
> Add fault handling for HDBSS including buffer full, external abort, and
> general protection fault (GPF).
> 
> Signed-off-by: eillon <yezhenyu2@huawei.com>
> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> ---
>  arch/arm64/include/asm/esr.h      |   5 ++
>  arch/arm64/include/asm/kvm_host.h |  17 +++++
>  arch/arm64/include/asm/kvm_mmu.h  |   1 +
>  arch/arm64/include/asm/sysreg.h   |  11 ++++
>  arch/arm64/kvm/arm.c              | 102 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c   |  19 ++++++
>  arch/arm64/kvm/mmu.c              |  70 ++++++++++++++++++++
>  arch/arm64/kvm/reset.c            |   3 +
>  8 files changed, 228 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 81c17320a588..2e6b679b5908 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,6 +437,11 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
> 
> +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> +{
> +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
> +}
> +
>  static inline unsigned long esr_brk_comment(unsigned long esr)
>  {
>  	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..57ee6b53e061 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -55,12 +55,17 @@
>  #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
>  #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
>  #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> 
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>  				     KVM_DIRTY_LOG_INITIALLY_SET)
> 
>  #define KVM_HAVE_MMU_RWLOCK
> 
> +/* HDBSS entry field definitions */
> +#define HDBSS_ENTRY_VALID BIT(0)
> +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
> +
>  /*
>   * Mode of operation configurable with kvm-arm.mode early param.
>   * See Documentation/admin-guide/kernel-parameters.txt for more information.
> @@ -84,6 +89,7 @@ int __init kvm_arm_init_sve(void);
>  u32 __attribute_const__ kvm_target_cpu(void);
>  void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>  void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> 
>  struct kvm_hyp_memcache {
>  	phys_addr_t head;
> @@ -405,6 +411,8 @@ struct kvm_arch {
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
>  	struct kvm_protected_vm pkvm;
> +
> +	bool enable_hdbss;
>  };
> 
>  struct kvm_vcpu_fault_info {
> @@ -816,6 +824,12 @@ struct vcpu_reset_state {
>  	bool		reset;
>  };
> 
> +struct vcpu_hdbss_state {
> +	phys_addr_t base_phys;
> +	u32 size;
> +	u32 next_index;
> +};
> +
>  struct vncr_tlb;
> 
>  struct kvm_vcpu_arch {
> @@ -920,6 +934,9 @@ struct kvm_vcpu_arch {
> 
>  	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>  	struct vncr_tlb	*vncr_tlb;
> +
> +	/* HDBSS registers info */
> +	struct vcpu_hdbss_state hdbss;
>  };
> 
>  /*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d968aca0461a..3fea8cfe8869 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -183,6 +183,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> 
>  int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> 
>  phys_addr_t kvm_mmu_get_httbr(void);
>  phys_addr_t kvm_get_idmap_vector(void);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index f4436ecc630c..d11f4d0dd4e7 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1039,6 +1039,17 @@
> 
>  #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>  					       GCS_CAP_VALID_TOKEN)
> +
> +/*
> + * Definitions for the HDBSS feature
> + */
> +#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
> +
> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
> +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
> +
> +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
> +

Do we actually need the GENMASK above? Could not we use just the 
HDBSSBR_EL2_BADDR_MASK? 

If the base address received in alloc_pages is not properly aligned, we 
might end up writing in some different memory region that we allocated on.

If you want to actually make sure the mem region is aligned, check just 
after it's allocated, instead of silently masking it at this moment.   

In any case, I wonder if we actually need above defines, as it looks they 
could easily be replaced by what they do.


>  /*
>   * Definitions for GICv5 instructions
>   */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 29f0326f7e00..d64da05e25c4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -125,6 +125,87 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
> 
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct page *hdbss_pg;
> +
> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
> +	if (hdbss_pg)
> +		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
> +
> +	vcpu->arch.hdbss.size = 0;
> +}
> +
> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
> +				    struct kvm_enable_cap *cap)
> +{
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +	struct page *hdbss_pg = NULL;
> +	__u64 size = cap->args[0];
> +	bool enable = cap->args[1] ? true : false;
> +
> +	if (!system_supports_hdbss())
> +		return -EINVAL;
> +
> +	if (size > HDBSS_MAX_SIZE)
> +		return -EINVAL;
> +
> +	if (!enable && !kvm->arch.enable_hdbss) /* Already Off */
> +		return 0;
> +
> +	if (enable && kvm->arch.enable_hdbss) /* Already On, can't set size */
> +		return -EINVAL;
> +
> +	if (!enable) { /* Turn it off */
> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			/* Kick vcpus to flush hdbss buffer. */
> +			kvm_vcpu_kick(vcpu);
> +
> +			kvm_arm_vcpu_free_hdbss(vcpu);
> +		}
> +
> +		kvm->arch.enable_hdbss = false;
> +
> +		return 0;
> +	}
> +
> +	/* Turn it on */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
> +		if (!hdbss_pg)
> +			goto error_alloc;
> +
> +		vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> +			.base_phys = page_to_phys(hdbss_pg),
> +			.size = size,
> +			.next_index = 0,
> +		};
> +	}
> +
> +	kvm->arch.enable_hdbss = true;
> +	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
> +
> +	/*
> +	 * We should kick vcpus out of guest mode here to load new
> +	 * vtcr value to vtcr_el2 register when re-enter guest mode.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_kick(vcpu);
> +
> +	return 0;
> +
> +error_alloc:
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.hdbss.base_phys)
> +			kvm_arm_vcpu_free_hdbss(vcpu);
> +	}
> +
> +	return -ENOMEM;
> +}
> +
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			    struct kvm_enable_cap *cap)
>  {
> @@ -182,6 +263,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
>  		break;
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		mutex_lock(&kvm->lock);
> +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;

If we prefer using a ioctl, I wonder if it would not be better to have a 
arch-generic option that enables hw dirty-bit tracking, and all archs could 
use it to implement their versions when available. 

I guess any VMM would have a much easier time doing it once, than for every 
arch they support.

>  	default:
>  		break;
>  	}
> @@ -471,6 +557,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  			r = kvm_supports_cacheable_pfnmap();
>  		break;
> 
> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> +		r = system_supports_hdbss();
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -1120,6 +1209,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_dirty_ring_check_request(vcpu))
>  			return 0;
> 
> +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> +			kvm_flush_hdbss_buffer(vcpu);
> +
>  		check_nested_vcpu_requests(vcpu);
>  	}
> 
> @@ -1898,7 +1990,17 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> 
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
> +	/*
> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> +	 * before reporting dirty_bitmap to userspace. Send a request with
> +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> +	 */
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> 
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS);
>  }
> 
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9db3f11a4754..600cbc4f8ae9 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -213,6 +213,23 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
>  	local_irq_restore(flags);
>  }
> 
> +static void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 br_el2, prod_el2;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +	prod_el2 = vcpu->arch.hdbss.next_index;
> +
> +	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
> +	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
> +
> +	isb();
> +}
> +
>  void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  {
>  	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
> @@ -220,10 +237,12 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  	__vcpu_load_switch_sysregs(vcpu);
>  	__vcpu_load_activate_traps(vcpu);
>  	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
> +	__load_hdbss(vcpu);
>  }
> 
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>  {
> +	kvm_flush_hdbss_buffer(vcpu);
>  	__vcpu_put_deactivate_traps(vcpu);
>  	__vcpu_put_switch_sysregs(vcpu);
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 070a01e53fcb..42b0710a16ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1896,6 +1896,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (writable)
>  		prot |= KVM_PGTABLE_PROT_W;
> 
> +	if (writable && kvm->arch.enable_hdbss && logging_active)
> +		prot |= KVM_PGTABLE_PROT_DBM;
> +
>  	if (exec_fault)
>  		prot |= KVM_PGTABLE_PROT_X;
> 
> @@ -2033,6 +2036,70 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> 
> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> +{
> +	int idx, curr_idx;
> +	u64 br_el2;
> +	u64 *hdbss_buf;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> +
> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> +	if (curr_idx == 0 || br_el2 == 0)
> +		return;
> +
> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> +	if (!hdbss_buf)
> +		return;
> +
> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> +	for (idx = 0; idx < curr_idx; idx++) {
> +		u64 gpa;
> +
> +		gpa = hdbss_buf[idx];
> +		if (!(gpa & HDBSS_ENTRY_VALID))
> +			continue;
> +
> +		gpa &= HDBSS_ENTRY_IPA;
> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> +	}
> +
> +	/* reset HDBSS index */
> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
> +	vcpu->arch.hdbss.next_index = 0;
> +	isb();
> +}
> +
> +static int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
> +{
> +	u64 prod;
> +	u64 fsc;
> +
> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
> +
> +	switch (fsc) {
> +	case HDBSSPROD_EL2_FSC_OK:
> +		/* Buffer full, which is reported as permission fault. */
> +		kvm_flush_hdbss_buffer(vcpu);
> +		return 1;
> +	case HDBSSPROD_EL2_FSC_ExternalAbort:
> +	case HDBSSPROD_EL2_FSC_GPF:
> +		return -EFAULT;
> +	default:
> +		/* Unknown fault. */
> +		WARN_ONCE(1,
> +				"Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
> +				fsc, prod, vcpu->vcpu_id);
> +		return -EFAULT;
> +	}
> +}
> +
>  /**
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:	the VCPU pointer
> @@ -2071,6 +2138,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> 
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> 
> +	if (esr_iss2_is_hdbssf(esr))
> +		return kvm_handle_hdbss_fault(vcpu);
> +
>  	if (esr_fsc_is_translation_fault(esr)) {
>  		/* Beyond sanitised PARange (which is the IPA limit) */
>  		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a..c03a4b310b53 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>  	kfree(vcpu->arch.vncr_tlb);
>  	kfree(vcpu->arch.ccsidr);
> +
> +	if (vcpu->kvm->arch.enable_hdbss)
> +		kvm_arm_vcpu_free_hdbss(vcpu);
>  }
> 
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> --
> 2.33.0
> 

Thx,
Leo


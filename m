Return-Path: <kvm+bounces-50348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC34AE4268
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C042B1898842
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF02C24BBE4;
	Mon, 23 Jun 2025 13:17:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4091798F;
	Mon, 23 Jun 2025 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684653; cv=none; b=qjYZaoKx2TwTFIGN8+SKGnVBHCeuirFKwJFcwhzUVhFzvDEEL/oCV9uExu1eQDlsx7QyF1kmSNEK5Idf9/h2Lekosy+OTsqg6TSceDMRG9Dgs55zHqJ9gDVIwJEEQvYVKJ/JoF68vxDNLExDAFL6SsAgStdt1pJn64ylkPkWo+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684653; c=relaxed/simple;
	bh=lJCWiILZyg1MpwvCQR5TLdJxWEZrSrW7BktfgB2ZZbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DDkHlTjdkhOJl2FJPhAXYaJjhA5qxh13H47LdnEqxAKObe/UTcmlgID9LPqRsPUIHNSxQMXAqiZ17q0qCsngFFOBn39RVOz36iO698Kk7fN+CJSOUN5plar+HdRIiecRub8K5UxxRAH0yvJXeKOVNfPi/x/6qaZVvxs4irbZdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bQpVc46l3z2BdVD;
	Mon, 23 Jun 2025 21:15:52 +0800 (CST)
Received: from kwepemo100012.china.huawei.com (unknown [7.202.195.139])
	by mail.maildlp.com (Postfix) with ESMTPS id 074711A016C;
	Mon, 23 Jun 2025 21:17:27 +0800 (CST)
Received: from [10.174.155.142] (10.174.155.142) by
 kwepemo100012.china.huawei.com (7.202.195.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 23 Jun 2025 21:17:25 +0800
Message-ID: <b3b709c2-a154-4b1a-b6bd-7075e6a57fd2@huawei.com>
Date: Mon, 23 Jun 2025 21:17:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/43] arm64: RME: ioctls to create and configure
 realms
To: Steven Price <steven.price@arm.com>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
CC: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	<linux-coco@lists.linux.dev>, Ganapatrao Kulkarni
	<gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, Shanker
 Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, "Aneesh
 Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
	<zhouguangwei5@huawei.com>, <wangyuan46@huawei.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-8-steven.price@arm.com>
From: zhuangyiwei <zhuangyiwei@huawei.com>
In-Reply-To: <20250611104844.245235-8-steven.price@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo100012.china.huawei.com (7.202.195.139)

Hi Steven

On 2025/6/11 18:48, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_RD ioctl to create a realm. This involves
> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
>
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created. Configuration options can be classified as:
>
>   1. Parameters specific to the Realm stage2 (e.g. IPA Size, vmid, stage2
>      entry level, entry level RTTs, number of RTTs in start level, LPA2)
>      Most of these are not measured by RMM and comes from KVM book
>      keeping.
>
>   2. Parameters controlling "Arm Architecture features for the VM". (e.g.
>      SVE VL, PMU counters, number of HW BRPs/WPs), configured by the VMM
>      using the "user ID register write" mechanism. These will be
>      supported in the later patches.
>
>   3. Parameters are not part of the core Arm architecture but defined
>      by the RMM spec (e.g. Hash algorithm for measurement,
>      Personalisation value). These are programmed via
>      KVM_CAP_ARM_RME_CONFIG_REALM.
>
> For the IPA size there is the possibility that the RMM supports a
> different size to the IPA size supported by KVM for normal guests. At
> the moment the 'normal limit' is exposed by KVM_CAP_ARM_VM_IPA_SIZE and
> the IPA size is configured by the bottom bits of vm_type in
> KVM_CREATE_VM. This means that it isn't easy for the VMM to discover
> what IPA sizes are supported for Realm guests. Since the IPA is part of
> the measurement of the realm guest the current expectation is that the
> VMM will be required to pick the IPA size demanded by attestation and
> therefore simply failing if this isn't available is fine. An option
> would be to expose a new capability ioctl to obtain the RMM's maximum
> IPA size if this is needed in the future.
>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v8:
>   * Fix free_delegated_granule() to not call kvm_account_pgtable_pages();
>     a separate wrapper will be introduced in a later patch to deal with
>     RTTs.
>   * Minor code cleanups following review.
> Changes since v7:
>   * Minor code cleanup following Gavin's review.
> Changes since v6:
>   * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
>     host page size to be larger than 4k while still communicating with an
>     RMM which uses 4k granules.
> Changes since v5:
>   * Introduce free_delegated_granule() to replace many
>     undelegate/free_page() instances and centralise the comment on
>     leaking when the undelegate fails.
>   * Several other minor improvements suggested by reviews - thanks for
>     the feedback!
> Changes since v2:
>   * Improved commit description.
>   * Improved return failures for rmi_check_version().
>   * Clear contents of PGD after it has been undelegated in case the RMM
>     left stale data.
>   * Minor changes to reflect changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   5 +
>   arch/arm64/include/asm/kvm_rme.h     |  19 ++
>   arch/arm64/kvm/arm.c                 |  16 ++
>   arch/arm64/kvm/mmu.c                 |  22 +-
>   arch/arm64/kvm/rme.c                 | 321 +++++++++++++++++++++++++++
>   5 files changed, 381 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 020ced82e5e3..a640bb7dffbc 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -704,6 +704,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>   	return READ_ONCE(kvm->arch.realm.state);
>   }
>   
> +static inline bool kvm_realm_is_created(struct kvm *kvm)
> +{
> +	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
> +}
> +
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	return false;
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 9c8a0b23e0e4..5dc1915de891 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,8 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <uapi/linux/kvm.h>
> +
>   /**
>    * enum realm_state - State of a Realm
>    */
> @@ -46,11 +48,28 @@ enum realm_state {
>    * struct realm - Additional per VM data for a Realm
>    *
>    * @state: The lifetime state machine for the realm
> + * @rd: Kernel mapping of the Realm Descriptor (RD)
> + * @params: Parameters for the RMI_REALM_CREATE command
> + * @num_aux: The number of auxiliary pages required by the RMM
> + * @vmid: VMID to be used by the RMM for the realm
> + * @ia_bits: Number of valid Input Address bits in the IPA
>    */
>   struct realm {
>   	enum realm_state state;
> +
> +	void *rd;
> +	struct realm_params *params;
> +
> +	unsigned long num_aux;
> +	unsigned int vmid;
> +	unsigned int ia_bits;
>   };
>   
>   void kvm_init_rme(void);
> +u32 kvm_realm_ipa_limit(void);
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int kvm_init_realm_vm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);
>   
>   #endif /* __ASM_KVM_RME_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 59dc992274fa..d1f9ab08c5ac 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -136,6 +136,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		mutex_lock(&kvm->lock);
> +		r = kvm_realm_enable_cap(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		break;
>   	}
> @@ -198,6 +203,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>   
> +	/* Initialise the realm bits after the generic bits are enabled */
> +	if (kvm_is_realm(kvm)) {
> +		ret = kvm_init_realm_vm(kvm);
> +		if (ret)
> +			goto err_free_cpumask;
> +	}
> +
>   	return 0;
>   
>   err_free_cpumask:
> @@ -257,6 +269,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_unshare_hyp(kvm, kvm + 1);
>   
>   	kvm_arm_teardown_hypercalls(kvm);
> +	kvm_destroy_realm(kvm);
>   }
>   
>   static bool kvm_has_full_ptr_auth(void)
> @@ -411,6 +424,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
>   		r = BIT(0);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		r = static_key_enabled(&kvm_rme_is_available);
> +		break;
>   	default:
>   		r = 0;
>   	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2942ec92c5a4..d654a817c063 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -876,12 +876,16 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.icache_inval_pou	= invalidate_icache_guest_page,
>   };
>   
> -static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
> +static int kvm_init_ipa_range(struct kvm *kvm,
> +			      struct kvm_s2_mmu *mmu, unsigned long type)
>   {
>   	u32 kvm_ipa_limit = get_kvm_ipa_limit();
>   	u64 mmfr0, mmfr1;
>   	u32 phys_shift;
>   
> +	if (kvm_is_realm(kvm))
> +		kvm_ipa_limit = kvm_realm_ipa_limit();
> +
>   	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>   		return -EINVAL;
>   
> @@ -946,7 +950,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   		return -EINVAL;
>   	}
>   
> -	err = kvm_init_ipa_range(mmu, type);
> +	err = kvm_init_ipa_range(kvm, mmu, type);
>   	if (err)
>   		return err;
>   
> @@ -1072,6 +1076,20 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	struct kvm_pgtable *pgt = NULL;
>   
>   	write_lock(&kvm->mmu_lock);
> +	if (kvm_is_realm(kvm) &&
> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		/* Tearing down RTTs will be added in a later patch */
> +		write_unlock(&kvm->mmu_lock);
> +
> +		/*
> +		 * The physical PGD pages are delegated to the RMM, so cannot
> +		 * be freed at this point. This function will be called again
> +		 * from kvm_destroy_realm() after the physical pages have been
> +		 * returned at which point the memory can be freed.
> +		 */
> +		return;
> +	}
>   	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 67cf2d94cb2d..73261b39f556 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -5,9 +5,23 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/rmi_cmds.h>
>   #include <asm/virt.h>
>   
> +#include <asm/kvm_pgtable.h>
> +
> +static unsigned long rmm_feat_reg0;
> +
> +#define RMM_PAGE_SHIFT		12
> +#define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
> +
> +static bool rme_has_feature(unsigned long feature)
> +{
> +	return !!u64_get_bits(rmm_feat_reg0, feature);
> +}
> +
>   static int rmi_check_version(void)
>   {
>   	struct arm_smccc_res res;
> @@ -42,6 +56,307 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +u32 kvm_realm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
> +static int get_start_level(struct realm *realm)
> +{
> +	/*
> +	 * Open coded version of 4 - stage2_pgtable_levels(ia_bits) but using
> +	 * the RMM's page size rather than the host's.
> +	 */
> +	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> +}
> +
> +static int free_delegated_granule(phys_addr_t phys)
> +{
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return -EBUSY;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +
> +	return 0;
> +}
> +
> +/* Calculate the number of s2 root rtts needed */
> +static int realm_num_root_rtts(struct realm *realm)
> +{
> +	unsigned int ipa_bits = realm->ia_bits;
> +	unsigned int levels = 4 - get_start_level(realm);
> +	unsigned int sl_ipa_bits = levels * (RMM_PAGE_SHIFT - 3) +
> +				   RMM_PAGE_SHIFT;
> +
> +	if (sl_ipa_bits >= ipa_bits)
> +		return 1;
> +
> +	return 1 << (ipa_bits - sl_ipa_bits);
> +}
> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int i, r;
> +	int rtt_num_start;
> +
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	rtt_num_start = realm_num_root_rtts(realm);
> +
> +	if (WARN_ON(realm->rd || !realm->params))
> +		return -EEXIST;
> +
> +	if (pgd_size / RMM_PAGE_SIZE < rtt_num_start)
> +		return -EINVAL;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_granule_delegate(rd_phys)) {
> +		r = -ENXIO;
> +		goto free_rd;
> +	}
> +
> +	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (rmi_granule_delegate(pgd_phys)) {
> +			r = -ENXIO;
> +			goto out_undelegate_tables;
> +		}
> +	}
> +
> +	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
> +	params->rtt_level_start = get_start_level(realm);
> +	params->rtt_num_start = rtt_num_start;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +	params->vmid = realm->vmid;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +		WARN_ON(rmi_realm_destroy(rd_phys));

Since r has not been initialized, "goto out_undelegate_tables" leads to

return unknown value.

> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	while (i > 0) {
> +		i -= RMM_PAGE_SIZE;
> +
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys))) {
> +			/* Leak the pages if they cannot be returned */
> +			kvm->arch.mmu.pgt = NULL;
> +			break;
> +		}
> +	}
> +	if (WARN_ON(rmi_granule_undelegate(rd_phys))) {
> +		/* Leak the page if it isn't returned */
> +		return r;
> +	}
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +
> +/* Protects access to rme_vmid_bitmap */
> +static DEFINE_SPINLOCK(rme_vmid_lock);
> +static unsigned long *rme_vmid_bitmap;
> +
> +static int rme_vmid_init(void)
> +{
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
> +	if (!rme_vmid_bitmap) {
> +		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rme_vmid_reserve(void)
> +{
> +	int ret;
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	spin_lock(&rme_vmid_lock);
> +	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
> +	spin_unlock(&rme_vmid_lock);
> +
> +	return ret;
> +}
> +
> +static void rme_vmid_release(unsigned int vmid)
> +{
> +	spin_lock(&rme_vmid_lock);
> +	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
> +	spin_unlock(&rme_vmid_lock);
> +}
> +
> +static int kvm_create_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	int ret;
> +
> +	if (kvm_realm_is_created(kvm))
> +		return -EEXIST;
> +
> +	ret = rme_vmid_reserve();
> +	if (ret < 0)
> +		return ret;
> +	realm->vmid = ret;
> +
> +	ret = realm_create_rd(kvm);
> +	if (ret) {
> +		rme_vmid_release(realm->vmid);
> +		return ret;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
> +
> +	/* The realm is up, free the parameters.  */
> +	free_page((unsigned long)realm->params);
> +	realm->params = NULL;
> +
> +	return 0;
> +}
> +
> +static int config_realm_hash_algo(struct realm *realm,
> +				  struct arm_rme_config *cfg)
> +{
> +	switch (cfg->hash_algo) {
> +	case ARM_RME_CONFIG_HASH_ALGO_SHA256:
> +		if (!rme_has_feature(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
> +			return -EINVAL;
> +		break;
> +	case ARM_RME_CONFIG_HASH_ALGO_SHA512:
> +		if (!rme_has_feature(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	realm->params->hash_algo = cfg->hash_algo;
> +	return 0;
> +}
> +
> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	struct arm_rme_config cfg;
> +	struct realm *realm = &kvm->arch.realm;
> +	int r = 0;
> +
> +	if (kvm_realm_is_created(kvm))
> +		return -EBUSY;
> +
> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
> +		return -EFAULT;
> +
> +	switch (cfg.cfg) {
> +	case ARM_RME_CONFIG_RPV:
> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
> +		break;
> +	case ARM_RME_CONFIG_HASH_ALGO:
> +		r = config_realm_hash_algo(realm, &cfg);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +	return r;
> +}
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r = 0;
> +
> +	if (!kvm_is_realm(kvm))
> +		return -EINVAL;
> +
> +	switch (cap->args[0]) {
> +	case KVM_CAP_ARM_RME_CONFIG_REALM:
> +		r = kvm_rme_config_realm(kvm, cap);
> +		break;
> +	case KVM_CAP_ARM_RME_CREATE_REALM:
> +		r = kvm_create_realm(kvm);
> +		break;
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +	int i;
> +
> +	if (realm->params) {
> +		free_page((unsigned long)realm->params);
> +		realm->params = NULL;
> +	}
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
> +
> +	if (realm->rd) {
> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +
> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
> +			return;
> +		free_delegated_granule(rd_phys);
> +		realm->rd = NULL;
> +	}
> +
> +	rme_vmid_release(realm->vmid);
> +
> +	for (i = 0; i < pgd_size; i += RMM_PAGE_SIZE) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> +			return;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
> +	/* Now that the Realm is destroyed, free the entry level RTTs */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	kvm->arch.realm.params = (void *)get_zeroed_page(GFP_KERNEL);
> +
> +	if (!kvm->arch.realm.params)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
>   void kvm_init_rme(void)
>   {
>   	if (PAGE_SIZE != SZ_4K)
> @@ -52,5 +367,11 @@ void kvm_init_rme(void)
>   		/* Continue without realm support */
>   		return;
>   
> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
> +		return;
> +
> +	if (rme_vmid_init())
> +		return;
> +
>   	/* Future patch will enable static branch kvm_rme_is_available */
>   }


Yiwei Zhuang



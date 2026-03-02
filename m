Return-Path: <kvm+bounces-72404-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UC3XCu3BpWmBFgAAu9opvQ
	(envelope-from <kvm+bounces-72404-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:59:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4041DD628
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B8018306582B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 16:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C35428850;
	Mon,  2 Mar 2026 16:47:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7799E41C0A4;
	Mon,  2 Mar 2026 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772470024; cv=none; b=H4iPhF64Y6eCv+X3geYzCuaJUYH8iIuetm/AJmc7/etWBWlX5rclJjuV3N501f2CXYSGuW4TyGY3kmZKur718afYp3gqDu524shVRt0R+TKugqlA1Se0nGV2tAz4YAGi2n0EkCc7TuHQ0mXqarw/zj8iWXPd1hY6/gteN5VdgTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772470024; c=relaxed/simple;
	bh=lTGRPWD5nMRyqg81LvsdYccWHtDwYOeLqtmq3kGQQ9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rzr6BDfq0Wxybr3GNZFSR5lRolDw/tH3LZ1pbS7WELHpdO9RQ2dJPXuWr/YT2QkQmsarBMKZXEtXtizb0umaDjqS1AgTErH7XtM/a1VK9mi1SM0QhRmYhUORU3t9poZ06o7e73Qr74qcOteu8PMqzGs3auFOkLqMbQWsHgd8DSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67C6714BF;
	Mon,  2 Mar 2026 08:46:54 -0800 (PST)
Received: from [10.57.55.216] (unknown [10.57.55.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA0543F694;
	Mon,  2 Mar 2026 08:46:54 -0800 (PST)
Message-ID: <782ffcc2-1a72-46f0-a0c7-f1277fb84ced@arm.com>
Date: Mon, 2 Mar 2026 16:46:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/46] arm64: RMI: Allow populating initial contents
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-21-steven.price@arm.com> <86qzq28elj.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86qzq28elj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB4041DD628
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.910];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72404-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Action: no action

On 02/03/2026 14:56, Marc Zyngier wrote:
> On Wed, 17 Dec 2025 10:10:57 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v11:
>>  * The multiplex CAP is gone and there's a new ioctl which makes use of
>>    the generic kvm_gmem_populate() functionality.
>> Changes since v7:
>>  * Improve the error codes.
>>  * Other minor changes from review.
>> Changes since v6:
>>  * Handle host potentially having a larger page size than the RMM
>>    granule.
>>  * Drop historic "par" (protected address range) from
>>    populate_par_region() - it doesn't exist within the current
>>    architecture.
>>  * Add a cond_resched() call in kvm_populate_realm().
>> Changes since v5:
>>  * Refactor to use PFNs rather than tracking struct page in
>>    realm_create_protected_data_page().
>>  * Pull changes from a later patch (in the v5 series) for accessing
>>    pages from a guest memfd.
>>  * Do the populate in chunks to avoid holding locks for too long and
>>    triggering RCU stall warnings.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   4 +
>>  arch/arm64/kvm/Kconfig           |   1 +
>>  arch/arm64/kvm/arm.c             |   9 ++
>>  arch/arm64/kvm/rmi.c             | 175 +++++++++++++++++++++++++++++++
>>  4 files changed, 189 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 8a862fc1a99d..b5e36344975c 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -99,6 +99,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>>  int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>>  int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>>  
>> +struct kvm_arm_rmi_populate;
>> +
>> +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +			 struct kvm_arm_rmi_populate *arg);
>>  void kvm_realm_unmap_range(struct kvm *kvm,
>>  			   unsigned long ipa,
>>  			   unsigned long size,
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 1cac6dfc0972..b495dfd3a8b4 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -39,6 +39,7 @@ menuconfig KVM
>>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>>  	select KVM_GUEST_MEMFD
>>  	select KVM_GENERIC_MEMORY_ATTRIBUTES
>> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>>  	help
>>  	  Support hosting virtualized guest machines.
>>  
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 7927181887cf..0a06ed9d1a64 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2037,6 +2037,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>  			return -EFAULT;
>>  		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>>  	}
>> +	case KVM_ARM_RMI_POPULATE: {
>> +		struct kvm_arm_rmi_populate req;
>> +
>> +		if (!kvm_is_realm(kvm))
>> +			return -EPERM;
> 
> EPERM is odd. It isn't that the VMM doesn't have the right to do it,
> it is that it shouldn't have called that, because the ioctl doesn't
> exist for a normal VM. -ENOSYS?

Ack

>> +		if (copy_from_user(&req, argp, sizeof(req)))
>> +			return -EFAULT;
>> +		return kvm_arm_rmi_populate(kvm, &req);
>> +	}
>>  	default:
>>  		return -EINVAL;
>>  	}
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index fe15b400091c..39577e956a59 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -558,6 +558,150 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>>  		realm_unmap_private_range(kvm, start, end, may_block);
>>  }
>>  
>> +static int realm_create_protected_data_granule(struct realm *realm,
>> +					       unsigned long ipa,
>> +					       phys_addr_t dst_phys,
>> +					       phys_addr_t src_phys,
>> +					       unsigned long flags)
>> +{
>> +	phys_addr_t rd = virt_to_phys(realm->rd);
>> +	int ret;
>> +
>> +	if (rmi_granule_delegate(dst_phys))
>> +		return -ENXIO;
>> +
>> +	ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
>> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +		/* Create missing RTTs and retry */
>> +		int level = RMI_RETURN_INDEX(ret);
>> +
>> +		WARN_ON(level == RMM_RTT_MAX_LEVEL);
> 
> If this is unexpected, why do we still try to handle it? We should
> abort hard on anything that doesn't seem 100% correct, and mark the
> realm dead.

Well this is a "should never happen - the RMM (or Linux kerne) is buggy" 
situation - so it's not specifically the realm's fault. The "do nothing" 
error handling deals with things quite reasonably - the following 
realm_create_rtt_levels() call is a no-op, so we'll retry the 
rmi_data_create() call and bubble the error up.

I'll change this to KVM_BUG_ON so that the guest is killed just in case 
it turns out the guest can somehow trigger this maliciously.

>> +
>> +		ret = realm_create_rtt_levels(realm, ipa, level,
>> +					      RMM_RTT_MAX_LEVEL, NULL);
>> +		if (ret)
>> +			return -EIO;
>> +
>> +		ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
>> +	}
>> +	if (ret)
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>> +static int realm_create_protected_data_page(struct realm *realm,
>> +					    unsigned long ipa,
>> +					    kvm_pfn_t dst_pfn,
>> +					    kvm_pfn_t src_pfn,
>> +					    unsigned long flags)
>> +{
>> +	unsigned long rd = virt_to_phys(realm->rd);
>> +	phys_addr_t dst_phys, src_phys;
>> +	bool undelegate_failed = false;
>> +	int ret, offset;
>> +
>> +	dst_phys = __pfn_to_phys(dst_pfn);
>> +	src_phys = __pfn_to_phys(src_pfn);
>> +
>> +	for (offset = 0; offset < PAGE_SIZE; offset += RMM_PAGE_SIZE) {
>> +		ret = realm_create_protected_data_granule(realm,
>> +							  ipa,
>> +							  dst_phys,
>> +							  src_phys,
>> +							  flags);
>> +		if (ret)
>> +			goto err;
>> +
>> +		ipa += RMM_PAGE_SIZE;
>> +		dst_phys += RMM_PAGE_SIZE;
>> +		src_phys += RMM_PAGE_SIZE;
>> +	}
>> +
>> +	return 0;
>> +
>> +err:
>> +	if (ret == -EIO) {
>> +		/* current offset needs undelegating */
>> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
>> +			undelegate_failed = true;
>> +	}
>> +	while (offset > 0) {
>> +		ipa -= RMM_PAGE_SIZE;
>> +		offset -= RMM_PAGE_SIZE;
>> +		dst_phys -= RMM_PAGE_SIZE;
>> +
>> +		rmi_data_destroy(rd, ipa, NULL, NULL);
>> +
>> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
>> +			undelegate_failed = true;
>> +	}
>> +
>> +	if (undelegate_failed) {
>> +		/*
>> +		 * A granule could not be undelegated,
>> +		 * so the page has to be leaked
>> +		 */
>> +		get_page(pfn_to_page(dst_pfn));
>> +	}
>> +
>> +	return -ENXIO;
>> +}
>> +
>> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> +			      void __user *src, int order, void *opaque)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long data_flags = *(unsigned long *)opaque;
>> +	phys_addr_t ipa = gfn_to_gpa(gfn);
>> +	int npages = (1 << order);
>> +	int i;
>> +
>> +	for (i = 0; i < npages; i++) {
>> +		struct page *src_page;
>> +		int ret;
>> +
>> +		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
>> +		if (ret < 0)
>> +			return ret;
>> +		if (ret != 1)
>> +			return -ENOMEM;
>> +
>> +		ret = realm_create_protected_data_page(realm, ipa, pfn,
>> +						       page_to_pfn(src_page),
>> +						       data_flags);
>> +
>> +		put_page(src_page);
>> +
>> +		if (ret)
>> +			return ret;
>> +
>> +		ipa += PAGE_SIZE;
>> +		pfn++;
>> +		src += PAGE_SIZE;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static long populate_region(struct kvm *kvm,
>> +			    gfn_t base_gfn,
>> +			    unsigned long pages,
>> +			    u64 uaddr,
>> +			    unsigned long data_flags)
>> +{
>> +	long ret = 0;
>> +
>> +	mutex_lock(&kvm->slots_lock);
>> +	mmap_read_lock(current->mm);
>> +	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
>> +				populate_region_cb, &data_flags);
>> +	mmap_read_unlock(current->mm);
>> +	mutex_unlock(&kvm->slots_lock);
>> +
>> +	return ret;
>> +}
>> +
>>  enum ripas_action {
>>  	RIPAS_INIT,
>>  	RIPAS_SET,
>> @@ -655,6 +799,37 @@ static int realm_ensure_created(struct kvm *kvm)
>>  	return -ENXIO;
>>  }
>>  
>> +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +			 struct kvm_arm_rmi_populate *args)
>> +{
>> +	unsigned long data_flags = 0;
>> +	unsigned long ipa_start = args->base;
>> +	unsigned long ipa_end = ipa_start + args->size;
>> +	int ret;
>> +
>> +	if (args->reserved ||
>> +	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
>> +	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
>> +	    !IS_ALIGNED(ipa_end, PAGE_SIZE))
>> +		return -EINVAL;
>> +
>> +	ret = realm_ensure_created(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
> 
> This flag isn't documented.

Indeed - that's an oversight! I'll add the following to the docs:

`flags` can be set to `KVM_ARM_RMI_POPULATE_FLAGS_MEASURE` to request that the
populated data is hashed and added to the guest's Realm Initial Measurement
(RIM).

>> +		data_flags |= RMI_MEASURE_CONTENT;
>> +
>> +	ret = populate_region(kvm, gpa_to_gfn(ipa_start),
>> +			      args->size >> PAGE_SHIFT,
>> +			      args->source_uaddr, args->flags);
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return ret * PAGE_SIZE;
> 
> Bits of the code works on PAGE_SIZE, other bits on RMM_PAGE_SIZE. It
> is pretty confusing. Are you in the middle of reworking this?

Yes, sorry about that - RMM_PAGE_SIZE will be completely gone when
this is updated to RMM v2.0.

Thanks,
Steve



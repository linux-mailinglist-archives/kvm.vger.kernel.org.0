Return-Path: <kvm+bounces-73002-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GK1yMS6eqmlLUgEAu9opvQ
	(envelope-from <kvm+bounces-73002-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:28:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5346421DE7A
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8988B3032D14
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B204344DAA;
	Fri,  6 Mar 2026 09:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PzNI3o6C"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D83344DA9;
	Fri,  6 Mar 2026 09:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789291; cv=none; b=nbNbMgOhPXCTkgc1Vs3QOAfdygIJGDuATT9aDIvk4HU1iIFitb28gv+kWqg5nH2/uOWWqCFgBd0ABVLetfPktVQ9BUN+WRcoiKs4XFoBdPQW3uG45sK1xey9m9vUDJFsXJGpPzrZJQlD/FCJNQW1OTwVZwUsWT059/bSv5292wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789291; c=relaxed/simple;
	bh=gFuzyJfrIJEKGOa2JU4DYIkNZ13ELl+arno5mpliIeo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=htpVpP2QWBcEuCkhnZlwtbIWCZdai8rzEDV/l6imp4gRP3XyvxKN5DgcTMAeoGI77g9Maf9extXJpdP8tCJU6phLDwQp0tkbN2qHJTHa0Mm2m+ONFgxjchdQB2rDc4aVdo4TI9CGXdY3Cwz5ehbR0gM0hoOnSFapq0hgOmq11Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PzNI3o6C; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4XKHFxhJXNE6tTFUFiPCjMsBl5awhMD78u/ZQefcc4k=;
	b=PzNI3o6C6ZPDRSBgGKdDaAgTHGfhmDbHa5m2tx6IXGFmEHSvuotDAkSJgo1pRCORiRD/DAh9K
	mtQlDmHfs8p8wAON6P3vmR8VtqZx/CyP4P5G9Nyt9g+sq0OuNgFbhYxlkA8CFDB4Wyz6kNLIO0B
	rruKCVtxRlkpAlb9XcWad8s=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fS1Cv6w4sz1cyTB;
	Fri,  6 Mar 2026 17:23:07 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A6D640539;
	Fri,  6 Mar 2026 17:28:00 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 6 Mar 2026 17:27:59 +0800
Message-ID: <ee584a49-ce69-443b-97c0-37f24f78bdbb@huawei.com>
Date: Fri, 6 Mar 2026 17:27:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Tian Zheng <zhengtian10@huawei.com>
Subject: Re: [PATCH v3 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <liuyonglong@huawei.com>,
	<Jonathan.Cameron@huawei.com>, <yezhenyu2@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
 <20260225040421.2683931-5-zhengtian10@huawei.com>
 <aahSaJTVeMBoRbUE@devkitleo>
In-Reply-To: <aahSaJTVeMBoRbUE@devkitleo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)
X-Rspamd-Queue-Id: 5346421DE7A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhengtian10@huawei.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73002-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[huawei.com:+]
X-Rspamd-Action: no action

Hi Leo,

On 3/4/2026 11:40 PM, Leonardo Bras wrote:
> Hi Tian,
>
> Few extra notes/questions below
>
> On Wed, Feb 25, 2026 at 12:04:20PM +0800, Tian Zheng wrote:
>> From: eillon<yezhenyu2@huawei.com>
>>
>> HDBSS is enabled via an ioctl from userspace (e.g. QEMU) at the start of
>> migration. This feature is only supported in VHE mode.
>>
>> Initially, S2 PTEs doesn't contain the DBM attribute. During migration,
>> write faults are handled by user_mem_abort, which relaxes permissions
>> and adds the DBM bit when HDBSS is active. Once DBM is set, subsequent
>> writes no longer trap, as the hardware automatically transitions the page
>> from writable-clean to writable-dirty.
>>
>> KVM does not scan S2 page tables to consume DBM. Instead, when HDBSS is
>> enabled, the hardware observes the clean->dirty transition and records
>> the corresponding page into the HDBSS buffer.
>>
>> During sync_dirty_log, KVM kicks all vCPUs to force VM-Exit, ensuring
>> that check_vcpu_requests flushes the HDBSS buffer and propagates the
>> accumulated dirty information into the userspace-visible dirty bitmap.
>>
>> Add fault handling for HDBSS including buffer full, external abort, and
>> general protection fault (GPF).
>>
>> Signed-off-by: eillon<yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng<zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/esr.h      |   5 ++
>>   arch/arm64/include/asm/kvm_host.h |  17 +++++
>>   arch/arm64/include/asm/kvm_mmu.h  |   1 +
>>   arch/arm64/include/asm/sysreg.h   |  11 ++++
>>   arch/arm64/kvm/arm.c              | 102 ++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/hyp/vhe/switch.c   |  19 ++++++
>>   arch/arm64/kvm/mmu.c              |  70 ++++++++++++++++++++
>>   arch/arm64/kvm/reset.c            |   3 +
>>   8 files changed, 228 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index 81c17320a588..2e6b679b5908 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -437,6 +437,11 @@
>>   #ifndef __ASSEMBLER__
>>   #include <asm/types.h>
>>
>> +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
>> +{
>> +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
>> +}
>> +
>>   static inline unsigned long esr_brk_comment(unsigned long esr)
>>   {
>>   	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 5d5a3bbdb95e..57ee6b53e061 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -55,12 +55,17 @@
>>   #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
>>   #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
>>   #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
>> +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
>>
>>   #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>>   				     KVM_DIRTY_LOG_INITIALLY_SET)
>>
>>   #define KVM_HAVE_MMU_RWLOCK
>>
>> +/* HDBSS entry field definitions */
>> +#define HDBSS_ENTRY_VALID BIT(0)
>> +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
>> +
>>   /*
>>    * Mode of operation configurable with kvm-arm.mode early param.
>>    * See Documentation/admin-guide/kernel-parameters.txt for more information.
>> @@ -84,6 +89,7 @@ int __init kvm_arm_init_sve(void);
>>   u32 __attribute_const__ kvm_target_cpu(void);
>>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>
>>   struct kvm_hyp_memcache {
>>   	phys_addr_t head;
>> @@ -405,6 +411,8 @@ struct kvm_arch {
>>   	 * the associated pKVM instance in the hypervisor.
>>   	 */
>>   	struct kvm_protected_vm pkvm;
>> +
>> +	bool enable_hdbss;
>>   };
>>
>>   struct kvm_vcpu_fault_info {
>> @@ -816,6 +824,12 @@ struct vcpu_reset_state {
>>   	bool		reset;
>>   };
>>
>> +struct vcpu_hdbss_state {
>> +	phys_addr_t base_phys;
>> +	u32 size;
>> +	u32 next_index;
>> +};
>> +
> IIUC this is used once both on enable/disable and massively on
> vcpu_put/get.
>
> What if we actually save just HDBSSBR_EL2 and HDBSSPROD_EL2 instead?
> That way we avoid having masking operations in put/get as well as any
> possible error we may have formatting those.
>
> The cost is doing those operations once for enable and once for disable,
> which should be fine.


Thanks for the suggestion. I actually started with storing the raw 
system register

values, as you proposed.


However, after discussing it with Oliver Upton in v1, we felt that 
keeping the base address,

size, and index as separate fields makes the state easier to understand.


Discussion 
link:https://lore.kernel.org/linux-arm-kernel/Z8_usklidqnerurc@linux.dev/ 
<https://lore.kernel.org/linux-arm-kernel/Z8_usklidqnerurc@linux.dev/>


That's why I ended up changing the storage approach in the end.


>>   struct vncr_tlb;
>>
>>   struct kvm_vcpu_arch {
>> @@ -920,6 +934,9 @@ struct kvm_vcpu_arch {
>>
>>   	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>>   	struct vncr_tlb	*vncr_tlb;
>> +
>> +	/* HDBSS registers info */
>> +	struct vcpu_hdbss_state hdbss;
>>   };
>>
>>   /*
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index d968aca0461a..3fea8cfe8869 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -183,6 +183,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>
>>   int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
>>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
>>
>>   phys_addr_t kvm_mmu_get_httbr(void);
>>   phys_addr_t kvm_get_idmap_vector(void);
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index f4436ecc630c..d11f4d0dd4e7 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1039,6 +1039,17 @@
>>
>>   #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>>   					       GCS_CAP_VALID_TOKEN)
>> +
>> +/*
>> + * Definitions for the HDBSS feature
>> + */
>> +#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
>> +
>> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
>> +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
>> +
>> +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
>> +
>>   /*
>>    * Definitions for GICv5 instructions
>>    */
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 29f0326f7e00..d64da05e25c4 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -125,6 +125,87 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>   }
>>
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct page *hdbss_pg;
>> +
>> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
>> +	if (hdbss_pg)
>> +		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
>> +
>> +	vcpu->arch.hdbss.size = 0;
>> +}
>> +
>> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
>> +				    struct kvm_enable_cap *cap)
>> +{
>> +	unsigned long i;
>> +	struct kvm_vcpu *vcpu;
>> +	struct page *hdbss_pg = NULL;
>> +	__u64 size = cap->args[0];
>> +	bool enable = cap->args[1] ? true : false;
>> +
>> +	if (!system_supports_hdbss())
>> +		return -EINVAL;
>> +
>> +	if (size > HDBSS_MAX_SIZE)
>> +		return -EINVAL;
>> +
>> +	if (!enable && !kvm->arch.enable_hdbss) /* Already Off */
>> +		return 0;
>> +
>> +	if (enable && kvm->arch.enable_hdbss) /* Already On, can't set size */
>> +		return -EINVAL;
>> +
>> +	if (!enable) { /* Turn it off */
>> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
>> +
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			/* Kick vcpus to flush hdbss buffer. */
>> +			kvm_vcpu_kick(vcpu);
>> +
>> +			kvm_arm_vcpu_free_hdbss(vcpu);
>> +		}
>> +
>> +		kvm->arch.enable_hdbss = false;
>> +
>> +		return 0;
>> +	}
>> +
>> +	/* Turn it on */
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
>> +		if (!hdbss_pg)
>> +			goto error_alloc;
>> +
>> +		vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>> +			.base_phys = page_to_phys(hdbss_pg),
>> +			.size = size,
>> +			.next_index = 0,
>> +		};
>> +	}
>> +
>> +	kvm->arch.enable_hdbss = true;
>> +	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
>> +
>> +	/*
>> +	 * We should kick vcpus out of guest mode here to load new
>> +	 * vtcr value to vtcr_el2 register when re-enter guest mode.
>> +	 */
>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>> +		kvm_vcpu_kick(vcpu);
>> +
>> +	return 0;
>> +
>> +error_alloc:
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		if (vcpu->arch.hdbss.base_phys)
>> +			kvm_arm_vcpu_free_hdbss(vcpu);
>> +	}
>> +
>> +	return -ENOMEM;
>> +}
>> +
>>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   			    struct kvm_enable_cap *cap)
>>   {
>> @@ -182,6 +263,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		r = 0;
>>   		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
>>   		break;
>> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
>> +		mutex_lock(&kvm->lock);
>> +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
>> +		mutex_unlock(&kvm->lock);
>> +		break;
>>   	default:
>>   		break;
>>   	}
>> @@ -471,6 +557,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   			r = kvm_supports_cacheable_pfnmap();
>>   		break;
>>
>> +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
>> +		r = system_supports_hdbss();
>> +		break;
>>   	default:
>>   		r = 0;
>>   	}
>> @@ -1120,6 +1209,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   		if (kvm_dirty_ring_check_request(vcpu))
>>   			return 0;
>>
>> +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
>> +			kvm_flush_hdbss_buffer(vcpu);
> I am curious on why we need a flush-hdbss request,
> Don't we have the flush function happening every time we run vcpu_put?
>
> Oh, I see, you want to check if there is anything needed inside the inner
> loop of vcpu_run, without having to vcpu_put. I think it makes sense.
>
> But instead of having this on guest entry, does not it make more sense to
> have it in guest exit? This way we flush every time (if needed) we exit the
> guest, and instead of having a vcpu request, we just require a vcpu kick
> and it should flush if needed.
>
> Maybe have vcpu_put just save the registers, and add a the flush before
> handle_exit.
>
> What do you think?


Thank you for the feedback.


Indeed, in the initial version (v1), I placed the flush operation inside 
handle_exit and

used a vcpu_kick in kvm_arch_sync_dirty_log to trigger the flush of the 
HDBSS buffer.


However, during the review, Marc pointed out that calling this function 
on every exit

event is too frequent if it's not always needed.


Discussion link: 
_https://lore.kernel.org/linux-arm-kernel/86senjony9.wl-maz@kernel.org/_


I agreed with his assessment. Therefore, in the current version, I've 
separated the flush

operation into more specific and less frequent points:


1. In vcpu_put

2. During dirty log synchronization, by kicking the vCPU to trigger a 
request that flushes

on its next exit.


3. When handling a specific HDBSSF event.


This ensures the flush happens only when necessary, avoiding the 
overhead of doing it

on every guest exit.


>> +
>>   		check_nested_vcpu_requests(vcpu);
>>   	}
>>
>> @@ -1898,7 +1990,17 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
>>
>>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>>   {
>> +	/*
>> +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
>> +	 * before reporting dirty_bitmap to userspace. Send a request with
>> +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
>> +	 */
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>>
>> +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS);
>>   }
>>
>>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
>> index 9db3f11a4754..600cbc4f8ae9 100644
>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>> @@ -213,6 +213,23 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
>>   	local_irq_restore(flags);
>>   }
>>
>> +static void __load_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	u64 br_el2, prod_el2;
>> +
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>> +
>> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
>> +	prod_el2 = vcpu->arch.hdbss.next_index;
>> +
>> +	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
>> +	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
>> +
>> +	isb();
>> +}
>> +
>>   void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>>   {
>>   	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
>> @@ -220,10 +237,12 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>>   	__vcpu_load_switch_sysregs(vcpu);
>>   	__vcpu_load_activate_traps(vcpu);
>>   	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
>> +	__load_hdbss(vcpu);
>>   }
>>
>>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>>   {
>> +	kvm_flush_hdbss_buffer(vcpu);
>>   	__vcpu_put_deactivate_traps(vcpu);
>>   	__vcpu_put_switch_sysregs(vcpu);
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 070a01e53fcb..42b0710a16ce 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1896,6 +1896,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	if (writable)
>>   		prot |= KVM_PGTABLE_PROT_W;
>>
>> +	if (writable && kvm->arch.enable_hdbss && logging_active)
>> +		prot |= KVM_PGTABLE_PROT_DBM;
>> +
>>   	if (exec_fault)
>>   		prot |= KVM_PGTABLE_PROT_X;
>>
>> @@ -2033,6 +2036,70 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>
>> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>> +{
>> +	int idx, curr_idx;
>> +	u64 br_el2;
>> +	u64 *hdbss_buf;
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>> +
>> +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
>> +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
>> +
>> +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
>> +	if (curr_idx == 0 || br_el2 == 0)
>> +		return;
>> +
>> +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
>> +	if (!hdbss_buf)
>> +		return;
>> +
>> +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
>> +	for (idx = 0; idx < curr_idx; idx++) {
>> +		u64 gpa;
>> +
>> +		gpa = hdbss_buf[idx];
>> +		if (!(gpa & HDBSS_ENTRY_VALID))
>> +			continue;
>> +
>> +		gpa &= HDBSS_ENTRY_IPA;
>> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
>> +	}
> This will mark a page dirty for both dirty_bitmap or dirty_ring, depending
> on what is in use.
>
> Out of plain curiosity, have you planned / tested for the dirty-ring as
> well, or just for dirty-bitmap?


Currently, I have only tested this with dirty-bitmap mode.


I will test and ensure the HDBSS feature works correctly with dirty-ring 
in the next version.


>> +
>> +	/* reset HDBSS index */
>> +	write_sysreg_s(0, SYS_HDBSSPROD_EL2);
>> +	vcpu->arch.hdbss.next_index = 0;
>> +	isb();
>> +}
>> +
>> +static int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 prod;
>> +	u64 fsc;
>> +
>> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
>> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
>> +
>> +	switch (fsc) {
>> +	case HDBSSPROD_EL2_FSC_OK:
>> +		/* Buffer full, which is reported as permission fault. */
>> +		kvm_flush_hdbss_buffer(vcpu);
>> +		return 1;
> Humm, flushing in a fault handler means hanging there, in IRQ context, for
> a while.
>
> Since we already deal with this on guest_exit (vcpu_put IIUC), why not just
> return in a way the vcpu has to exit the inner loop and let it flush there
> instead?
>
> Thanks!
> Leo


Thanks for the feedback.


If we flush on every guest exit (by moving the flush before handle_exit, 
then we can

indeed drop the flush from the fault handler and from vcpu_put.


However, given Marc's earlier concern about not imposing this overhead 
on all vCPUs,

I'd rather avoid flushing on every exit.


My current plan is to set a request bit in kvm_handle_hdbss_fault (via 
kvm_make_request),

and move the actual flush to the normal exit path, where it can execute 
in a safe context.

This also allows us to remove the flush from the fault handler entirely.


Does that approach sound reasonable to you?


>> +	case HDBSSPROD_EL2_FSC_ExternalAbort:
>> +	case HDBSSPROD_EL2_FSC_GPF:
>> +		return -EFAULT;
>> +	default:
>> +		/* Unknown fault. */
>> +		WARN_ONCE(1,
>> +				"Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
>> +				fsc, prod, vcpu->vcpu_id);
>> +		return -EFAULT;
>> +	}
>> +}
>> +
>>   /**
>>    * kvm_handle_guest_abort - handles all 2nd stage aborts
>>    * @vcpu:	the VCPU pointer
>> @@ -2071,6 +2138,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>
>>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>
>> +	if (esr_iss2_is_hdbssf(esr))
>> +		return kvm_handle_hdbss_fault(vcpu);
>> +
>>   	if (esr_fsc_is_translation_fault(esr)) {
>>   		/* Beyond sanitised PARange (which is the IPA limit) */
>>   		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 959532422d3a..c03a4b310b53 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>>   	kfree(vcpu->arch.vncr_tlb);
>>   	kfree(vcpu->arch.ccsidr);
>> +
>> +	if (vcpu->kvm->arch.enable_hdbss)
>> +		kvm_arm_vcpu_free_hdbss(vcpu);
>>   }
>>
>>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>> --
>> 2.33.0

Thanks!

Tian



Return-Path: <kvm+bounces-66668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EA0CDB76F
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 07:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10658302EF65
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 06:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6072DC763;
	Wed, 24 Dec 2025 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2e60XrQO"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3279F3594F;
	Wed, 24 Dec 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766556926; cv=none; b=U4qKenfUT/73zKdPWRQg2tkF0uh/IonxPVrnbox331YbbB6jerKAMbNG4JMD5wfQ5xwcNwLmeQc0AAI5bGhAgXW6g6GBu72Gp5t/g5AFGA6Gmry4dDC3fH2s0TB7Ip7kwJ8HnDArEGl0onR/oS+xyiX8DJAbA6wxF1oNoMsnuPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766556926; c=relaxed/simple;
	bh=qq1SXME7AbXDnt9RsKYhB1tyhzC+kttGZlFvm92MYoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kxIXY6t1xQSRhqfdpIjOZqNYq6gSRdfj4tnXhdCCvpgzJQ8xkdSNwEhxdxNIjbG0Uj6CctBpedWzY9tPs7gXXl5gszmwtzVJAYQbuAV24GbufMl78b2aDdOWMEICUvVRsPe41r2c9C/FOUIRrTg42Itl5lsi6JiL9KJ60OJr6fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2e60XrQO; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Z6s05Oe7JEqfjJMZVFBnicnBj32uLD/EjtUJ4enaUBc=;
	b=2e60XrQOFa7j0KVjV71Czh6e+qNB8ck0r8Jfr9X5NX//5QpJviYIVvgk0DBLeFREGJPM7VrpL
	94uDpymmPdWyeR5qy7ya7NSxRO7BuEMI3CWituejwcAygkqWy6AF6xH+JlrxmvaMSIXcproui1C
	rptUFBImIyfI+i+y9WXS/uA=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dbhNj56j3z12LJy;
	Wed, 24 Dec 2025 14:12:05 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CE2040363;
	Wed, 24 Dec 2025 14:15:18 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 24 Dec 2025 14:15:17 +0800
Message-ID: <f8e59e80-33b2-47cd-a042-11f28cc61645@huawei.com>
Date: Wed, 24 Dec 2025 14:15:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Robert Hoo <robert.hoo.linux@gmail.com>, Tian Zheng
	<zhengtian10@huawei.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>, <xiexiangyou@huawei.com>,
	<zhengchuan@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-5-zhengtian10@huawei.com>
 <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 12/17/2025 9:39 PM, Robert Hoo wrote:
> On 11/21/2025 5:23 PM, Tian Zheng wrote:
>> From: eillon <yezhenyu2@huawei.com>
>>
>> Implement the HDBSS enable/disable functionality using the
>> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.
>>
>> Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
>> at the start of live migration, configuring the buffer size.
>> The feature is disabled by invoking the ioctl again with size
>> set to 0 once migration completes.
>>
>> Add support for updating the dirty bitmap based on the HDBSS
>> buffer. Similar to the x86 PML implementation, KVM flushes the
>> buffer on all VM-Exits, so running vCPUs only need to be kicked
>> to force a VM-Exit.
>>
>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  10 +++
>>   arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
>>   arch/arm64/kvm/arm.c              | 107 ++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
>>   arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
>>   arch/arm64/kvm/mmu.c              |  10 +++
>>   arch/arm64/kvm/reset.c            |   3 +
>>   include/linux/kvm_host.h          |   1 +
>>   8 files changed, 194 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>> asm/kvm_host.h
>> index d962932f0e5f..408e4c2b3d1a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
>>   u32 __attribute_const__ kvm_target_cpu(void);
>>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>
>>   struct kvm_hyp_memcache {
>>       phys_addr_t head;
>> @@ -793,6 +794,12 @@ struct vcpu_reset_state {
>>       bool        reset;
>>   };
>>
>> +struct vcpu_hdbss_state {
>> +    phys_addr_t base_phys;
>> +    u32 size;
>> +    u32 next_index;
>> +};
>> +
>>   struct vncr_tlb;
>>
>>   struct kvm_vcpu_arch {
>> @@ -897,6 +904,9 @@ struct kvm_vcpu_arch {
>>
>>       /* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>>       struct vncr_tlb    *vncr_tlb;
>> +
>> +    /* HDBSS registers info */
>> +    struct vcpu_hdbss_state hdbss;
>>   };
>>
>>   /*
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/ 
>> asm/kvm_mmu.h
>> index e4069f2ce642..6ace1080aed5 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -331,6 +331,23 @@ static __always_inline void __load_stage2(struct 
>> kvm_s2_mmu *mmu,
>>       asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>>   }
>>
>> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    u64 br_el2, prod_el2;
>> +
>> +    if (!kvm->enable_hdbss)
>> +        return;
>> +
>> +    br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu- 
>> >arch.hdbss.size);
>> +    prod_el2 = vcpu->arch.hdbss.next_index;
>> +
>> +    write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
>> +    write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
>> +
>> +    isb();
>> +}
>> +
>>   static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>>   {
>>       return container_of(mmu->arch, struct kvm, arch);
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 870953b4a8a7..64f65e3c2a89 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>       return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>   }
>>
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +    struct page *hdbss_pg = NULL;
>> +
>> +    hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
>> +    if (hdbss_pg)
>> +        __free_pages(hdbss_pg, vcpu->arch.hdbss.size);
>> +
>> +    vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>> +        .base_phys = 0,
>> +        .size = 0,
>> +        .next_index = 0,
>> +    };
>> +}
>> +
>> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
>> +                    struct kvm_enable_cap *cap)
>> +{
>> +    unsigned long i;
>> +    struct kvm_vcpu *vcpu;
>> +    struct page *hdbss_pg = NULL;
>> +    int size = cap->args[0];
>> +    int ret = 0;
>> +
>> +    if (!system_supports_hdbss()) {
>> +        kvm_err("This system does not support HDBSS!\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    if (size < 0 || size > HDBSS_MAX_SIZE) {
>> +        kvm_err("Invalid HDBSS buffer size: %d!\n", size);
>> +        return -EINVAL;
>> +    }
>> +
> 
> I think you should check if it's already enabled here. What if user 
> space calls this twice?

Ok, I review the implement of qemu, when disable the hdbss feature in
ram_save_cleanup, size=0 will be set, so here can add a check, if (size
&& kvm->arch.enable_hdbss), we will do nothing.

> 
>> +    /* Enable the HDBSS feature if size > 0, otherwise disable it. */
>> +    if (size) {
>> +        kvm_for_each_vcpu(i, vcpu, kvm) {
>> +            hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
>> +            if (!hdbss_pg) {
>> +                kvm_err("Alloc HDBSS buffer failed!\n");
>> +                ret = -ENOMEM;
>> +                goto error_alloc;
>> +            }
>> +
>> +            vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>> +                .base_phys = page_to_phys(hdbss_pg),
>> +                .size = size,
>> +                .next_index = 0,
>> +            };
>> +        }
>> +
>> +        kvm->enable_hdbss = true;
>> +        kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;
> 
> VTCR_EL2_HA is also a necessity for VTCR_EL2_HDBSS to take effect.

I see, thanks! I checked the architecture spec, and it indeed states
that HA needs to be enabled for AF hardware management to function
properly.

> 
>> +
>> +        /*
>> +         * We should kick vcpus out of guest mode here to load new
>> +         * vtcr value to vtcr_el2 register when re-enter guest mode.
>> +         */
>> +        kvm_for_each_vcpu(i, vcpu, kvm)
>> +            kvm_vcpu_kick(vcpu);
>> +    } else if (kvm->enable_hdbss) {
>> +        kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS);
>> +
>> +        kvm_for_each_vcpu(i, vcpu, kvm) {
>> +            /* Kick vcpus to flush hdbss buffer. */
>> +            kvm_vcpu_kick(vcpu);
>> +
>> +            kvm_arm_vcpu_free_hdbss(vcpu);
>> +        }
>> +
>> +        kvm->enable_hdbss = false;
>> +    }
>> +
>> +    return ret;
>> +
>> +error_alloc:
>> +    kvm_for_each_vcpu(i, vcpu, kvm) {
>> +        if (!vcpu->arch.hdbss.base_phys && !vcpu->arch.hdbss.size)
>> +            continue;
>> +
>> +        kvm_arm_vcpu_free_hdbss(vcpu);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>                   struct kvm_enable_cap *cap)
>>   {
>> @@ -132,6 +218,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>           }
>>           mutex_unlock(&kvm->lock);
>>           break;
>> +    case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
>> +        mutex_lock(&kvm->lock);
>> +        r = kvm_cap_arm_enable_hdbss(kvm, cap);
>> +        mutex_unlock(&kvm->lock);
>> +        break;
>>       default:
>>           break;
>>       }
>> @@ -420,6 +511,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>               r = kvm_supports_cacheable_pfnmap();
>>           break;
>>
>> +    case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
>> +        r = system_supports_hdbss();
>> +        break;
>>       default:
>>           r = 0;
>>       }
>> @@ -1837,7 +1931,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>
>>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot 
>> *memslot)
>>   {
>> +    /*
>> +     * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
>> +     * before reporting dirty_bitmap to userspace.  KVM flushes the 
>> buffers
>> +     * on all VM-Exits, thus we only need to kick running vCPUs to 
>> force a
>> +     * VM-Exit.
>> +     */
>> +    struct kvm_vcpu *vcpu;
>> +    unsigned long i;
>>
>> +    if (!kvm->enable_hdbss)
>> +        return;
>> +
>> +    kvm_for_each_vcpu(i, vcpu, kvm)
>> +        kvm_vcpu_kick(vcpu);
>>   }
>>
>>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index cc7d5d1709cb..9ba0ea6305ef 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -412,6 +412,49 @@ static exit_handle_fn kvm_get_exit_handler(struct 
>> kvm_vcpu *vcpu)
>>       return arm_exit_handlers[esr_ec];
>>   }
>>
>> +static void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>> +{
>> +    int idx, curr_idx;
>> +    u64 *hdbss_buf;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    u64 br_el2;
>> +
>> +    if (!kvm->enable_hdbss)
>> +        return;
>> +
>> +    dsb(sy);
>> +    isb();
>> +    curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
>> +    br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu- 
>> >arch.hdbss.size);
>> +
>> +    /* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
>> +    if (curr_idx == 0 || br_el2 == 0)
>> +        return;
>> +
>> +    hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
>> +    if (!hdbss_buf) {
>> +        kvm_err("Enter flush hdbss buffer with buffer == NULL!");
>> +        return;
>> +    }
>> +
>> +    guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
>> +    for (idx = 0; idx < curr_idx; idx++) {
>> +        u64 gpa;
>> +
>> +        gpa = hdbss_buf[idx];
>> +        if (!(gpa & HDBSS_ENTRY_VALID))
>> +            continue;
>> +
>> +        gpa &= HDBSS_ENTRY_IPA;
>> +        kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
>> +    }
>> +
>> +    /* reset HDBSS index */
>> +    write_sysreg_s(0, SYS_HDBSSPROD_EL2);
>> +    vcpu->arch.hdbss.next_index = 0;
>> +    isb();
>> +}
>> +
>>   /*
>>    * We may be single-stepping an emulated instruction. If the emulation
>>    * has been completed in the kernel, we can return to userspace with a
>> @@ -447,6 +490,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int 
>> exception_index)
>>   {
>>       struct kvm_run *run = vcpu->run;
>>
>> +    kvm_flush_hdbss_buffer(vcpu);
>> +
>>       if (ARM_SERROR_PENDING(exception_index)) {
>>           /*
>>            * The SError is handled by handle_exit_early(). If the guest
>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/ 
>> switch.c
>> index 9984c492305a..3787c9c5810d 100644
>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>> @@ -220,6 +220,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>>       __vcpu_load_switch_sysregs(vcpu);
>>       __vcpu_load_activate_traps(vcpu);
>>       __load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
>> +    __load_hdbss(vcpu);
>>   }
>>
>>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 7cc964af8d30..91a2f9dbb406 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1843,6 +1843,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
>> phys_addr_t fault_ipa,
>>       if (writable)
>>           prot |= KVM_PGTABLE_PROT_W;
>>
>> +    if (writable && kvm->enable_hdbss && logging_active)
>> +        prot |= KVM_PGTABLE_PROT_DBM;
>> +
>>       if (exec_fault)
>>           prot |= KVM_PGTABLE_PROT_X;
>>
>> @@ -1950,6 +1953,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>
>>       is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>
>> +    /*
>> +     * HDBSS buffer already flushed when enter handle_trap_exceptions().
>> +     * Nothing to do here.
>> +     */
>> +    if (ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
>> +        return 1;
>> +
>>       if (esr_fsc_is_translation_fault(esr)) {
>>           /* Beyond sanitised PARange (which is the IPA limit) */
>>           if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 959532422d3a..65e8f890f863 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -161,6 +161,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>>       free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>>       kfree(vcpu->arch.vncr_tlb);
>>       kfree(vcpu->arch.ccsidr);
>> +
>> +    if (vcpu->arch.hdbss.base_phys || vcpu->arch.hdbss.size)
>> +        kvm_arm_vcpu_free_hdbss(vcpu);
>>   }
>>
>>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 5bd76cf394fa..aa8138604b1e 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -876,6 +876,7 @@ struct kvm {
>>       struct xarray mem_attr_array;
>>   #endif
>>       char stats_id[KVM_STATS_NAME_SIZE];
>> +    bool enable_hdbss;
>>   };
>>
>>   #define kvm_err(fmt, ...) \
>> -- 
>> 2.33.0
>>
>>
> 



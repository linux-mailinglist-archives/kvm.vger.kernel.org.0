Return-Path: <kvm+bounces-67527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A78B5D07A7C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 08:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D769303370F
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 07:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF04C2F659F;
	Fri,  9 Jan 2026 07:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dLEEdksa"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710F76026;
	Fri,  9 Jan 2026 07:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767945179; cv=none; b=foe/9pGRdgzghJWeABr3KNmAAXJT0XgPy0G7rjQ7Z73YMQR8vhooqTvx/ciy//3jVpXx0e6aSDjYgsUOMmghXGaPoEgBLXqDPjmuqMLAEg2YPDessfve3dOzBMkjivIvY16flxEd+XqAJVoHF9ncDARa6/qSxVpdiUMan9fgfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767945179; c=relaxed/simple;
	bh=8bi4os2vIQBeDSrR3DIIeWSQ4/rDPcmqYhe2SkYTrmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pFZhv3Mgq10JXOLB/c6tb0Hkbb0DG+smVViI3N1ddjvldm3DxHRkJ7avVcQEV9BRdPmHXi9oAMDy81Z1OasTWVLLy62XRfPiolvf6cGlfIv9J7VLBvXiO6yI/lP3GgDBFiHZZHPlxQhCFpGjEvxf2YCHiE03j4sDAbKotcXdSfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dLEEdksa; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cAR5LxUosn5MR+Z/5Moz9cTm0bb98yOxJOET8rzyKpQ=;
	b=dLEEdksaplpS8/45BsNH/BlSmJya5HWO6a3QfmnzOgvITtGrcS4tQqOlz5Stt/MisPFZViHE/
	WVF9s/WF84xFLu/zuaPkqf+n3pKgW1aAEhkIbKtAQoi0MAiecbB4nh+i3PEjuBou0htiMVD6AY+
	8YHqy1c3T8XqlD1qRKeDwVE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dnYn92STTz1T4GT;
	Fri,  9 Jan 2026 15:49:01 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 13CD74036C;
	Fri,  9 Jan 2026 15:52:47 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 9 Jan 2026 15:52:46 +0800
Message-ID: <36e0a4d0-b440-4aba-8dfd-0c0fcb5f4318@huawei.com>
Date: Fri, 9 Jan 2026 15:52:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Robert Hoo <robert.hoo.linux@gmail.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>, <xiexiangyou@huawei.com>,
	<zhengchuan@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-5-zhengtian10@huawei.com>
 <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
 <f8e59e80-33b2-47cd-a042-11f28cc61645@huawei.com>
 <77111894-1b9f-4970-b41f-48e3a4c4b754@gmail.com>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <77111894-1b9f-4970-b41f-48e3a4c4b754@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 12/28/2025 9:21 PM, Robert Hoo wrote:
> On 12/24/2025 2:15 PM, Tian Zheng wrote:
>>
>>
>> On 12/17/2025 9:39 PM, Robert Hoo wrote:
>>> On 11/21/2025 5:23 PM, Tian Zheng wrote:
>>>> From: eillon <yezhenyu2@huawei.com>
>>>>
>>>> Implement the HDBSS enable/disable functionality using the
>>>> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.
>>>>
>>>> Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
>>>> at the start of live migration, configuring the buffer size.
>>>> The feature is disabled by invoking the ioctl again with size
>>>> set to 0 once migration completes.
>>>>
>>>> Add support for updating the dirty bitmap based on the HDBSS
>>>> buffer. Similar to the x86 PML implementation, KVM flushes the
>>>> buffer on all VM-Exits, so running vCPUs only need to be kicked
>>>> to force a VM-Exit.
>>>>
>>>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>> ---
>>>>   arch/arm64/include/asm/kvm_host.h |  10 +++
>>>>   arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
>>>>   arch/arm64/kvm/arm.c              | 107 
>>>> ++++++++++++++++++++++++++++++
>>>>   arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
>>>>   arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
>>>>   arch/arm64/kvm/mmu.c              |  10 +++
>>>>   arch/arm64/kvm/reset.c            |   3 +
>>>>   include/linux/kvm_host.h          |   1 +
>>>>   8 files changed, 194 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>>>> b/arch/arm64/include/ asm/kvm_host.h
>>>> index d962932f0e5f..408e4c2b3d1a 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
>>>>   u32 __attribute_const__ kvm_target_cpu(void);
>>>>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>>>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>>>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>>>
>>>>   struct kvm_hyp_memcache {
>>>>       phys_addr_t head;
>>>> @@ -793,6 +794,12 @@ struct vcpu_reset_state {
>>>>       bool        reset;
>>>>   };
>>>>
>>>> +struct vcpu_hdbss_state {
>>>> +    phys_addr_t base_phys;
>>>> +    u32 size;
>>>> +    u32 next_index;
>>>> +};
>>>> +
>>>>   struct vncr_tlb;
>>>>
>>>>   struct kvm_vcpu_arch {
>>>> @@ -897,6 +904,9 @@ struct kvm_vcpu_arch {
>>>>
>>>>       /* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>>>>       struct vncr_tlb    *vncr_tlb;
>>>> +
>>>> +    /* HDBSS registers info */
>>>> +    struct vcpu_hdbss_state hdbss;
>>>>   };
>>>>
>>>>   /*
>>>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/ 
>>>> asm/kvm_mmu.h
>>>> index e4069f2ce642..6ace1080aed5 100644
>>>> --- a/arch/arm64/include/asm/kvm_mmu.h
>>>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>>>> @@ -331,6 +331,23 @@ static __always_inline void 
>>>> __load_stage2(struct kvm_s2_mmu *mmu,
>>>>       asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>>>>   }
>>>>
>>>> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct kvm *kvm = vcpu->kvm;
>>>> +    u64 br_el2, prod_el2;
>>>> +
>>>> +    if (!kvm->enable_hdbss)
>>>> +        return;
>>>> +
>>>> +    br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu- 
>>>> >arch.hdbss.size);
>>>> +    prod_el2 = vcpu->arch.hdbss.next_index;
>>>> +
>>>> +    write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
>>>> +    write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
>>>> +
>>>> +    isb();
>>>> +}
>>>> +
>>>>   static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>>>>   {
>>>>       return container_of(mmu->arch, struct kvm, arch);
>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>> index 870953b4a8a7..64f65e3c2a89 100644
>>>> --- a/arch/arm64/kvm/arm.c
>>>> +++ b/arch/arm64/kvm/arm.c
>>>> @@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu 
>>>> *vcpu)
>>>>       return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>>>   }
>>>>
>>>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct page *hdbss_pg = NULL;
>>>> +
>>>> +    hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
>>>> +    if (hdbss_pg)
>>>> +        __free_pages(hdbss_pg, vcpu->arch.hdbss.size);
>>>> +
>>>> +    vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>>>> +        .base_phys = 0,
>>>> +        .size = 0,
>>>> +        .next_index = 0,
>>>> +    };
>>>> +}
>>>> +
>>>> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
>>>> +                    struct kvm_enable_cap *cap)
>>>> +{
>>>> +    unsigned long i;
>>>> +    struct kvm_vcpu *vcpu;
>>>> +    struct page *hdbss_pg = NULL;
>>>> +    int size = cap->args[0];
>>>> +    int ret = 0;
>>>> +
>>>> +    if (!system_supports_hdbss()) {
>>>> +        kvm_err("This system does not support HDBSS!\n");
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    if (size < 0 || size > HDBSS_MAX_SIZE) {
>>>> +        kvm_err("Invalid HDBSS buffer size: %d!\n", size);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>
>>> I think you should check if it's already enabled here. What if user 
>>> space calls this twice?
>>
>> Ok, I review the implement of qemu, when disable the hdbss feature in
>> ram_save_cleanup, size=0 will be set, so here can add a check, if (size
>> && kvm->arch.enable_hdbss), we will do nothing.
>>
>
> I mean you should check if ' kvm->enable_hdbss' is already set, if so, 
> return rather than alloc_pages() in below (you have allocated in 
> previous call with valid 'size').
>
> qemu is just one of the user space applications that would possibly 
> call this API, you cannot rely on your qemu patch's flow/sequence as 
> assumption to design a KVM API's implementation.


Yes, The latest v3 patch fixes this bug by checking if (size > 0 && 
kvm->arch.enable_hdbss).
When this condition is met, the function returns immediately rather than 
alloc_pages().


>
>>>
>>>> +    /* Enable the HDBSS feature if size > 0, otherwise disable it. */
>>>> +    if (size) {
>>>> +        kvm_for_each_vcpu(i, vcpu, kvm) {
>>>> +            hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
>>>> +            if (!hdbss_pg) {
>>>> +                kvm_err("Alloc HDBSS buffer failed!\n");
>>>> +                ret = -ENOMEM;
>>>> +                goto error_alloc;
>>>> +            }
>>>> +
>>>> +            vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>>>> +                .base_phys = page_to_phys(hdbss_pg),
>>>> +                .size = size,
>>>> +                .next_index = 0,
>>>> +            };
>>>> +        }
>>>> +
>>>> +        kvm->enable_hdbss = true;
>>>> +        kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;
>>>
>
>


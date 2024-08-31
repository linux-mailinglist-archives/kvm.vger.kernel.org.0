Return-Path: <kvm+bounces-25618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC50966E5E
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 03:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97B0B284241
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 01:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82AA23759;
	Sat, 31 Aug 2024 01:15:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD223749;
	Sat, 31 Aug 2024 01:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725066916; cv=none; b=Gmamu6MO/UNDMNmjsEVCNZ7QQB7kEm9e90DMsqgLcczL4IpNqZMOAQyjXr/tV3P4KlaDjCngz/0jiLjvsIxpsygSCYdnhhcr2w3Q8APu/9epVD3JEsC7NZOp9TyZlNtz/K2NUZt+NAMr3ttDL37Pf+8Q9Yf7EqIiVh1QmbTv/B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725066916; c=relaxed/simple;
	bh=irLYLosr12ArP/wZ4Ha75M17Hdfex1a8lKkEm8iNpmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nWAGClIJ343uxkRD1RE2kpGKeCne2nh4JACNd8vv8hmnVP/mBXY8NYIU+r6h2VSGuJliBRWkLcbjYw123H+ONJ5JcD6dzJJlbqrF6oqfZMJXitBav5VuFet8LoVIrr62FgNM3cdguWn1fHC3lPkKyu3XERgOEhEObTXXEc/+wf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WwcWM6Ykwz1j7Nx;
	Sat, 31 Aug 2024 09:14:55 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 6894E140133;
	Sat, 31 Aug 2024 09:15:10 +0800 (CST)
Received: from [10.174.179.113] (10.174.179.113) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 31 Aug 2024 09:15:09 +0800
Message-ID: <b77289a9-8bbb-9ddf-facd-0a310da6122a@huawei.com>
Date: Sat, 31 Aug 2024 09:15:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH -next] KVM: x86: Remove some unused declarations
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240830022537.2403873-1-yuehaibing@huawei.com>
 <ZtFCb_zN1eik3Xn-@google.com>
From: Yue Haibing <yuehaibing@huawei.com>
In-Reply-To: <ZtFCb_zN1eik3Xn-@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

On 2024/8/30 11:54, Sean Christopherson wrote:
> On Fri, Aug 30, 2024, Yue Haibing wrote:
>> Commit 238adc77051a ("KVM: Cleanup LAPIC interface") removed
>> kvm_lapic_get_base() but leave declaration.
>>
>> And other two declarations were never implenmented since introduction.
>>
>> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
>> ---
>>  arch/x86/kvm/lapic.h            | 1 -
>>  arch/x86/kvm/mmu.h              | 2 --
>>  arch/x86/kvm/mmu/mmu_internal.h | 2 --
>>  3 files changed, 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index 7ef8ae73e82d..7c95eedd771e 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -96,7 +96,6 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
>>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>>  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>> -u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> 
> Ha!  I have an APIC base cleanup series that I'm about to post that modifies
> these APIs and does a similar cleanup.  I might defer deleting this declaration
> to that series, purely for branch orginization purposes.  Hmm, or maybe I'll
> split this into two patches.
> 
> Anyways, just an FYI that I might tweak this slightly.  No action needed on your
> end, I'll get this applied for 6.12, one way or another.

Got it, thanks！
> 
>>  void kvm_recalculate_apic_map(struct kvm *kvm);
>>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>>  void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 4341e0e28571..9dc5dd43ae7f 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -223,8 +223,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>  
>>  bool kvm_mmu_may_ignore_guest_pat(void);
>>  
>> -int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>> -
>>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>>  
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index 1721d97743e9..1469a1d9782d 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -349,8 +349,6 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>>  
>> -void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>> -
>>  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>>  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>>  
>> -- 
>> 2.34.1
>>
> .


Return-Path: <kvm+bounces-33190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 297629E6517
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 04:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A92981884C06
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 03:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE93191F75;
	Fri,  6 Dec 2024 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mmp/o2H7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEFF13DDDF;
	Fri,  6 Dec 2024 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733456260; cv=none; b=YB8cNnQ2jMhfwnWlT1kERuvvYEt0pqcahDmk8Ry3OEKv+0/hs7PU03C5NjkVS4gyI2ZbKNf1YmAYydCtRfV/QlQjtXUh9MhWyDazTYoIVaiIKhijs5iMX25qtWTvY35eoOs0JvCqPU1t+33b8KoQzLjqr1eJ9hy1zLpOh9hhi1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733456260; c=relaxed/simple;
	bh=WrKwAGr9rCPIoNqYi8F9dNIcqs5fsyfUF/2DoTg4HCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ni7mWkfaKc/GtSlZRg2HuhYilEgHgLuNBrYha8mso2IcuUjLR2QB45NwKzMPmJKrt6WozEpEqw4kP8pcUphnz8ri8jSdxPsvqWSwi7pV9bTPWuWlySVsjlXqG5corlbeOA0ZpQGwHFv0fIRBxC14TEHN4cPoagjb/GJ+2SCC8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mmp/o2H7; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733456258; x=1764992258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WrKwAGr9rCPIoNqYi8F9dNIcqs5fsyfUF/2DoTg4HCQ=;
  b=mmp/o2H7m8bepPnb1BwQMu2lWMxdR8uDStr/2Z+MhOtcfUwqgCZgkKqK
   T130duaLhPl+ZdyRob8vrVPoVjOtkuYt6BD2E3E5oO3onQbks83Qsaeo3
   zpM4O3QWU12/fXMZq/yLdGkeZBguhyT4KNbYiIgcvMxruTfpPGA6Jy3VL
   MzuWXoteh0bhvu5OziUcuPXZSSIasDABEjHfMocNehJCsjT4I0H9V3/3D
   xlt+79hzt9JEisHwoUllJw0gY2cg0WVScVR3T3f5fmSWW7SCX0duXomtQ
   XRmqYZzHbV+GKYdpFjcvTxN7doCxmuuUEnMgOqQ48aJtWryAV4CyPy/Aa
   A==;
X-CSE-ConnectionGUID: EEoxDbwQRUGm12BkDCo4QA==
X-CSE-MsgGUID: RwBp05oeRg6BZmzAONgcsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="44269524"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="44269524"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 19:37:38 -0800
X-CSE-ConnectionGUID: LzfPS1TfTDmpsAGKGiZd/Q==
X-CSE-MsgGUID: dbn1X0P1QEODfzWbuDfy3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="94488859"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 19:37:33 -0800
Message-ID: <3f52c362-ac1b-4435-92c8-81ec97992b02@intel.com>
Date: Fri, 6 Dec 2024 11:37:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: Adrian Hunter <adrian.hunter@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Huang, Kai"
 <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yang, Weijiang" <weijiang.yang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com> <Z0+vdVRptHNX5LPo@intel.com>
 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com> <Z0/4wsR2WCwWfZyV@intel.com>
 <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com> <Z1A5QWaTswaQyE3k@intel.com>
 <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
 <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
 <84964644-e53f-4aac-b827-5626393f8c25@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <84964644-e53f-4aac-b827-5626393f8c25@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/6/2024 1:31 AM, Adrian Hunter wrote:
> On 4/12/24 17:33, Xiaoyao Li wrote:
>> On 12/4/2024 7:55 PM, Adrian Hunter wrote:
>>> On 4/12/24 13:13, Chao Gao wrote:
>>>> On Wed, Dec 04, 2024 at 08:57:23AM +0200, Adrian Hunter wrote:
>>>>> On 4/12/24 08:37, Chao Gao wrote:
>>>>>> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>>>>>>> On 4/12/24 03:25, Chao Gao wrote:
>>>>>>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>>>>>>> +
>>>>>>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    return entry->function == 7 && entry->index == 0 &&
>>>>>>>>> +           (entry->ebx & TDX_FEATURE_TSX);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    entry->ebx &= ~TDX_FEATURE_TSX;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    return entry->function == 7 && entry->index == 0 &&
>>>>>>>>> +           (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    if (has_tsx(entry))
>>>>>>>>> +        clear_tsx(entry);
>>>>>>>>> +
>>>>>>>>> +    if (has_waitpkg(entry))
>>>>>>>>> +        clear_waitpkg(entry);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>>>>>>> +{
>>>>>>>>> +    return has_tsx(entry) || has_waitpkg(entry);
>>>>>>>>> +}
>>>>>>>>
>>>>>>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>>>>>>> ensures that unconfigurable bits are not set by userspace.
>>>>>>>
>>>>>>> Aren't they configurable?
>>>>>>
>>>>>> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
>>>>>> so they are not configurable from a userspace perspective. Did I miss anything?
>>>>>> KVM should check user inputs against its adjusted configurable bitmap, right?
>>>>>
>>>>> Maybe I misunderstand but we rely on the TDX module to reject
>>>>> invalid configuration.  We don't check exactly what is configurable
>>>>> for the TDX Module.
>>>>
>>>> Ok, this is what I missed. I thought KVM validated user input and masked
>>>> out all unsupported features. sorry for this.
>>>>
>>>>>
>>>>> TSX and WAITPKG are not invalid for the TDX Module, but KVM
>>>>> must either support them by restoring their MSRs, or disallow
>>>>> them.  This patch disallows them for now.
>>>>
>>>> Yes. I agree. what if a new feature (supported by a future TDX module) also
>>>> needs KVM to restore some MSRs? current KVM will allow it to be exposed (since
>>>> only TSX/WAITPKG are checked); then some MSRs may get corrupted. I may think
>>>> this is not a good design. Current KVM should work with future TDX modules.
>>>
>>> With respect to CPUID, I gather this kind of thing has been
>>> discussed, such as here:
>>>
>>>      https://lore.kernel.org/all/ZhVsHVqaff7AKagu@google.com/
>>>
>>> and Rick and Xiaoyao are working on something.
>>>
>>> In general, I would expect a new TDX Module would advertise support for
>>> new features, but KVM would have to opt in to use them.
>>>
>>
>> There were discussion[1] on whether KVM to gatekeep the configurable/supported CPUIDs for TDX. I stand by Sean that KVM needs to do so.
>>
>> Regarding KVM opt in the new feature, KVM gatekeeps the CPUID bit that can be set by userspace is exactly the behavior of opt-in. i.e., for a given KVM, it only allows a CPUID set {S} to be configured by userspace, if new TDX module supports new feature X, it needs KVM to opt-in X by adding X to {S} so that X is allowed to be configured by userspace.
>>
>> Besides, I find current interface between KVM and userspace lacks the ability to tell userspace what bits are not supported by KVM. KVM_TDX_CAPABILITIES.cpuid doesn't work because it represents the configurable CPUIDs, not supported CPUIDs (I think we might rename it to configurable_cpuid to better reflect its meaning). So userspace has to hardcode that TSX and WAITPKG is not support itself.
> 
> I don't follow why hardcoding would be necessary.
> 
> If the leaf is represented in KVM_TDX_CAPABILITIES.cpuid, and
> the bits are 0 there, why would userspace try to set them to 1?

Userspace doesn't set the bit to 1 in kvm_tdx_init_vm.cpuid, doesn't 
mean userspace wants the bit to be 0.

Note, KVM_TDX_CAPABILITIES.cpuid reports the configurable bits. The 
value 0 of a bit in KVM_TDX_CAPABILITIES.cpuid means the bit is not 
configurable, not means the bit is unsupported.

For kvm_tdx_init_vm.cpuid,
  - if the corresponding bit is reported as 1 in 
KVM_TDX_CAPABILITIES.cpuid, then a value 0 in kvm_tdx_init_vm.cpuid 
means userspace wants to configure it as 0.
  - if the corresponding bit is reported as 0 in 
KVM_TDX_CAPABILITIES.cpuid, then userspace has to pass a value 0 in 
kvm_tdx_init_vm.cpuid. But it doesn't mean the value of the bit will be 0.

e.g., X2APIC bit is 0 in KVM_TDX_CAPABILITIES.cpuid, and it's also 0 in 
kvm_tdx_init_vm.cpuid, but TD guest sees a value of 1. In the view of 
QEMU, it maintains the bit of X2APIC as 1, and QEMU filters X2APIC bit 
when calling KVM_TDX_INIT_VM because X2APIC is not configurable.

So when it comes to TSX and WAITPKG, QEMU also needs an interface to be 
informed that they are unsupported. Without the interface of fixed0 bits 
reported by KVM, QEMU needs to hardcode itself like [1]. The problem of 
hardcode is that it will conflict when future KVM allows them to be 
configurable.

In the future, if we have interface from KVM to report the fixed0 and 
fixed1 bit (on top of the proposal [2]), userspace can drop the 
hardcoded one it maintains. At that time, KVM can ensure no conflict by 
removing the bits from fixed0/1 array when allowing them to be 
configurable.

[1] 
https://lore.kernel.org/qemu-devel/20241105062408.3533704-49-xiaoyao.li@intel.com/
[2] 
https://lore.kernel.org/all/43b26df1-4c27-41ff-a482-e258f872cc31@intel.com/

>>
>> [1] https://lore.kernel.org/all/ZuM12EFbOXmpHHVQ@google.com/
>>
> 



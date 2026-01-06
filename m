Return-Path: <kvm+bounces-67179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A59ABCFB07E
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA47B3028596
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706382BCF68;
	Tue,  6 Jan 2026 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ewMcDi5S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723D22CBE6
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767733436; cv=none; b=WXQBqMWYmAetOGbbgRK2fh4s3+d8u61frfPrJcKELCSaLhE8pHnMZofJ8DxuaKwLTzpEk+FFKL6Iy2IW3NILC1jzFeLwFJRGaXjve7zE9TLlRlaTw0BUqFdOc1c7JHPq+wn/3jm62jwAJW8ThHQ3El2H9DbNzip9/fDX/gIUNiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767733436; c=relaxed/simple;
	bh=0Mpby0dh9MMSR13M59qLjEHM8s7pdUBODbXo9EKiM2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBAAB4iF6yIgZ+rZgyC6Lwo5Xg+8u8l18JzMQWnI/TARtTUMTK33/hybTO5XLc7hQIA/wLfEJVZ631GX2PQvdnFXHjWo8MeDPJr7rel3Kth9RO5ad8DgMqSEDxumRskulapf36sD0iJ5Gxvi1uyrwzTukfp9MjLvTsJ1Y47CSZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ewMcDi5S; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767733435; x=1799269435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0Mpby0dh9MMSR13M59qLjEHM8s7pdUBODbXo9EKiM2k=;
  b=ewMcDi5SgZ5kRpSdTXcmFJsK/GT3fO+GQBvGKDzzm0ktPEF8Hd5BrBd3
   eAjTblvnoPh5ca3eJKCKCF2u7HDCwmNirOL6kCibG6ihaU5bSjjmdo2xD
   57PFtuLoBYzHDeB1N6xSDelSsEn4bil7y5KcsKXoeFMHfOdaNTs7v8K/9
   7x0tXfu2vcNlWUfTm9POyThOkOQlb9Ugf8Smf9/4mM6TDOnN9M8XMywsm
   W+1rvXkVg56VqXkGZuBiooCCB5MyE+cv4SmanMBTkDazH4rMOTVtqKeF9
   ootkDjoXugtcuNd2IQm6DeaWvQMG2sidMXymvrYfB3wslK9CpEyBOCx3E
   g==;
X-CSE-ConnectionGUID: I5xiMuTESPeW13UWbFJIVg==
X-CSE-MsgGUID: IKeLGFgISA2jK+Lv5peOag==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69179162"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="69179162"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:03:54 -0800
X-CSE-ConnectionGUID: zW80d5AASpWUX08HJVoptQ==
X-CSE-MsgGUID: wBiWR5PiRZOzr01nqyI3eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202651604"
Received: from unknown (HELO [10.241.241.119]) ([10.241.241.119])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:03:53 -0800
Message-ID: <e9762b91-175e-444d-b64c-dcded943b312@intel.com>
Date: Tue, 6 Jan 2026 13:03:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] target/i386/kvm: query kvm.enable_pmu parameter
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-5-dongli.zhang@oracle.com>
 <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
 <29969c2f-d71f-4952-9ab4-4ba8f69e1514@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <29969c2f-d71f-4952-9ab4-4ba8f69e1514@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/5/2026 12:21 PM, Dongli Zhang wrote:
> Hi Zide,
> 
> On 1/2/26 2:59 PM, Chen, Zide wrote:
>>
>>
>> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
> 
> [snip]
> 
>>>  
>>>  static struct kvm_cpuid2 *cpuid_cache;
>>>  static struct kvm_cpuid2 *hv_cpuid_cache;
>>> @@ -2068,23 +2072,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>      if (first) {
>>>          first = false;
>>>  
>>> -        /*
>>> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>> -         * disable PMUs; however, QEMU has been providing PMU property per
>>> -         * CPU since v1.6. In order to accommodate both, have to configure
>>> -         * the VM-level capability here.
>>> -         *
>>> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>> -         * behavior on Intel platform because current "pmu" property works
>>> -         * as expected.
>>> -         */
>>> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
>>> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>> -                                    KVM_PMU_CAP_DISABLE);
>>> -            if (ret < 0) {
>>> -                error_setg_errno(errp, -ret,
>>> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
>>> -                return ret;
>>> +        if (X86_CPU(cpu)->enable_pmu) {
>>> +            if (kvm_pmu_disabled) {
>>> +                warn_report("Failed to enable PMU since "
>>> +                            "KVM's enable_pmu parameter is disabled");
>>
>> I'm wondering about the intended value of this patch?
>>
>> If enable_pmu is true in QEMU but the corresponding KVM parameter is
>> false, then KVM_GET_SUPPORTED_CPUID or KVM_GET_MSRS should be able to
>> tell that the PMU feature is not supported by host.
>>
>> The logic implemented in this patch seems somewhat redundant.
> 
> For Intel, the QEMU userspace can determine if the vPMU is disabled by KVM
> through the use of KVM_GET_SUPPORTED_CPUID.
> 
> However, this approach does not apply to AMD. Unlike Intel, AMD does not rely on
> CPUID to detect whether PMU is supported. By default, we can assume that PMU is
> always available, except for the recent PerfMonV2 feature.
> 
> The main objective of this PATCH 4/7 is to introduce the variable
> 'kvm_pmu_disabled', which will be reused in PATCH 5/7 to skip any PMU
> initialization if the parameter is set to 'N'.
> 
> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }

Thanks for explanation.

> The 'kvm_pmu_disabled' variable is used to differentiate between the following
> two scenarios on AMD:
> 
> (1) A newer KVM with KVM_PMU_CAP_DISABLE support, but explicitly disabled via
> the KVM parameter ('N').
> 
> (2) An older KVM without KVM_CAP_PMU_CAPABILITY support.
> 
> In both cases, the call to KVM_CAP_PMU_CAPABILITY extension support check may
> return 0.
> 
> By reading the file "/sys/module/kvm/parameters/enable_pmu", we can distinguish
> between these two scenarios.

As described in PATCH 1/7, without issuing KVM_PMU_CAP_DISABLE, KVM has
no way to know that userspace does not intend to enable vPMU in AMD
platforms, and therefore does not fault guest accesses to PMU MSRs.

My understanding is that the issue being addressed here is basically the
opposite: QEMU does not know that vPMU is disabled by KVM.

IIUC, one difference between Intel and AMD is that AMD lacks a CPUID
leaf to indicate the availability of PMU version 1. But Intel
potentially could be in the same situation that KVM advertises PMU
availability but it's not actually supported. (e.g. kvm->arch.enable_pmu
is false while modules parameter enable_pmu is true).

From the guest’s point of view, it probes PMU MSRs to determine whether
PMU support is present and it's fine in this situation.

In userspace, QEMU may issue KVM_SET_MSRS / KVM_GET_MSRS to KVM without
knowing that vPMU has been disabled by KVM.  I think these IOCTLs should
not fail, since KVM states that “Userspace is allowed to read MSRs, and
write ‘0’ to MSRs, that KVM advertises to userspace, even if an MSR
isn’t fully supported.”

My current understanding is that AMD should be fine even without
kvm_pmu_disabled, but I may be missing some context here.

The bottom line is this patch doesn't handle the cases that KVM still
could disable vPMU support even if enable_pmu is true.


> As you mentioned, another approach would be to use KVM_GET_MSRS to specifically
> probe for AMD during QEMU initialization. In this case, we can set
> 'kvm_pmu_disabled' to true if reading the AMD PMU MSR registers fails.
> 
> To implement this, we may need to:
> 
> 1. Turn this patch to be AMD specific by probing the AMD PMU registers during
> initialization. We may need go create a new function in QEMU to use KVM_GET_MSRS
> for probing only, or we may re-use kvm_arch_get_supported_msr_feature() or
> kvm_get_one_msr(). I may change in the next version.
> 
> 2. Limit the usage of 'kvm_pmu_disabled' to be AMD specific in PATCH 5/7.

I guess this might make things more complicated.

>>
>> Additionally, in this scenario — where the user intends to enable a
>> feature but the host cannot support it — normally no warning is emitted
>> by QEMU.
> 
> According to the usage of QEMU, may I assume QEMU already prints warning logs
> for unsupported features? The below is an example.
> 
> QEMU 10.2.50 monitor - type 'help' for more information
> qemu-system-x86_64: warning: host doesn't support requested feature:
> CPUID[eax=07h,ecx=00h].EBX.hle [bit 4]
> qemu-system-x86_64: warning: host doesn't support requested feature:
> CPUID[eax=07h,ecx=00h].EBX.rtm [bit 11]
> 
>>
>>> +            }
>>> +        } else {
>>> +            /*
>>> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
>>> +             * disable PMUs; however, QEMU has been providing PMU property per
>>> +             * CPU since v1.6. In order to accommodate both, have to configure
>>> +             * the VM-level capability here.
>>> +             *
>>> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>> +             * behavior on Intel platform because current "pmu" property works
>>> +             * as expected.
>>> +             */
>>> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
>>> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>> +                                        KVM_PMU_CAP_DISABLE);
>>> +                if (ret < 0) {
>>> +                    error_setg_errno(errp, -ret,
>>> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
>>> +                    return ret;
>>> +                }
>>>              }
>>>          }
>>>      }
>>> @@ -3302,6 +3313,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>      int ret;
>>>      struct utsname utsname;
>>>      Error *local_err = NULL;
>>> +    g_autofree char *kvm_enable_pmu;
>>>  
>>>      /*
>>>       * Initialize confidential guest (SEV/TDX) context, if required
>>> @@ -3437,6 +3449,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>  
>>>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>>>  
>>> +    /*
>>> +     * The enable_pmu parameter is introduced since Linux v5.17,
>>> +     * give a chance to provide more information about vPMU
>>> +     * enablement.
>>> +     *
>>> +     * The kvm.enable_pmu's permission is 0444. It does not change
>>> +     * until a reload of the KVM module.
>>> +     */
>>> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>>> +                            &kvm_enable_pmu, NULL, NULL)) {
>>> +        if (*kvm_enable_pmu == 'N') {
>>> +            kvm_pmu_disabled = true;
>>
>> It’s generally better not to rely on KVM’s internal implementation
>> unless really necessary.
>>
>> For example, in the new mediated vPMU framework, even if the KVM module
>> parameter enable_pmu is set, the per-guest kvm->arch.enable_pmu could
>> still be cleared.
>>
>> In such a case, the logic here might not be correct.
> 
> Would the Mediated vPMU set KVM_PMU_CAP_DISABLE to clear per-VM enable_pmu even
> when the global KVM parameter enable_pmu=N is set?
> 
> In this scenario, we plan to rely on KVM_PMU_CAP_DISABLE only when the value of
> "/sys/module/kvm/parameters/enable_pmu" is not equal to N.
> 
> Can I assume that this will work with Mediated vPMU?
> 
> 
> Is there any possibility to follow the current approach before Mediated vPMU is
> finalized for mainline, and later introduce an incremental change using
> KVM_GET_MSRS probing? The current approach is straightforward and can work with
> existing Linux kernel source code.

Apologies for the incorrect statement I made earlier regarding mediated
vPMU.

According to the mediated vPMU v6, the only behavior specific to
mediated vPMU is that kvm->arch.enable_pmu may be cleared when
irqchip_in_kernel() is not true:
https://lore.kernel.org/all/20251206001720.468579-17-seanjc@google.com/

However, this does not imply that mediated vPMU requires any special
handling here. In theory, KVM could clear kvm->arch.enable_pmu in the
future for other reasons.


> For quite some time, QEMU has lacked support for disabling or resetting AMD PMU
> registers. If we could add this feature before Mediated vPMU is finalized, it
> would benefit many existing kernel versions. This patchset solves production bugs.
> 
> 
> Feel free to let me know your thought, while I would starting working on next
> version now.
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 



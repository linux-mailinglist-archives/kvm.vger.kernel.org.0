Return-Path: <kvm+bounces-37696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7702BA2F1BA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42AE71621AE
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 15:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC23424BCEE;
	Mon, 10 Feb 2025 15:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IoLtqbVC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E724BCE6;
	Mon, 10 Feb 2025 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739201383; cv=none; b=oR1QUVH1LFGi0RqF78Krs16V110rf3oL8hjeVoW7gw6YiCqWZe/S7LX9xMZALVniz5NAcKWY/BzdIfyHj3cDsiAeepfpo5nh24MTWW2p7x9JdTYqYbJnT1t0fFoPrvLl5hCj0Bh7W5KJVulqsyR5t8SGvf7ZLkqF21bC66qdrDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739201383; c=relaxed/simple;
	bh=quV1lTLedgn2WTA4MKqGbb8ogSma6DpN9SeU5YJkhiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpo4fCsdlEBcsjr6bOtc2kioEP2Pbz5IkgPw3sx3F8AMCtqbUfVvXyBzGNBLNXdCLx0DZVby60yRZr097n+KHL9SuWSKL92XB11tJhEx4ACXnXEheB6lPpCpuHumd84vhK7wbnzsMO1BjBWTJx8oiIrpICZBPUe1Yk85NCg6piI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IoLtqbVC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739201381; x=1770737381;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=quV1lTLedgn2WTA4MKqGbb8ogSma6DpN9SeU5YJkhiU=;
  b=IoLtqbVC5dmI6mXgk0qZXZpWJMRgxQkaUfUIhS8PyuR11lmmv15tUtz8
   UxEDrILhbU8cCZOEhkpMIopjLCko1rTkOCXLlrmoiJEzvxP7R0O1LQ1mU
   9Ky+/AUlUMrjmVjArB6E/LGyj7MMbqkVd6OZglPViDEWtc8Imr2ZJ6942
   wWvsPvbBb48Wb9VtuLGTq8d6DPxm/DNPcXwOQftQOQmnBogTLE2xmDJ92
   sVS82fhedJBOkwRQoabSeQyUaxG60qpox2RnVXFDoKN3qtLdwjwsQEo00
   VYAAHKrlSXnf9hD8RSYedGRY43ti0+++FgX4gkLtlOQgCtO/iZBQCmkrS
   Q==;
X-CSE-ConnectionGUID: +cWBopzdQYW2wUBDYyWnWQ==
X-CSE-MsgGUID: hZMRlERKSomeXJJKAICMtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="50417037"
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="50417037"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 07:29:40 -0800
X-CSE-ConnectionGUID: zQawmnv+RtqKuo8jJzEiKQ==
X-CSE-MsgGUID: mwI6DrvCRd65/jRpObNBbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="112439978"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.228]) ([10.124.241.228])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 07:29:36 -0800
Message-ID: <f133d093-fb91-4dd6-b936-cd4a17c24ecf@linux.intel.com>
Date: Mon, 10 Feb 2025 23:29:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>, "Xu, Min M"
 <min.m.xu@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "dionnaglaze@google.com" <dionnaglaze@google.com>,
 Binbin Wu <binbin.wu@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "vkuznets@redhat.com"
 <vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "jgross@suse.com" <jgross@suse.com>, "pgonda@google.com"
 <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>,
 jiewen.yao@intel.com, Binbin Wu <binbin.wu@linux.intel.com>
References: <20250201005048.657470-1-seanjc@google.com>
 <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
 <Z6EoAAHn4d_FujZa@google.com>
 <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
 <Z6Fe1nFWv52rDijx@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6Fe1nFWv52rDijx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/4/2025 8:27 AM, Sean Christopherson wrote:
> On Mon, Feb 03, 2025, Rick P Edgecombe wrote:
>> On Mon, 2025-02-03 at 12:33 -0800, Sean Christopherson wrote:
>>>> Since there is no upstream KVM TDX support yet, why isn't it an option to
>>>> still
>>>> revert the EDKII commit too? It was a relatively recent change.
>>> I'm fine with that route too, but it too is a band-aid.  Relying on the
>>> *untrusted*
>>> hypervisor to essentially communicate memory maps is not a winning strategy.
>>>
>>>> To me it seems that the normal KVM MTRR support is not ideal, because it is
>>>> still lying about what it is doing. For example, in the past there was an
>>>> attempt to use UC to prevent speculative execution accesses to sensitive
>>>> data.
>>>> The KVM MTRR support only happens to work with existing guests, but not all
>>>> possible MTRR usages.
>>>>
>>>> Since diverging from the architecture creates loose ends like that, we could
>>>> instead define some other way for EDKII to communicate the ranges to the
>>>> kernel.
>>>> Like some simple KVM PV MSRs that are for communication only, and not
>>> Hard "no" to any PV solution.  This isn't KVM specific, and as above, bouncing
>>> through the hypervisor to communicate information within the guest is asinine,
>>> especially for CoCo VMs.
>> Hmm, right.
>>
>> So the other options could be:
>>
>> 1. Some TDX module feature to hold the ranges:
>>   - Con: Not shared with AMD
>>
>> 2. Re-use MTRRs for the communication, revert changes in guest and edk2:
> Thinking more about how EDK2 is consumed downstream, I think reverting the EDK2
> changes is necessary regardless of what happens in the kernel.
IIUC, 071d2cfab8 ("OvmfPkg/Sec: Skip setup MTRR early in TD-Guest") was added
to avoid changing the setting of MTRR, which will trigger #VE by setting
CR0.CD=1.

And recently, 3a3b12cbda ("UefiCpuPkg/MtrrLib: MtrrLibIsMtrrSupported always
return FALSE in TD-Guest") was added to avoid touching MTRR MSRs at all,
so that the MTRR MSRs support for TDX guests was dropped as described in
[PATCH 00/18] KVM: TDX: TDX "the rest" part [1].

If we want to revert the two commits, we need to:
1. Make sure that OVMF will not set CR0.CD to 1 for TDX guests, probably
    needs some kind of hack in OVMF.

2. Need to bring back the support of MTRR MSRs in KVM for TDX guests.
    TDX KVM basic support patch set v19 and earlier versions enforce default
    MTRR type as WB and disabled fixed/variable MTRR (by reporting MSR_MTRRcap
    as 0) for TDX guests, which was kind of half support and needed
    "clearcpuid=mtrr" to avoid toggling of CR0.CD.

    If we really want to rely on the OVMF to program the MTRR values, maybe we
    can treat MTRR MSRs for TDX guests as normal VMs, i.e., allow guests to
    read/write the values without any further virtualization.
    Of course, it needs to prompt the guest kernel to skip toggling CR0.CD for
    TDX guests.

[1] https://lore.kernel.org/kvm/20241210004946.3718496-1-binbin.wu@linux.intel.com


>    Or at the least,
> somehow communicate to EDK2 users that ingesting those changes is a bad idea
> unless the kernel has also been updated.
>
> AFAIK, Bring Your Own Firmware[*] isn't widely adopted, which means that the CSP
> is shipping the firmware.  And shipping OVMF/EDK2 with the "ignores MTRRs" code
> will cause problems for guests without commit 8e690b817e38 ("x86/kvm: Override
> default caching mode for SEV-SNP and TDX").  Since the host doesn't control the
> guest kernel, there's no way to know if deploying those EDK2 changes is safe.

Oh, yea.

And if we drop the MTRR MSRs access in KVM for TDX guests, an old guest kernel
without commit 8e690b817e38 ("x86/kvm: Override default caching mode for
SEV-SNP and TDX") will require "clearcpuid=mtrr". :(

>   
> [*] https://kvm-forum.qemu.org/2024/BYOF_-_KVM_Forum_2024_iWTioIP.pdf
>
>>   - Con: Creating more half support, when it's technically not required
>>   - Con: Still bouncing through the hypervisor
> I assume by "Re-use MTRRs for the communication" you also mean updating the guest
> to address the "everything is UC!" flaw, otherwise another con is:
>
>     - Con: Doesn't address the performance issue with TDX guests "using" UC
>            memory by default (unless there's yet more enabled).
>
> Presumably that can be accomplished by simply skipping the CR0.CD toggling, and
> doing MTRR stuff as nonrmal?
>
>>   - Pro: Design and code is clear
>>
>> 3. Create some new architectural definition, like a bit that means "MTRRs don't
>> actually work:
>>   - Con: Takes a long time, need to get agreement
>>   - Con: Still bouncing through the hypervisor
> Not for KVM guests.  As I laid out in my bug report, it's safe to assume MTRRs
> don't actually affect the memory type when running under KVM.
>
> FWIW, PAT doesn't "work" on most KVM Intel setups either, because of misguided
> KVM code that resulted in "Ignore Guest PAT" being set in all EPTEs for the
> overwhelming majority of guests.  That's not desirable long term because it
> prevents the guest from using WC (via PAT) in situations where doing so is needed
> for performance and/or correctness.
>
>>   - Pro: More pure solution
> MTRRs "not working" is a red herring.  The problem isn't that MTRRs don't work,
> it's that the kernel is (somewhat unknowingly) using MTRRs as a crutch to get the
> desired memtype for devices.  E.g. for emulated MMIO, MTRRs _can't_ be virtualized,
> because there's never a valid mapping, i.e. there is no physical memory and thus
> no memtype.  In other words, under KVM guests (and possibly other hypervisors),
> MTRRs end up being nothing more than a communication channel between guest firmware
> and the kernel.
>
> The gap for CoCo VMs is that using MTRRs is undesirable because they are controlled
> by the untrusted host.  But that's largely a future problem, unless someone has a
> clever way to fix the kernel mess.
>
>> 4. Do this series:
>>   - Pro: Looks ok to me
It looks OK to me too.
But as mentioned above, mismatch of OVMF, guest kernel, host kernel
version will cause problem.

>>   - Cons: As explained in the patches, it's a bit hacky.
Skipping toggling CR0.CD in guest kernel seems also a bit hacky.

>>   - Cons: Could there be more cases than the legacy PCI hole?
>>
>> I would kind of like to see something like 3, but 2 or 4 seem the only feasible
>> ones if we want to resolve this soon.



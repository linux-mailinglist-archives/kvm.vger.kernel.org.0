Return-Path: <kvm+bounces-53119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC01B0D980
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08D80564454
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 12:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5532E9EA3;
	Tue, 22 Jul 2025 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WyvFfeBm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE982E3AF7
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753186992; cv=none; b=BXT4PUVa7NRfl5+NmCxFeqoUjAKKD59p4PhbG43c9lP1o3ICBGhldsCmH6eMK1OWgEEi0Di+EOoIQM1bSOTjvezNbcSbRs58NQtrXTxPg2MDxg1EFi40LkXohS1220Lo0AtxFS8bqjHpOzlNGYnO3ss7FjXAkRJL3aKZ7+YeBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753186992; c=relaxed/simple;
	bh=WTKpFAUaMH3gTX/82ufgLc6VaesBS81C1+Rq7IwfKuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0eg7jd/kaUfoDCwl3hCSCUydJFiXv8iVQi3S5VW99tn3Ls2Y4kX7dCUHwxxNPsqXFw/54jK/N2kZg016eRQpINR/wRDacXGWw7Xv7/2myHBc5MZItGW/Np2uFPQ3AKYiCBXBuIlmb5l/i8WvvCXhj+25DEMAZUyUZHtparW6Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WyvFfeBm; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753186991; x=1784722991;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WTKpFAUaMH3gTX/82ufgLc6VaesBS81C1+Rq7IwfKuE=;
  b=WyvFfeBmJlUipddklAwMz7ix1Vd5fvbwCXvpR3C0+TRdc1l4rCSiWgot
   4UT3biyt2uIXXwp1k0hTIUbr2NcfyBNlrIFEYFNx5+dKtzjK7xR0wcg+2
   SUfZYHhen4ttYKnGYb7MGTIY5QEOEbZCUOKFUremhGpRlZvT4tdfk80g+
   jX0NIDNyzb84y7iUT3RbUtCGtm/TbqpF05BMURiEi/ACP/2Q6pX2R/iQz
   knfszSKPjP017rmN4RCz4LKd7p/9u/4oQmlm280ygs6A6uVNugCvxNXN+
   DqensZRmQ7QQoms6DPx3Lg84DKOQ7CIiBsBVZW5PUt5GShQPSNxZQWmAD
   g==;
X-CSE-ConnectionGUID: x1TCBbvUTfCuR8OFCHkBrQ==
X-CSE-MsgGUID: kHoh5bkVQoSmqsWOFxpyfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55140135"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55140135"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 05:21:51 -0700
X-CSE-ConnectionGUID: +qBA7GxQRBSQdMSL60kwIg==
X-CSE-MsgGUID: njD7ki8oQViqWSWR8dSM6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="182831385"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 05:21:49 -0700
Message-ID: <c2d2a3e9-e317-4049-9b6d-b6b3027ddd6d@intel.com>
Date: Tue, 22 Jul 2025 20:21:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Mathias Krause <minipli@grsecurity.net>, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
 <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
 <aH9yuVcUJQc4_-vP@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH9yuVcUJQc4_-vP@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/22/2025 7:15 PM, Daniel P. Berrangé wrote:
> On Tue, Jul 22, 2025 at 06:27:45PM +0800, Xiaoyao Li wrote:
>> On 7/22/2025 5:21 PM, Mathias Krause wrote:
>>> On 22.07.25 05:45, Xiaoyao Li wrote:
>>>> On 6/20/2025 3:42 AM, Mathias Krause wrote:
>>>>> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
>>>>> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
>>>>> exception (#UD) as they are just the wrong instruction for the CPU
>>>>> given. But instead of forwarding the exception to the guest, KVM tries
>>>>> to patch the guest instruction to match the host's actual hypercall
>>>>> instruction. That is doomed to fail as read-only code is rather the
>>>>> standard these days. But, instead of letting go the patching attempt and
>>>>> falling back to #UD injection, KVM injects the page fault instead.
>>>>>
>>>>> That's wrong on multiple levels. Not only isn't that a valid exception
>>>>> to be generated by these instructions, confusing attempts to handle
>>>>> them. It also destroys guest state by doing so, namely the value of CR2.
>>>>>
>>>>> Sean attempted to fix that in KVM[1] but the patch was never applied.
>>>>>
>>>>> Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
>>>>> conceptually be disabled. Paolo even called out to add this very
>>>>> functionality to disable the quirk in QEMU[3]. So lets just do it.
>>>>>
>>>>> A new property 'hypercall-patching=on|off' is added, for the very
>>>>> unlikely case that there are setups that really need the patching.
>>>>> However, these would be vulnerable to memory corruption attacks freely
>>>>> overwriting code as they please. So, my guess is, there are exactly 0
>>>>> systems out there requiring this quirk.
>>>>
>>>> The default behavior is patching the hypercall for many years.
>>>>
>>>> If you desire to change the default behavior, please at least keep it
>>>> unchanged for old machine version. i.e., introduce compat_property,
>>>> which sets KVMState->hypercall_patching_enabled to true.
>>>
>>> Well, the thing is, KVM's patching is done with the effective
>>> permissions of the guest which means, if the code in question isn't
>>> writable from the guest's point of view, KVM's attempt to modify it will
>>> fail. This failure isn't transparent for the guest as it sees a #PF
>>> instead of a #UD, and that's what I'm trying to fix by disabling the quirk.
>>>
>>> The hypercall patching was introduced in Linux commit 7aa81cc04781
>>> ("KVM: Refactor hypercall infrastructure (v3)") in v2.6.25. Until then
>>> it was based on a dedicated hypercall page that was handled by KVM to
>>> use the proper instruction of the KVM module in use (VMX or SVM).
>>>
>>> Patching code was fine back then, but the introduction of DEBUG_RO_DATA
>>> made the patching attempts fail and, ultimately, lead to Paolo handle
>>> this with commit c1118b3602c2 ("x86: kvm: use alternatives for VMCALL
>>> vs. VMMCALL if kernel text is read-only").
>>>
>>> However, his change still doesn't account for the cross-vendor live
>>> migration case (Intel<->AMD), which will still be broken, causing the
>>> before mentioned bogus #PF, which will just lead to misleading Oops
>>> reports, confusing the poor souls, trying to make sense of it.
>>>
>>> IMHO, there is no valid reason for still having the patching in place as
>>> the .text of non-ancient kernel's  will be write-protected, making
>>> patching attempts fail. And, as they fail with a #PF instead of #UD, the
>>> guest cannot even handle them appropriately, as there was no memory
>>> write attempt from its point of view. Therefore the default should be to
>>> disable it, IMO. This won't prevent guests making use of the wrong
>>> instruction from trapping, but, at least, now they'll get the correct
>>> exception vector and can handle it appropriately.
>>
>> But you don't accout for the case that guest kernel is built without
>> CONFIG_STRICT_KERNEL_RWX enabled, or without CONFIG_DEBUG_RO_DATA, or for
>> whatever reason the guest's text is not readonly, and the VM needs to be
>> migrated among different vendors (Intel <-> AMD).
>>
>> Before this patch, the above usecase works well. But with this patch, the
>> guest will gets #UD after migrated to different vendors.
>>
>> I heard from some small CSPs that they do want to the ability to live
>> migrate VMs among Intel and AMD host.
> 
> Usually CSPs don't have full control over what their customers
> are running as a guest. If their customers are running mainstream
> modern guest OS, CONFIG_STRICT_KERNEL_RWX is pretty likely to be
> set, so presumably migration between Intel & AMD will not work
> and this isn't making it worse ?

If breaking some usecase is not a concern, then I'm fine with no compat 
property.

> With regards,
> Daniel



Return-Path: <kvm+bounces-53113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4C3B0D7AF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4E2B1C23583
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939E52E267C;
	Tue, 22 Jul 2025 11:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eVOYeT78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046F1243378
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753182385; cv=none; b=gc4yOOI/a1gp0Am0oJF4lgNP1S/6wgMeylQ7ujXMrPOX+rnyKg31HVxaHSok/E2sX9Y5Rjzm1AYszaiJLuMR9BMIsniHljIYQ4c993OgPnFs6miAlQvmIrCbylP+Vy/+gs3j1sJ427h6dCYKs1PGtWgNKzAMzDY8P3OFVoZ3PxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753182385; c=relaxed/simple;
	bh=HQfLQ1tiPCYXo8hIhl+T+tSiwKBGU63pShOT4PDGA9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R05e03J+Z4FB4zqhMxEyAFL6CJlrf0++dZgxEPXjZKNUqxaAXddGa3YuxnPtNoVXKWizDpAgWgy9XvsmfChHm8CpfSAOvA2VRR9/7+OdmvpbnBAhJKTxb4lryuu2Sb+n9Asqxdmo3qx9RcMen4a0aaBrszZnkobyttIzFeTfcTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eVOYeT78; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753182384; x=1784718384;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HQfLQ1tiPCYXo8hIhl+T+tSiwKBGU63pShOT4PDGA9w=;
  b=eVOYeT78NjBjd8Q9K+b9eBqdJXGt77x+XUzVylhFN20C5EuCcRR0hXgW
   tFPM1NHgjo9voV1wcZV1JCZ9IUjlCkzau4ELhgkotx6KOURsBZA5oCkFO
   Z2SyHyjVRpuFkqT8SN1ASt0oSRn5sJp9SQf4nUTJ+eUB2xsBJxLjBeJJ6
   DPCp5KTyRZgLinRsZQkrHHQbqqmrDEfXdMm/nEhz0NDV2fUcLZdcDl0pW
   IcRHF/hrdGiExpXzJjGjz/n+XIxjP+SwPWkrNmPX91RDwRzejeOglyswQ
   SWXDNCayt3X6sVGJzRs2B0TJj24ij//uNBaFxPUhn1xVX0CIxdEl+IE7m
   g==;
X-CSE-ConnectionGUID: /enY90T3RXC1kfmvIIdFVw==
X-CSE-MsgGUID: 6+q3OuriSN23VfoxgOch2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="72880728"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="72880728"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 04:06:23 -0700
X-CSE-ConnectionGUID: aje7LPObQR63Ghn7LmUd1w==
X-CSE-MsgGUID: HFREgLGIRmiHtgVz+CWsWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="158423256"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 04:06:21 -0700
Message-ID: <0a700950-45b8-4f38-afe2-a1a261110d78@intel.com>
Date: Tue, 22 Jul 2025 19:06:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: Mathias Krause <minipli@grsecurity.net>, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
 <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
 <317D3308-0401-4A36-A6B0-D2575869748D@unpredictable.fr>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <317D3308-0401-4A36-A6B0-D2575869748D@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/22/2025 6:35 PM, Mohamed Mediouni wrote:
>> On 22. Jul 2025, at 12:27, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>>
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
>>>> The default behavior is patching the hypercall for many years.
>>>>
>>>> If you desire to change the default behavior, please at least keep it
>>>> unchanged for old machine version. i.e., introduce compat_property,
>>>> which sets KVMState->hypercall_patching_enabled to true.
>>> Well, the thing is, KVM's patching is done with the effective
>>> permissions of the guest which means, if the code in question isn't
>>> writable from the guest's point of view, KVM's attempt to modify it will
>>> fail. This failure isn't transparent for the guest as it sees a #PF
>>> instead of a #UD, and that's what I'm trying to fix by disabling the quirk.
>>> The hypercall patching was introduced in Linux commit 7aa81cc04781
>>> ("KVM: Refactor hypercall infrastructure (v3)") in v2.6.25. Until then
>>> it was based on a dedicated hypercall page that was handled by KVM to
>>> use the proper instruction of the KVM module in use (VMX or SVM).
>>> Patching code was fine back then, but the introduction of DEBUG_RO_DATA
>>> made the patching attempts fail and, ultimately, lead to Paolo handle
>>> this with commit c1118b3602c2 ("x86: kvm: use alternatives for VMCALL
>>> vs. VMMCALL if kernel text is read-only").
>>> However, his change still doesn't account for the cross-vendor live
>>> migration case (Intel<->AMD), which will still be broken, causing the
>>> before mentioned bogus #PF, which will just lead to misleading Oops
>>> reports, confusing the poor souls, trying to make sense of it.
>>> IMHO, there is no valid reason for still having the patching in place as
>>> the .text of non-ancient kernel's  will be write-protected, making
>>> patching attempts fail. And, as they fail with a #PF instead of #UD, the
>>> guest cannot even handle them appropriately, as there was no memory
>>> write attempt from its point of view. Therefore the default should be to
>>> disable it, IMO. This won't prevent guests making use of the wrong
>>> instruction from trapping, but, at least, now they'll get the correct
>>> exception vector and can handle it appropriately.
>> But you don't accout for the case that guest kernel is built without CONFIG_STRICT_KERNEL_RWX enabled, or without CONFIG_DEBUG_RO_DATA, or for whatever reason the guest's text is not readonly, and the VM needs to be migrated among different vendors (Intel <-> AMD).
>>
>> Before this patch, the above usecase works well. But with this patch, the guest will gets #UD after migrated to different vendors.
>>
>> I heard from some small CSPs that they do want to the ability to live migrate VMs among Intel and AMD host.
>>
> Is there a particular reason to not handle that #UD as a hypercall to support that scenario?

do you mean KVM handles the first hardware #UD due to the wrong opcode 
of hypercall by directly emulate the hypercall instead of going to 
emulator to patch the guest memory with modifying the guest memory?

If so, I agree with it. I thought the same solution and had no bandwidth 
and motivation to raise the idea to KVM community.

> Especially with some guest OS kernels having kernel patch protection with periodic scrubbing of r/o memory (ie Windows), doesn’t sound great to override anything in a way the guest OS kernel can notice…



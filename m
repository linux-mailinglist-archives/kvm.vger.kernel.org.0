Return-Path: <kvm+bounces-56660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D67DEB413A0
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 551231A885A1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 04:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E062D46B6;
	Wed,  3 Sep 2025 04:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yd18gZvb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE02D3EEA;
	Wed,  3 Sep 2025 04:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756874609; cv=none; b=Vq/MKXAPlPX1OoS4VU1Diba4ZviEZuHNt+e+lKhv7FLjCA7nPRgMCjoJS6xnRMXT8FHOpLbY625xTZXIfqfPF4weh3Cr0v9vuRoWQjnZozgDyQApa3gQ24g6kB2BwgE4jInX21nVczWzwzh9U5KXeaPKhyTloi9NKFTVvLS55p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756874609; c=relaxed/simple;
	bh=kKlPpwYXj/FU8DbfmlUchGL3G72piEGC7w1RbGsV98M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iCrhF9yay+H+40jp3GDaNbA35lt6frb17LeKqA0pY0KgulUG5KXjPyCPR9ZrC8OAAEz2RLRTWIUkAE0baOYJ1Ig7niszRr/KY/Fq0dkdZP8a0wd64y4wGfJI1dh+TtkHH3CmIe+xO+o0llowcdo2mE5cT71Zet4IP0CEW+YU4tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yd18gZvb; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756874607; x=1788410607;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kKlPpwYXj/FU8DbfmlUchGL3G72piEGC7w1RbGsV98M=;
  b=Yd18gZvbFGU2yGRBshCgcpi44r/rr8yjy5cVOZ6Xr2eBno5Sf+Y+WYA/
   iIFIv9MDqFrxIZWB8+kMzFwb+eSvhmcwfbA3m2WQvXWYJ2V1Vw6+PUg70
   oBkNLhNVtgHdFgrEa4pINmM6OuFqrxW8deO2j4sP6z4cHScY+Ye0yOBhh
   S+2MxIN4xybiRX3zhUTsofjh5+MlQr3Hra83I0rLDco1S0UFostcbe+qV
   ydUYXrNzWFqGhdcz6WQUWDlRm8PvczRpLk2zq0+EtaqWm9xYlwMs1+c+m
   LLpUb35nwgFlDjhX/R94407HnMsT+m7xuoNTq8Sd1+rdZASf3osr/h6Uf
   Q==;
X-CSE-ConnectionGUID: lhUS0+MCTaS7pBDRWf8mhA==
X-CSE-MsgGUID: 0NhzJO2BQdqbqR5qMB3Tew==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63010671"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63010671"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 21:43:26 -0700
X-CSE-ConnectionGUID: 9XCavLGVQbS/An0CGJq/2A==
X-CSE-MsgGUID: X6dvOUlqQMCKj1HFPmoZeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="195120614"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 21:43:24 -0700
Message-ID: <76499c2e-8ca9-4e5f-9a34-96eec19a5f6d@intel.com>
Date: Wed, 3 Sep 2025 12:43:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
To: Sean Christopherson <seanjc@google.com>
Cc: Xin Li <xin@zytor.com>, Binbin Wu <binbin.wu@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
References: <20250805202224.1475590-1-seanjc@google.com>
 <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
 <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
 <c4bc61da-c42c-453d-b484-f970b99cb616@zytor.com>
 <fbdcca61-e9c4-47fc-b629-7a46ad35cd24@intel.com>
 <aLcEMCMDRCEZnmdH@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aLcEMCMDRCEZnmdH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/2/2025 10:50 PM, Sean Christopherson wrote:
> On Mon, Sep 01, 2025, Xiaoyao Li wrote:
>> On 9/1/2025 3:04 PM, Xin Li wrote:
>>> On 8/31/2025 11:34 PM, Binbin Wu wrote:
>>>>> We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
>>>>>
>>>>
>>>> Indeed.
>>>
>>> Good catch!
>>>
>>>>
>>>> There is a virtualization hole of this feature for the accesses to the
>>>> MSRs not intercepted. IIUIC, there is no other control in VMX for this
>>>> feature. If the feature is supported in hardware, the guest will succeed
>>>> when it accesses to the MSRs not intercepted even when the feature is not
>>>> exposed to the guest, but the guest will get #UD when access to the MSRs
>>>> intercepted if KVM injects #UD.
>>>
>>> hpa mentioned this when I just started the work.  But I managed to forget
>>> it later... Sigh!
>>>
>>>>
>>>> But I guess this is the guest's fault by not following the CPUID,
>>>> KVM should
>>>> still follow the spec?
>>>
>>> I think we should still inject #UD when a MSR is intercepted by KVM.
> 
> Hmm, no, inconsistent behavior (from the guest's perspective) is likely worse
> than eating with the virtualization hole.  

Then could we document this design decision somewhere?

I believe people won't stop wondering why not inject #UD when no guest 
CPUID, when reading the code.

> Practically speaking, the only guest
> that's going to be surprised by the hole is a guest that's fuzzing opcodes, and
> a guest that's fuzzing opcodes at CPL0 isn't is going to create an inherently
> unstable environment no matter what.
> 
> Though that raises the question of whether or not KVM should emulate WRMSRNS and
> whatever the official name for the "RDMSR with immediate" instruction is (I can't
> find it in the SDM).  

do you mean because guest might be able to use immediate form of MSR 
access even if the CPUID doesn't advertise it, should KVM emulate it on 
platform doesn't support it, to make sure immediate form of MSR access 
is always supported?

> I'm leaning "no", because outside of forced emulation, KVM
> should only "need" to emulate the instructions if Unrestricted Guest is disabled,
> the instructions should only be supported on CPUs with unrestricted guest, there's
> no sane reason (other than testing) to run a guest without Unrestricted Guest,
> and using the instructions in Big RM would be quite bizarre.  On the other hand,
> adding emulation support should be quite easy...
> 
> Side topic, does RDMSRLIST have any VMX controls?
> 
>> For handle_wrmsr_imm(), it seems we need to check
>> guest_cpu_cap_has(X86_FEATURE_WRMSRNS) as well, since immediate form of MSR
>> write is only supported on WRMSRNS instruction.
>>
>> It leads to another topic, do we need to bother checking the opcode of the
>> instruction on EXIT_REASON_MSR_WRITE and inject #UD when it is WRMSRNS
>> instuction and !guest_cpu_cap_has(X86_FEATURE_WRMSRNS)?
>>
>> WRMSRNS has virtualization hole as well, but KVM at least can emulate the
>> architectural behavior when the write on MSRs are not pass through.



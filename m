Return-Path: <kvm+bounces-34204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E91929F8A26
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 03:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E51116BB0C
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83D0249EB;
	Fri, 20 Dec 2024 02:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SLTAj1up"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF9B4A08
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 02:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734662443; cv=none; b=JytnJRB7FRnzpdrqm7TaLfaD8iQh7EqvDYItVgEZcKh4mc+b+1DiI7GIl2UTOqYXakwk0Skkz0+pJ/70soK/KjiA5iRlSh8hJpbDQ5cOcyrzfUFbvOqS6tU5+WX6IOKOcfBvVgwNY/yKU09hmyTS/Ozyiz11MwdFgQBKRJ02DPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734662443; c=relaxed/simple;
	bh=/pqf9h2qJXBBN2f+fR9Wh3ziCzf/Pma6YvbUywRpP9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CaP6xqtwzMvstq8dV0lm6dY80D3+olGpiSJTUfEuBjI4C2r09LukF9vdufE3ihZZDAOeJ8jXrN048MkL1zDjzvG7FPVGDh2bG+VQz40sE0qs/ah+WgsoKH4V8UiyDX+5vbz27FJ/EU3RSZaOTEhANmnH5BoDqcaD+8VS18S8yRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SLTAj1up; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734662441; x=1766198441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/pqf9h2qJXBBN2f+fR9Wh3ziCzf/Pma6YvbUywRpP9M=;
  b=SLTAj1upkXPSllf2BV6ZkQmyFod3ppXHxbvMrhs1TTW9qL0wAsOfAJUe
   u8FbKH7VhxJgFddQvj/XIDmfzOSs6V1iMPtYlVqTUZvJfS9l84lQBA++v
   ciwt3hrDotToNpw6e/KYaJnRRttfZmbGxMtcnC6TXWtB4QaQ+clMOvaJy
   ZIKSD4vKhGZv0dhSPZhmWh/1hDw9h8jmA8PoTbPTAdiuwow9xHmQOarF5
   64uoWMZNFqKJdOyZl0mA8I5SeRgEntVs9Wds0B1QYUDCkLtOKscUWH8RH
   M+aY//FvP4s4Yop5bMk920AYH27qMDximTdCNaFg/gAEAICVGaTP9vyfo
   w==;
X-CSE-ConnectionGUID: 7f8UZa7zSmKJRWY9CFkw8w==
X-CSE-MsgGUID: XZvPNcRRSo2e73JeL1LdEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="35098342"
X-IronPort-AV: E=Sophos;i="6.12,249,1728975600"; 
   d="scan'208";a="35098342"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 18:40:41 -0800
X-CSE-ConnectionGUID: 8L2xDTDdSsyhhJAYJya+Xg==
X-CSE-MsgGUID: zxpLWte8Q6uoBYmWUJjs6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="121660659"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 18:40:38 -0800
Message-ID: <88c87ff8-bae0-4522-bb65-109b959a7e52@intel.com>
Date: Fri, 20 Dec 2024 10:40:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Yan Y Zhao <yan.y.zhao@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
 <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
 <Z2DZpJz5K9W92NAE@google.com>
 <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
 <Z2INi480K96q2m5S@google.com>
 <f58c24757f8fd810e5d167c8b6da41870dace6b1.camel@intel.com>
 <Z2OEQdxgLX0GM70n@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z2OEQdxgLX0GM70n@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/2024 10:33 AM, Sean Christopherson wrote:
>>> For all other CPUID bits, what the TDX Module thinks and/or presents to the guest
>>> is completely irrelevant, at least as far as KVM cares, and to some extent as far
>>> as QEMU cares.  This includes the TDX Module's FEATURE_PARAVIRT_CTRL, which frankly
>>> is asinine and should be ignored.  IMO, the TDX Module spec is entirely off the
>>> mark in its assessment of paravirtualization.  Injecting a #VE instead of a #GP
>>> isn't "paravirtualization".
>>>   
>>> Take TSC_DEADLINE as an example.  "Disabling" the feature from the guest's side
>>> simply means that WRMSR #GPs instead of #VEs.*Nothing* has changed from KVM's
>>> perspective.  If the guest makes a TDVMCALL to write IA32_TSC_DEADLINE, KVM has
>>> no idea if the guest has opted in/out of #VE vs #GP.  And IMO, a sane guest will
>>> never take a #VE or #GP if it wants to use TSC_DEADLINE; the kernel should instead
>>> make a direct TDVMCALL and save itself a pointless exception.
>>>
>>>    Enabling Guest TDs are not allowed to access the IA32_TSC_DEADLINE MSR directly.
>>>    Virtualization of IA32_TSC_DEADLINE depends on the virtual value of
>>>    CPUID(1).ECX[24] bit (TSC Deadline). The host VMM may configure (as an input to
>>>    TDH.MNG.INIT) virtual CPUID(1).ECX[24] to be a constant 0 or allow it to be 1
>>>    if the CPU’s native value is 1.
>>>
>>>    If the TDX module supports #VE reduction, as enumerated by TDX_FEATURES0.VE_REDUCTION
>>>    (bit 30), and the guest TD has set TD_CTLS.REDUCE_VE to 1, it may control the
>>>    value of virtual CPUID(1).ECX[24] by writing TDCS.FEATURE_PARAVIRT_CTRL.TSC_DEADLINE.
>>>
>>>    • If the virtual value of CPUID(1).ECX[24] is 0, IA32_TSC_DEADLINE is virtualized
>>>      as non-existent. WRMSR or RDMSR attempts result in a #GP(0).
>>>
>>>    • If the virtual value of CPUID(1).ECX[24] is 1, WRMSR or RDMSR attempts result
>>>      in a #VE(CONFIG_PARAVIRT). This enables the TD’s #VE handler.
>>>
>>> Ditto for TME, MKTME.
>>>
>>> FEATURE_PARAVIRT_CTRL.MCA is even weirder, but I still don't see any reason for
>>> KVM or QEMU to care if it's fixed or configurable.  There's some crazy logic for
>>> whether or not CR4.MCE can be cleared, but the host can't see guest CR4, and so
>>> once again, the TDX Module's view of MCA is irrelevant when it comes to handling
>>> TDVMCALL for the machine check MSRs.
>>>
>>> So I think this again purely comes to back to KVM correctness and safety.  More
>>> specifically, the TDX Module needs to report features that are unconditionally
>>> enabled or disabled and can't be emulated by KVM.  For everything else, I don't
>>> see any reason to care what the TDX module does.
>>>
>>> I'm pretty sure that gives us a way forward.  If there only a handful of features
>>> that are unconditionally exposed to the guest, then KVM forces those features in
>>> cpu_caps[*].
>> I see. Hmm. We could use this new interface to double check the fixed bits. It
>> seems like a relatively cheap sanity check.
>>
>> There already is an interface to get CPUID bits (fixed and dynamic). But it only
>> works after a TD is configured. So if we want to do extra verification or
>> adjustments, we could use it before entering the TD. Basically, if we delay this
>> logic we don't need to wait for the fixed bit interface.
> Oh, yeah, that'd work.  Grab the guest CPUID and then verify that bits KVM needs
> to be 0 (or 1) are set according, and WARN+kill if there's a mismatch.
> 
> Honestly, I'd probably prefer that over using the fixed bit interface, as my gut
> says it's less likely for the TDX Module to misreport what CPUID it has created
> for the guest, than it is for the TDX module to generate a "fixed bits" list that
> doesn't match the code.  E.g. KVM has (had?) more than a few CPUID features that
> KVM emulates without actually reporting support to userspace.

The original motivation of the proposed fxied0 and fixed1 data is to 
complement the CPUID configurability report, which is important for 
userspace. E.g., Currently, what QEMU is doing is hardcoding the fixed0 
and fixed1 information of a specific TDX release to adjust the 
KVM_GET_SUPPORTED_CPUID result and gets a final "supported" CPUID set 
for TDX. Hardcoding is not a good idea and it's better that KVM can get 
the data from TDX module, then pass to userspace (of course KVM can 
tweak the data based on its own requirement). So, do you think it's 
useful to have TDX module report the fixed0/fixed1 data for this purpose?


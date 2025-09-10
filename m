Return-Path: <kvm+bounces-57202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8809AB51836
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 15:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ED2D542F62
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8EF1FDA82;
	Wed, 10 Sep 2025 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L/Bdfip7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF231D382;
	Wed, 10 Sep 2025 13:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757511972; cv=none; b=aObO7u6ybh+GvPepPMAo2cTJDBJmFE6l0DRN8ou0nKtbPxbl8UgU8kjZKJVMz0jVEEahjkNVB7Rr+L3gy1eCmYfSOl9JB4SuhNkmig//tHReliaCbhjrQkw83a+uyV1m3LvGAkOSn4fUHzNJwTnbgteXb7PS/phZQEWgZLXkuL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757511972; c=relaxed/simple;
	bh=z11WiJxFvJ2XbIvM8eaZyqRCuCpRYVlpJGYWLTsQxbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Djg6d3DMHsB8PeaibXGkHhh4YsrRs7p1FaC1AecLv6u2HJqy8GAmb9FfEVzSPTJNnqa2b7c+REL6WlXBWdWkEtEwq+z2DGTUJmZuB7dtkc67LcascgbVRPh0mfG54c9Wsb49R6UW7ARWEaS33YR9N31TQEBXVkfi6FcsS9zLctU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L/Bdfip7; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757511971; x=1789047971;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z11WiJxFvJ2XbIvM8eaZyqRCuCpRYVlpJGYWLTsQxbs=;
  b=L/Bdfip7FQS4VJ9UZ/Bd7hE42BKTNNyNmPJMxZsMB0k2H8EGpXq4coaN
   +bRbActK84JYz9TOs9RVlCsmOVdSQbvi0QjdiM7d3fB7mgcjtDEh3BI5L
   VsV6zuVbPbHq563vCKKZ8y4RA8PbpNH11cTQL6XD7+kztzcS7Ar6631hh
   Hu8Xpp+qpERaHXPSfLCxx/YnWTADYaAveXU5zLoQtl3b3tT3sDNYUn9Hz
   QTmJb01CSj8aN7SIDrW7dNZtX07A45ih7KJOUahugC52a9iO/gviZYAGG
   hnpYHE7hDIC10pCHjUtHLYWXBHnL8/hT4CvW722WDN3u1ePCU+OJxDfir
   Q==;
X-CSE-ConnectionGUID: tJKMwhlOQwOfImdke81pxg==
X-CSE-MsgGUID: dZZBWBXBR9mBLy/fYaBuXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59759702"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59759702"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 06:46:10 -0700
X-CSE-ConnectionGUID: rwNJt1VpTB+PuFa4w9xoUA==
X-CSE-MsgGUID: 3LYFixSSTdSwYpPB536a0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173777182"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 06:46:04 -0700
Message-ID: <5077c390-1211-42fc-b753-2a23187cf8ca@intel.com>
Date: Wed, 10 Sep 2025 21:46:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-7-chao.gao@intel.com>
 <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com> <aMFedyAqac+S38P2@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aMFedyAqac+S38P2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/2025 7:18 PM, Chao Gao wrote:
> On Wed, Sep 10, 2025 at 05:37:50PM +0800, Xiaoyao Li wrote:
>> On 9/9/2025 5:39 PM, Chao Gao wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Load the guest's FPU state if userspace is accessing MSRs whose values
>>> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
>>> to facilitate access to such kind of MSRs.
>>>
>>> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
>>> the guest MSRs are swapped with host's before vCPU exits to userspace and
>>> after it reenters kernel before next VM-entry.
>>>
>>> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
>>> explicitly check @vcpu is non-null before attempting to load guest state.
>>> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
>>> loading guest FPU state (which doesn't exist).
>>>
>>> Note that guest_cpuid_has() is not queried as host userspace is allowed to
>>> access MSRs that have not been exposed to the guest, e.g. it might do
>>> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> ...
> 
>>> +	bool fpu_loaded = false;
>>>    	int i;
>>> -	for (i = 0; i < msrs->nmsrs; ++i)
>>> +	for (i = 0; i < msrs->nmsrs; ++i) {
>>> +		/*
>>> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
>>> +		 * temporarily load the guest's FPU state so that the guest's
>>> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
>>> +		 * get/set the MSR via RDMSR/WRMSR.
>>> +		 */
>>> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
>>
>> why not check vcpu->arch.guest_supported_xss?
> 
> Looks like Sean anticipated someone would ask this question.

here it determines whether to call kvm_load_guest_fpu().

- based on kvm_caps.supported_xss, it will always load guest fpu.
- based on vcpu->arch.guest_supported_xss, it depends on whether 
userspace calls KVM_SET_CPUID2 and whether it enables any XSS feature.

So the difference is when no XSS feature is enabled for the VM.

In this case, if checking vcpu->arch.guest_supported_xss, it will skip
kvm_load_guest_fpu(). And it will result in GET_MSR gets usrerspace's 
value and SET_MSR changes userspace's value, when MSR access is 
eventually allowed in later do_msr() callback. Is my understanding 
correctly?



Return-Path: <kvm+bounces-57696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2304DB5900E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FA61B20E1E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E47B28640C;
	Tue, 16 Sep 2025 08:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZqFn9JT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13359272E56;
	Tue, 16 Sep 2025 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758010230; cv=none; b=hZoaPUimuSBbV2NkS3wvnWHkiQIL9+XMlSn9BhM+w+q3ZJi22LFpilU6qX62YnJT8JtZJIlOvOsznHPmgQsKPgmDhZTK3mDo1gwH4QDJpusGmLD7EdBLfMyMKTmRmPFCIZqVWgdnWtsp8cwzJ/UJFS8IssEkadZBQn9E+QJEyE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758010230; c=relaxed/simple;
	bh=2Nv+n5LL6mu6ryi5KjrNmaa+IvdLmvVgC46XijpjkRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bw3uvmMHKGZgq/KWG/lv7NJJjWCuVQ0cBAyteK5aaj/GcHoLNd4/sFS+7L6tSy7/RTu6X71GHsoS6z875/6QWPyReJ8bwjL6a3LEOjXolUSmKrtirUOTFJdusXjzY4ii1rNcj4Y/BG2ydFx4OJWgVBS2RoLigKsAdj4Q0zJ7jNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZqFn9JT; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758010229; x=1789546229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2Nv+n5LL6mu6ryi5KjrNmaa+IvdLmvVgC46XijpjkRA=;
  b=EZqFn9JTXoq6HjVp1PMPSNklesjyGevskNLB2fLPThIGGfZ1NsuatikL
   i5Gi3dBqqiLH4BpupxeiBEFwqv+clOp7zTraKXal6bdURVoyCLPAwvIe2
   7EQjzKLedTici1h5gQoOa/633JAz80ck89ly27PMhU5Yn2zob6S+XAJUP
   PlbakxYnERmScBSvltPILpG7Scx4bDFH6syfPQ4+uNtTIgdt60HXBYuQg
   tS3TjMJJs2VJYB+laMGKStK9WDf0VeHO5rnLIvqqGJaISYXtLPC4zb3yM
   5vbSsFFuEvxgyxAgb+4qTjWiH/BQ9e7s+1nvfUnKb8EKVn6q2dwmWRL/j
   g==;
X-CSE-ConnectionGUID: T+Yz+RHXTGGApqQALP5YNg==
X-CSE-MsgGUID: heGPYWqGSXqYLroz+xCw6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60354470"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="60354470"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:10:28 -0700
X-CSE-ConnectionGUID: uSMxwofqSSiLvP8QlO82Gg==
X-CSE-MsgGUID: cVgCIi54S3W3S3sjpX2baw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174686701"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:10:25 -0700
Message-ID: <6a638dc4-bd99-4a93-8498-2ba1c0c61b30@intel.com>
Date: Tue, 16 Sep 2025 16:10:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/41] KVM: VMX: Emulate read and write to CET MSRs
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-15-seanjc@google.com>
 <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com> <aMkWT/8cBVwi2mfN@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aMkWT/8cBVwi2mfN@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/2025 3:48 PM, Chao Gao wrote:
> On Tue, Sep 16, 2025 at 03:07:06PM +0800, Xiaoyao Li wrote:
>> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
>>> From: Yang Weijiang <weijiang.yang@intel.com>
>>>
>>> Add emulation interface for CET MSR access. The emulation code is split
>>> into common part and vendor specific part. The former does common checks
>>> for MSRs, e.g., accessibility, data validity etc., then passes operation
>>> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
>>>
>>> SSP can only be read via RDSSP. Writing even requires destructive and
>>> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
>>> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
>>> for the GUEST_SSP field of the VMCS.
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> Tested-by: Mathias Krause <minipli@grsecurity.net>
>>> Tested-by: John Allen <john.allen@amd.com>
>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>>> [sean: drop call to kvm_set_xstate_msr() for S_CET, consolidate code]
>>
>> Is the change/update of "drop call to kvm_set_xstate_msr() for S_CET" true
>> for this patch?
> 
> v14 has that call, but it is incorrect. So Sean dropped it. See v14:
> 
> https://lore.kernel.org/kvm/20250909093953.202028-12-chao.gao@intel.com/

Sorry, my fault. I missed it somehow, when bouncing between the 3 MSR 
handlers.

>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>



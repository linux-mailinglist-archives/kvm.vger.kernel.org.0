Return-Path: <kvm+bounces-14414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AC68A297B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01D141F22809
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B6B50291;
	Fri, 12 Apr 2024 08:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P/+jnRZL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE14DA1B;
	Fri, 12 Apr 2024 08:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911245; cv=none; b=R4B/3W/RfJJHp2+G7yccebtkKcaPIFBtpweUE5PnAlbeN2CoYNAso1KEqVkfo42Z1edMTxqpGezGPL2zMTFo6qCq6YndKgiJ5nhbFlXFbPz1jjkc2GFa69QHdotv59FXv0s7NjAyq5t/r/5Q8Rmdwfh9A8C3uaj7dRXVuj7vN4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911245; c=relaxed/simple;
	bh=oE/Av3AYLF8NfpU6hLN/Pb+gVR2nlGO/R5tgQc/JF20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSvNNcqZoLgRmFWxQCvH8jQfnQPozaRjSKMqnEpQoKe34ALti+LsVQ082XyvN+/0YwTzAOY1n1/7pow+VmuYg0AqxuoOGE0zZqCwIQhbNJDJ5HWDmdgyrm6LWFda6aDQNgPsZHt9uUOSlTyiXJefl7nsRXdiLwvKZgSwDkA4aT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P/+jnRZL; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712911243; x=1744447243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oE/Av3AYLF8NfpU6hLN/Pb+gVR2nlGO/R5tgQc/JF20=;
  b=P/+jnRZLRS5TwQMvbwrcXGXa8szPBqsiLhSbp4XmLLYoY7Blb8/a7BSC
   FXDaC64I7oNbmCuFCcNuciIgmnt8OC+tV7iF4hhVwAAFfkRDqYYIh9BuI
   mofO5zFmQiVM1sKJd2B5ZrP+dAxeNiFanmYQZ7F8XCYIunBbKWDTHd5An
   wPwNEhFoC9qgn7x5ESuPkODCqLsC5lHT+0QBuhivDJAQkWElQlv+F4vsc
   G8uDw52WehKV38M+qCcl+udB6L565PcC+z3Z/anx6Jvt4YvlK5X3XADxR
   85n+tA9F/cVPylpxXb1VKadGiTk6W04iBuARSfZr409G7GzGLRDvDURG3
   g==;
X-CSE-ConnectionGUID: E85NwQmjRs6Y4OiNW8YHcA==
X-CSE-MsgGUID: P7DfqAbpSiKsOlSBjf5kiw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="18915614"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="18915614"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:40:42 -0700
X-CSE-ConnectionGUID: A824Ptf/QmWoTxqKvzSyFw==
X-CSE-MsgGUID: vvmEOulGSDKZ2SMXLzeA0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25715667"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:40:39 -0700
Message-ID: <19a0f47e-6840-42f8-b200-570a9aa7455d@intel.com>
Date: Fri, 12 Apr 2024 16:40:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>,
 "srutherford@google.com" <srutherford@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Wang, Wei W" <wei.w.wang@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <ZhRxWxRLbnrqwQYw@google.com>
 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com>
 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com>
 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com>
 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
 <ZhgBGkPTwpIsE6P6@google.com>
 <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/12/2024 2:52 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-04-11 at 08:26 -0700, Sean Christopherson wrote:
>> On Thu, Apr 11, 2024, Xiaoyao Li wrote:
>>> flexible (configurable) bits is known to VMM (KVM and userspace) because TDX
>>> module has interface to report them. So we can treat a bit as fixed if it is
>>> not reported in the flexible group. (of course the dynamic bits are special
>>> and excluded.)
>>
>> Does that interface reported the fixed _values_?
> 
> So backing up a bit to the problem statement. I think there are two related
> requirements. (please correct)
> 
> The first is a simple functional one. KVM is involved in virtualizing TD
> behavior. If enables various logic based on its knowledge of a vCPU’s CPUID
> state. Some of this logic is necessary for TDX. It can end up engaging logic for
> at least:
> X86_FEATURE_X2APIC
> X86_FEATURE_XSAVE
> X86_FEATURE_SMEP
> X86_FEATURE_SMAP
> X86_FEATURE_FSGBASE
> X86_FEATURE_PKU
> X86_FEATURE_LA57
> TDX pieces need for some of these bits to get set in the vCPU or KVM’s part of
> the necessary virtualization wont function.
> 
> The second issue is that userspace can’t know what CPUID values are configured
> in the TD. In the existing API for normal guests, it knows because it tells the
> guest what CPUID values to have. But for the TDX module that model is
> complicated to fit into in its API where you tell it some things and it gives
> you the resulting leaves. How to handle KVM_SET_CPUID kind of follows from this
> issue.
> 
> One option is to demand the TDX module change to be able to efficiently wedge
> into KVM’s exiting “tell” model. This looks like the metadata API to query the
> fixed bits. Then userspace can know what bits it has to set, and call
> KVM_SET_CPUID with them. I think it is still kind of awkward. "Tell me what you
> want to hear?", "Ok here it is".
> 
> Another option would be to add TDX specific KVM APIs that work for the TDX
> module's “ask” model, and meet the enumerated two goals. It could look something
> like:
> 1. KVM_TDX_GET_CONFIG_CPUID provides a list of directly configurable bits by
> KVM. This is based on static data on what KVM supports, with sanity check of
> TD_SYSINFO.CPUID_CONFIG[]. Bits that KVM doesn’t know about, but are returned as
> configurable by TD_SYSINFO.CPUID_CONFIG[] are not exposed as configurable. (they
> will be set to 1 by KVM, per the recommendation)

This is not how KVM works. KVM will never enable unknown features 
blindly. If the feature is unknown to KVM, it cannot be enable for 
guest. That's why every new feature needs enabling patch in KVM, even 
the simplest case that needs one patch to enumerate the CPUID of new 
instruction in KVM_GET_SUPPORTED_CPUID.

> 2. KVM_TDX_INIT_VM is passed userspaces choice of configurable bits, along with
> XFAM and ATTRIBUTES as dedicated fields. They go into TDH.MNG.INIT.
> 3. KVM_TDX_INIT_VCPU_CPUID takes a list of CPUID leafs. It pulls the CPUID bits
> actually configured in the TD for these leafs. They go into the struct kvm_vcpu,
> and are also passed up to userspace so everyone knows what actually got
> configured.
> 
> KVM_SET_CPUID is not used for TDX.
> 
> Then we get TDX module folks to commit to never breaking KVM/userspace that
> follows this logic. One thing still missing is how to handle unknown future
> leafs with fixed bits. If a future leaf is defined and gets fixed 1, QEMU
> wouldn't know to query it. 

We can make KVM_TDX_INIT_VCPU_CPUID provide a large enough CPUID leafs 
and KVM reports every leafs to userpsace. Instead of something that 
userspace cares leafs X,Y,Z and KVM only reports back leafs X,Y,Z via 
KVM_TDX_INIT_VCPU_CPUID.

> We might need to ask for some TDX module guarantees
> around that. It might already be the expectation though, based on the
> description of how to handle unknown configurable bits.
> 
> Xiaoyao, would it work for userspace?

As I see, userspace has to be enlightened to run TDX. So whatever 
interface KVM defines for TDX, userspace has to adjust itself to work 
with it.

So my personal answer is yes. But only personal.


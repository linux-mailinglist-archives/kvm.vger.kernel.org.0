Return-Path: <kvm+bounces-50066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B59AE1B2F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A32A93BD31E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D84028B4F0;
	Fri, 20 Jun 2025 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGU28bMd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4728368A;
	Fri, 20 Jun 2025 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750423727; cv=none; b=YgeObSjTQ5CKokacYB0bdRMjzrPZF+VaX/qgLk29CDJJCxnYSmgGNSj1iQgyr2SjYLGYOHup5C6avNN7ZrOv9Mg8RptKq682EH1qs2dt5FR4p20wFZK0k/S9B3IS7ByquUKvy8MfdUMlbEq0NMZoNEm3iV47x1i4AHw1scB0Nr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750423727; c=relaxed/simple;
	bh=yVaxpPeFFP3rnQCIorHxvbBAoiiYM3mlDcF3kA5KISI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A81cWTxvH1YPDFdwyTa7ASDiXAq6BPWZq4bolQp/EDMEUmnLWdLYhy2+AWIb0AGgR+xlKQ3g+Jv+FS2/cGJW56nXu8vwtywlm11LvRUTHP6xEP6TfaLRkcoqZRUwU1lEajufF6Ow+8EWP2GUtIpnNyo8jxYmh0ChqDZlFOEp2Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGU28bMd; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750423726; x=1781959726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yVaxpPeFFP3rnQCIorHxvbBAoiiYM3mlDcF3kA5KISI=;
  b=XGU28bMdhwZA2zwJF+8tgZ7kDn2eei16QzafYMPBxpaERO/XNWa3KNOa
   mOX2UiMxwTlDKi1qD0XRUIaSz1pew9E4YRGcX2sNWupCoOHdQwhPHAnxw
   JWaZt9QJ69B8VN48QjcRjOuYAcvbncCSK4xfkMaonrtOsks9NGhXHsocC
   R0SDfjkaouHzQdxibocvhxjmU+UMm1I50Cf7Gu201Hmiw4r6TUuoN0KGe
   XX6/N5cMvTCgKyvfajmKMWjYor5xNuxlKfPtT8CNNLNoafvCEbOFswn1I
   hFvlDzf6ja/HdFi1omOBZMY5RgNTiWaLF7tK8cE2RTmacTfJjZI8Av13T
   w==;
X-CSE-ConnectionGUID: e7rT/RTjTTuVo4xi/uNUfA==
X-CSE-MsgGUID: OkciWRStTyWQ0V81T3LQTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="75216094"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="75216094"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 05:48:46 -0700
X-CSE-ConnectionGUID: GqSOpAUeQdGVI6bfIkq+Dg==
X-CSE-MsgGUID: IXp2ib+DRKaj7ZWXPIsPmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="155195275"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 05:48:42 -0700
Message-ID: <b003b2c8-66fc-4600-9873-aa5201415b94@intel.com>
Date: Fri, 20 Jun 2025 20:48:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
 kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, "Huang, Kai"
 <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
 reinette.chatre@intel.com, "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>, Yan Zhao
 <yan.y.zhao@intel.com>, mikko.ylinen@linux.intel.com,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Yao, Jiewen" <jiewen.yao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
 <CABgObfaN=tcx=_38HnnPfE0_a+jRdk_UPdZT6rVgCTSNLEuLUw@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfaN=tcx=_38HnnPfE0_a+jRdk_UPdZT6rVgCTSNLEuLUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/2025 8:03 PM, Paolo Bonzini wrote:
> Il ven 20 giu 2025, 03:30 Xiaoyao Li <xiaoyao.li@intel.com> ha scritto:
>>
>> On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
>>> This is a refresh of Binbin's patches with a change to the userspace
>>> API.  I am consolidating everything into a single KVM_EXIT_TDX and
>>> adding to the contract that userspace is free to ignore it *except*
>>> for having to reenter the guest with KVM_RUN.
>>>
>>> If in the future this does not work, it should be possible to introduce
>>> an opt-in interface.  Hopefully that will not be necessary.
>>
>> For <GetTdVmCallInfo> exit, I think KVM still needs to report which
>> TDVMCALL leaf will exit to userspace, to differentiate between different
>> KVMs.
> 
> 
> The interface I chose is that KVM always exits, but it initializes the
> output values such that userspace can leave them untouched for unknown
> TDVMCALLs or unknown leaves. So there is no need for this.
> 
> Querying kernel support of other services can be added later, but
> unless the GHCI adds more input or output fields to TdVmCallInfo there
> is no need to limit the userspace exit to leaf 1.

I meant the case where KVM is going to support another optional TDVMCALL 
leaf in the future, e.g., SetEventNotifyInterrupt. At that time, 
userspace needs to differentiate between old KVM which only supports 
<GetQuote> and new KVM which supports both <GetQuote> and 
<SetEventNotifyInterrupt>.

- If it's old KVM, userspace should only set <GetQuote> bit in 
GetTdVmCallInfo exit. If userspace sets <SetEventNotifyInterrupt> in 
GetTdVmCallInfo exit and enumerate to TD guest, but it's wrong info 
since the KVM doesn't support <SetEventNotifyInterrupt> and userspace 
won't get any chance to handle the guest call of <SetEventNotifyInterrupt>

- But if it's new KVM, userspace can <SetEventNotifyInterrupt> bit in 
GetTdVmCallInfo exit and enumerate to TD guest.

Anyway, its the future problem, there should be various options to 
handle it in the future. This series works for the current need.

> 
> Paolo
> 
>>
>> But it's not a must for current <GetQuote> since it exits to userspace
>> from day 0. So that we can leave the report interface until KVM needs to
>> support user exit of another TDVMCALL leaf.
>>
>>> Paolo
>>>
>>> Binbin Wu (3):
>>>     KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
>>>     KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
>>>     KVM: TDX: Exit to userspace for GetTdVmCallInfo
>>>
>>>    Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
>>>    arch/x86/include/asm/shared/tdx.h |  1 +
>>>    arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
>>>    include/uapi/linux/kvm.h          | 22 +++++++++
>>>    4 files changed, 154 insertions(+), 8 deletions(-)
>>>
>>
> 



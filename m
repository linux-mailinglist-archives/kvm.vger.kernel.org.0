Return-Path: <kvm+bounces-56396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB935B3D65C
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 03:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FD2A7AB275
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 01:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4565201278;
	Mon,  1 Sep 2025 01:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g6pmLv0i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE9B74C14;
	Mon,  1 Sep 2025 01:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756691175; cv=none; b=QFp+FcL+Ey9ZBZQ4qqrqpS21dfQkpgkRwir5GyY7VcJuv4SKtv6MZgfuH9uB1Xutw5Ig/Y8N7gsb1VRzjl3zV0MuhrcyT4TOfK6Q/aOugfit45iRQ4/EcKwFtUZdpBd33GeUtptlG6bt4FzzwREYcEYzeH8yyEkn0PSEcEhk8pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756691175; c=relaxed/simple;
	bh=RwPnLfR/CR62rui7rWGx8rgnlwqvfNsbiTVOztkvBWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Et34Nuq/gUxnGoaQ0vLKVPFU1JjrmqCT3fRhVLGTIEJjKbRJDyZ02Yar5cw29Ley5WWKKyb+oZW37t+wr8ikeq7SS1IuWdK6iFmcSxVDkD4mWxx2unLbJpPVfB9DgRS+BFQ5AJ/vhdaPUiMvNtjE3jzO4eFEj9vJ56loClsxJEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g6pmLv0i; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756691174; x=1788227174;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RwPnLfR/CR62rui7rWGx8rgnlwqvfNsbiTVOztkvBWs=;
  b=g6pmLv0iEtGzd2Ez37C3ppNNmQD5xMi8mbVHeSSLTpLR57/+EM527iRq
   8j2VTN/+g5pDrcOWc3JITKZFDAGdTDDzaL0htSfMDPA6N9UIbBRIojqka
   agQyNZq09BAGOzjkPzhqsvK7/MICTI9viPmFE6LW0bTV78uSA5hgrIl+Z
   KocwfUeJ6FYz2pt1rHY5ftKx8KPdN0mdqvJXmqDtCLt2i1S2xOd2fn33h
   3Du2YAJsd88gXu3kCYYpERThr9+mPXzpY4nlNCHeJOBfFaY07CcaGub+i
   ZtkfpsFWVsCzskW4cqJEXmPUWQGdat8syWb7e4oTiuplD/CnUYnIIWJ9H
   g==;
X-CSE-ConnectionGUID: 9QtiTutdThCTixbA3Zci3A==
X-CSE-MsgGUID: ndV5aQjeRYG1KCmma4bpXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="69480589"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="69480589"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 18:46:13 -0700
X-CSE-ConnectionGUID: dgj/J4rNQRmTzgVTSjtY+w==
X-CSE-MsgGUID: 7DuHPgXWQGOu2htpcfFHZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171228349"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 18:46:10 -0700
Message-ID: <6c7ee971-d2b1-461f-900e-d343678ec989@linux.intel.com>
Date: Mon, 1 Sep 2025 09:46:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 15/18] KVM: TDX: Combine KVM_BUG_ON +
 pr_tdx_error() into TDX_BUG_ON()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-16-seanjc@google.com>
 <fcf19563-df65-4936-bd08-46f1a95359af@linux.intel.com>
 <aLG24VoWbrB5e-K4@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aLG24VoWbrB5e-K4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/29/2025 10:19 PM, Sean Christopherson wrote:
> On Fri, Aug 29, 2025, Binbin Wu wrote:
>> On 8/29/2025 8:06 AM, Sean Christopherson wrote:
>>> Add TDX_BUG_ON() macros (with varying numbers of arguments) to deduplicate
>>> the myriad flows that do KVM_BUG_ON()/WARN_ON_ONCE() followed by a call to
>>> pr_tdx_error().  In addition to reducing boilerplate copy+paste code, this
>>> also helps ensure that KVM provides consistent handling of SEAMCALL errors.
>>>
>>> Opportunistically convert a handful of bare WARN_ON_ONCE() paths to the
>>> equivalent of KVM_BUG_ON(), i.e. have them terminate the VM.  If a SEAMCALL
>>> error is fatal enough to WARN on, it's fatal enough to terminate the TD.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++------------------------
>>>    1 file changed, 47 insertions(+), 67 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index aa6d88629dae..df9b4496cd01 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -24,20 +24,32 @@
>>>    #undef pr_fmt
>>>    #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>> -#define pr_tdx_error(__fn, __err)	\
>>> -	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
>>> +#define __TDX_BUG_ON(__err, __f, __kvm, __fmt, __args...)			\
>>> +({										\
>>> +	struct kvm *_kvm = (__kvm);						\
>>> +	bool __ret = !!(__err);							\
>>> +										\
>>> +	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
>>> +		if (_kvm)							\
>>> +			kvm_vm_bugged(_kvm);					\
>>> +		pr_err_ratelimited("SEAMCALL " __f " failed: 0x%llx" __fmt "\n",\
>>> +				   __err,  __args);				\
>>> +	}									\
>>> +	unlikely(__ret);							\
>>> +})
>>> -#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
>>> -	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
>>> +#define TDX_BUG_ON(__err, __fn, __kvm)				\
>>> +	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
>>> -#define pr_tdx_error_1(__fn, __err, __rcx)		\
>>> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
>>> +#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
>>> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
>>> -#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
>>> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
>>> +#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
>>> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
>>> +
>>> +#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
>>> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
>>> -#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
>>> -	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
>> I thought you would use the format Rick proposed in
>> https://lore.kernel.org/all/9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com/
>>      #define TDX_BUG_ON_2(__err, __fn, arg1, arg2, __kvm)        \
>>          __TDX_BUG_ON(__err, #__fn, __kvm, ", " #arg1 " 0x%llx, " #arg2 "
>>      0x%llx", arg1, arg2)
>>
>>      so you get: entry: 0x00 level:0xF00
>>
>> No?
> Ya, see the next patch :-)

Oh, sorry for the noise.
>



Return-Path: <kvm+bounces-52690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6612B08343
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 05:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 921134E60EE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 03:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF181E572F;
	Thu, 17 Jul 2025 03:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPGJm6p9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E4A7E107;
	Thu, 17 Jul 2025 03:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752722056; cv=none; b=b+2YS9wq0qW5TU28xKldddhjYguwTKcX15Iz9NKnnlnZO9aDN26jzansOU7glNSPu9vv18X2HilX6dXvzWMc4xu/7dCdZnF59FQEsMLtBq9FfDXiE5fuWhm7q94rnmMDf+3Yo24zwIg4lE9oz3JBOKFe5eTvV8M/NVuOjunNn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752722056; c=relaxed/simple;
	bh=lczO1AdKw3XeNe1pc8ZBsZpTAuXeYBEyhHeCUjSbWhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uShgwWxNo8JSiu2ZyXSCSRM0V6vxFKiHvG7mcFycFC/TF64AFDSLfPV8vLWq2B1Rs/rSmYUGgN8imMTuCCw9tjzuygUV7panlRmafynKQns9ZfcEHJfsoBtJt2sJogfP4j+Kmnr1ZB4qn/71BTmqPWVBfOJtftT7jkAzz9m7atw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPGJm6p9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752722054; x=1784258054;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lczO1AdKw3XeNe1pc8ZBsZpTAuXeYBEyhHeCUjSbWhA=;
  b=VPGJm6p9nPlp/9/GlxP4soUTXUS6GIZ4usApA/iFL/w9pY8xYCMP0XJh
   jTS3OBeB45B9pqwUQ0a94wnEI1OmTQu/CwPQMWz3DuOfCM4dhah91zvL5
   u4T3ar1iAisyx31c6MdvHexcLc6u4YIly3Mc5LlzWT9F6KSeVmNMYWVxT
   TdluCT/dQfFYGuxYpvvqAsK/IZ/kdeyqPQQUIVRiul1qSriKc7+lAxmq2
   QeeeiK/MM14D7VzEf/hX4Xf6HA5FxgTzOlyp8kc06XdwlUYGQPvDEpCD5
   rnzSrJxwr33wPgF4KMO7vBcqZLbE+S7AcvlquocH/JM854tO+O/b0y9JG
   Q==;
X-CSE-ConnectionGUID: SFUnO/qvSwKyELgAR4KawQ==
X-CSE-MsgGUID: zpfBwCuPRRKmmtqxi4SLQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54843432"
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="54843432"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 20:14:13 -0700
X-CSE-ConnectionGUID: n+iXT9pTRcSDkb3MoRbrsg==
X-CSE-MsgGUID: JalUWRbzQIGtzshCblUsNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,317,1744095600"; 
   d="scan'208";a="161967452"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 20:14:12 -0700
Message-ID: <2838eb7a-9d54-48f2-aabe-1428f65a4fd2@intel.com>
Date: Thu, 17 Jul 2025 11:14:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Don't report base TDVMCALLs
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250717022010.677645-1-xiaoyao.li@intel.com>
 <f0281c2f-4ddf-4a0c-81a2-b6de51a4fe82@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f0281c2f-4ddf-4a0c-81a2-b6de51a4fe82@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/17/2025 10:45 AM, Binbin Wu wrote:
> 
> 
> On 7/17/2025 10:20 AM, Xiaoyao Li wrote:
>> Remove TDVMCALLINFO_GET_QUOTE from user_tdvmcallinfo_1_r11 reported to
>> userspace to align with the direction of the GHCI spec.
>>
>> Recently, concern was raised about a gap in the GHCI spec that left
>> ambiguity in how to expose to the guest that only a subset of GHCI
>> TDVMCalls were supported. During the back and forth on the spec 
>> details[0],
>> <GetQuote> was moved from an individually enumerable TDVMCall, to one 
>> that
>> is part of the 'base spec', meaning it doesn't have a specific bit in the
> 
> 'GHCI base API' is more appropriate instead of 'base spec'
> 
>> <GetTDVMCallInfo> return values. Although the spec[1] is still in draft
>> form, the GetQoute part has been agreed by the major TDX VMMs.
> GetQoute  ->  <GetQuote>
> 
> typo and use <> to align with others.
> 
>>
>> Unfortunately the commits that were upstreamed still treat <GetQuote> as
>> individually enumerable. They set bit 0 in the user_tdvmcallinfo_1_r11
>> which is reported to userspace to tell supported optional TDVMCalls,
>> intending to say that <GetQuote> is supported.
>>
>> So stop reporting <GetQute> in user_tdvmcallinfo_1_r11 to align with
> 
> GetQute -> GetQuote
> 
>> the direction of the spec, and allow some future TDVMCall to use that 
>> bit.
>>
>> [0] https://lore.kernel.org/all/aEmuKII8FGU4eQZz@google.com/
>> [1] https://cdrdv2.intel.com/v1/dl/getContent/858626
>>
>> Fixes: 28224ef02b56 ("KVM: TDX: Report supported optional TDVMCALLs in 
>> TDX capabilities")
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Nits: typos and wording suggested above.

thanks for catching them!

I would like to leave them to Paolo to fix when he applies the patch 
instead of spinning a v2.

> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> 
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index f31ccdeb905b..ea1261ca805f 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -173,7 +173,6 @@ static void td_init_cpuid_entry2(struct 
>> kvm_cpuid_entry2 *entry, unsigned char i
>>       tdx_clear_unsupported_cpuid(entry);
>>   }
>> -#define TDVMCALLINFO_GET_QUOTE                BIT(0)
>>   #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT    BIT(1)
>>   static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf 
>> *td_conf,
>> @@ -192,7 +191,6 @@ static int init_kvm_tdx_caps(const struct 
>> tdx_sys_info_td_conf *td_conf,
>>       caps->cpuid.nent = td_conf->num_cpuid_config;
>>       caps->user_tdvmcallinfo_1_r11 =
>> -        TDVMCALLINFO_GET_QUOTE |
>>           TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT;
>>       for (i = 0; i < td_conf->num_cpuid_config; i++)
> 



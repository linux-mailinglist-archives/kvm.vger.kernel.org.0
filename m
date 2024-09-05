Return-Path: <kvm+bounces-25955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3C296DA7C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 15:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CC181C23AD2
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 13:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123D319D885;
	Thu,  5 Sep 2024 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LUWAM3l7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BE01E487;
	Thu,  5 Sep 2024 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725543385; cv=none; b=XnnTl3UhjXaa33E8kkhr187/aex/EojzSW//eqQX7njebDEd92vKSEVkvLf+WD0NznnLoxxiTwTh0s6/2KNyIaipuJ6ud9D4tp3b2pya5VfPdWDNSsd3DOWMQwuZguZLDOrHcMzGX088yNSHaYmi648qa6ZgXNiLyVCZN37MgZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725543385; c=relaxed/simple;
	bh=bwsVZqpl0gb6sDTWOENMlINZBnlx/UFogyS3q6Ro+20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=edishB4/kXxzV991LiAnFUrediVq9gA4AbJLhaP2qtTZSv0TX45KT+LbksX0c6qcRxrzzLLjfd7OS0M++KE3WSFG9nycVA9Fay4asD+BBCst7q05uO8T7cUurkm197YqHqvI4dq7gfFenmkzeq9jd1JMdqXMBG+98XFXMwUK7ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LUWAM3l7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725543384; x=1757079384;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bwsVZqpl0gb6sDTWOENMlINZBnlx/UFogyS3q6Ro+20=;
  b=LUWAM3l7hJEE92xCJ9eZAir2srLs3iZ62D2sipKOH7U2DP1poEcLDsI5
   Ffek15tVV8dWTnGHSD7bBYcAN8COdZytOkzloJr9A738tuQD3kcUZDZNI
   xve8ESZLQ/f78mm8EcW6mqeXFLtU5OWyXqfQDhOp2GRmV2nYpO4Y1W82Y
   6qSGC7Rk1EnSwKZNrFevd3EhH3MX9tvphPS1Z2EGNiImkfi7Edbs1xg7I
   xgjHln+1YeFK7dLG2f+ektMLpbKQwQimUzPxjq6NJxWWdgMylNZ4/lmDk
   9MiYpUg6GzG93vrrK/YvOWxVGNTXmJU8gG5JrsCO8plwWUmsLf51OOhar
   w==;
X-CSE-ConnectionGUID: 5zDz+jI/SKqtzGBLLhLheQ==
X-CSE-MsgGUID: De7u+GrDRKqHRvupgHweKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="41734730"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="41734730"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 06:36:23 -0700
X-CSE-ConnectionGUID: ErhAUB0xROWxdndgX+24ow==
X-CSE-MsgGUID: 3THAGq2eRMykanZA5JkCtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="103079461"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 06:36:20 -0700
Message-ID: <aa764aad-1736-459f-896e-4f43bfe8b18d@intel.com>
Date: Thu, 5 Sep 2024 21:36:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
To: Nikolay Borisov <nik.borisov@suse.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <caa4407a-b838-4e1b-bb3d-87518f3de66b@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/4/2024 7:58 PM, Nikolay Borisov wrote:
> 
> 
> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> While TDX module reports a set of capabilities/features that it
>> supports, what KVM currently supports might be a subset of them.
>> E.g., DEBUG and PERFMON are supported by TDX module but currently not
>> supported by KVM.
>>
>> Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>> supported_attrs and suppported_xfam are validated against fixed0/1
>> values enumerated by TDX module. Configurable CPUID bits derive from TDX
>> module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>> i.e., mask off the bits that are configurable in the view of TDX module
>> but not supported by KVM yet.
>>
>> KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>> and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>> uAPI breakout v1:
>>   - Change setup_kvm_tdx_caps() to use the exported 'struct tdx_sysinfo'
>>     pointer.
>>   - Change how to copy 'kvm_tdx_cpuid_config' since 'struct tdx_sysinfo'
>>     doesn't have 'kvm_tdx_cpuid_config'.
>>   - Updates for uAPI changes
>> ---
>>   arch/x86/include/uapi/asm/kvm.h |  2 -
>>   arch/x86/kvm/vmx/tdx.c          | 81 +++++++++++++++++++++++++++++++++
>>   2 files changed, 81 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h 
>> b/arch/x86/include/uapi/asm/kvm.h
>> index 47caf508cca7..c9eb2e2f5559 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
>>       __u64 hw_error;
>>   };
>> -#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>> -
>>   struct kvm_tdx_cpuid_config {
>>       __u32 leaf;
>>       __u32 sub_leaf;
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 90b44ebaf864..d89973e554f6 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
>>       ida_free(&tdx_guest_keyid_pool, keyid);
>>   }
>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>> +
>> +struct kvm_tdx_caps {
>> +    u64 supported_attrs;
>> +    u64 supported_xfam;
>> +
>> +    u16 num_cpuid_config;
>> +    /* This must the last member. */
>> +    DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
>> +};
>> +
>> +static struct kvm_tdx_caps *kvm_tdx_caps;
>> +
>>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>>   {
>>       const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
>> @@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>>       return r;
>>   }
>> +#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
> 
> Why isn't TDX_TD_ATTR_DEBUG added as well?

Because so far KVM doesn't support all the features of a DEBUG TD for 
userspace. e.g., KVM doesn't provide interface for userspace to 
read/write private memory of DEBUG TD.

> <snip>



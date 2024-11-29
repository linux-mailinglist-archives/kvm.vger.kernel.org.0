Return-Path: <kvm+bounces-32770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0699DC2F3
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 12:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F66281C08
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 11:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9830C19A281;
	Fri, 29 Nov 2024 11:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bO43w9D5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3219E17ADF7;
	Fri, 29 Nov 2024 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732880387; cv=none; b=Cw+6v5N4kRdv1agrcrZefMMvarSQiF8D0YtirvU2E86uRZhXFCL/2G32jbaEAFbIvKVbMSaH9CFINBjl5+6v9GPfv6ugKIfe/8lkGQdjRiRUZNdpBhKgdCbu42akaak6XfuFIR8WfimQWGn0CH4N9OwZv6Dcg1PDz5o9663rBnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732880387; c=relaxed/simple;
	bh=ARvAC3U7Sz2sw+G4OdBfXDegCVZu5eOVnOgNxlHAWPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E994v1AzlyFhQENEF/QfTgBZhrZou/XzHXdoTPXPOwa3MRP1vJ5CxjmDfDyq0WA5plflfNfckx9asRJ+j97RMdfxk5fPzze7P8UPPM2CYEMvAQP1/So/HsuoLukfS/Zez1DDlvpfrsxweYMlIdrYhd7xzmp2W/8AcAMJC1nRrYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bO43w9D5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732880387; x=1764416387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ARvAC3U7Sz2sw+G4OdBfXDegCVZu5eOVnOgNxlHAWPA=;
  b=bO43w9D5XwxjMwe7jHNIV2PdaW/36pDg+FwOzRsFHnNAvtiB3Q4KuKzk
   34WUikAIBiX/y3c871vc+ieu+zlFRZdp7KWd2z02it76+EvpUr+VBAkZ/
   Q0cDgekKWCD4TfTaTJ+9UiE7r47Tdz/zN7VpXhRYjX0TCkRIQQDNaUSyX
   05hZEGVL/m9WHKTbTSWU3quoIoTbseCuuRu0Kn7gJ0/IsEzUsh2sY1uU4
   nZ4AN1ox4qQsD3suTDzGsn6QKafipKBwm7sFb2q+UmLb2i9VE6MO4XQCS
   ywaxu26br0Yw7OdwYhQJBU55139UBCNcumhVl6DYlmb+DZBDVC9lmnrlV
   Q==;
X-CSE-ConnectionGUID: u3XFPhftSOKW31XkEw2T0A==
X-CSE-MsgGUID: EqhomqcART6P3yvY+x6Dcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11270"; a="44489568"
X-IronPort-AV: E=Sophos;i="6.12,195,1728975600"; 
   d="scan'208";a="44489568"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 03:39:46 -0800
X-CSE-ConnectionGUID: 85tpzxxPRfmE86pedbEXiw==
X-CSE-MsgGUID: Rv8iy6csQdefett5thzfoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,195,1728975600"; 
   d="scan'208";a="92648836"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 03:39:40 -0800
Message-ID: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
Date: Fri, 29 Nov 2024 13:39:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 yan.y.zhao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com> <Zz/6NBmZIcRUFvLQ@intel.com>
 <Z0cmEd5ehnYT8uc-@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0cmEd5ehnYT8uc-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/11/24 16:00, Sean Christopherson wrote:
> On Fri, Nov 22, 2024, Chao Gao wrote:
>>> +static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
>>> +{
>>> +	const struct kvm_cpuid_entry2 *entry;
>>> +	u64 mask;
>>> +	u32 ebx;
>>> +
>>> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x7, 0);
>>> +	if (entry)
>>> +		ebx = entry->ebx;
>>> +	else
>>> +		ebx = 0;
>>> +
>>> +	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
>>> +	return ebx & mask;
>>> +}
>>> +
>>> static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>>> 			struct kvm_tdx_init_vm *init_vm)
>>> {
>>> @@ -1299,6 +1322,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>>> 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
>>> 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
>>>
>>> +	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
>>> 	return 0;
>>> }
>>>
>>> @@ -2272,6 +2296,11 @@ static int __init __tdx_bringup(void)
>>> 			return -EIO;
>>> 		}
>>> 	}
>>> +	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
>>> +	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
>>> +		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
>>> +		return -EIO;
>>> +	}
>>>
>>> 	/*
>>> 	 * Enabling TDX requires enabling hardware virtualization first,
>>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>>> index 48cf0a1abfcc..815ff6bdbc7e 100644
>>> --- a/arch/x86/kvm/vmx/tdx.h
>>> +++ b/arch/x86/kvm/vmx/tdx.h
>>> @@ -29,6 +29,14 @@ struct kvm_tdx {
>>> 	u8 nr_tdcs_pages;
>>> 	u8 nr_vcpu_tdcx_pages;
>>>
>>> +	/*
>>> +	 * Used on each TD-exit, see tdx_user_return_msr_update_cache().
>>> +	 * TSX_CTRL value on TD exit
>>> +	 * - set 0     if guest TSX enabled
>>> +	 * - preserved if guest TSX disabled
>>> +	 */
>>> +	bool tsx_supported;
>>
>> Is it possible to drop this boolean and tdparams_tsx_supported()? I think we
>> can use the guest_can_use() framework instead.
> 
> Yeah, though that optimized handling will soon come for free[*], and I plan on
> landing that sooner than TDX, so don't fret too much over this.
> 
> [*] https://lore.kernel.org/all/20240517173926.965351-1-seanjc@google.com

guest_can_use() is per-vcpu whereas we are currently using the
CPUID from TD_PARAMS (as per spec) before there are any VCPU's.
It is a bit of a disconnect so let's keep tsx_supported for now.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580403054BD
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhA0HdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:33:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:60070 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317811AbhA0ATP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:19:15 -0500
IronPort-SDR: vDgZIY5oWJj7LY9VxUIKjgfglKRvFjWJxnlhPnh6H+AGXpGckU7/XbImrcwiys6rCz/4U+2HEn
 GUlW5ESKC4zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="264816014"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="264816014"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:18:33 -0800
IronPort-SDR: qcf6kcogC5RsUNtGMUh3yfbVWKsLjrljILXNnGddLw69ryk/TYIXEBBZWz39qoCBEORmQei5kC
 fW6U4Ira10SA==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="410338734"
Received: from kalinapo-mobl.amr.corp.intel.com (HELO [10.209.85.22]) ([10.209.85.22])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:18:33 -0800
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
References: <cover.1611634586.git.kai.huang@intel.com>
 <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
 <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
 <20210127125607.52795a882ace894b19f41d68@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <ecb0595b-76e9-9298-438d-80de28156371@intel.com>
Date:   Tue, 26 Jan 2021 16:18:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210127125607.52795a882ace894b19f41d68@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 3:56 PM, Kai Huang wrote:
> On Tue, 26 Jan 2021 08:26:21 -0800 Dave Hansen wrote:
>> On 1/26/21 1:30 AM, Kai Huang wrote:
>>> --- a/arch/x86/kernel/cpu/feat_ctl.c
>>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
>>> @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
>>>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>>>  {
>>>  	bool tboot = tboot_enabled();
>>> -	bool enable_sgx;
>>> +	bool enable_vmx;
>>> +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
>>>  	u64 msr;
>>>  
>>>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
>>> @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>>>  		return;
>>>  	}
>>>  
>>> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
>>> +		     IS_ENABLED(CONFIG_KVM_INTEL);
>>
>> The reason it's called 'enable_sgx' below is because this code is
>> actually going to "enable sgx".  This code does not "enable vmx".  That
>> makes this a badly-named variable.  "vmx_enabled" or "vmx_available"
>> would be better.
> 
> It will also try to enable VMX if feature control MSR is not locked by BIOS.
> Please see below code:

Ahh, I forgot this is non-SGX code.  It's mucking with all kinds of
other stuff in the same MSR.  Oh, well, I guess that's what you get for
dumping a bunch of refactoring in the same patch as the new code.


>>> -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
>>> -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
>>> -		     IS_ENABLED(CONFIG_X86_SGX);
>>> +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
>>> +			 cpu_has(c, X86_FEATURE_SGX1) &&
>>> +			 IS_ENABLED(CONFIG_X86_SGX);
>>
>> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?
> 
> Please see my reply to Sean's reply.

... yes, so you're breaking out the fix into a separate patch,.

>>>  update_sgx:
>>> -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
>>> -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
>>> -		if (enable_sgx)
>>> -			pr_err_once("SGX disabled by BIOS\n");
>>> +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
>>> +		if (enable_sgx_kvm || enable_sgx_driver)
>>> +			pr_err_once("SGX disabled by BIOS.\n");
>>>  		clear_cpu_cap(c, X86_FEATURE_SGX);
>>> +		return;
>>> +	}
>>
>>
>> Isn't there a pr_fmt here already?  Won't these just look like:
>>
>> 	sgx: SGX disabled by BIOS.
>>
>> That seems a bit silly.
> 
> Please see my reply to Sean's reply.

Got it.  I was thinking this was in the SGX code, not in the generic CPU
setup code.

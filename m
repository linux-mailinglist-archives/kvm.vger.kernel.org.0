Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E473043D2
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392894AbhAZQ1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:27:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:64033 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405307AbhAZQ1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 11:27:20 -0500
IronPort-SDR: kFkIZKoKRDFSeBncQRLLxfZgQTh747oMaR/CYhxdnakeifPT151Ec1laa11HQpOCafaB3LAV1v
 dRV5gm+1RIBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241458294"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="241458294"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 08:26:23 -0800
IronPort-SDR: BtBCh3ShU89UuBNymlK0+t8vwR12RjTCD9XTyMw7JUgr/JDYw5YYiIH5AhOXOJEOHoMhqxBx1W
 hIW7wAwjlx+Q==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="369154366"
Received: from ekfraser-mobl1.amr.corp.intel.com (HELO [10.209.173.94]) ([10.209.173.94])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 08:26:22 -0800
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
References: <cover.1611634586.git.kai.huang@intel.com>
 <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
Date:   Tue, 26 Jan 2021 08:26:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 1:30 AM, Kai Huang wrote:
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  {
>  	bool tboot = tboot_enabled();
> -	bool enable_sgx;
> +	bool enable_vmx;
> +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
>  	u64 msr;
>  
>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  		return;
>  	}
>  
> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> +		     IS_ENABLED(CONFIG_KVM_INTEL);

The reason it's called 'enable_sgx' below is because this code is
actually going to "enable sgx".  This code does not "enable vmx".  That
makes this a badly-named variable.  "vmx_enabled" or "vmx_available"
would be better.

>  	/*
> -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> +	 * Enable SGX if and only if the kernel supports SGX.  Require Launch
> +	 * Control support if SGX virtualization is *not* supported, i.e.
> +	 * disable SGX if the LE hash MSRs can't be written and SGX can't be
> +	 * exposed to a KVM guest (which might support non-LC configurations).
>  	 */

I hate this comment.

	/*
	 * Separate out bare-metal SGX enabling from KVM.  This allows
	 * KVM guests to use SGX even if the kernel refuses to use it on
	 * bare-metal.  This happens if flexible Faunch Control is not
	 * available.
	 *

> -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> -		     IS_ENABLED(CONFIG_X86_SGX);
> +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> +			 cpu_has(c, X86_FEATURE_SGX1) &&
> +			 IS_ENABLED(CONFIG_X86_SGX);

The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?

> +	enable_sgx_driver = enable_sgx_any &&
> +			    cpu_has(c, X86_FEATURE_SGX_LC);
> +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
>  
>  	if (msr & FEAT_CTL_LOCKED)
>  		goto update_caps;
> @@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
>  	 * for the kernel, e.g. using VMX to hide malicious code.
>  	 */
> -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> +	if (enable_vmx) {
>  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
>  
>  		if (tboot)
>  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
>  	}
>  
> -	if (enable_sgx)
> -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> +	if (enable_sgx_kvm || enable_sgx_driver) {
> +		msr |= FEAT_CTL_SGX_ENABLED;
> +		if (enable_sgx_driver)
> +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> +	}
>  
>  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
>  
> @@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  	}
>  
>  update_sgx:
> -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> -		if (enable_sgx)
> -			pr_err_once("SGX disabled by BIOS\n");
> +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> +		if (enable_sgx_kvm || enable_sgx_driver)
> +			pr_err_once("SGX disabled by BIOS.\n");
>  		clear_cpu_cap(c, X86_FEATURE_SGX);
> +		return;
> +	}


Isn't there a pr_fmt here already?  Won't these just look like:

	sgx: SGX disabled by BIOS.

That seems a bit silly.

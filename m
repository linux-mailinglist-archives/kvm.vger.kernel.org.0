Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504232EC48A
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbhAFUNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 15:13:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:21805 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbhAFUNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 15:13:34 -0500
IronPort-SDR: tJZYT97O2o5nsHtVTLr3wiDkQnF74ZJR/zR5Hjosxw331Xo0Y236L1hhsRFlOKPNwKwX9RKnQB
 v74dTq1jOXAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="177483433"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="177483433"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 12:12:53 -0800
IronPort-SDR: rTYlajJyn/nG1I/BSs6V2/0B25e4DMLxXmEeZ6Y9PgxFy+87MmNCBQq+Dp4RchfhVYm15sPVw2
 xqk33bMxAzHA==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="422301686"
Received: from jmonroe1-mobl2.amr.corp.intel.com (HELO [10.212.12.85]) ([10.212.12.85])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 12:12:52 -0800
Subject: Re: [RFC PATCH 11/23] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1609890536.git.kai.huang@intel.com>
 <6b29d1ee66715b40aba847b31cbdac71cbb22524.1609890536.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <863820fc-f0d2-6be6-52db-ab3eefe36f64@intel.com>
Date:   Wed, 6 Jan 2021 12:12:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6b29d1ee66715b40aba847b31cbdac71cbb22524.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/21 5:56 PM, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Provide wrappers around __ecreate() and __einit() to hide the ugliness
> of overloading the ENCLS return value to encode multiple error formats
> in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
> of SGX virtualization, and on an exception, KVM needs the trapnr so that
> it can inject the correct fault into the guest.

This is missing a bit of a step about how and why ECREATE needs to be
run in the host in the first place.

> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> new file mode 100644
> index 000000000000..0d643b985085
> --- /dev/null
> +++ b/arch/x86/include/asm/sgx.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_SGX_H
> +#define _ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_X86_SGX_VIRTUALIZATION
> +struct sgx_pageinfo;
> +
> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> +		     int *trapnr);
> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
> +#endif
> +
> +#endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index d625551ccf25..4e9810ba9259 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -261,3 +261,58 @@ int __init sgx_virt_epc_init(void)
>  
>  	return misc_register(&sgx_virt_epc_dev);
>  }
> +
> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> +		     int *trapnr)
> +{
> +	int ret;
> +
> +	__uaccess_begin();
> +	ret = __ecreate(pageinfo, (void *)secs);
> +	__uaccess_end();

The __uaccess_begin/end() worries me.  There are *very* few of these in
the kernel and it seems like something we want to use as sparingly as
possible.

Why don't we just use the kernel mapping for 'secs' and not have to deal
with stac/clac?

I'm also just generally worried about casting away an __user without
doing any checking.  How is that OK?

> +	if (encls_faulted(ret)) {
> +		*trapnr = ENCLS_TRAPNR(ret);
> +		return -EFAULT;
> +	}
> +
> +	/* ECREATE doesn't return an error code, it faults or succeeds. */
> +	WARN_ON_ONCE(ret);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
> +
> +static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
> +			    void __user *secs)
> +{
> +	int ret;
> +
> +	__uaccess_begin();
> +	ret =  __einit((void *)sigstruct, (void *)token, (void *)secs);
> +	__uaccess_end();
> +	return ret;
> +}

If casting away one __user wasn't good enough, we get three! :)

We need some more background in the changelog on why this is OK.

> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr)
> +{
> +	int ret;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> +		ret = __sgx_virt_einit(sigstruct, token, secs);
> +	} else {
> +		preempt_disable();
> +
> +		sgx_update_lepubkeyhash(lepubkeyhash);
> +
> +		ret = __sgx_virt_einit(sigstruct, token, secs);
> +		preempt_enable();
> +	}
> +
> +	if (encls_faulted(ret)) {
> +		*trapnr = ENCLS_TRAPNR(ret);
> +		return -EFAULT;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> 


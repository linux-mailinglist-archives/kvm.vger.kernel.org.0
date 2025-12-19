Return-Path: <kvm+bounces-66405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E283CD13E2
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DD1430CB142
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E623557FB;
	Fri, 19 Dec 2025 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HdXstqCN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82A355038;
	Fri, 19 Dec 2025 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766166313; cv=none; b=FvgxWXybSReuOC6VyhLBDJ5gK2TuN7YrpeMwGfuCh3UkokYPV/ddWJqrdUJcMyM722H2wEMNCpB1C3QbtxOCOd94SFH+xQBhaPW7nBaZH5HVz4l0dfN5Vw8eX5A+Ij0XOslvrseu1Pe8BuvGmfVGJiaTtlwQp6/qNuBz6MV3yl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766166313; c=relaxed/simple;
	bh=z4Soyab2jeoJ7YzJg0t2np5dpClWtNWLEJAC3/9ALwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oEbvhy4XiZ34J+leM00ON0ADXCUr/eAfTl6vFfeWPujTJ50d6jYYb7PF/LaiOlxuGyL2Z8LfcDrSPLIA/adu9HYzojWGWC91cEXlHWBEWvMtlh8dbn71yhIF0jN88gHWFz3dZmVIkHt1LDukmW3+hqkYRVwvK+u/x/MbXhErMs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HdXstqCN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766166311; x=1797702311;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z4Soyab2jeoJ7YzJg0t2np5dpClWtNWLEJAC3/9ALwI=;
  b=HdXstqCNq1DQr985VYiUmvfVDDu8zPSkoDLsxI2hDhzcxV/3NJZxxzX6
   nPxJo3VdF9/4A9gxYmRE5ozdhx33ATPTzbLQ97VVcNQepneV8yzoD73st
   arUp/W/EoqPqd8VO0/d30w4VH+F73mpeAnGtddbQU3EC+fzxbyx7V0d1a
   THalRwIUqQ34nAoIRpZNADobaOGkZDPuJ/drLHWvv0ceeK2HJYsQnWWf9
   jpp1PPlkgxgl2FFwDWA0jRqrhiXWs9Z4BBx1J3CBkLyywORGZ86t0k9u8
   PxIHNUu0KoF67nuY/UbNf12mydSI3iACn2UPzXXlAu7rkamQQqsd2Q4IK
   w==;
X-CSE-ConnectionGUID: yLpMu8YMSm+rYyPycMoedw==
X-CSE-MsgGUID: N6w7P7vFSaq/FTUDVXD1Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="78764599"
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="78764599"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 09:45:11 -0800
X-CSE-ConnectionGUID: Or1e/VJgQfSaNFH0PfJKfQ==
X-CSE-MsgGUID: PfkgpOCCQOOjbC3je0dOgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="198066920"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.100]) ([10.125.111.100])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 09:45:11 -0800
Message-ID: <90837ad5-c9a6-42da-a5a8-fcd2d870dac8@intel.com>
Date: Fri, 19 Dec 2025 09:45:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Kiryl Shutsemau <kas@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251206011054.494190-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/25 17:10, Sean Christopherson wrote:
> Move the innermost VMXON and EFER.SVME management logic out of KVM and
> into to core x86 so that TDX can force VMXON without having to rely on
> KVM being loaded, e.g. to do SEAMCALLs during initialization.
> 
> Implement a per-CPU refcounting scheme so that "users", e.g. KVM and the
> future TDX code, can co-exist without pulling the rug out from under each
> other.
> 
> To avoid having to choose between SVM and VMX, simply refuse to enable
> either if both are somehow supported.  No known CPU supports both SVM and
> VMX, and it's comically unlikely such a CPU will ever exist.

Yeah, that's totally a "please share your drugs" moment, if it happens.

> +static int x86_vmx_get_cpu(void)
> +{
> +	int r;
> +
> +	if (cr4_read_shadow() & X86_CR4_VMXE)
> +		return -EBUSY;
> +
> +	intel_pt_handle_vmx(1);
> +
> +	r = x86_virt_cpu_vmxon();
> +	if (r) {
> +		intel_pt_handle_vmx(0);
> +		return r;
> +	}
> +
> +	return 0;
> +}
...> +#define x86_virt_call(fn)				\
> +({							\
> +	int __r;					\
> +							\
> +	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
> +	    cpu_feature_enabled(X86_FEATURE_VMX))	\
> +		__r = x86_vmx_##fn();			\
> +	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
> +		 cpu_feature_enabled(X86_FEATURE_SVM))	\
> +		__r = x86_svm_##fn();			\
> +	else						\
> +		__r = -EOPNOTSUPP;			\
> +							\
> +	__r;						\
> +})

I'm not a super big fan of this. I know you KVM folks love your macros
and wrapping function calls in them because you hate grep. ;)

I don't like a foo_get_cpu() call having such fundamentally different
semantics than good old get_cpu() itself. *Especially* when the calls
look like:

	r = x86_virt_call(get_cpu);

and get_cpu() itself it not invovled one bit. This 100% looks like it's
some kind of virt-specific call for get_cpu().

I think it's probably OK to make this get_hw_ref() or inc_hw_ref() or
something to get it away from getting confused with get_cpu().

IMNHO, the macro magic is overkill. A couple of global function pointers
would probably be fine because none of this code is even remotely
performance sensitive. A couple static_call()s would be fine too because
those at least make it blatantly obvious that the thing being called is
variable. A good ol' ops structure would also make things obvious, but
are probably also overkill-adjecent for this.

P.S. In a perfect world, the renames would also be in their own patches,
but I think I can live with it as-is.


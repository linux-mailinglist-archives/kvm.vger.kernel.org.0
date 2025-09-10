Return-Path: <kvm+bounces-57190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A42B9B512B6
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D20161C828EE
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4913148A1;
	Wed, 10 Sep 2025 09:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hfHiZmbp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E61EBA14;
	Wed, 10 Sep 2025 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497121; cv=none; b=fN7LyQxmCb8hPF7HKvyy2lTOAbjVs5iFisck8u4ChJOu1jFUZSRRCvtT7zHNL6SxoA2263YIT4tWh1SWG4q7MOodMCLGoowI1IHWbk7Xd5mJqMQVpqDRTJfaR6d7j7fsGZeDaV7Jf4ps1mfmCCtCwQCrUtyVQJphQdIpRoxRaY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497121; c=relaxed/simple;
	bh=EMpd3gvqX8iY0MLFJz1Rt7MQin6Dzcdt7Lq82h/v5UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGBIw/ISo2mztJ0knDlcK7oKR4JwpTvTX8KoO+pia5+JVzvKpMgkVLE644VSPjElePJCk4/iO2Wv9G0/IlOLh3oLf1kAWFcNn8APVpNDYIU1UO2qXwxzRQLuZQbRDMTZh4KqxsMblpXMgP4BNXubU36jevNZbev2LlTr5RsaehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hfHiZmbp; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757497120; x=1789033120;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EMpd3gvqX8iY0MLFJz1Rt7MQin6Dzcdt7Lq82h/v5UM=;
  b=hfHiZmbpSl4OR0WzdZsSAeGG0aLkFK9KbgVhJ3cQiCDbxfvcFTCHgfUg
   bGs4okNt9gdTbSajSRMF8hEM+rKPkSRWv7VBCP8vhd5l1EYM7fh+DNqVa
   1X8Zlv1HRen4wp3lagHXFNnPZhEjslQ6mz+frQNeRKE47sybbT12cwK0M
   oNDIgqouEduMLaToT1gkMCI3vm2GmaIx0rJ0FT33qtcIQpvBsKy9mdhAN
   BR/58vpC5JDhUiW08ljnDcpNMMh9kGZWF+wqs8SR1gTy6Fy2C+MrwPQez
   qQSZhVcPkUbdVtMz63DyQzHKXzWXnseGI5uYHvKV1ASee5atemhV+taEy
   w==;
X-CSE-ConnectionGUID: kybKLRxhTMy37X4R8zBT7g==
X-CSE-MsgGUID: 6NMLmpnLQu+pKrJdVc5S0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="71216876"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="71216876"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:38:39 -0700
X-CSE-ConnectionGUID: g8EKtBtYRAKQOLNvcdZn1w==
X-CSE-MsgGUID: kIToiwnqSJ6a123RyMBrAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173255473"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:38:34 -0700
Message-ID: <4575e64f-8989-4a33-8f37-c013ba8f676f@intel.com>
Date: Wed, 10 Sep 2025 17:38:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/22] KVM: x86: Add fault checks for guest CR4.CET
 setting
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-8-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-8-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Check potential faults for CR4.CET setting per Intel SDM requirements.
> CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
> 1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c0a07be6b64..50c192c99a7e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1173,6 +1173,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>   	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
>   		return 1;
>   
> +	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
> +		return 1;
> +
>   	kvm_x86_call(set_cr0)(vcpu, cr0);
>   
>   	kvm_post_set_cr0(vcpu, old_cr0, cr0);
> @@ -1372,6 +1375,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   			return 1;
>   	}
>   
> +	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
> +		return 1;
> +
>   	kvm_x86_call(set_cr4)(vcpu, cr4);
>   
>   	kvm_post_set_cr4(vcpu, old_cr4, cr4);



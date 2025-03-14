Return-Path: <kvm+bounces-41020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E372FA60797
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 03:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4DD460F00
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 02:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261D57083F;
	Fri, 14 Mar 2025 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNJSIRIR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AA02E3364;
	Fri, 14 Mar 2025 02:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741920168; cv=none; b=ugdI4JgjrJFtxdmnacDnV9gDt1H1izhscM8xCZ5knrTru+TrHiiroVmQv3Z8Q1FoW3ZvxqVdlWUKGvisinMFZzqGl6UtdI0CZpGh9+1HHw3yOn1/jknnhzOK8SOvIgG7ng1ENxQVTLRmqOmP5JZuHOCqGP6txfEpCdSz+CeRVh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741920168; c=relaxed/simple;
	bh=IHnkLmOiLY3MQ7jD5itWUipEQMKkVCo+vJ9rLn/FtWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+/+QYk1im+e6FBK/y4t318vEcqDd/svv6t5th9kKBW2l51/FT7Z1tsiH1dHG8xqvhfklFcBAGDgCoBVSH9iq0/Yshll5jEK2d2A7wM8OZGXiPLdGvJHatnAbmJNvMoz1YG/V8gO5zsHHs9SkArOpFiFJ10U/fMzb1VHG2dxCow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNJSIRIR; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741920167; x=1773456167;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IHnkLmOiLY3MQ7jD5itWUipEQMKkVCo+vJ9rLn/FtWA=;
  b=iNJSIRIRHN6p75lSfYRnsVAFzTlGEutwvISczHye/53wiDjZorSYH+V8
   lK7b+Tg7pyuVm5MLTWtJ0TsI+zs0pbjDtj7m46Km7MAZGeu4nBcoubd2M
   uaHheY/fzbd/65HEjwGxPZO0vjMbfjUVwaWE1wZf5YEgZv8kM/ETe+uVc
   Mj3eCZCVUkZz3V8gLxSEnaBAN7113aXlV0jfRZlK1ifl9dLao+z7QH3lI
   K8yuJ39tQKPSn3h/B+JJYtAqFV4ZhFr4bO5Jkn3tV4KYO0ZEWWpbHoRnv
   bU+lFN7xWW298A2KoaWVJvt72NLj6EZo2zB5ffW+DLpUifacBTlrRBXsU
   A==;
X-CSE-ConnectionGUID: 6z14DKQxQl+DwdiPzxPMbA==
X-CSE-MsgGUID: 5kWp/787RtatmVZyyT7bUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="54441853"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="54441853"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 19:42:46 -0700
X-CSE-ConnectionGUID: /fBGos3pRraA3qEmRRAnxQ==
X-CSE-MsgGUID: eklPN9yvSoGwGSLZPfu0xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="120858659"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.54]) ([10.124.240.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 19:42:44 -0700
Message-ID: <d4c19589-baa4-47a8-8d3d-bff10ba6aa64@linux.intel.com>
Date: Fri, 14 Mar 2025 10:42:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] KVM: VMX: Move x86_ops wrappers under
 CONFIG_KVM_INTEL_TDX
To: Vishal Verma <vishal.l.verma@intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250313-vverma7-cleanup_x86_ops-v1-0-0346c8211a0c@intel.com>
 <20250313-vverma7-cleanup_x86_ops-v1-2-0346c8211a0c@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250313-vverma7-cleanup_x86_ops-v1-2-0346c8211a0c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/14/2025 3:30 AM, Vishal Verma wrote:
> Rather than have a lot of stubs for x86_ops helpers, simply omit the
> wrappers when CONFIG_KVM_INTEL_TDX=n.  This allows nearly all of
> vmx/main.c to go under a single #ifdef.  That eliminates all the
> trampolines in the generated code, and almost all of the stubs.

In this patch, these vt_xxx() functions still are common code.
Move these functions inside CONFIG_KVM_INTEL_TDX will break the build for
kvm-intel when CONFIG_KVM_INTEL_TDX=n.

Maybe just squash this patch into 4/4?

>
> Based on a patch by Sean Christopherson <seanjc@google.com>
>
> Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.h     | 2 +-
>   arch/x86/kvm/vmx/x86_ops.h | 2 +-
>   arch/x86/kvm/vmx/main.c    | 4 ++--
>   3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 8f8070d0f55e..b43d7a7c8f1c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -5,7 +5,7 @@
>   #include "tdx_arch.h"
>   #include "tdx_errno.h"
>   
> -#ifdef CONFIG_INTEL_TDX_HOST
> +#ifdef CONFIG_KVM_INTEL_TDX
>   #include "common.h"
>   
>   int tdx_bringup(void);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 19f770b0fc81..4704bed033b1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -121,7 +121,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>   #endif
>   void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
> -#ifdef CONFIG_INTEL_TDX_HOST
> +#ifdef CONFIG_KVM_INTEL_TDX
>   void tdx_disable_virtualization_cpu(void);
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 9d201ddb794a..ccb81a8b73f7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -10,9 +10,8 @@
>   #include "tdx.h"
>   #include "tdx_arch.h"
>   
> -#ifdef CONFIG_INTEL_TDX_HOST
> +#ifdef CONFIG_KVM_INTEL_TDX
>   static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
> -#endif
>   
>   static void vt_disable_virtualization_cpu(void)
>   {
> @@ -879,6 +878,7 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>   
>   	return 0;
>   }
> +#endif
>   
>   #define VMX_REQUIRED_APICV_INHIBITS				\
>   	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
>



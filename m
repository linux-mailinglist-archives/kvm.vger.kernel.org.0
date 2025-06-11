Return-Path: <kvm+bounces-48960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 217DBAD48E9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B2183A742F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FE618FDD5;
	Wed, 11 Jun 2025 02:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGiYhYmC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F592D540B;
	Wed, 11 Jun 2025 02:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749609333; cv=none; b=Z2WKmoLC/UxBvCVr6J7LV9iuIzJIDBJM78pGjjn1sWCm3MSwu4dVJKJMQFvrwGKcusFpIix20r31wJNdZ80aixBbLuRzruDqysPSIjnKQvGP9K2BDitnz9EL7+tjYZYLIFD/IaUWyV/KFLooBOdVzotJ5NW1kwVt4u2kam3YmAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749609333; c=relaxed/simple;
	bh=DuYa7ouVX0jvgihAaCsa131PXtTGMbKKKSQldyZooIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzhSpdAyhIWwna93TJjswIAEj0yqT2RTtR7akeGvCLxCK/UkCbs9YX8gcr2Bgs07qPYUQa46ufobVmKyEl5/LLf6K502jaVultgULTofLj6fo22PDIFr3avi35a6Z2aVs6kfDf8NqTDp7JNB7BWCeB94A7n4fsmv+KGxpNSnIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGiYhYmC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749609331; x=1781145331;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DuYa7ouVX0jvgihAaCsa131PXtTGMbKKKSQldyZooIk=;
  b=fGiYhYmChwK1AuMFbVWsuxVOWPljJf5O2r13dM9k8SAF5zmUWt74/4r7
   ZMiVXxaXtFOMZu/ULx2E+tZjN31RNrUpXR2o1rVbEqOl1+fDIsSLwlbeh
   7I/e84VaUMh+rT5/hM3rHw0BJri/PPMHMp1NKt1TGCi21BEFwyZf3nSA+
   F0OgwuHmconXxr6ARoal1rm1IvbicrwpFF53ubArbWiHjC2DScKHGVV/2
   70WYLOwSTeQ+VO3GYWZ1Z+AadjWM38dK2yoMRKmz/cHPOeigYYHF5ROXa
   LQ+CM2zUzywgR2e2tbwV7zOwCnjwv7cdkLBdFyQDL4THdZVnPd66ZnXDv
   w==;
X-CSE-ConnectionGUID: lljja/fdTC2uJ2NNyj4CAg==
X-CSE-MsgGUID: uSSSgLVeSBy0q4oxno0z5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="50964447"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="50964447"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:35:31 -0700
X-CSE-ConnectionGUID: ql+0J15VSBeI9ksKw36QMg==
X-CSE-MsgGUID: rTCBjoGuTyOJyrJIT1DCMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="147395886"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:35:29 -0700
Message-ID: <8f71ad94-034c-4282-85eb-abedda49ece4@linux.intel.com>
Date: Wed, 11 Jun 2025 10:35:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/32] KVM: x86: Simplify userspace filter logic when
 disabling MSR interception
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-32-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610225737.156318-32-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Refactor {svm,vmx}_disable_intercept_for_msr() to simplify the handling of
> userspace filters that disallow access to an MSR.  The more complicated
> logic is no longer needed or justified now that KVM recalculates all MSR
> intercepts on a userspace MSR filter change, i.e. now that KVM doesn't
> need to also update shadow bitmaps.
>
> No functional change intended.
>
> Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 24 ++++++++++--------------
>  arch/x86/kvm/vmx/vmx.c | 24 ++++++++++--------------
>  2 files changed, 20 insertions(+), 28 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e3c49c763225..5453478d1ca3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -691,24 +691,20 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	void *msrpm = svm->msrpm;
>  
>  	/* Don't disable interception for MSRs userspace wants to handle. */
> -	if ((type & MSR_TYPE_R) &&
> -	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
> -		svm_set_msr_bitmap_read(msrpm, msr);
> -		type &= ~MSR_TYPE_R;
> +	if (type & MSR_TYPE_R) {
> +		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> +			svm_clear_msr_bitmap_read(msrpm, msr);
> +		else
> +			svm_set_msr_bitmap_read(msrpm, msr);
>  	}
>  
> -	if ((type & MSR_TYPE_W) &&
> -	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
> -		svm_set_msr_bitmap_write(msrpm, msr);
> -		type &= ~MSR_TYPE_W;
> +	if (type & MSR_TYPE_W) {
> +		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
> +			svm_clear_msr_bitmap_write(msrpm, msr);
> +		else
> +			svm_set_msr_bitmap_write(msrpm, msr);
>  	}
>  
> -	if (type & MSR_TYPE_R)
> -		svm_clear_msr_bitmap_read(msrpm, msr);
> -
> -	if (type & MSR_TYPE_W)
> -		svm_clear_msr_bitmap_write(msrpm, msr);
> -
>  	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
>  	svm->nested.force_msr_bitmap_recalc = true;
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bdff81f8288d..277c6b5b5d5f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3962,23 +3962,19 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  
>  	vmx_msr_bitmap_l01_changed(vmx);
>  
> -	if ((type & MSR_TYPE_R) &&
> -	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
> -		vmx_set_msr_bitmap_read(msr_bitmap, msr);
> -		type &= ~MSR_TYPE_R;
> +	if (type & MSR_TYPE_R) {
> +		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> +			vmx_clear_msr_bitmap_read(msr_bitmap, msr);
> +		else
> +			vmx_set_msr_bitmap_read(msr_bitmap, msr);
>  	}
>  
> -	if ((type & MSR_TYPE_W) &&
> -	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
> -		vmx_set_msr_bitmap_write(msr_bitmap, msr);
> -		type &= ~MSR_TYPE_W;
> +	if (type & MSR_TYPE_W) {
> +		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
> +			vmx_clear_msr_bitmap_write(msr_bitmap, msr);
> +		else
> +			vmx_set_msr_bitmap_write(msr_bitmap, msr);
>  	}
> -
> -	if (type & MSR_TYPE_R)
> -		vmx_clear_msr_bitmap_read(msr_bitmap, msr);
> -
> -	if (type & MSR_TYPE_W)
> -		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
>  }
>  
>  void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>




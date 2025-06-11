Return-Path: <kvm+bounces-48956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C76AD48C0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8D413A2E32
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B407A183098;
	Wed, 11 Jun 2025 02:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWTckdSf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8733E7;
	Wed, 11 Jun 2025 02:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749608194; cv=none; b=f6vTNve6h9oHitwpZyvURMaWPAWbnPH8XpvlQ1ZCCKy33ob1AAPP1wnFa5WgSd7GpOVIcP/SmUoRd9daFzxfD257zCwbu7sByg+qzEw4WoMlhyx7tO/ZDzUsxTWNdhGSFPgq4QsF+2Sukf3TavjX6lzYCfapOvQg2GHLE7lTUAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749608194; c=relaxed/simple;
	bh=mTHqiAgZeMLtBCLvmwMu/fW5j0K8s3oC04d1lP7v9t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3qLv8oJT0i5Dca65psBq/a105jpuf1bTZ8Chia4/tCGxCO8RpMEZrRM0SSXpYvRRuDGMM3UghyiD/mWC2NR7iMETuHDPxONqq4LLqgC9EtrVk44hRaqzwUKoKMlJUxSqu88fuFGIQHSsVjscOr4E877+s9Vxyiu3cMrWKrsXYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWTckdSf; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749608194; x=1781144194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mTHqiAgZeMLtBCLvmwMu/fW5j0K8s3oC04d1lP7v9t0=;
  b=QWTckdSf0+zTpXSMoMDw4yCt5FYXUtYcnaFuHYMwmBvqgj/lJGxMUmio
   jASq30uNtXczfZZJ4bAjz0QQqrq7VUETs4z0wVKaU74uOTCWkqeL9wRWa
   eBDjiiadtpgVgI6EQ2RxjVkPhw9XFo7cHRRi74ViditLobbL9p4zDV/6g
   JtxAmuhY9LzthwEQuGkQzFQtROGc+Y2zThgJJtxHXa4BMl2elU4v8G2KW
   Y55KiFwqDQhHnLiSaz1yPfHBL9uaD+7/Wi2+2YkuXUCAcnDsoXEa3aH+k
   oXI0I6uQ0E7kdNPg5hhCfeZvckBNni3ET+LVyMecyUS85Q24jZ742JrQv
   w==;
X-CSE-ConnectionGUID: HJ3hl2rVSAOIdjyrCVqoEg==
X-CSE-MsgGUID: 7pSLSYHxT/inQLw2NBgb/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62354193"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="62354193"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:16:33 -0700
X-CSE-ConnectionGUID: /DF9WnH4SEqSye6N3INR8g==
X-CSE-MsgGUID: GU6JoQ0mRr6Tmd9QnwaJ2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="146940889"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:16:30 -0700
Message-ID: <b70b6803-b12b-420f-8a96-8cb0936773da@linux.intel.com>
Date: Wed, 11 Jun 2025 10:16:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/32] KVM: SVM: Kill the VM instead of the host if MSR
 interception is buggy
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-7-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250610225737.156318-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> WARN and kill the VM instead of panicking the host if KVM attempts to set
> or query MSR interception for an unsupported MSR.  Accessing the MSR
> interception bitmaps only meaningfully affects post-VMRUN behavior, and
> KVM_BUG_ON() is guaranteed to prevent the current vCPU from doing VMRUN,
> i.e. there is no need to panic the entire host.
>
> Opportunistically move the sanity checks about their use to index into the
> MSRPM, e.g. so that bugs only WARN and terminate the VM, as opposed to
> doing that _and_ generating an out-of-bounds load.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c75977ca600b..7e39b9df61f1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -824,11 +824,12 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
>  				      to_svm(vcpu)->msrpm;
>  
>  	offset    = svm_msrpm_offset(msr);
> +	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
> +		return false;
> +
>  	bit_write = 2 * (msr & 0x0f) + 1;
>  	tmp       = msrpm[offset];
>  
> -	BUG_ON(offset == MSR_INVALID);
> -
>  	return test_bit(bit_write, &tmp);
>  }
>  
> @@ -854,12 +855,13 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
>  		write = 0;
>  
>  	offset    = svm_msrpm_offset(msr);
> +	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
> +		return;
> +
>  	bit_read  = 2 * (msr & 0x0f);
>  	bit_write = 2 * (msr & 0x0f) + 1;
>  	tmp       = msrpm[offset];
>  
> -	BUG_ON(offset == MSR_INVALID);
> -
>  	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
>  	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>




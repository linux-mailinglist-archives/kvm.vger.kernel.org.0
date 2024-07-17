Return-Path: <kvm+bounces-21773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3CA933DA3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 15:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C056DB21733
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 13:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B35313AF2;
	Wed, 17 Jul 2024 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2pDIpxC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC28B566A;
	Wed, 17 Jul 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223071; cv=none; b=KzGFFwogiaQunxAbFIKprnea4LxSrR4aEAVodY+vYo13edOzpRHZzjsFHPCfG314VBJj/aeE4sE5HmT5F+0p7hzqQASw48+DwTYJHVO0LpfJpUx6U8cNwKJYiEeq20b1p3DGa3ocG0lWq5cmVZ3nHWJB+F6wY6pLAGUPzrTBzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223071; c=relaxed/simple;
	bh=9/LX+FPC7nXVipMC+1Tbxx41tWTkMEJcT3a+DLYqWq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FOc8cu8gHfGGYGYxVdFi5TLtOEY2bhTt3T8OA8cPPcpyIioKGecpNwwYDLcDvSOVScTtfo4NyjcdjvqZ5HJOIOUnJN8xse5si+tgvl0DIpeT7gAq7AfJ5fft7tnJZxyiJhukF/mYVJvUfXmGHgjxZhi2ec3ALQd47O2fNmQqxtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2pDIpxC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721223070; x=1752759070;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9/LX+FPC7nXVipMC+1Tbxx41tWTkMEJcT3a+DLYqWq0=;
  b=I2pDIpxC+Oe3tX49f1r1dfTW7TMq7cvkeS3gkR4y5+8aanzk57DcAYsa
   8m7uAcFwa0Mspo4sWp4wmqoa6AayfWKBQYFbZpqXWyaMlqzSwWg2hhrdn
   mbFXAxZ0ynJokNQLaztJzKkGLEHvYsLD8IhxsnbqcaU12Jhlttg+Fm9Hw
   +zoD0Mcn7wmI2S+H+5/RJobXj8pFWfwUDs5nFsentBpoI3IehPdBE8GI1
   tN8qFJFk0Gbv0wtKxuG+y6sbCFqHQFdnMdqFRa8mUVw7F8zx82pK/41LQ
   y2jfb615xJcnH/RMwFCjRmfQ4tbfr5Ug1BFfeIy7l8jTnXuiGkDm9zdVE
   Q==;
X-CSE-ConnectionGUID: NiQp7ZP5TFORlfpUgnV7CQ==
X-CSE-MsgGUID: Qxx9hkrQRC61rwtriiqOEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="29394816"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="29394816"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 06:31:09 -0700
X-CSE-ConnectionGUID: aeF2PvNdTgmFzVErDR5kvQ==
X-CSE-MsgGUID: BneAubfwT9+zUrpvrlYoVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50266393"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.247.52]) ([10.125.247.52])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 06:31:05 -0700
Message-ID: <8c783615-1e79-471d-b853-d654696fb782@intel.com>
Date: Wed, 17 Jul 2024 21:31:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/49] KVM: x86: Add a macro to init CPUID features
 that are 64-bit only
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-22-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240517173926.965351-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> Add a macro to mask-in feature flags that are supported only on 64-bit
> kernels/KVM.  In addition to reducing overall #ifdeffery, using a macro
> will allow hardening the kvm_cpu_cap initialization sequences to assert
> that the features being advertised are indeed included in the word being
> initialized.  And arguably using *F() macros through is more readable.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Very nice patch!

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5a4d6138c4f1..5e3b97d06374 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -70,6 +70,12 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
>   })
>   
> +/* Features that KVM supports only on 64-bit kernels. */
> +#define X86_64_F(name)						\
> +({								\
> +	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
> +})
> +
>   /*
>    * Raw Feature - For features that KVM supports based purely on raw host CPUID,
>    * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> @@ -639,15 +645,6 @@ static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
>   
>   void kvm_set_cpu_caps(void)
>   {
> -#ifdef CONFIG_X86_64
> -	unsigned int f_gbpages = F(GBPAGES);
> -	unsigned int f_lm = F(LM);
> -	unsigned int f_xfd = F(XFD);
> -#else
> -	unsigned int f_gbpages = 0;
> -	unsigned int f_lm = 0;
> -	unsigned int f_xfd = 0;
> -#endif
>   	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
>   
>   	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
> @@ -744,7 +741,8 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_init(CPUID_D_1_EAX,
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) |
> +		X86_64_F(XFD)
>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
> @@ -766,8 +764,8 @@ void kvm_set_cpu_caps(void)
>   		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
>   		F(PAT) | F(PSE36) | 0 /* Reserved */ |
>   		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> -		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
> -		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
> +		F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> +		0 /* Reserved */ | X86_64_F(LM) | F(3DNOWEXT) | F(3DNOW)
>   	);
>   
>   	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))



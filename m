Return-Path: <kvm+bounces-24051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86DD6950BA9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC3281C223BD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283BD1A38F0;
	Tue, 13 Aug 2024 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MlmiQi1L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689D31BC5C;
	Tue, 13 Aug 2024 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723571404; cv=none; b=TI21wI6gbk1WbZeMmpRdv1pgRNPPy5pe3VtTMuqvhF3BpSrPQcnDE8K8RPINkOIbUPXqYi2HRZgLOV4jce79LpHVRFBJB3KmJDoahaTPaUnm+EYUQ5L7S0dTOOku8HhsxXJAQNJYKyuG/vjWdbSFYUrL/QxO7Yc4rRffJWqGYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723571404; c=relaxed/simple;
	bh=XzbYAIp3lQcaq+GfhOMnTfpycXFbTS5bp+jiqzQktNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZ6GYKqCz18segdMKFU94WbfuIzgXuvtjzOKIvbXM2MZXKlDFRLMszrDdP4YbUC6yao4kdwAsqbwbTlGIUw7c3d40YmWfKBt5H1Lb6/E5d6SbS8fynW6CEkfvEYzFNaohDZwZvWrmdwUHAx6BpxVwlBpgMa63oYrsCi921Ry5r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MlmiQi1L; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723571402; x=1755107402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XzbYAIp3lQcaq+GfhOMnTfpycXFbTS5bp+jiqzQktNA=;
  b=MlmiQi1L+SNHQDSNwN1UHonVmH4L0MBacMdqH/VmBxDIm7mZACgSNlbj
   mKqg0mpxAQDGEV9mFTTso2iXh4FQ/keiYxRkiRwlGzBwPZp5rJVHbeW17
   jb+ISDK3TFmb05uXCwLqTQVirBGvhkRILhNtF2MM/krR8WTvmVSvwoPaP
   /D5iPlWXXMUAkwjR5AqB2n0kga8LwU8J8nmhDj+SGamX/G5XtrTuBkjZl
   7A/SJ+CqihGnBbTAvlqmlRDBFuHSOo5ByBnceWPsbfT978MDhuCyhh4vQ
   5leGZrRoCaGml+If8G0v9IqKr+eBms+/v/hL4/bqKAw37EnLXq2FY3kyq
   w==;
X-CSE-ConnectionGUID: ajyTPi1OTfGaptTniprU6Q==
X-CSE-MsgGUID: H5uePrOhRpC3S+Xusp3Qww==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32369938"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="32369938"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:50:01 -0700
X-CSE-ConnectionGUID: m4Of+yp7Q8mfF4ezLs4OxQ==
X-CSE-MsgGUID: FhuuWwUwRU6enAF0vWqL+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="63594774"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:50:02 -0700
Date: Tue, 13 Aug 2024 10:50:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240813051256.2246612-2-binbin.wu@linux.intel.com>

On Tue, Aug 13, 2024 at 01:12:55PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> Check whether a KVM hypercall needs to exit to userspace or not based on
> hypercall_exit_enabled field of struct kvm_arch.
> 
> Userspace can request a hypercall to exit to userspace for handling by
> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> hypercall_exit_enabled.  Make the check code generic based on it.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  arch/x86/kvm/x86.h | 7 +++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..6e16c9751af7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	cpl = kvm_x86_call(get_cpl)(vcpu);
>  
>  	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> +		/* The hypercall is requested to exit to userspace. */
>  		return 0;
>  
>  	if (!op_64_bit)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 50596f6f8320..0cbec76b42e6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
> +{
> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
> +		return false;

Is this to detect potential bug? Maybe
BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
             !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
Overkill?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


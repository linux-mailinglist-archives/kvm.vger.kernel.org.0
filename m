Return-Path: <kvm+bounces-65190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A76E1C9E0FE
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 08:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 218C7344401
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 07:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC80C29BDA4;
	Wed,  3 Dec 2025 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9dHk/zk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AD220F47
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747349; cv=none; b=asA+33fxYgmmC6TYdLoGNpFt6rhAZeKYP2fOQBaRF9o1MS6Std6tpFWleQjZLJnWQ79Y1g1MiwPqlGsxhvuYNqksWOJDUnvLKOXt1e7QFABV26Wc8yPx6zq//ISvkQCmq5oYIE8D6L8GD5yvFaN97Mro9Mk2gVWabMLj5JckySA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747349; c=relaxed/simple;
	bh=uPkdQERsIUHqaNGhdud8roMEQ1jbCQGL7Ej6X/cSmgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3VYAPokx93cHc6DZSkc8hOaKVTRuCTm2IaQYyNoLGviL+B7BB9kCX18Zy9dcimkgE2qHsfHc9VHKgQc7LKEUVsh4uR/tWXy/JE89dhbLtszCxMWYhNwOJzcnG0S2G8ODdswQrlYaftlC7f8hoZccInqWXlASBrIt1jIxDCM3lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9dHk/zk; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764747347; x=1796283347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uPkdQERsIUHqaNGhdud8roMEQ1jbCQGL7Ej6X/cSmgs=;
  b=F9dHk/zkGPB15MQPOq92RyvP8vum5wZm+JY1AxzmfLI29kj5IB1oOkFl
   mBVo3KfQsOh6FKtRFzp4hzlcVLnAc7VlN+6CtcApwBct9EXTElEE4pKkF
   6yX1NkA6mZS/JKBVSbOsN/K7pK+NlXvtbxZIHry58oWsDmA5B/1GeX3F0
   1x2UbpIjzT+7freL/pwfnP3cfkDcuJdTOazaLtY5wJjS2q4/yOwEgr8jm
   9uiSruqwm6DEAV6l7Et85LS68VwrUlxNyAPOCDemoX4WcEQePJRUBK4kM
   0C+jLsLoMHUh/oGlLwroLpT4uiVy7hzrAjUKjZwFb0DqFQXpym2haNB6M
   A==;
X-CSE-ConnectionGUID: hIdsyWQhSZGOzZkInpMQCw==
X-CSE-MsgGUID: x+YR0FR6TZyoeTbyMHlqpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="65734507"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="65734507"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 23:35:46 -0800
X-CSE-ConnectionGUID: 6mrCZqXsSJq1NlqrqoQD7A==
X-CSE-MsgGUID: JaWz9ufsR5qI4BE4ureL1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="194280649"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 02 Dec 2025 23:35:43 -0800
Date: Wed, 3 Dec 2025 16:00:26 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 06/23] i386/kvm: Initialize x86_ext_save_areas[] based
 on KVM support
Message-ID: <aS/uGsU39/ZbXDij@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
 <20251118034231.704240-7-zhao1.liu@intel.com>
 <5675fe47-f8ca-468a-abb6-449c88030a5f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5675fe47-f8ca-468a-abb6-449c88030a5f@redhat.com>

Hi Paolo,

> > +        /*
> > +         * AMX xstates are supported in KVM_GET_SUPPORTED_CPUID only when
> > +         * XSTATE_XTILE_DATA_MASK gets guest permission in
> > +         * kvm_request_xsave_components().
> > +         */
> > +        if (!((1 << i) & XSTATE_XTILE_MASK)) {
> 
> This should be XSTATE_DYNAMIC_MASK, 

XSTATE_DYNAMIC_MASK covers both XSTATE_XTILE_DATA_MASK and
XSTATE_XTILE_CFG_MASK, and XSTATE_DYNAMIC_MASK only has
XSTATE_XTILE_DATA_MASK.

On KVM side, kvm_get_filtered_xcr0() will mask off XTILE_CFG if
XTILE_DATA is filtered out.

So from this KVM logic, at current point, getting XTILE_CFG information
seems meaningless. Therefore I skip both XTILE_DATA and XTILE_CFG.

> but I don't like getting the information differently.  My understanding is
> that this is useful for the next patch, but I don't understand well why
> the next patch is needed. The commit message doesn't help.

My bad, my commit messages are not orginized well. Both patch 6 & 7 are
serving patch 8. Please let me explain in detail:

* In 0xD encoding, Arch LBR is checked specially, that's not needed.
  Before 0xD encoding, any dependencies check should be done. So there's
  patch 8 to drop such special check for Arch LBR.

  But there're 2 differences should be clarified before patch 8.

  - Arch LBR xstate CPUID is filled by x86_cpu_get_supported_cpuid(),
    and other xstates in 0xD is filled based on x86_ext_save_areas[].

    Ideally, all xstates CPUIDs should be from x86_ext_save_areas[] and
    x86_ext_save_areas[] is initialized by accelerators.

    So there's patch 7 to make ARCH LBR also use x86_ext_save_areas[] to
    encode its CPUID.

  - Arch LBR gets its xstate information by
    x86_cpu_get_supported_cpuid(), and other xstates (for KVM) in the
    x86_ext_save_areas[] are initialized by host_cpuid().

    I think this is a confusion. QEMU KVM doesn't need to use
    host_cpuid() to get xstates information. In fact, it should get this
    from KVM's get_cpuid ioctl (although KVM also use host info directly),
    just like HVF does.

    So this is what patch 6 does - avoid using host_cpuid as much as
    possible. For AMX states that require dynamic permission acquisition,
    since memory allocation is involved, I think it also makes sense to
    continue using host_cpuid().

The changes in patches 6~8 are rather trivial, mainly to address the
comments from the previous version... such as whether such replacements
(in patch 8) would change functionality, etc. So, in this version I'm
doing it step by step.

> Can you move the call to kvm_cpu_xsave_init() after
> x86_cpu_enable_xsave_components()?  Is it used anywhere before the CPU is
> running?

Yes, this is an "ugly" palce. I did not fully defer the initialization
of the xstate array earlier also because I observed that both HVF and
TCG have similar xsave initialization interfaces within their accelerator's
cpu_instance_init() function.

I think it might be better to do the same thing for HVF & TCG as well
(i.e., defer xstate initialization). Otherwise, if we only modify QEMU
KVM logic, it looks a bit fragmented... What do you think?

Thanks for your patience,
Zhao



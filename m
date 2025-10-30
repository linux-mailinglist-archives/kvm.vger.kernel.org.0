Return-Path: <kvm+bounces-61486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55256C20F9D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CB801894335
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026853644BD;
	Thu, 30 Oct 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NDeWFIkv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7C8F6F
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838485; cv=none; b=YFNqk5Br4eS5ajQ8vKG9XtWOVvV5f0bnevqImR6ZvWBZ/AZm6Qgy3CLEvvz2RtFXshxxOOrpMU3yK32IigYFO7voEdJtvV/cVis15/1F9vn3vb2sx94mTDyx3TWuuguQrhunUo/Yz2+3Mpa3BSL/8dIxwVA6WKtWxQ5OSDGRSI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838485; c=relaxed/simple;
	bh=pTXcdRYSjHNynWIEVGm+EuBIpQGZF5os4FAc1lkATuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPsi4VaG69qZzXDIz3z7nvMjOdM113geoQuBYG882T7vv8KkPoZ/RwmEg33odaYT0Nr4KjA0iQBG2DJt1S/FaeIF9clAcl6BW59b4kjo1cxc4lsNp/ajkJSYWR/hNBxzzJJUXQTPBmZTt1bthIB4UB8CVzlrCzya4cRDrMdirVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NDeWFIkv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761838483; x=1793374483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pTXcdRYSjHNynWIEVGm+EuBIpQGZF5os4FAc1lkATuA=;
  b=NDeWFIkvMEjolpSSH2jSJ48JHfLSdZrUQS8zgNsdXUz3wFO3h+pT96se
   42N8/rHao1Oh8uMoI8V4HdXBt+WV6YwEhV9zVRoX3sNgjeAC+U5xBhBia
   K2vRikqkMG6R8e4cNXKtDGY86YEPx1vosF7Zm6l4KUUPVDO3aTUzgAHL4
   ioqDi6sVY1Zv1iDQe0qNu9G5LbbpGHg7Ho7X1+D/FZHVArd/4LM/mLcXt
   vc3gwb8Qrnm/i79cMHUBJJIRDIHQ6ZxyGRbfbC+azFuupivrkCVxcg5wJ
   4AmFYPN0nMaqbuydonSKvqxufdvMZdyu2ayt8LC4w/ePSsZK1ZLuIy+9V
   g==;
X-CSE-ConnectionGUID: tys8EMiPQBeEuRAm38LWCQ==
X-CSE-MsgGUID: 5L+r8buGTkuiAWH3jr+y+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75434223"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="75434223"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:34:43 -0700
X-CSE-ConnectionGUID: uzvbaQXaQ6mQTiMiVQeviw==
X-CSE-MsgGUID: ATGxoKK+Rlu5bT0pnZOVBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="223203672"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2025 08:34:41 -0700
Date: Thu, 30 Oct 2025 23:56:51 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
Message-ID: <aQOKw/2lxg/EjyDY@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
 <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com>
 <aP9HPKwHPcOlBTwm@intel.com>
 <aP9VF7FkfGeY6B+Q@intel.com>
 <308bcfcd-6c43-4530-8ba7-8a2d8a7b0c8f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <308bcfcd-6c43-4530-8ba7-8a2d8a7b0c8f@intel.com>

> can you elaborate what will be broken without the patch?

Obviously, the migratable_flags has been broken.

> As I commented earlier, though the .migrable_flags determines the return
> value of x86_cpu_get_supported_feature_word() for
> features[FEAT_XSAVE_XCR0_LO] in x86_cpu_expand_features(), eventually the
> x86_cpu_enable_xsave_components() overwrites features[FEAT_XSAVE_XCR0_LO].
> So even we set the migratable_flags to 0 for FEAT_XSAVE_XCR0_LO, it doesn't
> have any issue.

No. this seemingly 'correct' result what you see is just due to
different bugs influencing each other: the flags are wrong, the code
path is wrong, and the impact produced by the flags is also wrong.

> So I think we can remove migratable_flags totally.

migratable_flags is used for feature leaves that are non-migratable by
default, while unmigratable_flags is used for feature leaves that are
migratable by default. Simply removing it doesn't need much effort, but
additional clarification is needed - about whether and how it affects
the migratable/unmigratable feature setting. Therefore, it's better to
do such refactor in the separate thread rather than combining it with
CET for now.

Regards,
Zhao




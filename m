Return-Path: <kvm+bounces-65744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A54CB5478
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8945B3001632
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EE9302CDC;
	Thu, 11 Dec 2025 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M5DCcX2t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C60A302CB9
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765443131; cv=none; b=iK30gMV7BY95+KMEin5JneJ041Jz+Uc1EKp+GHNVJKxfW141RzqJcnJeMRup0IowXYAGYBLq1RI3p6E4xbyr3F2z0lH5BQ9vHkFaz9jhkD93FZYOkznIrNo+OIvLNRPuiuREacZS37C85pQdj1yG6txvxD7L86BTRtgfCjvrEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765443131; c=relaxed/simple;
	bh=47CtsqOCElRhQmwQBHGB+RMzeDpuMiMvxyN/PDZE120=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxuSuQVpJJrc2b8zS1d5w3m2lIHH7MjAw9SqZwU52KQkPOEUiks3Fs9y+UgNy5wfjnN3ppuQgG/QeiXGYvxsOff2eUryNg05Cl43dcsk+aDUN0xlaYPiclyguv/o3su7SKDX+fCGIpfZPaJol4lyuih3nIGRZYFN8F4hhQQou54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M5DCcX2t; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765443130; x=1796979130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=47CtsqOCElRhQmwQBHGB+RMzeDpuMiMvxyN/PDZE120=;
  b=M5DCcX2tnq1un7rYHAHLKzVcv3C0u4m3Q9CaYEFK6ZparsheFcL0wZ0o
   NqQGLXf3zl4eeHqHFdICg9aIeN2HWOf9aguNnoTRLSySC9XK9i4NnqnoJ
   tOQjMEU3QnwtjmmkTmbGgdCMK3OWZCrKJDKvth9qLEt9IHUo9rymul5vZ
   Ak88jxQ3ZAb8tBP1dNbaGEtDcYmlFhXPZf6/9Xwkulum1hu+RdqLqsIz7
   2cR3h+8NN8a7rPrDQwHNq8yZF3EA8UYXKfSVUqiHNLsEmAzwhtC0EnU2d
   8M1x+UdDVhQZiuN8tjAGSem2+b6/4/nV1lfQaEkux0vi24RNj+7dfAiMk
   w==;
X-CSE-ConnectionGUID: bN0V/n6ESWugNVmtrnCANA==
X-CSE-MsgGUID: hcbnFYJhS4id8H1BI24MDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="78040207"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="78040207"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 00:52:10 -0800
X-CSE-ConnectionGUID: /V9HF3OLSmCSmmHQwhc3Qg==
X-CSE-MsgGUID: X3anHFyqQiSYQddwcOI5iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196757073"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 11 Dec 2025 00:52:07 -0800
Date: Thu, 11 Dec 2025 17:16:54 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH v2 0/9] i386/cpu: Support APX for KVM
Message-ID: <aTqMBtkOxx6mZhn+@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
 <16e0fc49-0cdf-4e54-b692-5f58e18c747b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16e0fc49-0cdf-4e54-b692-5f58e18c747b@redhat.com>

On Thu, Dec 11, 2025 at 09:08:33AM +0100, Paolo Bonzini wrote:
> Date: Thu, 11 Dec 2025 09:08:33 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v2 0/9] i386/cpu: Support APX for KVM
> 
> On 12/11/25 08:09, Zhao Liu wrote:
> > Hi,
> > 
> > This series adds APX (Advanced Performance Extensions) support in QEMU
> > to enable APX in Guest based on KVM (RFC v1 [1]).
> > 
> > This series is based on CET v5:
> > 
> > https://lore.kernel.org/qemu-devel/20251211060801.3600039-1-zhao1.liu@intel.com/
> > 
> > And you can also find the code here:
> > 
> > https://gitlab.com/zhao.liu/qemu/-/commits/i386-all-for-dmr-v2.1-12-10-2025
> > 
> > Compared with v1 [2], v2 adds:
> >   * HMP support ("print" & "info registers").
> >   * gdbstub support.
> > 
> > Thanks for your review!
> 
> Great, thanks!  Just one question, should the CPUID feature be "apx" or
> "apxf" (and therefore CPUID_7_1_EDX_APXF)?  I can fix that myself of course.

Good point! I didn't realize this.

1) Per APX spec:

(APX adds) CPUID Enumeration for APX_F (APX Foundation).

2) And gcc also use apx_f:

https://codebrowser.dev/gcc/gcc/config/i386/cpuid.h.html#_M/bit_APX_F

3) ...and we already have "avx512f".

So you're right, I should use "apxf" and CPUID_7_1_EDX_APXF.

Since APX CPUID appears in several patches, I can respin a new version
quickly.

Thanks,
Zhao




Return-Path: <kvm+bounces-61153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C75EC0D079
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52320401808
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC952F693A;
	Mon, 27 Oct 2025 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="inNcgSxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448722F12CE
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761562603; cv=none; b=AqM3/HWdiHTpqHbFaPoxJC/DmJProkrqWUluqSKDV/DF8MNgT2gRqw/7glO2NeTLR6kaUvGo4/igpcw3wzrs5DEJhzSJK38P3xsTKs1S3x7Y2qrUYho1kQXTlyB/nn8I0yrKOhG3Dv4MXTSaVNiciDlN1NCXgaqj5cQZ+t66cBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761562603; c=relaxed/simple;
	bh=tBi0DDOGa1sTaTA9yS+f/khOO57uDsMBL7lkmcWwF84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbLLv9cmdE046fr3WF282D7MVOw3XrqPtXw0Q+Bvjy8J/7ZIqZXU2XOWEWdjf/Lfxpx9bb1MxGFKIaWq3a1jjBAQ1lX0daRc3uxLfuCHK4asP7Wu14qDsLu2TZ5WW1UX53csO+HSiJ7jXDJ6EdzcVUnayfgK6ppe6o18MwCLOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=inNcgSxV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761562601; x=1793098601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=tBi0DDOGa1sTaTA9yS+f/khOO57uDsMBL7lkmcWwF84=;
  b=inNcgSxVDvNqQH/L6NqZkKxBmwGBWdq2IAQCHSBcCOntikea3WKastU3
   NHVyOTYo4KMYAeVp/ngLrzsVcBLeS7H1xSmSNvue65DWuewZLxvEsB1qg
   zLHRh7sRaoGrnLbwAvazlEdjo9fKIK52oAMQfXhPiEgpWbfKyvd1I4WpZ
   iH0MkuF4aptM7p0ai5lnGYYGPBuELHkcqlsgSK/nfgqI2Ja5z2IOgERaO
   iUPDOhQbnmQzhx67GMdsalwm6/KL0W72QSjf63LVeUZLckJtvPfDAuoKi
   VyScaE4eyp33fXc0mZmxH0oXSpAr7gKq4lESnlGLb7Td/6hnAj1DAWsfI
   A==;
X-CSE-ConnectionGUID: QQpn33vRTByUJlLBDi77Gg==
X-CSE-MsgGUID: U2LBh7yBRT6NJUvGlLBNaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62844744"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="62844744"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 03:56:40 -0700
X-CSE-ConnectionGUID: C0KV7ngJTDyAD1zQ6vTykQ==
X-CSE-MsgGUID: 73+ArOTiRlu8W1oS+/dCIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="222224397"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 27 Oct 2025 03:56:37 -0700
Date: Mon, 27 Oct 2025 19:18:47 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
Message-ID: <aP9VF7FkfGeY6B+Q@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
 <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com>
 <aP9HPKwHPcOlBTwm@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aP9HPKwHPcOlBTwm@intel.com>

On Mon, Oct 27, 2025 at 06:19:40PM +0800, Zhao Liu wrote:
> Date: Mon, 27 Oct 2025 18:19:40 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave
>  features
> 
> > Though the feature expansion in x86_cpu_expand_features() under
> > 
> > 	if (xcc->max_features) {
> > 		...
> > 	}
> > 
> > only enables migratable features when cpu->migratable is true,
> > x86_cpu_enable_xsave_components() overwrite the value later.
> 
> I have not changed the related logic, and this was intentional...too,
> which is planed to be cleaned up after CET.

There's only 1 use case of migratable_flags, so I would try to drop
it directly.

The xsave-managed/enabled feature is not suitable as the configurable
feature. Therefore, it is best to keep it non-configurable as it is
currently.

At least with this fix, the support for the new xsave feature —
including APX next — will not be broken, and the migratable flag
refactoring will become a separate RFC.

Regards,
Zhao



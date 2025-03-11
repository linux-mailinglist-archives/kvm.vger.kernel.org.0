Return-Path: <kvm+bounces-40769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBDEDA5C2B9
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 14:31:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A3B1171B7D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 13:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BE51C1F2F;
	Tue, 11 Mar 2025 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cm4+W07W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32485680
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 13:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741699869; cv=none; b=QkLm3h2Zrpgf5AjVWw3+TfdHGMfra0dfKSTn+4TdkhcoqaFu0zHF08uNcBGicTyY4OEFbZbMnPczsxpqG/MazvqOCxShf7kZYaIVgBycrbTn0mSPCmail6UzroEc7uG7BaX+Wx3kpv1cL+adOiIaSyP5F12AzMNbYDD4LtIBhj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741699869; c=relaxed/simple;
	bh=1KOmzmrSwiEXReJq2LterO9F8yh62frqUd0TRpdbQtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzZB32lZiYX2EiTwEB9ypXn4rp4i0I2eYMGkg+3JhuRhcEyWOsZM5S1rUWCKwoOGyeeEzvtR6fY8SlcNlOO1LOffMVTPc3H1FvA4f291kUreI1KLPsflXRCEaNwYbVqm1hc2/0k6ZmjWa7i+/yLBpZc944QSOF42tM2rzduR+d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cm4+W07W; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741699868; x=1773235868;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1KOmzmrSwiEXReJq2LterO9F8yh62frqUd0TRpdbQtI=;
  b=cm4+W07WNW6orlrPJ7QiFDQM+x6GIOQTFtTFTqbNDAiGl5xB15YcYSi1
   JgX8Jr91EgnfBJfKQCQUZ9Fhz9JyDlUX2y2bQW+itlf1ewgEMU2IykyHs
   bivd1QkkhM/IZEXVlg25YnKbDy3UgPWkq44V7d1jcUbSi7cCRrUz1gkAY
   vgz25mhD+feEp6cmOOfRe42F4t0HcsLavImgiPWHCcIm6WMP6YF/MuZhU
   5X8v+NYVHdSlpGaZOX6zJ5/RMCDKpGl/Rej4db5OFM0FB24RZwrlcq5VN
   IxyrMYH+Rn3OOIcYjqhGTs2gdnwUoAV2HNwjFoiF5Z5rr2hmfvkY3WlJ5
   Q==;
X-CSE-ConnectionGUID: 1w/3N/7WRaS1fqbnPmaguQ==
X-CSE-MsgGUID: RACpNInRRoy49aUrdIq2TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="42648515"
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="42648515"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 06:31:08 -0700
X-CSE-ConnectionGUID: Pxk/4SkhTnK69gTC0YQDKw==
X-CSE-MsgGUID: VME4DSeXRry7yMJ+/JsIZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="120814359"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 11 Mar 2025 06:31:03 -0700
Date: Tue, 11 Mar 2025 21:51:13 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <Z9A/0RE2Zc7BKDvD@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <Z86Y9BxV6p25A2Wo@intel.com>
 <a52ad0b9-4760-4347-ad73-1690eb28a464@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a52ad0b9-4760-4347-ad73-1690eb28a464@oracle.com>

Hi Dongli,

> >> +    /*
> >> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> >> +     * disable the AMD pmu virtualization.
> >> +     *
> >> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
> >> +     * indicates the KVM has already disabled the PMU virtualization.
> >> +     */
> >> +    if (has_pmu_cap && !cpu->enable_pmu) {
> >> +        return;
> >> +    }
> > 
> > Could we only check "cpu->enable_pmu" at the beginning of this function?
> > then if pmu is already disabled, we don't need to initialize the pmu info.
> 
> I don't think so. There is a case:
> 
> - cpu->enable_pmu = false. (That is, "-cpu host,-pmu").
> - But for KVM prior v5.18 that KVM_CAP_PMU_CAPABILITY doesn't exist.
> 
> There is no way to disable vPMU. To determine based on only
> "!cpu->enable_pmu" doesn't work.

Ah, I didn't get your point here. When QEMU user has already disabled
PMU, why we still need to continue initialize PMU info and save/load PMU
MSRs? In this case, user won't expect vPMU could work.

> It works only when "!cpu->enable_pmu" and KVM_CAP_PMU_CAPABILITY exists.
> 
> 
> We may still need a static global variable here to indicate where
> "kvm.enable_pmu=N" (as discussed in PATCH 07).
>
> > 
> >> +    if (IS_INTEL_CPU(env)) {
> > 
> > Zhaoxin also supports architectural PerfMon in 0xa.
> > 
> > I'm not sure if this check should also involve Zhaoxin CPU, so cc
> > zhaoxin guys for double check.
> 
> Sure for both here and below 'ditto'. Thank you very much!

Per the Linux commit 3a4ac121c2cac, Zhaoxin mostly follows Intel
Architectural PerfMon-v2. Afterall, before this patch, these PMU things
didn't check any vendor, so I suppose vPMU may could work for Zhaoxin as
well. Therefore, its' better to consider Zhaoxin when you check Intel
CPU, which can help avoid introducing some regressions.

Thanks,
Zhao



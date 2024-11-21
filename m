Return-Path: <kvm+bounces-32229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F3C9D4533
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 02:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C9CD1F22629
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 01:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D081F5E6;
	Thu, 21 Nov 2024 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CWC/INAu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310162FB6;
	Thu, 21 Nov 2024 01:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732151613; cv=none; b=MljUdhYOw2ZjQMxkvTSZ6itXzuWRyZmN/+0qq99eSc7Iz9Wz6pBndBjQBATcxbzDfVolfm7SZR7h11JPlp2JB3oXO4pySFrRmxkABoKd+Oz0tW6lNeWsZm36x8hW6kwuT6o5kLjoaHt9vCu769KXDGgoP2USSCrC6pZZEB2Bo+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732151613; c=relaxed/simple;
	bh=ICG+FxvrX5yibq/Mxg/BZXiLCG8EnXKd7MctmBYvpBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QT8yMalh2cyfb/m9I+L9NDg3YulqsHOovs+zymf8a4/Hi6p1KOvMdTedXe4Y1RTnw5dU4s/54SEFokiccR3hxMpdTT9DKDu698S4WUE+Ln7VJ1kFcgSLfvtGIFGgL3UmOIhuhgqAktN4dc+iOsDV5G2gR48kiQawABykKLuWr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CWC/INAu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732151612; x=1763687612;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ICG+FxvrX5yibq/Mxg/BZXiLCG8EnXKd7MctmBYvpBE=;
  b=CWC/INAuca+bZ5JdValLzghQxxnxH8ZisNkA9WyvwLNB8Fkz+kThhX5f
   wqGE4nGvxYPiDlPsvFgbcVQdduVORWtN7On9UdWpDRLt52xG8avxzOz0u
   XzMbcBIVzwVoll9/YGE2oM9kr4dPcnL+Uic0eiJ5ZytKLg8IGD67tvvUz
   pVpAbBnbR+hr/eOSk2iFnIZ/X1J1nyKYE5U0mEkznmU8Bt5Cg8/ykYERy
   VEFEqauLUFh8ibUvyJ3JQcR/ubcNwBOXS5fsVOYmMPfzlo9hU1QtUVMRQ
   kYDV/d0S8CokAyl3gQPu6oTFJjsDUtyiPFBd+1z888OYT0TQlF0nf3jHA
   g==;
X-CSE-ConnectionGUID: 7WrkrIPVSsaJ+9qdzKBr6w==
X-CSE-MsgGUID: VZ9p8UYsQX+IWt7ecItSZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="35100576"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="35100576"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 17:13:32 -0800
X-CSE-ConnectionGUID: oANH9ESQRCSHjPLW3W87gA==
X-CSE-MsgGUID: VW2equZkQ7iEMjuFOuK5Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="95035102"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 17:13:27 -0800
Message-ID: <43a93ac5-3503-444a-8b29-41996faf42df@linux.intel.com>
Date: Thu, 21 Nov 2024 09:13:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 38/58] KVM: x86/pmu: Exclude existing vLBR logic
 from the passthrough PMU
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-39-mizhang@google.com> <Zz4tsayQblkJUOtG@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4tsayQblkJUOtG@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/21/2024 2:42 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Excluding existing vLBR logic from the passthrough PMU because the it does
>> not support LBR related MSRs. So to avoid any side effect, do not call
>> vLBR related code in both vcpu_enter_guest() and pmi injection function.
> This is unnecessary.  PMU_CAP_LBR_FMT will be cleared in kvm_caps.supported_perf_cap
> when the mediated PMU is enabled, which will prevent relevant bits from being set
> in the vCPU's PERF_CAPABILITIES, and that in turn will ensure the number of LBR
> records is always zero.
Yes, that's true.

>
> If we wanted a sanity check, then it should go in intel_pmu_refresh().  But I don't
> think that's justified.  E.g. legacy LBRs are incompatible with arch LBRs.  At some
> point we have to rely on us not screwing up.
>
> A selftest for this though, that's a different story, but we already have coverage
> thanks to vmx_pmu_caps_test.c.  If we wanted to be paranoid, that test could be
> extended to assert that LBRs are unsupported if the mediated PMU is enabled.

we have already supported arch-LBR feature internally (still not sent to
upstream since the dependency) base on this mediated vPMU framework and we
would add a arch-LBR selftest.  It looks unnecessary to add temporary test
case and then remove it soon.

would drop this patch.




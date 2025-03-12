Return-Path: <kvm+bounces-40821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B06A5D7E3
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 09:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 616607AA776
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 08:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341C0231C8D;
	Wed, 12 Mar 2025 08:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UM5eNocP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D945230995
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 08:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741767001; cv=none; b=b0Ih5nPE7u3gx2lHCT7vcIqeJdVnglz/8YVw1fZffKTXTUvfWYErZhuoU0QGBMofWcC45NrywA6TiBltip7J0VZFrmlTrQkd98ijHtcznWLrwBDM+tZWlRoKUAATEvztnwg32Y1l5kTACmYOx/g0U42SkLJSELYBqRtc4O9C8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741767001; c=relaxed/simple;
	bh=Aej7uSydC5Ff1oCpTr2BwUDISjhUC3cOAX+PsKHMFrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toUaQPMPzVmZ0hwCdsVCqAPQsKkSCDa2tdC5UIMmwpDJQ10Ly7SuscEUUqW8GIwC2P+eusTqa0IMMcS7BKLJ4o+jYvi4O2Nfi4MQDwZhA2WmAhhCHa/TnRlKkOXN4fNKnWfHFqHfEaNNn+jZUJZXAY307XxsfQHT++GPgeC3SbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UM5eNocP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741767000; x=1773303000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Aej7uSydC5Ff1oCpTr2BwUDISjhUC3cOAX+PsKHMFrY=;
  b=UM5eNocPPTVNfatmFl4vKtnQhE/fvYXpzHKNJSO9Stkd8yuoj6CWQfPP
   9pB5JVEqwLX3fNv/cwG8rGoqp9N95AA1g1CurGLYFpCeRGHC9PG0TWP2K
   E7fJzGo3Xh/OAmxEnouB7jCooFo+JmhsNAIFK/HDX7C9dXZhbbQrb9p3v
   P0HB95PepWVB4CvvL3tjRvpXoqGUPGFbUAw5YtiR4heVXcjU1IfS06s1y
   PPWbANwQgF1u6N1V2RryQetWoYgtdbz6vLtiA39c3aAM2rTqxtUzcOFYb
   dFbdaTdQUI8BubVXF1oQox9rOdGyZWJH2Cy6fQhQNW6AHRoVUtqUx5A5T
   Q==;
X-CSE-ConnectionGUID: KZehYPznRQmV4lohnI3C3g==
X-CSE-MsgGUID: xK0C9cMHTBe1ALLRLxIhlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="42747311"
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="42747311"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 01:09:59 -0700
X-CSE-ConnectionGUID: E/C4qN+cQs6Actd9TlWwIA==
X-CSE-MsgGUID: /OVup4TCQuGeLwFECSscIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="125466778"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 12 Mar 2025 01:09:55 -0700
Date: Wed, 12 Mar 2025 16:30:05 +0800
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
Message-ID: <Z9FGDfzqimDo8SV5@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <Z86Y9BxV6p25A2Wo@intel.com>
 <a52ad0b9-4760-4347-ad73-1690eb28a464@oracle.com>
 <Z9A/0RE2Zc7BKDvD@intel.com>
 <976f58aa-5e14-4dda-ae07-f78276b54ff8@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976f58aa-5e14-4dda-ae07-f78276b54ff8@oracle.com>

> >>>> +    /*
> >>>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> >>>> +     * disable the AMD pmu virtualization.
> >>>> +     *
> >>>> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
> >>>> +     * indicates the KVM has already disabled the PMU virtualization.
> >>>> +     */
> >>>> +    if (has_pmu_cap && !cpu->enable_pmu) {
> >>>> +        return;
> >>>> +    }
> >>>
> >>> Could we only check "cpu->enable_pmu" at the beginning of this function?
> >>> then if pmu is already disabled, we don't need to initialize the pmu info.
> >>
> >> I don't think so. There is a case:
> >>
> >> - cpu->enable_pmu = false. (That is, "-cpu host,-pmu").
> >> - But for KVM prior v5.18 that KVM_CAP_PMU_CAPABILITY doesn't exist.
> >>
> >> There is no way to disable vPMU. To determine based on only
> >> "!cpu->enable_pmu" doesn't work.
> > 
> > Ah, I didn't get your point here. When QEMU user has already disabled
> > PMU, why we still need to continue initialize PMU info and save/load PMU
> > MSRs? In this case, user won't expect vPMU could work.
> 
> Yes, "In this case, user won't expect vPMU could work.".
> 
> But in reality vPMU is still active, although that doesn't match user's
> expectation.
> 
> User doesn't expect PMU to work. However, "perf stat" still works in VM
> (when KVM_CAP_PMU_CAPABILITY isn't available).
> 
> Would you suggest we only follow user's expectation?

Yes, for this case, many PMU related CPUIDs have already been disabled
because of "!enable_pmu", so IMO it's not necessary to handle other PMU
MSRs.

> That is, once user
> configure "-pmu", we are going to always assume vPMU is disabled, even it
> is still available (on KVM without KVM_CAP_PMU_CAPABILITY and prior v5.18)?

Strictly speaking, only the earlier AMD PMUs are still AVAILABLE at this
point, as the other platforms, have CPUIDs to indicate PMU enablement.
So for the latter (which I understand is most of the cases nowadays),
there's no reason to assume that the PMUs are still working when the CPUIDs
are corrupted...

There is no perfect solution for pre-v5.18 kernel... But while not breaking
compatibility, again IMO, we need the logic to be self-consistent, i.e.
any time the user does not enable vPMU (enable_pmu = false), it should be
assumed that vPMU does not work.

Thanks,
Zhao



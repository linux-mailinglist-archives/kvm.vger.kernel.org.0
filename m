Return-Path: <kvm+bounces-17075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A28078C0887
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:38:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2830FB21A35
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA911BC56;
	Thu,  9 May 2024 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdmoI4q3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B08E56C;
	Thu,  9 May 2024 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715215116; cv=none; b=hbpmNpI4KdYXJG8dLST94QKdJRSX3KiXL4ScWh6PiXiXYiZSwFYEN6D4VZEUG+r1GYdu/Hz66N31HfK/5D6a0q5obEvzPMm/Im79P51ZwUlOr5YiQXjn40tdja956gjMCIpdctM+NeRkaYgrwfLSd/2vEmz932TTANi/1U0CgJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715215116; c=relaxed/simple;
	bh=hUYsHkH1sS4bBFK1XdWftEQYBSuLHKbNbP4/Zfe7NX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mypmn+Jydk8LwdSGInsBdPYXpAk+xhZsgLXCrfox7v6BXdETghXCE8SULpJeyfpAcbxxi/8hgjmDSbFRgrWmND4d5uSLoUcj77g217Pl4BQqdgBTO5c1VZOf38w1315gdTOD3j1vQ/s1dR5horREU6d9lFnf0+VJP+fxvFsG2dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TdmoI4q3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715215115; x=1746751115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hUYsHkH1sS4bBFK1XdWftEQYBSuLHKbNbP4/Zfe7NX4=;
  b=TdmoI4q3OFlF7FoMQeIj4yfzNnpzl40B6DoaKiQ59WV4cI1suGEJLcdB
   nIxSYVPcHZBDjftABs5dtM3ld7KSsABKvB5Nww8JfMpntmKmlXM41On/e
   ooLZH/ir2fO3Y7v52z2dC8BLJK12Y13EUOGagZrcNV9MgesRZnD17Lybs
   rIrJV8qLmlbHwldXu57QeUeT5f/CnXMcr/7rtGDSWRH+ORdu+mTt21A4G
   DsOWst4j9smfVpsZnx/+UIyMk0NwrtcKWv80nNPdH1SRndV3sflYVaiqA
   hJSduN+dMX4aH+pkzcUtO/lhzCIR2Zkbeu2fTsAomvIam5Yj5FKtSRcW0
   w==;
X-CSE-ConnectionGUID: TQeSOuzJQl+BpzjCZhM30g==
X-CSE-MsgGUID: 52ypNYW0Qd+VuTHOQ6TpVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11268822"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="11268822"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:38:35 -0700
X-CSE-ConnectionGUID: NqYX7chIQ2axJii/U5a+8g==
X-CSE-MsgGUID: hNS2C4PbRSqr8B5vZbBn9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="33893819"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:38:28 -0700
Message-ID: <5b0292ed-c16a-4010-a7a8-23fe682cd5e1@linux.intel.com>
Date: Thu, 9 May 2024 08:38:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
 <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
 <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com>
 <ZjuIiDwbrWL7OD86@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZjuIiDwbrWL7OD86@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/8/2024 10:13 PM, Sean Christopherson wrote:
> On Wed, May 08, 2024, Dapeng Mi wrote:
>> On 5/8/2024 12:36 PM, Mingwei Zhang wrote:
>>> if (pmu->passthrough && pmu->nr_arch_gp_counters)
>>>
>>> Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
>>> v2 in AMD), once it is enabled (pmu->passthrough = true), then global
>>> ctrl _must_ exist phyiscally. Regardless of whether we expose it to
>>> the guest VM, at reset time, we need to ensure enabling bits for GP
>>> counters are set (behind the screen). This is critical for AMD, since
>>> most of the guests are usually in (AMD) PerfMon v1 in which global
>>> ctrl MSR is inaccessible, but does exist and is operating in HW.
>>>
>>> Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
>>> Intel / Perfmon v2 AMD), then this code will have to change. However,
>> Yeah, that's what I'm worrying about. We ever discussed to support mediated
>> vPMU on HW below perfmon v4. When someone implements this, he may not
>> notice this place needs to be changed as well, this introduces a potential
>> bug and we should avoid this.
> Just add a WARN on the PMU version.  I haven't thought much about whether or not
> KVM should support mediated PMU for earlier hardware, but having a sanity check
> on the assumptions of this code is reasonable even if we don't _plan_ on supporting
> earlier hardware.
I have no preference on whether supporting the old hardware (especially for
Intel CPUs below v4 which has no GLOBAL_STATUS_SET MSR), but I think the
key question is whether we want to totally drop the emulated vPMU after
mediated passthrough vPMU becomes mature. If so, we may have to support the
old platforms.


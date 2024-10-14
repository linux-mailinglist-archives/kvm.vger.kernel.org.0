Return-Path: <kvm+bounces-28776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC2A99D2EC
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE8BA1C22CA9
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12FF1B4F0A;
	Mon, 14 Oct 2024 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OiympIcq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6083F139D0B;
	Mon, 14 Oct 2024 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919716; cv=none; b=Om9IQhYRPnAiGYN5UDUi9du8fkjrYboWS35/lU2rcN/+3lv5xPs50L+fa1qvk2H9vFxjXJKSag94sRVow9/oHyK8mdOCApintj0Qa6Rpn5XnfX0v4z3YlIS/yiAiqzQe+5TCxN+uqaMXhrH+QDNrFPpgPJelC1YzHJdlYqyG/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919716; c=relaxed/simple;
	bh=tkXAamVskpR65XPj0Dxg0PnWNWD0shAYLS0n70P8WT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fr5h2b5iju4FEfvjmNzvdkoQhTpcHDle8SG+71XL9AXUQOgz2AEoN4p7SQ89Nubt6xio7YDcj0p3qocdXpX75wI4dkPs6BTyq6oqZEzLmrz8XFN3ja3Q2oHsc+AuGctQbIYBaIz7x2hxCGFROH3Hm7vwqRE0P2Rtt906Qx4Q/AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OiympIcq; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728919715; x=1760455715;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tkXAamVskpR65XPj0Dxg0PnWNWD0shAYLS0n70P8WT0=;
  b=OiympIcq85I48GPLQ27NouUPEjSlfslYMVn9Ec+rMzgOUmr46kZHpLyi
   VZ0U/6MY/Zn7UHjHZB2CzK1ZP6BvAlmDoGWmefgYUWHMh+WPhAR2yQN01
   BRtFks637kap82sS6KZuJhSMndMowla0VPetu+D/YrUpD5WroQOVj5CdY
   0eebhaRrEyH5fyEjSrudrdfUzb+GVTwh96hE+W246Pbevx7e56uMvkb0q
   6l7SpV7uedsR+LN6LjZFQaxKWbsMEHvjPfnuPptnWmt/Rt0RpxhidmE16
   FX5YqVM+0tEXH5GcJnEjnvKe3vhe0hKAhQQ7dgRfOC5uDJRZqwwDiRzYc
   Q==;
X-CSE-ConnectionGUID: A1l5EFtSTo6voIsiwzangA==
X-CSE-MsgGUID: Fmh84GcGTxOPxkF6xG0dCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28416830"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28416830"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:28:10 -0700
X-CSE-ConnectionGUID: ukoISos4QzaNZS0JEiRx9Q==
X-CSE-MsgGUID: XkcWAqO6QcushywClGfI7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="77219968"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:27:24 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id BBEC220B5782;
	Mon, 14 Oct 2024 08:27:19 -0700 (PDT)
Message-ID: <8a9bb804-276d-4b94-9c6d-c984fcd6b649@linux.intel.com>
Date: Mon, 14 Oct 2024 11:27:18 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 10/58] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-11-mizhang@google.com>
 <20241014112043.GD16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014112043.GD16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 7:20 a.m., Peter Zijlstra wrote:
> On Thu, Aug 01, 2024 at 04:58:19AM +0000, Mingwei Zhang wrote:
>> +void perf_guest_exit(void)
>> +{
>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +
>> +	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>> +		goto unlock;
>> +
>> +	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>> +	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>> +	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>> +	if (cpuctx->task_ctx) {
>> +		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
>> +		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
>> +		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>> +	}
> 
> Does this not violate the scheduling order of events? AFAICT this will
> do:
> 
>   cpu pinned
>   cpu flexible
>   task pinned
>   task flexible
> 
> as opposed to:
> 
>   cpu pinned
>   task pinned
>   cpu flexible
>   task flexible
> 
> We have the perf_event_sched_in() helper for this.

Yes, we can avoid the sched_in() with EVENT_GUEST flag, then invoke the
perf_event_sched_in() helper to do the real schedule. I will do more
tests to double check.

Thanks,
Kan
> 
>> +
>> +	__this_cpu_write(perf_in_guest, false);
>> +unlock:
>> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_guest_exit);
> 



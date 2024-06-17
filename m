Return-Path: <kvm+bounces-19780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 861EE90B1B2
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21B8128945D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 14:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA30F1A2C1F;
	Mon, 17 Jun 2024 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ekTksabl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B919A289;
	Mon, 17 Jun 2024 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718631262; cv=none; b=bu50RTC61dUWkCJWJ4xooJFiCneSQl1hWBs3SyvXgsihY3A2xU/Raq/xxvSamnzhEftjZmuWIKcKj68uIMEYkOXsjHtjq1rw+39FUmpDT8cz111k5cDzySyHx6UCKIc4gsDpkZP5gfAlct3qyDL+JpWoO/qzBE4cBShFYisLNWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718631262; c=relaxed/simple;
	bh=+NRvjYKiPdpSkNjcQbOvp8EwA2yizV06H2BtcziH4TQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQ28s0yqduTA02CwcRBx+tIv3eg1uf/ruA0fLFmYJqWD86R6xr92A4mrtzafN0Ds8+3xEbx0/2J3EroEusSWPFkojffcdDL6szqxKVGEhKAbaBnPamwF9BsbRWJF4urALbQgOa2RQJ5iJff0T2XQncpsx3RgTSBEArgQtOJNcAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ekTksabl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718631261; x=1750167261;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+NRvjYKiPdpSkNjcQbOvp8EwA2yizV06H2BtcziH4TQ=;
  b=ekTksablmRZhxINmZ1fSTyc5cGoPXFVa3wqxvn51z1yIgQn7uWG+htM8
   p6YAT0k3oCDlYP7gBgZeMZCQXXJLvckOShnUEBeWmls/UQUtqtxxxflDD
   54ubRG7naMGqAlgYuLu/LMtQG7LoqMj6tCvQ8Y77q6Iq+n7RsdaXVKvQq
   ruCVNSBCJauKuYGdpGzI97pjTyzerjxIdIJuFUd/dGDLcF6FYPePu/Ddi
   WF8bGohtCrL1NpF303PWakkI8IgiS24Rd+AlaooUKzDqO6U33R23qFdKT
   lpkuga01SQL05XFHT5tK3ym4shbYxb2Ap1A8FKuoV4y6crsnJutitRN7D
   g==;
X-CSE-ConnectionGUID: dIog4OngRqKhCDmznUh2AQ==
X-CSE-MsgGUID: 4KHujEn2TSKymNcMWTOhEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="19279522"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="19279522"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 06:34:20 -0700
X-CSE-ConnectionGUID: qUk3iqm3SluzvTXSZqCQ5w==
X-CSE-MsgGUID: hnTKSXKxSEOCc66OkHUxgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="41285400"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 06:34:19 -0700
Received: from [10.212.91.105] (kliang2-mobl1.ccr.corp.intel.com [10.212.91.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id C8AE820B5703;
	Mon, 17 Jun 2024 06:34:16 -0700 (PDT)
Message-ID: <5fcf4471-bcf9-43af-93a0-dcc4fae27449@linux.intel.com>
Date: Mon, 17 Jun 2024 09:34:15 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
 <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
 <20240613091507.GA17707@noisy.programming.kicks-ass.net>
 <3755c323-6244-4e75-9e79-679bd05b13a4@linux.intel.com>
 <f4da2fb2-fa09-4d2b-a78d-1b459ada6d09@linux.intel.com>
 <20240617075123.GX40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240617075123.GX40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-06-17 3:51 a.m., Peter Zijlstra wrote:
> On Thu, Jun 13, 2024 at 02:04:36PM -0400, Liang, Kan wrote:
>>>>  static enum event_type_t get_event_type(struct perf_event *event)
>>>> @@ -3340,9 +3388,14 @@ ctx_sched_out(struct perf_event_context
>>>>  	 * would only update time for the pinned events.
>>>>  	 */
>>>>  	if (is_active & EVENT_TIME) {
>>>> +		bool stop;
>>>> +
>>>> +		stop = !((ctx->is_active & event_type) & EVENT_ALL) &&
>>>> +		       ctx == &cpuctx->ctx;
>>>> +			
>>>>  		/* update (and stop) ctx time */
>>>>  		update_context_time(ctx);
>>>> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
>>>> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
>>
>> For the event_type == EVENT_GUEST, the "stop" should always be the same
>> as "ctx == &cpuctx->ctx". Because the ctx->is_active never set the
>> EVENT_GUEST bit.
>> Why the stop is introduced?
> 
> Because the ctx_sched_out() for vPMU should not stop time, 

But the implementation seems stop the time.

The ctx->is_active should be (EVENT_ALL | EVENT_TIME) for most of cases.

When a vPMU is scheduling in (invoke ctx_sched_out()), the event_type
should only be EVENT_GUEST.

!((ctx->is_active & event_type) & EVENT_ALL) should be TRUE.

For a CPU context, ctx == &cpuctx->ctx is TRUE as well.

The update_cgrp_time_from_cpuctx(cpuctx, TRUE) stops the time by
deactivate the cgroup, __store_release(&info->active, 0).

If an user try to read the cgroup events when a guest is running. The
update_cgrp_time_from_event() doesn't update the cgrp time. So both time
and counter are stopped.

> only the
> 'normal' sched-out should stop time.

If the guest is the only case which we want to keep the time for, I
think we may use a straightforward check as below.

	stop = !(event_type & EVENT_GUEST) && ctx == &cpuctx->ctx;

> 
> 
>>>> @@ -3949,6 +4015,8 @@ ctx_sched_in(struct perf_event_context *
>>>>  		return;
>>>>  
>>>>  	if (!(is_active & EVENT_TIME)) {
>>>> +		/* EVENT_TIME should be active while the guest runs */
>>>> +		WARN_ON_ONCE(event_type & EVENT_GUEST);
>>>>  		/* start ctx time */
>>>>  		__update_context_time(ctx, false);
>>>>  		perf_cgroup_set_timestamp(cpuctx);
>>>> @@ -3979,8 +4047,11 @@ ctx_sched_in(struct perf_event_context *
>>>>  		 * the exclude_guest events.
>>>>  		 */
>>>>  		update_context_time(ctx);
>>>> -	} else
>>>> +		update_cgrp_time_from_cpuctx(cpuctx, false);
>>
>>
>> In the above ctx_sched_out(), the cgrp_time is stopped and the cgrp has
>> been set to inactive.
>> I think we need a perf_cgroup_set_timestamp(cpuctx) here to restart the
>> cgrp_time, Right?
> 
> So the idea was to not stop time when we schedule out for the vPMU, as
> per the above.
> 
>> Also, I think the cgrp_time is different from the normal ctx->time. When
>> a guest is running, there must be no cgroup. It's OK to disable the
>> cgrp_time. If so, I don't think we need to track the guest_time for the
>> cgrp.
> 
> Uh, the vCPU thread is/can-be part of a cgroup, and different guests
> part of different cgroups. The CPU wide 'guest' time is all time spend
> in guets, but the cgroup view of things might differ, depending on how
> the guets are arranged in cgroups, no?
> 
> As such, we need per cgroup guest tracking.

Got it.

Thanks,
Kan


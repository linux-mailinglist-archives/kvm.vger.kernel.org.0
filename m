Return-Path: <kvm+bounces-54911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33C3B2B20F
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:08:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5C8E3BF4FD
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A3924EAB1;
	Mon, 18 Aug 2025 20:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9oTVbBu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF02828695;
	Mon, 18 Aug 2025 20:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547664; cv=none; b=gtUnn62WZH7T1s+xYjyNBtr/onxmcqinDWqq9NqekHL3Z+mOpgN8NDeU6rY6VBAqN5hGZCQg5tiIAbd58ZAQAXfp5dGNhxAyhIzTCrahTWQPKn6tWppkF82l6ucb/l00SMtAvcDDoSLXaNn2By0qD/7lZag7ZWKyMv9PT/UOJEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547664; c=relaxed/simple;
	bh=HUP2AEiZfFgmlejZ9gs27ibEAHSKm6RtjRLDUuqDXBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9FbF6NmiBdc9AP9BHdcm16LWJHTUfR5oLe0Z4JlA9afit2kfuo9YD9z47kbtb5yVYPZzaqS6wdLaeICy/oNHtsJypgd1j7aVgNsKhXIe5xAObw8T69lNyi9coe6lZS3KjLB8FJL8Nb2Cr1tZN8vf7pcH9/eeu1zyYSp0Uy3ues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9oTVbBu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755547663; x=1787083663;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HUP2AEiZfFgmlejZ9gs27ibEAHSKm6RtjRLDUuqDXBM=;
  b=F9oTVbBuK8fZEOqmOJwLuhaU1Z+cHHP05a6oZ4yISpCDUrmXS5RaT96v
   hM/6UP12uUeXoTRdbxuCYTftEHgh3f3LhIPb4Y5BpuLq28WF7nWoozjYD
   q9HbTureoXfwT9iKnIMWAjh2VXAIuKK+lsNKOky8aUmpqFl1J/vuOr0Gh
   iZr4w2xarbb/kpkqdWuUTYKXfM/y0uCBfhhDjbw/BQZM1caZBDFIbWTiH
   8RLu7NuBVq7OgQ4skQTYRST7y9CTN60lsclY4c8I7VXNrJGDrlbqJ5N8K
   EtEU/JyrhTTCCN6FC2DWQX0kVyu0gCrwFcy7R3D5ns78/ofrjYhb3aFef
   g==;
X-CSE-ConnectionGUID: YKi0aTo5S6ih6X9Oq2qq2g==
X-CSE-MsgGUID: cHoWeWULTouUptFmpDlYRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="69233303"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="69233303"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 13:07:43 -0700
X-CSE-ConnectionGUID: VPdWLgrPQ4q9Io7sk+4Srw==
X-CSE-MsgGUID: IPqmhJ93SHqaacsNGeVfjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="168055360"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 13:07:41 -0700
Received: from [10.124.163.195] (kliang2-mobl1.ccr.corp.intel.com [10.124.163.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id D183720B571C;
	Mon, 18 Aug 2025 13:07:39 -0700 (PDT)
Message-ID: <4e58688f-22e0-4e20-9043-dee76d01d24f@linux.intel.com>
Date: Mon, 18 Aug 2025 13:07:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
To: Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com> <aJ9YbZTJAg66IiVh@google.com>
 <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
 <aKNF7jc4qr9ab-Es@google.com>
 <20250818161210.GJ3289052@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20250818161210.GJ3289052@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025-08-18 9:12 a.m., Peter Zijlstra wrote:
> On Mon, Aug 18, 2025 at 08:25:34AM -0700, Sean Christopherson wrote:
> 
>>> OK, so *IF* doing the VM-exit during PMI is sound, this is something
>>> that needs a comment somewhere. 
>>
>> I'm a bit lost here.  Are you essentially asking if it's ok to take a VM-Exit
>> while the guest is handling a PMI?  If so, that _has_ to work, because there are
>> myriad things that can/will trigger a VM-Exit at any point while the guest is
>> active.
> 
> Yes, that's what I'm asking. Why is this VM-exit during PMI nonsense not
> subject to the same failures that mandates the mid/late PMI ACK.
> 
> And yes, I realize this needs to work. But so far I'm not sure I
> understand why that is a safe thing to do.
> 
> Like I wrote, I suspect writing all the PMU MSRs serializes things
> sufficiently, but if that is the case, that needs to be explicitly
> mentioned. Because that also doesn't explain why we needs mid-ack
> instead of late-ack on ADL e-cores for instance.

The mid-ack and late-ack only require under some corner cases, e.g., two
PMIs are triggered simultaneously with PEBS.
Because the ucode of p-core and e-core handle the pending PEBS records
and PMIs differently.
For p-core, the ACK should be as close to EOM. Otherwise, the pending
PMI will trigger a spurious PMI warning.
For e-core, the uncode handles the pending PMI well. There is no
spurious PMI. However, it impacts the update of the PEBS_DATA_CFG. The
PEBS_DATA_CFG is global. If the ACK cannot be done before re-enabling
counters, the stale PEBS_DATA_CFG will somehow be written into the next
PEBS record of the pending PMI. It triggers the malformed PEBS record.

For the upcoming arch PEBS, the data cfg is per-counter.
The mid-ack workaround should not be required.
> 
> Could it perhaps be that we don't let the guests do PEBS because DS
> doesn't virtualize? And thus we don't have the malformed PEBS record?
>

Yes, I don't think it can impact the mediated PMU. The legacy PEBS for
vPMU is not supported.
Since the configuration is per-counter with the arch PEBS, the malformed
PEBS record should not be triggered either.


Thanks,
Kan


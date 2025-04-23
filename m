Return-Path: <kvm+bounces-43858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E13A97B80
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 02:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5373BA124
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 00:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3A94C62;
	Wed, 23 Apr 2025 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhzsM7Sf"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E2F1862
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745366588; cv=none; b=VoO8OW+qkXqPYAnOiQQ+XXETHYg3KfZzlslS5JFnyd/bnE8xzKofENa665EGxzdek8k5BpixkJhT847W4xIFDR9Bq/asmydWKzn71jDE1v+HogbnQEoWVH/HKtD1U6yl5bBlg/+2rOZZ+fU8wiltXJElgoB6d696l5tOlNOrfBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745366588; c=relaxed/simple;
	bh=vtSHiCGeVpCK89VRFfHTQt0dcY/pf+IuTThkl50qclE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSPNtu6j7AUjZ0chHW6kCUhgZQzurGXaKiQD978sNgfGdthNNIlIQ+Bg82mawTuLx9mKhWoINR8nNfs7Z18/tKTdJyDi7OJ2ZNFEF/ZdNBHMutMrvvDSOHRCOwI6cViIb+Yc+I/6UQR2dvQPaRgTZVSBYfB6rci+8HvULIFiJaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhzsM7Sf; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <42e1d440-24a0-4bdb-b21f-fedf8b7be4fe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745366573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WZGPFf3wMnSbU09hVmCJjsXY+G6x3DIKE+UVsiEcfVo=;
	b=VhzsM7SfNxZBX8mRw1/QEzjMwF2pH593aPmDUeBsHCgaieFXrT8VRFFfIFY3prO034W1jt
	+bTJq+wjNisRfusKlmRzBCJP9HI2Txq8P/OmG2NCMR2VbCR5tIP+SSMbok6Kn2a6giMEZY
	1zMY3nOiwGnbm9AccKkxUE1U9Y6IROA=
Date: Tue, 22 Apr 2025 17:02:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 11/21] RISC-V: perf: Restructure the SBI PMU code
To: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Mark Rutland <mark.rutland@arm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
 <20250327-counter_delegation-v5-11-1ee538468d1b@rivosinc.com>
 <20250404134937.GA29394@willie-the-truck>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250404134937.GA29394@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 4/4/25 6:49 AM, Will Deacon wrote:
> On Thu, Mar 27, 2025 at 12:35:52PM -0700, Atish Patra wrote:
>> With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
>> access hpmcounter/events. However, we do need it for firmware counters.
>> Rename the driver and its related code to represent generic name
>> that will handle both sbi and ISA mechanism for hpmcounter related
>> operations. Take this opportunity to update the Kconfig names to
>> match the new driver name closely.
>>
>> No functional change intended.
>>
>> Reviewed-by: Clément Léger <cleger@rivosinc.com>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>>   MAINTAINERS                                       |   4 +-
>>   arch/riscv/include/asm/kvm_vcpu_pmu.h             |   4 +-
>>   arch/riscv/include/asm/kvm_vcpu_sbi.h             |   2 +-
>>   arch/riscv/kvm/Makefile                           |   4 +-
>>   arch/riscv/kvm/vcpu_sbi.c                         |   2 +-
>>   drivers/perf/Kconfig                              |  16 +-
>>   drivers/perf/Makefile                             |   4 +-
>>   drivers/perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
>>   drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 214 +++++++++++++---------
> 
> I'm still against this renaming churn. It sucks for backporting and
> you're also changing the name of the driver, which could be used by
> scripts in userspace (e.g. module listings, udev rules, cmdline options)
> 


Ok. I will revert the file and driver name change. I hope config 
renaming and code refactoring to separate counter delegation (hw method) 
vs SBI calls (firmware assisted method) are okay ?


> Will
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv



Return-Path: <kvm+bounces-43204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65174A875A9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 04:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AA9716F909
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 02:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214D519066D;
	Mon, 14 Apr 2025 02:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VcFq6s9G"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005A2AD2C;
	Mon, 14 Apr 2025 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744596116; cv=none; b=toazhxhRF3zyUMfwzbfFN3hK68cXt4GUG1vbEXGaNiMoffcu8vLMcVDA9ot3T6c31jUyPhP5PTePNGvmMFoZ+JBeALgp/h7Z9FRITnyDRM6pkCe2mb0vFDY/i5fgHXxBxvB5K8mFZMZQNPSsRPKmJtljsXRN75bDaDVcLCa6eLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744596116; c=relaxed/simple;
	bh=hT82+C+fgTndGTtayP85x/XcIQcK04vHW06MJRnMAhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORy/Hd6imEDK9gWBqvcIgxpzPQcysUVtY/XcEfy98N1MZLs9F093CArCY5rtt9+xSH9S+OLwdbLTZDAtv+JG6cgrD/97iR2hXkjdSq5C3SU83aErdfQbavs30TrpZtUMjBin06SZ9EUvLiBIdWrXPqaYLGSysA5/Y1jVIgU3lM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VcFq6s9G; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744596103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=X97F5MgRA4m0PgntN/AzNUw5CItqAr4WVJ5ZtYo90bQ=;
	b=VcFq6s9GdagObMRd7AlfZnKHFo10XVGLBbsORpZuheqF7GXmIY7OsuLxRScR0c6kQTIUm73j5Q/7K8FqLzee+nIruvMVQCUhKpeMxHTUeBxIAE31E0yAf9ZovN1H4YbONX1qgXFfvjAxdjWpv0W7mPUp5yP+i5pk5VAAfK1886c=
Received: from 30.246.161.79(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WWdgnQn_1744596100 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Apr 2025 10:01:41 +0800
Message-ID: <f384a766-d91a-4db5-9ed6-c1ed6079da1d@linux.alibaba.com>
Date: Mon, 14 Apr 2025 10:01:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
To: Ankur Arora <ankur.a.arora@oracle.com>, harisokn@amazon.com
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 x86@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
 daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
 lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
 mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org, maz@kernel.org,
 misono.tomohiro@fujitsu.com, maobibo@loongson.cn, zhenglifeng1@huawei.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-11-ankur.a.arora@oracle.com>
 <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
 <87h62u76xg.fsf@oracle.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <87h62u76xg.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/4/12 04:57, Ankur Arora 写道:
> 
> Shuai Xue <xueshuai@linux.alibaba.com> writes:
> 
>> 在 2025/2/19 05:33, Ankur Arora 写道:
>>> Needed for cpuidle-haltpoll.
>>> Acked-by: Will Deacon <will@kernel.org>
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ---
>>>    arch/arm64/kernel/idle.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>>> index 05cfb347ec26..b85ba0df9b02 100644
>>> --- a/arch/arm64/kernel/idle.c
>>> +++ b/arch/arm64/kernel/idle.c
>>> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>>>    	 */
>>>    	cpu_do_idle();
>>
>> Hi, Ankur,
>>
>> With haltpoll_driver registered, arch_cpu_idle() on x86 can select
>> mwait_idle() in idle threads.
>>
>> It use MONITOR sets up an effective address range that is monitored
>> for write-to-memory activities; MWAIT places the processor in
>> an optimized state (this may vary between different implementations)
>> until a write to the monitored address range occurs.
> 
> MWAIT is more capable than WFE -- it allows selection of deeper idle
> state. IIRC C2/C3.
> 
>> Should arch_cpu_idle() on arm64 also use the LDXR/WFE
>> to avoid wakeup IPI like x86 monitor/mwait?
> 
> Avoiding the wakeup IPI needs TIF_NR_POLLING and polling in idle support
> that this series adds.
> 
> As Haris notes, the negative with only using WFE is that it only allows
> a single idle state, one that is fairly shallow because the event-stream
> causes a wakeup every 100us.
> 
> --
> ankur

Hi, Ankur and Haris

Got it, thanks for explaination :)

Comparing sched-pipe performance on Rund with Yitian 710, *IPC improved 35%*:

w/o haltpoll
Performance counter stats for 'CPU(s) 0,1' (5 runs):

     32521.53 msec task-clock                #    2.000 CPUs utilized            ( +-  1.16% )
  38081402726      cycles                    #    1.171 GHz                      ( +-  1.70% )
  27324614561      instructions              #    0.72  insn per cycle           ( +-  0.12% )
          181      sched:sched_wake_idle_without_ipi #    0.006 K/sec

w/ haltpoll
Performance counter stats for 'CPU(s) 0,1' (5 runs):

      9477.15 msec task-clock                #    2.000 CPUs utilized            ( +-  0.89% )
  21486828269      cycles                    #    2.267 GHz                      ( +-  0.35% )
  23867109747      instructions              #    1.11  insn per cycle           ( +-  0.11% )
      1925207      sched:sched_wake_idle_without_ipi #    0.203 M/sec

Comparing sched-pipe performance on QEMU with Kunpeng 920, *IPC improved 10%*:

w/o haltpoll
Performance counter stats for 'CPU(s) 0,1' (5 runs):

          34,007.89 msec task-clock                       #    2.000 CPUs utilized               ( +-  8.86% )
      4,407,859,620      cycles                           #    0.130 GHz                         ( +- 84.92% )
      2,482,046,461      instructions                     #    0.56  insn per cycle              ( +- 88.27% )
                 16      sched:sched_wake_idle_without_ipi #    0.470 /sec                        ( +- 98.77% )

              17.00 +- 1.51 seconds time elapsed  ( +-  8.86% )

w/ haltpoll
Performance counter stats for 'CPU(s) 0,1' (5 runs):

          16,894.37 msec task-clock                       #    2.000 CPUs utilized               ( +-  3.80% )
      8,703,158,826      cycles                           #    0.515 GHz                         ( +- 31.31% )
      5,379,257,839      instructions                     #    0.62  insn per cycle              ( +- 30.03% )
            549,434      sched:sched_wake_idle_without_ipi #   32.522 K/sec                       ( +- 30.05% )

              8.447 +- 0.321 seconds time elapsed  ( +-  3.80% )

Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks.
Shuai


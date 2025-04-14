Return-Path: <kvm+bounces-43213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F187A87950
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 09:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50EE1893B10
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 07:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB9225A2C0;
	Mon, 14 Apr 2025 07:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="azFDULDu"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F05257AD7;
	Mon, 14 Apr 2025 07:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744616607; cv=none; b=lpZPb4d9nSGMBuZcJTeDo2KJ1fOrd7imHf/UPG4IFnOjcdHS+HpiQISJa7N1Os4+6cEMzlRcWCo3fjUiVBGRwhPSFVmqqAZ/KyGCgD2Lt/xjvHLFyRkpFhci6DW+c3H1a5pWCKxXMyalpxAdBy4kKzb4zAlvLBWqNdQmz23QBq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744616607; c=relaxed/simple;
	bh=tf/PEHyYC+GBZMw14mMpsvDNIqms1Sh+qIoWrHc5IsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wk5fu97ZP4RFCz8Plki9OsHeqsBY2kBHqHxp46/BjLehztofTkySdpCFIjA3xkKRMOxOcb/M8Z49Anf+wkwTQjUwMK+NQnGeUq3n2/aYokNDr0LaaCe7FCeDAFcSB+Vy3sD6cfx7F/YOTTXTPijoq/ELYr/C5BEL/TgCr6ZRedE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=azFDULDu; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744616593; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=C6S9D8CaBKO/q2oBksdQOb459DEafNnNvUFs5jBUstY=;
	b=azFDULDuHExDCt5FswzsqBiw7GRjdeF5X4tmjj/+mIXPx9ZocY8uR29jO/vEJhIlHYY9a+jvyiDy5CNXeQ2s8vYdiCtZiVhbyTmGgkniYDwsWY/a3gD+yekO7r9dkhQ2Y/ncQGdhcDwpSDfATmFxHfzk1+V1VImjkIVEz/qyfSc=
Received: from 30.246.161.79(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WWirnWt_1744616589 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Apr 2025 15:43:10 +0800
Message-ID: <6b313eef-c576-4c0c-8d9f-8ef0bf3cc0fd@linux.alibaba.com>
Date: Mon, 14 Apr 2025 15:43:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
To: Ankur Arora <ankur.a.arora@oracle.com>
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
 <f384a766-d91a-4db5-9ed6-c1ed6079da1d@linux.alibaba.com>
 <87ikn75rrn.fsf@oracle.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <87ikn75rrn.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/4/14 11:46, Ankur Arora 写道:
> 
> Shuai Xue <xueshuai@linux.alibaba.com> writes:
> 
>> 在 2025/4/12 04:57, Ankur Arora 写道:
>>> Shuai Xue <xueshuai@linux.alibaba.com> writes:
>>>
>>>> 在 2025/2/19 05:33, Ankur Arora 写道:
>>>>> Needed for cpuidle-haltpoll.
>>>>> Acked-by: Will Deacon <will@kernel.org>
>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>> ---
>>>>>     arch/arm64/kernel/idle.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>>>>> index 05cfb347ec26..b85ba0df9b02 100644
>>>>> --- a/arch/arm64/kernel/idle.c
>>>>> +++ b/arch/arm64/kernel/idle.c
>>>>> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>>>>>     	 */
>>>>>     	cpu_do_idle();
>>>>
>>>> Hi, Ankur,
>>>>
>>>> With haltpoll_driver registered, arch_cpu_idle() on x86 can select
>>>> mwait_idle() in idle threads.
>>>>
>>>> It use MONITOR sets up an effective address range that is monitored
>>>> for write-to-memory activities; MWAIT places the processor in
>>>> an optimized state (this may vary between different implementations)
>>>> until a write to the monitored address range occurs.
>>> MWAIT is more capable than WFE -- it allows selection of deeper idle
>>> state. IIRC C2/C3.
>>>
>>>> Should arch_cpu_idle() on arm64 also use the LDXR/WFE
>>>> to avoid wakeup IPI like x86 monitor/mwait?
>>> Avoiding the wakeup IPI needs TIF_NR_POLLING and polling in idle support
>>> that this series adds.
>>> As Haris notes, the negative with only using WFE is that it only allows
>>> a single idle state, one that is fairly shallow because the event-stream
>>> causes a wakeup every 100us.
>>> --
>>> ankur
>>
>> Hi, Ankur and Haris
>>
>> Got it, thanks for explaination :)
>>
>> Comparing sched-pipe performance on Rund with Yitian 710, *IPC improved 35%*:
> 
> Thanks for testing Shuai. I wasn't expecting the IPC to improve by quite
> that much :). The reduced instructions make sense since we don't have to
> handle the IRQ anymore but we would spend some of the saved cycles
> waiting in WFE instead.
> 
> I'm not familiar with the Yitian 710. Can you check if you are running
> with WFE? That's the __smp_cond_load_relaxed_timewait() path vs the
> __smp_cond_load_relaxed_spinwait() path in [0]. Same question for the
> Kunpeng 920.

Yes, it running with __smp_cond_load_relaxed_timewait().

I use perf-probe to check if WFE is available in Guest:

perf probe 'arch_timer_evtstrm_available%return r=$retval'
perf record -e probe:arch_timer_evtstrm_available__return -aR sleep 1
perf script
swapper       0 [000]  1360.063049: probe:arch_timer_evtstrm_available__return: (ffff800080a5c640 <- ffff800080d42764) r=0x1

arch_timer_evtstrm_available returns true, so
__smp_cond_load_relaxed_timewait() is used.

> 
> Also, I'm working on a new version of the series in [1]. Would you be
> okay trying that out?

Sure. Please cc me when you send out a new version.

> 
> Thanks
> Ankur
> 
> [0] https://lore.kernel.org/lkml/20250203214911.898276-1-ankur.a.arora@oracle.com/
> [1] https://lore.kernel.org/lkml/20250203214911.898276-4-ankur.a.arora@oracle.com/
> 

Thanks.
Shuai


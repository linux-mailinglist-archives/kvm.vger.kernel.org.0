Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232DB3D7E23
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhG0S52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhG0S51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:57:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB27EC061764
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:57:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ca5so971506pjb.5
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=NXlwJruXkpJ+yuRr3Ny47qE4ejJcWzcd0hJXzdTUy1o=;
        b=H7UwOW/t/LEWHiQpFLro/pe3jEtcPO0eJPaadtLJ3pnvkadLizFuOiiY+oM8G9HD+P
         Ocs++ENNM0TOk1oXv1vAS0WRHRKyItKZqj0gCjto78xvLekO7HX2suQDKD/hSpzsM3Xm
         7DU1hLmwDBgTtzdkX9E5JOnVfwjWf1Xr6Gd6U8e17NZ6vRcUoUZ3UqsEZxgcSbszjN7X
         PRoH+KWuLkOFv+6F1Bx+m+vtMT6tjucX+A7OSrtQCmrnYWOb2gy0/V0LMEdZnue7x/85
         yArY/k1okB0FmJMpAlnf2PcM5WTrvfiMI+ArAsxb2sPRB5EONRckb9G3MJD59gPfNVzW
         9+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=NXlwJruXkpJ+yuRr3Ny47qE4ejJcWzcd0hJXzdTUy1o=;
        b=JL6sQxGhLq74m380KQU0J0X7E/F3aN6wmWuBAI5cEGz0mzwpwCcLfUkmmRJiE9UxfG
         aWCmFAgvbnKNFaCWp5EWQKo85eXUebSFpJiOgGIO5kuiLIXSUY1ZpC/eL1hDnKkIuyhV
         mQqYsjw5NX2DuUzvam5qNuolSqynbU4rOlJ5cJ3D6taEn2cEVAUUf44yvaiiQWkUiw4F
         WdddvU5j8kXQi2P/Hek6L11Y6Q2ZVAG7+Aww6ZFMjTtjwDg/GH1OzT3idvwSftZHkrwF
         rhgzQAWw0J7/+jhJ9xkSDMN9cmHYbYuMdaptqnkbS4y6E+gkKJoaplBID9TfJON8mozy
         bDdQ==
X-Gm-Message-State: AOAM532YL8ix2FCF5MEB3DEx/KG0l84K5kq0P4R/TxweeA9gSB8sSvZZ
        On2Apd69RWLGmA+kTFUuQYPH3g==
X-Google-Smtp-Source: ABdhPJzApcwZYWTEiTKzL5ZYv6E437W4sjpRLKR2IvWjZoE088wEQSwVMWXYyUTq+9+qN1FFpbpyRQ==
X-Received: by 2002:a63:f241:: with SMTP id d1mr24813648pgk.424.1627412246933;
        Tue, 27 Jul 2021 11:57:26 -0700 (PDT)
Received: from bsegall-glaptop.localhost (c-73-71-82-80.hsd1.ca.comcast.net. [73.71.82.80])
        by smtp.gmail.com with ESMTPSA id il2sm3338495pjb.29.2021.07.27.11.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:57:25 -0700 (PDT)
From:   Benjamin Segall <bsegall@google.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>, peterz@infradead.org,
        bristot@redhat.com, dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
        <20210707123402.13999-1-borntraeger@de.ibm.com>
        <20210707123402.13999-2-borntraeger@de.ibm.com>
        <20210723093523.GX3809@techsingularity.net>
        <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
        <20210723162137.GY3809@techsingularity.net>
        <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
Date:   Tue, 27 Jul 2021 11:57:13 -0700
In-Reply-To: <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com> (Christian
        Borntraeger's message of "Mon, 26 Jul 2021 20:41:15 +0200")
Message-ID: <xm2635rza8l2.fsf@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> On 23.07.21 18:21, Mel Gorman wrote:
>> On Fri, Jul 23, 2021 at 02:36:21PM +0200, Christian Borntraeger wrote:
>>>> sched: Do not select highest priority task to run if it should be skipped
>>>>
>>>> <SNIP>
>>>>
>>>> index 44c452072a1b..ddc0212d520f 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>>>    			se = second;
>>>>    	}
>>>> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>>>> +	if (cfs_rq->next &&
>>>> +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
>>>>    		/*
>>>>    		 * Someone really wants this to run. If it's not unfair, run it.
>>>>    		 */
>>>>
>>>
>>> I do see a reduction in ignored yields, but from a performance aspect for my
>>> testcases this patch does not provide a benefit, while the the simple
>>> 	curr->vruntime += sysctl_sched_min_granularity;
>>> does.
>> I'm still not a fan because vruntime gets distorted. From the docs
>>     Small detail: on "ideal" hardware, at any time all tasks would have the
>> same
>>     p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
>>     would ever get "out of balance" from the "ideal" share of CPU time
>> If yield_to impacts this "ideal share" then it could have other
>> consequences.
>> I think your patch may be performing better in your test case because every
>> "wrong" task selected that is not the yield_to target gets penalised and
>> so the yield_to target gets pushed up the list.
>> 
>>> I still think that your approach is probably the cleaner one, any chance to improve this
>>> somehow?
>>>
>> Potentially. The patch was a bit off because while it noticed that skip
>> was not being obeyed, the fix was clumsy and isolated. The current flow is
>> 1. pick se == left as the candidate
>> 2. try pick a different se if the "ideal" candidate is a skip candidate
>> 3. Ignore the se update if next or last are set
>> Step 3 looks off because it ignores skip if next or last buddies are set
>> and I don't think that was intended. Can you try this?
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 44c452072a1b..d56f7772a607 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>>   			se = second;
>>   	}
>>   -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
>>   		/*
>>   		 * Someone really wants this to run. If it's not unfair, run it.
>>   		 */
>>   		se = cfs_rq->next;
>> -	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
>> +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
>>   		/*
>>   		 * Prefer last buddy, try to return the CPU to a preempted task.
>>   		 */
>> 
>
> This one alone does not seem to make a difference. Neither in ignored yield, nor
> in performance.
>
> Your first patch does really help in terms of ignored yields when
> all threads are pinned to one host CPU. After that we do have no ignored yield
> it seems. But it does not affect the performance of my testcase.
> I did some more experiments and I removed the wakeup_preempt_entity checks in
> pick_next_entity - assuming that this will result in source always being stopped
> and target always being picked. But still, no performance difference.
> As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
> controller). I will try to better understand the scheduler logic and do some more
> testing. If you have anything that I should test, let me know.
>
> Christian

If both yielder and target are in the same cpu cgroup or the cpu cgroup
is disabled (ie, if cfs_rq_of(p->se) matches), you could try

if (p->se.vruntime > rq->curr->se.vruntime)
	swap(p->se.vruntime, rq->curr->se.vruntime)

as well as the existing buddy flags, as an entirely fair vruntime boost
to the target.

For when they aren't direct siblings, you /could/ use find_matching_se,
but it's much less clear that's desirable, since it would yield vruntime
for the entire hierarchy to the target's hierarchy.

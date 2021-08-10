Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDFC3E55DD
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhHJItj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbhHJIth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:49:37 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00324C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 01:49:15 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c23-20020a0568301af7b029050cd611fb72so2524886otd.3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJvqFMrFyC5HN29/1laUi8N0RvWoYgo0Ab1qvuvHTEE=;
        b=x7m0XTiGBYRi6EVx7ZndV6sWn8CwnRMBsgAqcmc4SWsqPUYcRyK1bdItpxlHgoorA3
         detcIqL0uZB8zLYz217UYDQlQNmOfzmVyxL9yJI1kyGB4gY5Q/5pBqiNE1DECMiBg5BR
         8VUI8QAjC8t2D0mmkVHzmOkmmB2PI4vwPWfJag+BNmprGnu5pXEEfeFkeCin32qb/e0d
         F9wQOOUk2gY36MwWS4ECXYvxeEOfX2+xtjppLlcwWA87CmnTMvTrSh4ig8hfPMwA73lk
         Lw13s01rLWtQodpnBKzUMTRKYqkARAj3hjBYNJVU8+NqU1Lr1/WwSmitXo2MUY9cwBd1
         lqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJvqFMrFyC5HN29/1laUi8N0RvWoYgo0Ab1qvuvHTEE=;
        b=JBV/whGIIe+2nYu8fjmDekXLwJjX1xBnyoNcDSqsfVvMaR7yewLgPNQfv+x2STOD9B
         iazObqlwozqaaQiw6zgLQPkcOlFOzFRK8Y5SW8IluNaYrpPvgHkm5tJF6JB+JYuZWg9H
         STsgCdgTeN5HC6nOQqKIBECyk8yojclCFUMutMKJRex6edhqFYOsyfwJtghUq2r9uJvZ
         n1ltTRIO1fe/6s2hN2dF2NBI8W1Qk9uYvgqMuCS7rhHrF0sOhzGi5VMXX5cknBssiFbo
         AtmCS7sVeY643TWVF44dGu6R1/T0HcKJZ39GQsC95gmMu/mPE2Jpm8Nx98En3dn41xh0
         ZCuw==
X-Gm-Message-State: AOAM530DSzcC798eoVYFI21Mgx4jPjqRlsxQefAIm5N4SrddcjtRtYoW
        CQedhw/GPC+JgPmboXyLT766DhSvgzTs6Yfl166uCA==
X-Google-Smtp-Source: ABdhPJypice4yN7OjjE+e0d3Oneqm+CAC/I0NkEJK16FX9j2XlM6PS8mJ3yq+sodXeKPm4zxn7YuFjieRnFMdk2n/Gw=
X-Received: by 2002:a9d:38f:: with SMTP id f15mr18504480otf.253.1628585355309;
 Tue, 10 Aug 2021 01:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com> <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net> <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
 <20210723162137.GY3809@techsingularity.net> <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
 <xm2635rza8l2.fsf@google.com> <d9543747-c75f-28c2-6af3-8d9a134717a6@de.ibm.com>
In-Reply-To: <d9543747-c75f-28c2-6af3-8d9a134717a6@de.ibm.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 10 Aug 2021 10:49:03 +0200
Message-ID: <CAKfTPtCwP9cV0AQCuwUDAMPvXYdR9Bi0QMbbonCtVbFRpUv0XQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Don <joshdon@google.com>,
        Juri Lelli <juri.lelli@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 at 18:24, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 27.07.21 20:57, Benjamin Segall wrote:
> > Christian Borntraeger <borntraeger@de.ibm.com> writes:
> >
> >> On 23.07.21 18:21, Mel Gorman wrote:
> >>> On Fri, Jul 23, 2021 at 02:36:21PM +0200, Christian Borntraeger wrote:
> >>>>> sched: Do not select highest priority task to run if it should be skipped
> >>>>>
> >>>>> <SNIP>
> >>>>>
> >>>>> index 44c452072a1b..ddc0212d520f 100644
> >>>>> --- a/kernel/sched/fair.c
> >>>>> +++ b/kernel/sched/fair.c
> >>>>> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >>>>>                           se = second;
> >>>>>           }
> >>>>> - if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> >>>>> + if (cfs_rq->next &&
> >>>>> +     (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
> >>>>>                   /*
> >>>>>                    * Someone really wants this to run. If it's not unfair, run it.
> >>>>>                    */
> >>>>>
> >>>>
> >>>> I do see a reduction in ignored yields, but from a performance aspect for my
> >>>> testcases this patch does not provide a benefit, while the the simple
> >>>>    curr->vruntime += sysctl_sched_min_granularity;
> >>>> does.
> >>> I'm still not a fan because vruntime gets distorted. From the docs
> >>>      Small detail: on "ideal" hardware, at any time all tasks would have the
> >>> same
> >>>      p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
> >>>      would ever get "out of balance" from the "ideal" share of CPU time
> >>> If yield_to impacts this "ideal share" then it could have other
> >>> consequences.
> >>> I think your patch may be performing better in your test case because every
> >>> "wrong" task selected that is not the yield_to target gets penalised and
> >>> so the yield_to target gets pushed up the list.
> >>>
> >>>> I still think that your approach is probably the cleaner one, any chance to improve this
> >>>> somehow?
> >>>>
> >>> Potentially. The patch was a bit off because while it noticed that skip
> >>> was not being obeyed, the fix was clumsy and isolated. The current flow is
> >>> 1. pick se == left as the candidate
> >>> 2. try pick a different se if the "ideal" candidate is a skip candidate
> >>> 3. Ignore the se update if next or last are set
> >>> Step 3 looks off because it ignores skip if next or last buddies are set
> >>> and I don't think that was intended. Can you try this?
> >>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>> index 44c452072a1b..d56f7772a607 100644
> >>> --- a/kernel/sched/fair.c
> >>> +++ b/kernel/sched/fair.c
> >>> @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >>>                     se = second;
> >>>     }
> >>>    -        if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> >>> +   if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
> >>>             /*
> >>>              * Someone really wants this to run. If it's not unfair, run it.
> >>>              */
> >>>             se = cfs_rq->next;
> >>> -   } else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
> >>> +   } else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
> >>>             /*
> >>>              * Prefer last buddy, try to return the CPU to a preempted task.
> >>>              */
> >>>
> >>
> >> This one alone does not seem to make a difference. Neither in ignored yield, nor
> >> in performance.
> >>
> >> Your first patch does really help in terms of ignored yields when
> >> all threads are pinned to one host CPU. After that we do have no ignored yield
> >> it seems. But it does not affect the performance of my testcase.
> >> I did some more experiments and I removed the wakeup_preempt_entity checks in
> >> pick_next_entity - assuming that this will result in source always being stopped
> >> and target always being picked. But still, no performance difference.
> >> As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
> >> controller). I will try to better understand the scheduler logic and do some more
> >> testing. If you have anything that I should test, let me know.
> >>
> >> Christian
> >
> > If both yielder and target are in the same cpu cgroup or the cpu cgroup
> > is disabled (ie, if cfs_rq_of(p->se) matches), you could try
> >
> > if (p->se.vruntime > rq->curr->se.vruntime)
> >       swap(p->se.vruntime, rq->curr->se.vruntime)
>
> I tried that and it does not show the performance benefit. I then played with my
> patch (uses different values to add) and the benefit seems to be depending on the
> size that is being added, maybe when swapping it was just not large enough.
>
> I have to say that this is all a bit unclear what and why performance improves.
> It just seems that the cpu cgroup controller has a fair share of the performance
> problems.
>
> I also asked the performance people to run some measurements and the numbers of
> some transactional workload under KVM was
> baseline: 11813
> with much smaller sched_latency_ns and sched_migration_cost_ns: 16419

Have you also tried to increase sched_wakeup_granularity which is used
to decide whether we can preempt curr ?

> with cpu controller disabled: 15962
> with cpu controller disabled + my patch: 16782

Your patch modifies the vruntime of the task but cgroup sched_entity
stays unchanged. Scheduler starts to compare the vruntime of the
sched_entity of the group before reaching your task. That's probably
why your patch doesn't help with cgroup and will be difficult to
extend to cgroup because the yield of the task should not impact the
other entities in the group.

>
> I will be travelling the next 2 weeks, so I can continue with more debugging
> after that.
>
> Thanks for all the ideas and help so far.
>
> Christian
>
> > as well as the existing buddy flags, as an entirely fair vruntime boost
> > to the target.
> >
> > For when they aren't direct siblings, you /could/ use find_matching_se,
> > but it's much less clear that's desirable, since it would yield vruntime
> > for the entire hierarchy to the target's hierarchy.
> >

Return-Path: <kvm+bounces-2593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BD87FB4F0
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D9722813BE
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0017735889;
	Tue, 28 Nov 2023 08:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Ej/Ej+7F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED946189
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 00:55:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cfb2176150so23508235ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 00:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701161717; x=1701766517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ecCmOx+9c4jLZfiKZbq3cyFiyRYscjUqdzTWdjgkAo0=;
        b=Ej/Ej+7FxZH2iwEU8+Ca2awnKeKoorQkopGF8zTBQ6d5ftddmsHQo3iBkJcxRmNHsl
         UcuarQ/TJ8DFH1W//lYRhOI92wV1pUuS+ecZ+VwrBu4BzUM29zmw5JisvrLvSCvonzrQ
         ptvAYQmWiI4nYWW5IypKNa1vfUyvvASjxoBTVtRLhpFHsYpUHG/KK1xhRz2QXmiz1n+M
         AhnaZpwAXjtk+OW1ex9QIv/VCpjxxpyXwn5AUgpDCf4kfFCz7yRwzxvikKLLgk55v3CO
         kXn9ll9V01LIMpGfOL3fUxSmLYzad7du84KaUASbu01s16TTbHzqmQOFg2A6NtpuTJQT
         9QVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701161717; x=1701766517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ecCmOx+9c4jLZfiKZbq3cyFiyRYscjUqdzTWdjgkAo0=;
        b=eEj++Uf/ubfgr3AqB/fm2J+2wwoRTcMhNRo2iI8/XddbO+cPxPFwR1qoAalsVhca5z
         /IdYaqtDa8ZcBIfS9QmiJuCFO7Gp1H3BMtg/+TwIjQlLmFOEgV8AXw5uaFuSXKbDNnHf
         rMAaSV928Pa5byV1J73n0PnWa+9bar7l4uvFEYHgWogybRq9wiSTiZZF6kji5ofhDuNM
         MLW8AScBPxQQe74x7S51d+M57uursor1kQE8dyA903g9cZ1gnEuF9kHNveZd7IQWf1XO
         QWNF419bsjFkX16D5JVgc6rX4NzsOBBPDRGAbYGE8c2awQ0+887FW3RBnDW44RiXyK/8
         LOIw==
X-Gm-Message-State: AOJu0YzAhFehuuz3thsuF9kZoizFjkVEY1LRhivXh6CqWXkfQCBor1ii
	WEM3IzIjKVbQHCQKRSZcDWnB+g==
X-Google-Smtp-Source: AGHT+IH181rTeV/n4HKnyRrWpJnxCUHi5P0N3fsFcjNKwWALvmBorQqbYdtBuDl/aFnPzVCfKV2cZw==
X-Received: by 2002:a17:902:d50d:b0:1cf:c3ae:490e with SMTP id b13-20020a170902d50d00b001cfc3ae490emr7233024plg.44.1701161717290;
        Tue, 28 Nov 2023 00:55:17 -0800 (PST)
Received: from [10.255.131.31] ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902740700b001cf684bf8d8sm7505262pll.107.2023.11.28.00.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 00:55:16 -0800 (PST)
Message-ID: <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
Date: Tue, 28 Nov 2023 16:55:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
To: Tobias Huschle <huschle@linux.ibm.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
 jasowang@redhat.com
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Language: en-US
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/23 9:56 PM, Tobias Huschle Wrote:
> On Wed, Nov 22, 2023 at 11:00:16AM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 21, 2023 at 02:17:21PM +0100, Tobias Huschle wrote:
>>
>> The below should also work for internal entities, but last time I poked
>> around with it I had some regressions elsewhere -- you know, fix one,
>> wreck another type of situations on hand.
>>
>> But still, could you please give it a go -- it applies cleanly to linus'
>> master and -rc2.
>>
>> ---
>> Subject: sched/eevdf: Revenge of the Sith^WSleepers
>>
> 
> Tried the patch, it does not help unfortuntately.
> 
> It might also be possible that the long running vhost is stuck on something.
> During those phases where the vhost just runs for a while. This might have
> been a risk for a while, EEVDF might have just uncovered an unfortuntate
> sequence of events.
> I'll look into this option.
> 
> I also added some more trace outputs in order to find the actual vruntimes
> of the cgroup parents. The numbers look kind of reasonable, but I struggle
> to judge this with certainty.
> 
> In one of the scenarios where the kworker sees an absurd wait time, the
> following occurs (full trace below):
> 
> - The kworker ends its timeslice after 4941 ns
> - __pick_eevdf finds the cgroup holding vhost as the next option to execute
> - Last known values are:
>                      vruntime      deadline
>     cgroup        56117619190   57650477291 -> depth 0
>     kworker       56117624131   56120619190
>    This is fair, since the kworker is not runnable here.
> - At depth 4, the cgroup shows the observed vruntime value which is smaller
>    by a factor of 20, but depth 0 seems to be running with values of the
>    correct magnitude.

A child is running means its parent also being the cfs->curr, but
not vice versa if there are more than one child.

> - cgroup at depth 0 has zero lag, with higher depth, there are large lag
>    values (as observed 606.338267 onwards)

These values of se->vlag means 'run this entity to parity' to avoid
excess context switch, which is what RUN_TO_PARITY does, or nothing
when !RUN_TO_PARITY. In short, se->vlag is not vlag when se->on_rq.

> 
> Now the following occurs, triggered by the vhost:
> - The kworker gets placed again with:
>                      vruntime      deadline
>     cgroup        56117619190   57650477291 -> depth 0, last known value
>     kworker       56117885776   56120885776 -> lag of -725
> - vhost continues executing and updates its vruntime accordingly, here
>    I would need to enhance the trace to also print the vruntimes of the
>    parent sched_entities to see the progress of their vruntime/deadline/lag
>    values as well
> - It is a bit irritating that the EEVDF algorithm would not pick the kworker
>    over the cgroup as its deadline is smaller.
>    But, the kworker has negative lag, which might cause EEVDF to not pick
>    the kworker.
>    The cgroup at depth 0 has no lag, all deeper layers have a significantly
>    positve lag (last known values, might have changed in the meantime).
>    At this point I would see the option that the vhost task is stuck
>    somewhere or EEVDF just does not see the kworker as a eligible option.

IMHO such lag should not introduce that long delay. Can you run the
test again with NEXT_BUDDY disabled?

> 
> - Once the vhost is migrated off the cpu, the update_entity_lag function
>    works with the following values at 606.467022: sched_update
>    For the cgroup at depth 0
>    - vruntime = 57104166665 --> this is in line with the amount of new timeslices
>                                 vhost got assigned while the kworker was waiting
>    - vlag     =   -62439022 --> the scheduler knows that the cgroup was
>                                 overconsuming, but no runtime for the kworker
>    For the cfs_rq we have
>    - min_vruntime =  56117885776 --> this matches the vruntime of the kworker
>    - avg_vruntime = 161750065796 --> this is rather large in comparison, but I
>                                      might access this value at a bad time

Use avg_vruntime() instead.

>    - nr_running   =            2 --> at this point, both, cgroup and kworker are
>                                      still on the queue, with the cgroup being
>                                      in the migration process
> --> It seems like the overconsumption accumulates at cgroup depth 0 and is not
>      propageted downwards. This might be intended though.
> 
> - At 606.479979: sched_place, cgroup hosting the vhost is migrated back
>    onto cpu 13 with a lag of -166821875 it gets scheduled right away as
>    there is no other task (nr_running = 0)
> 
> - At 606.479996: sched_place, the kworker gets placed again, this time
>    with no lag and get scheduled almost immediately, with a wait
>    time of 1255 ns.
> 
> It shall be noted, that these scenarios also occur when the first placement
> of the kworker in this sequence has no lag, i.e. a lag <= 0 is the pattern
> when observing this issue.
> 
> ######################### full trace #########################
> 
> sched_bestvnode: v=vruntime,d=deadline,l=vlag,md=min_deadline,dp=depth
> --> during __pick_eevdf, prints values for best and the first node loop variable, second loop is never executed
> 
> sched_place/sched_update: sev=se->vruntime,sed=se->deadline,sev=se->vlag,avg=cfs_rq->avg_vruntime,min=cfs_rq->min_vruntime

It would be better replace cfs_rq->avg_vruntime with avg_vruntime().
Although we can get real @avg by (vruntime + vlag), I am not sure
vlag (@lag in trace) is se->vlag or the local variable in the place
function which is scaled and no longer be the true vlag.

> --> at the end of place_entity and update_entity_lag
> 
> --> the chunks of 5 entries for these new events represent the 5 levels of the cgroup which hosts the vhost
> 
>      vhost-2931-2953    [013] d....   606.338262: sched_stat_blocked: comm=kworker/13:1 pid=168 delay=90133345 [ns]
>      vhost-2931-2953    [013] d....   606.338262: sched_bestvnode: best: id=0 v=56117619190 d=57650477291 l=0 md=56121178745 dp=0 node: id=168 v=56117619190 d=56120619190 l=0 md=56120619190 dp=0
>      vhost-2931-2953    [013] dN...   606.338263: sched_wakeup: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
>      vhost-2931-2953    [013] dN...   606.338263: sched_bestvnode: best: id=0 v=56117619190 d=57650477291 l=0 md=56121178745 dp=0 node: id=168 v=56117619190 d=56120619190 l=0 md=56120619190 dp=0
>      vhost-2931-2953    [013] dN...   606.338263: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=17910 [ns] vruntime=2099190650 [ns] deadline=2102172740 [ns] lag=2102172740
>      vhost-2931-2953    [013] dN...   606.338264: sched_stat_wait: comm=kworker/13:1 pid=168 delay=0 [ns]
>      vhost-2931-2953    [013] d....   606.338264: sched_switch: prev_comm=vhost-2931 prev_pid=2953 prev_prio=120 prev_state=R+ ==> next_comm=kworker/13:1 next_pid=168 next_prio=120
> --> kworker allowed to execute
>    kworker/13:1-168     [013] d....   606.338266: sched_waking: comm=CPU 0/KVM pid=2958 prio=120 target_cpu=009
>    kworker/13:1-168     [013] d....   606.338267: sched_stat_runtime: comm=kworker/13:1 pid=168 runtime=4941 [ns] vruntime=56117624131 [ns] deadline=56120619190 [ns] lag=56120619190
> --> runtime of 4941 ns
>    kworker/13:1-168     [013] d....   606.338267: sched_update: comm=kworker/13:1 pid=168 sev=56117624131 sed=56120619190 sel=-725 avg=0 min=56117619190 cpu=13 nr=2 lag=-725 lim=10000000
>    kworker/13:1-168     [013] d....   606.338267: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=56117619190 d=57650477291 l=0 md=57650477291 dp=0
> --> depth 0 of cgroup holding vhost:     vruntime      deadline
>                          cgroup        56117619190   57650477291
>                          kworker       56117624131   56120619190
>    kworker/13:1-168     [013] d....   606.338268: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=29822481776 d=29834647752 l=29834647752 md=29834647752 dp=1
>    kworker/13:1-168     [013] d....   606.338268: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=21909608438 d=21919458955 l=21919458955 md=21919458955 dp=2
>    kworker/13:1-168     [013] d....   606.338268: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=11306038504 d=11312426915 l=11312426915 md=11312426915 dp=3
>    kworker/13:1-168     [013] d....   606.338268: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=2953 v=2099190650 d=2102172740 l=2102172740 md=2102172740 dp=4
>    kworker/13:1-168     [013] d....   606.338268: sched_stat_wait: comm=vhost-2931 pid=2953 delay=4941 [ns]
>    kworker/13:1-168     [013] d....   606.338269: sched_switch: prev_comm=kworker/13:1 prev_pid=168 prev_prio=120 prev_state=I ==> next_comm=vhost-2931 next_pid=2953 next_prio=120
>      vhost-2931-2953    [013] d....   606.338311: sched_waking: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
>      vhost-2931-2953    [013] d....   606.338312: sched_place: comm=kworker/13:1 pid=168 sev=56117885776 sed=56120885776 sel=-725 avg=0 min=56117880833 cpu=13 nr=1 vru=56117880833 lag=-725
> --> kworker gets placed again
>      vhost-2931-2953    [013] d....   606.338312: sched_stat_blocked: comm=kworker/13:1 pid=168 delay=44970 [ns]
>      vhost-2931-2953    [013] d....   606.338313: sched_wakeup: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
> --> kworker set to runnable, but vhost keeps on executing

What are the weights of the two entities?

>      vhost-2931-2953    [013] d.h..   606.346964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=8697702 [ns] vruntime=2107888352 [ns] deadline=2110888352 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.356964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999583 [ns] vruntime=2117887935 [ns] deadline=2120887935 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.366964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000089 [ns] vruntime=2127888024 [ns] deadline=2130888024 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.376964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999716 [ns] vruntime=2137887740 [ns] deadline=2140887740 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.386964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000179 [ns] vruntime=2147887919 [ns] deadline=2150887919 [ns] lag=2102172740
>      vhost-2931-2953    [013] D....   606.392250: sched_waking: comm=vhost-2306 pid=2324 prio=120 target_cpu=018
>      vhost-2931-2953    [013] D....   606.392388: sched_waking: comm=vhost-2306 pid=2321 prio=120 target_cpu=017
>      vhost-2931-2953    [013] D....   606.392390: sched_migrate_task: comm=vhost-2306 pid=2321 prio=120 orig_cpu=17 dest_cpu=23
>      vhost-2931-2953    [013] d.h..   606.396964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000187 [ns] vruntime=2157888106 [ns] deadline=2160888106 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.406964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000112 [ns] vruntime=2167888218 [ns] deadline=2170888218 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.416964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999779 [ns] vruntime=2177887997 [ns] deadline=2180887997 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.426964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999667 [ns] vruntime=2187887664 [ns] deadline=2190887664 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.436964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000329 [ns] vruntime=2197887993 [ns] deadline=2200887993 [ns] lag=2102172740
>      vhost-2931-2953    [013] D....   606.441980: sched_waking: comm=vhost-2306 pid=2325 prio=120 target_cpu=021
>      vhost-2931-2953    [013] d.h..   606.446964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=10000069 [ns] vruntime=2207888062 [ns] deadline=2210888062 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.456964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999977 [ns] vruntime=2217888039 [ns] deadline=2220888039 [ns] lag=2102172740
>      vhost-2931-2953    [013] d.h..   606.466964: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=9999548 [ns] vruntime=2227887587 [ns] deadline=2230887587 [ns] lag=2102172740
>      vhost-2931-2953    [013] dNh..   606.466979: sched_wakeup: comm=migration/13 pid=80 prio=0 target_cpu=013
>      vhost-2931-2953    [013] dN...   606.467017: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=41352 [ns] vruntime=2227928939 [ns] deadline=2230887587 [ns] lag=2102172740
>      vhost-2931-2953    [013] d....   606.467018: sched_switch: prev_comm=vhost-2931 prev_pid=2953 prev_prio=120 prev_state=R+ ==> next_comm=migration/13 next_pid=80 next_prio=0
>    migration/13-80      [013] d..1.   606.467020: sched_update: comm=vhost-2931 pid=2953 sev=2227928939 sed=2230887587 sel=0 avg=0 min=2227928939 cpu=13 nr=1 lag=0 lim=10000000
>    migration/13-80      [013] d..1.   606.467021: sched_update: comm= pid=0 sev=12075393889 sed=12087868931 sel=0 avg=0 min=12075393889 cpu=13 nr=1 lag=0 lim=42139916
>    migration/13-80      [013] d..1.   606.467021: sched_update: comm= pid=0 sev=23017543001 sed=23036322254 sel=0 avg=0 min=23017543001 cpu=13 nr=1 lag=0 lim=63209874
>    migration/13-80      [013] d..1.   606.467021: sched_update: comm= pid=0 sev=30619368612 sed=30633124735 sel=0 avg=0 min=30619368612 cpu=13 nr=1 lag=0 lim=46126124
>    migration/13-80      [013] d..1.   606.467022: sched_update: comm= pid=0 sev=57104166665 sed=57945071818 sel=-62439022 avg=161750065796 min=56117885776 cpu=13 nr=2 lag=-62439022 lim=62439022
> --> depth 0 of cgroup holding vhost:     vruntime      deadline
>                          cgroup        57104166665   57945071818
>                          kworker       56117885776   56120885776  --> last known values
> --> cgroup's lag of -62439022 indicates that the scheduler knows that the cgroup ran for too long
> --> nr=2 shows that the cgroup and the kworker are currently on the runqueue
>    migration/13-80      [013] d..1.   606.467022: sched_migrate_task: comm=vhost-2931 pid=2953 prio=120 orig_cpu=13 dest_cpu=12
>    migration/13-80      [013] d..1.   606.467023: sched_place: comm=vhost-2931 pid=2953 sev=2994881412 sed=2997881412 sel=0 avg=0 min=2994881412 cpu=12 nr=0 vru=2994881412 lag=0
>    migration/13-80      [013] d..1.   606.467023: sched_place: comm= pid=0 sev=16617220304 sed=16632657489 sel=0 avg=0 min=16617220304 cpu=12 nr=0 vru=16617220304 lag=0
>    migration/13-80      [013] d..1.   606.467024: sched_place: comm= pid=0 sev=30778525102 sed=30804781512 sel=0 avg=0 min=30778525102 cpu=12 nr=0 vru=30778525102 lag=0
>    migration/13-80      [013] d..1.   606.467024: sched_place: comm= pid=0 sev=38704326194 sed=38724404624 sel=0 avg=0 min=38704326194 cpu=12 nr=0 vru=38704326194 lag=0
>    migration/13-80      [013] d..1.   606.467025: sched_place: comm= pid=0 sev=66383057731 sed=66409091628 sel=-30739032 avg=0 min=66383057731 cpu=12 nr=0 vru=66383057731 lag=0
> --> vhost migrated off to CPU 12
>    migration/13-80      [013] d....   606.467026: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=168 v=56117885776 d=56120885776 l=-725 md=56120885776 dp=0
>    migration/13-80      [013] d....   606.467026: sched_stat_wait: comm=kworker/13:1 pid=168 delay=128714004 [ns]
>    migration/13-80      [013] d....   606.467027: sched_switch: prev_comm=migration/13 prev_pid=80 prev_prio=0 prev_state=S ==> next_comm=kworker/13:1 next_pid=168 next_prio=120
> --> kworker runs next
>    kworker/13:1-168     [013] d....   606.467030: sched_waking: comm=CPU 0/KVM pid=2958 prio=120 target_cpu=009
>    kworker/13:1-168     [013] d....   606.467032: sched_stat_runtime: comm=kworker/13:1 pid=168 runtime=6163 [ns] vruntime=56117891939 [ns] deadline=56120885776 [ns] lag=56120885776
>    kworker/13:1-168     [013] d....   606.467032: sched_update: comm=kworker/13:1 pid=168 sev=56117891939 sed=56120885776 sel=0 avg=0 min=56117891939 cpu=13 nr=1 lag=0 lim=10000000
>    kworker/13:1-168     [013] d....   606.467033: sched_switch: prev_comm=kworker/13:1 prev_pid=168 prev_prio=120 prev_state=I ==> next_comm=swapper/13 next_pid=0 next_prio=120
> --> kworker finishes
>          <idle>-0       [013] d.h..   606.479977: sched_place: comm=vhost-2931 pid=2953 sev=2227928939 sed=2230928939 sel=0 avg=0 min=2227928939 cpu=13 nr=0 vru=2227928939 lag=0
> --> vhost migrated back and placed on CPU 13 again
>          <idle>-0       [013] d.h..   606.479977: sched_stat_sleep: comm=vhost-2931 pid=2953 delay=27874 [ns]
>          <idle>-0       [013] d.h..   606.479977: sched_place: comm= pid=0 sev=12075393889 sed=12099393888 sel=0 avg=0 min=12075393889 cpu=13 nr=0 vru=12075393889 lag=0
>          <idle>-0       [013] d.h..   606.479978: sched_place: comm= pid=0 sev=23017543001 sed=23056927616 sel=0 avg=0 min=23017543001 cpu=13 nr=0 vru=23017543001 lag=0
>          <idle>-0       [013] d.h..   606.479978: sched_place: comm= pid=0 sev=30619368612 sed=30648907073 sel=0 avg=0 min=30619368612 cpu=13 nr=0 vru=30619368612 lag=0
>          <idle>-0       [013] d.h..   606.479979: sched_place: comm= pid=0 sev=56117891939 sed=56168252594 sel=-166821875 avg=0 min=56117891939 cpu=13 nr=0 vru=56117891939 lag=0
>          <idle>-0       [013] dNh..   606.479979: sched_wakeup: comm=vhost-2931 pid=2953 prio=120 target_cpu=013
>          <idle>-0       [013] dN...   606.479981: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=56117891939 d=56168252594 l=-166821875 md=56168252594 dp=0
> --> depth 0 of cgroup holding vhost:     vruntime      deadline
>                          cgroup        56117891939   56168252594
>                          kworker       56117891939   56120885776
>          <idle>-0       [013] dN...   606.479981: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=30619368612 d=30648907073 l=0 md=30648907073 dp=1
>          <idle>-0       [013] dN...   606.479981: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=23017543001 d=23056927616 l=0 md=23056927616 dp=2
>          <idle>-0       [013] dN...   606.479981: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=0 v=12075393889 d=12099393888 l=0 md=12099393888 dp=3
>          <idle>-0       [013] dN...   606.479981: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=2953 v=2227928939 d=2230928939 l=0 md=2230928939 dp=4
>          <idle>-0       [013] dN...   606.479982: sched_stat_wait: comm=vhost-2931 pid=2953 delay=0 [ns]
>          <idle>-0       [013] d....   606.479982: sched_switch: prev_comm=swapper/13 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=vhost-2931 next_pid=2953 next_prio=120
> --> vhost can continue to bully the kworker
>      vhost-2931-2953    [013] d....   606.479995: sched_waking: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
>      vhost-2931-2953    [013] d....   606.479996: sched_place: comm=kworker/13:1 pid=168 sev=56118220659 sed=56121220659 sel=0 avg=0 min=56118220659 cpu=13 nr=1 vru=56118220659 lag=0
>      vhost-2931-2953    [013] d....   606.479996: sched_stat_blocked: comm=kworker/13:1 pid=168 delay=12964004 [ns]
>      vhost-2931-2953    [013] d....   606.479997: sched_wakeup: comm=kworker/13:1 pid=168 prio=120 target_cpu=013
>      vhost-2931-2953    [013] d....   606.479997: sched_stat_runtime: comm=vhost-2931 pid=2953 runtime=20837 [ns] vruntime=2227949776 [ns] deadline=2230928939 [ns] lag=2230928939
>      vhost-2931-2953    [013] d....   606.479997: sched_update: comm=vhost-2931 pid=2953 sev=2227949776 sed=2230928939 sel=0 avg=0 min=2227949776 cpu=13 nr=1 lag=0 lim=10000000
>      vhost-2931-2953    [013] d....   606.479998: sched_update: comm= pid=0 sev=12075560584 sed=12099393888 sel=0 avg=0 min=12075560584 cpu=13 nr=1 lag=0 lim=79999997
>      vhost-2931-2953    [013] d....   606.479998: sched_update: comm= pid=0 sev=23017816553 sed=23056927616 sel=0 avg=0 min=23017816553 cpu=13 nr=1 lag=0 lim=131282050
>      vhost-2931-2953    [013] d....   606.479998: sched_update: comm= pid=0 sev=30619573776 sed=30648907073 sel=0 avg=0 min=30619573776 cpu=13 nr=1 lag=0 lim=98461537
>      vhost-2931-2953    [013] d....   606.479998: sched_update: comm= pid=0 sev=56118241726 sed=56168252594 sel=-19883 avg=0 min=56118220659 cpu=13 nr=2 lag=-19883 lim=167868850
>      vhost-2931-2953    [013] d....   606.479999: sched_bestvnode: best: id=0 v=0 d=0 l=0 md=0 dp=131072 node: id=168 v=56118220659 d=56121220659 l=0 md=56121220659 dp=0
>      vhost-2931-2953    [013] d....   606.479999: sched_stat_wait: comm=kworker/13:1 pid=168 delay=1255 [ns]
> --> good delay of 1255 ns for the kworker
> --> depth 0 of cgroup holding vhost:     vruntime      deadline
>                          cgroup        56118241726   56168252594
>                          kworker       56118220659   56121220659


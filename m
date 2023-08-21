Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353CD782469
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 09:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjHUHX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 03:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjHUHX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 03:23:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747CBAC
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 00:23:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bf57366ccdso10116315ad.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 00:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692602636; x=1693207436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZiimQeJjZp6HSq1FLNLm7O14p/GafEFARObwGRB1dHQ=;
        b=WdSK8vCUutlgNAGsL0C+0vWktCaUYykSwW2NbFx5mYzX+s4gNWQtQiShg0VW3w9yiD
         ryKmejf5anlEvUJnRrYoOLRW9xHBrjJaRZizeloQ/BxsDe3NIiXIcHBhvUoZxTkC9Ynr
         DazUrkWlsEEUharlYKbarLAQB2wUj7n8Bzxzw/gGpGVS0i5Z/wCpyFUEPJIXrHQnYZD1
         GwrzJVctoRjC/ihK1CF282+Hkxpr8ii1vNfL6aMd+FqZ5/WiR/uWoXYChTeXgVhR6n07
         lq55GZN6jfpbXRr5IK99VqBxrzZmVOMWax9gRr8rp4xbJ45jfWquicPx6hG1H8y6rgN0
         0uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692602636; x=1693207436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiimQeJjZp6HSq1FLNLm7O14p/GafEFARObwGRB1dHQ=;
        b=ANOnZhBP1ry8phIu7iPj5HwOzRY7wyc97WxnFY4cCwHjojOG5/S2YYYFG31PG1W20z
         CsMR2m2W0R8D0CqzVUnkBksm6ltT2Bav2bqpd6o1QamxHz4pP5u0tvq3a+wKoDLLC2fb
         hUO4dLACcZf0tn3o3IwN5APcrbm0GqTZOMXPiltv/NclTf6hax6sW6aNZ32t2swrSppP
         d2myZzg4XbhKinE0TgU14SnzE3hBbxj3yapOia5dxK2F3uDBInU6sHB4i+cwnAsiyB2L
         HDuk0CedtgbiSXavxD+i/UqWe8TaINMl9mTiRjGVnOh6DE7sP3Asj5Er/zxdPKvenCBh
         tJAw==
X-Gm-Message-State: AOJu0Yze1h1GLk0ON1hzylUCncKQeTDhC0Gy7ZG5lNfxSYf9m7N2t2eu
        LLHuMZx71k6rGAlAKmW9SP4WsytqccOkjXv4
X-Google-Smtp-Source: AGHT+IFsLP4D+6bv68bbiQTjzFZ7bcOJIgHPx5O8Q087q9pKsjantK84DCy3k94EDMkiMeuutpjKtQ==
X-Received: by 2002:a17:903:1c4:b0:1b5:522a:1578 with SMTP id e4-20020a17090301c400b001b5522a1578mr8902158plh.29.1692602635782;
        Mon, 21 Aug 2023 00:23:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001b9fef7f454sm6338017plb.73.2023.08.21.00.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 00:23:55 -0700 (PDT)
Message-ID: <beec5e0e-cb35-5b54-cd46-9e68c1e6d543@gmail.com>
Date:   Mon, 21 Aug 2023 15:23:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, weijiang.yang@intel.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com, kvm@vger.kernel.org
References: <20230810054518.329117-1-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230810054518.329117-1-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 1:45 pm, Xiong Zhang wrote:
> +3. Arch PMU virtualization
> +==========================
> +
> +3.1. Overview
> +-------------
> +
> +Once KVM/QEMU expose vcpu's Arch PMU capability into guest, the guest

KVM user space (like QEMU)

> +PMU driver would access the Arch PMU MSRs (including Fixed and GP
> +counter) as the host does. All the guest Arch PMU MSRs accessing are

as expected from guest emulated capabilities (like CPUID hinted).

No need to mention "MSRs accessing are interceptable", and it's not true.

> +interceptable.

More, we need to mention here what to expect if the user space sets more PMU
capabilities than KVM can support.

> +
> +When a guest virtual counter is enabled through guest MSR writing, the
> +KVM trap will create a kvm perf event through the perf subsystem. The
> +kvm perf event's attribute is gotten from the guest virtual counter's
> +MSR setting.

This part fits the "Basic Counter Virtualization", not true for vLBR emulation.

> +
> +When a guest changes the virtual counter's setting later, the KVM trap
> +will release the old kvm perf event then create a new kvm perf event
> +with the new setting.

It's not true. Often times perf_event will be reused

Here it is also necessary to mention the life cycle management of perf_event,
such as the lazy-release mechanism in the KVM context.

> +
> +When guest read the virtual counter's count number, the kvm trap will
> +read kvm perf event's counter value and accumulate it to the previous
> +counter value.

Again, it only fits the  "Basic Counter Virtualization".

> +
> +When guest no longer access the virtual counter's MSR within a
> +scheduling time slice and the virtual counter is disabled, KVM will
> +release the kvm perf event.

The timing of the release and why needs to be explained in more detail here.

> +
> +vPMU diagram::
> +
> +  ----------------------------
> +  |  Guest                   |
> +  |  perf subsystem          |
> +  ----------------------------
> +       |            ^
> +  vMSR |            | vPMI

Try to cover RDPMC trap.

> +       v            |
> +  ----------------------------
> +  |  vPMU        KVM vCPU    |
> +  ----------------------------
> +        |          ^
> +  Call  |          | Callbacks
> +        v          |
> +  ---------------------------
> +  | Host Linux Kernel       |
> +  | perf subsystem          |
> +  ---------------------------
> +               |       ^
> +           MSR |       | PMI
> +               v       |
> +         --------------------
> +	 | PMU        CPU   |
> +         --------------------
> +

Again, it only fits the "Basic Counter Virtualization".

> +Each guest virtual counter has a corresponding kvm perf event, and the
> +kvm perf event joins host perf scheduler and complies with host perf
> +scheduler rule. When kvm perf event is scheduled by host perf scheduler
> +and is active, the guest virtual counter could supply the correct value.
> +However, if another host perf event comes in and takes over the kvm perf
> +event resource, the kvm perf event will be in error state, then the

How about case "in the INACTIVE state" ? And more:

enum perf_event_state {
	PERF_EVENT_STATE_DEAD		= -4,
	PERF_EVENT_STATE_EXIT		= -3,
	PERF_EVENT_STATE_ERROR		= -2,
	PERF_EVENT_STATE_OFF		= -1,
	PERF_EVENT_STATE_INACTIVE	=  0,
	PERF_EVENT_STATE_ACTIVE		=  1,
};

> +virtual counter keeps the saved value when the kvm perf event is preempted.
> +But guest perf doesn't notice the underbeach virtual counter is stopped, so
> +the final guest profiling data is wrong.

It is also important to mention here the impact on vPMC when a counter
is share in a multiplexing approach.

> +
> +3.2. Host and Guest perf event contention
> +-----------------------------------------
> +
> +Kvm perf event is a per-process pinned event, its priority is second.

Always use "KVM".

> +When kvm perf event is active, it can be preempted by host per-cpu
> +pinned perf event, or it can preempt host flexible perf events. Such
> +preemption can be temporarily prohibited through disabling host IRQ.
> +
> +The following results are expected when host and guest perf event
> +coexist according to perf scheduler rule:
> +1). if host per cpu pinned events occupy all the HW resource, kvm perf
> +event can not be active as no available resource, the virtual counter

Not prioritizing enough to grab limited resources.

Again, we need selftests to cover this part of the behavior, and the following.

> +value is zero always when the guest reads it.
> +2). if host per cpu pinned event release HW resource, and kvm perf event
> +is in error state, kvm perf event can claim the HW resource and switch into

I think there might be a window period here. Is the transition from
the error state to the active state done by event re-enanablement, or
by recreating perf_event, or is perf-core internally re-sched the events ?

> +active, then the guest can get the correct value from the guest virtual
> +counter during kvm perf event is active, but the guest total counter
> +value is not correct since counter value is lost during kvm perf event
> +is in error state.
> +3). if kvm perf event is active, then host per cpu pinned perf event
> +becomes active and reclaims kvm perf event resource, kvm perf event will
> +be in error state. Finally the virtual counter value is kept unchanged and
> +stores previous saved value when the guest reads it. So the guest total
> +counter isn't correct.
> +4). If host flexible perf events occupy all the HW resource, kvm perf
> +event can be active and preempts host flexible perf event resource,
> +the guest can get the correct value from the guest virtual counter.
> +5). if kvm perf event is active, then other host flexible perf events
> +request to active, kvm perf event still own the resource and active, so
> +the guest can get the correct value from the guest virtual counter.

What happens when an event of the same priority is added ?

Here we can have one table to cover all combinations.

> +
> +3.3. vPMU Arch Gaps
> +-------------------
> +
> +The coexist of host and guest perf events has gaps:
> +1). when guest accesses PMU MSRs at the first time, KVM will trap it and
> +create kvm perf event, but this event may be not active because the
> +contention with host perf event. But guest doesn't notice this and when
> +guest read virtual counter, the return value is zero.

Or historical old values.

> +2). when kvm perf event is active, host per-cpu pinned perf event can
> +reclaim kvm perf event resource at any time once resource contention

Not reclaimed at any time, but at a point in time beyond KVM's control or awareness.

That's the root of the pmu-coexistence issues.

> +happens. But guest doesn't notice this neither and guest following
> +counter accesses get wrong data.
> +So maillist had some discussion titled "Reconsider the current approach
> +of vPMU".
> +
> +https://lore.kernel.org/lkml/810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com/
> +
> +The major suggestion in this discussion is host pass-through some
> +counters into guest, but this suggestion is not feasible, the reasons
> +are:
> +a. processor has several counters, but counters are not equal, some
> +event must bind with a specific counter.
> +b. if a special counter is passthrough into guest, host can not support
> +such events and lose some capability.
> +c. if a normal counter is passthrough into guest, guest can support
> +general event only, and the guest has limited capability.
> +So both host and guest lose capability in pass-through mode.
> +

In short, any solution that statically splits pmu resources between
host and guest at run time will not survive.

But one line of thought is to completely disable the ability to host perf
from init, which we haven't tried it yet.

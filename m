Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C9E7823CE
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 08:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjHUGkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 02:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjHUGkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 02:40:03 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A265AA9
        for <kvm@vger.kernel.org>; Sun, 20 Aug 2023 23:40:01 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3a741f46fadso2419623b6e.0
        for <kvm@vger.kernel.org>; Sun, 20 Aug 2023 23:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692600001; x=1693204801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7s73kuIQHR7LO5KJQWo5RAXHWI8mJ1SQlq0R8hMo4f0=;
        b=FzeD29dInR8+HqsDpcTM7/5xo+GeiZIWDpCyrXob7dSU7QP3uq2fEif7kjsB6Tc9pL
         ZpwIPIPVxHqlDpVeKEejBu0mEgMn0GLsh5lzFZZL4uXv3qaaTE/hcvxeO2wnQDErv4bq
         xoN2bJfTGkJ3n/vDOliO4zVMzeWr6ph/z2pF2JVMhJ2TRbfxlZl1wSczaBGWqSwMaBc4
         8J0f24dLgjnPwbGD+/V+TdW5uX7aYJECD34nHv0UptHdpQWlgkj2jWoXqyUcd+WlyvMH
         PqZoInOGVwkqHs3ANLnn0Y9YPCEH5rpBbZC3/0Bxs6KbP/4zhy+BEVBQ6kL8ydYbuY/C
         f8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692600001; x=1693204801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7s73kuIQHR7LO5KJQWo5RAXHWI8mJ1SQlq0R8hMo4f0=;
        b=JFTI2zR+xb8iRtC2xkM+aKz+ft8IbagybItVfcp3HYNeVZJkna0Mjk+hSoBWJgSUCy
         l3JorAIBNcbNrYhrbWNJje8XTG2NQ3NItuwn4DW+I1OPoBwxhACeqW9N/tA1BMRP4B9t
         XRG/bRHyhreT80u1gxhWFxv33bLCU4h0ZtVfsguT/toBKrEej13sNSeQV8vwKbk8GDyw
         jknQLVc7NiLVcZyO8qrv+bjUKhkIH4EM990n3tJi3ZyBOkb2kPUPZDF7KHSgtrflUgpV
         CCvq3uKle2rePM+aCXY3YsY9FYbFcIbbmlMtFsXSA8xOCF7WrSA9xTT0owPWST1tSRhz
         h1MQ==
X-Gm-Message-State: AOJu0YwtEMjd/6YG5EKtHfR8ppGKxnCIpalxOpUh9fMWejiz+P31stNm
        yckoL5dPm9SazWROatYKVoo=
X-Google-Smtp-Source: AGHT+IGiGAHwY/3zimpnCe5Zpwub9kuqz7evKguePUifXVhf/b++TGlkpJC4Fr0gjdpAZIIwCp/PSA==
X-Received: by 2002:a05:6808:2187:b0:3a4:8590:90f2 with SMTP id be7-20020a056808218700b003a4859090f2mr10211829oib.47.1692600000958;
        Sun, 20 Aug 2023 23:40:00 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ey6-20020a056a0038c600b00686f048bb9dsm1620385pfb.74.2023.08.20.23.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Aug 2023 23:40:00 -0700 (PDT)
Message-ID: <eba07a68-893d-079b-a165-0112c33eb865@gmail.com>
Date:   Mon, 21 Aug 2023 14:39:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3] Documentation: KVM: Add vPMU implementaion and gap
 document
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, weijiang.yang@intel.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        kvm list <kvm@vger.kernel.org>
References: <20230810054518.329117-1-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230810054518.329117-1-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 1:45 pm, Xiong Zhang wrote:
> +2. Perf Scheduler Basic
> +=======================
> +
> +Perf subsystem users can not get PMU counter or resource directly, user

s/can not get/not expected to access PMU hw counters/

> +should create a perf event first and specify event’s attribute which is

eventâ€™s attribute, drop the Unicode character.

attribute --> attributes which are

> +used to choose PMU counters, then perf event joins in perf scheduler,
> +perf scheduler assigns the corresponding PMU counter to a perf event.

"Counter" is not generic enough for LBR case.

The number of perf_event is not necessarily 1:1 mapped to the number of PMU
hardware resources (such as counters) acquired either.

> +
> +Perf event is created by perf_event_open() system call::

KVM is using the perf_event_create_kernel_counter() API.

The difference between these two interfaces is worth being described here.
But generic perf scheduler behavior doesn't fit.

> +
> +    int syscall(SYS_perf_event_open, struct perf_event_attr *,
> +		pid, cpu, group_fd, flags)
> +    struct perf_event_attr {
> +	    ......
> +	    /* Major type: hardware/software/tracepoint/etc. */
> +	    __u32   type;
> +	    /* Type specific configuration information. */
> +	    __u64   config;
> +	    union {
> +		    __u64      sample_period;
> +		    __u64      sample_freq;
> +	    }
> +	   __u64   disabled :1;
> +	           pinned   :1;
> +		   exclude_user  :1;
> +		   exclude_kernel :1;
> +		   exclude_host   :1;
> +	           exclude_guest  :1;
> +	......
> +    }
> +
> +The pid and cpu arguments allow specifying which process and CPU
> +to monitor::
> +
> +  pid == 0 and cpu == -1
> +        This measures the calling process/thread on any CPU.
> +  pid == 0 and cpu >= 0
> +        This measures the calling process/thread only when running on
> +	the specified cpu.
> +  pid > 0 and cpu == -1
> +        This measures the specified process/thread on any cpu.
> +  pid > 0 and cpu >= 0
> +        This  measures the specified process/thread only when running
> +	on the specified CPU.
> +  pid == -1 and cpu >= 0
> +        This measures all processes/threads on the specified CPU.
> +  pid == -1 and cpu == -1
> +        This setting is invalid and will return an error.
> +
> +Perf scheduler's responsibility is choosing which events are active at
> +one moment and binding counter with perf event. As processor has limited

This is not rigorous at all, perf manages a lot of kernel abstractions,
and hardware pmu is just one part of it.

> +PMU counters and other resource, only limited perf events can be active
> +at one moment, the inactive perf event may be active in the next moment,
> +perf scheduler has defined rules to control these things.

Some developers often ask about the mechanics of events/counters multiplexing,
which is expect to be mentioned here for generic perf behavior.

> +
> +Perf scheduler defines four types of perf event, defined by the pid and
> +cpu arguments in perf_event_open(), plus perf_event_attr.pinned, their
> +schedule priority are: per_cpu pinned > per_process pinned
> +> per_cpu flexible > per_process flexible. High priority events can
> +preempt low priority events when resources contend.

It's not "per-process",

  *  - CPU pinned (EVENT_CPU | EVENT_PINNED)
  *  - task pinned (EVENT_PINNED)
  *  - CPU flexible (EVENT_CPU | EVENT_FLEXIBLE)
  *  - task flexible (EVENT_FLEXIBLE).

It would be nice to mention here that perf function that handles prioritization:

static void ctx_resched(struct perf_cpu_context *cpuctx,
			struct perf_event_context *task_ctx,
			enum event_type_t event_type)

I wouldn't be surprised if the comment around ctx_resched() is out of date.

> +
> +perf event type::
> +
> +  --------------------------------------------------------
> +  |                      |   pid   |   cpu   |   pinned  |
> +  --------------------------------------------------------
> +  | Per-cpu pinned       |   *    |   >= 0   |     1     |
> +  --------------------------------------------------------
> +  | Per-process pinned   |  >= 0  |    *     |     1     |
> +  --------------------------------------------------------
> +  | Per-cpu flexible     |   *    |   >= 0   |     0     |
> +  --------------------------------------------------------
> +  | Per-process flexible | >= 0   |    *     |     0     |
> +  --------------------------------------------------------
> +
> +perf_event abstract::
> +
> +    struct perf_event {
> +	    struct list_head       event_entry;
> +	    ......
> +	    struct pmu             *pmu;
> +	    enum perf_event_state  state;
> +	    local64_t              count;
> +	    u64                    total_time_enabled;
> +	    u64                    total_time_running;
> +	    struct perf_event_attr attr;
> +	    ......
> +    }
> +
> +For per-cpu perf event, it is linked into per cpu global variable
> +perf_cpu_context, for per-process perf event, it is linked into
> +task_struct->perf_event_context.
> +
> +Usually the following cases cause perf event reschedule:
> +1) In a context switch from one task to a different task.
> +2) When an event is manually enabled.
> +3) A call to perf_event_open() with disabled field of the
> +perf_event_attr argument set to 0.
> +
> +When perf_event_open() or perf_event_enable() is called, perf event
> +reschedule is needed on a specific cpu, perf will send an IPI to the
> +target cpu, and the IPI handler will activate events ordered by event
> +type, and will iterate all the eligible events in per cpu gloable
> +variable perf_cpu_context and current->perf_event_context.
> +
> +When a perf event is sched out, this event mapped counter is disabled,
> +and the counter's setting and count value are saved. When a perf event
> +is sched in, perf driver assigns a counter to this event, the counter's
> +setting and count values are restored from last saved.
> +
> +If the event could not be scheduled because no resource is available for
> +it, pinned event goes into error state and is excluded from perf
> +scheduler, the only way to recover it is re-enable it, flexible event
> +goes into inactive state and can be multiplexed with other events if
> +needed.

I highly doubt that these are internal behaviors that the perf system is designed
to do, some are, some aren't, and some have exceptions like the BTS event.

Obviously this part needs to be reviewed by more perf developers.
Trying to muddle through will only mislead more developers.

I'd much rather see those perf descriptions in the perf comments or man-pages.
 From time to time, perf core will refactor or change its internal implementations.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBB7BCDBA
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344595AbjJHKEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 06:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjJHKEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 06:04:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538DBB6;
        Sun,  8 Oct 2023 03:04:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-69101022969so3224747b3a.3;
        Sun, 08 Oct 2023 03:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696759481; x=1697364281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xIhkUz9q8zzhIbVUqPN76xFOBMPbkwp5QCawaSSPdnM=;
        b=Z7P1ZN3W6DFUN2upBkSrXW71iDrimOU+fYqipUAq+pQ/ZpnV8y/+jGbejQHoC2iIxy
         4BelL81jcjIzkXSgqs8ZVLsFW+yQ3ajbutNXqbBVl3A+w2DHV0l7V08+qlIq0nbWF/aZ
         LYanqjWx8qr07j2pzLi5q+3ArVHGsQ7IyTM5vhXaw7A8VE4jUYgzvhg7VhtYqIMfIK1G
         WYBCieZbFgkWbDbn5sSDKejOiuHYjl7tgZZUKdV93FwMa5qAygH6gQ4L80GBGuQtRn1d
         b9NQclR2VOA5kLWhTPxkxSnVydBgY03AMs+0LYnxphiLUq5Gvrh8FXrOEsjTDX48IR4E
         /zDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696759481; x=1697364281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIhkUz9q8zzhIbVUqPN76xFOBMPbkwp5QCawaSSPdnM=;
        b=gvGtmLySfiY6JjbmFocm8E/EINiSjvQDdJ60PY5UHeZX6B28HspxkyIBdoIwu46hhI
         fPWpApvoN5MI+YAsEZdyJU/V628j64I1t6qh6B+uhCiupa0pkwmx6t5yeD+3HVoYT9eH
         M8cpIFXtkjmg3d+ueG8n0gkH752PQIAlXYLcIZ0YmXaDm2o7ypGwObn4ZM/bHAqMa24F
         ft/AZdO7qbwjjudCrFwd9EG0pT2JF/1HB05PvoQIbVM/rks+AGJ+e6wdEH0LxOrVChh3
         3wduAT/Zclp0jbWCzV9hyqgb2o/yTt9soEDCl8W7yENkQPxCf+G2HQKeJsegOzsKv4Mc
         Db1g==
X-Gm-Message-State: AOJu0Yyq58MiT84SKGFCyfvMiIrovtwWuXWl20RX6lgxCqCpcQW754l6
        ENu+O7HXVkd+CPmuAusJ30A=
X-Google-Smtp-Source: AGHT+IEYr65hoJ/ii5X3srhLclDzVhqNmnkpWRJVUOQb/j0vk0xMn5Ed610TTy2GLDpCBFbIzVek1g==
X-Received: by 2002:a05:6a20:6a1a:b0:154:fb34:5f09 with SMTP id p26-20020a056a206a1a00b00154fb345f09mr15453017pzk.15.1696759480632;
        Sun, 08 Oct 2023 03:04:40 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e9-20020aa78249000000b00690f622d3cdsm4265817pfn.126.2023.10.08.03.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Oct 2023 03:04:39 -0700 (PDT)
Message-ID: <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com>
Date:   Sun, 8 Oct 2023 18:04:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <ZR3hx9s1yJBR0WRJ@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZR3hx9s1yJBR0WRJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

On 5/10/2023 6:05 am, Sean Christopherson wrote:
> So I'll add a self-NAK to the idea of completely disabling the host PMU, I think
> that would burn us quite badly at some point.

I seem to have missed a party, so allow me to add a few more comments
to better facilitate future discussions in this direction:

(1) PMU counters on TEE

The SGX/SEV is already part of the upstream, but what kind of performance
data will be obtained by sampling enclaves or sev-guest with hardware pmu
counters on host (will the perf-report show these data missing holes or
pure encrypted data), we don't have a clear idea nor have we established
the right expectations. But on AMD profiling a SEV-SNP guest is supported:

"Fingerprinting attack protection is also not supported in the current
generation of these technologies. Fingerprinting attacks attempt to
determine what code the VM is running by monitoring its access patterns,
performance counter information, etc." (AMD SEV-SNP White Paper, 2020)

(2) PMU Guest/Host Co-existence Development

The introduction of pt_mode in the KVM was misleading, leading subsequent
developers to believe that static slicing of pmu facility usage was allowed.

On user scenarios, the host/perf should treat pmu resource requests from
vCPUs with regularity (which can be unequal under the host's authority IMO)
while allowing the host to be able to profile any software entity (including
hypervisor and guest-code, including TEE code in debug mode). Functionality
takes precedence over performance.

The semantics of exclude_guest/host should be tied to the hw-event isolation
settings on the hardware interfaces, not to the human-defined sw-context.
The perf subsystem is the arbiter of pmu resource allocation on the host,
and any attempt to change the status quo (or maintenance scope) will not
succeed. Therefore, vPMU developers are required to be familiar with the
implementation details of both perf and kvm, and try not to add perf APIs
dedicated to serving KVM blindly.

Getting host and guests to share limited PMU resources harmoniously is not
particularly difficult compared to real rocket science in the kernel, so
please don't be intimidated.

(3) Performance Concern in Co-existence

I wonder if it would be possible to add a knob to turn off the perf counter
multiplexing mechanism on the host, so that in coexistence scenarios, the
number of VM exits on the vCPU would not be increased by counter rotations
due to timer expiration.

For normal counters shared between guest and host, the number of counter
msr switches requiring a vm-entry level will be relatively small.
(The number of counters is growing; for LBR, it is possible to share LBR
select values to avoid frequent switching, but of course this requires the
implementation of a software filtering mechanism when the host/guest read
the LBR records, and some additional PMI; for DS-based PEBS, host and guest
PEBS buffers are automatically segregated based on linear address).

There is a lot of room for optimisation here, and in real scenarios where
triggering a large number of register switches in the host/guest PMU is
to be expected and observed easily (accompanied by a large number of pmi
appearances).

If we are really worried about the virtualisation overhead of vPMU, then
virtio-pmu might be an option. In this technology direction, the back-end
pmu can add more performance events of interest to the VM (including host
un-core and off-core events, host-side software events, etc.) In terms of
implementation, the semantics of the MSRLIST instruction can be re-used,
along with compatibility with the different PMU hardware interfaces on ARM
and Risc-v, which is also very friendly to production environments based on
its virtio nature.

(4) New vPMU Feature Development

We should not put KVM's current vPMU support into maintenance-only mode.
Users want more PMU features in the guest, like AMD vIBS, Intel pmu higher
versions, Intel topdown and Arch lbr, more on the way. The maturity of
different features' patch sets aren't the same, but we can't ignore these
real needs because of available time for key maintainers, apathy towards
contributors, mindset avoidance and laziness, and preference for certain
technology stacks. These technical challenges will attract an influx of
open source heroes to push the technology forward, which is good in the
long run.

(5) More to think about

Similar to the guest PMU feature, the debugging feature may face the same
state. For example, what happens when you debug code inside the host and
guest at the same time (host debugs hypevisor/guest code and guest debugs
guest code only) ?

Forgive my ignorance and offence, but we don't want to see a KVM subsystem
controlled and driven by Google's demands.

Please feel free to share comments to move forward.

Thanks,
Like Xu

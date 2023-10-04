Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B1F7B9720
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjJDWGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 18:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjJDWGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 18:06:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7093FD7
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 15:06:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d84acda47aeso433456276.3
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 15:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696457160; x=1697061960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQhr64Gt8dKyHZjOzMcheFeKf4AHIRHG09SiFUQfy3g=;
        b=fzdBXODevY/Q3gIWKFCdoVcO9SGfxtkiGP37f+mR5qKBcufPII7Y9XDYfwsHPuAemX
         eqPiNW9os3uQ4MDVaL04sMwGlhzeOS8WbL6z2RmTdiuAqkMeXyAKZh7HjWBcfazWzDbM
         iohmEcSKia7Wh7NeYWXImcjh0ripNjWgO4Z47KV5yNUPWvc1awLFXQ52LPps81S4eHh5
         bGWf0Ug0Woc9q5f3QA1jpbGknb1hK+HRgyWNAxLl4mGWUwo5wVnIUloCMVVQTE8zKKc5
         JdYTYPW93EuI+xGT9KuBgaGCFl/tN2LuJ8bqS6H+5Jq+Oj7qJxP/MpjSon1oUgBa/9/S
         ik+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696457160; x=1697061960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQhr64Gt8dKyHZjOzMcheFeKf4AHIRHG09SiFUQfy3g=;
        b=DPuTBbRmaqM5Y2yk5/5q6zx6dJemOQRws69F5nN4kgC+wSNvyWwv6LlvroJ0hTRlSQ
         XSSO9p4x7KfbeypS07E3ucxlfwipPI2WzeO7rakmTcyRCVmsYOR/I3mmfkCpA1Z8QDg3
         OFWFFW+htvXeRsCV02xMDyPJxOCgfhwe3bKVA6k5mZUmGTuU2yjd7NsrJMG7b7VEWgoG
         4OWd5AHPsnWjEymiCB2v32NcsLZ46av8bw5cshIBL8mjO9u9qN8W35ITnIYEmaB3pY0v
         HopUL6gf6YBfjv7EFwLrSLqnBTTTxYbLpoVSFhtIwj/NglcoAoOFHKNnzoMibP2fznnI
         LeJA==
X-Gm-Message-State: AOJu0Yy6RrOTuoGvXlctiW+ffvFRbo040L1yPncP+48qm/qCAI4Wl74R
        dTeJl2or3G77SQrJkFe47yt6oXPv7s8=
X-Google-Smtp-Source: AGHT+IHH7NjbwhwW4+NO0g7zeY04sTLxW9j5SbKQaY4wvrnVGWvxS+MDJv/NzzkAEBxTE44icmyJ25+CXGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f01:0:b0:d77:f7c3:37db with SMTP id
 t1-20020a255f01000000b00d77f7c337dbmr62293ybb.8.1696457160665; Wed, 04 Oct
 2023 15:06:00 -0700 (PDT)
Date:   Wed, 4 Oct 2023 15:05:59 -0700
In-Reply-To: <ZR3eNtP5IVAHeFNC@google.com>
Mime-Version: 1.0
References: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net> <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net> <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net> <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com>
Message-ID: <ZR3hx9s1yJBR0WRJ@google.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
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
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, Sean Christopherson wrote:
> Thinking about this more, what if we do a blend of KVM's FPU swapping and debug
> register swapping?
> 
>   A. Load guest PMU state in vcpu_enter_guest() after IRQs are disabled
>   B. Put guest PMU state (and load host state) in vcpu_enter_guest() before IRQs
>      are enabled, *if and only if* the current CPU has one or perf events that
>      wants to use the hardware PMU
>   C. Put guest PMU state at vcpu_put()
>   D. Add a perf callback that is invoked from IRQ context when perf wants to
>      configure a new PMU-based events, *before* actually programming the MSRs,
>      and have KVM's callback put the guest PMU state
> 
> If there are host perf events that want to use the PMU, then KVM will swap fairly
> aggressively and the "downtime" of the host perf events will be limited to the
> small window around VM-Enter/VM-Exit.
> 
> If there are no such host events, KVM will swap on the first entry to the guest,
> and keep the guest PMU loaded until the vCPU is put.
> 
> The perf callback in (D) would allow perf to program system-wide events on all
> CPUs without clobbering guest PMU state.
> 
> I think that would make everyone happy.  As long as our hosts don't create perf
> events, then we get the "swap as little as possible" behavior without significantly
> impacting the host's ability to utilize perf.  If our host screws up and creates
> perf events on CPUs that are running vCPUs, then the degraded vCPU performance is
> on us.
> 
> Rough sketch below, minus the perf callback or any of actual swapping logic.

Another reason to go for an approach that doesn't completely kill off host PMU
usage: just because we don't plan on enable perf events in *production*, there
will undoubtedly be times where we want to enable perf events to debug issues
(outside of prod) in the host kernel/KVM that affect VMs with a passthrough PMU.

So I'll add a self-NAK to the idea of completely disabling the host PMU, I think
that would burn us quite badly at some point.

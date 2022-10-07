Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA35F7C62
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiJGRkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJGRkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:40:23 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E301ED7E24
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:40:21 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s10so6523622ljp.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/qyZfhFMqsGY+2x81lxkw4SeGXVJxcXp72bwU6csGYs=;
        b=TKGR1uQTGER1ZWKJGAM+dHVm1xLKYwU2Zk88DPGtKUPt+8WfU45u1WPdxzZ9+gtzpl
         4a7uHdIzCiVkZcr6/QIrcaDXYL9Pvxg3EMiNWl9A4t4BxW5jxTqWdBa2m3K8WkrY7x0d
         RGfsLni2dEJJzRBP2AneWh7JJg7Ai+Ppoxv+/3wMw4/tgMRRe0uMb1CKGQfkeVo/7iHD
         6JztSiF3O9rLBFGcnhy1LMT5dav76J1oYC3iurdfJq+tCgy8uw5APMXku3kdN2IbKF47
         qu1jjC2EmVMFMJ6CRXIZprsUACsHUSeVYDgj3xEGPLd0GkyohxFc+TEVqzrMc75ejmoj
         yrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/qyZfhFMqsGY+2x81lxkw4SeGXVJxcXp72bwU6csGYs=;
        b=Oea8DVbr1Ab8ziXggof6MweFMQ8qO8i6S7q9rKqcAurKZUiK/RDY3VyAIKNEG+xioR
         RVc/0hJpSywVTqgijC1m+azIe+QETHYTE7KDfhv9ww//BBjf/Bsh/L2pwsZV+iifycwl
         7dF2Aa+gYUUgvOsNd/g4IeOToq/arAoXH4tgLCLCvQERvpGzdb/atLzmMTJasIUi4k6/
         yHpg7gsnj7T+miXL+b1qXQUi/7k4mslk2dsst0CIGXPWv4/P27NaAiTT0UEgM/lYQHvg
         JtAOGuzZV3MlWzi9Ugl183BbbOmSC/lTLjMvL9/i34QmHKbzaJNMX/zUUHxGuakAz/4e
         sjXA==
X-Gm-Message-State: ACrzQf10/xU/bDa0QSHtQCmZtIWIoOuvQ1oJTumSTVlbMPgFP+N2JWD6
        OMSzsPUWAVnvhKU5ZzULXCMLshUszy4OC07KKzntPg==
X-Google-Smtp-Source: AMsMyM7sCgTfoIcnsRjFd8b/qqibflc1XJSea0Wdh9/guDuPfxt95cCHHpxfsEaF9/Ne4FIJS5o5vJN949fy40KyiM8=
X-Received: by 2002:a2e:aa20:0:b0:26e:609:cf08 with SMTP id
 bf32-20020a2eaa20000000b0026e0609cf08mr2038925ljb.422.1665164420071; Fri, 07
 Oct 2022 10:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com> <20221006171133.372359-5-vipinsh@google.com>
 <Yz8xdJEMjcfdrcWC@google.com> <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
 <Yz9vdoiq+0TyaGqo@google.com>
In-Reply-To: <Yz9vdoiq+0TyaGqo@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 7 Oct 2022 10:39:43 -0700
Message-ID: <CAHVum0duCPZSqDcT2L0uupvMB0uGe31Oh-DSpojAnBLFN1d1XQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 5:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 06, 2022, Vipin Sharma wrote:
> > On Thu, Oct 6, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > +{
> > > > +     cpu_set_t cpuset;
> > > > +     int err;
> > > > +
> > > > +     CPU_ZERO(&cpuset);
> > > > +     CPU_SET(pcpu, &cpuset);
> > >
> > > To save user pain:
> > >
> > >         r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
> > >         TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
> > >                     strerror(errno));
> > >
> > >         TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
> > >                     "Task '%d' not allowed to run on pCPU '%d'\n");
> > >
> > >         CPU_ZERO(&allowed_mask);
> > >         CPU_SET(cpu, &allowed_mask);
> > >
> > > that way the user will get an explicit error message if they try to pin a vCPU/task
> > > that has already been affined by something else.  And then, in theory,
> > > sched_setaffinity() should never fail.
> > >
> > > Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
> > > unnecessarily complex.
> > >
> >
> > sched_setaffinity() doesn't fail when we assign more than one task to
> > the pCPU, it allows multiple tasks to be on the same pCPU. One of the
> > reasons it fails is if it is provided a cpu number which is bigger
> > than what is actually available on the host.
> >
> > I am not convinced that pinning vCPUs to the same pCPU should throw an
> > error. We should allow if someone wants to try and compare performance
> > by over subscribing or any valid combination they want to test.
>
> Oh, I'm not talking about the user pinning multiple vCPUs to the same pCPU via
> the test, I'm talking about the user, or more likely something in the users's
> environment, restricting what pCPUs the user's tasks are allowed on.  E.g. if
> the test is run in shell that has been restricted to CPU8 via cgroups, then
> sched_setaffinity() will fail if the user tries to pin vCPUs to any other CPU.

I see, I will add this validation.

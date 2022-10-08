Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669345F81A7
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 02:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJHArM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 20:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiJHArK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 20:47:10 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916B2923FE
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 17:47:07 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f37so9403464lfv.8
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 17:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p7KMiKmygQljdaDze+1Mi5dSyi76bw3K5QTxXbuEomg=;
        b=FwJC73g7hln2Woi+OdqsgomZb1YT6HDjlJtR0dHZDJKg4T4xoc5flWGZSuL09O2SHY
         EggpVgmlGO68sqS95xEI4UDUSy9nocvp3ASQORU8zgpyQ/x/emSMYsyUYHVGcQDpbP4V
         Jw7f/KA8QMoK1EYoKUs8pwOTcizZSq6C4+DzcZVDVpygIq6isc8e5D8vtGW1+0uGNOZN
         fXRRqpM3vHT/EdUSQC8j5/bEV5I5/L4jvukacbP2nxfWjiGhuu129b1OfLg148hkjxFh
         Bi051ku+vXBrWt+h9OseDpsnzrhoCx+JlOmjgnnicUIGyJD8jQLnVssRG/Wy8psaWMFZ
         R8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p7KMiKmygQljdaDze+1Mi5dSyi76bw3K5QTxXbuEomg=;
        b=QHGEbXX7V20yyLBB9JDL3rXjqZ5qOSTCDgV86RoCgs/tuUTvdmcZYf77HAMaq/g3s4
         HAhOnRg+VseS7pPwog4czmmNua60uxOzKbcuWmTaurwLfgkEVn42xCauKjn0w90I7kpd
         kmA4Gm7b9TYmpo06nbomPoom9EVJiXPjVFHIB3o3udoVqyDeDtAIARr8g/W5yILTKWvn
         YQDotY455lYkYxV6AfmRjkXT5YlEGxPrsv62s2nCDuJRyWExcnhjPy43uvn0AajHORri
         HYhdZW+OrnGHuLReRS9PwDIamo+43BmAUNezMDiVs2xP7fxAObOngCsFryqjeUzhFINC
         GMrw==
X-Gm-Message-State: ACrzQf3/bFHueHYjF/qv9wljsCGQM08lMHeiOBsepu7ueg/Tt1nvAr2/
        Q3M/6mZgMys6pdUDgCesxV1FgnzxspOm+EnmIwwB0Qz67AGctA==
X-Google-Smtp-Source: AMsMyM64qzh4cdRvUydaeoSPr1Eur/9lKKt+EIT0/wUB2PNNfV9bRheVITft4fI6c7Zc1FYl6XnzgnS4GortN5iKvUY=
X-Received: by 2002:ac2:5cd1:0:b0:4a2:291a:9460 with SMTP id
 f17-20020ac25cd1000000b004a2291a9460mr2636611lfq.203.1665190025651; Fri, 07
 Oct 2022 17:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com> <20221006171133.372359-5-vipinsh@google.com>
 <Yz8xdJEMjcfdrcWC@google.com> <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
 <Yz9vdoiq+0TyaGqo@google.com> <CAHVum0duCPZSqDcT2L0uupvMB0uGe31Oh-DSpojAnBLFN1d1XQ@mail.gmail.com>
In-Reply-To: <CAHVum0duCPZSqDcT2L0uupvMB0uGe31Oh-DSpojAnBLFN1d1XQ@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 7 Oct 2022 17:46:29 -0700
Message-ID: <CAHVum0ehcP_tn_7g5RP6HAd8cr50DfHO2H+i_UnjyKE8NJrn7Q@mail.gmail.com>
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

On Fri, Oct 7, 2022 at 10:39 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Thu, Oct 6, 2022 at 5:14 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Oct 06, 2022, Vipin Sharma wrote:
> > > On Thu, Oct 6, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > +{
> > > > > +     cpu_set_t cpuset;
> > > > > +     int err;
> > > > > +
> > > > > +     CPU_ZERO(&cpuset);
> > > > > +     CPU_SET(pcpu, &cpuset);
> > > >
> > > > To save user pain:
> > > >
> > > >         r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
> > > >         TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
> > > >                     strerror(errno));
> > > >
> > > >         TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
> > > >                     "Task '%d' not allowed to run on pCPU '%d'\n");
> > > >
> > > >         CPU_ZERO(&allowed_mask);
> > > >         CPU_SET(cpu, &allowed_mask);
> > > >
> > > > that way the user will get an explicit error message if they try to pin a vCPU/task
> > > > that has already been affined by something else.  And then, in theory,
> > > > sched_setaffinity() should never fail.
> > > >
> > > > Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
> > > > unnecessarily complex.
> > > >
> > >
> > > sched_setaffinity() doesn't fail when we assign more than one task to
> > > the pCPU, it allows multiple tasks to be on the same pCPU. One of the
> > > reasons it fails is if it is provided a cpu number which is bigger
> > > than what is actually available on the host.
> > >
> > > I am not convinced that pinning vCPUs to the same pCPU should throw an
> > > error. We should allow if someone wants to try and compare performance
> > > by over subscribing or any valid combination they want to test.
> >
> > Oh, I'm not talking about the user pinning multiple vCPUs to the same pCPU via
> > the test, I'm talking about the user, or more likely something in the users's
> > environment, restricting what pCPUs the user's tasks are allowed on.  E.g. if
> > the test is run in shell that has been restricted to CPU8 via cgroups, then
> > sched_setaffinity() will fail if the user tries to pin vCPUs to any other CPU.
>
> I see, I will add this validation.

I think we should drop this check. Current logic is that the new
function perf_test_setup_pinning() parses the vcpu mappings, stores
them in perf_test_vcpu_args{} struct and moves the main thread to the
provided pcpu. But this causes TEST_ASSERT(CPU_ISSET...) to fail for
vcpu threads when they are created because they inherit task affinity
from the main thread which has the pcpu set during setup.

However, this affinity is not strict, so, if TEST_ASSERT(CPU_ISSET...)
is removed then vcpu threads successfully move to their required pcpu
via sched_setaffinity() even though the main thread has different
affinity. If cpus are restricted via cgroups then sched_setaffinity()
fails as expected no matter what.

Another option will be to split the API, perf_test_setup_pinning()
will return the main thread pcpu and dirty_log_perf_test can call
pin_this_task_to_cpu() with the returned pcpu after vcpus have been
started. I do not like this approach, I also think
TEST_ASSERT(CPU_ISSET...) is not reducing user pain that much because
users can still figure out with returned errno what is happening.

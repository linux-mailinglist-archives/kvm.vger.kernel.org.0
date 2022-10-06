Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE795F71BC
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 01:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiJFX0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 19:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJFX0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 19:26:10 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFB0BBE22
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 16:26:09 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m14so3931144ljg.2
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 16:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mV9Q8TxTnZx5YN34R7SUXMVFq34AMSjPHpiLz7F3AAE=;
        b=Jof8LQIU/LTuSSP8IlLOJPBNTJHtoMtM4OCWw8V1VoKbuCusd4xVtpujTiPT8afnee
         nTlskKM4P3VaniKgPk3WpNFloS+8fkySpc1bOdHqtcMd1dW830VlZuNe4woPoTqywiSA
         bb/yVRjeb9lzQvfm/xJBL4vwjZy8/MOQI1GaoUUlj9k8SAo3Hc8qyxuxH0n6381BKmVt
         07mG4mibyTyFYEul/6qXEW+rwhVKVJor7+IjQq/ae7H/83nbYl33YedC0Lka1M91VddC
         qGdaJ519jZLxMn/yBCCclfxMc6aBkqK142cDYorwp+Y/39aFGbaK+5xC02QZCkdofsLR
         jVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mV9Q8TxTnZx5YN34R7SUXMVFq34AMSjPHpiLz7F3AAE=;
        b=rC0vYywQYRYNxvyHpM5nwCyvh3G0tNlKqNtsNXrBXxWscbGf0DL5XRAC3BBDV9KIII
         Py3lFM1f1V5OJqcGu+x2rzOxNK/bmG25xDGd8OsDDi7rHAVLsP1gUqpo4vU60sXtB+Dm
         28uiJT+ucYzxnsBbV4NsAtAwrx7Ube4LlgVK5LiaFKpSJ1nbIzsmxjaouSVrqzERsmGM
         GF1CW2d2FPUC92DWSbVyKofdsXbMEzsMJqATO9Q/f4pkk0G5kA73DURTrFH+xUPXwM47
         TMDK1VfE31e9mxULpfeTIFk70KcVR8I2aAWZe4Zyjwg7pr9bJpcdcWKK4woI7rriMTqW
         B4/g==
X-Gm-Message-State: ACrzQf3R/T5VwIg+ZJJPoU3rgi1ZRccYHaT0GHGLiTSyJDKb/NitecR+
        vGs/1uZYffYakUGpMFLTF5SZaF1tDyjDszTU0WiMFA==
X-Google-Smtp-Source: AMsMyM4Bsu70blXGXiZx0d4DQ3MtJDtM6pfc4RygLl3vlfkNLKFvVBBszLm918fiUVz4Nmnpp8s3Ox0KB5jtzGZLrXI=
X-Received: by 2002:a2e:aa20:0:b0:26e:609:cf08 with SMTP id
 bf32-20020a2eaa20000000b0026e0609cf08mr669552ljb.422.1665098767843; Thu, 06
 Oct 2022 16:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com> <20221006171133.372359-5-vipinsh@google.com>
 <Yz8xdJEMjcfdrcWC@google.com>
In-Reply-To: <Yz8xdJEMjcfdrcWC@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 6 Oct 2022 16:25:31 -0700
Message-ID: <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 06, 2022, Vipin Sharma wrote:
> ...
>
> > +static void pin_me_to_pcpu
>
> Maybe s/me/this_task ?

Sure.

>
> > (int pcpu)
>
> Unless we're using -1 as "don't pin" or "invalid", this should be an unsigned value.
>
> > +{
> > +     cpu_set_t cpuset;
> > +     int err;
> > +
> > +     CPU_ZERO(&cpuset);
> > +     CPU_SET(pcpu, &cpuset);
>
> To save user pain:
>
>         r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
>         TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
>                     strerror(errno));
>
>         TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
>                     "Task '%d' not allowed to run on pCPU '%d'\n");
>
>         CPU_ZERO(&allowed_mask);
>         CPU_SET(cpu, &allowed_mask);
>
> that way the user will get an explicit error message if they try to pin a vCPU/task
> that has already been affined by something else.  And then, in theory,
> sched_setaffinity() should never fail.
>
> Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
> unnecessarily complex.
>

sched_setaffinity() doesn't fail when we assign more than one task to
the pCPU, it allows multiple tasks to be on the same pCPU. One of the
reasons it fails is if it is provided a cpu number which is bigger
than what is actually available on the host.

I am not convinced that pinning vCPUs to the same pCPU should throw an
error. We should allow if someone wants to try and compare performance
by over subscribing or any valid combination they want to test.

...

> > +static int pcpu_num(const char *cpu_str)
> > +{
> > +     int pcpu = atoi_paranoid(cpu_str);
>
> newline after declaration.  Though maybe just omit this helper entirely?  As a
> somewhat belated thought, it's trivial to let "-1" mean "don't pin this vCPU".
> No idea if there's a use case for that, but it's not any more work to support.
>
> Even if <0 is invalid, what about just having pin_task_to_pcu() do all the
> sanity checking?  That way it's more obvious that that helper isn't failing to
> sanity check the incoming value.
>

This will go away with atoi_non_negative() API I will write in v5. I
won't even need this function then.

...

> > +     while (cpu && i < nr_vcpus) {
> > +             perf_test_args.vcpu_args[i++].pcpu = pcpu_num(cpu);
> > +             cpu = strtok(NULL, delim);
> > +     }
> > +
> > +     TEST_ASSERT(i == nr_vcpus,
> > +                 "Number of pcpus (%d) not sufficient for the number of vcpus (%d).",
> > +                 i, nr_vcpus);
>
> Rather than assert after the fact, use a for-loop:
>
>         for (i = 0; i < nr_vcpus; i++ {
>                 TEST_ASSERT(cpu, "pCPU not provided for vCPU%d\n", i);
>                 perf_test_args.vcpu_args[i++].pcpu = atoi_paranoid(cpu);
>                 cpu = strtok(NULL, delim);
>         }
>
> so as to avoid having to consume the loop control variable before and after the
> loop.  Or even
>
>         for (i = 0, cpu = strtok(cpu_list, delim);
>              i < nr_vcpus;
>              i++, cpu = strtok(NULL, delim)) {
>                 TEST_ASSERT(cpu, "pCPU not provided for vCPU%d\n", i);
>                 perf_test_args.vcpu_args[i++].pcpu = atoi_paranoid(cpu);
>         }
>
> Though IMO the latter is gratuitous and hard to read.
>

I will use the former one.

> > +
> > +     perf_test_args.pin_vcpus = true;
> > +
> > +     // 2. Check if main worker is provided
> > +     if (cpu)
> > +             pin_me_to_pcpu(pcpu_num(cpu));
>
> Verify the string is now empty?  I.e. that there isn't trailing garbage.
>

Okay, I will add the verification.

All other suggestions to which I haven't responded, I agree with them
and will make the changes in v5.

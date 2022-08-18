Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09C1598AC7
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiHRR6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344153AbiHRR6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:58:44 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93B9C0B46
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:58:41 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id n24so385137ljc.13
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=WNfjFt9m9xPrC6sMtqNFXjJdIECd9U1HI5Wb3V+wx4o=;
        b=FAZ1Ob+rhfUlGNvVJ57i7sIbExAWg5Ly7qnaPm1VfM7fdaOLZyCCKgokgVpfouzF3p
         /Xfi9wV2R2TEhwtmjzoiCgnzNJTDBcDaAIc+lKDme1LPglCnZV2oYzszTZ31G2tntFJi
         0wqIbRMjqFbhr4cIEMyPR33y30vx/sMNczAGqniQyFmZXU6D4vKA6ReJ7L1Q9LJh9ikU
         ZY4nMDc9CTgPSUXNechHQk4hu/Nsso99VtJtHpNBEUSVLUQS82NQ3awZbJwRV4VE2PIu
         wTse0wNBD/0uwHNIeRx5gC+1KQBg9Xk37/xrpJyMfFynB2Fk8hUMHlJ6Hnwh/KlFBMU1
         b5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=WNfjFt9m9xPrC6sMtqNFXjJdIECd9U1HI5Wb3V+wx4o=;
        b=TI8d/U5yaYWonN6SE5XLFyPbe/XG4kncYXlDWi5nlYu1ZnTzHvLRabvBlnKh1dzo9t
         gK2Og0Xoggl5iML3IUujgDP0hbylHlqtmBna6V8k9q4BRPyLb5dfZYddekuSMq3czR3+
         /1wYLK6gqBLyA1F/u4reRlmhig0VXjujmYeGU5BYDH7yzwKUHVVD+cvjUKx9yj+xNvpQ
         E5G0diQ3soHi6V05yiO1kTA2/zJE1V1DdiQNaFNWWcDtRAnYNZDG404ejn7rXbHxrhQJ
         b+6bXpJfKSufjhrcSjFViSTBEAed3Tm5GdNYDW7I/GKu+ZXsmEBCWVHNiJ6yaaWCKVhs
         SJIQ==
X-Gm-Message-State: ACgBeo28C+FE2kzDALUHdW4N4LcBEhZ+vVO07DeRT/XqCs54X8NnVM9P
        ZoBEBdNy90zDrjOMVSPZ+Gwm8mM0Bvu8LNMA5xVVNg==
X-Google-Smtp-Source: AA6agR5JQV/VYQZk1/zJsIXbRAgRBXF+HQIVTf6BSJMQFgfBO9W2E/zmGk3XBpkuTRAtm9arB3OZpHK5nLPhavEgNuE=
X-Received: by 2002:a2e:84ca:0:b0:25d:77e0:2566 with SMTP id
 q10-20020a2e84ca000000b0025d77e02566mr1251066ljh.78.1660845519988; Thu, 18
 Aug 2022 10:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220817152956.4056410-1-vipinsh@google.com> <Yv0kRhSjSqz0i0lG@google.com>
 <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com> <Yv1ds4zVCt6hbxC4@google.com>
In-Reply-To: <Yv1ds4zVCt6hbxC4@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 18 Aug 2022 10:58:03 -0700
Message-ID: <CAHVum0dJBwtc5yNzK=n2OQn8YZohTxgFST0XBPUWweQ+KuSeWQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 2:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 17, 2022, Vipin Sharma wrote:
> > On Wed, Aug 17, 2022 at 10:25 AM Sean Christopherson <seanjc@google.com> wrote:

> > We need error checking here to make sure that the user really wants
> > cpu 0 and it was not a mistake in typing.
> > I was thinking of using parse_num API for other places as well instead
> > of atoi() in dirty_log_perf_test.
>
> Yes, definitely.  And maybe give it a name like atoi_paranoid()?

Lol. Absolutely, if that's what you want!

>
> > Yeah, it was either my almost duplicate functions or have the one
> > function do two things via if-else.  I am not happy with both
> > approaches.
> >
> > I think I will pass an integer array which this parsing function will
> > fill up and return an int denoting how many elements were filled. The
> > caller then can use the array as they wish, to copy it in
> > vcpu_to_lcpu_map or cpuset.
>
> Eh, I doubt that'll be a net improvement, e.g. the CPUSET case will then need to
> re-loop, which seems silly.  If the exclusive cpuset vs. array is undesirable, we
> could have the API require at least one instead of exactly one, i.e.
>
>         TEST_ASSERT(cpuset || vcpu_map);
>
>         ...
>
>                 cpu = atoi(cpustr);
>                 TEST_ASSERT(cpu >= 0, "Invalid cpu number: %d\n", cpu);
>                 if (vcpu_map)
>                         vcpu_map[i++] = cpu;
>                 if (cpuset)
>                         CPU_SET(cpu, cpuset);
>
> If we somehow end up with a third type of destination, then we can revisit this,
> but that seems unlikely at this point.
>

I am removing the -d option, so this is not needed anymore.


> > > I wonder if we should make -c and -d mutually exclusive.  Tweak -c to include the
> > > application thread, i.e. TEST_ASSERT(nr_lcpus == nr_vcpus+1) and require 1:1 pinning
> > > for all tasks.  E.g. allowing "-c ..., -d 0,1,22" seems unnecessary.
> > >
> >
> > One downside I can think of will be if we add some worker threads
> > which are not vcpus then all of those threads will end up running on a
> > single cpu unless we edit this parsing logic again.
>
> But adding worker threads also requires a code change, i.e. it won't require a
> separate commit/churn.  And if we get to the point where we want multiple workers,
> it should be relatively straightforward to support pinning an arbitrary number of
> workers, e.g.
>
>         enum memtest_worker_type {
>                 MAIN_WORKER,
>                 MINION_1,
>                 MINION_2,
>                 NR_MEMTEST_WORKERS,
>         }
>
>
>         TEST_ASSERT(nr_lcpus == nr_vcpus + NR_MEMTEST_WORKERS);
>
> void spawn_worker(enum memtest_worker_type type, <function pointer>)
> {
>         cpu_set_t cpuset;
>
>         CPU_ZERO(&cpuset);
>         CPU_SET(task_map[nr_vcpus + type], &cpuset);
>
>         <set affinity and spawn>
> }
>
> > Current implementation gives vcpus special treatment via -c and for
> > the whole application via -d. This gives good separation of concerns
> > via flags.
>
> But they aren't separated, e.g. using -d without -c means vCPUs are thrown into
> the same pool as worker threads.  And if we ever do add more workers, -d doesn't
> allow the user to pin workers 1:1 with logical CPUs.
>
> Actually, if -c is extended to pin workers, then adding -d is unnecessary.  If the
> user wants to affine tasks to CPUs but not pin 1:1, it can do that with e.g. taskset.
> What the user can't do is pin 1:1.
>
> If we don't want to _require_ the caller to pin the main worker, then we could do
>
>         TEST_ASSERT(nr_lcpus >= nr_vcpus &&
>                     nr_lcpus <= nr_vcpus + NR_MEMTEST_WORKERS);
>
> to _require_ pinning all vCPUs, and allow but not require pinning non-vCPU tasks.

Okay, I will remove -d and only keep -c. I will extend it to support
pinning the main worker and vcpus. Arguments to -c will be like:
<main woker lcpu>, <vcpu0's lcpu>, <vcpu1's lcpu>, <vcpu2's lcpu>,...
Example:
./dirty_log_perf_test -v 3 -c 1,20,21,22

Main worker will run on 1 and 3 vcpus  will run on logical cpus 20, 21 and 22.

Sounds good?

Thanks
Vipin

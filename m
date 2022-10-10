Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738EB5FA1CD
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJJQW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 12:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJJQW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 12:22:57 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2AB74E33
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:22:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l6so1125272pgu.7
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=30TR2CuJwPKOrCv4Q4hSO7C7sSGvC6dl7aUHvvqXm3c=;
        b=FjLxiVSUL2y9i9fMEJjfCmJNNoOYicc/cmhjc6b8/Ku7yRj5iYVp2upvLJeJll1cmS
         q12dOZoJidPP+41lBNJ5NZP0ThhYlWC0vs5qs9WlddfMOPcvswSkWWpiWYnRNjn4W1x5
         5J70Gy4Qyu4dCKahWBw3cufCOEraFw8+qqRpNngsTBJ9pMD/SlxCBjK9XVNDW4E8c8Sx
         6CTVOyqQW2/wyMMs9Vc5oHvPoEhu/qE89rWV73d7jmhnShvp2l9C6rbB8qErLyP3Y77A
         nFPtZNHxhV+qkaXTDTPbS4u6J224hqGMSEtetHVGAJYxQ81oCfHXlz3QLZlivQg5KKqT
         hwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30TR2CuJwPKOrCv4Q4hSO7C7sSGvC6dl7aUHvvqXm3c=;
        b=Fm6vL5NPDgh4N+gBJTQmR+NEg73cPO+LLXfgHA10U7+hLDZ1d/WOK0Rf3hwhzKhj6o
         kqEuzrBXCjqilrlABYEnd4qElX/cFY0MZpb++bHVEmMRj4EIaxWXwLjcmgV0SBqvV1O5
         40qW6mA61QaZIBzRu0Fvjbl9KB07rhmwfXT3N1JPd6qmmkru9Sa/rlk89Z0HAwSYs8Dz
         yybDbcuC3/2V/6kirtc7Z+Jd//hR2eQdQdgLTdB7bxGyZ1kNOJfitjxcvBwgBj1TG8sL
         16ricZwd7DZEHU6tPgsCddDNeZBICj84MajLRbPA5i5KqjTODbJyrBD/pt3310K3ys0m
         kcUA==
X-Gm-Message-State: ACrzQf1oVE1uAuBcAtDYpATbVGK4PEG7CW0FTR7X4dsVAG5n43b1IQwi
        bVpFqpOSC7hjhpZ3AeOrM0ALrA==
X-Google-Smtp-Source: AMsMyM67dcWfpVNAdU0+n9+wJDsn82BpzpG9pDlhh6wbr2SN0F47b1hnKIAnTMNVRJoBNj6z0SjByA==
X-Received: by 2002:a05:6a00:230f:b0:53e:2c2c:5c03 with SMTP id h15-20020a056a00230f00b0053e2c2c5c03mr20768734pfh.11.1665418975635;
        Mon, 10 Oct 2022 09:22:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o39-20020a17090a0a2a00b001f262f6f717sm9467872pjo.3.2022.10.10.09.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 09:22:55 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:22:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
Message-ID: <Y0RG2w9cHn01Af41@google.com>
References: <20221006171133.372359-1-vipinsh@google.com>
 <20221006171133.372359-5-vipinsh@google.com>
 <Yz8xdJEMjcfdrcWC@google.com>
 <CAHVum0e4fiaB7hGSA6z1SaiZ1632f9Md2p0Nw6G=5wqhHYvdJg@mail.gmail.com>
 <Yz9vdoiq+0TyaGqo@google.com>
 <CAHVum0duCPZSqDcT2L0uupvMB0uGe31Oh-DSpojAnBLFN1d1XQ@mail.gmail.com>
 <CAHVum0ehcP_tn_7g5RP6HAd8cr50DfHO2H+i_UnjyKE8NJrn7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0ehcP_tn_7g5RP6HAd8cr50DfHO2H+i_UnjyKE8NJrn7Q@mail.gmail.com>
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

On Fri, Oct 07, 2022, Vipin Sharma wrote:
> On Fri, Oct 7, 2022 at 10:39 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Thu, Oct 6, 2022 at 5:14 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Oct 06, 2022, Vipin Sharma wrote:
> > > > On Thu, Oct 6, 2022 at 12:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > +{
> > > > > > +     cpu_set_t cpuset;
> > > > > > +     int err;
> > > > > > +
> > > > > > +     CPU_ZERO(&cpuset);
> > > > > > +     CPU_SET(pcpu, &cpuset);
> > > > >
> > > > > To save user pain:
> > > > >
> > > > >         r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
> > > > >         TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
> > > > >                     strerror(errno));
> > > > >
> > > > >         TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
> > > > >                     "Task '%d' not allowed to run on pCPU '%d'\n");
> > > > >
> > > > >         CPU_ZERO(&allowed_mask);
> > > > >         CPU_SET(cpu, &allowed_mask);
> > > > >
> > > > > that way the user will get an explicit error message if they try to pin a vCPU/task
> > > > > that has already been affined by something else.  And then, in theory,
> > > > > sched_setaffinity() should never fail.
> > > > >
> > > > > Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
> > > > > unnecessarily complex.
> > > > >
> > > >
> > > > sched_setaffinity() doesn't fail when we assign more than one task to
> > > > the pCPU, it allows multiple tasks to be on the same pCPU. One of the
> > > > reasons it fails is if it is provided a cpu number which is bigger
> > > > than what is actually available on the host.
> > > >
> > > > I am not convinced that pinning vCPUs to the same pCPU should throw an
> > > > error. We should allow if someone wants to try and compare performance
> > > > by over subscribing or any valid combination they want to test.
> > >
> > > Oh, I'm not talking about the user pinning multiple vCPUs to the same pCPU via
> > > the test, I'm talking about the user, or more likely something in the users's
> > > environment, restricting what pCPUs the user's tasks are allowed on.  E.g. if
> > > the test is run in shell that has been restricted to CPU8 via cgroups, then
> > > sched_setaffinity() will fail if the user tries to pin vCPUs to any other CPU.
> >
> > I see, I will add this validation.
> 
> I think we should drop this check. Current logic is that the new
> function perf_test_setup_pinning() parses the vcpu mappings, stores
> them in perf_test_vcpu_args{} struct and moves the main thread to the
> provided pcpu. But this causes TEST_ASSERT(CPU_ISSET...) to fail for
> vcpu threads when they are created because they inherit task affinity
> from the main thread which has the pcpu set during setup.
> 
> However, this affinity is not strict, so, if TEST_ASSERT(CPU_ISSET...)
> is removed then vcpu threads successfully move to their required pcpu
> via sched_setaffinity() even though the main thread has different
> affinity. If cpus are restricted via cgroups then sched_setaffinity()
> fails as expected no matter what.
> 
> Another option will be to split the API, perf_test_setup_pinning()
> will return the main thread pcpu and dirty_log_perf_test can call
> pin_this_task_to_cpu() with the returned pcpu after vcpus have been
> started. I do not like this approach, I also think
> TEST_ASSERT(CPU_ISSET...) is not reducing user pain that much because
> users can still figure out with returned errno what is happening.

The easy way to handle this is to take the sched_getaffinity() snapshot during
perf_test_setup_pinning().  You could even do the sanity checking there, e.g.
keep pcpu_num() (maybe rename it to parse_pcpu()?)

static uint32_t parse_pcpu(const char *cpu_str, cpu_set_t *allowed_mask)
{
	uint32_t pcpu = atoi_positive(cpu_str);

	TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
		    "Not allowed to run on pCPU '%d', check cgroups?\n");
	return pcpu;
}


	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
	TEST_ASSERT(!r, "sched_getaffinity() failed");

	for (i = 0; i < nr_vcpus; i++ {
		TEST_ASSERT(cpu, "pCPU not provided for vCPU%d\n", i);

		perf_test_args.vcpu_args[i++].pcpu = parse_pcpu(cpu, &allowed_mask);
		cpu = strtok(NULL, delim);
	}


	if (cpu)
		pin_me_to_pcpu(parse_pcpu(cpu, &allowed_mask));

That'll result in a slightly larger window where the sanity check could get a
false negative, but that's ok.  Detecting conflicts with 100% accuracy isn't
possible since there's always a window where the allowed cpuset could change, the
goal is only to catch the "obvious" cases in order to save the user a bit of debug
time.

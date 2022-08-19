Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD9659A89F
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 00:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbiHSWeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 18:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiHSWeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 18:34:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338015AA24
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:34:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso6104261pjj.4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 15:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=kbE/65DRjPYqdTnyqLepSgX1Hekk23DazggKsiasbMI=;
        b=f1awwJtCJkd9zjKnF7QVDXZjvTiGVaFt0oxrlKLtFsWuLPaTJoNT/d93siF9E9L5nb
         A09Otekuu+kbq6hDCFdhfmHhRVJK70vsNcnmFlQ5ud+bOKwd0TNNB+HFDzN7wq5FAdzZ
         0dOroiYEIYB349JxDlU6+NvPWq64pVr2cl8zbeehi6J/bcBWejcQtWwV3o6W9KF1mZDY
         6vE7PSGIBQkrGY/YqNR50hcdJHrJIz4xW1mJhA4QgtjUnpvw47bIuMaiCR71a28XnbuQ
         kfXnLJf6lVCFBdBXZrwNR+cLYkjHJqTsuMxNKQOF+u3ByMqdsPutwmn9DofQW7skOWL3
         6SCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kbE/65DRjPYqdTnyqLepSgX1Hekk23DazggKsiasbMI=;
        b=EArH69x2jofpRN/IYQJ+vLbp71yG3ega7uQEEpI21nBaQ6TcWSZTkQK63U68cqptUy
         HNXAOlC3aFrOYc77e8hxCbjjr8mE2KE+FEgtZ93CVjdT0Tm4nWsANFMHF1BQO05APiYB
         rqTIKvJDMZcYlHH80gY451Kr8iWvmfSc559NgQg6fcdegYmrJgLyfbirqg8K1M35VOfA
         7Yy7UsJZV8BMz9qNT2rvMQaIwyOk+ndx+Vxm2NWC3sWouPBa3SsbTtv/Ki7CN+UH5Wh+
         dku90iD4Qa0Q5Yzx1V0EDxcNC/HyA4AWYf0YxE841fe6IViqnSHMpifx8qok84J7AoRv
         5nTg==
X-Gm-Message-State: ACgBeo0AmXXPE/zsoUaJQfzNDCGrhJ31YyUpSxmyk9tj47Ry6Mvyuveu
        VGRK7esuMSa13Nit8SyxVhGcUw==
X-Google-Smtp-Source: AA6agR7xiaNGZGxj1jhH+TXInm/skq5rrDbAzx1asotOTsbjHl4pO/58qVGlo7ah4r3QB25jHbb/nw==
X-Received: by 2002:a17:902:6ac8:b0:172:cdd5:182a with SMTP id i8-20020a1709026ac800b00172cdd5182amr1484083plt.56.1660948447246;
        Fri, 19 Aug 2022 15:34:07 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709026b8400b001729da53673sm3658748plk.14.2022.08.19.15.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 15:34:06 -0700 (PDT)
Date:   Fri, 19 Aug 2022 15:34:01 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Run dirty_log_perf_test on specific
 cpus
Message-ID: <YwAP2dM/9vfjlAMb@google.com>
References: <20220819210737.763135-1-vipinsh@google.com>
 <YwAC1f5wTYpTdeh+@google.com>
 <CAHVum0ecr7S9QS4+3kS3Yd-eQJ5ZY_GicQWurVFnAif6oOYhOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0ecr7S9QS4+3kS3Yd-eQJ5ZY_GicQWurVFnAif6oOYhOg@mail.gmail.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 03:20:06PM -0700, Vipin Sharma wrote:
> On Fri, Aug 19, 2022 at 2:38 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Aug 19, 2022 at 02:07:37PM -0700, Vipin Sharma wrote:
> > > +static int atoi_paranoid(const char *num_str)
> > > +{
> > > +     int num;
> > > +     char *end_ptr;
> > > +
> > > +     errno = 0;
> > > +     num = (int)strtol(num_str, &end_ptr, 10);
> > > +     TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
> > > +     TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> > > +                 "Invalid number string.\n");
> > > +
> > > +     return num;
> > > +}
> >
> > Introduce atoi_paranoid() and upgrade existing atoi() users in a
> > separate commit. Also please put it in e.g. test_util.c so that it can
> > be used by other tests (and consider upgrading other tests to use it in
> > your commit).
> >
> 
> Sure, I will add a separate commit.
> 
> 
> > > -     while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
> > > +     while ((opt = getopt(argc, argv, "c:eghi:p:m:nb:f:v:os:x:")) != -1) {
> > >               switch (opt) {
> > > +             case 'c':
> > > +                     nr_lcpus = parse_cpu_list(optarg, lcpu_list, KVM_MAX_VCPUS + 1);
> >
> > I think we should move all the logic to pin threads to perf_test_util.c.
> > The only thing dirty_log_perf_test.c should do is pass optarg into
> > perf_test_util.c. This will make it trivial for any other test based on
> > pef_test_util.c to also use pinning.
> >
> > e.g. All a test needs to do to use pinning is add a flag to the optlist
> > and add a case statement like:
> >
> >         case 'c':
> >                 perf_test_setup_pinning(optarg);
> >                 break;
> >
> > perf_test_setup_pinning() would:
> >  - Parse the list and populate perf_test_vcpu_args with each vCPU's
> >    assigned pCPU.
> >  - Pin the current thread to it's assigned pCPU if one is provided.
> >
> 
> This will assume all tests have the same pinning requirement and
> format. What if some tests have more than one worker threads after the
> vcpus?

Even if a test has other worker threads, this proposal would still be
logically consistent. The flag is defined to only control the vCPU
threads and the main threads. If some test has some other threads
besides that, this flag will not affect them (which is exactly how it's
defined to behave). If such a test wants to pin those other threads, it
would make sense to have a test-specific flag for that pinning (and we
can figure out the right way to do that if/when we encounter that
situation).

> 
> Maybe I should:
> 1. Create a generic function which parses a csv of integers, put it in
> test_util.c
> 2. Provide a function to populate perf_test_vcpus_args in perf_test_util.c
> 3. Provide a function to migrate self to some cpu in perf_test_util.c.
> This will work for now, but in future if there are more than 1 worker
> we need to revisit it.
> 
> I will also be fine implementing what you suggested and keep working
> under the precondition that there will be only one worker thread, if
> that is okay to assume.
> 
> > Validating that the number of pCPUs == number of vCPUs is a little
> > tricky. But that could be done as part of
> > perf_test_start_vcpu_threads(). Alternatively, you could set up pinning
> > after getting the number of vCPUs. e.g.
> >
> >         const char *cpu_list = NULL;
> >
> >         ...
> >
> >         while ((opt = getopt(...)) != -1) {
> >                 switch (opt) {
> >                 case 'c':
> >                         cpu_list = optarg;  // is grabbing optarg here safe?
> 
> I am not sure how it is internally implemented. API doesn't mention
> anything. Better to be safe and assume it is not valid later.

I think it should be fine. I assume optarg is pointing into [a copy of?]
argv with null characters inserted, so the pointer will still be valid
after the loop. But I just wanted to call out that I wasn't 100% sure :)

> 
> >                         break;
> >                 }
> >                 ...
> >         }
> >
> >         if (cpu_list)
> >                 perf_test_setup_pinning(cpu_list, nr_vcpus);
> >
> 
> Better to have a copy of the argument or just get list of cpus after
> parsing and then do the verification. What is the point in doing all
> extra parsing work when we are gonna abort the process due to some
> invalid condition.

Yeah and I also realized perf_test_setup_pinning() will need to know how
many vCPUs there are so it can determine which element is the main
thread's pCPU assignment.

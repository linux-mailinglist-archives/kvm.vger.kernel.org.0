Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E4675740
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjATOeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjATOeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:34:15 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCF7EC6C
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:34:09 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id n2so3958063qvo.1
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XjmZ79ynV0bH+EDWqgk/8lTzxUbHD5cFbos/kq0lBzo=;
        b=Y+lj6ercKj761PR1DL1Hpm5eGCnvzA42lm3xZovTG3vMJCzIDiM35VWyJtUnGXDPFv
         JMS+pWpvxg+kgZeP+mLbLHESJFkHhHTipc9dFHdzw1BAmOb8Ysa5pmY6+bNUk42bIOSe
         BtjHNB4M854xOfOXsFAu83CpNqqJotEwQw7Jw2+6ysISdZQ2K5cPmin4AcSE2Rq4rTbF
         A/iJ8PE6xBoRmlADxbjKNsVOwplmsiS0GeqsLn/Kt2lnl19MJbd2gcGjPZIvdtnGK3hz
         ddz95jvcnjX7SBMNDZa7A6xdQx9v8nnBg8MN9ZYZxz/ABnPackLz76yxaZjttFgdnaMQ
         3zGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XjmZ79ynV0bH+EDWqgk/8lTzxUbHD5cFbos/kq0lBzo=;
        b=WyAET6N4QROMyqhVqmh16ALrzJlL3cS0nU4hG02Cti4DBpLlrD/rrP6QKxrQIknTNm
         mHLAfQoyXhdRHd94giCmOOjFthnGeiKbCBqgiQ4ePNB9KpH4Hh9mSrIQpeEQNXoRfkcB
         T2AnZGGYYt76XPOSNslbH4vxMa/ePrGTSbg3xMJpZDIZecRIJFoRfMwFKKi6+KNsGhvH
         Jv3w+1As5LGDjrNXf+Png+715D5u/BcvvWztWzngY1GnaGKjvOtQNd4TgDzs5cf7qCXY
         kCjkzZHhQ+gTJyUovFUVmBX7Ly/+5znls4mkroqYn2XaHmQc1+OaRXEz0W9lc5EExkBI
         OEbg==
X-Gm-Message-State: AFqh2koQD7Gx20TmA6L6XnM/XO2qziP+dvR3Jn/YIFkjlTZ53jDlxRoH
        B7gJCp0Mhbt/l+gyprbVzYUpK6UVG3GGgCVmABrGVQ==
X-Google-Smtp-Source: AMrXdXswQv+uQXtY9g1EHZJz/nyGV9Tq2uCjARwRHzlA804B/OV18aEbTuKydnZl5Zi3/nE0KJlKNM/pq8WLmjgpQZ4=
X-Received: by 2002:ad4:551a:0:b0:534:a748:719 with SMTP id
 pz26-20020ad4551a000000b00534a7480719mr707624qvb.102.1674225248906; Fri, 20
 Jan 2023 06:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20230119212510.3938454-1-bgardon@google.com> <20230119212510.3938454-3-bgardon@google.com>
 <Y8nKerX9tDRHkFq+@google.com> <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
 <Y8qj1QS1VadgaX7A@google.com>
In-Reply-To: <Y8qj1QS1VadgaX7A@google.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Fri, 20 Jan 2023 06:33:56 -0800
Message-ID: <CAOHnOrzKBh2Cq7ZQece+6f6P5wS6gZ1R2vjEQ5=QLTy7BmUvFQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
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

On Fri, Jan 20, 2023 at 6:23 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Thu, Jan 19, 2023 at 03:48:14PM -0800, Ben Gardon wrote:
> > On Thu, Jan 19, 2023 at 2:56 PM David Matlack <dmatlack@google.com> wrote:
> > ...
> > > > +static int NR_VCPUS = 2;
> > > > +static int NR_SLOTS = 2;
> > > > +static int NR_ITERATIONS = 2;
> > >
> > > These should be macros or at least const?
> >
> > Yikes, woops, that was a basic mistake.
> >
> > >
> > > > +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> > > > +
> > > > +/* Host variables */
> > >
> > > What does "Host variables" mean? (And why is guest_percpu_mem_size not a
> > > "Host variable"?)
> > >
> > > I imagine this is copy-pasta from a test that has some global variables
> > > that are used by guest code? If that's correct, it's probably best to
> > > just drop this comment.
> >
> > Yeah, shameful copypasta. I'll drop it.
> >
> > >
> > > > +static u64 dirty_log_manual_caps;
> > ...
> >
> > > > +             /*
> > > > +              * Incrementing the iteration number will start the vCPUs
> > > > +              * dirtying memory again.
> > > > +              */
> > > > +             iteration++;
> > > > +
> > > > +             for (i = 0; i < NR_VCPUS; i++) {
> > > > +                     while (READ_ONCE(vcpu_last_completed_iteration[i])
> > > > +                            != iteration)
> > > > +                             ;
> > > > +             }
> > > > +
> > > > +             pr_debug("\nGetting stats after dirtying memory on pass %d:\n", iteration);
> > > > +             get_page_stats(vm, &stats_dirty_pass[iteration - 1]);
> > >
> > > Incrementing iteration, waiting for vCPUs, and grabbing stats is
> > > repeated below. Throw it in a helper function?
> >
> > Good call.
> >
> > >
> > > > +
> > > > +             memstress_get_dirty_log(vm, bitmaps, NR_SLOTS);
> > > > +
> > > > +             if (dirty_log_manual_caps) {
> > > > +                     memstress_clear_dirty_log(vm, bitmaps, NR_SLOTS, pages_per_slot);
> > > > +
> > > > +                     pr_debug("\nGetting stats after clearing dirty log pass %d:\n", iteration);
> > > > +                     get_page_stats(vm, &stats_clear_pass[iteration - 1]);
> > > > +             }
> > > > +     }
> > > > +
> > > > +     /* Disable dirty logging */
> > > > +     memstress_disable_dirty_logging(vm, NR_SLOTS);
> > > > +
> > > > +     pr_debug("\nGetting stats after disabling dirty logging:\n");
> > > > +     get_page_stats(vm, &stats_dirty_logging_disabled);
> > > > +
> > > > +     /* Run vCPUs again to fault pages back in. */
> > > > +     iteration++;
> > > > +     for (i = 0; i < NR_VCPUS; i++) {
> > > > +             while (READ_ONCE(vcpu_last_completed_iteration[i]) != iteration)
> > > > +                     ;
> > > > +     }
> > > > +
> > > > +     pr_debug("\nGetting stats after repopulating memory:\n");
> > > > +     get_page_stats(vm, &stats_repopulated);
> > > > +
> > > > +     /*
> > > > +      * Tell the vCPU threads to quit.  No need to manually check that vCPUs
> > > > +      * have stopped running after disabling dirty logging, the join will
> > > > +      * wait for them to exit.
> > > > +      */
> > > > +     host_quit = true;
> > > > +     memstress_join_vcpu_threads(NR_VCPUS);
> > > > +
> > > > +     memstress_free_bitmaps(bitmaps, NR_SLOTS);
> > > > +     memstress_destroy_vm(vm);
> > > > +
> > > > +     /* Make assertions about the page counts. */
> > > > +     total_4k_pages = stats_populated.pages_4k;
> > > > +     total_4k_pages += stats_populated.pages_2m * 512;
> > > > +     total_4k_pages += stats_populated.pages_1g * 512 * 512;
> > > > +
> > > > +     /*
> > > > +      * Check that all huge pages were split. Since large pages can only
> > > > +      * exist in the data slot, and the vCPUs should have dirtied all pages
> > > > +      * in the data slot, there should be no huge pages left after splitting.
> > > > +      * Splitting happens at dirty log enable time without
> > > > +      * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
> > > > +      * with that capability.
> > > > +      */
> > > > +     if (dirty_log_manual_caps) {
> > > > +             TEST_ASSERT(stats_clear_pass[0].hugepages == 0,
> > >
> > > Consider using ASSERT_EQ() to simplify these checks. It will
> > > automatically print out the values for you, but you'll lose the
> > > contextual error message ("Unexpected huge page count after
> > > splitting..."). But maybe we could add support for a custom extra error
> > > string?
> > >
> > > __ASSERT_EQ(stats_clear_pass[0].hugepages, 0,
> > >             "Expected 0 hugepages after splitting");
> > >
> > > Or use a comment to document the context for the assertion. Whoever is
> > > debugging a failure is going to come look at the selftest code no matter
> > > what.
> > >
> > > I think I prefer ASSERT_EQ() + comment, especially since the comment
> > > pretty much already exists above.
> >
> > That's fair. I prefer the way it is because the resulting error
> > message is a lot easier to read and I don't need to look at the test
> > code to decrypt it. If I'm developing a feature and just running all
> > tests, it's nice to not have to track down the test source code.
> >
> > >
> > > > +                         "Unexpected huge page count after splitting. Expected 0, got %ld",
> > > > +                         stats_clear_pass[0].hugepages);
> > > > +             TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
> > > > +                         "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> > > > +                         total_4k_pages, stats_clear_pass[0].pages_4k);
> > >
> > > Also assert that huge pages are *not* split when dirty logging is first
> > > enabled.
> >
> > Ah great idea. I felt like I was a little light on the assertions.
> > That'll be a good addition.
> >
> > >
> > > > +     } else {
> > ...
> > > > +
> > > > +     dirty_log_manual_caps =
> > > > +             kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > > > +     dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > > > +                               KVM_DIRTY_LOG_INITIALLY_SET);
> > >
> > > Since this is a correctness test I think the test should, by default,
> > > test both KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and 0, to ensure we get
> > > test coverage of both.
> > >
> > > And with that in place, there's probably no need for the -g flag.
> >
> > Good idea.
> >
> > >
> > > > +
> > > > +     guest_modes_append_default();
> > ...
> > > > +
> > > > +     if (!is_backing_src_hugetlb(p.backing_src)) {
> > > > +             pr_info("This test will only work reliably with HugeTLB memory. "
> > > > +                     "It can work with THP, but that is best effort.");
> > > > +             return KSFT_SKIP;
> > > > +     }
> > >
> > > backing_src only controls the memstress data slots. The rest of guest
> > > memory could be a source of noise for this test.
> >
> > That's true, but we compensate for that noise by taking a measurement
> > after the population pass. At that point the guest has executed all
> > it's code (or at least from all it's code pages) and touched every
> > page in the data slot. Since the other slots aren't backed with huge
> > pages, NX hugepages shouldn't be an issue. As a result, I would be
> > surprised if noise from the other memory became a problem.
> >
> > >
> > > > +
> > > > +     run_test(&p);
> > >
> > > Use for_each_guest_mode() to run against all supported guest modes.
> >
> > I'm not sure that would actually improve coverage. None of the page
> > splitting behavior depends on the mode AFAICT.
>
> You need to use for_each_guest_mode() for the ARM case. The issue is
> that whatever mode (guest page size and VA size) you pick might not be
> supported by the host. So, you first to explore what's available (via
> for_each_guest_mode()).

Actually, that's fixed by using the default mode, which picks the
first available
mode. I would prefer to use for_each_guest_mode() though, who knows and
something fails with some specific guest page size for some reason.

>
> Thanks,
> Ricardo
>
> >
> > >
> > > > +
> > > > +     return 0;
> > > > +}
> > > > --
> > > > 2.39.1.405.gd4c25cc71f-goog
> > > >

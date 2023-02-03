Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F41D689E65
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjBCPg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 10:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjBCPgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 10:36:52 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112FB6F21F
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 07:36:50 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id l1so2571397qkg.11
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 07:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0UYvq70HDOIo75wjd1El9PDilVQmMcpF6t7PglLrXVk=;
        b=aImhPd9bN9VE0QHO2Wh3L0dRlzz/G7Mg5KgY08aAtSrX5GFGgWzJxU14VO3K4aUR6X
         P6lPl+9M5liDXnrk9eSEotRi6kIjns9vgxW60OKwQLIFIyuJR7c62c6qgXqY+IsKi4W+
         gwJD5LJHNJ5jkLo80VpZ6R+K8wKBTFNvhkjSGE7GGPXVYVqY4LJ2yZlQA1i4uvqSeSzC
         x/JOhiLjefi0yKjCb4vwyiiuRtsKBfRiPDBFUY11QGqFipEuKHRJ7b2B82l081QHHT1n
         hTWZz+td3a1PJRVi1uFNzZySjUnnPdigafLZqK3YLC9Y5n/cyIkJH9/fzJou0cZpwQoc
         fB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UYvq70HDOIo75wjd1El9PDilVQmMcpF6t7PglLrXVk=;
        b=b5ygkN/exGWvjzyYbOLjnLoKb2SeEqQHyhkL68z3OG1M0SjpZKMdtGU8KtJgS3UNJR
         4AqoGfn56X9tc+LCEtCfnMfAGPVrRCxMVZ44N4IUU1nea1qZygcRc2bq1wcT+gRMo0gB
         tNLKq6BOzbkPHn9TYVWkR26vHQ24ZHvr/u0auZ67+bUXGoBP8GXb6/fMpNsg6v0oaxpq
         nkLGl+e7Cj9j50OhX8xBRqNwzi+y7c07Y36nSfM4MYuvvbXNcz6XNp3ltuUYuiwIXhNb
         NBk6fuskHoDhhVxjQDegLZJdaJTlkZvuLpp4wx1zaczAGSXu4IwlO47nX7O/dmzh/jgB
         PeSw==
X-Gm-Message-State: AO0yUKWVsLezfY51WaTV2fDk18NtLSY63nonMXtyqOOw6rNA6WS6bOBz
        Do1pP08oMTjEbhMRge7ZBa4mzoaCsMA3kS1tEq7HEw==
X-Google-Smtp-Source: AK7set+6xViBuxHQLgOv2161oDQ6P1Qe7Y0fSJLUVbtwcqJ+NT3AkubfrnFLGVU3QaU7FnFN9EHsLun7O6EkWM/fbsk=
X-Received: by 2002:a05:620a:13d3:b0:706:8588:513c with SMTP id
 g19-20020a05620a13d300b007068588513cmr743433qkl.390.1675438608985; Fri, 03
 Feb 2023 07:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com> <Y90e4IluvCYSnShh@sirena.org.uk>
In-Reply-To: <Y90e4IluvCYSnShh@sirena.org.uk>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Fri, 3 Feb 2023 07:36:37 -0800
Message-ID: <CAOHnOrwqJ+K4vcyzV7z=BcC-J=ZyFj8wZYSdJO7Kk=kJ=4kKOw@mail.gmail.com>
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
To:     Mark Brown <broonie@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
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

Hi Mark,

On Fri, Feb 3, 2023 at 6:49 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Oct 17, 2022 at 07:58:20PM +0000, Ricardo Koller wrote:
> > This series adds a new aarch64 selftest for testing stage 2 fault handling
> > for various combinations of guest accesses (e.g., write, S1PTW), backing
> > sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> > hole, write on a readonly memslot). Each test tries a different combination
> > and then checks that the access results in the right behavior (e.g., uffd
> > faults with the right address and write/read flag). Some interesting
> > combinations are:
>
> I'm seeing issues with the page_fault_test tests in both -next and
> mainline all the way back to v6.1 when they were introduced running on
> both the fast model and hardware.  With -next the reports come back as:
>
> # selftests: kvm: page_fault_test
> # ==== Test Assertion Failure ====
> #   aarch64/page_fault_test.c:316: __a == __b
> #   pid=851 tid=860 errno=0 - Success
> #      1        0x0000000000402253: uffd_generic_handler at page_fault_test.c:316
> #      2        0x000000000040be07: uffd_handler_thread_fn at userfaultfd_util.c:97
> #      3        0x0000ffff8b39edd7: ?? ??:0
> #      4        0x0000ffff8b407e9b: ?? ??:0
> #   ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write) failed.
> #       !!(flags & UFFD_PAGEFAULT_FLAG_WRITE) is 0
> #       expect_write is 0x1
> not ok 6 selftests: kvm: page_fault_test # exit=254
>
> (addr2line seemed to be not doing much, I've not poked too hard at
> that).  I've been unable to find any case where the program passes.
> Is this expected?
>
> Some random full runs on hardware:

That failure was fixed with this series:
"KVM: selftests: aarch64: page_fault_test S1PTW related fixes"
https://lore.kernel.org/kvmarm/20230127214353.245671-1-ricarkol@google.com/

which made it into kvmarm/fixes and should get into 6.2:
https://lore.kernel.org/kvmarm/20230129190142.2481354-1-maz@kernel.org/

Note that the failing assert does not exist after the mentioned series:
> #   ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write) failed.

>
> 4xA53: https://lava.sirena.org.uk/scheduler/job/244678
> 4xA72: https://lkft.validation.linaro.org/scheduler/job/6114427

Thanks,
Ricardo

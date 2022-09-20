Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5867A5BEB1F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiITQcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 12:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiITQcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 12:32:00 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8761647DB
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:31:58 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a8so4650587lff.13
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 09:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=59u/2Na9wvMcIUzmPI/Vs4MUBBV350GPYbERyKjm6L8=;
        b=icNkO+SAftm3mx1tQl/00CHe/70gdlCVRlWkTl0UkWQFrwdZLkXb2Ckl4DMON8bDdr
         4pVKKwEcuO676aj2W4aoAM0U1+94o59rHWeadNzg3lXZzTFmOiLKahZT/J1Us2k6amaR
         tNp5tU+/obLt5PhNcV/UoOaLzwSHkQ1sAPceRPYjRwIMRGvS5DmHdfzauEhCM/+XbWyx
         9GJMdf3k3Zg6xeztQl2kgE64UL82OfG/reFl6rceOnpim1MQ6JAztsNpFjdJBbSra8yK
         5IqTEEjzgf0nbKLG8ziKI9kw7GTraEhffOuSxpO/R2OQib2LrOiQHcp2NRZGWYTiS0kT
         n6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=59u/2Na9wvMcIUzmPI/Vs4MUBBV350GPYbERyKjm6L8=;
        b=yiFlhuTTfcqdLV1wf4CWon8hUVkSSNGH6DcyN4urIrrKM4Lz0vRU//+Ck65IAoFqh3
         0ihLW9zqZKAcWMd7hXxZ8XcBl4tp4C2YHH58ac+6Uo9zBWt7OeL0KhWslWm7fVWnGaj6
         UWjCWANmZRm8tfiwYLMxxqRJBGCs8TUrv6qHnCVth8VVbcnNEWw9a3Z1rbkw6ReQ0+sd
         RjI3cLjpglCyKpfL5Ue5Pn+89QO+G5Iwo7SZEWlcj8EhjoJpwSYpbiZWyk9oV5q59/om
         VN7KM4dGwen9g8kCXhh0caDewKrFtUmpSQ7HKBn2F+uQGH1Ofsrb6FqF98jme/4VYsgc
         roWg==
X-Gm-Message-State: ACrzQf0yxxeTj1noZ3MzPXZcxTBhdTs2KJK+hUL59DwtO0YDgVd3pPfo
        GYI8M6g/4WXDUeqRqL5MZVqw1e1Zz09/EMjk8L1K8g==
X-Google-Smtp-Source: AMsMyM7RlIInnoR9T4HMsJf2ND4jq46dmYmpNOnZWE62MPxgWwcHnQSkFqrrHI0gXuw3qMujjUEMZAK3QLurRcS5M7M=
X-Received: by 2002:ac2:5469:0:b0:497:ed1:97c6 with SMTP id
 e9-20020ac25469000000b004970ed197c6mr7935414lfn.248.1663691517036; Tue, 20
 Sep 2022 09:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com>
In-Reply-To: <20220826184500.1940077-1-vipinsh@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 20 Sep 2022 09:31:20 -0700
Message-ID: <CAHVum0eUsVoJKJ1X+qmW-6jRoag=QZW2RD46_Ez2489qy8ps5w@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] dirty_log_perf_test cpu pinning and some goodies
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, Aug 26, 2022 at 11:45 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> Pin vcpus to a host physical cpus in dirty_log_perf_test and optionally
> pin the main application thread to a physical cpu if provided. All tests
> based on perf_test_util framework can take advantage of it if needed.
>
> While at it, I changed atoi() to atoi_paranoid() in other tests, sorted
> command line options alphabetically, and made switch case logic of -e
> option less error prone to code changes by adding break and decoupling
> it from -g.
>
> v3:
> - Moved atoi_paranoid() to test_util.c and replaced all atoi() usage
>   with atoi_paranoid()
> - Sorted command line options alphabetically.
> - Instead of creating a vcpu thread on a specific pcpu the thread will
>   migrate to the provided pcpu after its creation.
> - Decoupled -e and -g option.
>
> v2: https://lore.kernel.org/lkml/20220819210737.763135-1-vipinsh@google.com/
> - Removed -d option.
> - One cpu list passed as option, cpus for vcpus, followed by
>   application thread cpu.
> - Added paranoid cousin of atoi().
>
> v1: https://lore.kernel.org/lkml/20220817152956.4056410-1-vipinsh@google.com
>
> Vipin Sharma (4):
>   KVM: selftests: Explicitly set variables based on options in
>     dirty_log_perf_test
>   KVM: selftests: Put command line options in alphabetical order in
>     dirty_log_perf_test
>   KVM: selftests: Add atoi_paranoid to catch errors missed by atoi
>   KVM: selftests: Run dirty_log_perf_test on specific cpus
>
>  .../selftests/kvm/aarch64/arch_timer.c        |  8 +--
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +-
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/demand_paging_test.c        |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 65 +++++++++++++------
>  .../selftests/kvm/include/perf_test_util.h    |  4 ++
>  .../testing/selftests/kvm/include/test_util.h |  2 +
>  .../selftests/kvm/kvm_page_table_test.c       |  2 +-
>  .../selftests/kvm/lib/perf_test_util.c        | 62 +++++++++++++++++-
>  tools/testing/selftests/kvm/lib/test_util.c   | 14 ++++
>  .../selftests/kvm/max_guest_memory_test.c     |  6 +-
>  .../kvm/memslot_modification_stress_test.c    |  4 +-
>  .../testing/selftests/kvm/memslot_perf_test.c | 10 +--
>  .../selftests/kvm/set_memory_region_test.c    |  2 +-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c |  4 +-
>  15 files changed, 148 insertions(+), 45 deletions(-)
>
> --
> 2.37.2.672.g94769d06f0-goog
>

Knock Knock!!

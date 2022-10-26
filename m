Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C194D60EAC6
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiJZVW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJZVW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:22:56 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAB912B364
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:22:52 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h185so16211276pgc.10
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OTWbttkJY9+UiZ3IJ1wp/zYpMm58Srtsymi020albs=;
        b=OTQ73ymmP9Nu02c4m+zswp13fUzdyubfqcegfFxDng7b9BvPZAUO5xZ34EAsUZ11q+
         su10Ar+fQeM+pfq4wbagonj9Cl8gjfHfm6rEiqtyBhZWLLFvUtsVxUC/GgMSeTYO6dUu
         FIaMTcthbk/hJ/6f20gn/SkBb4DVnoiGvDIKnL2sq/+R0ODT/MrxlZgylXwkUceSbRX4
         nhKZquxx91ViHYSJYYoWV0OKf5kkDaUnM6G9EQALfuFf/kxKHGyT06NNBxiEMAEDCOsJ
         PB+VQ+0GPNACv4LnPnm5QYGPk8pBvSIPf6MJapdzVCpA2ZKOzCpF7wwBiY+0rFA3ndDd
         eWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OTWbttkJY9+UiZ3IJ1wp/zYpMm58Srtsymi020albs=;
        b=Vkg4p+U+YkJHXL/PonvyP5e9L7y3vrT1i+qQu1m0UM9QVwOqR3U3R5IBIuzcuBElc+
         lywxA3MfcIqe+lOsUBz8/XOyWjPJWWrmrsXpP+spKAhgf4MFvSOrmhja95CNBdO1DAB2
         YtP+86MWbc0+reiC1RcAcR9HulzrkZAZdGKgr9dEnwcosKUh5TNQrWleuFizrFy55PTc
         9p4bNePGSvwuz/m2QNfp9KeERyLODX8DTupT0H6L6ChVSJMJx+sQRnbpmlc895WNLDwW
         CmikEZOePCVYnF8VTngvp4Bw2n+7Vq34RbpjqklYxerElbpxY96R62xsVyvoTvqnomw8
         Lc6g==
X-Gm-Message-State: ACrzQf3Xfc8n4AUjZiHYYV4ZEU9S5rmau7zJDOazXbOp6i7eIjR9gzIn
        FzM7I5Q1LnfaC6+uqi4uFBYGVQ==
X-Google-Smtp-Source: AMsMyM6lZW58ikrKYE7rGbhgOpi1TcfuL9KXipcclHosAShP5Xqm8tKM3JzhFHvVQBs9v8IsMw9CuA==
X-Received: by 2002:a65:6e47:0:b0:438:c2f0:c0eb with SMTP id be7-20020a656e47000000b00438c2f0c0ebmr39121933pgb.236.1666819371325;
        Wed, 26 Oct 2022 14:22:51 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s23-20020aa78bd7000000b0056bc95ef1ffsm3417064pfd.75.2022.10.26.14.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:22:50 -0700 (PDT)
Date:   Wed, 26 Oct 2022 14:22:46 -0700
From:   David Matlack <dmatlack@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Message-ID: <Y1mlJqKdFtlgG3jR@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
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

On Mon, Oct 24, 2022 at 07:34:27PM +0800, Wei Wang wrote:
> This patch series intends to improve kvm selftests with better code
> consolidation using the helper functions to perform vcpu and thread
> related operations.
> 
> In general, several aspects are improved:
> 1) The current users allocate an array of vcpu pointers to the vcpus that
>    are added to a vm, and an array of vcpu threads. This isn't necessary
>    as kvm_vm already maintains a list of added vcpus. This series changes
>    the list of vcpus in the kvm_vm struct to a vcpu array for users to
>    work with and removes each user's own allocation of such vcpu arrays.
>    Aslo add the vcpu thread to the kvm_vcpu struct, so that users don't
>    need to explicitly allocate a thread array to manage vcpu threads on
>    their own.
> 2) Change the users to use the helper functions provided by this series
>    with the following enhancements:
>    - Many users working with pthread_create/join forgot to check if
>      error on returning. The helper functions have handled thoses inside,
>      so users don't need to handle them by themselves;
>    - The vcpu threads created via the helper functions are named in
>      "vcpu-##id" format. Naming the threads facilitates debugging,
>      performance tuning, runtime pining etc;
>    - helper functions named with "vm_vcpu_threads_" iterates over all the
>      vcpus that have been added to the vm. Users don't need a explicit
>      loop to go through the added cpus by themselves.
> 3) kvm_vcpu is used as the interface parameter to the vcpu thread's
>    start routine, and the user specific data is made to be the private
>    data in kvm_vcpu. This can simplify the user specific data structures,
>    as kvm_vcpu has already included the required info for the thread, for
>    example, in patch 13, the cpu_idx field from "struct vcpu_thread"
>    is a duplicate of vcpu->id.

I haven't dug too much into the actual code yet, but I have some high
level feedback based on a quick look through the series:

 - Use the format "KVM: selftests: <Decsription>" for the shortlog.

 - Make the shortlog more specific. "vcpu related code consolidation" is
   vague.

 - Do not introduce bugs and then fix them in subsequent commits.  This
   breaks bisection. For example, kvm_page_table_test is broken at "KVM:
   selftests/kvm_util: use vm->vcpus[] when create vm with vcpus" and
   then fixed by "KVM: selftests/kvm_page_table_test: vcpu related code
   consolidation".

 - Try to limit each patch to one logical change. This is somewhat more
   art than science, but the basic idea is to avoid changing too much at
   once so that the code is easier to review and bisect. For example,
   "KVM: selftests/perf_test_util: vcpu related code consolidation" has
   a list of 6 different changes being made in the commit description.
   This is a sure sign this commit should be broken up. The same applies
   to many of the other patches. This will also make it easier to come
   up with more specific shortlogs.

> 
> The changes have been tested on an SPR server. Patch 15 and 16 haven't
> been tested due to the lack of an ARM environment currently.
> 
> Wei Wang (18):
>   KVM: selftests/kvm_util: use array of pointers to maintain vcpus in
>     kvm_vm
>   KVM: selftests/kvm_util: use vm->vcpus[] when create vm with vcpus
>   KVM: selftests/kvm_util: helper functions for vcpus and threads
>   KVM: selftests/kvm_page_table_test: vcpu related code consolidation
>   KVM: selftests/hardware_disable_test: code consolidation and cleanup
>   KVM: selftests/dirty_log_test: vcpu related code consolidation
>   KVM: selftests/max_guest_memory_test: vcpu related code consolidation
>   KVM: selftests/set_memory_region_test: vcpu related code consolidation
>   KVM: selftests/steal_time: vcpu related code consolidation and cleanup
>   KVM: selftests/tsc_scaling_sync: vcpu related code consolidation
>   KVM: selftest/xapic_ipi_test: vcpu related code consolidation
>   KVM: selftests/rseq_test: name the migration thread and some cleanup
>   KVM: selftests/perf_test_util: vcpu related code consolidation
>   KVM: selftest/memslot_perf_test: vcpu related code consolidation
>   KVM: selftests/vgic_init: vcpu related code consolidation
>   KVM: selftest/arch_timer: vcpu related code consolidation
>   KVM: selftests: remove the *vcpu[] input from __vm_create_with_vcpus
>   KVM: selftests/kvm_create_max_vcpus: check KVM_MAX_VCPUS
> 
>  .../selftests/kvm/aarch64/arch_timer.c        |  42 ++--
>  .../testing/selftests/kvm/aarch64/vgic_init.c |  35 ++-
>  .../selftests/kvm/access_tracking_perf_test.c |  18 +-
>  .../selftests/kvm/demand_paging_test.c        |   9 +-
>  .../selftests/kvm/dirty_log_perf_test.c       |  11 +-
>  tools/testing/selftests/kvm/dirty_log_test.c  |  16 +-
>  .../selftests/kvm/hardware_disable_test.c     |  56 ++---
>  .../testing/selftests/kvm/include/kvm_util.h  |  24 ++
>  .../selftests/kvm/include/kvm_util_base.h     |  12 +-
>  .../selftests/kvm/include/perf_test_util.h    |   9 +-
>  .../selftests/kvm/kvm_create_max_vcpus.c      |   7 +
>  .../selftests/kvm/kvm_page_table_test.c       |  16 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 217 +++++++++++++++---
>  .../selftests/kvm/lib/perf_test_util.c        |  68 ++----
>  .../selftests/kvm/lib/x86_64/perf_test_util.c |  11 +-
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
>  .../selftests/kvm/max_guest_memory_test.c     |  53 ++---
>  .../kvm/memslot_modification_stress_test.c    |   9 +-
>  .../testing/selftests/kvm/memslot_perf_test.c | 137 +++++------
>  tools/testing/selftests/kvm/rseq_test.c       |  10 +-
>  .../selftests/kvm/set_memory_region_test.c    |  16 +-
>  tools/testing/selftests/kvm/steal_time.c      |  15 +-
>  .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  25 +-
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |  54 ++---
>  24 files changed, 476 insertions(+), 396 deletions(-)
> 
> -- 
> 2.27.0
> 

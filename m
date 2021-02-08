Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA5A313D02
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhBHSQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhBHSOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:14:10 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85AEC061793
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 10:13:30 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id o7so9120726ils.2
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 10:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/e5PLp3RTxWM6g/qVFsn49ZO2ohirYic5f4PB4jc4ZY=;
        b=BFg1UkNZ9SMlhyTC6i87VjnB4xZ+DXY84WteYAKejtKFAFnYFyKbtiYDMizAWFEG0I
         ViJWJoUapoct5jaDBcHYqQQdfNXEXZtFalj1LtGZuOggkN3TWv8No4VxNdwVj0OvLSqj
         y5h0I4mpHlgQapMx2SPYQ1981oYIKbarywq2rBhscty+X4vAi44jaG4BH192+HWTQnqc
         OrhV4DRtqUXZTIxUqYzY9BPgs1wO8if6DKTA+R9J0p4Y+pz+2kQH6bMThBm5+T9FUBfh
         dXkjetwjUFTdM1oLCuHS+2a0+QtUuB+WqPydFTR9l359i4u5DbS5ECw/lLohqlD+2Xh7
         leow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/e5PLp3RTxWM6g/qVFsn49ZO2ohirYic5f4PB4jc4ZY=;
        b=FmCvgwsfWmtaoaeyECcCflw0Hbga8rl1QW+NYjYdly0764r2WJDqGZJ13o4OV5eDnh
         MpHpacwKJGPlNjWK8kpn3UwaR4Hjx/Sp4Li1MDRxUldGRtymZifQTDQt2JGCOL26qd7j
         9iom6eNHkzaViTRa7+njOGJa/ymLAY38hmi0xxKFGJeSbYssmnAeIOtINSYK9SSipxKf
         /NjsAmzy9yzLe0zYGSJ+csjxliWqHH7eL2u3dsNzKWKgG2lznVr/cAW31+Zs9/YIFcdZ
         cvAHu5g2Bwh6LUj8VafK2dkC5NxLb1Ugkcjbi7H0oTu2BAvD1aQ/A+L3Ht5taBGbh51I
         y6MQ==
X-Gm-Message-State: AOAM531faSsZw1RbMqLfLFq3kWvAAqcSCa9f2MqaZ+Yx0VpYRNYSEVUm
        LOy5orDws+4qgJK+aqCvzCG5pAkG+jOWPoFUzTC8fHYhcuelYQ==
X-Google-Smtp-Source: ABdhPJxWBm/7+d+3KjPYZevjBOfi/4p7431fD5LmT+LRlgqWcGBxS3YK+5yPxuNo74mcVr37b5wgf5gpi43olmI6hwM=
X-Received: by 2002:a92:3f06:: with SMTP id m6mr16244038ila.283.1612808009705;
 Mon, 08 Feb 2021 10:13:29 -0800 (PST)
MIME-Version: 1.0
References: <20210208090841.333724-1-wangyanan55@huawei.com> <20210208090841.333724-2-wangyanan55@huawei.com>
In-Reply-To: <20210208090841.333724-2-wangyanan55@huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 8 Feb 2021 10:13:18 -0800
Message-ID: <CANgfPd967wgLk0tb6mNaWsaAa9Tn0LyecEZ_4-e+nKoa-HkCBg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] KVM: selftests: Add a macro to get string of vm_mem_backing_src_type
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm <kvm@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 8, 2021 at 1:08 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> Add a macro to get string of the backing source memory type, so that
> application can add choices for source types in the help() function,
> and users can specify which type to use for testing.

Coincidentally, I sent out a change last week to do the same thing:
"KVM: selftests: Add backing src parameter to dirty_log_perf_test"
(https://lkml.org/lkml/2021/2/2/1430)
Whichever way this ends up being implemented, I'm happy to see others
interested in testing different backing source types too.

>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 3 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 8 ++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 5cbb861525ed..f5fc29dc9ee6 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -69,7 +69,9 @@ enum vm_guest_mode {
>  #define PTES_PER_MIN_PAGE      ptes_per_page(MIN_PAGE_SIZE)
>
>  #define vm_guest_mode_string(m) vm_guest_mode_string[m]
> +#define vm_mem_backing_src_type_string(s) vm_mem_backing_src_type_string[s]
>  extern const char * const vm_guest_mode_string[];
> +extern const char * const vm_mem_backing_src_type_string[];
>
>  struct vm_guest_mode_params {
>         unsigned int pa_bits;
> @@ -83,6 +85,7 @@ enum vm_mem_backing_src_type {
>         VM_MEM_SRC_ANONYMOUS,
>         VM_MEM_SRC_ANONYMOUS_THP,
>         VM_MEM_SRC_ANONYMOUS_HUGETLB,
> +       NUM_VM_BACKING_SRC_TYPES,
>  };
>
>  int kvm_check_cap(long cap);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fa5a90e6c6f0..a9b651c7f866 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -165,6 +165,14 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>                "Missing new mode params?");
>
> +const char * const vm_mem_backing_src_type_string[] = {
> +       "VM_MEM_SRC_ANONYMOUS        ",
> +       "VM_MEM_SRC_ANONYMOUS_THP    ",
> +       "VM_MEM_SRC_ANONYMOUS_HUGETLB",
> +};
> +_Static_assert(sizeof(vm_mem_backing_src_type_string)/sizeof(char *) == NUM_VM_BACKING_SRC_TYPES,
> +              "Missing new source type strings?");
> +
>  /*
>   * VM Create
>   *
> --
> 2.23.0
>

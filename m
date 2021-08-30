Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E752E3FBDB5
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhH3U7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbhH3U7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 16:59:25 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC13C06175F
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:58:31 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id v16so17650408ilo.10
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KI2RPuIRoh7NOePByo6KVOnUF9gby91sf7lNNFA6eIg=;
        b=SBMG9ymeVS2vlI8RISsrSy2N4QQxU/x92frWOGSDNUosIAdgQmUR7yxj5yGIbqr0xg
         jeP/mvg9VN50cKoY/vFIR1GALIZN/fOOBtZYtxgQSzvByeUqH3ip5vB7nYQcbtLD+6JM
         KmSq46SN9goyVG1Jl3XZImHJ2zWbD947M+dP8o/ewFQ9lTBxpVgvdQpQkJk1ycsaZoJK
         hEdtbDsEpMCH4EwPHND0ichcKfPbaIi5HPGl445qZ+85dLm6GRP2OQFOeC330AFR8LKH
         hbpP7EQSX0SHL7QkTzQbZic901OxHkIWmUtod5X5bZPwDD4M7zevPmc4UR2qE9WupDjQ
         /EFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KI2RPuIRoh7NOePByo6KVOnUF9gby91sf7lNNFA6eIg=;
        b=IcHphogLvEGLGyjWhSACiu0OLuRsrLpY9C09yF8K5DLGS37+SpONfhJPh79dL5syc8
         WGloX+aJjWC+e9d1HacnK2z8Hl9GDWzKEhb6AHZmknZLdRTFJQdUhWNQjhqy1Gto9spb
         ImTB4LBthTXyxG7PIEL2j1YKo0b+j2/sWZTF3scRGWwHY2X1usGkIPmVqn9nX9+Z6eKW
         EP9y/G+Zk3gW7dvskbjfviBBz0egremSWb9npzb68ghaPpJCJkq8oIe3u/DvWVe5lzk9
         LrcA7tynmj+NmI6/OMkZG5aYb4vbcHHZw0poAT3EesuMQIgPiTohkiSbl7lEUE7nKPj8
         xcBQ==
X-Gm-Message-State: AOAM531YGeleW/8PqNWQvh1ptMJ91paDGQiRXWfAR6xQKCsQNBLjzWP0
        odT84ieph8gGjERepCOZzGCxqcISmv2QPc/GEDfjFQ==
X-Google-Smtp-Source: ABdhPJwp3/kiOxyQkGJQbuBrPJLY89/1ucjlbEwBcLaoftrBluWg08kjh0Z6meSfc7wvI3FkBRVCWXtdVecglvTzALU=
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr17383378ilu.154.1630357110922;
 Mon, 30 Aug 2021 13:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210830044425.2686755-1-mizhang@google.com> <20210830044425.2686755-2-mizhang@google.com>
In-Reply-To: <20210830044425.2686755-2-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 30 Aug 2021 13:58:19 -0700
Message-ID: <CANgfPd8KKYRXGn9Vb-BjAGrhqq0pffE5_+j9KNODvpQGQhv=hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] selftests: KVM: align guest physical memory base
 address to 1GB
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 29, 2021 at 9:44 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Existing selftest library function always allocates GPA range that aligns
> to the end of GPA address space, ie., the allocated GPA range guarantees to
> end at the last available GPA. This ends up with the fact that selftest
> programs cannot control the alignment of the base GPA. Depending on the
> size of the allocation, the base GPA may align only on a 4K based
> bounday.
>
> The alignment of base GPA sometimes creates problems for dirty logging
> selftest where a 2MB-aligned or 1GB-aligned base GPA is needed to
> create NPT/EPT mappings for hugepages.
>
> So, fix this issue and ensure all GPA allocation starts from a 1GB bounary
> in all architectures.
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 0ef80dbdc116..96c30b8d6593 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -93,10 +93,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>                               perf_test_args.guest_page_size;
>         guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> -#ifdef __s390x__
> -       /* Align to 1M (segment size) */
> -       guest_test_phys_mem &= ~((1 << 20) - 1);
> -#endif
> +
> +       /* Align to 1G for all architectures */
> +       guest_test_phys_mem &= ~((1 << 30) - 1);
> +
>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>
>         /* Add extra memory slots for testing */
> --
> 2.33.0.259.gc128427fd7-goog
>

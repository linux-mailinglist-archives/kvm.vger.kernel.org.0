Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5302AFD5C
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgKLBbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgKKWqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:46:35 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95588C061A49
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:46:35 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id e17so3499848ili.5
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMpjhOGJVQ5RyS0PG78cexcL0eUqyZ4b+81sSJFbukE=;
        b=PZavI73SXmwE2pkPsmRMVH5LhU1Xt7pJ9Qom2RycAZhNoSWuefsHUACCfOPd8DY3g4
         hCdkT9pAj4aCAsyCN0jNjn7/X7jayyrLYa+4kVwHgCd1o7R3CId36DPxoRQezFahHcFV
         eIoMnpaOGHRszVzF6OLTYPwm4gdZY3I4/mrD0JLB0aQ0/Ozr8lhgPtT+0z4vup0LYRJE
         CCUxoPevaSYv1BclqU+QxTfB3mt0oqzjS7RF0MhErMsKuwIbiLcZdIlj11gmutNttTEx
         KmzNmbFtP4DHsOEdiVS4U096lJ55G+BYlAhdeU28uQ5LhoUAKQi2EZqw3Ch4SlIKUlzM
         QuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMpjhOGJVQ5RyS0PG78cexcL0eUqyZ4b+81sSJFbukE=;
        b=JHA+ofXaV/a4cBroMpwt/9Z24QE0hQTF0sHX7QRNrT2aeml2zWkdDVD3heAmwjZACK
         SSRfav+z7q9bNGHM9/bLkI5GGQQYJf2sN5dwl7aQtCH6O0AkhV0ihXpsHAXudmeCc5WE
         dv1jXCu9Gldp4AgofmptxefGvzU7SVNQWmHemVGEZLz3v8CD9TWbUHW6h2cC1f4PHKFa
         f0Fy5q8WcYi7aSLmesNb1kJnsNQV6e40Xpnu2/LaEkIGjqC58ewt7VemfpBhpOn8yZlU
         0jMHLssh+iwKV4BkkUxwrNFwftcjVSWk+PZzfwr56ia68k/ONMc4f5/PfN35URpRSoLh
         0XKA==
X-Gm-Message-State: AOAM530agG40noEOCYYsZEIc84ww8U5juEs0AIOI/b/jytoQpzFY7HF6
        mkCpTLb4/C7jAJwbnOeiEtBQzAjCbNru/S8NUsqq3w==
X-Google-Smtp-Source: ABdhPJyT/7ZM7LuR3tCjWiiRDATI00k79XpDNNp5dRflXZt4h0AwvUZCptHtw2O2tGKDEhrihmdcdMgXWOB0vhBZpsQ=
X-Received: by 2002:a92:50e:: with SMTP id q14mr11803516ile.306.1605134794566;
 Wed, 11 Nov 2020 14:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20201111122636.73346-1-drjones@redhat.com> <20201111122636.73346-7-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-7-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Nov 2020 14:46:23 -0800
Message-ID: <CANgfPd8jNY4877UcwNsCtCjfknvXYsf+JYcqsPm7sFp8+E+7nA@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: selftests: dirty_log_test: Remove create_vm
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 4:27 AM Andrew Jones <drjones@redhat.com> wrote:
>
> Use vm_create_with_vcpus instead of create_vm and do
> some minor cleanups around it.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 56 ++++++--------------
>  1 file changed, 16 insertions(+), 40 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 1b7375d2acea..2e0dcd453ef0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -5,8 +5,6 @@
>   * Copyright (C) 2018, Red Hat, Inc.
>   */
>
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <pthread.h>
> @@ -20,6 +18,9 @@
>
>  #define VCPU_ID                                1
>
> +#define DIRTY_MEM_BITS                 30 /* 1G */
> +#define DIRTY_MEM_SIZE                 (1UL << 30)
> +
>  /* The memory slot index to track dirty pages */
>  #define TEST_MEM_SLOT_INDEX            1
>
> @@ -353,27 +354,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>         }
>  }
>
> -static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
> -                               uint64_t extra_mem_pages, void *guest_code)
> -{
> -       struct kvm_vm *vm;
> -       uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
> -
> -       pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> -
> -       vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> -       kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
> -#ifdef __x86_64__
> -       vm_create_irqchip(vm);
> -#endif
> -       log_mode_create_vm_done(vm);
> -       vm_vcpu_add_default(vm, vcpuid, guest_code);
> -       return vm;
> -}
> -
> -#define DIRTY_MEM_BITS 30 /* 1G */
> -#define PAGE_SHIFT_4K  12
> -
>  struct test_params {
>         unsigned long iterations;
>         unsigned long interval;
> @@ -393,43 +373,39 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 return;
>         }
>
> +       pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> +
>         /*
>          * We reserve page table for 2 times of extra dirty mem which
> -        * will definitely cover the original (1G+) test range.  Here
> -        * we do the calculation with 4K page size which is the
> -        * smallest so the page number will be enough for all archs
> -        * (e.g., 64K page size guest will need even less memory for
> -        * page tables).
> +        * will definitely cover the original (1G+) test range.
>          */
> -       vm = create_vm(mode, VCPU_ID,
> -                      2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
> -                      guest_code);
> +       vm = vm_create_with_vcpus(mode, 1,
> +                       vm_calc_num_guest_pages(mode, DIRTY_MEM_SIZE * 2),
> +                       0, guest_code, (uint32_t []){ VCPU_ID });
> +
> +       log_mode_create_vm_done(vm);
>
>         guest_page_size = vm_get_page_size(vm);
> +       host_page_size = getpagesize();
> +
>         /*
>          * A little more than 1G of guest page sized pages.  Cover the
>          * case where the size is not aligned to 64 pages.
>          */
> -       guest_num_pages = (1ul << (DIRTY_MEM_BITS -
> -                                  vm_get_page_shift(vm))) + 3;
> -       guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> -
> -       host_page_size = getpagesize();
> +       guest_num_pages = vm_adjust_num_guest_pages(mode,
> +                               (1ul << (DIRTY_MEM_BITS - vm_get_page_shift(vm))) + 3);
>         host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>
>         if (!p->phys_offset) {
> -               guest_test_phys_mem = (vm_get_max_gfn(vm) -
> -                                      guest_num_pages) * guest_page_size;
> +               guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) * guest_page_size;
>                 guest_test_phys_mem &= ~(host_page_size - 1);
>         } else {
>                 guest_test_phys_mem = p->phys_offset;
>         }
> -
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
>         guest_test_phys_mem &= ~((1 << 20) - 1);
>  #endif
> -
>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>
>         bmap = bitmap_alloc(host_num_pages);
> --
> 2.26.2
>

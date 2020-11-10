Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A851D2AE2F4
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 23:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732920AbgKJWN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 17:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgKJWN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 17:13:26 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DE7C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 14:13:25 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id e17so75909ili.5
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 14:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8XxF7P4BIHJRv/Tx2FeTUKVQIG5HEpX1bri88ef7oU=;
        b=LON6JyYuVC4idgGsUdUhJOm+eqxhTHC1CF66ELDspK4T+rv+sjesU0LdhPHBcb8MwK
         0WROkHStVdzz3Lx50mJRuGhF0jsCVXebfBPRJZcmCvDxF4LoxeAPYyZPnTbzcOPxN9Gf
         iPg6AbSPIBhIDQQvTS6a5HCN3jt3kYlBm6vL1C4x+e1F7CBEdOOh/TEOAKBr+7cF0g/P
         whEL8VQX2+6hkQjrLENi2rQBje9uMVasT9Ew4HL+x5epviiguv5vrb8J5ffLkxIGayHa
         O1KAHKJsqr/Bf/cv4uGQEEQWgnm/c1FTCgxPEUj/86WzeG/husF56r0XKQYqSkPQw2G/
         5JgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8XxF7P4BIHJRv/Tx2FeTUKVQIG5HEpX1bri88ef7oU=;
        b=mc9FLwJaClq6r/E7Zb5iKc7GALxKWe14Xbe5MEbXWTFYH+Pf91GS5Axs3cLI9x6VcA
         XWlfhy9TDkZg8NyJyUh9BjhQaMAeiVbMZ9ZbqFAvv8NoZsISB48XqEvEdoTxPGdSE10O
         ee25yUpuZqxvh9uq202+ozr78SsG5P1+cFyc0w3PqEqltHPdI0vKiwCiUQKUp5ZNuoxy
         WnzoQdTrJ631NSGVGYy4BeibLcVh7WXWQS5BkZwOUGmSxxx/PRpkxMm5Ur2yj2BUCuIu
         hnaZ1YedXX+fChvnTY/tn0E0ZftkRrXWVMLspgGXV00TQgujDYRVcPrpbbIDzOeOunjK
         zBtQ==
X-Gm-Message-State: AOAM531Tgw/ynX1XtvjUxViv7TsIOlOQrgtOBNsiZGJM+uw3XoZ6aYNu
        VwwSyBPCqH7cHLwJvtOKaRu7V2wJ/Ru8CJpebKMtKQ==
X-Google-Smtp-Source: ABdhPJw/UO9svn7BvFdGK5UB2NXubpnlhApdiDiIXfPZVuT+EnTPuhWcCWnhzPQo1QRsYZ9+xMfJohZLPfbfWXX7tL4=
X-Received: by 2002:a92:50e:: with SMTP id q14mr7603813ile.306.1605046405057;
 Tue, 10 Nov 2020 14:13:25 -0800 (PST)
MIME-Version: 1.0
References: <20201110204802.417521-1-drjones@redhat.com> <20201110204802.417521-6-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-6-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 10 Nov 2020 14:13:14 -0800
Message-ID: <CANgfPd8M0eBMGSu7di_OKx-VK16DgLd4iKA=syU8cdL9JntxbQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] KVM: selftests: Introduce vm_create_[default_]_with_vcpus
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 12:48 PM Andrew Jones <drjones@redhat.com> wrote:
>
> Introduce new vm_create variants that also takes a number of vcpus,
> an amount of per-vcpu pages, and optionally a list of vcpuids. These
> variants will create default VMs with enough additional pages to
> cover the vcpu stacks, per-vcpu pages, and pagetable pages for all.
> The new 'default' variant uses VM_MODE_DEFAULT, whereas the other
> new variant accepts the mode as a parameter.
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 10 ++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 ++++++++++++++++---
>  2 files changed, 40 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 48b48a0014e2..bc8db80309f5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -261,6 +261,16 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>                                  void *guest_code);
>
> +/* Same as vm_create_default, but can be used for more than one vcpu */
> +struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
> +                                           uint32_t num_percpu_pages, void *guest_code,
> +                                           uint32_t vcpuids[]);
> +
> +/* Like vm_create_default_with_vcpus, but accepts mode as a parameter */
> +struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> +                                   uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> +                                   void *guest_code, uint32_t vcpuids[]);
> +
>  /*
>   * Adds a vCPU with reasonable defaults (e.g. a stack)
>   *
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index a7e28e33fc3b..b31a4e988a5d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -272,8 +272,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>         return vm;
>  }
>
> -struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> -                                void *guest_code)
> +struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
> +                                   uint64_t extra_mem_pages, uint32_t num_percpu_pages,
> +                                   void *guest_code, uint32_t vcpuids[])
>  {
>         /* The maximum page table size for a memory region will be when the
>          * smallest pages are used. Considering each page contains x page
> @@ -281,10 +282,18 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>          * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
>          * than N/x*2.
>          */
> -       uint64_t extra_pg_pages = (extra_mem_pages / PTES_PER_MIN_PAGE) * 2;
> +       uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
> +       uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> +       uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
>         struct kvm_vm *vm;
> +       int i;
> +
> +       TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
> +                   "nr_vcpus = %d too large for host, max-vcpus = %d",
> +                   nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
>
> -       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> +       pages = vm_adjust_num_guest_pages(mode, pages);
> +       vm = vm_create(mode, pages, O_RDWR);

I think this will substantially change the behavior of this function
to create a much larger memslot 0. In the existing code, the memslot
created in vm_create is just sized large enough for the stacks and
page tables. Another memslot is then created for the memory under
test.

I think separating the memslots is a good arrangement because it
limits the extent to which kernel bugs could screw up the test and
makes it easier to debug if you're testing something like dirty
logging. It's also useful if you wanted to back the memslot under test
with a different kind of memory from memslot 0. e.g. memslot 0 could
use anonymous pages and the slot(s) under test could use hugetlbfs.
You might also want multiple memslots to assign them to different NUMA
nodes.

Is that change intentional? I would suggest not adding vcpu_pages to
the calculation for pages above, similar to what it was before:
uint64_t pages = DEFAULT_GUEST_PHY_PAGES + extra_pg_pages;

>
>         kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
>
> @@ -292,11 +301,27 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>         vm_create_irqchip(vm);
>  #endif
>
> -       vm_vcpu_add_default(vm, vcpuid, guest_code);
> +       for (i = 0; i < nr_vcpus; ++i)
> +               vm_vcpu_add_default(vm, vcpuids ? vcpuids[i] : i, guest_code);
>
>         return vm;
>  }
>
> +struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_mem_pages,
> +                                           uint32_t num_percpu_pages, void *guest_code,
> +                                           uint32_t vcpuids[])
> +{
> +       return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, extra_mem_pages,
> +                                   num_percpu_pages, guest_code, vcpuids);
> +}
> +
> +struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
> +                                void *guest_code)
> +{
> +       return vm_create_default_with_vcpus(1, extra_mem_pages, 0, guest_code,
> +                                           (uint32_t []){ vcpuid });
> +}
> +
>  /*
>   * VM Restart
>   *
> --
> 2.26.2
>

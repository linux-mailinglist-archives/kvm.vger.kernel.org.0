Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665D644DB33
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhKKRqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhKKRqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 12:46:12 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D9C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:43:23 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id e144so7926620iof.3
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5l5PkD//IvgvNQIs7jK0WhBYA7t8wndNOeYxzbrv78U=;
        b=O5JdeUHKwk20qHQInw9u+Ysed+uwSEjiiYbP74pYNNEfqIPTgVMtNlEGpuMAV6ZK4v
         PRf0MCFfdLtYG5Ht0Q/xrpjkPWzqLF0hdxwSz6NdVpREVJjg6lOU02DGaoOFgp7HuBsb
         iBxTOGCPQLM9P+WkP4cWp9GynDvJiZkl/gTpg6HRDgEId/jqaRf+IymfyyEyP2jAyd/0
         2b8p9KvRgrvpmxwy24g5hFAPcjMbzKMD+xzcBz4beSSHQCD1OxfVF0zu36W9pM4599W6
         Z64VL7BXcWANrYSBSTJ6hzeFmOrRlrfliwBHMrcD5+Wy0sfZ76cvr5R6kPOoZyfqrAFM
         g1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5l5PkD//IvgvNQIs7jK0WhBYA7t8wndNOeYxzbrv78U=;
        b=y2CAyhmMHcRJHP5H8tRiAHSoRC37i51v2pllExwo8JFGXyXdA4MmuwUI0ARQYFRw37
         P1Lib6t2isQyVvehX1erh4/LUkHwXsp2++umAaTIJB/1Xp5MH7Y7iflsG2S97CLQj4Yt
         +xd4yhBH2D8++v2Nsb4BXMSbOOguw0lQqVaKRjfyN5kucrNl2QVgaPw6Tl8pZDxVWLG/
         k3v/wms24Medtpa+PCjKd9jtGOoTYsQGekkxS84Gbm5iydMnf5i4UEiLXCDq/U2YEfSW
         HMwMG80leXcLnerQ0VNH3Jw8XG4SqjPY8Wv/DMI9Wh/ubwtOPtUWpwkRQqnIuBtD9QR5
         hPVQ==
X-Gm-Message-State: AOAM533pDs4mWM2NE0LdRPq0j8t8ANX9OgwHE3BuIac1DYMeUHOV7oZB
        s60JnDvbZzzFWb8/ASYAXVSrL0xXu96/1xC3zexUjQ==
X-Google-Smtp-Source: ABdhPJz8Hv0jzIu2HEbjQivT3Adylyc6uc3JGR95qsPLxNAK8A55Y+auRwgl+TZE4mHeu8Rop6uIzXxPcOkwxOofrWI=
X-Received: by 2002:a02:624c:: with SMTP id d73mr6816048jac.32.1636652602554;
 Thu, 11 Nov 2021 09:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com> <20211111000310.1435032-3-dmatlack@google.com>
In-Reply-To: <20211111000310.1435032-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 09:43:11 -0800
Message-ID: <CANgfPd82cPXjsAgLVMhmgjpSpiomWvYdn+x_CVFoc-=wAT0fPQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] KVM: selftests: Expose align() helpers to tests
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 4:03 PM David Matlack <dmatlack@google.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Refactor align() to work with non-pointers and split into separate
> helpers for aligning up vs. down. Add align_ptr_up() for use with
> pointers. Expose all helpers so that they can be used by tests and/or
> other utilities.  The align_down() helper in particular will be used to
> ensure gpa alignment for hugepages.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Added sepearate up/down helpers and replaced open-coded alignment

Nit: separate

>  bit math throughout the KVM selftests.]
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

This is wonderful.

> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  |  6 ++---
>  .../testing/selftests/kvm/include/test_util.h | 25 +++++++++++++++++++
>  .../selftests/kvm/kvm_page_table_test.c       |  2 +-
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 13 ++--------
>  .../selftests/kvm/lib/perf_test_util.c        |  4 +--
>  6 files changed, 34 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 792c60e1b17d..3fcd89e195c7 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -115,7 +115,7 @@ static void guest_code(void)
>                         addr = guest_test_virt_mem;
>                         addr += (READ_ONCE(random_array[i]) % guest_num_pages)
>                                 * guest_page_size;
> -                       addr &= ~(host_page_size - 1);
> +                       addr = align_down(addr, host_page_size);
>                         *(uint64_t *)addr = READ_ONCE(iteration);
>                 }
>
> @@ -737,14 +737,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         if (!p->phys_offset) {
>                 guest_test_phys_mem = (vm_get_max_gfn(vm) -
>                                        guest_num_pages) * guest_page_size;
> -               guest_test_phys_mem &= ~(host_page_size - 1);
> +               guest_test_phys_mem = align_down(guest_test_phys_mem, host_page_size);
>         } else {
>                 guest_test_phys_mem = p->phys_offset;
>         }
>
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
> -       guest_test_phys_mem &= ~((1 << 20) - 1);
> +       guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
>  #endif
>
>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index f8fddc84c0d3..78c06310cc0e 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -117,4 +117,29 @@ static inline bool backing_src_is_shared(enum vm_mem_backing_src_type t)
>         return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;
>  }
>
> +/* Aligns x up to the next multiple of size. Size must be a power of 2. */
> +static inline uint64_t align_up(uint64_t x, uint64_t size)
> +{
> +       uint64_t mask = size - 1;
> +
> +       TEST_ASSERT(size != 0 && !(size & (size - 1)),
> +                   "size not a power of 2: %lu", size);
> +       return ((x + mask) & ~mask);
> +}
> +
> +static inline uint64_t align_down(uint64_t x, uint64_t size)
> +{
> +       uint64_t x_aligned_up = align_up(x, size);
> +
> +       if (x == x_aligned_up)
> +               return x;
> +       else
> +               return x_aligned_up - size;
> +}
> +
> +static inline void *align_ptr_up(void *x, size_t size)
> +{
> +       return (void *)align_up((unsigned long)x, size);
> +}
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index 36407cb0ec85..3836322add00 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -280,7 +280,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
>  #ifdef __s390x__
>         alignment = max(0x100000, alignment);
>  #endif
> -       guest_test_phys_mem &= ~(alignment - 1);
> +       guest_test_phys_mem = align_down(guest_test_virt_mem, alignment);
>
>         /* Set up the shared data structure test_args */
>         test_args.vm = vm;
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index eac44f5d0db0..13e8e3dcf984 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -157,8 +157,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>                         "memsize of 0,\n"
>                         "  phdr index: %u p_memsz: 0x%" PRIx64,
>                         n1, (uint64_t) phdr.p_memsz);
> -               vm_vaddr_t seg_vstart = phdr.p_vaddr;
> -               seg_vstart &= ~(vm_vaddr_t)(vm->page_size - 1);
> +               vm_vaddr_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
>                 vm_vaddr_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
>                 seg_vend |= vm->page_size - 1;
>                 size_t seg_size = seg_vend - seg_vstart + 1;
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b624c24290dd..63375118d48f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -22,15 +22,6 @@
>
>  static int vcpu_mmap_sz(void);
>
> -/* Aligns x up to the next multiple of size. Size must be a power of 2. */
> -static void *align(void *x, size_t size)
> -{
> -       size_t mask = size - 1;
> -       TEST_ASSERT(size != 0 && !(size & (size - 1)),
> -                   "size not a power of 2: %lu", size);
> -       return (void *) (((size_t) x + mask) & ~mask);
> -}
> -
>  /*
>   * Open KVM_DEV_PATH if available, otherwise exit the entire program.
>   *
> @@ -911,7 +902,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>                     region->mmap_start, errno);
>
>         /* Align host address */
> -       region->host_mem = align(region->mmap_start, alignment);
> +       region->host_mem = align_ptr_up(region->mmap_start, alignment);
>
>         /* As needed perform madvise */
>         if ((src_type == VM_MEM_SRC_ANONYMOUS ||
> @@ -954,7 +945,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>                             "mmap of alias failed, errno: %i", errno);
>
>                 /* Align host alias address */
> -               region->host_alias = align(region->mmap_alias, alignment);
> +               region->host_alias = align_ptr_up(region->mmap_alias, alignment);
>         }
>  }
>
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 0ef80dbdc116..6b8d5020dc54 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -92,10 +92,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>                               perf_test_args.guest_page_size;
> -       guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> +       guest_test_phys_mem = align_down(guest_test_phys_mem, perf_test_args.host_page_size);
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
> -       guest_test_phys_mem &= ~((1 << 20) - 1);
> +       guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
>  #endif
>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>

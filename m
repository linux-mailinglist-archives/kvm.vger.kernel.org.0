Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED1A2AFBFE
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgKLBb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbgKKWv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:51:59 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234EBC0617A6
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:51:59 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id r12so4036198iot.4
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S5DO/UNI7UIuEvZyF68rYoxD14tI6hj6wKurCVFwPRM=;
        b=hDeGTOFYinQgw4kz4Pmeha4B8OaX3BYCPMDyaFhgi7VyrMAGRPT3WC8OkGLbR03mpq
         h08vieprh5FMV0SIQKaKsTkja+qYDdg8juJMowjSdVYn5ZcvtGpf/a5nWhS1CRZhCZeM
         C2eV7SzARDQCnrcQ0XI8sPnO6664Jq6MWSz3WaFf7VNuPxfyPW9ML41IIP6RshV/L8fg
         bfvCEzicN1aDGJbR3dZF/kzbQ5f5HTUl3Hdyfq03OobewBUFaghwEowg9w8fKeEcPhkp
         0v+vjEiZqcse7Kltd0fsQceRPbYne/Y6J8pRGrTifhU137YpNc2alwGRjgQy/X331QeG
         ozWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S5DO/UNI7UIuEvZyF68rYoxD14tI6hj6wKurCVFwPRM=;
        b=YUL4z8mdzQDhFn6+dTOiPubzZz7YXB+zG0RI8n+qyHjBxJuyXBiLyZHqRXebTPIBHB
         Rdof2/eS/HJUBuMi09nIOH65/wY0BJRM7Hcx7fHHBpMFJR43pKn/+dSb0cEgxir4XDaI
         tCWLg1v+byhyTD2C8OSpna+6y0U5xHBlaKgsOYZUTTjRuzUcegivPDcTuBhnlbQpFmGf
         ekclDGwpaYtyQYJYBFH5rF2ixsPVb9Cj2szk8zeU5sXgByCdbFpe6JP2Izz5b6wTk9B6
         98EhzitzaU3Avr/BNgqX5zp0WuwtxVT57ut1ACyiTY1pWwy/zMvzKH1yxee4QQ3oNhLm
         uKfw==
X-Gm-Message-State: AOAM530OIpARWMwIh7sdcxYdU1R5fLzocyEFLYPpXyGWb6xWC9+Goz//
        NfKCL7gHQJ6hdCv/9qIuXV0ceYPhNL2udH+NYAO36A==
X-Google-Smtp-Source: ABdhPJxw0ZUJgc0hxijz5DRnqlVHW6QiUE417C1lwAAdSWSOe2wEENzHNKaCCV9Nr2BfLACEyYNT/VVqHKjunfI9RfQ=
X-Received: by 2002:a02:cba2:: with SMTP id v2mr21870324jap.44.1605135118184;
 Wed, 11 Nov 2020 14:51:58 -0800 (PST)
MIME-Version: 1.0
References: <20201111122636.73346-1-drjones@redhat.com> <20201111122636.73346-8-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-8-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Nov 2020 14:51:47 -0800
Message-ID: <CANgfPd_ZnV+xDjorgAJUXZV9m5cG1-3+uWCh7CUEOnSyj26X+A@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] KVM: selftests: Use vm_create_with_vcpus in create_vm
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
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/demand_paging_test.c        |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       |  2 -
>  .../testing/selftests/kvm/include/kvm_util.h  |  8 ++++
>  .../selftests/kvm/include/perf_test_util.h    | 47 +++++--------------
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  9 +---
>  5 files changed, 21 insertions(+), 47 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 946161a9ce2d..b0c41de32e9b 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -7,7 +7,7 @@
>   * Copyright (C) 2019, Google, Inc.
>   */
>
> -#define _GNU_SOURCE /* for program_invocation_name and pipe2 */
> +#define _GNU_SOURCE /* for pipe2 */
>
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index b448c17bd7aa..c606dbb36244 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -8,8 +8,6 @@
>   * Copyright (C) 2020, Google, Inc.
>   */
>
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <time.h>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index bc8db80309f5..011e8c6b4600 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -70,6 +70,14 @@ enum vm_guest_mode {
>  #define vm_guest_mode_string(m) vm_guest_mode_string[m]
>  extern const char * const vm_guest_mode_string[];
>
> +struct vm_guest_mode_params {
> +       unsigned int pa_bits;
> +       unsigned int va_bits;
> +       unsigned int page_size;
> +       unsigned int page_shift;
> +};
> +extern const struct vm_guest_mode_params vm_guest_mode_params[];
> +
>  enum vm_mem_backing_src_type {
>         VM_MEM_SRC_ANONYMOUS,
>         VM_MEM_SRC_ANONYMOUS_THP,
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 2618052057b1..5f0719629a4e 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -13,9 +13,6 @@
>
>  #define MAX_VCPUS 512
>
> -#define PAGE_SHIFT_4K  12
> -#define PTES_PER_4K_PT 512
> -
>  #define TEST_MEM_SLOT_INDEX            1
>
>  /* Default guest test virtual memory offset */
> @@ -94,41 +91,26 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>                                 uint64_t vcpu_memory_bytes)
>  {
>         struct kvm_vm *vm;
> -       uint64_t pages = DEFAULT_GUEST_PHY_PAGES;
>         uint64_t guest_num_pages;
>
> -       /* Account for a few pages per-vCPU for stacks */
> -       pages += DEFAULT_STACK_PGS * vcpus;
> -
> -       /*
> -        * Reserve twice the ammount of memory needed to map the test region and
> -        * the page table / stacks region, at 4k, for page tables. Do the
> -        * calculation with 4K page size: the smallest of all archs. (e.g., 64K
> -        * page size guest will need even less memory for page tables).
> -        */
> -       pages += (2 * pages) / PTES_PER_4K_PT;
> -       pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
> -                PTES_PER_4K_PT;
> -       pages = vm_adjust_num_guest_pages(mode, pages);
> -
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
> -       vm = vm_create(mode, pages, O_RDWR);
> -       kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
> -#ifdef __x86_64__
> -       vm_create_irqchip(vm);
> -#endif
> -
> -       perf_test_args.vm = vm;
> -       perf_test_args.guest_page_size = vm_get_page_size(vm);
>         perf_test_args.host_page_size = getpagesize();
> +       perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
> +
> +       guest_num_pages = vm_adjust_num_guest_pages(mode,
> +                               (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
>
> +       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
> +                   "Guest memory size is not host page size aligned.");
>         TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
>                     "Guest memory size is not guest page size aligned.");
>
> -       guest_num_pages = (vcpus * vcpu_memory_bytes) /
> -                         perf_test_args.guest_page_size;
> -       guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> +       vm = vm_create_with_vcpus(mode, vcpus,
> +                                 (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
> +                                 0, guest_code, NULL);
> +
> +       perf_test_args.vm = vm;
>
>         /*
>          * If there should be more memory in the guest test region than there
> @@ -140,18 +122,13 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>                     guest_num_pages, vm_get_max_gfn(vm), vcpus,
>                     vcpu_memory_bytes);
>
> -       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
> -                   "Guest memory size is not host page size aligned.");
> -
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>                               perf_test_args.guest_page_size;
>         guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> -
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
>         guest_test_phys_mem &= ~((1 << 20) - 1);
>  #endif
> -
>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>
>         /* Add an extra memory slot for testing */
> @@ -177,8 +154,6 @@ static void add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes)
>         for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
>                 vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
>
> -               vm_vcpu_add_default(vm, vcpu_id, guest_code);
> -
>  #ifdef __x86_64__
>                 vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
>  #endif
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b31a4e988a5d..ff4a0310c420 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -143,14 +143,7 @@ const char * const vm_guest_mode_string[] = {
>  _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
>                "Missing new mode strings?");
>
> -struct vm_guest_mode_params {
> -       unsigned int pa_bits;
> -       unsigned int va_bits;
> -       unsigned int page_size;
> -       unsigned int page_shift;
> -};
> -
> -static const struct vm_guest_mode_params vm_guest_mode_params[] = {
> +const struct vm_guest_mode_params vm_guest_mode_params[] = {
>         { 52, 48,  0x1000, 12 },
>         { 52, 48, 0x10000, 16 },
>         { 48, 48,  0x1000, 12 },
> --
> 2.26.2
>

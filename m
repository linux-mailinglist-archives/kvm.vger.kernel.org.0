Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1043182E9
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBKBJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhBKBJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:09:39 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C708C06178B
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:09:20 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p132so4005055iod.11
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOxzzb6yRl4hMPTeH8DBjmS0bF7z1J+Al7VlESjqRdk=;
        b=kFhTAD0QPIKr3/RJEsHZogqo2XLlSO/QA9+ZfOQ108yLyRHNDSSJhssv+01RXz+bhd
         /ggRKeIPFhcT2CM1eCXFxYhIDAHCqJgeCODZFwS05c2pjNlAkRZ7GGFwkTyUNIjaBFNy
         ggTvh8woI68yg6VD9v3fxUFQzo1KrMEqGyGRtrx1I7CtEX5gZs43PQ8HnWtrvw9RCEED
         933ac4Yj/AczHF1Sa/bR1sXoZWY1/fEnm3p254hcFe4ONKwdgoQyfoVnDBOoxEmCLoDZ
         sUZTmK5vCUygeWqyP3jZIvtK5cFBcPmnspPEGI5CqXGTpbbEopBx8lBUg5UW+c+uAxr4
         uxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOxzzb6yRl4hMPTeH8DBjmS0bF7z1J+Al7VlESjqRdk=;
        b=LKuPGrGoKM5SnONqEAzAuvKXZigakc3BIhK44KVChlDqeiBMpFUYRXSAdizs+aY49S
         g+D5MAoK8oPRjrH5kZ3Gr+D/JKMP/tdG9hK04DgrGGl22YdFURLApuW0BH/XTpzmUh1T
         x/9Ne/UIDk0kEwTaleZcSxSuTaEFi5t8a8MmiZqYkM2EV/FiqyDjCM09DSlxZi88Tb8F
         GwlxPVY31wfMEYGr0aHx4gls00pOJhAkn+HsGtmw/RKorcw52ghtqxC0jPgTHej2Aper
         mB0QDFGimX1qJYlerHOm49tDS+pw/KCzaFyL1ES5e6buuvzsx4Pr64itK85P5ap1yFC+
         vqtg==
X-Gm-Message-State: AOAM5300mXUigb7wM3nBE8qM3STd9/aaubLCUKISrIASsJ1vtrzDmWdD
        xPHM3+3tmJlIWeO3UcyNh8/bncG7MeuqgEQ5BotqEQ==
X-Google-Smtp-Source: ABdhPJztdKGDRkdYNbZNcCBtgOD9fhyfCZJZZzKTNZW2xEytFDgjHYKoAPkBEsEsYSfdXWHY3eIv38H5pKFFYURHUlM=
X-Received: by 2002:a02:30cb:: with SMTP id q194mr6134571jaq.57.1613005759954;
 Wed, 10 Feb 2021 17:09:19 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-7-seanjc@google.com>
In-Reply-To: <20210210230625.550939-7-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:09:08 -0800
Message-ID: <CANgfPd872uLa4iziZko86cQerSK56fUS8iNzzOevF3PmThYfvQ@mail.gmail.com>
Subject: Re: [PATCH 06/15] KVM: selftests: Use shorthand local var to access
 struct perf_tests_args
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use 'pta' as a local pointer to the global perf_tests_args in order to
> shorten line lengths and make the code borderline readable.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/lib/perf_test_util.c        | 36 ++++++++++---------
>  1 file changed, 19 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index f187b86f2e14..73b0fccc28b9 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -23,7 +23,8 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
>   */
>  static void guest_code(uint32_t vcpu_id)
>  {
> -       struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> +       struct perf_test_args *pta = &perf_test_args;
> +       struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
>         uint64_t gva;
>         uint64_t pages;
>         int i;
> @@ -36,9 +37,9 @@ static void guest_code(uint32_t vcpu_id)
>
>         while (true) {
>                 for (i = 0; i < pages; i++) {
> -                       uint64_t addr = gva + (i * perf_test_args.guest_page_size);
> +                       uint64_t addr = gva + (i * pta->guest_page_size);
>
> -                       if (i % perf_test_args.wr_fract == 0)
> +                       if (i % pta->wr_fract == 0)
>                                 *(uint64_t *)addr = 0x0123456789ABCDEF;
>                         else
>                                 READ_ONCE(*(uint64_t *)addr);
> @@ -52,32 +53,32 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                                    uint64_t vcpu_memory_bytes,
>                                    enum vm_mem_backing_src_type backing_src)
>  {
> +       struct perf_test_args *pta = &perf_test_args;
>         struct kvm_vm *vm;
>         uint64_t guest_num_pages;
>
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
> -       perf_test_args.host_page_size = getpagesize();
> +       pta->host_page_size = getpagesize();
>
>         /*
>          * Snapshot the non-huge page size.  This is used by the guest code to
>          * access/dirty pages at the logging granularity.
>          */
> -       perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
> +       pta->guest_page_size = vm_guest_mode_params[mode].page_size;
>
>         guest_num_pages = vm_adjust_num_guest_pages(mode,
> -                               (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
> +                               (vcpus * vcpu_memory_bytes) / pta->guest_page_size);
>
> -       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
> +       TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
>                     "Guest memory size is not host page size aligned.");
> -       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
> +       TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
>                     "Guest memory size is not guest page size aligned.");
>
>         vm = vm_create_with_vcpus(mode, vcpus,
> -                                 (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
> +                                 (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
>                                   0, guest_code, NULL);
> -
> -       perf_test_args.vm = vm;
> +       pta->vm = vm;
>
>         /*
>          * If there should be more memory in the guest test region than there
> @@ -90,8 +91,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                     vcpu_memory_bytes);
>
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
> -                             perf_test_args.guest_page_size;
> -       guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> +                             pta->guest_page_size;
> +       guest_test_phys_mem &= ~(pta->host_page_size - 1);

Not really germane to this patch, but the align macro could be used
here as well.

>         if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
>             backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
>                 guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
> @@ -125,30 +126,31 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
>                            uint64_t vcpu_memory_bytes,
>                            bool partition_vcpu_memory_access)
>  {
> +       struct perf_test_args *pta = &perf_test_args;
>         vm_paddr_t vcpu_gpa;
>         struct perf_test_vcpu_args *vcpu_args;
>         int vcpu_id;
>
>         for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> -               vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> +               vcpu_args = &pta->vcpu_args[vcpu_id];
>
>                 vcpu_args->vcpu_id = vcpu_id;
>                 if (partition_vcpu_memory_access) {
>                         vcpu_args->gva = guest_test_virt_mem +
>                                          (vcpu_id * vcpu_memory_bytes);
>                         vcpu_args->pages = vcpu_memory_bytes /
> -                                          perf_test_args.guest_page_size;
> +                                          pta->guest_page_size;
>                         vcpu_gpa = guest_test_phys_mem +
>                                    (vcpu_id * vcpu_memory_bytes);
>                 } else {
>                         vcpu_args->gva = guest_test_virt_mem;
>                         vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
> -                                          perf_test_args.guest_page_size;
> +                                          pta->guest_page_size;
>                         vcpu_gpa = guest_test_phys_mem;
>                 }
>
>                 pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
>                          vcpu_id, vcpu_gpa, vcpu_gpa +
> -                        (vcpu_args->pages * perf_test_args.guest_page_size));
> +                        (vcpu_args->pages * pta->guest_page_size));
>         }
>  }
> --
> 2.30.0.478.g8a0d178c01-goog
>

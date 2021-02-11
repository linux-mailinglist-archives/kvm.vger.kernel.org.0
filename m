Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7A318305
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhBKBWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhBKBWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:22:52 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030DCC061574
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:22:12 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id y5so3729669ilg.4
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHAwlqEsJZqXXlaYYLdWeimBUUl5Q8QJh5QhboJp+wI=;
        b=P7iHgxs6yNhdEwBpGa0NSuD55vAH6c4rc2iIQk+cJwiKlYLeCZY/TbXB4+W+5r7O9T
         eQjuiwP6CMfLCyhtnE3dDTgya76Q/hsUfeL1qVN2ZtmV1QU8c620dNdSpmU4i2rAtoYD
         +sXQbEHBHioCwGMOGt8WzaIDzOEqFMmjjRkEo8GMtGb4WpQv2+EVRu7FQi4iwMP0ydd7
         z56ETWRIKV4sC7hWcgdmBvOQenM3Z4YySEJ08tFLPm0i/fY2QBimgp8zQcC3tGLeloOT
         FDHWWYCecQ+he0kh6yvUlJqfgKBjYV3JtSi2XbORQs98+YUFtlE3aVpv0488t8IRIxzU
         vUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHAwlqEsJZqXXlaYYLdWeimBUUl5Q8QJh5QhboJp+wI=;
        b=YIACbpF4gtwcQW8YVIDzWOd+6pqjCxp2/sz9YrF2eOJhIjUKUNZLweHqglCkbaQf7Y
         3CwduwWjDCA3DtcIxxIrEvkfqTBHDrPdI1spgiLsZPNv3T14IpVuUu8veoE02VpvmGRt
         1BBUFO8eqKr1INr7MKhD5fNR6JMN+NuVEgP+sWemT7O8jpePZPBdmX5TLFVAUeHSAZeZ
         NqUbSDJMLOxIjK3jeFvLzh4lFEvQemMVuhScLcXQPqy/7lEgak6EBXcF87K5rpcp796w
         lErGR4IXyzDQ/7dvZHp+PoMEdenni16fcJMbenY53g9YxNaKmGyI0xhN9ewfHz58cbzv
         yFXA==
X-Gm-Message-State: AOAM533ioCDWmtD1shirNBTOsdYwVhg+1/hX4msIDLz4mfaYNsIAF2wQ
        A1sVg7wE1PpBoFXNMezV6L3I4tb2Antwvv4wqGg2Xw==
X-Google-Smtp-Source: ABdhPJyF6xv4jvRlcmFQMIg11mawZvxzaXqUy0uOm7m+3OIGcKwQDvd6M3ZnL0G6CidlWheLmgVqf2DI6B/x2/fpk4k=
X-Received: by 2002:a05:6e02:1888:: with SMTP id o8mr3504355ilu.154.1613006531238;
 Wed, 10 Feb 2021 17:22:11 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-10-seanjc@google.com>
In-Reply-To: <20210210230625.550939-10-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:22:00 -0800
Message-ID: <CANgfPd8itawTsza-SPSMehUEAAJ4DWtSQX4QRbHg1kX4c6VRBg@mail.gmail.com>
Subject: Re: [PATCH 09/15] KVM: selftests: Move per-VM GPA into perf_test_args
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
> Move the per-VM GPA into perf_test_args instead of storing it as a
> separate global variable.  It's not obvious that guest_test_phys_mem
> holds a GPA, nor that it's connected/coupled with per_vcpu->gpa.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/include/perf_test_util.h    |  8 +-----
>  .../selftests/kvm/lib/perf_test_util.c        | 28 ++++++++-----------
>  .../kvm/memslot_modification_stress_test.c    |  2 +-
>  3 files changed, 13 insertions(+), 25 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 4d53238b139f..cccf1c44bddb 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -29,6 +29,7 @@ struct perf_test_vcpu_args {
>  struct perf_test_args {
>         struct kvm_vm *vm;
>         uint64_t host_page_size;
> +       uint64_t gpa;
>         uint64_t guest_page_size;
>         int wr_fract;
>
> @@ -37,13 +38,6 @@ struct perf_test_args {
>
>  extern struct perf_test_args perf_test_args;
>
> -/*
> - * Guest physical memory offset of the testing memory slot.
> - * This will be set to the topmost valid physical address minus
> - * the test memory size.
> - */
> -extern uint64_t guest_test_phys_mem;
> -
>  struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                                    uint64_t vcpu_memory_bytes,
>                                    enum vm_mem_backing_src_type backing_src);
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index f22ce1836547..03f125236021 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -9,8 +9,6 @@
>
>  struct perf_test_args perf_test_args;
>
> -uint64_t guest_test_phys_mem;
> -
>  /*
>   * Guest virtual memory offset of the testing memory slot.
>   * Must not conflict with identity mapped test code.
> @@ -87,29 +85,25 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
>                     "Requested more guest memory than address space allows.\n"
>                     "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> -                   guest_num_pages, vm_get_max_gfn(vm), vcpus,
> -                   vcpu_memory_bytes);
> +                   guest_num_pages, vm_get_max_gfn(vm), vcpus, vcpu_memory_bytes);
>
> -       guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
> -                             pta->guest_page_size;
> -       guest_test_phys_mem &= ~(pta->host_page_size - 1);
> +       pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
> +       pta->gpa &= ~(pta->host_page_size - 1);

Also not related to this patch, but another case for align.

>         if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
>             backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
> -               guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
> -
> +               pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);

also align

>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
> -       guest_test_phys_mem &= ~((1 << 20) - 1);
> +       pta->gpa &= ~((1 << 20) - 1);

And here again (oof)

>  #endif
> -       pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
> +       pr_info("guest physical test memory offset: 0x%lx\n", pta->gpa);
>
>         /* Add an extra memory slot for testing */
> -       vm_userspace_mem_region_add(vm, backing_src, guest_test_phys_mem,
> -                                   PERF_TEST_MEM_SLOT_INDEX,
> -                                   guest_num_pages, 0);
> +       vm_userspace_mem_region_add(vm, backing_src, pta->gpa,
> +                                   PERF_TEST_MEM_SLOT_INDEX, guest_num_pages, 0);
>
>         /* Do mapping for the demand paging memory slot */
> -       virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
> +       virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages, 0);
>
>         ucall_init(vm, NULL);
>
> @@ -139,13 +133,13 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
>                                          (vcpu_id * vcpu_memory_bytes);
>                         vcpu_args->pages = vcpu_memory_bytes /
>                                            pta->guest_page_size;
> -                       vcpu_args->gpa = guest_test_phys_mem +
> +                       vcpu_args->gpa = pta->gpa +
>                                          (vcpu_id * vcpu_memory_bytes);
>                 } else {
>                         vcpu_args->gva = guest_test_virt_mem;
>                         vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
>                                            pta->guest_page_size;
> -                       vcpu_args->gpa = guest_test_phys_mem;
> +                       vcpu_args->gpa = pta->gpa;
>                 }
>
>                 pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 6096bf0a5b34..569bb1f55bdf 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -121,7 +121,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         add_remove_memslot(vm, p->memslot_modification_delay,
>                            p->nr_memslot_modifications,
> -                          guest_test_phys_mem +
> +                          perf_test_args.gpa +
>                            (guest_percpu_mem_size * nr_vcpus) +
>                            perf_test_args.host_page_size +
>                            perf_test_args.guest_page_size);
> --
> 2.30.0.478.g8a0d178c01-goog
>

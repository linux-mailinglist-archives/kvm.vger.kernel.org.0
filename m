Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F032AE201
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 22:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgKJVrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 16:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731759AbgKJVrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 16:47:48 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D06C0613D1
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:47:48 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k1so13656895ilc.10
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/3/LjBBUJR12eFtgYhlmtK97IfljMWykbg20pJkYoc=;
        b=QsRLrMcLoh2b+IeBcbZiIxbLUo7QXOiePyVcyRc0H0/fdrMAXydcgq1kK54n5+LgTi
         Ka4RR5OJQjvYsInyjC1G8mUoF2Wd4ffFyxZW6o3SWSpkON3qb+8Fwvx/2WaNNDrwEktm
         DzP3PxrJZYqCrZYCPvL8CgyPU5NxmHmLJOTqIeztLqzuR0DoyHKOJ1zD/Q9HslNTTFOZ
         9b/GWiAsDN42aGxSuSJ0eKuzUPAlkscCv41gMlAaEkrz7Fqe1Vt4c1g1nKwbRbIiKfdY
         2prxmJdJKQ0x0Fx30N6ZtE1pmpNx40wbh4wCWsy2ULWo2PGSxSZk/H39si/Azre+tE2C
         19Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/3/LjBBUJR12eFtgYhlmtK97IfljMWykbg20pJkYoc=;
        b=bLqYHKmn+MNUdHin0NyTntMr6unb8OBIhURmK6kYpKGC/nEEs+nPmFCk1Llf34YGXi
         OSFl9mGxHX9VHOsaRWvUwAMZKuJZOUamNYiPaNyUCv+MiHSNZ9y8ZyLu3/d6he0Z6mMd
         +D5+RHXrc5hTagGvAqTMxSWwVWZQ65sGttsjIdYsbkIMG5cxKqse/t8ofxRUUMovwJx0
         OhCK/26HxlOuX0oCxaQjxdUesrP5usZS2tHYNCEr9pIgW7+lf/RoVM2/CxlHzN+3Vjf8
         HetK7KIQMYowKgVcQT56LAhk9CAxR3EJYSK88dmhZgwbRqH0L7wsthX+EhGyoZ5WVjqw
         3Pjg==
X-Gm-Message-State: AOAM533LX6/TbsUcLLIdP5wNxEQPjRoGfBE95JIT+gp0jS6oDDwzns7H
        U1gV+I0ac9CpoWg4lkbPPuK15vfWk+6r4tXziSq+wA==
X-Google-Smtp-Source: ABdhPJy2ZcgGdEWYXnnMEstP5EWJ1s5AgNUKy8LCM/YvKc7S/vsgg2FVd4VcWXKFKrePWj4ZtItqjD3aOnZ4VSzWNhY=
X-Received: by 2002:a92:7914:: with SMTP id u20mr15955042ilc.203.1605044866958;
 Tue, 10 Nov 2020 13:47:46 -0800 (PST)
MIME-Version: 1.0
References: <20201110204802.417521-1-drjones@redhat.com> <20201110204802.417521-3-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-3-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 10 Nov 2020 13:47:36 -0800
Message-ID: <CANgfPd-msm5J=NUKPS=CNbZy1MMrm5GOhAL20u=X+eXqfrgF6Q@mail.gmail.com>
Subject: Re: [PATCH 2/8] KVM: selftests: Remove deadcode
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
> Nothing sets USE_CLEAR_DIRTY_LOG anymore, so anything it surrounds
> is dead code.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 44 -------------------
>  1 file changed, 44 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 85c9b8f73142..b9115e8ef0ed 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -88,10 +88,6 @@ static void *vcpu_worker(void *data)
>         return NULL;
>  }
>
> -#ifdef USE_CLEAR_DIRTY_LOG
> -static u64 dirty_log_manual_caps;
> -#endif
> -
>  static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>                      uint64_t phys_offset, int wr_fract)
>  {
> @@ -106,10 +102,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         struct timespec get_dirty_log_total = (struct timespec){0};
>         struct timespec vcpu_dirty_total = (struct timespec){0};
>         struct timespec avg;
> -#ifdef USE_CLEAR_DIRTY_LOG
> -       struct kvm_enable_cap cap = {};
> -       struct timespec clear_dirty_log_total = (struct timespec){0};
> -#endif
>
>         vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
>
> @@ -120,12 +112,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>         bmap = bitmap_alloc(host_num_pages);
>
> -#ifdef USE_CLEAR_DIRTY_LOG
> -       cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
> -       cap.args[0] = dirty_log_manual_caps;
> -       vm_enable_cap(vm, &cap);
> -#endif
> -
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> @@ -189,18 +175,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>                                                    ts_diff);
>                 pr_info("Iteration %lu get dirty log time: %ld.%.9lds\n",
>                         iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
> -
> -#ifdef USE_CLEAR_DIRTY_LOG
> -               clock_gettime(CLOCK_MONOTONIC, &start);
> -               kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
> -                                      host_num_pages);
> -
> -               ts_diff = timespec_diff_now(start);
> -               clear_dirty_log_total = timespec_add(clear_dirty_log_total,
> -                                                    ts_diff);
> -               pr_info("Iteration %lu clear dirty log time: %ld.%.9lds\n",
> -                       iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
> -#endif
>         }
>
>         /* Tell the vcpu thread to quit */
> @@ -220,13 +194,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>                 iterations, get_dirty_log_total.tv_sec,
>                 get_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
>
> -#ifdef USE_CLEAR_DIRTY_LOG
> -       avg = timespec_div(clear_dirty_log_total, iterations);
> -       pr_info("Clear dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
> -               iterations, clear_dirty_log_total.tv_sec,
> -               clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
> -#endif
> -
>         free(bmap);
>         free(vcpu_threads);
>         ucall_uninit(vm);
> @@ -284,17 +251,6 @@ int main(int argc, char *argv[])
>         int opt, i;
>         int wr_fract = 1;
>
> -#ifdef USE_CLEAR_DIRTY_LOG
> -       dirty_log_manual_caps =
> -               kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> -       if (!dirty_log_manual_caps) {
> -               print_skip("KVM_CLEAR_DIRTY_LOG not available");
> -               exit(KSFT_SKIP);
> -       }
> -       dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> -                                 KVM_DIRTY_LOG_INITIALLY_SET);
> -#endif
> -
>  #ifdef __x86_64__
>         guest_mode_init(VM_MODE_PXXV48_4K, true, true);
>  #endif
> --
> 2.26.2
>

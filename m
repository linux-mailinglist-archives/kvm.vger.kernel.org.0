Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0125F363547
	for <lists+kvm@lfdr.de>; Sun, 18 Apr 2021 14:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhDRMoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Apr 2021 08:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhDRMoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Apr 2021 08:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618749836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E6uNbMbVCgDMvWJ8+GT/41tyTN862snKqfW8+VoOfFA=;
        b=Fr1GpBvBTg7K54GZirlNLJNOTlOAQN6pGXJaZ65eo7rQ3nkYdk+MmXNu0G1P/bVvfQe8jM
        xzGrDyT5w0VGi9XzSH4my7Lfp0rMFtNOifXa3lorIKdlNs/JdYCMip3cV6xBlDxFJuiNbb
        VvPLa2/frKJhJoD4iMj4oK0FvxbdXwM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-DwY6dEQVPhO2F_-pYX0OpA-1; Sun, 18 Apr 2021 08:43:54 -0400
X-MC-Unique: DwY6dEQVPhO2F_-pYX0OpA-1
Received: by mail-qk1-f198.google.com with SMTP id g184-20020a3784c10000b02902e385de9adaso2290163qkd.3
        for <kvm@vger.kernel.org>; Sun, 18 Apr 2021 05:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E6uNbMbVCgDMvWJ8+GT/41tyTN862snKqfW8+VoOfFA=;
        b=iSueD+qknbyCflPLW/vHZMJiW1qlsyKjUBU+GcWgB1j15Nlno3ascWAXJHePddYIu9
         OKB6mvgmahDBpBpQsT/6ZMwB7++hu3gNDuR5qzruu88WtT2niwHeIyu7KNGiXsrD6ISA
         EIL4NxdPhoT5P7NpKlC5QQZTmTb2+rNH95vEZ6iu1MnG+Xoic9GN4zfV9hvs1fYPRk17
         z+3Iz3IzsOUlJe4qmkDt1Xg+7Szgs7v1LWfOQU2QCsm4PwCO3rZW5QrRIiXMr8+E0BmB
         /qXbTmXOI7oky17zRpCoRD0NiP0P1iXMh2fEj1dsmaEA+nnmk6XamV+FxdmYbYQO1SEg
         sgKA==
X-Gm-Message-State: AOAM532cHNuronFiWMWL4ye3sKePOvvktiORkyLng+XnhLdHQop8Vrmm
        KdMbKDzXR9D2YqbHAMGsmT/ced5dxXFa3jEIuZ3aHHqYIyz84uRXBXUtCK/ymFU2Q2SKMc9rOeF
        d/RINgqz+SKBq
X-Received: by 2002:a37:a1ce:: with SMTP id k197mr7760833qke.80.1618749833943;
        Sun, 18 Apr 2021 05:43:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycxRUqy0u6tmZyIEaLaDEryyqlMoMUFUDmS06oOOjhPiQ6Xs+EJMgk+er6zEIRqDDEyjOe6w==
X-Received: by 2002:a37:a1ce:: with SMTP id k197mr7760819qke.80.1618749833660;
        Sun, 18 Apr 2021 05:43:53 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id h23sm7212085qtr.21.2021.04.18.05.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:43:53 -0700 (PDT)
Date:   Sun, 18 Apr 2021 08:43:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 1/2] KVM: selftests: Sync data verify of dirty logging
 with guest sync
Message-ID: <20210418124351.GW4440@xz-x1>
References: <20210417143602.215059-1-peterx@redhat.com>
 <20210417143602.215059-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210417143602.215059-2-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 17, 2021 at 10:36:01AM -0400, Peter Xu wrote:
> This fixes a bug that can trigger with e.g. "taskset -c 0 ./dirty_log_test" or
> when the testing host is very busy.
> 
> A similar previous attempt is done [1] but that is not enough, the reason is
> stated in the reply [2].
> 
> As a summary (partly quotting from [2]):
> 
> The problem is I think one guest memory write operation (of this specific test)
> contains a few micro-steps when page is during kvm dirty tracking (here I'm
> only considering write-protect rather than pml but pml should be similar at
> least when the log buffer is full):
> 
>   (1) Guest read 'iteration' number into register, prepare to write, page fault
>   (2) Set dirty bit in either dirty bitmap or dirty ring
>   (3) Return to guest, data written
> 
> When we verify the data, we assumed that all these steps are "atomic", say,
> when (1) happened for this page, we assume (2) & (3) must have happened.  We
> had some trick to workaround "un-atomicity" of above three steps, as previous
> version of this patch wanted to fix atomicity of step (2)+(3) by explicitly
> letting the main thread wait for at least one vmenter of vcpu thread, which
> should work.  However what I overlooked is probably that we still have race
> when (1) and (2) can be interrupted.
> 
> One example calltrace when it could happen that we read an old interation, got
> interrupted before even setting the dirty bit and flushing data:
> 
>     __schedule+1742
>     __cond_resched+52
>     __get_user_pages+530
>     get_user_pages_unlocked+197
>     hva_to_pfn+206
>     try_async_pf+132
>     direct_page_fault+320
>     kvm_mmu_page_fault+103
>     vmx_handle_exit+288
>     vcpu_enter_guest+2460
>     kvm_arch_vcpu_ioctl_run+325
>     kvm_vcpu_ioctl+526
>     __x64_sys_ioctl+131
>     do_syscall_64+51
>     entry_SYSCALL_64_after_hwframe+68
> 
> It means iteration number cached in vcpu register can be very old when dirty
> bit set and data flushed.
> 
> So far I don't see an easy way to guarantee all steps 1-3 atomicity but to sync
> at the GUEST_SYNC() point of guest code when we do verification of the dirty
> bits as what this patch does.
> 
> [1] https://lore.kernel.org/lkml/20210413213641.23742-1-peterx@redhat.com/
> [2] https://lore.kernel.org/lkml/20210417140956.GV4440@xz-x1/
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 60 ++++++++++++++++----
>  1 file changed, 50 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index bb2752d78fe3..510884f0eab8 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -17,6 +17,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <asm/barrier.h>
> +#include <linux/atomic.h>
>  
>  #include "kvm_util.h"
>  #include "test_util.h"
> @@ -137,12 +138,20 @@ static uint64_t host_clear_count;
>  static uint64_t host_track_next_count;
>  
>  /* Whether dirty ring reset is requested, or finished */
> -static sem_t dirty_ring_vcpu_stop;
> -static sem_t dirty_ring_vcpu_cont;
> +static sem_t sem_vcpu_stop;
> +static sem_t sem_vcpu_cont;
> +/*
> + * This is only set by main thread, and only cleared by vcpu thread.  It is
> + * used to request vcpu thread to stop at the next GUEST_SYNC, since GUEST_SYNC
> + * is the only place that we'll guarantee both "dirty bit" and "dirty data"
> + * will match.  E.g., SIG_IPI won't guarantee that (e.g., when vcpu interrupted
> + * after setting dirty bit but before data flushed).
> + */
> +static atomic_t vcpu_sync_stop_requested;
>  /*
>   * This is updated by the vcpu thread to tell the host whether it's a
>   * ring-full event.  It should only be read until a sem_wait() of
> - * dirty_ring_vcpu_stop and before vcpu continues to run.
> + * sem_vcpu_stop and before vcpu continues to run.
>   */
>  static bool dirty_ring_vcpu_ring_full;
>  /*
> @@ -234,6 +243,17 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
>  	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
>  }
>  
> +/* Should only be called after a GUEST_SYNC */
> +static void vcpu_handle_sync_stop(void)
> +{
> +	if (atomic_read(&vcpu_sync_stop_requested)) {
> +		/* It means main thread is sleeping waiting */
> +		atomic_set(&vcpu_sync_stop_requested, false);
> +		sem_post(&sem_vcpu_stop);
> +		sem_wait_until(&sem_vcpu_cont);
> +	}
> +}
> +
>  static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>  {
>  	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> @@ -244,6 +264,8 @@ static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>  	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
>  		    "Invalid guest sync status: exit_reason=%s\n",
>  		    exit_reason_str(run->exit_reason));
> +
> +	vcpu_handle_sync_stop();
>  }
>  
>  static bool dirty_ring_supported(void)
> @@ -301,13 +323,13 @@ static void dirty_ring_wait_vcpu(void)
>  {
>  	/* This makes sure that hardware PML cache flushed */
>  	vcpu_kick();
> -	sem_wait_until(&dirty_ring_vcpu_stop);
> +	sem_wait_until(&sem_vcpu_stop);
>  }
>  
>  static void dirty_ring_continue_vcpu(void)
>  {
>  	pr_info("Notifying vcpu to continue\n");
> -	sem_post(&dirty_ring_vcpu_cont);
> +	sem_post(&sem_vcpu_cont);
>  }
>  
>  static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
> @@ -361,11 +383,11 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>  		/* Update the flag first before pause */
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full,
>  			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
> -		sem_post(&dirty_ring_vcpu_stop);
> +		sem_post(&sem_vcpu_stop);
>  		pr_info("vcpu stops because %s...\n",
>  			dirty_ring_vcpu_ring_full ?
>  			"dirty ring is full" : "vcpu is kicked out");
> -		sem_wait_until(&dirty_ring_vcpu_cont);
> +		sem_wait_until(&sem_vcpu_cont);
>  		pr_info("vcpu continues now.\n");
>  	} else {
>  		TEST_ASSERT(false, "Invalid guest sync status: "
> @@ -377,7 +399,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>  static void dirty_ring_before_vcpu_join(void)
>  {
>  	/* Kick another round of vcpu just to make sure it will quit */
> -	sem_post(&dirty_ring_vcpu_cont);
> +	sem_post(&sem_vcpu_cont);
>  }
>  
>  struct log_mode {
> @@ -768,7 +790,25 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		usleep(p->interval * 1000);
>  		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
>  					     bmap, host_num_pages);
> +
> +		/*
> +		 * See vcpu_sync_stop_requested definition for details on why
> +		 * we need to stop vcpu when verify data.
> +		 */
> +		atomic_set(&vcpu_sync_stop_requested, true);
> +		sem_wait_until(&sem_vcpu_stop);
> +		/*
> +		 * NOTE: for dirty ring, it's possible that we didn't stop at
> +		 * GUEST_SYNC but instead we stopped because ring is full;
> +		 * that's okay too because ring full means we're only missing
> +		 * the flush of the last page, and since we handle dirty ring
> +		 * last page specifically, so verify will still pass.
> +		 */
> +		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
> +		       atomic_read(&vcpu_sync_stop_requested) == false);
>  		vm_dirty_log_verify(mode, bmap);
> +		sem_post(&sem_vcpu_cont);
> +
>  		iteration++;
>  		sync_global_to_guest(vm, iteration);
>  	}
> @@ -819,8 +859,8 @@ int main(int argc, char *argv[])
>  	};
>  	int opt, i;
>  
> -	sem_init(&dirty_ring_vcpu_stop, 0, 0);
> -	sem_init(&dirty_ring_vcpu_cont, 0, 0);
> +	sem_init(&sem_vcpu_stop, 0, 0);
> +	sem_init(&sem_vcpu_cont, 0, 0);
>  
>  	guest_modes_append_default();
>  
> -- 
> 2.26.2
> 

We'd also squash below into this patch (which I forgot):

----8<-----
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 25230e799bc4..d3050d1c2cd0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -377,7 +377,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
        /* A ucall-sync or ring-full event is allowed */
        if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
                /* We should allow this to continue */
-               ;
+               vcpu_handle_sync_stop();
        } else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
                   (ret == -1 && err == EINTR)) {
                /* Update the flag first before pause */
----8<-----

That's my intention when I introduce vcpu_handle_sync_stop(), but forgot to
add...

This should not affect correctness of this patch as dirty ring test can always
trigger ring full event which achieve similar goals, but it'll allow dirty ring
test to quit even earlier before ring is full.

-- 
Peter Xu


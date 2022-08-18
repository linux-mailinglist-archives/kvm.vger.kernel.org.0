Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923E5599129
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345357AbiHRX3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 19:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiHRX3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 19:29:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A28D3E66
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:29:16 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a22so2890668pfg.3
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BEL6EhdJLbNrjlPlbZ4iYst8WAXvRI2evKtyrqt/Thg=;
        b=n8k0a5Y9w5Kzv+Z7fj9jouK9CdYtAO4YO/zm5fyaydiNtQjSq0GB3hQxAxY/RRj9qp
         MN08pE/6hgZYHXxIPYFl+VCgKkisH+bTuDvTMjzLorOdwaCYJV1JZnC5N1GUL2QURSZR
         CcUc1I3LR0G2fr1rIYrc2NPD4K5QYIIGlxG9JhBJVpyn8WN7hk4XgBeBsvbARtei5d1F
         OGGa4ZtKYylKZkTYQo5ArgEo8ZoQjFzsc8C2AStadt1ztiPVRlHEaC3XxiPJYZgv2x0A
         Zi6R8+JFqB40y6Z3x8Isi3f+LEolMDQjEA2VVr7kW3NmG5hlYvGmGuf8/Y/2mwK8ywc5
         MLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BEL6EhdJLbNrjlPlbZ4iYst8WAXvRI2evKtyrqt/Thg=;
        b=NSCQzS4JqfgndHmc5hXsoVJ/boBaTZl3DI+WFvgRtS0gkY3uUW68NQ6QDirmSNJ2UE
         0Ixo6++4yWEf5014QxGPtS/tsNfnhWTgx8hCZJGWZoMXGDOhumLv1Xi1b/9L9T/Jel5f
         oWs+o2P5DJIlpxMiFFTmSi2QA3ng5MSPT20D9hWkH+aksQ3ptwD7dEC1q18M5aNOzQfS
         bIT4cJmAFw1F/v5oBy2vFRPjQq61ihtDro3GRy/q/lcRNBDDHZsZFmwo1FcXFZsRJNj7
         DQ5I3bi3DCwEMb7jAaevCwGZ8Xg01zz6344PqaEAZjijzSmDmmVRXlbBFN/hNDAc686K
         zJpQ==
X-Gm-Message-State: ACgBeo2eTy9N4ue0W3kxaKPYLD71GDkLdv8JLEHsIti1F0X+r+IMj1Jm
        ARi84vRF6zN/J6EVAMvYaG+gbEjOSKO2uQ==
X-Google-Smtp-Source: AA6agR6NbVAOlb8RzgXGd9mRIiGRGd0ptF37aV/i2Y/KadVeBuYsT6txvTotxjcngJTkYOrxKFCv9w==
X-Received: by 2002:a05:6a00:2309:b0:52e:f35a:be04 with SMTP id h9-20020a056a00230900b0052ef35abe04mr5038328pfh.11.1660865355696;
        Thu, 18 Aug 2022 16:29:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jd22-20020a170903261600b0016d7b2352desm1883439plb.244.2022.08.18.16.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 16:29:15 -0700 (PDT)
Date:   Thu, 18 Aug 2022 23:29:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcorr@google.com,
        michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org,
        mizhang@google.com, pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <Yv7LR8NMBMKVzS3Z@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
 <20220816161350.b7x5brnyz5pyi7te@kamzik>
 <Yv5iKJbjW5VseagS@google.com>
 <20220818190514.ny77xpfwiruah6m5@kamzik>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iuUX1rO0XqAgLi0Z"
Content-Disposition: inline
In-Reply-To: <20220818190514.ny77xpfwiruah6m5@kamzik>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--iuUX1rO0XqAgLi0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 18, 2022, Andrew Jones wrote:
> On Thu, Aug 18, 2022 at 04:00:40PM +0000, Sean Christopherson wrote:
> > But why is "use_ucall_pool" optional?  Unless there's a use case that fundamentally
> > conflicts with the pool approach, let's make the pool approach the _only_ approach.
> > IIRC, ARM's implementation isn't thread safe, i.e. there's at least one other use
> > case that _needs_ the pool implementation.
> 
> Really? The ucall structure is on the vcpu's stack like the other
> architectures. Ah, you're probably thinking about the shared address used
> to exit to userspace. The address doesn't matter as long as no VM maps
> it, but, yes, a multi-VM test where the VMs have different maps could end
> up breaking ucalls for one or more VMs.

Yah, that's what I was thinking of.

> It wouldn't be hard to make that address per-VM, though, if ever necessary.
> 
> > 
> > By supporting both, we are signing ourselves up for extra maintenance and pain,
> > e.g. inevitably we'll break whichever option isn't the default and not notice for
> > quite some time.
> 
> uc pools are currently limited to a single VM. That could be changed, but
> at the expense of even more code to maintain.

Unless I'm missing something, it's actually less code.  "globals" that are sync'd
to the guest aren't truly global, each VM has a separate physical page that is a
copy of the global, hence the need for sync_global_to_guest().

And FWIW, the code is actually "safe" in practice because I doubt any test spawns
multiple VMs in parallel, i.e. the host might get confused over the value of
ucall_pool, but guests won't stomp on each other so long as they're created
serially.  Ditto for ARM's ucall_exit_mmio_addr.

To make this truly thread safe, we just need a way to atomically sync the pointer
to the guest, and that's easy enough to add.

With that out of the way, all of the conditional "use pool" code goes away, which
IMO simplifies things overall.  Using a pool versus stack memory isn't _that_ much
more complicated, and we _know_ the stack approach doesn't work for all VM types.

Indeed, this partial conversion is:

  7 files changed, 131 insertions(+), 18 deletions(-)

versus a full conversion:

  6 files changed, 89 insertions(+), 20 deletions(-)

And simplification is only a secondary concern, what I'm really worried about is
things bitrotting and then some poor sod having to wade through unrelated issues
because somebody else broke the pool implementation and didn't notice.

Argh, case in point, none of the x86 (or s390 or RISC-V) tests do ucall_init(),
which would have been a lurking bug if any of them tried to switch to the pool.

Argh + case in point #2, this code is broken, and that bug may have sat unnoticed
due to only the esoteric SEV test using the pool.

-static inline size_t uc_pool_idx(struct ucall *uc)
+static noinline void ucall_free(struct ucall *uc)
 {
-       return uc->hva - ucall_pool->ucalls;
-}
-
-static void ucall_free(struct ucall *uc)
-{
-       clear_bit(uc_pool_idx(uc), ucall_pool->in_use);
+       /* Beware, here be pointer arithmetic.  */
+       clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }


So my very strong vote is to fully switch to a single implementation.  That way
our code either works or it doesn't, i.e. we notice very quickly if it breaks.

Peter, if I can convince Drew of One Pool To Rule Them All, can you slot in the
attached patches and slightly rework the ordering so that all SEV patches are at
the end?  E.g. something like:

  KVM: selftests: Automatically do init_ucall() for non-barebones VMs
  KVM: selftests: move vm_phy_pages_alloc() earlier in file
  KVM: selftests: sparsebit: add const where appropriate
  KVM: selftests: add hooks for managing encrypted guest memory
  KVM: selftests: handle encryption bits in page tables
  KVM: selftests: add support for encrypted vm_vaddr_* allocations
  KVM: selftests: Consolidate common code for popuplating
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  tools: Add atomic_test_and_set_bit()
  KVM: selftests: Add macro to atomically sync per-VM "global" pointers
  KVM: selftests: Add ucall pool based implementation
  KVM: selftests: add library for creating/interacting with SEV guests
  KVM: selftests: Add simple sev vm testing

The patches are tested on x86 and compile tested on arm.  I can provide more testing
if/when necessary.  I also haven't addressed any other feedback in the "ucall pool"
patch, though I'm guessing much of it no longer applies.

--iuUX1rO0XqAgLi0Z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-selftests-Automatically-do-init_ucall-for-non-ba.patch"

From 9264f40a8cff865e5845d89e8e44e0c3a6fa482a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Aug 2022 15:15:57 -0700
Subject: [PATCH 01/13] KVM: selftests: Automatically do init_ucall() for
 non-barebones VMs

Do init_ucall() automatically during VM creation in preparation for
making ucall initialization meaningful on all architectures.  aarch64 is
currently the only arch that needs to do any setup, but that will change
in the future by switching to a pool-based implementation (instead of the
current stack-based approach).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c         | 1 -
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c   | 1 -
 tools/testing/selftests/kvm/aarch64/hypercalls.c         | 1 -
 tools/testing/selftests/kvm/aarch64/psci_test.c          | 1 -
 tools/testing/selftests/kvm/aarch64/vgic_init.c          | 2 --
 tools/testing/selftests/kvm/aarch64/vgic_irq.c           | 1 -
 tools/testing/selftests/kvm/dirty_log_test.c             | 2 --
 tools/testing/selftests/kvm/kvm_page_table_test.c        | 1 -
 tools/testing/selftests/kvm/lib/kvm_util.c               | 3 +++
 tools/testing/selftests/kvm/lib/perf_test_util.c         | 2 --
 tools/testing/selftests/kvm/memslot_perf_test.c          | 1 -
 tools/testing/selftests/kvm/rseq_test.c                  | 1 -
 tools/testing/selftests/kvm/steal_time.c                 | 1 -
 tools/testing/selftests/kvm/system_counter_offset_test.c | 1 -
 14 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 574eb73f0e90..37c0ddebf4db 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -375,7 +375,6 @@ static struct kvm_vm *test_vm_create(void)
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
-	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
 	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..eaf225fd2a4a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -254,7 +254,6 @@ int main(int argc, char *argv[])
 	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..3dceecfd1f62 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -236,7 +236,6 @@ static struct kvm_vm *test_vm_create(struct kvm_vcpu **vcpu)
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
-	ucall_init(vm, NULL);
 	steal_time_init(*vcpu);
 
 	return vm;
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index f7621f6e938e..56278f3df891 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -77,7 +77,6 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
 	struct kvm_vm *vm;
 
 	vm = vm_create(2);
-	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index e05ecb31823f..cc828fb53d8f 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -68,8 +68,6 @@ static void guest_code(void)
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
-	ucall_init(vcpu->vm, NULL);
-
 	return __vcpu_run(vcpu) ? -errno : 0;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 17417220a083..d1817f852daf 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -756,7 +756,6 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	print_args(&args);
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..583b46250d07 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -754,8 +754,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
-	ucall_init(vm, NULL);
-
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
 	sync_global_to_guest(vm, guest_page_size);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index f42c6ac6d71d..20533c48ba3d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -289,7 +289,6 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
 	/* Export shared structure test_args to guest */
-	ucall_init(vm, NULL);
 	sync_global_to_guest(vm, test_args);
 
 	ret = sem_init(&test_stage_updated, 0, 0);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..ea679987f038 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -301,6 +301,9 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
+
+	ucall_init(vm, NULL);
+
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..5161fa68cdf3 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -209,8 +209,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		perf_test_setup_nested(vm, nr_vcpus, vcpus);
 	}
 
-	ucall_init(vm, NULL);
-
 	/* Export the shared variables to the guest. */
 	sync_global_to_guest(vm, perf_test_args);
 
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..4ed5acd74278 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -277,7 +277,6 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
 	data->vm = __vm_create_with_one_vcpu(&data->vcpu, mempages, guest_code);
-	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index fac248a43666..8dc745effb5e 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -224,7 +224,6 @@ int main(int argc, char *argv[])
 	 * CPU affinity.
 	 */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
 		       (void *)(unsigned long)gettid());
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index db8967f1a17b..c87f38712073 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -266,7 +266,6 @@ int main(int ac, char **av)
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
-	ucall_init(vm, NULL);
 
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 1c274933912b..7f5b330b6a1b 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -121,7 +121,6 @@ int main(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 	check_preconditions(vcpu);
-	ucall_init(vm, NULL);
 
 	enter_guest(vcpu);
 	kvm_vm_free(vm);
-- 
2.37.1.595.g718a3a8f04-goog


--iuUX1rO0XqAgLi0Z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0010-KVM-selftests-Add-macro-to-atomically-sync-per-VM-gl.patch"

From bbc527a48fe0481495d6a0a562815e3d33fb655b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Aug 2022 15:22:55 -0700
Subject: [PATCH 10/13] KVM: selftests: Add macro to atomically sync per-VM
 "global" pointers

Add atomic_sync_global_pointer_to_guest() to allow sync'ing "global"
pointers that hold per-VM values, i.e. technically need to be handled in
a thread-safe manner.

Use the new macro to fix a mostly-theoretical bug where ARM's ucall MMIO
setup could result in different VMs stomping on each other.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util_base.h | 15 +++++++++++++++
 tools/testing/selftests/kvm/lib/aarch64/ucall.c   | 15 +++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 8ce9e5be70a3..f4a2622db53c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -16,6 +16,7 @@
 #include <linux/kvm.h>
 #include "linux/rbtree.h"
 
+#include <asm/atomic.h>
 
 #include <sys/ioctl.h>
 
@@ -727,6 +728,20 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
+/*
+ * Sync a global pointer to the guest that has a per-VM value, in which case
+ * writes to the host copy of the "global" must be serialized (in case a test
+ * is being truly crazy and spawning multiple VMs concurrently).
+ */
+#define atomic_sync_global_pointer_to_guest(vm, g, val) ({	\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+								\
+	while (cmpxchg(&g, NULL, val))				\
+		;						\
+	memcpy(_p, &(g), sizeof(g));				\
+	WRITE_ONCE(g, NULL);					\
+})
+
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 132c0e98bf49..c30a6eacde34 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -6,8 +6,17 @@
  */
 #include "kvm_util.h"
 
+/*
+ * This "global" holds different per-VM values, it must not be accessed from
+ * host code except to sync the guest value, and that must be done atomically.
+ */
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
+static void ucall_set_mmio_addr(struct kvm_vm *vm, vm_vaddr_t *val)
+{
+	atomic_sync_global_pointer_to_guest(vm, ucall_exit_mmio_addr, val);
+}
+
 static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
@@ -15,8 +24,7 @@ static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
 
 	virt_pg_map(vm, gpa, gpa);
 
-	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+	ucall_set_mmio_addr(vm, (vm_vaddr_t *)gpa);
 
 	return true;
 }
@@ -66,8 +74,7 @@ void ucall_arch_init(struct kvm_vm *vm, void *arg)
 
 void ucall_arch_uninit(struct kvm_vm *vm)
 {
-	ucall_exit_mmio_addr = 0;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+	ucall_set_mmio_addr(vm, (vm_vaddr_t *)NULL);
 }
 
 void ucall_arch_do_ucall(vm_vaddr_t uc)
-- 
2.37.1.595.g718a3a8f04-goog


--iuUX1rO0XqAgLi0Z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0011-KVM-selftests-Add-ucall-pool-based-implementation.patch"

From ba28b353f632bcf8a3b6a8bc4e678c18a3dae7e9 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Aug 2022 08:20:32 -0700
Subject: [PATCH 11/13] KVM: selftests: Add ucall pool based implementation

From: Peter Gonda <pgonda@google.com>

To play nice with guests whose stack memory is encrypted, e.g. AMD SEV,
introduce a new "ucall pool" implementation that passes the ucall struct
via dedicated memory (which can be mapped shared, a.k.a. as plain text).

Because not all architectures have access to the vCPU index in the guest,
use a bitmap with atomic accesses to track which entries in the pool are
free/used.  A list+lock could also work in theory, but synchronizing the
individual pointers to the guest would be a mess.

Note, there's no need to rewalk the bitmap to ensure success.  If all
vCPUs are simply allocating, success is guaranteed because there are
enough entries for all vCPUs.  If one or more vCPUs are freeing and then
reallocating, success is guaranteed because vCPUs _always_ walk the
bitmap from 0=>N; if vCPU frees an entry and then wins a race to
re-allocate, then either it will consume the entry it just freed (bit is
the first free bit), or the losing vCPU is guaranteed to see the freed
bit (winner consumes an earlier bit, which the loser hasn't yet visited).

Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 13 ++-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  7 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  2 +-
 .../testing/selftests/kvm/lib/ucall_common.c  | 83 ++++++++++++++++++-
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |  2 +-
 6 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 63bfc60be995..002a22e1cd1d 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -22,6 +22,9 @@ enum {
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+
+	/* For ucall pool usage. */
+	struct ucall *hva;
 };
 
 void ucall_arch_init(struct kvm_vm *vm, void *arg);
@@ -32,15 +35,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 
-static inline void ucall_init(struct kvm_vm *vm, void *arg)
-{
-	ucall_arch_init(vm, arg);
-}
+void ucall_init(struct kvm_vm *vm, void *arg);
 
-static inline void ucall_uninit(struct kvm_vm *vm)
-{
-	ucall_arch_uninit(vm);
-}
+void ucall_uninit(struct kvm_vm *vm);
 
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index c30a6eacde34..dadcebf1c904 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -88,12 +88,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
 	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
-		vm_vaddr_t gva;
-
-		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
 			    "Unexpected ucall exit mmio address access");
-		memcpy(&gva, run->mmio.data, sizeof(gva));
-		return addr_gva2hva(vcpu->vm, gva);
+		return (void *)(*((uint64_t *)run->mmio.data));
 	}
 
 	return NULL;
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 37e091d4366e..bef4df251e7e 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -59,7 +59,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
 		switch (run->riscv_sbi.function_id) {
 		case KVM_RISCV_SELFTESTS_SBI_UCALL:
-			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
+			return (void *)run->riscv_sbi.args[0];
 		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
 			vcpu_dump(stderr, vcpu, 2);
 			TEST_ASSERT(0, "Unexpected trap taken by guest");
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 0f695a031d35..da73cd466296 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -30,7 +30,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	    (run->s390_sieic.ipb >> 16) == 0x501) {
 		int reg = run->s390_sieic.ipa & 0xf;
 
-		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
+		return (void *)run->s.regs.gprs[reg];
 	}
 	return NULL;
 }
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index ced480860746..134ff3022724 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,22 +1,97 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kvm_util.h"
+#include "linux/types.h"
+#include "linux/bitmap.h"
+#include "linux/atomic.h"
+
+struct ucall_header {
+	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
+	struct ucall ucalls[KVM_MAX_VCPUS];
+};
+
+/*
+ * This "global" holds different per-VM values, it must not be accessed from
+ * host code except to sync the guest value, and that must be done atomically.
+ */
+static struct ucall_header *ucall_pool;
+
+static void ucall_set_pool(struct kvm_vm *vm, struct ucall_header *val)
+{
+	atomic_sync_global_pointer_to_guest(vm, ucall_pool, val);
+}
+
+void ucall_init(struct kvm_vm *vm, void *arg)
+{
+	struct ucall_header *hdr;
+	struct ucall *uc;
+	vm_vaddr_t vaddr;
+	int i;
+
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
+	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
+	memset(hdr, 0, sizeof(*hdr));
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		uc = &hdr->ucalls[i];
+		uc->hva = uc;
+	}
+
+	ucall_set_pool(vm, (void *)vaddr);
+
+	ucall_arch_init(vm, arg);
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+	ucall_set_pool(vm, NULL);
+
+	ucall_arch_uninit(vm);
+}
+
+static struct ucall *ucall_alloc(void)
+{
+	struct ucall *uc;
+	int i;
+
+	GUEST_ASSERT(ucall_pool && ucall_pool->in_use);
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
+			uc = &ucall_pool->ucalls[i];
+			memset(uc->args, 0, sizeof(uc->args));
+			return uc;
+		}
+	}
+	GUEST_ASSERT(0);
+	return NULL;
+}
+
+static noinline void ucall_free(struct ucall *uc)
+{
+	/* Beware, here be pointer arithmetic.  */
+	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
+}
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {};
+	struct ucall *uc;
 	va_list va;
 	int i;
 
-	WRITE_ONCE(uc.cmd, cmd);
+	uc = ucall_alloc();
+
+	WRITE_ONCE(uc->cmd, cmd);
 
 	nargs = min(nargs, UCALL_MAX_ARGS);
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
+		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)&uc);
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
 }
 
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index ead9946399ab..ea6b2e3a8e39 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -30,7 +30,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 		struct kvm_regs regs;
 
 		vcpu_regs_get(vcpu, &regs);
-		return addr_gva2hva(vcpu->vm, regs.rdi);
+		return (void *)regs.rdi;
 	}
 	return NULL;
 }
-- 
2.37.1.595.g718a3a8f04-goog


--iuUX1rO0XqAgLi0Z--

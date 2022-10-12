Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040FE5FC995
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJLQ5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJLQ5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:57:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3FEDED18
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a7-20020a25a187000000b006c23949ec98so1437949ybi.4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YbKwEtCZMIFDgzbf7NWDA8W3fZ0S4ljsw3xaYuW8TGo=;
        b=szN5MifN1pZXf5/ppZg6WWJ1SD1JrkijPHMieBeQDCeXWhvV0leg6dVCUP+TApI2J/
         9Ij7RaMDiz9ZN7R7/txXBvhAnbZyTxg22wg7EU052yVnnZpfjnjBRIregGhgFXDsGv2M
         4a7G6KtAl48nqaCtwmdf+XiNUJkL+YVNtrnl+rW9B+y3PGVbhQ8g5XAGpTKxcsKOCVuJ
         dQ1JaDwU8cukHqxJHR8CnpMZe5dsazFxECMk1zVIlhtwfCZY2DWxnR3iuDBEy199yMv7
         OEYIXsVaj3HifQKCNhncwoWWOxHG0u46XEnQU1x0I2PTxD6V00B/PRPWcWqOHPdo/Xxj
         vEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbKwEtCZMIFDgzbf7NWDA8W3fZ0S4ljsw3xaYuW8TGo=;
        b=EPmrbv4SuhCN287g9FmAjPHxlWrP59G+KZy2PVPi14vX+io8SrAbMNu41OihD1Wc/4
         l5oOT+alN+BKvDPrJMtygPDUUv7kZnjDCef4Bdj/on3dqlyWOb3LZMErKVCGI6FOF1HO
         /sO16jLRTKA/jMtsSV8rmluoLOYW0u8V8wtabjQ2Ldn/ax6Hm5FAE9YlRfXGzxlK1o5y
         Acbtwun3imkiL+SXpivikd/WvL/CqwAW57UhxIOhlT69Kq7Stb9y+WNkc7yOZGzzOOql
         H3ymMgdIkYhHq/c6lx56MdFOmlK2XAGDiB65ntZXRRyDniBqJxxJO6fk2Qfqnkr+XfVR
         ErWQ==
X-Gm-Message-State: ACrzQf32ODsSCG2bbJzjmjftO9nBEwMYY7OWJM32RDWjnfrsjn+shWdq
        Mew8wK/MIlR98ePWktoMLo29JyTnEcRd9A==
X-Google-Smtp-Source: AMsMyM799cLM8db9pHsayvk4ajAdgEJug6GtIzHL2TCsg351Rt6HuamT0D7V8IZXMmwkptL52vG3zFSu+VD0Pw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:8c4:0:b0:6be:8933:ceb0 with SMTP id
 187-20020a2508c4000000b006be8933ceb0mr29724417ybi.335.1665593860390; Wed, 12
 Oct 2022 09:57:40 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:57:28 -0700
In-Reply-To: <20221012165729.3505266-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221012165729.3505266-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012165729.3505266-3-dmatlack@google.com>
Subject: [PATCH v2 2/3] KVM: selftests: Rename pta (short for perf_test_args)
 to args
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the local variables "pta" (which is short for perf_test_args) for
args. "pta" is not an obvious acronym and using "args" mirrors
"vcpu_args".

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/memstress.c | 56 ++++++++++-----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d3aea9e4f6a1..10d1c5bc0dc3 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -44,8 +44,8 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
  */
 void perf_test_guest_code(uint32_t vcpu_idx)
 {
-	struct perf_test_args *pta = &perf_test_args;
-	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
+	struct perf_test_args *args = &perf_test_args;
+	struct perf_test_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
 	int i;
@@ -58,9 +58,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			uint64_t addr = gva + (i * args->guest_page_size);
 
-			if (i % pta->wr_fract == 0)
+			if (i % args->wr_fract == 0)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -75,12 +75,12 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
-	struct perf_test_args *pta = &perf_test_args;
+	struct perf_test_args *args = &perf_test_args;
 	struct perf_test_vcpu_args *vcpu_args;
 	int i;
 
 	for (i = 0; i < nr_vcpus; i++) {
-		vcpu_args = &pta->vcpu_args[i];
+		vcpu_args = &args->vcpu_args[i];
 
 		vcpu_args->vcpu = vcpus[i];
 		vcpu_args->vcpu_idx = i;
@@ -89,20 +89,20 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			vcpu_args->gva = guest_test_virt_mem +
 					 (i * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa + (i * vcpu_memory_bytes);
+					   args->guest_page_size;
+			vcpu_args->gpa = args->gpa + (i * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (nr_vcpus * vcpu_memory_bytes) /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa;
+					   args->guest_page_size;
+			vcpu_args->gpa = args->gpa;
 		}
 
 		vcpu_args_set(vcpus[i], 1, i);
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 i, vcpu_args->gpa, vcpu_args->gpa +
-			 (vcpu_args->pages * pta->guest_page_size));
+			 (vcpu_args->pages * args->guest_page_size));
 	}
 }
 
@@ -111,7 +111,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
-	struct perf_test_args *pta = &perf_test_args;
+	struct perf_test_args *args = &perf_test_args;
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages, slot0_pages = 0;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
@@ -121,20 +121,20 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	args->wr_fract = 1;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
 	 */
-	pta->guest_page_size = vm_guest_mode_params[mode].page_size;
+	args->guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
-				(nr_vcpus * vcpu_memory_bytes) / pta->guest_page_size);
+				(nr_vcpus * vcpu_memory_bytes) / args->guest_page_size);
 
 	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
-	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % args->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 	TEST_ASSERT(guest_num_pages % slots == 0,
 		    "Guest memory cannot be evenly divided into %d slots.",
@@ -144,7 +144,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * If using nested, allocate extra pages for the nested page tables and
 	 * in-memory data structures.
 	 */
-	if (pta->nested)
+	if (args->nested)
 		slot0_pages += perf_test_nested_pages(nr_vcpus);
 
 	/*
@@ -155,7 +155,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
 				    perf_test_guest_code, vcpus);
 
-	pta->vm = vm;
+	args->vm = vm;
 
 	/* Put the test region at the top guest physical memory. */
 	region_end_gfn = vm->max_gfn + 1;
@@ -165,8 +165,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * When running vCPUs in L2, restrict the test region to 48 bits to
 	 * avoid needing 5-level page tables to identity map L2.
 	 */
-	if (pta->nested)
-		region_end_gfn = min(region_end_gfn, (1UL << 48) / pta->guest_page_size);
+	if (args->nested)
+		region_end_gfn = min(region_end_gfn, (1UL << 48) / args->guest_page_size);
 #endif
 	/*
 	 * If there should be more memory in the guest test region than there
@@ -178,20 +178,20 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		    " nr_vcpus: %d wss: %" PRIx64 "]\n",
 		    guest_num_pages, region_end_gfn - 1, nr_vcpus, vcpu_memory_bytes);
 
-	pta->gpa = (region_end_gfn - guest_num_pages - 1) * pta->guest_page_size;
-	pta->gpa = align_down(pta->gpa, backing_src_pagesz);
+	args->gpa = (region_end_gfn - guest_num_pages - 1) * args->guest_page_size;
+	args->gpa = align_down(args->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	pta->gpa = align_down(pta->gpa, 1 << 20);
+	args->gpa = align_down(args->gpa, 1 << 20);
 #endif
-	pta->size = guest_num_pages * pta->guest_page_size;
+	args->size = guest_num_pages * args->guest_page_size;
 	pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
-		pta->gpa, pta->gpa + pta->size);
+		args->gpa, args->gpa + args->size);
 
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = pta->gpa + region_pages * pta->guest_page_size * i;
+		vm_paddr_t region_start = args->gpa + region_pages * args->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    PERF_TEST_MEM_SLOT_INDEX + i,
@@ -199,12 +199,12 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	}
 
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
+	virt_map(vm, guest_test_virt_mem, args->gpa, guest_num_pages);
 
 	perf_test_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
 			      partition_vcpu_memory_access);
 
-	if (pta->nested) {
+	if (args->nested) {
 		pr_info("Configuring vCPUs to run in L2 (nested).\n");
 		perf_test_setup_nested(vm, nr_vcpus, vcpus);
 	}
-- 
2.38.0.rc1.362.ged0d419d3c-goog


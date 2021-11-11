Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B7B44CE12
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhKKAGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbhKKAGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:13 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288BC0613F5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:25 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020aa7980c000000b0049fa3fc29d0so2851486pfl.10
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ixtDEsrmQegbuMXL4qtAfwrCVIUP/EwC7eFMjrlz0FY=;
        b=UZ1xzYCTus0otnrDbFNuj8+u/tnLwjb73kSF6QupVWMkyPP3r+kliFKOOyL9/nRL0Z
         tHgANyASUuSU9ABAkceHo0gn/2rDnJewZFC0e1moGbtL2VRuQ0mXb0vHh/2OfLwvQUsV
         yjO8s0K3RoX9HSo8LM0naTxqp+i1B4hnOm1AjZ7oIe9UDyRG1uQvVRL7j3ZPAP62zjfF
         6MjQn8YqZxpcZEZC+u74Nw5eyBpIPCV2c5c6Rn0iJQCLyXe31LlyWqeXX/ywO2xvL7MX
         zc0yoXXnMMGZ4pDqg+mJJouwKPh6+wjVzhV9lERn51yHCLWmVUqzwGoOgI07GBwYuter
         pnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ixtDEsrmQegbuMXL4qtAfwrCVIUP/EwC7eFMjrlz0FY=;
        b=TgPdy1ZjTwLFMShw31TZOcDlT8LO/dw4FFblk/zVfATnTa1U9tBHAq46jz+pHrIeAI
         +kpMAp/oPNJILLlTiX9EMlFPjr401mjCvcDMaQGrzwUjh9V/mvtSsKQfMJOWS91oN65M
         85aO26fiEpCnOte5IMuRu8oG60cCMoGnnzIWgMFzCYCG3mgno8PNqKloTgV930QtlmSi
         MiGmxO8k62ou9LaoYCpxWTRh2AYuPzIEG5ZKOJlXQqu8uk4N+krZKTLIuHZIlt7ZWEY6
         KEC7dOxsa+oaZVSfyRsu4w3DAdDjUrC2bL8vS97ji6CmCJDWvJNwC0oFQa+I4jzRGqz1
         JxSw==
X-Gm-Message-State: AOAM532xAb5Fik4shjqOITh0xhdrNgSGc+9RxJeqDkrA6ogP7ZM5IBEp
        JEk1msphpz2dZkZR19rsBNzQZDP/6a4KNQ==
X-Google-Smtp-Source: ABdhPJxJmKLIjw4qWGdZWRks4nnBcy8pdHYButyTVKyc/5wqhzgbZ2ELt8V1U/24mihHi9J/NLwzRA346lfUOg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:5c4b:: with SMTP id
 n11mr1204330pgm.105.1636589004600; Wed, 10 Nov 2021 16:03:24 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:03 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 05/12] KVM: selftests: Use shorthand local var to access
 struct perf_tests_args
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Use 'pta' as a local pointer to the global perf_tests_args in order to
shorten line lengths and make the code borderline readable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/lib/perf_test_util.c        | 35 ++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index a015f267d945..ccdc950c829e 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -24,7 +24,8 @@ static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
  */
 static void guest_code(uint32_t vcpu_id)
 {
-	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
+	struct perf_test_args *pta = &perf_test_args;
+	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
 	uint64_t gva;
 	uint64_t pages;
 	int i;
@@ -37,9 +38,9 @@ static void guest_code(uint32_t vcpu_id)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * perf_test_args.guest_page_size);
+			uint64_t addr = gva + (i * pta->guest_page_size);
 
-			if (i % perf_test_args.wr_fract == 0)
+			if (i % pta->wr_fract == 0)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -53,6 +54,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src)
 {
+	struct perf_test_args *pta = &perf_test_args;
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
@@ -60,29 +62,29 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	perf_test_args.host_page_size = getpagesize();
+	pta->host_page_size = getpagesize();
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
 	 */
-	perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
+	pta->guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
-				(vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
+				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
 
-	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
 		    "Guest memory size is not host page size aligned.");
-	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 	TEST_ASSERT(guest_num_pages % slots == 0,
 		    "Guest memory cannot be evenly divided into %d slots.",
 		    slots);
 
 	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
+				  (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
 				  0, guest_code, NULL);
 
-	perf_test_args.vm = vm;
+	pta->vm = vm;
 
 	/*
 	 * If there should be more memory in the guest test region than there
@@ -96,7 +98,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    vcpu_memory_bytes);
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
-			      perf_test_args.guest_page_size;
+			      pta->guest_page_size;
 	guest_test_phys_mem = align_down(guest_test_phys_mem, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
@@ -108,7 +110,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
 		vm_paddr_t region_start = guest_test_phys_mem +
-			region_pages * perf_test_args.guest_page_size * i;
+			region_pages * pta->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    PERF_TEST_MEM_SLOT_INDEX + i,
@@ -133,25 +135,26 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 			   uint64_t vcpu_memory_bytes,
 			   bool partition_vcpu_memory_access)
 {
+	struct perf_test_args *pta = &perf_test_args;
 	vm_paddr_t vcpu_gpa;
 	struct perf_test_vcpu_args *vcpu_args;
 	int vcpu_id;
 
 	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
+		vcpu_args = &pta->vcpu_args[vcpu_id];
 
 		vcpu_args->vcpu_id = vcpu_id;
 		if (partition_vcpu_memory_access) {
 			vcpu_args->gva = guest_test_virt_mem +
 					 (vcpu_id * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
-					   perf_test_args.guest_page_size;
+					   pta->guest_page_size;
 			vcpu_gpa = guest_test_phys_mem +
 				   (vcpu_id * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
-					   perf_test_args.guest_page_size;
+					   pta->guest_page_size;
 			vcpu_gpa = guest_test_phys_mem;
 		}
 
@@ -159,6 +162,6 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			 vcpu_id, vcpu_gpa, vcpu_gpa +
-			 (vcpu_args->pages * perf_test_args.guest_page_size));
+			 (vcpu_args->pages * pta->guest_page_size));
 	}
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog


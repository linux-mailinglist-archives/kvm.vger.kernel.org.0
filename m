Return-Path: <kvm+bounces-1383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B717E7359
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C873280DB9
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9B83AC00;
	Thu,  9 Nov 2023 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WoN/S/qg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2822739862
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:59 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE5A49EA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:58 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afe220cadeso18512337b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563837; x=1700168637; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2a/M+0Fr1PqC5kgKOfRG5N8I8zu921PMSouy8YMa7RU=;
        b=WoN/S/qgMPKbQJC6g+FjJzVngApy91gFcXr6idpMzzZW58JvfHB465Vg230vhUI22y
         TM2HJ3JSXvRAvG0ATN349naHWRQJs/Ei+oDqppbwrDarw4t40LrdjkzIbhC+I99LjJ++
         jqo3Cix2MVA9u7glOE2zJuKUiN6uRC+4ELgkox7H9LSHuPbUhhHbIykf8M/0UU2XTWUB
         tQZyCgW4+xeal4dQJEsf4T9Kh93vSxyHEtiqD82wwpWFiiLoo/yKGjlawcvAYhgvxFuX
         f0WXANlamJ9IsJtv+rrYyXzmsTq7MNw2+Q2ZHT+asHl40AY/Qpr6/WUde32OSOkY0JGm
         EiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563837; x=1700168637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2a/M+0Fr1PqC5kgKOfRG5N8I8zu921PMSouy8YMa7RU=;
        b=k50xyFAfJERA0Hl960Fbktq/JqRf4owx/RJlj7SXdLklrBbs+x1K5x4bFu+G9jvR8q
         H7iuwSDobfCtj6i8kmNW6nInoG64feTqFwfmH1EXUY/jD0gBax6HT2yyC2Pi9cq3BD7E
         35Ko5JMCtxxFXncKR+jHVh2p0ZEsh1OL/pvz+SkFrw617easPlfjZ8CmfKPbXlYiyF0l
         EmDu6wYSM7oAiCghFO67B1/A92Sy4sbTmXHXgOD8r4SrXExfljikuuckO5ZQcadHj7Ky
         p/wFA9wkBIJO6JYOVb4PZCR/YG7xVf6or+KReLzKND+/DUcH+Co4mXGb6RV3rynI9v4l
         paew==
X-Gm-Message-State: AOJu0YxrWim/oKVuA6+vH/KH2SiyB8HqHNLfeTthoEaIZ+ZiGlufMNVU
	vD/0SFAevsP9p3b72kNrLKVX+babj4B4qw==
X-Google-Smtp-Source: AGHT+IGkRtZ0otuvawnXg3FnB/DDPqjO//IWJIG3gi/q13j0FI8C9+TJy7xo5m2vn9PLkCfKS8hq9ldNvIQW3A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:800c:0:b0:da0:48e1:5f46 with SMTP id
 m12-20020a25800c000000b00da048e15f46mr166858ybk.9.1699563837558; Thu, 09 Nov
 2023 13:03:57 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:24 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-14-amoorthy@google.com>
Subject: [PATCH v6 13/14] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Memslot flags aren't currently exposed to the tests, and are just always
set to 0. Add a parameter to allow tests to manually set those flags.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 2 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c             | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 .../selftests/kvm/x86_64/dirty_log_page_splitting_test.c      | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..b51656b408b8 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -306,7 +306,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;
 
-	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1, 0,
 				 params->backing_src, !overlap_memory_access);
 
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0455347f932a..61bb2e23bef0 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -163,7 +163,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	double vcpu_paging_rate;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..8b1a84a4db3b 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -153,7 +153,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src,
+				 p->slots, 0, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Random seed: %u\n", p->random_seed);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index ce4e603050ea..8be9609d3ca0 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -56,7 +56,7 @@ struct memstress_args {
 extern struct memstress_args memstress_args;
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index d05487e5a371..e74b09f39769 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -123,7 +123,7 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
@@ -212,7 +212,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+					    region_pages, slot_flags);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..0b19ec3ecc9c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..a770d7fa469a 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -100,7 +100,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	struct kvm_page_stats stats_dirty_logging_disabled;
 	struct kvm_page_stats stats_repopulated;
 
-	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size,
+	vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size, 0,
 				 SLOTS, backing_src, false);
 
 	guest_num_pages = (VCPUS * guest_percpu_mem_size) >> vm->page_shift;
-- 
2.42.0.869.gea05f2083d-goog



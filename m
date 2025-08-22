Return-Path: <kvm+bounces-55483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6968B30FE6
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83ACFA26BDF
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C23F2E717B;
	Fri, 22 Aug 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdV1tyce"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985032253F9;
	Fri, 22 Aug 2025 07:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846398; cv=none; b=H+fDVKjl5Qe0rRvvEiPFKcxfpN5XrcyxyaRTMqxmvPy2HvvciMdaV4wzQjL5YPXepi5yn5u1TezlXC/p8PgzlYY9MSKfT3E1Z/ZwKnJ5SGhbZcPKZnAr5gtvNzMEYONay+U/SIy0Hv2LKksOlzF/q3Sslhyl8pqe2B41rT473ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846398; c=relaxed/simple;
	bh=vK1Fc9hq2tBF3cBCzzIiljNe8N3mobe9b1tyZxZ4buU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTn2ZoefVl73aruxdfV3C6x6T6fXeAm0kgJTWJLDvbXDKGrcFRr5prPqqbJbmQQUDtnRkT5x9MzZ2dsj5s3gfFy8YykIkG+75qsrcjxeheKGgAMubsfxi8qy5qqAjzzfvDmFTGQjRgejFkuuOYs1wKCpNynZfKCNuc2M4LKse7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gdV1tyce; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755846397; x=1787382397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vK1Fc9hq2tBF3cBCzzIiljNe8N3mobe9b1tyZxZ4buU=;
  b=gdV1tyceWLlO52sClX9gUdm/86iKswrVRVRmFCTznxgtoIwRHczlLDyy
   rJnvppcevpYVSH4qjmCD8Q5v5feKEw4y7uwufVNlu1RW4dJqAWnhZHml/
   TsXFte2A5ZWQzzYQLWSm6aIyCuFq0q1uPPQdAM5pYS8vRtneSEGnD8/Kg
   MpIk7mmhfA37zhIQqkpu3wFSgkHVG1Y/6BcLqjvriwCXIPdIYn7PdDvf/
   9DrgiFZbD035juDPbGY9CT6djBR00JHEXoT6tHAbcaaP4zIemkg2HcQvn
   Rc3I994WKbPvXpwDSKuYHiXqUyzuJCRubQHYOq1qG9o3G80yUoDFFfjzg
   Q==;
X-CSE-ConnectionGUID: CkABdel/STCriOejPEsGlg==
X-CSE-MsgGUID: N9f47Mz7S6qCujcg9JIqIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58216274"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58216274"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:06:36 -0700
X-CSE-ConnectionGUID: gcF2yLkNSUSlOftyS9kDBw==
X-CSE-MsgGUID: 1MzEeu0TSqiaScYbMY6pxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="172829670"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:06:34 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: reinette.chatre@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/3] KVM: selftests: Test prefault memory during concurrent memslot removal
Date: Fri, 22 Aug 2025 15:05:54 +0800
Message-ID: <20250822070554.26523-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822070305.26427-1-yan.y.zhao@intel.com>
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test prefault memory during concurrent memslot removal.

Add a new param "remove_slot" to pre_fault_memory() to indicate testing
concurrent memslot removal. When "remove_slot" is set:

Create a remove_thread which deletes the test slot concurrently while the
main thread is executing ioctl KVM_PRE_FAULT_MEMORY on the test slot memory
range.

Introduce variables "delete_thread_ready" and "prefault_ready" to
synchronize the slot removal and ioctl KVM_PRE_FAULT_MEMORY. When the
concurrency is achieved, ioctl KVM_PRE_FAULT_MEMORY should return the error
EAGAIN. Otherwise, the ioctl should succeed as in cases where remove_slot
is not set.

Retry ioctl KVM_PRE_FAULT_MEMORY upon receiving EAGAIN. Since the memslot
should have been successfully removed during the retry, EFAULT or ENOENT
should be returned depending on whether the prefault is for private or
shared memory.

Split the existing "gpa" parameter in pre_fault_memory() into "base_gpa"
and "offset" to facilitate adding the test slot back to "base_gpa" after
the test concludes, ensuring that subsequent tests are not affected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 94 +++++++++++++++----
 1 file changed, 78 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..56e65feb4c8c 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -10,12 +10,16 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <pthread.h>
 
 /* Arbitrarily chosen values */
 #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
 #define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
 #define TEST_SLOT		10
 
+static bool prefault_ready;
+static bool delete_thread_ready;
+
 static void guest_code(uint64_t base_gpa)
 {
 	volatile uint64_t val __used;
@@ -30,17 +34,47 @@ static void guest_code(uint64_t base_gpa)
 	GUEST_DONE();
 }
 
-static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
-			     u64 left)
+static void *remove_slot_worker(void *data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	WRITE_ONCE(delete_thread_ready, true);
+
+	while (!READ_ONCE(prefault_ready))
+		cpu_relax();
+
+	vm_mem_region_delete(vcpu->vm, TEST_SLOT);
+
+	WRITE_ONCE(delete_thread_ready, false);
+	return NULL;
+}
+
+static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
+			     u64 size, u64 left, bool private, bool remove_slot)
 {
 	struct kvm_pre_fault_memory range = {
-		.gpa = gpa,
+		.gpa = base_gpa + offset,
 		.size = size,
 		.flags = 0,
 	};
-	u64 prev;
+	pthread_t remove_thread;
+	bool remove_hit = false;
 	int ret, save_errno;
+	u64 prev;
 
+	if (remove_slot) {
+		pthread_create(&remove_thread, NULL, remove_slot_worker, vcpu);
+
+		while (!READ_ONCE(delete_thread_ready))
+			cpu_relax();
+
+		WRITE_ONCE(prefault_ready, true);
+	}
+
+	/*
+	 * EAGAIN may be returned if slot removal is performed during
+	 * KVM_PRE_FAULT_MEMORY.
+	 */
 	do {
 		prev = range.size;
 		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
@@ -49,18 +83,42 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
 			    "%sexpecting range.size to change on %s",
 			    ret < 0 ? "not " : "",
 			    ret < 0 ? "failure" : "success");
-	} while (ret >= 0 ? range.size : save_errno == EINTR);
 
-	TEST_ASSERT(range.size == left,
-		    "Completed with %lld bytes left, expected %" PRId64,
-		    range.size, left);
+		if (remove_slot && ret < 0 && save_errno == EAGAIN)
+			remove_hit = true;
+
+	} while (ret >= 0 ? range.size : ((save_errno == EINTR) || (save_errno == EAGAIN)));
 
-	if (left == 0)
-		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
-	else
-		/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
-		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+	if (remove_slot) {
+		pthread_join(remove_thread, NULL);
+		WRITE_ONCE(prefault_ready, false);
+
+		vm_userspace_mem_region_add(vcpu->vm, VM_MEM_SRC_ANONYMOUS,
+					    base_gpa, TEST_SLOT, TEST_NPAGES,
+					    private ? KVM_MEM_GUEST_MEMFD : 0);
+	}
+
+	if (remove_hit) {
+		/*
+		 * Prefault within a removed memory slot range returns
+		 * - EFAULT for private memory or
+		 * - ENOENT for shared memory (due to RET_PF_EMULATE).
+		 */
+		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == (private ? EFAULT : ENOENT),
 					    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+	} else {
+		TEST_ASSERT(range.size == left,
+			    "Completed with %lld bytes left, expected %" PRId64,
+			    range.size, left);
+
+		if (left == 0)
+			__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY",
+						    ret, vcpu->vm);
+		else
+			/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
+			__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+						    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+	}
 }
 
 static void __test_pre_fault_memory(unsigned long vm_type, bool private)
@@ -97,9 +155,13 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
 	if (private)
 		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, 0);
-	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
-	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
+
+	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private, true);
+	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private, false);
+	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE,
+			 private, false);
+	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE,
+			 private, false);
 
 	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
 	vcpu_run(vcpu);
-- 
2.43.2



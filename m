Return-Path: <kvm+bounces-1121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCB97E4E76
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8604D28159A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADAB10E8;
	Wed,  8 Nov 2023 01:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IS9j7CXK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3604812
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:10:00 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52357E7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:10:00 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afbcffe454so126399677b3.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 17:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699405799; x=1700010599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QukVHBGeYSPz1+2qTuLcVIbH1kQU9rT6cdzN6AFG5KM=;
        b=IS9j7CXKvnl2UuQibEx4/5Sofxn9Wex5loBOdQLX61HDteZ6ZfpD/4Y5OnFkVBDZBH
         OmbCaiVGHk52Jo5/CsKjUOtfvM/3gKatnxckZYib2u/P2JyK7qga7sCqMDlZwPfQXrw0
         9uqDFgYoNYzeB3GsVeCKGX5GYNNqVgLcruX7orISmB9jC48ECKUD1/pMFczfieGRcnGo
         HokhtWzm9/xvr8/7wFubUODsSf4tQUwEEBUKsXOS1GmEWdC2FKPh+wxtBKAdIw0LBkeO
         nujKalhI64wkOiTJk5B9k2juwgf3TsK/1A0iKwhaVr3sARc2T1VEcCdVxx1M3XFbF/jE
         5ZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699405799; x=1700010599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QukVHBGeYSPz1+2qTuLcVIbH1kQU9rT6cdzN6AFG5KM=;
        b=fVYJU6lEXgrwCx/KgdTltTrkg/8f+UPnTs6YUqGO0XolIuZQLkEMxcSlnCY49KKwL2
         v2S0J4E52Qyf4OMXUkMYucjeJd/SSdXIgT6KD2MQc9JoCETEnXBV8kNQOsRCoOYcWaXH
         ra2JVD+vV5m3GqmrM2Q9Kgo6Sx4cOLIBzwhgqtdsQu5rkiDh8GVYOUvAnxUWkO5v3+Nb
         0J0/T3eY0d6tpcvamGZ58B40g8sFapO9fqa5X/IOFeyenNffoLbWnQkhjivBWx2M/tm/
         6SN/QM5aHTX0laSOQwsAdz8W32qP9BeeMoHpJlllQ+HUgYHbmfZk8iYmFKwa5S3D+m+A
         EtZw==
X-Gm-Message-State: AOJu0YwEbWo9e8WYLkAK3ZKSol3EKmWFirMt3ryxusPdQc6mqDFT2Weg
	eKHnBR142zqYeeQIwfkiuqYDDYlD92A=
X-Google-Smtp-Source: AGHT+IG5EDfRYHa9zbeZsaffwrzHpUf2L31GOHkP08fuh//RS6O1PJrNN1NM4sIC7p9V4KivNphMc2ySjXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d745:0:b0:5a7:b672:4d88 with SMTP id
 z66-20020a0dd745000000b005a7b6724d88mr7106ywd.0.1699405799597; Tue, 07 Nov
 2023 17:09:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 17:09:53 -0800
In-Reply-To: <20231108010953.560824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108010953.560824-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108010953.560824-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Add logic to detect if ioctl() failed
 because VM was killed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add yet another macro to the VM/vCPU ioctl() framework to detect when an
ioctl() failed because KVM killed/bugged the VM, i.e. when there was
nothing wrong with the ioctl() itself.  If KVM kills a VM, e.g. by way of
a failed KVM_BUG_ON(), all subsequent VM and vCPU ioctl()s will fail with
-EIO, which can be quite misleading and ultimately waste user/developer
time.

Use KVM_CHECK_EXTENSION on KVM_CAP_USER_MEMORY to detect if the VM is
dead and/or bug, as KVM doesn't provide a dedicated ioctl().  Using a
heuristic is obviously less than ideal, but practically speaking the logic
is bulletproof barring a KVM change, and any such change would arguably
break userspace, e.g. if KVM returns something other than -EIO.

Without the detection, tearing down a bugged VM yields a cryptic failure
when deleting memslots:

  ==== Test Assertion Failure ====
  lib/kvm_util.c:689: !ret
  pid=45131 tid=45131 errno=5 - Input/output error
     1	0x00000000004036c3: __vm_mem_region_delete at kvm_util.c:689
     2	0x00000000004042f0: kvm_vm_free at kvm_util.c:724 (discriminator 12)
     3	0x0000000000402929: race_sync_regs at sync_regs_test.c:193
     4	0x0000000000401cab: main at sync_regs_test.c:334 (discriminator 6)
     5	0x0000000000416f13: __libc_start_call_main at libc-start.o:?
     6	0x000000000041855f: __libc_start_main_impl at ??:?
     7	0x0000000000401d40: _start at ??:?
  KVM_SET_USER_MEMORY_REGION failed, rc: -1 errno: 5 (Input/output error)

Which morphs into a more pointed error message with the detection:

  ==== Test Assertion Failure ====
  lib/kvm_util.c:689: false
  pid=80347 tid=80347 errno=5 - Input/output error
     1	0x00000000004039ab: __vm_mem_region_delete at kvm_util.c:689 (discriminator 5)
     2	0x0000000000404660: kvm_vm_free at kvm_util.c:724 (discriminator 12)
     3	0x0000000000402ac9: race_sync_regs at sync_regs_test.c:193
     4	0x0000000000401cb7: main at sync_regs_test.c:334 (discriminator 6)
     5	0x0000000000418263: __libc_start_call_main at libc-start.o:?
     6	0x00000000004198af: __libc_start_main_impl at ??:?
     7	0x0000000000401d90: _start at ??:?
  KVM killed/bugged the VM, check the kernel log for clues

Suggested-by: Michal Luczaj <mhal@rbox.co>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 39 ++++++++++++++++---
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1f6193dc7d3a..c7717942ddbb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -282,11 +282,40 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 	kvm_do_ioctl((vm)->fd, cmd, arg);			\
 })
 
+/*
+ * Assert that a VM or vCPU ioctl() succeeded, with extra magic to detect if
+ * the ioctl() failed because KVM killed/bugged the VM.  To detect a dead VM,
+ * probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM since before
+ * selftests existed and (b) should never outright fail, i.e. is supposed to
+ * return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
+ * VM and its vCPUs, including KVM_CHECK_EXTENSION.
+ */
+#define __TEST_ASSERT_VM_VCPU_IOCTL(cond, name, ret, vm)				\
+do {											\
+	int __errno = errno;								\
+											\
+	static_assert_is_vm(vm);							\
+											\
+	if (cond)									\
+		break;									\
+											\
+	if (errno == EIO &&								\
+	    __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {	\
+		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");	\
+		TEST_FAIL("KVM killed/bugged the VM, check the kernel log for clues");	\
+	}										\
+	errno = __errno;								\
+	TEST_ASSERT(cond, __KVM_IOCTL_ERROR(name, ret));				\
+} while (0)
+
+#define TEST_ASSERT_VM_VCPU_IOCTL(cond, cmd, ret, vm)		\
+	__TEST_ASSERT_VM_VCPU_IOCTL(cond, #cmd, ret, vm)
+
 #define vm_ioctl(vm, cmd, arg)					\
 ({								\
 	int ret = __vm_ioctl(vm, cmd, arg);			\
 								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, vm);		\
 })
 
 static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
@@ -301,7 +330,7 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 ({								\
 	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
 								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
 })
 
 /*
@@ -312,7 +341,7 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 {
 	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
 
-	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
+	TEST_ASSERT_VM_VCPU_IOCTL(ret >= 0, KVM_CHECK_EXTENSION, ret, vm);
 	return ret;
 }
 
@@ -371,7 +400,7 @@ static inline int vm_get_stats_fd(struct kvm_vm *vm)
 {
 	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
 
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
+	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_GET_STATS_FD, fd, vm);
 	return fd;
 }
 
@@ -583,7 +612,7 @@ static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
 {
 	int fd = __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
 
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
+	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_CHECK_EXTENSION, fd, vcpu->vm);
 	return fd;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..c847f942cd38 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1227,7 +1227,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu->vm = vm;
 	vcpu->id = vcpu_id;
 	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
-	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
+	TEST_ASSERT_VM_VCPU_IOCTL(vcpu->fd >= 0, KVM_CREATE_VCPU, vcpu->fd, vm);
 
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
-- 
2.42.0.869.gea05f2083d-goog



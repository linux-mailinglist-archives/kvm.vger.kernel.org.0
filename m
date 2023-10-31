Return-Path: <kvm+bounces-146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 344637DC382
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 01:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B96B2B20C4E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 00:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A463807;
	Tue, 31 Oct 2023 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DutbvxFd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C67F2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 00:20:55 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9181F4
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:20:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0cb98f66cso4125262276.2
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698711653; x=1699316453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QBv8J2j2tFrn/qyS6YAMefYGNMpKBA+EnJ/tz9XeZcQ=;
        b=DutbvxFdNj+zxFsXIApxuqgL/svtHFE4X/w9rnzDlctDS5aEKYBHsMFuGsD2ppEan5
         YFMqvnCKG53Rlybn98y5q77a5MpuTtAucEPhIo7eNk2V2+s7EPAj4EjoZBsxjiDA1Wgp
         wZyw9LMd2L4yUILKkMIJFH/1f1+Ais7lSpK/pUNwe4B9tfDfsTc1jUYuMaYPzxVg7ODU
         Iwvs+PMW6VidbEzn0tHKXJ+viUEAs8xkSYidMx8TdObaEwuzsWe2YmDYf0JxpwIfdben
         DccNkbIfGdDwrnq3qLloMhx6T6yKHqGXtqh+AZmjyqVu2zal4Z5Kh2E43uC+4/vEsslQ
         BfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698711653; x=1699316453;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QBv8J2j2tFrn/qyS6YAMefYGNMpKBA+EnJ/tz9XeZcQ=;
        b=OXGCXo8496HujCLenLKuj6OeC02ipY4Hz8ppDOUEFERtpc7Bq8PgP2lBrQ061Plc2M
         zKHXr/M7nedvcHpKP9VulAA6XG0WlN/ZuQOBfCNSuAJmw9viS9SlNBtzwKlh+1zt1ySw
         3DONSsKCbwq8LAnvvZ6JNWj3idPJ6s7SHNVtA4pFVc3NblwZMQOtxb37vJkdXEa+QNSB
         xpe+a3XjwVHfrIkIPfXj1XD1GdhviDS+L2jtqecxOa43xNLgxZkrDoIHOk47FaQFRW6c
         Wntln+lPvH1NLKewHbG9VSdXXa0pl6PSK1dP+y6BpqSJWfThOr9JlkU+7eX0bJ4XkBHV
         J6/A==
X-Gm-Message-State: AOJu0YwGvabRKPtT6iGsMMW/4QK799LEANuWhdLt6ioU6DrNrEDdAwvN
	9TdWX8gnGRHPXev82Id/Odtf4mbpUSo=
X-Google-Smtp-Source: AGHT+IHDrosN2uCkEGjbekhzE56kmIuP6ZdJ4qX5BxhY2UQvH9WBnwhhS/T43sOArnZ3ZTMzAD09hmalB/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:168c:b0:da0:3e46:8ba5 with SMTP id
 bx12-20020a056902168c00b00da03e468ba5mr205460ybb.8.1698711652929; Mon, 30 Oct
 2023 17:20:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 30 Oct 2023 17:20:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231031002049.3915752-1-seanjc@google.com>
Subject: [PATCH guest_memfd] KVM: selftests: Add a memory region subtest to
 validate invalid flags
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a subtest to set_memory_region_test to verify that KVM rejects invalid
flags and combinations with -EINVAL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Selftest that *tries* to detect cases where KVM allows v2 flags for
KVM_SET_USER_MEMORY_REGION.  It's kinda worthless because KVM will likely fail
with EINVAL anyways, but maybe it'll provide meaningful coverage in concert
with a sanitizer?

 .../selftests/kvm/set_memory_region_test.c    | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ca83e3307a98..268baf853bd6 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -326,6 +326,53 @@ static void test_zero_memory_regions(void)
 }
 #endif /* __x86_64__ */
 
+static void test_invalid_memory_region_flags(void)
+{
+	uint32_t supported_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	const uint32_t v2_only_flags = KVM_MEM_PRIVATE;
+	struct kvm_vm *vm;
+	int r, i;
+
+#ifdef __x86_64__
+	supported_flags |= KVM_MEM_READONLY;
+
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
+		vm = vm_create_barebones_protected_vm();
+	else
+#endif
+		vm = vm_create_barebones();
+
+	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		supported_flags |= KVM_MEM_PRIVATE;
+
+	for (i = 0; i < 32; i++) {
+		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
+			continue;
+
+		r = __vm_set_user_memory_region(vm, MEM_REGION_SLOT, BIT(i),
+						MEM_REGION_GPA, MEM_REGION_SIZE, NULL);
+
+		TEST_ASSERT(r && errno == EINVAL,
+			    "KVM_SET_USER_MEMORY_REGION should have failed on v2 only flag 0x%lx", BIT(i));
+
+		if (supported_flags & BIT(i))
+			continue;
+
+		r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT, BIT(i),
+						 MEM_REGION_GPA, MEM_REGION_SIZE, NULL, 0, 0);
+		TEST_ASSERT(r && errno == EINVAL,
+			    "KVM_SET_USER_MEMORY_REGION2 should have failed on unsupported flag 0x%lx", BIT(i));
+	}
+
+	if (supported_flags & KVM_MEM_PRIVATE) {
+		r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+						 KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_PRIVATE,
+						 MEM_REGION_GPA, MEM_REGION_SIZE, NULL, 0, 0);
+		TEST_ASSERT(r && errno == EINVAL,
+			    "KVM_SET_USER_MEMORY_REGION2 should have failed, dirty logging private memory is unsupported");
+	}
+}
+
 /*
  * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
  * tentative to add further slots should fail.
@@ -491,6 +538,8 @@ int main(int argc, char *argv[])
 	test_zero_memory_regions();
 #endif
 
+	test_invalid_memory_region_flags();
+
 	test_add_max_memory_regions();
 
 	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&

base-commit: 881375a408c0f4ea451ff14545b59216d2923881
-- 
2.42.0.820.g83a721a137-goog



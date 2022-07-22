Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC40657E847
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiGVUXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiGVUXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:23:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C192AF86D
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u6-20020a25b7c6000000b00670862c5b16so4413069ybj.12
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LotgCwTPE7W0Iog/EgRAiJU4OXX1J8eWyfbtht/7qSU=;
        b=pWifpqbzWfnhr9vzlztD0iRmDjf6xepYMBaIFE0nit1Ymw1wxwYv/D1ioJTYBh/wMi
         EgKS5fvdEHwXXyTKdlf+/9SALX4Cjx3SYF8dVY3W4BkReDfH3KIdM8HYNK19ww7dB2Uw
         ELbwge9idiwSAXUkCOf9THUMfMhBW/ZEApOvrY32miNxE3x7TEzmDJ7hTPVtGIzUJIh3
         DWO/2xg79daZjtJLYPCcWfE5vE7wJshQ2s/mz0ybyMXsGHDBWai1PqTNnx2hDyJz7dQY
         Xgap+sYlAEGl1zVFf3J7vpO3mm5zKg7sPqw4yl4vrUFdGKtkwNKJRCRU+ijMnqHrOBEz
         fXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LotgCwTPE7W0Iog/EgRAiJU4OXX1J8eWyfbtht/7qSU=;
        b=55pm7VDzNbsWiT8P6wRM/+k8zElnkmjUKSGdnzCp3C//nlXwtwLiWPp4lL6Q3hmbGJ
         XVroAfU5DLHUJZJVQqzJ4vMYxAlbY4c+pvd8O1oTPX9VvIgRahwBbKcAh3w1JTfVXOuJ
         UTMODb+oVLWhnNufietLQ7glMZq+devJDfRhfNdIQit6N87xw0oqnuUCqHivqgFKgra9
         O8SFJdBPEzwnO7Dq+M5Or8nE749woXogueJ0AQZrYs9Wvlw/rBLsWBV/xWQ5O+409B8u
         ELtdFcF8rq2afvuHptTSvkhX9tMIDj1D826beA5S52nfjmZmeKHsLX/1U7noLsUE7h5B
         iK1Q==
X-Gm-Message-State: AJIora+Pi1Pm0kRkApE5jMrUU+mmaKNtxFC7nZEYt1uTGbjaPIKSvOpl
        ynTu5Rk79JL1c7IBuDro1HjijjMnXDaWxuJGgektHZQ5qTYxpTgDd/dTs4HWXii1nx0wX4Ce24L
        rni0l4b1Bo932gVO98q9MfvZQRIJPzlM/UdRBSHcf6yfU7bstUx13BD4th+PifFm8hJfB
X-Google-Smtp-Source: AGRyM1vR5+e5DhehxYSXChpczI8kiGskrMMXGcpU5ly/rWU1pcg0RVvZwkimu0MGnsjAy5IL1DhYotoORiTyMhU2
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:36c3:0:b0:31e:6899:dd7b with SMTP
 id d186-20020a8136c3000000b0031e6899dd7bmr1387271ywa.205.1658521399937; Fri,
 22 Jul 2022 13:23:19 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:23:03 +0000
In-Reply-To: <20220722202303.391709-1-aaronlewis@google.com>
Message-Id: <20220722202303.391709-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220722202303.391709-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v3 4/4] selftests: kvm/x86: Test the flags in MSR
 filtering / exiting
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

When using the flags in KVM_X86_SET_MSR_FILTER and
KVM_CAP_X86_USER_SPACE_MSR it is expected that an attempt to write to
any of the unused bits will fail.  Add testing to walk over every bit
in each of the flag fields in MSR filtering / exiting to verify that
happens.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/userspace_msr_exit_test.c      | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index f84dc37426f5..0173bd41b577 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -734,6 +734,89 @@ static void test_msr_permission_bitmap(void)
 	kvm_vm_free(vm);
 }
 
+#define test_user_exit_msr_ioctl(vm, cmd, arg, flag, valid_mask)	\
+({									\
+	int r = __vm_ioctl(vm, cmd, arg);				\
+									\
+	if (flag & valid_mask)						\
+		TEST_ASSERT(!r, __KVM_IOCTL_ERROR(#cmd, r));		\
+	else								\
+		TEST_ASSERT(r == -1 && errno == EINVAL,			\
+			    "Wanted EINVAL for %s with flag = 0x%llx, got  rc: %i errno: %i (%s)", \
+			    #cmd, flag, r, errno,  strerror(errno));	\
+})
+
+static void run_user_space_msr_flag_test(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = { .cap = KVM_CAP_X86_USER_SPACE_MSR };
+	int nflags = sizeof(cap.args[0]) * BITS_PER_BYTE;
+	int rc;
+	int i;
+
+	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+
+	for (i = 0; i < nflags; i++) {
+		cap.args[0] = BIT_ULL(i);
+		test_user_exit_msr_ioctl(vm, KVM_ENABLE_CAP, &cap,
+			   BIT_ULL(i), KVM_MSR_EXIT_REASON_VALID_MASK);
+	}
+}
+
+static void run_msr_filter_flag_test(struct kvm_vm *vm)
+{
+	u64 deny_bits = 0;
+	struct kvm_msr_filter filter = {
+		.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+		.ranges = {
+			{
+				.flags = KVM_MSR_FILTER_READ,
+				.nmsrs = 1,
+				.base = 0,
+				.bitmap = (uint8_t *)&deny_bits,
+			},
+		},
+	};
+	int nflags;
+	int rc;
+	int i;
+
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
+
+	nflags = sizeof(filter.flags) * BITS_PER_BYTE;
+	for (i = 0; i < nflags; i++) {
+		filter.flags = BIT_ULL(i);
+		test_user_exit_msr_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
+			   BIT_ULL(i), KVM_MSR_FILTER_VALID_MASK);
+	}
+
+	filter.flags = KVM_MSR_FILTER_DEFAULT_ALLOW;
+	nflags = sizeof(filter.ranges[0].flags) * BITS_PER_BYTE;
+	for (i = 0; i < nflags; i++) {
+		filter.ranges[0].flags = BIT_ULL(i);
+		test_user_exit_msr_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter,
+			   BIT_ULL(i), KVM_MSR_FILTER_RANGE_VALID_MASK);
+	}
+}
+
+/* Test that attempts to write to the unused bits in a flag fails. */
+static void test_user_exit_msr_flags(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	/* Test flags for KVM_CAP_X86_USER_SPACE_MSR. */
+	run_user_space_msr_flag_test(vm);
+
+	/* Test flags and range flags for KVM_X86_SET_MSR_FILTER. */
+	run_msr_filter_flag_test(vm);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	/* Tell stdout not to buffer its content */
@@ -745,5 +828,7 @@ int main(int argc, char *argv[])
 
 	test_msr_permission_bitmap();
 
+	test_user_exit_msr_flags();
+
 	return 0;
 }
-- 
2.37.1.359.gd136c6c3e2-goog


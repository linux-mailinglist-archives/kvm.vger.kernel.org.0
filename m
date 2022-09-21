Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420CE5C00E5
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIUPPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIUPPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF168C47B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u131-20020a627989000000b0054d3cf50780so3714791pfc.22
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=2gChb2mZIRsjPOMMmksGp+RecOjQKuxIHCTvu3UAjtI=;
        b=P+agJWVynGZ+z9kGjbw/1DvFhP8x6E+hCKegnuO2tlmMLjudEN10aiTNFPUYraaOtj
         ye6ZTe4vCXxgabOsEChScm6Jk2F64EORRBQqHcJ8ax0r4TeT1yd4pQ8PVw6P00p1etH3
         ek62m1JQ9F2CXfRPkF/9l/D9SHcG50kAtyQcSDIHzKA8l3sYakKyrFCYx3H4amVFEBOE
         gu/CcgqUBYPIrMnFwLhpxcO7PMnA0Anl5OBdlvdn/cpewtRMYk/znR5Y0IutSgYBzMlI
         1KHfUHVeINe73sbzxoGveAk0Q4CK0x8xsciI1hfpnveTBmbg0lKcFnfpTQiYxaMi5gbh
         WpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=2gChb2mZIRsjPOMMmksGp+RecOjQKuxIHCTvu3UAjtI=;
        b=IDlQLO/sHAyWUoJhF//N4WtTL6sQ++evqFJzLyfmhUbvi82zprGBJDfDtfWxUFP8OK
         8HIgKa7B3G3tUAhPN3FaPKxguC/2/MfPDri+sw5d0a+j8SJ4wkE/xTU2zzKkqgnxjXwx
         DXvqvZCyOuD8ZNX2/a2+50H7sbjRKUF5ZH9fZ4LIMmiYehf6PmcszKTpfaF0o1B0I9R/
         KK7MpJXjmOA/05cxIqjgiSG3PqZnSX8CaEv5lLkODGeAZyxEH1KKi/T8LgL8LjIEP83R
         rLTpMu0EsSnLdGasBFsrZk5TUvoWjTbR4D5+x1DhH1nqDsbxkz4jWKg3uAPT72LiVqac
         izKg==
X-Gm-Message-State: ACrzQf2FA3B/R3M08nAV1YqMEyVcuIPoijMnBBzTVxTevUwyY3PEzUu2
        AjGJ6y0vXc4EEw92mZOT1Qm2A3gu3N+SxvnSAeHCf2nK0PcSzWESL1XfJ3LfwbWeq4wXfwu5rkC
        jKa9/FUGjp1bPfWyELPCZUP04I5jllh5mSwnfULyYfgCBIT4NSaOMjI9QvFXbGM3StKOo
X-Google-Smtp-Source: AMsMyM52YUOXkCVUFEU4YtM+hoCBb0Uj3NLhwjhBMTaMkd0/kUauYoV9Wg4I3jBw1ytcpTf3moFIrNTrGsoSZuCc
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:3303:0:b0:53e:30a2:8fb6 with SMTP
 id z3-20020a623303000000b0053e30a28fb6mr29236638pfz.39.1663773338541; Wed, 21
 Sep 2022 08:15:38 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:25 +0000
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220921151525.904162-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-6-aaronlewis@google.com>
Subject: [PATCH v4 5/5] selftests: kvm/x86: Test the flags in MSR filtering
 and MSR exiting
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
in each of the flag fields in MSR filtering and MSR exiting to verify
that unused bits return and error and used bits, i.e. valid bits,
succeed.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/userspace_msr_exit_test.c      | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index a4f06370a245..fae95089e655 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -733,6 +733,89 @@ static void test_msr_permission_bitmap(void)
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
@@ -744,5 +827,7 @@ int main(int argc, char *argv[])
 
 	test_msr_permission_bitmap();
 
+	test_user_exit_msr_flags();
+
 	return 0;
 }
-- 
2.37.3.968.ga6b4b080e4-goog


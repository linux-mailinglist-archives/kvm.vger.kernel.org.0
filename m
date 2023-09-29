Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388B77B3CDA
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 01:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbjI2XDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 19:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjI2XC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 19:02:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A7DF3
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a1f12cf1ddso24183257b3.0
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696028577; x=1696633377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sgA+7cwO+asCMW+VKWM9AdpqZBoug8Y8fkI9cjpUQc=;
        b=vvz8xJC9AOP4i5pONKNRi6xNyg54imAfZua0/qOtO/T9diPt5O85pA/fkanT1pFf/W
         fyI35Tw0ePc1JmUR4ZqcFaskSNU3qwPfcX73FriiDPnlIJdvl2JC0hpxmzjt9uNWCOnM
         g+nWVWWLgJuuh9Mky8l4XR3brqFeyagx3MPVTNAOqOSduXjpC8DBB2SYAuXfEMRTZRaM
         lwZqAcc6uTxzAc7s3N9nul9tqcMXelI4KBh4jon8znYf3otEYAOLsocsN6UvKxU4MX9W
         zgjZ5tktbLB7XUHPKIs8fSNt1g+tJEfzH8e/OosvoIeyyIyKS0lTyrHGfpwSmagERCGE
         rW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696028577; x=1696633377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sgA+7cwO+asCMW+VKWM9AdpqZBoug8Y8fkI9cjpUQc=;
        b=dJ48FDV83aqhY+O9drMWJPaoN1vFL5znFYwN00wPJOpwVSx7WYDwMNWbhDu8yIMUfZ
         r0xHcoOHq/rKwwVI7WrB1bzQyHD60EuqARx9vrRenYJgcq6z6hNTrEIv4AGp+E7XyJhs
         kyxOGvDtiHF70O7a+zpYxGnjbI+3kMOp9l8CQ0olJoy3PVJHFq2KdMrQfsyhoXU27TvM
         ebmhRxdQczQDGnQl88KYTwHMCNuXLauzq/8xs+gE/9v0Qam8cRaiLY9WEVVnTQ0j7/sU
         r4GgUtGwQbd0Sg2utPJyv1/0rCu8FFJ2RJphFHF8TxWbTd4LtwOQSS+wCqilflHKirug
         0QQQ==
X-Gm-Message-State: AOJu0YxLT2s7T0pcETrRJ58HXtMwDVF3ycvtqn70OgfR5td4wc2mSgYq
        3HUaJf3XEKDwJTAugKdCEXtK/cHPkgmcMWfeJAFnVD5dEkENuQ9DbK6XE48HK07RM11XakXvFzX
        P+7tRfxEwVO7WlZ5LNAIpUOCdeQwI51n4yf8nyQBEz8oXYEumWsAgutcyq5mngSQ=
X-Google-Smtp-Source: AGHT+IHk0TqQL6xGOoMTUd5a5awAcRM/1k97nhfdDUlTPS9xK4GWfJENfsuFCN6smPHC0C+bQP7g58Ve6ah6IQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:b104:0:b0:58c:e8da:4d1a with SMTP id
 p4-20020a81b104000000b0058ce8da4d1amr124682ywh.2.1696028577218; Fri, 29 Sep
 2023 16:02:57 -0700 (PDT)
Date:   Fri, 29 Sep 2023 16:02:46 -0700
In-Reply-To: <20230929230246.1954854-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230929230246.1954854-4-jmattson@google.com>
Subject: [PATCH v4 3/3] KVM: selftests: Test behavior of HWCR
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify the following:
* Attempts to set bits 3, 6, or 8 are ignored
* Bits 18 and 24 are the only bits that can be set
* Any bit that can be set can also be cleared

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 52 +++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..3b82c583c68d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -119,6 +119,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
new file mode 100644
index 000000000000..1a6a09791ac3
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023, Google LLC.
+ *
+ * Tests for the K7_HWCR MSR.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+void test_hwcr_bit(struct kvm_vcpu *vcpu, unsigned int bit)
+{
+	const unsigned long long ignored = BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8);
+	const unsigned long long valid = BIT_ULL(18) | BIT_ULL(24);
+	const unsigned long long legal = ignored | valid;
+	uint64_t val = BIT_ULL(bit);
+	uint64_t check;
+	int r;
+
+	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
+	TEST_ASSERT((r == 1 && (val & legal)) || (r == 0 && !(val & legal)),
+		    "Unexpected result (%d) when setting HWCR[bit %u]", r, bit);
+	check =	vcpu_get_msr(vcpu, MSR_K7_HWCR);
+	if (val & valid) {
+		TEST_ASSERT(check == val,
+			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,
+			    check, val);
+		vcpu_set_msr(vcpu, MSR_K7_HWCR, 0);
+	} else {
+		TEST_ASSERT(!check,
+			    "Bit %u: unexpected HWCR %lx; expected 0", bit,
+			    check);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	unsigned int bit;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	for (bit = 0; bit < BITS_PER_LONG; bit++)
+		test_hwcr_bit(vcpu, bit);
+
+	kvm_vm_free(vm);
+}
-- 
2.42.0.582.g8ccd20d70d-goog


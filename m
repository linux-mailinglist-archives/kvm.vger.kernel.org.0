Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CD57AE199
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 00:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjIYWP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 18:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjIYWP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 18:15:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CFB107
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d865f1447a2so8189301276.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695680121; x=1696284921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml2BjbCv499IKlnmZixHVZkHR6ooVHSvVHw92d4tj/U=;
        b=aO4IyjYd2t+zsEC3i4ZrJ1j7n6v/Bad3SJ/O6vOWFpURChKfO4w0EAkMdMP6/aXVWb
         gX5CxPKxpwbqqCY8YrwUuJFEF040sXGN0kSTWcS3b1JFn7gGbG9MfpsJzG9xxJwHSbRX
         +XzKPPvMQ/SQdLUGNBuk0g50kyxSqI1AQ737sh1Ub7GfvsgjQnjvTutSvcDi190oDN7T
         I/JF+voKEChvdvtY0UWjE82Cs4Oi0Ize3f0fjiI9Z/oQccfwzwiSHAgf21a62lPi/DP4
         limgLzUfdvQpvUwsyJ2tacLURuSzhTbZfqoBJU/dTiUmF3R4I9k/kEXFuceaJ9U9zVNj
         D7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695680121; x=1696284921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml2BjbCv499IKlnmZixHVZkHR6ooVHSvVHw92d4tj/U=;
        b=tAhTBODChKk023iVAYj7k6DghEqCvOPYYNE04TChaPnlDTULm0LXz9uZrWgjKFWM7J
         Ru8ap4DEAS2MW8X0EzeGTQKdLwtu6WkfjsM0mycyz25CAMKGGHeWIEm1RhP8XPhw9EyU
         2VZ/hGCt39JJbUIhWhlu2PjtcHEnxafcj35eGFvcTLXfepKQPYIVRL1VJNueW9xiGl4v
         edm0JFkWhtFdu7zLdHnDtGgiPhf1uuWaemTuioNKX5XnqiwpPaj9+kgGeTeEKB6lHe/i
         HrELUApympPiBSIwAAdQY/VNeNky7qiODseeOsmk20Ac12N3l1S2/wVLhSA6XTnGdCYN
         roMQ==
X-Gm-Message-State: AOJu0YzoMoqcYufBcAC/n5NSLo5xsUoozGpHxqDJ20Fon78OGGKm1r2r
        IeZBezLgokCY641CvTQYmLOgWAGkPBcdDTsiSl6n5B/g1TnieYxumYGXdWA8/HskkHmaFKf6g3o
        0GF/WlvJHBwXpS2fzEE9pWN1FKe2KoW7To9COdsVj0y2c850YMy4w/WG6k+nRG4g=
X-Google-Smtp-Source: AGHT+IGdjg0DjTyZ89iF8IFfJtBHxt6tt5bzPFrSdir0QZ6iBP8ufy168RHXTSBiUG5It+fmXYT321TlUkgL5A==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:e7d6:0:b0:d89:425b:77bd with SMTP id
 e205-20020a25e7d6000000b00d89425b77bdmr23668ybh.1.1695680121580; Mon, 25 Sep
 2023 15:15:21 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:15:12 -0700
In-Reply-To: <20230925221512.3817538-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230925221512.3817538-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925221512.3817538-4-jmattson@google.com>
Subject: [PATCH v2 3/3] KVM: selftests: Test behavior of HWCR
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
index a3bb36fb3cfc..6b0219ca65eb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -135,6 +135,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
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
2.42.0.515.g380fc7ccd1-goog


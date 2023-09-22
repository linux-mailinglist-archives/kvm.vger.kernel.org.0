Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2557AB636
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjIVQm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjIVQm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:42:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2A9196
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d85bdcbec9cso2939689276.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400969; x=1696005769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pc4LqSwL0IDo380jbAAxuI0kvYidIGTCgI8AUTd2CyM=;
        b=qOfhfQp0ANKBzgKid+Nhix7dG39QMfxDAa+7FNxOluNmIInHyyDRtHxhWTZ6bb6Yxs
         YrBgB1XHztGfvrYdUsdGapSo/8Iw6lcRr7Kf+67VQA4qW/zcFi6UmranMSziy7fWS4t7
         4Ce8r3tVHM924179JzwovsLoAExteJLfXxDPe1HWhZjSP9b15BGOVzPrBGngqHN/zr9F
         yQ2s5KSUzmg+Fh+5G9JhIQxYANgpE0rViqQPsvT1QtT+DEuCvCX0bbRxf1+ckgE4wvwh
         PBugG1R4fhJy1kvZ/x2IhV78SWahXfg0jFEitLHM2twjQV9k0B3UZUNrdfdtP3ykao/8
         ogUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400969; x=1696005769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pc4LqSwL0IDo380jbAAxuI0kvYidIGTCgI8AUTd2CyM=;
        b=cBiQBtouq6m14MjEUrYG+hcKLHgc+5WaKO6FXxSMJdMo/aaNyJwV7Aj7UDPAlF9TH6
         rTGUsEW64lPLcF9qPFeaNCFz9IlC8nxoHToO2h597yS4uYZsar+73759BcA9HZnuoKmU
         KGsyjqiJSxO3eeyaMP95hzQ0h4RN9wIh79xtgWbryQsuG3jf5+MNPFSByJ71HLlp3waX
         vIRhCmz31SPC2QnQgYWQOro48O29buCzAvcBEoMOaF5gViXHT6vWMknehHIKB29qew0P
         E9PgylBWg/9WR14AxEq98DYZ/GQXY8QokwNSYlqOmncOT0eRbkJXqdJDHBqMyvwW0qos
         EkUQ==
X-Gm-Message-State: AOJu0Yz6H2zbcxia7cGxQiogUC6st81pynAxsHTtSjSVYPcCzkeyn/yD
        QDFrbiyihH0A4X0DnX3aCirkqUeRZxmda5fWRTjzduRHgWHYb5hUFMDQ9ODYhPA89gj1BFTl7sH
        dJaY7R2Hbes1efFf2cbXAv53UHb0kd6zMMbLqPzt5HVA0uSSTbOaVUV5VazvpNoA=
X-Google-Smtp-Source: AGHT+IEMbgnlLMKIqfr7cBi7ACEzPLm4tshaqqkOifdjjyv9NnX5ucP3Z8kc/5FKauwQ0W+3GP16gLJqvg8c6Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:abe4:0:b0:d7f:809a:9787 with SMTP id
 v91-20020a25abe4000000b00d7f809a9787mr128693ybi.1.1695400969197; Fri, 22 Sep
 2023 09:42:49 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:42:39 -0700
In-Reply-To: <20230922164239.2253604-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230922164239.2253604-3-jmattson@google.com>
Subject: [PATCH 3/3] KVM: selftests: Test behavior of HWCR
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
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

Verify the following:
* Any bits that read as one cannot be cleared
* Attempts to set bits 3, 6, 8, or 24 are ignored
* Bit 18 is the only bit that can be set
* Any bit that can be set can also be cleared

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 57 +++++++++++++++++++
 2 files changed, 58 insertions(+)
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
index 000000000000..123267b44daf
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
@@ -0,0 +1,57 @@
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
+	const unsigned long long ignored =
+		BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8) | BIT_ULL(24);
+	const unsigned long long legal = ignored | BIT_ULL(18);
+	uint64_t orig = vcpu_get_msr(vcpu, MSR_K7_HWCR);
+	uint64_t val = BIT_ULL(bit);
+	uint64_t check;
+	int r;
+
+	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
+	TEST_ASSERT((r == 1 && (val & legal)) || (r == 0 && !(val & legal)),
+		    "Unexpected result (%d) when setting HWCR[bit %u]", r, bit);
+	check =	vcpu_get_msr(vcpu, MSR_K7_HWCR);
+	if (val & (legal & ~ignored)) {
+		TEST_ASSERT(check == (orig | val),
+			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,
+			    check, orig | val);
+		_vcpu_set_msr(vcpu, MSR_K7_HWCR, 0);
+		check =	vcpu_get_msr(vcpu, MSR_K7_HWCR);
+		TEST_ASSERT(check == orig,
+			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,
+			    check, orig);
+	} else {
+		TEST_ASSERT(check == orig,
+			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,
+			    check, orig);
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


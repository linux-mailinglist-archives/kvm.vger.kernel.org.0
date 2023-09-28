Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06037B258C
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjI1Svl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjI1Svj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:51:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD45719C
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2775a7f3803so11832060a91.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695927097; x=1696531897; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S97oJyeYvw/0Se2FKv0qxUl1yLtoNb25rJPKj1jUGiQ=;
        b=WPvk9MflTHgFNc45swxDEyQuxV/SiJMLy9EfE+1CbLUC/4swPAMCHdK3isb8KG0vM4
         y5Ng14Bx/dfyfdA/7q3QT+dBn6H4RKa3xRqNfhb7w5BXqhSLV3vxHUGwoWphxtmQ8RyE
         ZFlLuNMGj7u8qrm0HoXLXSMf4LlFy6myBKztcvbJf2A9jLE3EdiwlYxUMqxR682nHEE+
         /uBPxnaNPaYBIcn6Cj0fb1CiVR+aS2of2tBU98+fa5sUvrkjHB3PWLSSzucoKT3hN9uN
         uNaN0du5GztFtu9W7VPo7W0PF34dKJvq+QKxGpySfH5DTI91TI/emp39wTDo6M0LPXGf
         wurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695927097; x=1696531897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S97oJyeYvw/0Se2FKv0qxUl1yLtoNb25rJPKj1jUGiQ=;
        b=hv9+8+yGQrKrZuJN0UPmGJpUZ16pBIwjGblSdwuKTlEPebZyR8r1/S90l+x86BX6HM
         vuiIayKOI5WCGHvm+npWFJe4ijCFTDIGtFww0tMMcmYCDSVWOEV48AbQDsjb5f4PDXqe
         JiFjJUmnbEYlKYY+21yIAqdGm3dnKq8EUvD5FVe2zLAA2joRJVpEPjVpIHxHv3VSJlg6
         0Oq+sYevtauparPF5x7aSHzb0YsPh/mgyFbfDhVKPzfd0zmkndrJYuUJqPzOktE6NjFy
         IrDJvPDAgNXrhbCgUn9+z1aq1VV8nzKCuYn1cTqB8rxw5pDpSOnIoW+aYYSl4dCLO0Ew
         driw==
X-Gm-Message-State: AOJu0YzjFOYppj+Qim93wtZskrIcvVX8ac3y+ei4apcsKLVZRccXo6wH
        dtT/VMR6GAmbRt8wdrI5L15RW+AtDphCzDQRWMU0npNp/v3cbea/0VQN0dVOTyE1Icq13p1o3D+
        MLcn6IRsSRLamagUxyLTf/btR5/piCdpRFC/39LqCSuiSyyYzYQNyR/fJkBbNq5E=
X-Google-Smtp-Source: AGHT+IEx4quvXW26E7TsktKgIeonO2rtOJjJE+an/04F7PYtzXjIoYU/1WuGabHVo/USZ0tvVX7zQZoqU5TOQQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:903:244d:b0:1c6:d25:8750 with SMTP id
 l13-20020a170903244d00b001c60d258750mr30308pls.10.1695927096880; Thu, 28 Sep
 2023 11:51:36 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:51:28 -0700
In-Reply-To: <20230928185128.824140-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230928185128.824140-4-jmattson@google.com>
Subject: [PATCH v3 3/3] KVM: selftests: Test behavior of HWCR
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
2.42.0.582.g8ccd20d70d-goog


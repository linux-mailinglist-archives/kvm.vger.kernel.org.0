Return-Path: <kvm+bounces-4741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B63181771E
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADAA5285593
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4F24FF8F;
	Mon, 18 Dec 2023 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QfbvNgiQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECA05A84F
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6d7121ceaadso628722b3a.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915962; x=1703520762; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5r+gfDTwXG4Hr3wDcClACrvPGp96QulbR+3EJ5OBefA=;
        b=QfbvNgiQCz8xtg/zDs4vCC56dlY+UGegXqf7MeT4u9nYxEPwVpnY7e/ZrxlyEjRw0X
         cWyF3E3xQOC0sUZjKCs+mcURT6z34cn/TQgbTo+XbLczTOuWirLxp97NArbgpE5MX+Cy
         e3pp+bQac2Cw/ODQbjkLwtje33V1BaF/5xFYsobPZRquWqQ+X/W2p9191t9ogdFSD8+Z
         yj6gsAgLam0IDekwIxR9FYWldWxS6xD9ckrFD9F7qpEf8hCb2ux3YlPw0nAhoE8UzjJw
         YGpGTRK+U1xz6boJ7qXofcO3WAj8uoDUTNgp6V06rIVvGkpiVKj8qyNTbD67RwqM6KPD
         qOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915962; x=1703520762;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5r+gfDTwXG4Hr3wDcClACrvPGp96QulbR+3EJ5OBefA=;
        b=MVoxvb3JMCLE03OPMfD6Z59HqDznpv8YLzfck/R2YUDWDESeXmap4orliriWXEwgSN
         BXLi4eEH2O6NIGc4MgkBxqSq1Rm3I1VUtZFd+1kHjN3zng2mDbJsLixh3HDl7+kpn+02
         a1F7Ian89zVCFabh1eV/2yaXuFTMAzOfKNgI2E52WtyHOMtqUN4t6e++tkxBHyImTDl/
         0LZwTziaA8FHbAX2XeEDbKedtgK0Ea7RGZEDfyWjP0TWrIG6DJxm72sdXvUw6OoRSM6i
         /tCfew1b8DmxjyyPECvAYgg2geKfOwLMcZbDh/45cym2S3WuOXno0kxxjw2ve99jRrA7
         GXbQ==
X-Gm-Message-State: AOJu0YyKjmDC87DCunGJBGPNbB2uJE6xAtsT3uijXtX4TjANKjan1KEv
	EMOsLY/Ps7jbTrQxl/dbB5fyQNb9YQhn94OE7uOIfkVTz08fZe231Ebx1PE2NceUeiROE7PzeZe
	X7cNYyUzHtM0rQR43B6B5jfdBaHX95f0+PY64z4k6lZ23R6cAJuLH7/DFQA==
X-Google-Smtp-Source: AGHT+IHUr7HJPn5OG9lHgTUZeIq0OfaiOJwxlfxxIRQ/eQYumozYumkGcMzkn3JhDh3j8iGQOLFwVJ2Z1WY=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:4b0a:b0:6c0:ec5b:bb2d with SMTP id
 kq10-20020a056a004b0a00b006c0ec5bbb2dmr2808969pfb.2.1702915961923; Mon, 18
 Dec 2023 08:12:41 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:46 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-9-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 8/8] KVM: selftests: Add simple sev vm testing
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

A very simple of booting SEV guests that checks SEV related CPUID bits
and the SEV MSR.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 59 +++++++++++++++++++
 2 files changed, 60 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c932bcea4198..320d7907ed4f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -115,6 +115,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_all_boot_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
new file mode 100644
index 000000000000..b4139cf90c8e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "sev.h"
+
+static void guest_sev_code(void)
+{
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+
+	GUEST_DONE();
+}
+
+static void test_sev(void *guest_code, uint64_t policy)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int i;
+
+	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected exit: %s",
+				  exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(is_kvm_sev_supported());
+
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.43.0.472.g3155946c3a-goog



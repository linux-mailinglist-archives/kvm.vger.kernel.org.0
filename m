Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF617F345
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 10:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgCJJQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 05:16:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27251 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCJJQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 05:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0GpzjH0J1vG+qv0tZ9jxmPXYVqn/44yTp+oob9OL7A=;
        b=PDPfbfMB7W6yIqyjIGq9AsGK72KBSrdg+Up2cDG3EQbDb8i/SlpKPE39JNJ4Td95cm3ae7
        jCVd75LeMbzKyrRVVJo8BZRkGmMbaddCXVmwZm5JVjgxa7sjRRXTo2dzKaUx/Bn5xhESn4
        W3ucAAFIwgsc0/YBo/n2sgjW2yEdHDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-JZkYjd6fM8mm7mXnbt2h6A-1; Tue, 10 Mar 2020 05:16:16 -0400
X-MC-Unique: JZkYjd6fM8mm7mXnbt2h6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61E4919251A1;
        Tue, 10 Mar 2020 09:16:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81F7360C05;
        Tue, 10 Mar 2020 09:16:13 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH 4/4] KVM: selftests: Use consistent message for test skipping
Date:   Tue, 10 Mar 2020 10:15:56 +0100
Message-Id: <20200310091556.4701-5-drjones@redhat.com>
In-Reply-To: <20200310091556.4701-1-drjones@redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c     |  4 ++--
 tools/testing/selftests/kvm/dirty_log_test.c         |  3 +--
 tools/testing/selftests/kvm/include/test_util.h      |  2 ++
 tools/testing/selftests/kvm/lib/assert.c             |  6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c           |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c          | 12 ++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/svm.c         |  2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c         |  2 +-
 tools/testing/selftests/kvm/s390x/memop.c            |  2 +-
 tools/testing/selftests/kvm/s390x/sync_regs_test.c   |  2 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c       |  2 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c      |  2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c    |  6 ++----
 .../testing/selftests/kvm/x86_64/mmio_warning_test.c |  4 ++--
 .../selftests/kvm/x86_64/platform_info_test.c        |  3 +--
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c  |  4 ++--
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c |  2 +-
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c    |  2 +-
 18 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index 47654071544c..9077b5e81d10 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -664,8 +664,8 @@ int main(int argc, char *argv[])
=20
 int main(void)
 {
-        printf("skip: Skipping userfaultfd test (missing __NR_userfaultf=
d)\n");
-        return KSFT_SKIP;
+	print_skip("__NR_userfaultfd must be present for userfaultfd test");
+	return KSFT_SKIP;
 }
=20
 #endif /* __NR_userfaultfd */
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 518a94a7a8b5..a64384bb7268 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -440,8 +440,7 @@ int main(int argc, char *argv[])
 	dirty_log_manual_caps =3D
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	if (!dirty_log_manual_caps) {
-		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, "
-				"skipping tests\n");
+		print_skip("KVM_CLEAR_DIRTY_LOG not available");
 		exit(KSFT_SKIP);
 	}
 	dirty_log_manual_caps &=3D (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index 07823740227b..1e1487a30402 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -32,6 +32,8 @@ static inline int _no_printf(const char *format, ...) {=
 return 0; }
 #define pr_info(...) _no_printf(__VA_ARGS__)
 #endif
=20
+void print_skip(const char *fmt, ...) __attribute__((format(printf, 1, 2=
)));
+
 ssize_t test_write(int fd, const void *buf, size_t count);
 ssize_t test_read(int fd, void *buf, size_t count);
 int test_seq_read(const char *path, char **bufp, size_t *sizep);
diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/sel=
ftests/kvm/lib/assert.c
index d1cf9f6e0e6b..5ebbd0d6b472 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -82,8 +82,10 @@ test_assert(bool exp, const char *exp_str,
 		}
 		va_end(ap);
=20
-		if (errno =3D=3D EACCES)
-			ksft_exit_skip("Access denied - Exiting.\n");
+		if (errno =3D=3D EACCES) {
+			print_skip("Access denied - Exiting");
+			exit(KSFT_SKIP);
+		}
 		exit(254);
 	}
=20
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index b29c5d338555..aa7697212267 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -92,7 +92,7 @@ static void vm_open(struct kvm_vm *vm, int perm)
 		exit(KSFT_SKIP);
=20
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
-		fprintf(stderr, "immediate_exit not available, skipping test\n");
+		print_skip("immediate_exit not available");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
index 1c0d45afdf36..26fb3d73dc74 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <limits.h>
+#include <assert.h>
 #include "test_util.h"
=20
 /*
@@ -69,3 +70,14 @@ struct timespec timespec_diff(struct timespec start, s=
truct timespec end)
=20
 	return temp;
 }
+
+void print_skip(const char *fmt, ...)
+{
+	va_list ap;
+
+	assert(fmt);
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+	puts(", skipping test");
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing=
/selftests/kvm/lib/x86_64/svm.c
index 6e05a8fc3fe0..c42401068373 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -154,7 +154,7 @@ void nested_svm_check_supported(void)
 		kvm_get_supported_cpuid_entry(0x80000001);
=20
 	if (!(entry->ecx & CPUID_SVM)) {
-		fprintf(stderr, "nested SVM not enabled, skipping test\n");
+		print_skip("nested SVM not enabled");
 		exit(KSFT_SKIP);
 	}
 }
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing=
/selftests/kvm/lib/x86_64/vmx.c
index 7aaa99ca4dbc..ff0a657a42d3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -381,7 +381,7 @@ void nested_vmx_check_supported(void)
 	struct kvm_cpuid_entry2 *entry =3D kvm_get_supported_cpuid_entry(1);
=20
 	if (!(entry->ecx & CPUID_VMX)) {
-		fprintf(stderr, "nested VMX not enabled, skipping test\n");
+		print_skip("nested VMX not enabled");
 		exit(KSFT_SKIP);
 	}
 }
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/se=
lftests/kvm/s390x/memop.c
index 9edaa9a134ce..9f49ead380ab 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -40,7 +40,7 @@ int main(int argc, char *argv[])
=20
 	maxsize =3D kvm_check_cap(KVM_CAP_S390_MEM_OP);
 	if (!maxsize) {
-		fprintf(stderr, "CAP_S390_MEM_OP not supported -> skip test\n");
+		print_skip("CAP_S390_MEM_OP not supported");
 		exit(KSFT_SKIP);
 	}
 	if (maxsize > sizeof(mem1))
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/t=
esting/selftests/kvm/s390x/sync_regs_test.c
index b705637ca14b..14d85fb2a1d9 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -79,7 +79,7 @@ int main(int argc, char *argv[])
=20
 	cap =3D kvm_check_cap(KVM_CAP_SYNC_REGS);
 	if (!cap) {
-		fprintf(stderr, "CAP_SYNC_REGS not supported, skipping test\n");
+		print_skip("CAP_SYNC_REGS not supported");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/t=
ools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 003d1422705a..a646843137c7 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -72,7 +72,7 @@ int main(int argc, char *argv[])
=20
 	entry =3D kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
-		printf("XSAVE feature not supported, skipping test\n");
+		print_skip("XSAVE feature not supported");
 		return 0;
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/test=
ing/selftests/kvm/x86_64/evmcs_test.c
index 464a55217085..15241dc2ded0 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -87,7 +87,7 @@ int main(int argc, char *argv[])
=20
 	if (!kvm_check_cap(KVM_CAP_NESTED_STATE) ||
 	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		printf("capabilities not available, skipping test\n");
+		print_skip("capabilities not available");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/te=
sting/selftests/kvm/x86_64/hyperv_cpuid.c
index 3edf3b517f9f..83323f3d7ca0 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -141,8 +141,7 @@ int main(int argc, char *argv[])
=20
 	rv =3D kvm_check_cap(KVM_CAP_HYPERV_CPUID);
 	if (!rv) {
-		fprintf(stderr,
-			"KVM_CAP_HYPERV_CPUID not supported, skip test\n");
+		print_skip("KVM_CAP_HYPERV_CPUID not supported");
 		exit(KSFT_SKIP);
 	}
=20
@@ -160,8 +159,7 @@ int main(int argc, char *argv[])
 	free(hv_cpuid_entries);
=20
 	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		fprintf(stderr,
-			"Enlightened VMCS is unsupported, skip related test\n");
+		print_skip("Enlightened VMCS is unsupported");
 		goto vm_free;
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/too=
ls/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 5350c2d6f736..e6480fd5c4bd 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -93,12 +93,12 @@ int main(void)
 	int warnings_before, warnings_after;
=20
 	if (!is_intel_cpu()) {
-		printf("Must be run on an Intel CPU, skipping test\n");
+		print_skip("Must be run on an Intel CPU");
 		exit(KSFT_SKIP);
 	}
=20
 	if (vm_is_unrestricted_guest(NULL)) {
-		printf("Unrestricted guest must be disabled, skipping test\n");
+		print_skip("Unrestricted guest must be disabled");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/to=
ols/testing/selftests/kvm/x86_64/platform_info_test.c
index 54a960ff63aa..1e89688cbbbf 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -88,8 +88,7 @@ int main(int argc, char *argv[])
=20
 	rv =3D kvm_check_cap(KVM_CAP_MSR_PLATFORM_INFO);
 	if (!rv) {
-		fprintf(stderr,
-			"KVM_CAP_MSR_PLATFORM_INFO not supported, skip test\n");
+		print_skip("KVM_CAP_MSR_PLATFORM_INFO not supported");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/=
testing/selftests/kvm/x86_64/sync_regs_test.c
index 5c8224256294..d672f0a473f8 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -91,11 +91,11 @@ int main(int argc, char *argv[])
=20
 	cap =3D kvm_check_cap(KVM_CAP_SYNC_REGS);
 	if ((cap & TEST_SYNC_FIELDS) !=3D TEST_SYNC_FIELDS) {
-		fprintf(stderr, "KVM_CAP_SYNC_REGS not supported, skipping test\n");
+		print_skip("KVM_CAP_SYNC_REGS not supported");
 		exit(KSFT_SKIP);
 	}
 	if ((cap & INVALID_SYNC_FIELD) !=3D 0) {
-		fprintf(stderr, "The \"invalid\" field is not invalid, skipping test\n=
");
+		print_skip("The \"invalid\" field is not invalid");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test=
.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 7962f2fe575d..54cdefdfb49d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -228,7 +228,7 @@ int main(int argc, char *argv[])
 	have_evmcs =3D kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
=20
 	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-		printf("KVM_CAP_NESTED_STATE not available, skipping test\n");
+		print_skip("KVM_CAP_NESTED_STATE not available");
 		exit(KSFT_SKIP);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/te=
sting/selftests/kvm/x86_64/xss_msr_test.c
index fc8328d8d5b0..3529376747c2 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 		xss_supported =3D entry && !!(entry->eax & X86_FEATURE_XSAVES);
 	}
 	if (!xss_supported) {
-		printf("IA32_XSS is not supported by the vCPU, skipping test\n");
+		print_skip("IA32_XSS is not supported by the vCPU");
 		exit(KSFT_SKIP);
 	}
=20
--=20
2.21.1


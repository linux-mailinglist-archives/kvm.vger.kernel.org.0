Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905F815DA1C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgBNPAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 10:00:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387542AbgBNO74 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0KxW+XwgAk59rzSBbvgljy0p4HWDcvZ6TUL0JEgHZM=;
        b=bzprJV7KHgVlMwJGvGi0Zx+ZbuwnJHkMmXk7A/uH8YVP9nOGYXodTB70QMK0IHUoBkJFV4
        cZnMY0tuD9mL4DWCu3IYMhw8caamO4GmbVAtu5zKfCwoaKRjk8xbUX8jWL+yw5yE7IGTnJ
        18tz39Cw5ktxv1vjsZNgTMWgaNr2ffU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-MoXLSOL1MLqVjFkpkBrWJQ-1; Fri, 14 Feb 2020 09:59:52 -0500
X-MC-Unique: MoXLSOL1MLqVjFkpkBrWJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2656D8017CC;
        Fri, 14 Feb 2020 14:59:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7531519E9C;
        Fri, 14 Feb 2020 14:59:49 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 10/13] KVM: selftests: Convert some printf's to pr_info's
Date:   Fri, 14 Feb 2020 15:59:17 +0100
Message-Id: <20200214145920.30792-11-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We leave some printf's because they inform the user the test is being
skipped. QUIET should not disable those. We also leave the printf's
used for help text.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c       | 8 ++++----
 tools/testing/selftests/kvm/s390x/resets.c               | 6 +++---
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c   | 2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c            | 2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c          | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 4 ++--
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c        | 2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/t=
esting/selftests/kvm/kvm_create_max_vcpus.c
index 6f38c3dc0d56..0299cd81b8ba 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -24,8 +24,8 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpu=
s)
 	struct kvm_vm *vm;
 	int i;
=20
-	printf("Testing creating %d vCPUs, with IDs %d...%d.\n",
-	       num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
+	pr_info("Testing creating %d vCPUs, with IDs %d...%d.\n",
+		num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
=20
 	vm =3D vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
=20
@@ -41,8 +41,8 @@ int main(int argc, char *argv[])
 	int kvm_max_vcpu_id =3D kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
 	int kvm_max_vcpus =3D kvm_check_cap(KVM_CAP_MAX_VCPUS);
=20
-	printf("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
-	printf("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
+	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
+	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
=20
 	/*
 	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/s=
elftests/kvm/s390x/resets.c
index 1485bc6c8999..c59db2c95e9e 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -134,7 +134,7 @@ static void inject_irq(int cpu_id)
=20
 static void test_normal(void)
 {
-	printf("Testing normal reset\n");
+	pr_info("Testing normal reset\n");
 	/* Create VM */
 	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run =3D vcpu_state(vm, VCPU_ID);
@@ -151,7 +151,7 @@ static void test_normal(void)
=20
 static void test_initial(void)
 {
-	printf("Testing initial reset\n");
+	pr_info("Testing initial reset\n");
 	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run =3D vcpu_state(vm, VCPU_ID);
 	regs =3D &run->s.regs;
@@ -168,7 +168,7 @@ static void test_initial(void)
=20
 static void test_clear(void)
 {
-	printf("Testing clear reset\n");
+	pr_info("Testing clear reset\n");
 	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run =3D vcpu_state(vm, VCPU_ID);
 	regs =3D &run->s.regs;
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/too=
ls/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 00bb97d76000..5350c2d6f736 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -44,7 +44,7 @@ void *thr(void *arg)
 	struct kvm_run *run =3D tc->run;
=20
 	res =3D ioctl(kvmcpu, KVM_RUN, 0);
-	printf("ret1=3D%d exit_reason=3D%d suberror=3D%d\n",
+	pr_info("ret1=3D%d exit_reason=3D%d suberror=3D%d\n",
 		res, run->exit_reason, run->internal.suberror);
=20
 	return 0;
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testin=
g/selftests/kvm/x86_64/smm_test.c
index 8c063646f2a0..8230b6bc6b8f 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -117,7 +117,7 @@ int main(int argc, char *argv[])
 		vcpu_alloc_vmx(vm, &vmx_pages_gva);
 		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 	} else {
-		printf("will skip SMM test with VMX enabled\n");
+		pr_info("will skip SMM test with VMX enabled\n");
 		vcpu_args_set(vm, VCPU_ID, 1, 0);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/test=
ing/selftests/kvm/x86_64/state_test.c
index 3ab5ec3da9f4..9d2daffd6110 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -139,7 +139,7 @@ int main(int argc, char *argv[])
 		vcpu_alloc_vmx(vm, &vmx_pages_gva);
 		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 	} else {
-		printf("will skip nested state checks\n");
+		pr_info("will skip nested state checks\n");
 		vcpu_args_set(vm, VCPU_ID, 1, 0);
 	}
=20
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/t=
ools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 69e482a95c47..64f7cb81f28d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -121,8 +121,8 @@ static void l1_guest_code(struct vmx_pages *vmx_pages=
)
=20
 static void report(int64_t val)
 {
-	printf("IA32_TSC_ADJUST is %ld (%lld * TSC_ADJUST_VALUE + %lld).\n",
-	       val, val / TSC_ADJUST_VALUE, val % TSC_ADJUST_VALUE);
+	pr_info("IA32_TSC_ADJUST is %ld (%lld * TSC_ADJUST_VALUE + %lld).\n",
+		val, val / TSC_ADJUST_VALUE, val % TSC_ADJUST_VALUE);
 }
=20
 int main(int argc, char *argv[])
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/te=
sting/selftests/kvm/x86_64/xss_msr_test.c
index 851ea81b9d9f..fc8328d8d5b0 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 		xss_supported =3D entry && !!(entry->eax & X86_FEATURE_XSAVES);
 	}
 	if (!xss_supported) {
-		printf("IA32_XSS is not supported by the vCPU.\n");
+		printf("IA32_XSS is not supported by the vCPU, skipping test\n");
 		exit(KSFT_SKIP);
 	}
=20
--=20
2.21.1


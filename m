Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1D148B59
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 16:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbgAXPhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 10:37:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388032AbgAXPhi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 10:37:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579880257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rpZ++MDPOSxZpfy4GT1pitwnqPRZR+669baPTdD1JM4=;
        b=etDB1g54vJAtPnp/drVjED159sE23iycfLOYGkuSG0nVdL5CNsQ1v9iqQblZh28pRDJuLP
        X6f9oWLSTxpUAxAgwmS3PKqLN1emGhdrhybBviGRxJQ6Ja0O5HRuU0XuwWsE0kj54MJOsM
        bNJ48FSHfZRX/QYzRrAn6J3cKV+3GfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-_RcTjyyxNDSis0HLv02XpA-1; Fri, 24 Jan 2020 10:37:35 -0500
X-MC-Unique: _RcTjyyxNDSis0HLv02XpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 901C790BE46
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 15:37:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8BAD100EA05;
        Fri, 24 Jan 2020 15:37:30 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/2] KVM: selftests: Convert some printf's to pr_info's
Date:   Fri, 24 Jan 2020 16:37:26 +0100
Message-Id: <20200124153726.15455-3-drjones@redhat.com>
In-Reply-To: <20200124153726.15455-1-drjones@redhat.com>
References: <20200124153726.15455-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We leave some printf's because they inform the user the test is being
skipped. QUIET shouldn't disable those. We also leave the printf's
in "dump" calls used for debug and in help text.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c       | 8 ++++----
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c   | 2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c            | 2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c          | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 4 ++--
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c        | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

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
index 5590fd2bcf87..f56c45824653 100644
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


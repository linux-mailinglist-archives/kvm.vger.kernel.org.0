Return-Path: <kvm+bounces-3493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C2D80509A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25869B20DF0
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6E25C90B;
	Tue,  5 Dec 2023 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lz2RE+cT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5666318F
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3Jm9wOI3aEYajV3fya67MUpt9R8ccLnW+4cSRJuTzU=;
	b=Lz2RE+cTvXWcw702RdkFqOYuIMkZmkB2zGC6sxNB/5/eyv/NSAeSIbRSHu123g6T9Itfvc
	eHauxP+j4tjApC0slQ2EAKA0RqxD3DdD/YB9G7dQf+mgEFITLhVlPuUg9COdwTGd1Q3fLt
	h5wiNunptvKpYr0FTqZXsMa0ppu48SU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-aUn60SuhNfqCI6C-By7YVw-1; Tue,
 05 Dec 2023 05:36:42 -0500
X-MC-Unique: aUn60SuhNfqCI6C-By7YVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBDD21C0690A;
	Tue,  5 Dec 2023 10:36:41 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 283472026D66;
	Tue,  5 Dec 2023 10:36:41 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 09/16] KVM: selftests: Make all Hyper-V tests explicitly dependent on Hyper-V emulation support in KVM
Date: Tue,  5 Dec 2023 11:36:23 +0100
Message-ID: <20231205103630.1391318-10-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

In preparation for conditional Hyper-V emulation enablement in KVM, make
Hyper-V specific tests check skip gracefully instead of failing when the
support is not there.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c            | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c            | 5 +++--
 .../selftests/kvm/x86_64/hyperv_extended_hypercalls.c        | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_features.c         | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c              | 2 ++
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c         | 1 +
 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c        | 2 ++
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index f25749eaa6a8..f5e1e98f04f9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -211,6 +211,8 @@ int main(void)
 	vm_vaddr_t tsc_page_gva;
 	int stage;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TIME));
+
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index 7bde0c4dfdbd..4c7257ecd2a6 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -240,11 +240,12 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	hcall_page = vm_vaddr_alloc_pages(vm, 1);
 	memset(addr_gva2hva(vm, hcall_page), 0x0,  getpagesize());
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
index e036db1f32b9..949e08e98f31 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
@@ -43,6 +43,8 @@ int main(void)
 	uint64_t *outval;
 	struct ucall uc;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
+
 	/* Verify if extended hypercalls are supported */
 	if (!kvm_cpuid_has(kvm_get_supported_hv_cpuid(),
 			   HV_ENABLE_EXTENDED_HYPERCALLS)) {
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 9f28aa276c4e..387c605a3077 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -690,6 +690,8 @@ static void guest_test_hcalls_access(void)
 
 int main(void)
 {
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENFORCE_CPUID));
+
 	pr_info("Testing access to Hyper-V specific MSRs\n");
 	guest_test_msrs_access();
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
index 6feb5ddb031d..65e5f4c05068 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -248,6 +248,8 @@ int main(int argc, char *argv[])
 	int stage = 1, r;
 	struct ucall uc;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_SEND_IPI));
+
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Hypercall input/output */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 6c1278562090..c9b18707edc0 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -158,6 +158,7 @@ int main(int argc, char *argv[])
 	int stage;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_DIRECT_TLBFLUSH));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 4758b6ef5618..c4443f71f8dd 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -590,6 +590,8 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage = 1, r, i;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TLBFLUSH));
+
 	vm = vm_create_with_one_vcpu(&vcpu[0], sender_guest_code);
 
 	/* Test data page */
-- 
2.43.0



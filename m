Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2C190872
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCXJFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:05:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54203 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbgCXJFu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 05:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585040748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LLJDKnz60hQ/rtR0UzkHHM3ofuTozwYEgaLts68tRKE=;
        b=Qcg14M4BJeLITnGcXn6jcmrbluSYT3KrW/64067l5UQOAk5iXQgUIj4T78rTKOPAaz3Xtd
        MoKib34K9OBECjYfeM/T80hv9k7pWEgmmvc5k7MhWDcVkqUcBo6xEii5MNuLkgQU+hCS6a
        M/fc05BOPlG3vvZXklOBIUpKsIqRYeQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-Pq-QyWs1NcmokmGWNisohg-1; Tue, 24 Mar 2020 05:05:45 -0400
X-MC-Unique: Pq-QyWs1NcmokmGWNisohg-1
Received: by mail-wr1-f71.google.com with SMTP id v6so8827029wrg.22
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 02:05:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LLJDKnz60hQ/rtR0UzkHHM3ofuTozwYEgaLts68tRKE=;
        b=d8nCBeKsRoa70DXCN+S3iRW/uslLH18gS662wTYO24s/wDJYWnWjD/6CcP70WLVKdk
         8oaEThFOxr3pPTngicpk+hVq0QlZhmBlq9WsN7wbQTtwq8s0qC2yznkBWK0irT4IrkqT
         A32YuD3vI+tDvbZ7tyCA+08RxS0Z2TCovLzhRO3RbRAWuk14JTVppQEiVUMik0XriM4k
         xw5E+2bGXTkaH1wtkyY4kywPquf3kcqQ5mO0prvwZV9PfAkLe33GalOZ2Vj8UZ+PbAPS
         W9UC/pmzNzx76Iz6hAGlaAfsyIrX1Jx1OVvM44FGc0J+KH+9d+hZ9XySPHqKJo0tfBLL
         726A==
X-Gm-Message-State: ANhLgQ2hYBzYBnvtzdEuzeiofybNwgjF28V70mPSIqeCaScytQNqpRqz
        OIUVdHmZC+7KjperY3afdwkkyAnab48jd5Ilmk/9pGOiMy3W5j96Vvlp44Y2NUMQ01tNtj/hE19
        Rvy/SG/0QWH3X
X-Received: by 2002:a1c:4645:: with SMTP id t66mr4493738wma.6.1585040744931;
        Tue, 24 Mar 2020 02:05:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtBlDagAsqeiIsI/mF7Dewgq14pztAh12G/i3D/M5Dw21WSc+D1tgf66xNIATRVwxHXNfkBZA==
X-Received: by 2002:a1c:4645:: with SMTP id t66mr4493715wma.6.1585040744669;
        Tue, 24 Mar 2020 02:05:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w7sm28772515wrr.60.2020.03.24.02.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 02:05:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v10 7/7] KVM: selftests: update hyperv_cpuid with SynDBG tests
In-Reply-To: <20200324074341.1770081-8-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com> <20200324074341.1770081-8-arilou@gmail.com>
Date:   Tue, 24 Mar 2020 10:05:42 +0100
Message-ID: <87d09286mx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Jon Doron <arilou@gmail.com> writes:

> From: Vitaly Kuznetsov <vkuznets () redhat ! com>
>
> Test all four combinations with eVMCS and SynDBG capabilities,
> check that we get the right number of entries and that
> 0x40000000.EAX always returns the correct max leaf.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Something weird happened to this patch. It fails to apply on kvm/queue
but it's also a bit different from what I've sent yesterday. I fixed and
tested it, please find the result attached.

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-selftests-update-hyperv_cpuid-with-SynDBG-tests.patch

From ae2c688389c20a99d7457861e57ce97054780908 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets () redhat ! com>
Date: Tue, 24 Mar 2020 09:43:41 +0200
Subject: [PATCH v10 7/7 FIXED] KVM: selftests: update hyperv_cpuid with SynDBG
 tests

Test all four combinations with eVMCS and SynDBG capabilities,
check that we get the right number of entries and that
0x40000000.EAX always returns the correct max leaf.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 143 ++++++++++++------
 1 file changed, 95 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 83323f3d7ca0..5268abf9ad80 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -26,18 +26,18 @@ static void guest_code(void)
 {
 }
 
-static int smt_possible(void)
+static bool smt_possible(void)
 {
 	char buf[16];
 	FILE *f;
-	bool res = 1;
+	bool res = true;
 
 	f = fopen("/sys/devices/system/cpu/smt/control", "r");
 	if (f) {
 		if (fread(buf, sizeof(*buf), sizeof(buf), f) > 0) {
 			if (!strncmp(buf, "forceoff", 8) ||
 			    !strncmp(buf, "notsupported", 12))
-				res = 0;
+				res = false;
 		}
 		fclose(f);
 	}
@@ -45,30 +45,48 @@ static int smt_possible(void)
 	return res;
 }
 
+void vcpu_enable_syndbg(struct kvm_vm *vm, int vcpu_id)
+{
+	struct kvm_enable_cap enable_syndbg_cap = {
+		.cap = KVM_CAP_HYPERV_SYNDBG,
+	};
+
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_syndbg_cap);
+}
+
 static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
-			  int evmcs_enabled)
+			  bool evmcs_enabled, bool syndbg_enabled)
 {
 	int i;
+	int nent = 6;
+	u32 test_val;
+
+	if (evmcs_enabled)
+		nent += 1; /* 0x4000000A */
 
-	if (!evmcs_enabled)
-		TEST_ASSERT(hv_cpuid_entries->nent == 6,
-			    "KVM_GET_SUPPORTED_HV_CPUID should return 6 entries"
-			    " when Enlightened VMCS is disabled (returned %d)",
-			    hv_cpuid_entries->nent);
-	else
-		TEST_ASSERT(hv_cpuid_entries->nent == 7,
-			    "KVM_GET_SUPPORTED_HV_CPUID should return 7 entries"
-			    " when Enlightened VMCS is enabled (returned %d)",
-			    hv_cpuid_entries->nent);
+	if (syndbg_enabled)
+		nent += 3; /* 0x40000080 - 0x40000082 */
+
+	TEST_ASSERT(hv_cpuid_entries->nent == nent,
+		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
+		    " with evmcs=%d syndbg=%d (returned %d)",
+		    nent, evmcs_enabled, syndbg_enabled,
+		    hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
 
 		TEST_ASSERT((entry->function >= 0x40000000) &&
-			    (entry->function <= 0x4000000A),
+			    (entry->function <= 0x40000082),
 			    "function %x is our of supported range",
 			    entry->function);
 
+		TEST_ASSERT(evmcs_enabled || (entry->function != 0x4000000A),
+			    "0x4000000A leaf should not be reported");
+
+		TEST_ASSERT(syndbg_enabled || (entry->function <= 0x4000000A),
+			    "SYNDBG leaves should not be reported");
+
 		TEST_ASSERT(entry->index == 0,
 			    ".index field should be zero");
 
@@ -78,12 +96,27 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
 			    !entry->padding[2], "padding should be zero");
 
-		if (entry->function == 0x40000004) {
-			int nononarchcs = !!(entry->eax & (1UL << 18));
-
-			TEST_ASSERT(nononarchcs == !smt_possible(),
+		switch (entry->function) {
+		case 0x40000000:
+			test_val = 0x40000005;
+			if (evmcs_enabled)
+				test_val = 0x4000000A;
+			if (syndbg_enabled)
+				test_val = 0x40000082;
+
+			TEST_ASSERT(entry->eax == test_val,
+				    "Wrong max leaf report in 0x40000000.EAX: %x"
+				    " (evmcs=%d syndbg=%d)",
+				    entry->eax, evmcs_enabled, syndbg_enabled
+				);
+			break;
+		case 0x40000004:
+			test_val = entry->eax & (1UL << 18);
+
+			TEST_ASSERT(!!test_val == !smt_possible(),
 				    "NoNonArchitecturalCoreSharing bit"
 				    " doesn't reflect SMT setting");
+			break;
 		}
 
 		/*
@@ -133,8 +166,9 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	int rv;
+	int rv, stage;
 	struct kvm_cpuid2 *hv_cpuid_entries;
+	bool evmcs_enabled, syndbg_enabled;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -145,36 +179,49 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-
-	test_hv_cpuid_e2big(vm);
-
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-	if (!hv_cpuid_entries)
-		return 1;
-
-	test_hv_cpuid(hv_cpuid_entries, 0);
-
-	free(hv_cpuid_entries);
+	for (stage = 0; stage < 5; stage++) {
+		evmcs_enabled = false;
+		syndbg_enabled = false;
+
+		vm = vm_create_default(VCPU_ID, 0, guest_code);
+		switch (stage) {
+		case 0:
+			test_hv_cpuid_e2big(vm);
+			continue;
+		case 1:
+			break;
+		case 2:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+				print_skip("Enlightened VMCS is unsupported");
+				continue;
+			}
+			vcpu_enable_evmcs(vm, VCPU_ID);
+			evmcs_enabled = true;
+			break;
+		case 3:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_SYNDBG)) {
+				print_skip("Synthetic debugger is unsupported");
+				continue;
+			}
+			vcpu_enable_syndbg(vm, VCPU_ID);
+			syndbg_enabled = true;
+			break;
+		case 4:
+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS) ||
+			    !kvm_check_cap(KVM_CAP_HYPERV_SYNDBG))
+				continue;
+			vcpu_enable_evmcs(vm, VCPU_ID);
+			vcpu_enable_syndbg(vm, VCPU_ID);
+			evmcs_enabled = true;
+			syndbg_enabled = true;
+			break;
+		}
 
-	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		print_skip("Enlightened VMCS is unsupported");
-		goto vm_free;
+		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
+		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled, syndbg_enabled);
+		free(hv_cpuid_entries);
+		kvm_vm_free(vm);
 	}
 
-	vcpu_enable_evmcs(vm, VCPU_ID);
-
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-	if (!hv_cpuid_entries)
-		return 1;
-
-	test_hv_cpuid(hv_cpuid_entries, 1);
-
-	free(hv_cpuid_entries);
-
-vm_free:
-	kvm_vm_free(vm);
-
 	return 0;
 }
-- 
2.25.1


--=-=-=--


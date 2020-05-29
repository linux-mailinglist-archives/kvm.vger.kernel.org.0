Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253B41E7F1D
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgE2NqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgE2NqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8368AC03E969;
        Fri, 29 May 2020 06:46:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c3so3615072wru.12;
        Fri, 29 May 2020 06:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CRfyzalkQGPRIJenwdlYo1bAXA5Z5I+yDJzGJeC0D90=;
        b=MXuZJPOV/iVCQa9nAp8mC/uuthnkol/KQBetYfpBArZo1btdaba7LLTTA2EI/LZa3r
         tQKvbVL+3NKBBOlwnXUCONPEt1OX7SytpTtF3JM7QDCsPPX2BTySiy3KQ6SnJexYiCXQ
         a4VP4K9u7WFm5/tlAP2dDbmIOXqteHj/W8uUWoHtdgH0cw8PfIEKOLUJqe3In5GN6Mv9
         NFcz0nEy3XMti1wDWnOzjTXidC/C6JBnd5Lm8pb4zt7JvNu5Re1nr3rYVo6EFnEsU/HV
         8n5wtJBqzjkT3AGy1wJZchyw+ocTizYHx/lpfzZrXHKUS/pMcH4ohbVF16+acNTBf/8o
         5T7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRfyzalkQGPRIJenwdlYo1bAXA5Z5I+yDJzGJeC0D90=;
        b=Gr9qbEMwma3GvcF0whEIadHdZOvJCWVgpbS/mUuMbezZL5fSytSBz2j0S6t6T8HEK/
         bpo1M9BvJJr4N+MDSTlETFoUSay4m0zxPOjIYnCdsmk+ivnj46k9woy8vkhVZDxdsxp8
         u++JW/Skg/EveNlHwUD9L5e1/MBi6pRLvk8Se1RftkfUx0IKK6jmpNQ3XKJuxhVTisdC
         60wtJhI0jLK/wQq+xT/gW5yuXRAK4BjHicGo8uWpGTOKzLPEWB4bEFeSVLVhF5rsLP56
         TrlP4u22XosQ6sLaJoU8VnU+LXT70f3o7ofR3vAEvZjdMGfO9m1+iHl1lUwUEmO/vVtF
         C3Tw==
X-Gm-Message-State: AOAM532G6yrhxIPCWKj7lf4gM3zEYonz8d+W2iFxd6+S7TinfUn1IN1v
        OC/TS150rdg/cQx4zNda4fOJ7pMM
X-Google-Smtp-Source: ABdhPJwVc+Sx7yrs9LgiWwmssibea/sNFRd08M7kpxU/kaEUcEdjlVc4H4JV/SLTxIRJ+UVLT7thaQ==
X-Received: by 2002:a05:6000:1042:: with SMTP id c2mr9458225wrx.351.1590759964039;
        Fri, 29 May 2020 06:46:04 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:46:03 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v12 6/6] KVM: selftests: update hyperv_cpuid with SynDBG tests
Date:   Fri, 29 May 2020 16:45:43 +0300
Message-Id: <20200529134543.1127440-7-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Update tests to reflect new CPUID capabilities with SYNDBG.
Check that we get the right number of entries and that
0x40000000.EAX always returns the correct max leaf.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 103 ++++++++++--------
 1 file changed, 56 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 83323f3d7ca0..4a7967cca281 100644
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
@@ -46,29 +46,31 @@ static int smt_possible(void)
 }
 
 static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
-			  int evmcs_enabled)
+			  bool evmcs_enabled)
 {
 	int i;
+	int nent = 9;
+	u32 test_val;
 
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
+	if (evmcs_enabled)
+		nent += 1; /* 0x4000000A */
+
+	TEST_ASSERT(hv_cpuid_entries->nent == nent,
+		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
+		    " with evmcs=%d (returned %d)",
+		    nent, evmcs_enabled, hv_cpuid_entries->nent);
 
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
 		TEST_ASSERT(entry->index == 0,
 			    ".index field should be zero");
 
@@ -78,12 +80,23 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
 			    !entry->padding[2], "padding should be zero");
 
-		if (entry->function == 0x40000004) {
-			int nononarchcs = !!(entry->eax & (1UL << 18));
+		switch (entry->function) {
+		case 0x40000000:
+			test_val = 0x40000082;
 
-			TEST_ASSERT(nononarchcs == !smt_possible(),
+			TEST_ASSERT(entry->eax == test_val,
+				    "Wrong max leaf report in 0x40000000.EAX: %x"
+				    " (evmcs=%d)",
+				    entry->eax, evmcs_enabled
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
@@ -133,8 +146,9 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	int rv;
+	int rv, stage;
 	struct kvm_cpuid2 *hv_cpuid_entries;
+	bool evmcs_enabled;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -145,36 +159,31 @@ int main(int argc, char *argv[])
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
+	for (stage = 0; stage < 3; stage++) {
+		evmcs_enabled = false;
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
+		}
 
-	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		print_skip("Enlightened VMCS is unsupported");
-		goto vm_free;
+		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
+		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled);
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
2.24.1


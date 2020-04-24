Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEBF1B7344
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgDXLiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXLiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02494C09B045;
        Fri, 24 Apr 2020 04:38:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so9643017wrt.5;
        Fri, 24 Apr 2020 04:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=81HV7LsCw4SH8jFyAVMERWB026fgTjwPKbEnYETv7cQ=;
        b=P8RBtkSAXYfrYD3TwzDxyVJmoS3UpVjIAi2gd+eFqBBVMAbUUOsWgePjgkIw84jNY9
         tF1zd5DgR3FQUOZ1eNNJmW8LwB8KGa+ESbFvD6sXrNBGeLhBRGVN/GH7VVLlU8gDBkRB
         FlvzJEzUzPp8myURV6IHav/d56Yqbl+pmnUzXrLgFLt7bBbL02DglqXctK9nKle5gY3d
         NNhxZWBTXWlGn0d1sebXNpw3XaUrljCJuS81HElmgYTkATfbzF7vqMmmay2B78bUvl7q
         Gdxrf/W2N4guctfO/wSASpgzP7EvnUSNkbGUBPZbxXq7JEZLtSIrVOTqSra+bHW6jeqj
         dyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=81HV7LsCw4SH8jFyAVMERWB026fgTjwPKbEnYETv7cQ=;
        b=lhbyuoVyO9Hu4KOWIrzF0YfZfCg+pwsyb4MrI5A+bgSkLVaxPV0z8dMx6piZo4mK+J
         Li6id35dD/k+G9uKK4LbkaHZfC9c65wG8d64uEvFHwiylbEFYznmueTnRFR4njjmtmRV
         G8Lu2WIoQjUwN70JzgnwrAXrOBc4byGNvLaktEOpeFmICbTaLELfwsCfYDnhsKi5AOc1
         1emhXSZVsfDBFH3Fps/mAmRFM+lJaF73/em9KMiZUdxCPdqvA8j2kANPiqLVqSFfPJ1h
         ExsmH9/DqrKgVfRy/+GojjA3MZWs+pWqyc6t27qdeUseVDbPI0nbdS9w9/0Gwbnhic12
         DzZw==
X-Gm-Message-State: AGi0PuYkGtvzXdrxWvqEufoOTvsN9RTYLWPWZcV1sdfwOMQ2fqHbJPG2
        eqyFUn3/y3QRE/P8DWSMVIFdf8YcuJk=
X-Google-Smtp-Source: APiQypI1GQD90DofoSOXy81sEGlRcRsnCGuV73CWIJevB8bqFi+FWn1FPaZXgioaDv9CufdNRtEq8g==
X-Received: by 2002:adf:e711:: with SMTP id c17mr11011226wrm.334.1587728291521;
        Fri, 24 Apr 2020 04:38:11 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:11 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH v11 7/7] KVM: selftests: update hyperv_cpuid with SynDBG tests
Date:   Fri, 24 Apr 2020 14:37:46 +0300
Message-Id: <20200424113746.3473563-8-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
2.24.1


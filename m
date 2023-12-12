Return-Path: <kvm+bounces-4255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD0D80F84C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35ECD1F214CC
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428C964CD9;
	Tue, 12 Dec 2023 20:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NnfZGkQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16241996
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:37 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-288817e5d6cso3810024a91.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414055; x=1703018855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBiOJZf7KtnyH3BNNYJPAadRM1tNvWRCeEycOvMN+pU=;
        b=NnfZGkQ2apcvX/2Rd3wgDpv90mk+ufZQ8ErQE1WRuNh7O7FOHKDouuaO8Y0HEb13nC
         8J7M1U2ShFpL3tkcbujZmF66Ydy/6+t2NxmnLxtc/GQE2AaewNFpqTQWZK2pBZLSK8Ex
         hcTeeyQ/XbJSUYO1UHpe4phyzaFKjz3vrCx/OJYjxSZ2/Rbkma+CQazO4a6Sf9WDxUHj
         4trDNFvTQhAjwPZ4he6tN5JhCT/9DuvijaPfNmOIqe/wRs9tGdaaTgDZSg5gAFQ0SGpf
         UyOJwUbyNgaBlzc+ztHy/2O1RqYXHd6ij9cCKR5eYI3KlkiKGR79SG6uXEPR9OIz2E6n
         85aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414055; x=1703018855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBiOJZf7KtnyH3BNNYJPAadRM1tNvWRCeEycOvMN+pU=;
        b=JsHyb5scCJmKhx62ScUpawynrYgdPU0ChnI8Q633fbbxCijjDJMR7P0IGeFpUURuwT
         InPMTzdZ77CDcpcbvAM/vTVdM0qYIJbdMFKqC2/z4WBkXRfz+sRFpdqmj0PF4Ug1eOMP
         cEhyCvubAlwCQ+bRfHOvIgLynVbaD6qdbYTMeguMQorWCdi9MV7vBZxdBVf4kcW/6g0e
         Q2Kf4CPfkQMZcImNQRiUvFt56KHNqWlUReCsgmTphI1eNJGunYGc4VwD4oKxjibq6xpk
         2qF+tAEp3NE4rdVN1NQMyz3tXUT+aQ0KxLonDzuSsRAXYpdANjlHBEsdIfbnz31ZQAF3
         ITDA==
X-Gm-Message-State: AOJu0YxZ0piUGOGhYZXh+gBH3dA+i7CfUzC6iBGjD7HDPNpG2QrIQRPl
	i0PHv9s4uYkBs45sq8/2/iWHM3h36g==
X-Google-Smtp-Source: AGHT+IF9mFDmE+EjddG5s/SyOCpTwUm15KmEORbZmtsVTD+OTDrv2Qk/i5lTzBYVQ+p74U2xuSBWL1QG8w==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:902:cec5:b0:1d2:f388:6def with SMTP id
 d5-20020a170902cec500b001d2f3886defmr52709plg.10.1702414055001; Tue, 12 Dec
 2023 12:47:35 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:35 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-21-sagis@google.com>
Subject: [RFC PATCH v5 20/29] KVM: selftests: TDX: Verify the behavior when
 host consumes a TD private memory
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

From: Ryan Afranji <afranji@google.com>

The test checks that host can only read fixed values when trying to
access the guest's private memory.

Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index 6935604d768b..c977223ff871 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -1062,6 +1062,90 @@ void verify_td_cpuid_tdcall(void)
 	printf("\t ... PASSED\n");
 }
 
+/*
+ * Shared variables between guest and host for host reading private mem test
+ */
+static uint64_t tdx_test_host_read_private_mem_addr;
+#define TDX_HOST_READ_PRIVATE_MEM_PORT_TEST 0x53
+
+void guest_host_read_priv_mem(void)
+{
+	uint64_t ret;
+	uint64_t placeholder = 0;
+
+	/* Set value */
+	*((uint32_t *) tdx_test_host_read_private_mem_addr) = 0xABCD;
+
+	/* Exit so host can read value */
+	ret = tdg_vp_vmcall_instruction_io(
+		TDX_HOST_READ_PRIVATE_MEM_PORT_TEST, 4,
+		TDG_VP_VMCALL_INSTRUCTION_IO_WRITE, &placeholder);
+	if (ret)
+		tdx_test_fatal(ret);
+
+	/* Update guest_var's value and have host reread it. */
+	*((uint32_t *) tdx_test_host_read_private_mem_addr) = 0xFEDC;
+
+	tdx_test_success();
+}
+
+void verify_host_reading_private_mem(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm_vaddr_t test_page;
+	uint64_t *host_virt;
+	uint64_t first_host_read;
+	uint64_t second_host_read;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_host_read_priv_mem);
+
+	test_page = vm_vaddr_alloc_page(vm);
+	TEST_ASSERT(test_page < BIT_ULL(32),
+		"Test address should fit in 32 bits so it can be sent to the guest");
+
+	host_virt = addr_gva2hva(vm, test_page);
+	TEST_ASSERT(host_virt != NULL,
+		"Guest address not found in guest memory regions\n");
+
+	tdx_test_host_read_private_mem_addr = test_page;
+	sync_global_to_guest(vm, tdx_test_host_read_private_mem_addr);
+
+	td_finalize(vm);
+
+	printf("Verifying host's behavior when reading TD private memory:\n");
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_HOST_READ_PRIVATE_MEM_PORT_TEST,
+		4, TDG_VP_VMCALL_INSTRUCTION_IO_WRITE);
+	printf("\t ... Guest's variable contains 0xABCD\n");
+
+	/* Host reads guest's variable. */
+	first_host_read = *host_virt;
+	printf("\t ... Host's read attempt value: %lu\n", first_host_read);
+
+	/* Guest updates variable and host rereads it. */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	printf("\t ... Guest's variable updated to 0xFEDC\n");
+
+	second_host_read = *host_virt;
+	printf("\t ... Host's second read attempt value: %lu\n",
+		second_host_read);
+
+	TEST_ASSERT(first_host_read == second_host_read,
+		"Host did not read a fixed pattern\n");
+
+	printf("\t ... Fixed pattern was returned to the host\n");
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	setbuf(stdout, NULL);
@@ -1084,6 +1168,7 @@ int main(int argc, char **argv)
 	run_in_new_process(&verify_mmio_reads);
 	run_in_new_process(&verify_mmio_writes);
 	run_in_new_process(&verify_td_cpuid_tdcall);
+	run_in_new_process(&verify_host_reading_private_mem);
 
 	return 0;
 }
-- 
2.43.0.472.g3155946c3a-goog



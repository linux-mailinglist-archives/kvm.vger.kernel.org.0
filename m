Return-Path: <kvm+bounces-4249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 477AB80F83A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 024BF282CFD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FE065A78;
	Tue, 12 Dec 2023 20:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xEsg+Ocr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACC1BD
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:24 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d09caea9e3so39776675ad.1
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414044; x=1703018844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pOWQKACugG9g7cz1/AmBUQwWqXmyF/X6aVaYz3Y0fys=;
        b=xEsg+OcraIn1wXFiLbdcLlsvoQ7XrcnNSRujN/AX1yG2NSZwu0+sr2Ac3X6shM3EAg
         bl+rVA1HYCsXgLW2NxMMZ55Zo44UY/WcF7kMR9cGIL7NDf7/4dwfR1+ZH/m7WrVPyUaS
         voknZB+KcKzc21caD9XiY6nTY/iZFNWp/mySUHkSPZpvYOP4tPCPTyA4fY4XELLwjj4g
         /tC6TdM05yTeNd/Jujgq0g/v9lmbpd+/l8yHmyJxLcUY9TZ4JZo0OzbU7EmQM0iky9jh
         uSzsyYQxbQVazo21s5rstc1zQQcijjLX9HlP2kz5FRpkZa2iCzqT8N84TmjYCNJn5SGV
         qGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414044; x=1703018844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOWQKACugG9g7cz1/AmBUQwWqXmyF/X6aVaYz3Y0fys=;
        b=t3N8Z2Gl5gMG3F+yBNc0YriNv7t2r9G+enUknqxl/GuRsuykXOR/UKw8Tedi9K8/wr
         ZrbLscorH/700s+v88qPkdvrZ8wugBo/KdTMRC/N98x8K0IJUfp/s0JYECNZXh3QDurJ
         +az4Nl+MxlO56kNSzFlrUY8SfR0SujAXzUzWmiBUL1v8HC7O/AV2+/BqRh88S9sXvsEw
         hZYkq5QYY8lWRg4zf1kB3cfeeFoMBAtXSaWCPSAsd/6NN7DcGq84NihyFKoFsARJ8TWh
         LtvHdmVI4KjJffYKE7U6ai7Mp7Rwycsny8WZDyWZw72Sev75G6q/MMJ8k5a3LvDFgPmr
         VPgA==
X-Gm-Message-State: AOJu0YwXeNl5hKMApr5A2FDYK0LTUMuVJueYbawtOaA2GnDfRJHii+to
	lY61cryGHX3s+THmRNRWgb8IZU9SHw==
X-Google-Smtp-Source: AGHT+IGLlrmxTENwZC6SGbM6jr4r7WDmCiJAWrdAa/8w6lr8saM6Dsnuvy2FguUg9MN6N/MAkqVuDY/IjA==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:903:32cb:b0:1d0:c3e7:d4c with SMTP id
 i11-20020a17090332cb00b001d0c3e70d4cmr53041plr.2.1702414044401; Tue, 12 Dec
 2023 12:47:24 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:29 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-15-sagis@google.com>
Subject: [RFC PATCH v5 14/29] KVM: selftests: TDX: Add TDX IO reads test
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

The test verifies IO reads of various sizes from the host to the guest.

Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index a2b3e1aef151..699cba36e9ce 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -429,6 +429,92 @@ void verify_guest_writes(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_IO_READS_TEST_PORT 0x52
+
+/*
+ * Verifies IO functionality by reading values of different sizes
+ * from the host.
+ */
+void guest_io_reads(void)
+{
+	uint64_t data;
+	uint64_t ret;
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 1,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xAB)
+		tdx_test_fatal(1);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 2,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xABCD)
+		tdx_test_fatal(2);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 4,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xFFABCDEF)
+		tdx_test_fatal(4);
+
+	// Read an invalid number of bytes.
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 5,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+
+	tdx_test_success();
+}
+
+void verify_guest_reads(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_io_reads);
+	td_finalize(vm);
+
+	printf("Verifying guest reads:\n");
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 1,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint8_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xAB;
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 2,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint16_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xABCD;
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 4,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xFFABCDEF;
+
+	td_vcpu_run(vcpu);
+	TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(vcpu->run->system_event.data[1], TDG_VP_VMCALL_INVALID_OPERAND);
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_ASSERT_SUCCESS(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	setbuf(stdout, NULL);
@@ -444,6 +530,7 @@ int main(int argc, char **argv)
 	run_in_new_process(&verify_td_cpuid);
 	run_in_new_process(&verify_get_td_vmcall_info);
 	run_in_new_process(&verify_guest_writes);
+	run_in_new_process(&verify_guest_reads);
 
 	return 0;
 }
-- 
2.43.0.472.g3155946c3a-goog



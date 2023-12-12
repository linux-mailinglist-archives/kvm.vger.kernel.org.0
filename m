Return-Path: <kvm+bounces-4239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B1D80F81F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0E7E1F214FE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D28C7F54A;
	Tue, 12 Dec 2023 20:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V05TFJWO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87641D3
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:05 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5ddd64f83a4so52014447b3.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414025; x=1703018825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1lodvb6OtWfxjhf5SoaUUtA7ex1XZFNPc9w8OKKvUg=;
        b=V05TFJWOpwlhLd3k3oEhlQ0LTZ8oXfSmFksigdfx8HAUfSFJdOmSQHvqPGxZt5PrbS
         ZJrzdXRUlDa19nPAB9Im4bwuejasfYoRwtTbYtibufvUVZzePX35jBD7Q8hsicivC8ZO
         2UV+Yt65WPJ1LDBH1HParEl96fCwNr5/TbeHKw4j8Qr43mnhb0e4Z+YeTRSwd3TdKALe
         i/0Ez1XLfcJ2DF1hg3xGLq92PEhd+b0gVsS5IS7wPzgBAVdCklX7LtKQNxdeyJqRGIez
         f3QNnVtCDji5mHOO7O3hOegyQXQIlrNTd/YX1j9j018MR9/v9J9pcdOO90iJYvSdS4TW
         QyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414025; x=1703018825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x1lodvb6OtWfxjhf5SoaUUtA7ex1XZFNPc9w8OKKvUg=;
        b=J6vUgIq9fwXWIrhELTqLLs+XPuNQCUc9p2sPPCnXExSTKv/PNXK1bjfRFZdYRUy10t
         KI/OJQ53YxbU3T6Oli9lQRF6F8fR3ui0EfAMWTN/V9cVQA3kL+l9riIBokdStExO+WVp
         kn+zPFEcNeRaMcg2PEA7oblLsq2kxZnkprYij2GzlfMlfPhQCGHdfESeSc8Lu895n4Yj
         R8LCDqYvAyfY/Xz8ZmjAiSOrTGrxFVHiN0Pv3EgULCV/+7Ix2DeQT8o9iIzolsJ7vFar
         5+FmLh6OnQiNjLOAWR+IPZxXP/vA+h9FesK2ijoTyaXOc5IaZeKTWXyOkP7UPb13BByO
         7qdQ==
X-Gm-Message-State: AOJu0YyvAi+KnAHEKni6QCk0mlVTmn/qa4eb0Mfh7wxwgT0ZHjvzFl6f
	zF5T78Kya0qgUey7RmbRR2nd3HAG2g==
X-Google-Smtp-Source: AGHT+IFA0fKoM26J8ai3StFQnJI6WfpZDk7m02MxQ8rkZS/AQ4lQ2xMjuz7+KEcD4kLjVBP5Xztzh7FZew==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a25:ab26:0:b0:da0:3117:f35 with SMTP id
 u35-20020a25ab26000000b00da031170f35mr56027ybi.3.1702414024705; Tue, 12 Dec
 2023 12:47:04 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:19 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-5-sagis@google.com>
Subject: [RFC PATCH v5 04/29] KVM: selftests: Refactor steps in vCPU
 descriptor table initialization
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

From: Ackerley Tng <ackerleytng@google.com>

Split the vCPU descriptor table initialization process into a few
steps and expose them:

+ Setting up the IDT
+ Syncing exception handlers into the guest

In kvm_setup_idt(), we conditionally allocate guest memory for vm->idt
to avoid double allocation when kvm_setup_idt() is used after
vm_init_descriptor_tables().

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  2 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b8855d68744..5c4e9a27d9e2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1089,6 +1089,8 @@ struct idt_entry {
 	uint32_t offset2; uint32_t reserved;
 };
 
+void kvm_setup_idt(struct kvm_vm *vm, struct kvm_dtable *dt);
+void sync_exception_handlers_to_guest(struct kvm_vm *vm);
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index b6b9438e0a33..566d82829da4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1155,19 +1155,32 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 			DEFAULT_CODE_SELECTOR);
 }
 
+void kvm_setup_idt(struct kvm_vm *vm, struct kvm_dtable *dt)
+{
+	if (!vm->idt)
+		vm->idt = vm_vaddr_alloc_page(vm);
+
+	dt->base = vm->idt;
+	dt->limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+}
+
+void sync_exception_handlers_to_guest(struct kvm_vm *vm)
+{
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 
 	vcpu_sregs_get(vcpu, &sregs);
-	sregs.idt.base = vm->idt;
-	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+	kvm_setup_idt(vcpu->vm, &sregs.idt);
 	sregs.gdt.base = vm->gdt;
 	sregs.gdt.limit = getpagesize() - 1;
 	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	vcpu_sregs_set(vcpu, &sregs);
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	sync_exception_handlers_to_guest(vm);
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.43.0.472.g3155946c3a-goog



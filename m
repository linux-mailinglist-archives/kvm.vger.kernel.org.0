Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6A3A3929
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFKBMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhFKBMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:12:39 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E239C0617A6
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so4460678pjo.9
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6B9KqosZW76/1EMVfhWTsUzi+G/pNj/0Z9xOYz9yDQc=;
        b=GAwPtc8CHR9Gr+VtSKHnJAsgeg8tvymKXdtyrqZVVpVhyFPC4aDdJHeumC3MsKK1En
         t2V4wHSwcIyd+ook/PA6bf6raSkx8Lh+wYGgshBgyA97jVDTPjMyAQjTYasVZws0zdJU
         lZaIBGOADVXXzKr6fY5hxM/DAgNkXUGp9scgaSPOjC5zO37xdO79xrZ000Igmd5RrOZp
         DMbj+vEYB3Fq+oB/nRURaapwNBM6zYLQ3qPz0MXRiGBeXocnliZ/46Qu6fhFDVzjlTOh
         th5l0M4Xd8JJeTxkKrveRuLVFuR3Qmx+e7I0bu/ck7gSLULn0agUeDBW0ssQMS/oV4sI
         xb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6B9KqosZW76/1EMVfhWTsUzi+G/pNj/0Z9xOYz9yDQc=;
        b=HnorKjBIsh7om6/2Qa3T3cy/xI4Bca86NOXY51OUUqBoLUuaVKfsQJp8f9SdhnZAKY
         Jhp7/jU5Ckmko1GcSKA8aenrcv52qZNNxKQrK2xRSiED6kSao9dytaaf/8yMoKYrpt6h
         x/IHvJloDqMMdjpuFP2TaLr1hddpY11ATH30tjisz40kUJ9ZjGIPTUUW+s/ldVLvVzLg
         WTPCpe245r5VltkolomKx5GK9hk7Zqkn7PYtpeLRiDA/DtXAXpc0ueEAlX6/R0YPslAd
         kLCQS+F4VkZ6GnvOgu8bU97SKToL522HbyHvHj2Cpdbeqe2lIiNKGHzz5fpphq85ucGF
         7GrQ==
X-Gm-Message-State: AOAM531ZTGJttsVIG+8Xtb6143a2PxMvnQ0Hx/zjAd4nzJS4zg4hM+A1
        2KlIDgbc+4oCSMQ9dg5VwUJBJIlm6sf684cx7e8ryc5k6s2aq5q3tV7KXuWkp3ri9FnoKkkJl11
        iVUOA9/F5EeAYf76HYAKf17m/kGkYdsAiAf/kchioJU3xWqEgSbBsNmRtTGedkjA=
X-Google-Smtp-Source: ABdhPJy6JJ9czr6WUVzln8gQQGALKDKrCqS8h4hNm7E8wu1hMBCdyByHyMcahySZBy96/6PZAuJL4nhzZpbc0A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a983:b029:fb:973:956a with SMTP
 id bh3-20020a170902a983b02900fb0973956amr1414711plb.79.1623373825413; Thu, 10
 Jun 2021 18:10:25 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:15 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 1/6] KVM: selftests: Rename vm_handle_exception
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
        Ricardo Koller <ricarkol@google.com>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the vm_handle_exception function to a name that indicates more
clearly that it installs something: vm_install_exception_handler.

Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
 tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 4 ++--
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..e9f584991332 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -391,7 +391,7 @@ struct ex_regs {
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
-void vm_handle_exception(struct kvm_vm *vm, int vector,
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index efe235044421..257c5c33d04e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1244,8 +1244,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-void vm_handle_exception(struct kvm_vm *vm, int vector,
-			 void (*handler)(struct ex_regs *))
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+			       void (*handler)(struct ex_regs *))
 {
 	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
 
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..0864b2e3fd9e 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -154,8 +154,8 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
-	vm_handle_exception(vm, NMI_VECTOR, guest_nmi_handler);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 732b244d6956..04ed975662c9 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -227,7 +227,7 @@ int main(void)
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	enter_guest(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 72c0d0797522..e3e20e8848d0 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	/* Process guest code userspace exits. */
 	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
@@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
 	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
 
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 	run_guest(vm);
-	vm_handle_exception(vm, UD_VECTOR, NULL);
+	vm_install_exception_handler(vm, UD_VECTOR, NULL);
 
 	if (process_ucall(vm) != UCALL_DONE) {
-		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+		vm_install_exception_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
 		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 2f964cdc273c..ed27269a01bb 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -462,7 +462,7 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
-	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
 
-- 
2.32.0.272.g935e593368-goog


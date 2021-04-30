Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE79370406
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhD3XZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhD3XZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:25:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E465AC06138B
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:12 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m36-20020a634c640000b02901fbb60ec3a6so25428980pgl.15
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZyjdoDvj+0d1MrdvPreqK5eup22FMf+XNotdYUvQgRI=;
        b=mVFEcJIz8TqMr35h+/Q4+Dav2KYnjMb7ka5/Gc219hGHhFNsWibr/XuA/YPgX+YHCA
         NeqV+TgK7Yo40Do4rWs0FSy/f7DQXYjOid3a1piWerc8fAYFMONv/Xny8SzTye5CFkdu
         8UO6h2hEwmqxxb/nMC1eCrRL0GCG7JLy8rL2TxB6lsJcFj+nEOnkJ7oqynUSoat7ZCAj
         axu0v6pjMoecsg8X9qkeuwsozgIWn4HN2ajHRbMCEll5feWXxuNRWaVkgdp/OnOWR817
         nwjerzB/XdDGaABVwh7/aFrycJgqzKOIITDywOnNcXrzrlOM/7SnoNQIubrddxI85XBo
         HOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZyjdoDvj+0d1MrdvPreqK5eup22FMf+XNotdYUvQgRI=;
        b=UoM0YqBbSbXk4eMRDo68ZqZ75zZrpzE8wyqfDBCx0tctLZxOtgi7S1UBkjdzDgCKUt
         FSDTz6YCpeHoOesjiugvo8XayrrJOns/b9tiAhpbM4gXGZsVvJWDtV6fIBE39TAMdebL
         J2ApHQpS3HRLaKdAOZ/EN4ugsiXsqjf8Kcg6FTDl4b/aF6MiluJujbMxiv43olp4Bujn
         MApkUtfyrKDQjk3p2ikSnIN0zGW1pYYvZznq4Riylj5s+XC+Ge6so0pKEo4OzD1VIg9p
         XJjJDxNvoOM/j+43O+l3F37Y9zyeAeSM23KqSRTbByKVVX/zni1ke3Je+dZsbs6qoQow
         44Kw==
X-Gm-Message-State: AOAM531isKg3ESeNH543nk6tkYJWy3re926PFRNAFr2ewPUPCjEtX9EV
        SKZH1Ct02/c8xiK/H9EAT5JDXCeHwAa4GfgAqU3+3qME8lqlA3ReksFzUcuv/UUD4nFtnnpNBve
        uUMm/cGdlIp7NxDyXsiNr9kc90b6qzD5Iadb1xXN9V+DJu3aC4/D+1P/k7eJLwU0=
X-Google-Smtp-Source: ABdhPJw/WgOmany3vFjVOVJu6fs2Y1+1Pd0XL579JpPqAIrVqPNcaxkdQAkHOnqSS0bi/PanAPM14cJfMb63Xw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:853:b029:27b:7bf6:f322 with SMTP
 id q19-20020a056a000853b029027b7bf6f322mr7086773pfk.7.1619825052185; Fri, 30
 Apr 2021 16:24:12 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:24:03 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the vm_handle_exception function to a name that indicates more
clearly that it installs something: vm_install_vector_handler.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..12889d3e8948 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -391,7 +391,7 @@ struct ex_regs {
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
-void vm_handle_exception(struct kvm_vm *vm, int vector,
+void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..e156061263a6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1250,8 +1250,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-void vm_handle_exception(struct kvm_vm *vm, int vector,
-			 void (*handler)(struct ex_regs *))
+void vm_install_vector_handler(struct kvm_vm *vm, int vector,
+			       void (*handler)(struct ex_regs *))
 {
 	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 732b244d6956..5ae5f748723a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -227,7 +227,7 @@ int main(void)
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	enter_guest(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 72c0d0797522..20c373e2d329 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	/* Process guest code userspace exits. */
 	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
@@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
 	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
 
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
 	run_guest(vm);
-	vm_handle_exception(vm, UD_VECTOR, NULL);
+	vm_install_vector_handler(vm, UD_VECTOR, NULL);
 
 	if (process_ucall(vm) != UCALL_DONE) {
-		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+		vm_install_vector_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
 		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 2f964cdc273c..ded70ff465d5 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -462,7 +462,7 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
-	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
+	vm_install_vector_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
 
-- 
2.31.1.527.g47e6f16901-goog


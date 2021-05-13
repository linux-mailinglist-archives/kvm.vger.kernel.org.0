Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E337F071
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbhEMAiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 20:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346522AbhEMAgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 20:36:36 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C73C061362
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z15-20020a170903018fb02900ef27498ce1so5697017plg.8
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 17:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JNTIckp/c/wIJdLM9riA2E5Tzb0NAF8GpY3mjrOIzWw=;
        b=mR1g+4RKX5l67W45s/ogwNgDOgsP/pBqA8UHoATQdQkE4dWvETmBmqh5Y9kHtV1S9Q
         GeopUrzMowsC6kJ99C6fiMDH1C31jwOH89Rl0BtW2ox6IAl81luouwI4XTn28qWjTkFJ
         CEMDKJ1dvdsk9sdXGT+AQpcjRa917+0kDxTCI/hLCgx2Yd7yC37Bg4OKH3yVFRyiwQFE
         JpLubN6jRxBOo66SoZAHwIReDzinXngPGRl4riYsQT3mjpFraXDHlldMJzLC494J6kr7
         /bysmEBIb50y/NGmQ8ZfJl7iKS82HakYl/+4Ro9Gq1iWhaWjwRYeoXWERPjbGmuFp8z1
         prOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JNTIckp/c/wIJdLM9riA2E5Tzb0NAF8GpY3mjrOIzWw=;
        b=Pi37QE8oX3L0jf+KIXKKprGNi766MXq+SS+krps3Cak+sMTkntDh3THixF+KP4nGXP
         n0ZYgqdnKu61QHyoc4iuxWLtnaBaO+SE+NVCGz81d7q80GxV+nxC67DDPChd5vMipJYw
         CxtQJZrO9WtySdsDKPgRXeROh9U4x8aD7P+AyIkE9WUmbGTTnAQJL4yJDNw3e4GrGrK7
         pHRkU3gVui1zxJf5lQm1buJv6nCF9CrvpZf4QLbLcZeYFNC1WqEqOq443nYihxOu+WPc
         F/k9pKXjjV3mZXZ4DW0UJaN7+9KU5HH+QaaiFi7xd0fhENIzIEIn9ojDiltDjTAm7lmS
         //Dw==
X-Gm-Message-State: AOAM531+qmgLlcUB9EdkTXAqYZxDJafY/9Ld8ki0gFn5gPUUsYYY2aGA
        LCvBaj4CBaZ5V5q3dCxTSOE9+1uUV0Bu3OYOGB5glI5W6/r0X0Gpa7KrPoEWSE0kUda7tAOQ0FV
        DPfNOm58XB+EGEQmdJ+T/nInNRJGR6oSB/adkyTXj93eu1Vy11dUl0MuIwA0IyM8=
X-Google-Smtp-Source: ABdhPJxNkQIDpG9TnashRF3YpGekq+hYFaWJw5BUV9b8Pe+Qu17xFimV42Yz2Tk9sYx2fF+JqDCKAd8VB87k/g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7589:b029:ed:492a:6ac6 with SMTP
 id j9-20020a1709027589b02900ed492a6ac6mr38534508pll.62.1620865686436; Wed, 12
 May 2021 17:28:06 -0700 (PDT)
Date:   Wed, 12 May 2021 17:27:58 -0700
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
Message-Id: <20210513002802.3671838-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210513002802.3671838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 1/5] KVM: selftests: Rename vm_handle_exception
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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
2.31.1.607.g51e8a6a459-goog


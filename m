Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C909B5FA9AA
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 03:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJKBGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 21:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJKBGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 21:06:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7543C6DFA6
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j75-20020a25234e000000b006c1656ba696so2328197ybj.7
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xfhZy3UUkhriDslFYVDM9M5BDExkncZX0DsGcYX7fbg=;
        b=admd+5/x8wpeJKkVRTO+JUip5gV6XBIFkmir4GdgC2eSEsMzfDSO5ZQshAsiD52f84
         PmeR0g4XO7es/yHVJST8vnjs1QXcJsmlKpWos/1MY1PMaroasIeVW45Sx/CJRbttgPbo
         hvTOcthoK4SZaV0oqCGbMKy3mY+Y5sdt2jS0MOT8zNuWuK+gNl2E1v6pJT+Ml4NCudDQ
         e/LjED9lTE4JR0jr3p4TLJmMYbngAKSymqYpxRijNM7Qv/Fu6wGQL9/iOqWtkysTKEW8
         gkFr3x3uu5hTvb1JuHgQQTPMqCbWPZWNvCqhOj6yEth4cztBAG20dKgGRmnXPOZYfzIH
         N9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xfhZy3UUkhriDslFYVDM9M5BDExkncZX0DsGcYX7fbg=;
        b=5MgN7AJUOjv1nxkxBdotNBEKBufKxO/SHomMdzIMqIEnia2r3ipasCCAxSZWSPaY8u
         MZRgiGFPvMfgtx4HyqPtGcWj55euPeVemQhtZtK1QDpTyIc8dVkaF45DlWR/AJF+QHkg
         soaQRN86HG/1Gl9AiIImDAK4uS8La2gDfrKoUr/CD0KrN+KX/wCPqo3drNbdWmdBh3zG
         N+HcSYI0o8T0tZiRlgTX16LOc9dWIASnSSageXHN4Wh2eFRmXad1qSbL1lB6wZ+kWj+i
         7jVWss80WVLnCLMNvETFgZ2zjryp6w1InAhk5O6gxBSOqKQDGPmEuHksO6B4CX/DVK84
         IsYw==
X-Gm-Message-State: ACrzQf3/4Y4FlbHBqPTnuxmBLocIpgmLvl5offQfYE/03FAD2N42kRdk
        ZGlH9u8oYvxCkUwEBb4xbK8AlO7EtTViOU4RIWT1CbXUf7y4+lDVpGStKsCEoui7kmR6+7e0O9y
        gQtNxMDWdKXLypiD09R0IVz52OuO/K8bb61MT896JODFPEw5wB9CO0FomH5/pqx0=
X-Google-Smtp-Source: AMsMyM6K8mKf7kubU50iXGiAK5FjtnbsyCh1le0Tt8DHH74pM4TSk7C4VDwEmdlpD/akb779t1V37FXog58JtQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:6a57:0:b0:6af:c9f1:1f8d with SMTP id
 f84-20020a256a57000000b006afc9f11f8dmr20568767ybc.3.1665450409962; Mon, 10
 Oct 2022 18:06:49 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:06:22 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-9-ricarkol@google.com>
Subject: [PATCH v9 08/14] KVM: selftests: Fix alignment in virt_arch_pgd_alloc()
 and vm_vaddr_alloc()
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
aarch64 to fix the alignment of parameters in a couple of calls. This will
make it easier to fix the alignment in a future commit that adds an extra
parameter (that happens to be very long).

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
 .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 26f0eccff6fe..6ff2b9d6cea6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -76,13 +76,14 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -325,13 +326,15 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code)
 {
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	uint64_t stack_vaddr;
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+
 	aarch64_vcpu_setup(vcpu, init);
 
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 604478151212..ac7fc9d317db 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -55,13 +55,14 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -279,15 +280,17 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  void *guest_code)
 {
 	int r;
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	unsigned long stack_vaddr;
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog


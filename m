Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4874D5B5A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiCKGE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347297AbiCKGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:54 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB1E1A949E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x123-20020a626381000000b004f6fc50208eso4638896pfb.11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bQK3tiQaNCPDChbMmIObJpHbjuJxCpHp0ngHczz/K88=;
        b=p0ElfbSfRFbh2onOZMLcgvy7xaQN+L1eRjGbdEdlotyXLZxUvTezAMBNQg23NqVACa
         OIS3GBP+f1CuQU99x8YtcyT2uqeg6UR4tZbWw2+4FcHuMKto0isIwUY8wAeKoV0jrKIl
         AZOc3b34fZbzlEJxzBbYqSaq7Zd9UJEyzLBPj28JHWLikyNK5+NcYqk7fsfDHQf+nrMR
         vCPreel5KxzZrTpDRo/WOViBrz2O1b1aqB5awJd9DVx18IpdzICbmSE0+SjwdAmGq77s
         Qi6WgRnF/DOWrhhn+IlDWNSYmrDkigCUUBCgQdsuKEgJmwOE3LhDin3Ski+hFwiSlSLO
         Cw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bQK3tiQaNCPDChbMmIObJpHbjuJxCpHp0ngHczz/K88=;
        b=sW18Y+thpflqbHs7Rwc758GWLzwxGeHVI/JF2SSOUAYS0K9FDWWkI7nRSWSa1vTaaJ
         NdyxkPd5S4wKs4D9WIa4Ku5zB4NXi0swTDQsQwVd/WFmZkdzrtS/eOuLlCEFmrdRE/CH
         KkQqh4DsTBgvfF+CPtfm2pzqL2WhTPTl4mVIenmozfth2ALV5tGP+vpr6TJuCCpn1qFy
         rz0wFIIt6M/gIIe4aqxvvUOWx9h3oTZzWSEoXETv2yGFoRcdxLbRTcYrFWj3E72Pqc86
         iL4Yro2fCqWdvMRIdVXPWMmQtRg4LTtVanYWArjLc+0KKhcdMeG/Cgkre/UsqYQVgGLI
         Dlkg==
X-Gm-Message-State: AOAM531e3CpgJBlR0+UapJDjtVn6o/VpU8mPMRD0+UlFGF/5YlbxZwMW
        LbRt/7VbMZMkV7nLkends8zbi6R5+Mx7DI3k9xx7ZqYclmF+uHFstpAzmR+9lUxG7np1NrKZX2s
        ZfxcBmjoBFbs9fS/GRtsGDRF6LZ7s+wjqUpD21n4T5f9MWn75GMyvik/jrp2MNr0=
X-Google-Smtp-Source: ABdhPJy7CkMfNWO/q7qASHNk+OXFyikAV71Ej2ADGG+MttMyDAp29u5Su8YNs60F3+/3TeijkeLWvjr11PDX7A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8ec2:0:b0:4f7:4a9:7fcd with SMTP id
 b2-20020aa78ec2000000b004f704a97fcdmr8436792pfr.26.1646978538998; Thu, 10 Mar
 2022 22:02:18 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:02:01 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 05/11] KVM: selftests: aarch64: Export _virt_pg_map with a
 pt_memslot arg
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument, pt_memslot, into _virt_pg_map in order to use a
specific memslot for the page-table allocations performed when creating
a new map. This will be used in a future commit to test having PTEs
stored on memslots with different setups (e.g., hugetlb with a hole).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h        |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c  | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index caa572d83062..3965a5ac778e 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -125,6 +125,9 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot);
+
 vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index ee006d354b79..8f4ec1be4364 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -86,8 +86,8 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-			 uint64_t flags)
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot)
 {
 	uint8_t attr_idx = flags & 7;
 	uint64_t *ptep;
@@ -108,18 +108,18 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep)
-		*ptep = vm_alloc_page_table(vm) | 3;
+		*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
@@ -136,7 +136,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
-	_virt_pg_map(vm, vaddr, paddr, attr_idx);
+	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
 
 vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.35.1.723.g4982287a31-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101AF55A397
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiFXVdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiFXVdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C55411C2B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so1876871plg.0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YUm56oivDgN+RP5oA0g2s9n3unpAggk6uf6vDLH3FH4=;
        b=WgPTRm1ERpmL4jqcLWSpoDy77/dfU2P7YjENougX8oSvFRtvVdvYrez9nldzWv4sgH
         JAqU2ErQjdlJ6h0lJurfDi86kJerb+4tmhb6GRJbvzhoNGxRQ6RFqr+c1WkmEiPNgCgY
         vnpssxrwl84jquENHn7m9Mb1unW2XU7uX9E7vcMkG8bFCivqaHJ2O9k3OExy5qjTC5l7
         zfswWmo7mzifSSQ94gdirTjO2NbhmNWrlmT0/bH50yalZAQKDqZaD3jKWmXHxFIwEva1
         r6Tda5OIMFppvuHmzbLQAxxo0wPohxD8XEI4b2ogCy5qrYBTbYW5ZzlTsS+L7NlQlwNe
         bqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YUm56oivDgN+RP5oA0g2s9n3unpAggk6uf6vDLH3FH4=;
        b=tdGJUJy7Cdabtj7yP4fuHu4AXA66AwJpzz3zlUmD7ZiDOMPRPzrITE9AstW53oR7q0
         +hM3pmnvW28DrZRqV9sppvP8VnyTsxC5MDIChz8RM2ggIRBnl706OCTYvPUXmIRFMXZW
         k+GMiDqFcsQfqSqcWnR//Jx3X+n81QXMWzUTLl3xhU5LQnT39BQUSyZ/EsrVyf3RRLLE
         z9/szeSZFu46MgH8ZnHb0VSg4YffL7YuJjjol4XyPCF/fY02XhWSLQcaUy91kfhuMbkY
         04zhsBMwk5vSfUSqhGxfUrwNaQDQ8Jr2CPf1jK6nx8m5loeZ6vE+pjQBrOEA6AQG7YW8
         2eNw==
X-Gm-Message-State: AJIora/xeMxTwz9gKJYYnlwO4r+SvjMu+bgRR0/DxuFbsxDIxxb2ELV/
        Xo3uF6oHRAmL3djZDEgj5r2gvVZUPO9kwAxU/s8uxMeSv6wYq8h6TA1xdznyoA+qjiUEB8iFTr+
        dgXJYFvk/WuqQ4rskzcRQ77N5PKG/EsWFPPdb+AlpZJi8pSNOK/n3ifjCI2ISp6c=
X-Google-Smtp-Source: AGRyM1twav2RjNxEnLmJHpien9GiTvNG3d2qoHQES9jZd2VNIqEUDyLCOIYWGE3epI54P1wH8YNze67SsZF2dQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:c2ca:b0:168:db72:16a with SMTP id
 c10-20020a170902c2ca00b00168db72016amr1018402pla.171.1656106387722; Fri, 24
 Jun 2022 14:33:07 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:48 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 04/13] KVM: selftests: aarch64: Export _virt_pg_map with a
 pt_memslot arg
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Ricardo Koller <ricarkol@google.com>
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

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h        |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c  | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..6649671fa7c1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -109,6 +109,9 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot);
+
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 63ef3c78e55e..8dd511aa79c2 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -85,8 +85,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-			 uint64_t flags)
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot)
 {
 	uint8_t attr_idx = flags & 7;
 	uint64_t *ptep;
@@ -107,18 +107,18 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
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
@@ -135,7 +135,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
-	_virt_pg_map(vm, vaddr, paddr, attr_idx);
+	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
 
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.37.0.rc0.161.g10f37bed90-goog


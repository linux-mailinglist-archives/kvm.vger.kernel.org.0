Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205DA4E5B7E
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbiCWWzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241410AbiCWWzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1227887A8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w6-20020a170902d70600b001547597fccbso1515858ply.15
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oEktOHA4h/Pzsk6xdNePnTp7Hf0kOVWpP7CdgL+bzKw=;
        b=Xs8hcW0FNFRDWwAGijUrf3IOcs1YOT3+divsoc1McHrVoNk6m6Z/2b8YiaTy+ZKg/2
         QpX7KalZ6NfxulsxhM1BX3Jc7n1xe6FvFwjdFAENd7RYFYt51hmVXSHcAzbgoeGBSjr2
         G1WdW+MksTLqLWBVLajXSQ+NY8u6LGLZGTAyQpjc/ca46j2LSaetZ9X/wLrQdcNXi5ZA
         CAwkLoMgc/qP3QbDy25hkiSReX2tT9tC6vSgSEySGo7isptcgwss2l/gkMch3s7tfuzu
         98Llsg+DNc2bStrrIO/cd3U7ESCoLfTBIbXdoEDJ6tA743vQnawC4XKjB+SFuExCYNK5
         XSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oEktOHA4h/Pzsk6xdNePnTp7Hf0kOVWpP7CdgL+bzKw=;
        b=5zCLv9j69YUUxHWamDe9Td6F5c+W+Q2sqdyeso5t8fnp3YM8O7Dhc+0VUXXenQuzhS
         Xzpy5GFYNlq1AYJptoW07pcdj+o4TeUwsj5TaWphuBF5nHqpdN/QWKRfdKxPDFyS3+wZ
         6rLIh/k1cG53xXa9rO4ImqSHoiaXt+Xyp/7g1V3TiqG8NlXswmu4abn4fwg3yNPVLGQB
         wm1MonPKqcQTpI+s6jFzPJ7KojXFbsXaSIq2o1VkEBT7b9oW8qYJx50bfWuVGgVsFYgA
         9ob4hKDOJahMehFT9wjQa1VSZrw6q5HLLe+QKapMB8J3+LiAbjOTjZoeObObO4Vk8GtC
         3sPQ==
X-Gm-Message-State: AOAM532GKtZNBQSO+xWmxX8lpBplaupdTeVODo59I3kogzW2tL6rZP8p
        kO8ztwH8l+0Zx+XipwBkv+IuNvyUmrw8z1ERLmuKLQmb+6/sqW0x+DyFpFoy9Qg1V+xYIqYOZAw
        1ylf98KRyEQWD6PhMe0Hs3HTm/Fc3q078V0TdT0dz9nXYcBQo5KXFAfuH8jghnIw=
X-Google-Smtp-Source: ABdhPJymrSPUSVCVfy9VYz8wQJ7EnH3jfORcGwmLLgCnmXsuGDss/MsB32qZGt5NM91bPbaw971dur38maD3xA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:b189:b0:14d:6f87:7c25 with SMTP
 id s9-20020a170902b18900b0014d6f877c25mr2446366plr.31.1648076055887; Wed, 23
 Mar 2022 15:54:15 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:53:58 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 04/11] KVM: selftests: aarch64: Export _virt_pg_map with a
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
2.35.1.894.gb6a874cedc-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA14F8B4D
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiDHAni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiDHAnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBE81777D4
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oj16-20020a17090b4d9000b001c7552b7546so6707559pjb.8
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KAfe53pKWAZL68142x6k33xnrCZ2swQcXff2G57c/kw=;
        b=R7x2A1GHqSEUwbp3RyEZpy1haZz0x79bvMaIOyfgCDQjCzYtjJBgyUTzal/pX7on/z
         pyi+d3XfXQiXrrUH9EtOHmzz4Lj9WemphCJpjRgJIuCcB6Qk543dE+WBFSuwerNwh0HL
         1x90qVj9xfHsU3R6sQ8eFwqUCog0QN8DcHfE9ICiWjtHOeFHivmS/zONvZLw+LFcgVCU
         obkRjvA7ovoH4Bb480a+XRvrCjmdPrBL2edRp3yHcykJ/8W8lebdYqbfD8X2cLsWGX3l
         mk1rR0AQiWtVLT+8rAT+xWNYoQqGUAD63H7j6zyn4wGEuI49gkgwVgArIgEFnRpYXqJP
         1jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KAfe53pKWAZL68142x6k33xnrCZ2swQcXff2G57c/kw=;
        b=lkOMWV1Dq75PX6zTlrpanemD3Gb7wnc0Nk9OqkACgp8Ae5+KWr3K5qldu+rZujNPKg
         3K+ee32Jxsj29gd0QGbsSDh8+dtQwSaEpDS5qMkDNiXQAGUtviZhtzMzTLAM8pHde77Q
         wGxhcRbs6M1ewtm9cX5C+0abAL2y9FBIlIeZaFS065BMJ5VVi0i9LNz+m1c9+nBuhXqJ
         tdNwYCkDkxVffPMJ5+NqQ7hi1Kq9D6uF2hhAu35LMJP3ROqzQFYtbu1R8NeGWqd98n7C
         2Shc9ZZoDYNEgo701QakWFzdX1BDUUTlX2rGQusejOAIYGtefvebVjieopXH8dtKKWBq
         Eadw==
X-Gm-Message-State: AOAM531M4VJdN/QzSbhJeCo77Nx7c4KKmMiLSohnOqdN0XuTaPd5FwjL
        TmDriZmEFZJ0oitURLDBKpud3eUHxE/8qA4NrdnbnjHidhEqB7H9N0SjXHoIMMfg+I/iib7Exxd
        FL+kDN7Y8WZ4kw/xMq+lfH8JkK9bCvNVGYERUYzlgxB6uVHeqXhwEj5cuHxXrlO8=
X-Google-Smtp-Source: ABdhPJy+JrHZpB861uw6fPE5ZifQvEmj2r2MrxGNq54LBdPo29NP4IZe9IfCDi7uv13BtKsv1tHqwXGSCGD1Iw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:558a:b0:1ca:a819:d2d1 with SMTP
 id c10-20020a17090a558a00b001caa819d2d1mr19006855pji.126.1649378489720; Thu,
 07 Apr 2022 17:41:29 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:11 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 04/13] KVM: selftests: aarch64: Export _virt_pg_map with a
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
2.35.1.1178.g4f1659d476-goog


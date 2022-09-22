Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214775E5991
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiIVDWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIVDVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3FF90816
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a10-20020a5b0aca000000b006b05bfb6ab0so6950589ybr.9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=d5L/Pex/df2nsW03MAou/4OYH9F7wbd4tSrasnOYgq2tk1+iLsC2xAMhzxPZcfBHMJ
         AFRfuoNKJHOUgJeSYrj2RQraX7oo9qFH9QAHoBll9w/ez/ptMh/8HVdSvedF/Rr2Typk
         GmKNLM7BHtYBHC4+zm6s9gw8KIoui0aKbrtC9N48bc1V6Qg8IiFiz0M5tNanJO3CCoqJ
         nwjgkCq6mC4fAy6bbL/KnY96n7HeVSYeebg5jRFNQKMF0woCt/PtXOIeBfWi9W0lpoUk
         5UvB+ogLTMXfg0yw6UbXNYyJjVNe67Khk9EuQjywWTkwGJsOGvEpb7dRR2JfU0juIOqg
         40aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=u7iS9BsOPR48q7ys7V2ELUmFODOno2/UshafOnTwZgOAtd1CYNgDt0iqTnvP4PCRSG
         pW8FD08LXpuIzw/ELGohvHoN+WNfnbcwbXRlLgjgOuS+rA7VXJ2KZwPpWO3fvAKg2RZl
         dyKgQ91C6SBUlOek8tpFb7D5KoL+t/HIs0BfDbq0CRY4emVKNDrR252rzHg2P59X7SXk
         VnHXcNXFpqbBSx4u/YBEOiq8Vd5cp/EjmF2WvpoVWYU/RBxidhKzeL1d6SLPf/rh5xgb
         F3Sone63CPuQ/WCs+d54kUnbHMUgtdlNEK6xQED3y+Uf4zDDflamInzZaUvIgHdb2cs0
         hXow==
X-Gm-Message-State: ACrzQf09DiDV/C9C91LzWJ4lIVr1PnxRGVH0MoVupMLF7dC4IGPOPduo
        h0gibQqDQb+iQv4DBewDqIScCLPCf4TaHrd819QvCxW/zGkFq7vsswIevsOGYvNbk+l6otc4ZWw
        HL/1uc48+guReRogMkYhBAl2qeb0SePTLc0wAuCUq+Ax2XDHimuBORIquB9Nr9UQ=
X-Google-Smtp-Source: AMsMyM4ZkS/VAsRgzEH2KFBQiF50yhXw75krrcdOmJf/P8jj8u5Z/zMedtfCl9DtWKtF7VbO/1YYyyWLDTSfeA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:e810:0:b0:6b4:5abb:af39 with SMTP id
 k16-20020a25e810000000b006b45abbaf39mr1592729ybd.158.1663816742842; Wed, 21
 Sep 2022 20:19:02 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:45 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-3-ricarkol@google.com>
Subject: [PATCH v8 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h       |  2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index a8124f9dd68a..df4bfac69551 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -109,6 +109,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..63ef3c78e55e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -138,7 +138,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -169,11 +169,18 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
-	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
+	return ptep;
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-	exit(1);
+	exit(EXIT_FAILURE);
+}
+
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep = virt_get_pte_hva(vm, gva);
+
+	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
-- 
2.37.3.968.ga6b4b080e4-goog


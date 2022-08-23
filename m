Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D059EFEF
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiHWXri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiHWXrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:47:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99C98A7C7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3328a211611so261913727b3.5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=J2mkVugn1myDbOEjkjhuVtflf2qvQ8P4WyEoICHnLzA=;
        b=JELmj/sO93tSXizhLkFU0QubCoWU13pb29anAIsUo6DQatVi36NQjSZGF5SjGIRpqF
         0m/Rah1nfiPxJJ0TRcD0zI68yPSF1V8G2r75iAhbHO04aTIsxLNy26PqnRf6H2SM3yIJ
         XlQCfBCLxgW0EtntRomOTyfeWPXnDzs2YnnU7A9oz9wHvvr2kLixVm/kQB3amPcCnskz
         mzn16oxpe46c+lRZKfCHIbB88SZ+gq1+yZQ0GRYYyMndrrxhh6e265RtgqmZw8ROmy43
         xb4IzoHFNxOUFPcDqZ17qBfrxtfP8dKrSyMDkpvk/XNgBcKJ5PknVV0dBdZrg0II8cMx
         cBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=J2mkVugn1myDbOEjkjhuVtflf2qvQ8P4WyEoICHnLzA=;
        b=fJqMkEqNf/RkK38/Nea19o7Lsq5/a+oSGT2dUWyVS4e+aqXSDLnE8weGtHQApQ340u
         Kb8Q9xoiCKDz3j6h4r5P1HcB5LnGvFKKv8ciBe7qA04Jbn60v1jok7UVChEJoMhb/XCt
         nxru1CrqyHC1xG5077NSGZ2dBrekAYiwmrZQ2eliqkWF6z/+subYw/JN5sgEMr9KmDLW
         StZaFz+gnWQErZ4d6M4lKCey+dS4rkYqQbM+FN+ITxDBOXecIuq5wZ2rrMNkl3XCMQDB
         0E7r6Lj6zMkCm2+UeAVyVt1KB1535UytSEp0Wk/91wdwZTWQtZTts5UaoTH/E6XH6eym
         HGsQ==
X-Gm-Message-State: ACgBeo1ycseqoyyEohPpkeCtQkn6UHOA3VjBnTDo+E+Y8S+R52WPp/XE
        xVIjrBjU9UZ8hGOEQ2ahzUU/DiuOLc3GDZ968GS4F/TdvSVbzRRNpS4PoqdhcuQW9raz0DAsfg7
        Hyji/e4qZzqO4h4vl9girm4NFmFQ+hRvElQOG7aRVK6rQXP8X1y49/NxQF/uoUcA=
X-Google-Smtp-Source: AA6agR5Qhgrm6tImFEyhevEcXK5yqAkkFa6tItim8V2GuytrVo2Y3sEhv0AsIo9oOk55kQ1fSkauI9WZam8/og==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:f402:0:b0:33c:eda4:8557 with SMTP id
 d2-20020a0df402000000b0033ceda48557mr9862942ywf.183.1661298455045; Tue, 23
 Aug 2022 16:47:35 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:16 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

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
2.37.1.595.g718a3a8f04-goog


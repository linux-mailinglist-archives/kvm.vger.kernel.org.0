Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6655A39E
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiFXVdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiFXVdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04B9CE15
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z4-20020a056a001d8400b005251a1d6bdaso1621565pfw.18
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/E7cBtwhQeWlJ2/e8yQhI7SinJMEgtQXjp0sOP+6HPI=;
        b=WA6fD4LXAC+4hdOVvDFxL02msgmrqFB06eNhzzNHtZir41tAARyP6q+lG5QjPfUUlU
         x++Hp503zt5xO31KyV2ah4U0u9BFUKAAINqX93oLYKmxBchO0pOEO05rAJ39kZELWKDy
         vOevQteJdFvPTXRQgx0p3hPuR4fDFXVEFQr9B9c4nwo2lV/i5oCJwkgr7TJdce5Zk9UE
         mpKAzNdXG+18DNY7xy3oEJqE5Q2VQ5mGjq6nMrYAC6fy5oZyGSiup9FlhfnCAIxH/h/V
         55iZAEVPoRjDTToRGJaGqNB9W9etrUlZrUJd/pHhbze7sRzUXYoum+rIFha+dCPxc8yS
         jl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/E7cBtwhQeWlJ2/e8yQhI7SinJMEgtQXjp0sOP+6HPI=;
        b=a7w5N0RLl2x4P4jwrwebxDM4PTUceFqQgyEjjaIZafgEyeepKiDKSSZmtuZLh03+Js
         lwv5PLHqfIKR+ngi/G6nPbsHEaE+bT8ZsvHG1GPAop87bKuIIi/c9YOLzgURNdru0CNq
         MUwQKuCksruuOXmJRN60ogY5YR4DTOQfOalYA1DaLSmuw70Qw+EuomfVV7THEF+q+8Dh
         zrbjqI13UnNzP/Lng4EuT8Omh7ZGNZojLlK3Fl9UVVYHrmzbPq3KPlZoX8/KenXHnFJa
         +8M8s43/cBAa2Ik+/FgOE2BrKeEY/3xHWZvtb3gyPDuxihhXsUoEuqzTQoTSZJzLqUig
         ebRQ==
X-Gm-Message-State: AJIora/+TKi9ley2uXeZlcsJN31bOiAoG/YdNUxkMupYUkAyBEeBqNPM
        JXkio9SqaaFwPv4S2uYybOBjaJQ2GH2+mR6PUkAp+zAFzqnzPotjWPncXjl9tBA8R2UaG+FFVZF
        M8qLbkrYlF72YulnDbocKqHMoVibWbwSrvSUH4FO5iopGcltsnx2zaL5dph+0+Vw=
X-Google-Smtp-Source: AGRyM1tMkZOAPWy+tG5mvLJoE0l1skI8OqXHBmejxdQHH07AlUTOJKDvKPcnQeV0Vojk9fCozl29/tFuNZ8nUA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e0c3:b0:16a:1fc3:b6e4 with SMTP
 id e3-20020a170902e0c300b0016a1fc3b6e4mr1154179pla.85.1656106384089; Fri, 24
 Jun 2022 14:33:04 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:46 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva
 library function
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

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
2.37.0.rc0.161.g10f37bed90-goog


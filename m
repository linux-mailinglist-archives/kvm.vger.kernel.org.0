Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D65BDB88
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiITE0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiITEZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:25:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CBA5465D
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:25:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y17-20020a056a00181100b0053e8868496bso953645pfa.21
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=aosHoqT9RThNoe6VamtssuE/g/+U6tbcYt4qPFtB37IY5Pgq7TvkXhvZv/Tezmsibt
         nSdcxRl4TC+EiTYicXiUdRHl1wryv+m7B3oiFNzlXQB1dr1YydmpWzPT22bgb1FSkLw+
         vZ6GRmU7kkq/HnJMkoksoRE/hpVZAsbYyo4tjvmMxg6EQGSmbD2mTrR/ZZoMUyD6UNks
         HWaC+pW/10LVg+IUOFJiY1YX7airz6RJcruSMQvWWidXq9iP7J3sfZ4FVXG46EvoNe0J
         Av+4QD0GXwrUmEEo4sDDMFa/zLgy4nd0hEVD5XTgYMU/i1kBrih/O2V5MRI0/mjtFV7u
         RlUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=CIZOuQFg85zmTLMC9pBegPYeExJmEqAhkkaQyG9e7grAFCDaA8kD62fde7CQGWhlgT
         C8wf/EQCBrbty0/zT3uT316z3HK2eEw2qllgQjT+9RXM062NZbBRKjP/ZxtS61tBjf2t
         cRmLRySP5FJg1hNlx7h+KOQbo9xyiWD3iX4DYzoD5PdI9Iz3wmNShsUi+xSeLMdn2lGQ
         nwmJNAlNKoOcLj2IVNQ50C08s81dlGzRvBJB0xyJHt5ScY7QarH3uPB2YKl1JPnjS7km
         oLNOB/g1ELGPVAGFBrdXGm2ipoCCD/NqIySGopUIzrPCium5oq8YOrbxp6H4NTw9UHUD
         bkkQ==
X-Gm-Message-State: ACrzQf1fG+9ZMQYj1Enz8Xqr9mO+3CRtLk/zM9pfbJtoyzh+7n5Vj84H
        NVcUkJyEpPfelH9k+evXnkOFUJqmHmxyo+YRwqcZHYeLudbumYxVb1Mw+PYC1NgZh6rLmlZFnYW
        D5pmeHTKx7TJCY+ExlEDHIxTkP8wG/+q4oGKiVbyuSh0Wjv5Q5HKhmM7/ZpcMfq0=
X-Google-Smtp-Source: AMsMyM7tML0kfhsb91m2QQGv5wnNsCscQ9UrJdt1ChXynxWjvefJ75VFez66KA01gGb+cl8htzwVZcmyoW/2yQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e709:0:b0:438:98e8:d1c with SMTP id
 b9-20020a63e709000000b0043898e80d1cmr18586866pgi.403.1663647956879; Mon, 19
 Sep 2022 21:25:56 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:25:40 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-3-ricarkol@google.com>
Subject: [PATCH v7 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
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


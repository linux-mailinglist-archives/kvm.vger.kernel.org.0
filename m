Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C511A5BDB3A
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiITEPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiITEPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:15:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BB2275E0
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c4-20020a259c04000000b006affd430b3cso1107430ybo.4
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=KcsacheBvoBTtwutYkASgDvMhsJttlNfMGwNm/qnBaEwR+K++vD5/0gcPcjU7oEKH+
         iyDNSgGTvmV/LSf4/9jOx83l3nG8Wqp5KfnSBm8Cgkhk78WUEIkqrlxfp0NpQQPwrdKE
         VPIew7wW1kW1oDbIERxQRTKfCL/3hYisd/Fl8l2ry5OW2LRDS0me2yRz5Zz9JHpsuNs2
         xNHYSb8XJwyKivDtX9jac/R4a929ClWvZOMkS+x+tjCCtvEryiVTIDUZIyUIq21ZJ0zl
         eGJ7colHEey6TQebT3YpFCw6GheidpULhx9+QrGORwtcka3IbYvtTd6pDSn7Sdf34j6+
         hKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
        b=yEaoaKJ2DRP1qmq4C5zPQY4nNDvQd42TTkDE+yhmtyMrqgDFzumnzpsvGmv34ukCoP
         mBHBfoe1OYsUHt4RKHsjrGa2PNfH1taiIWOAaSQdy+iyAUI598nuR9Mk/Odgxu4tAenJ
         Ac0MdJ45WzlE14PaIaLSBNRXpuHiDNic3capkW139EAaFG8scpLdQziZg7QJ51mPF0Cb
         l2hxAZJbHN7UPU/CQSqLF/3rx9A/BwwtuBQ2+J6nz/pPKNuj4Y9ZtMYa4qiAluqkpXHQ
         o5UgxkNlS5d3dn4qHG1uIdgUvMDFMueDehgr9nC0B/4wvhvNIb9NTmMit5Tdz+tX0iNv
         vIaQ==
X-Gm-Message-State: ACrzQf2k76/eK/pNuMenxx1fkltrvQOdsVeC2nR3WL+3OqjSIUCLL90c
        89PLkG7jVYlJ6dk1pp+9/7q/C+XMit7ZH8b+d8B7gqCNec/do973cjUJ2b90cYhUHykFUt0giFd
        J1L9Vc8h4Ysg+dgoMrjeV9ZFn8D26oBGNWzgepPVN/6pbpHV+gTBvRXjbu8SBUnU=
X-Google-Smtp-Source: AMsMyM4w/TW6t7ALYUwLVOL4AbvLhEcMAXxCd3cv3LQWgT3THGBCzU/5rahjOxQK0Uj8B9XUhpdcKgs/m1b7Ew==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:3356:0:b0:6af:13b8:f8a4 with SMTP id
 z83-20020a253356000000b006af13b8f8a4mr17691864ybz.52.1663647315737; Mon, 19
 Sep 2022 21:15:15 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:14:58 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-3-ricarkol@google.com>
Subject: [PATCH v6 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
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


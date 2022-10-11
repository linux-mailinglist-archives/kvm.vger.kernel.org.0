Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E485FA99D
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 03:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJKBGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 21:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJKBGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 21:06:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D3D51401
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3586920096bso120525597b3.20
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 18:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hq9NL6B9Os53bTPgTLTOMBGsM6lY0z/4JHp7mLyST1U=;
        b=lkrHQV/0lVpq1npY9LHpffGonYfpeNlunRWanRqfunEzNi/NcefaHQcNSm8i6b+GU7
         j8K6AP95M36DnJphvvI9B7hRpUeiECfr6j3gW7J0sj73Ekcsv1hTGG+t2N+wfUUDU6oR
         lu0GrlM0vFAtxWCpmGs2HZjoHYhxe5Sw+G/DhMRfgYTIDSUbXwdYBIXC04yqLLUJrgxu
         jDI6NwHNSxy7ENngck0izE6Qy5f6kkj+epUcBJZRz34B16rGbqwAyFhK4bNZbgEjc6o6
         mXW78Xf9dEoKzUbpRzEYUsW74h7NPRhf8F9lT7uisjcwgoMD4OXNV0WmcBLfau25SdcZ
         07WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hq9NL6B9Os53bTPgTLTOMBGsM6lY0z/4JHp7mLyST1U=;
        b=fDqAXu2hcOTroTua4XXPoeaUH6chMwwFEdLLZvx8GhpNGzBiCZFvnpYl4AXtlmz/ij
         oKXZ1bWYdhbXmCj5TKMTttPcMtue/XLT3esSe/7uGWPJSuNY1YndioLHN/VO6szq+Y03
         Hpnw0h+1VVHxrCFyE2H2K4aJH1M0Uk2KbAa1Qdq0b8LzmnJEoFxhLxhCJYHk+BVkfwCS
         srW45B6Bb1R5qagonXJJRTGi82IGEmrrUB6HsYv1DRq9Px+YDD2GnyfLwWMLOY9GEvWG
         LtOc//uyRjTGmrsbCUkpc1WRprR1aDN2bcjQuw0nyFVb3yt1UioLBfGHT3BlVIM+48PM
         zkqQ==
X-Gm-Message-State: ACrzQf1duzecCzB2LVTFi8e6mUrVt4CnQVMKgqB8lFe3LiPdg/Pvb6io
        LNaq7HyX0TYza7B0gUWIVjIad5q9jHZ8WXCP64eLVRa/kRzUpuKPc/g2DNNrcNwL3hIHOqY0ZxL
        tzfKSPBu1gehQc3iSi0z8sdf2fBrcV5xRrmJHWkaB0Ei7De08rLJTZdLSZtH10PQ=
X-Google-Smtp-Source: AMsMyM5werx4OlUxUq9yYtmxBAkTX+TLMdV2IK95277jRL8MA7+s0rjb4DSqTbsl0obBxVv8WfNgTl1RA9rJdw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:bca:0:b0:6bf:b0d4:407d with SMTP id
 c10-20020a5b0bca000000b006bfb0d4407dmr16896540ybr.189.1665450397236; Mon, 10
 Oct 2022 18:06:37 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:06:16 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-3-ricarkol@google.com>
Subject: [PATCH v9 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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
2.38.0.rc1.362.ged0d419d3c-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654CA5AF34B
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiIFSJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIFSJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB426AC7
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o14-20020a17090ab88e00b0020034a4415dso5140107pjr.6
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=WdKXXyOiNL7tHw4czPZqabS6V/2k1QhfqlT03oehezc=;
        b=AHTPSnI9WzHXRJKYVXhU1NPy3w9I3wq7nZoibVPLBek+eNJ2p7U12Zj2Q7LX4y4zXQ
         dlwj705TeJSYZq0A6FD1T075aVX/4VRVP112xYJQcrcwiNFW1KHwrK3HmsCjbYP3+pyW
         yq8eH+7mdQzLLOiKhCYJtAewr9eLSpaOfftNvAiqIT549eQGyXVNDYllNuTIyM2bysun
         aGoLLMTYsQToKc5OLP34nmYYkdnq6Ea+PZKDy+CPhsZxdsdOklNX2c7FIIrsN9fOSu1H
         qp6QIN8XynxEVU1aFo8N82oYeMtMRpVw8q2NC5bFk3NCep/NXnr+Z751VKOPHCyq/idW
         lJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=WdKXXyOiNL7tHw4czPZqabS6V/2k1QhfqlT03oehezc=;
        b=Sg9ncMWDjmGdZoKIsFFDSZqEJ0d7wP94p0Hgt7s0Y6hWXGpVZ6lSOggDL0qNtNpv5g
         PUyGsd4mF26owdIltPTeU+8D+8eu6bWMYwztI4DScw0babejFRKk5rZupZZ9mMUmeaT2
         oUa3NgF2ljOLvlQt9YzL8g6j5GPdNsty62JlyBork3O+6ZHCzJ9OajDCsY+cWx7k6iKN
         CHQWFVGd0KC/3DgKZN+KCXainEhRiVmNiOGNE5AAFCXPjkahqUP8ByLb2vNRNRdnprlE
         AhRGw5gEGBMlgog9FN2RVroyBcbQV31EQJDCNmUqdLQuEvz0MoKJySlNDzhWEda3yMnE
         ++YA==
X-Gm-Message-State: ACgBeo1OMSVEvg88wWgqdPaFKl28gIORUSh67ZakF95upnht/vo4UYMb
        TFnM7/bE7j8j1JuJPx4FpycQkRw/8mFF0mZs1fi/ae+rdGWfwq69+eNmOM+E+WtT/g041A3uMd8
        CDkMjRyWBMbjEepYQsKpEUW199eaOSj6JZfLXsWnIMa3KA/cJ8cNNzBzH229sS64=
X-Google-Smtp-Source: AA6agR4ac83JgAtiop9Kq9QbBzgDoQaETkNX/tKBEn77W26FNsF/bmL0SV5ArqF2s5Vm9OK1ey6e9aaH57h2yw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:2341:0:b0:434:d9b8:cfdf with SMTP id
 u1-20020a632341000000b00434d9b8cfdfmr753937pgm.446.1662487778403; Tue, 06 Sep
 2022 11:09:38 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:19 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-3-ricarkol@google.com>
Subject: [PATCH v6 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
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
2.37.2.789.g6183377224-goog


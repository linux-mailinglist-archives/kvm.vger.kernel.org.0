Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A958EF49
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiHJPUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiHJPUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:20:47 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EBB2C134
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:46 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 185-20020a6218c2000000b0052d4852d3f6so6573092pfy.5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=inMFi1r68yo31MqDSQUW1MrXqR/Fsx7sJdQYcs3nA2A=;
        b=TciIvPL7Ok+MSMHHNnoV/S0cgh2k0O7YEE2UsWpJOjO2Rl++7/d0rE41bp4ZXn1PH0
         uC2fGCuG8t4TfYR/fweWXYFKFz54IjdqRzrz6snAfpyzRN1k5JCfKxQJslr3Zayg3R+Y
         P1pqjrirg5eH7BgdvLq39bCWRjlQbL1Oa+aDeB1azAHtr1zaeZJ1nzBueHNPbwYhAP1H
         TsRxCNNAwogvZyAk9vaECyOXChzMlYC6soRz45PbfvGAv7kNgH7ezCmIKK1JLPf+6gpR
         orydod/QVAKzUVkTTqz5XICsC/MBfCNRKMGWenNL4G3hstq1tPgY6MT/D+OkWusnFqLM
         ueEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=inMFi1r68yo31MqDSQUW1MrXqR/Fsx7sJdQYcs3nA2A=;
        b=HNzWqi5mpyNPhju2a4EoV6HQoZTIXE/7fbe/lS1NXqlEC5P/kgc+Wl+u/b8n3AwLqA
         DwnN1yZJWogI1vIIfYV8xrCzo1e5p7G1sYC8ylSkMmdu3LivpXoHm8elwbxPZpFXiN9q
         sKHbjZiahcBEYSWwU67RjXbXjftZD4uf2ibadKH/Cq1SWHa15wRIoRJSS/aeOtsNkXV6
         M9lV7n4F5TKIB8V/Z/tDa9hMxaMb0YDiC60E5+qBq4SVgF/dS/d1xjIFV204FOskJ9ek
         JMgeQ3ieu8q7peF7X5N8/l1KMMVOesGRoZ2XivyLyRtiyRNIbOBvuanboyyaaJyQtmFO
         +pEw==
X-Gm-Message-State: ACgBeo086YfjhNI3BCgOLeK0/yU+3oUCE5sMr7CA9NZOKwREgI3L7kui
        9WWVrCCGPCc7Ox5I1ru4UHprwBTYsXOu18IkZZuRv4JJ8Q8BfV3INaz7DiPgookhz8gXHA1K2Nz
        eT4Xrecp7OWzPZS0UgyiS6bak8uCnDL1Di0re2Bzd16jhOXDaC4zCijNv7g==
X-Google-Smtp-Source: AA6agR4LZb7Yqyy32FN1fTAMq1aUHEh23ROTvttgThhcctl+d6SGj9/jccM5pfWDzrr/y4eX7dO9nFTkkzI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:8c8:b0:52c:887d:fa25 with SMTP id
 s8-20020a056a0008c800b0052c887dfa25mr27953088pfu.86.1660144846015; Wed, 10
 Aug 2022 08:20:46 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:27 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-6-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 05/11] KVM: selftests: add support for encrypted vm_vaddr_* allocations
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

The default policy for whether to handle allocations as encrypted or
shared pages is currently determined by vm_phy_pages_alloc(), which in
turn uses the policy defined by vm->memcrypt.enc_by_default.

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since enc_by_default will be true in the
case of SEV guests (since it's required in order to have the initial
ELF binary and page table become part of the initial guest payload), an
interface is needed to explicitly request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index de769b3de274..8ce9e5be70a3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -390,6 +390,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 87772e23d1b5..4e4b28e4e890 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1262,12 +1262,13 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 }
 
 /*
- * VM Virtual Address Allocate
+ * VM Virtual Address Allocate Shared/Encrypted
  *
  * Input Args:
  *   vm - Virtual Machine
  *   sz - Size in bytes
  *   vaddr_min - Minimum starting virtual address
+ *   encrypt - Whether the region should be handled as encrypted
  *
  * Output Args: None
  *
@@ -1280,13 +1281,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+static vm_vaddr_t
+_vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min, bool encrypt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
+					       KVM_UTIL_MIN_PFN * vm->page_size,
+					       0, encrypt);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1307,6 +1310,16 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, vm->memcrypt.enc_by_default);
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return _vm_vaddr_alloc(vm, sz, vaddr_min, false);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
-- 
2.37.1.559.g78731f0fdb-goog


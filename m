Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48CB5A52D0
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiH2RLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiH2RK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:10:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B445D63F24
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:56 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso3532092pjh.6
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=6LTZwMRrvDfqpVLhhHWZqp+4pXfvnPC22KdqKnuCz/0=;
        b=FocFynqOz+suSfkXv90fdFT1W9TWPO5+CnSrEiXMlB57S0wcKJv+jvfvOofZBhm9x4
         yCLrY0dFO/JMl8SdBgSGb5NRShYPh7u4NGUVyZCV6z+xdj4Iu90vHNEX1zK9sox2LJ8R
         7k9EgEMEG0NJeJbu1Txz/SfpvSybz5ZLIF/Xz+RRrzF2JowSk1+J6bJyFd51csJyA4lk
         QGEZDHZ2n9ga9yH5EbMoSzPZNyLk5Eztd/481pJk3ZowGknw09ehKoaBWkvew4jNaVtQ
         dZyjO6oBL5yaPgPgmIq6N7u1jeM1eq9APXSdnvDlp/ersUD2kcYMNf7g1Dn75Xgp7cWk
         JGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=6LTZwMRrvDfqpVLhhHWZqp+4pXfvnPC22KdqKnuCz/0=;
        b=wlmFZLSii0Ekx5YIK1JICi8xBq/5KMYUiHH5BQUir3TZ4JZ6tVPGKHOWKN8bNJkq5F
         bP5YVnmRRkNEyo43ZLB0134aVdVr8qTMjtpRxVK8DzO022L3a7LR+sm5TNCIf4gxit3s
         ZTKmVH6c/l3XbYxnJeDDzSGgmGVV9oL26lZpm7Ya6at7e2fcWLooTcneR3L8t+jTrOeN
         2XnMICWaz2kTjJn0QeDOqnazBNNQ8exTm59pF6pu3m5Fui1OJfKJtBw86INVJ6HhrtjN
         wvmhqz0LB4rlGjaPxTULCbwFheV3ZABFYXH2q49wQgc6GDm6t2c1TPiNL1PxFyG8uvXM
         VDEQ==
X-Gm-Message-State: ACgBeo1xmG3ItBTQk+F50d1Pe2O8H9BUHV1+aLt641ACXF0a9RaQH7DC
        +UrKUJfhpLfQ7GRTRA9fGKRzgQ6WRnse2xRIMXKGLbDOLHRkA4K5133vgm4HyedKdSJoAhwBdx3
        YfQIrEwAdF/Ap2DRQou0B46CHS6POWwKkCI5X86bYkpsmygmasas48mCIYw==
X-Google-Smtp-Source: AA6agR6IqZl5qv/5ZTSiHIBpwhrLC/OmUBFjrSuFkk6YDx0C/Z3kfJ6vgNlEMzo+GLzONevvYYx6/tL7SKc=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a63:e507:0:b0:42c:65d3:f3b6 with SMTP id
 r7-20020a63e507000000b0042c65d3f3b6mr1935660pgh.395.1661793056160; Mon, 29
 Aug 2022 10:10:56 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:16 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-4-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 3/8] KVM: selftests: add hooks for managing encrypted guest memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
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

From: Michael Roth <michael.roth@amd.com>

VM implementations that make use of encrypted memory need a way to
configure things like the encryption/shared bit position for page
table handling, the default encryption policy for internal allocations
made by the core library, and a way to fetch the list/bitmap of
encrypted pages to do the actual memory encryption. Add an interface to
configure these parameters. Also introduce a sparsebit map to track
allocations/mappings that should be treated as encrypted, and provide
a way for VM implementations to retrieve it to handle operations
related memory encryption.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 17 ++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 52 +++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 59d52b58a1a6..5ecde5ad4c2f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -33,6 +33,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *encrypted_phy_pages;
 	int fd;
 	off_t offset;
 	void *host_mem;
@@ -65,6 +66,14 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+/* Memory encryption policy/configuration. */
+struct vm_memcrypt {
+	bool enabled;
+	int8_t enc_by_default;
+	bool has_enc_bit;
+	int8_t enc_bit;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -89,6 +98,7 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	struct vm_memcrypt memcrypt;
 
 	/* Cache of information for binary stats interface */
 	int stats_fd;
@@ -849,4 +859,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
+			      uint8_t enc_bit);
+
+const struct sparsebit *vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot,
+						   vm_paddr_t *gpa_start,
+						   uint64_t *size);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 06559994711e..53b9a509c1d5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -553,6 +553,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->encrypted_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
@@ -893,6 +894,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	region->encrypted_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1108,6 +1110,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
+ *   encrypt - Whether to treat the pages as encrypted
  *
  * Output Args: None
  *
@@ -1119,8 +1122,9 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+static vm_paddr_t
+_vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, vm_paddr_t paddr_min,
+		    uint32_t memslot, bool encrypt)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1152,12 +1156,22 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (encrypt)
+			sparsebit_set(region->encrypted_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+				   vm->memcrypt.enc_by_default);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
@@ -1741,6 +1755,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (vm->memcrypt.enabled) {
+			fprintf(stream, "%*sencrypted_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->encrypted_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -1989,3 +2007,31 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
+			      uint8_t enc_bit)
+{
+	vm->memcrypt.enabled = true;
+	vm->memcrypt.enc_by_default = enc_by_default;
+	vm->memcrypt.has_enc_bit = has_enc_bit;
+	vm->memcrypt.enc_bit = enc_bit;
+}
+
+const struct sparsebit *
+vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot, vm_paddr_t *gpa_start,
+			   uint64_t *size)
+{
+	struct userspace_mem_region *region;
+
+	if (!vm->memcrypt.enabled)
+		return NULL;
+
+	region = memslot2region(vm, slot);
+	if (!region)
+		return NULL;
+
+	*size = region->region.memory_size;
+	*gpa_start = region->region.guest_phys_addr;
+
+	return region->encrypted_phy_pages;
+}
-- 
2.37.2.672.g94769d06f0-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571E450A586
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiDUQdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390597AbiDUQdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4153448883
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650558509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D3OVcmZyD5fQf7XMBGl6jNoW5Atc9YkshU+4HcOs24k=;
        b=FKr+USxDcPidGpP86Xg3zI2CuNkLnfOxmDiZKKlw3ayIErYdUTTXOAtnNMLicNqx+hrNj6
        DvJS5sxbk4eoFh36bOZCN2JPpHsB32qCScm+KQBVCusV66eGC8DSnokGieLJDwLMhpbf0c
        aZ5yQ/3u2MfEyPw7D+o5Nq/OZ/E/qzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-o9QRIk8dPoudnJQi56rPlA-1; Thu, 21 Apr 2022 12:28:26 -0400
X-MC-Unique: o9QRIk8dPoudnJQi56rPlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6DD883395E;
        Thu, 21 Apr 2022 16:28:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33CA145BA53;
        Thu, 21 Apr 2022 16:28:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, seanjc@google.com
Subject: [PATCH 2/2] kvm: selftests: introduce and use more page size-related constants
Date:   Thu, 21 Apr 2022 12:28:25 -0400
Message-Id: <20220421162825.1412792-3-pbonzini@redhat.com>
In-Reply-To: <20220421162825.1412792-1-pbonzini@redhat.com>
References: <20220421162825.1412792-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up code that was hardcoding masks for various fields,
now that the masks are included in processor.h.

For more cleanup, define PAGE_SIZE and PAGE_MASK just like in Linux.
PAGE_SIZE in particular was defined by several tests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 12 ++++++------
 tools/testing/selftests/kvm/x86_64/amx_test.c        |  1 -
 .../selftests/kvm/x86_64/emulator_error_test.c       |  1 -
 tools/testing/selftests/kvm/x86_64/smm_test.c        |  2 --
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c       |  1 -
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c |  1 -
 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c |  1 -
 8 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 86e79af64dea..d0d51adec76e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -71,6 +71,8 @@
 #define PTE_NX_MASK             BIT_ULL(63)
 
 #define PAGE_SHIFT		12
+#define PAGE_SIZE		(1ULL << PAGE_SHIFT)
+#define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
 #define PTE_GET_PFN(pte)        (((pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 0dd442c26015..33ea5e9955d9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -255,13 +255,13 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_sregs sregs;
 	int max_phy_addr;
-	/* Set the bottom 52 bits. */
-	uint64_t rsvd_mask = 0x000fffffffffffff;
+	uint64_t rsvd_mask = 0;
 
 	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
 	max_phy_addr = entry->eax & 0x000000ff;
-	/* Clear the bottom bits of the reserved mask. */
-	rsvd_mask = (rsvd_mask >> max_phy_addr) << max_phy_addr;
+	/* Set the high bits in the reserved mask. */
+	if (max_phy_addr < 52)
+		rsvd_mask = GENMASK_ULL(51, max_phy_addr);
 
 	/*
 	 * SDM vol 3, fig 4-11 "Formats of CR3 and Paging-Structure Entries
@@ -271,7 +271,7 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
 	 */
 	vcpu_sregs_get(vm, vcpuid, &sregs);
 	if ((sregs.efer & EFER_NX) == 0) {
-		rsvd_mask |= (1ull << 63);
+		rsvd_mask |= PTE_NX_MASK;
 	}
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
@@ -549,7 +549,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!(pte[index[0]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & 0xfffu);
+	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 52a3ef6629e8..76f65c22796f 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -29,7 +29,6 @@
 #define X86_FEATURE_XSAVE		(1 << 26)
 #define X86_FEATURE_OSXSAVE		(1 << 27)
 
-#define PAGE_SIZE			(1 << 12)
 #define NUM_TILES			8
 #define TILE_SIZE			1024
 #define XSAVE_SIZE			((NUM_TILES * TILE_SIZE) + PAGE_SIZE)
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index f070ff0224fa..aeb3850f81bd 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -12,7 +12,6 @@
 #include "vmx.h"
 
 #define VCPU_ID	   1
-#define PAGE_SIZE  4096
 #define MAXPHYADDR 36
 
 #define MEM_REGION_GVA	0x0000123456789000
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index a626d40fdb48..b4e0c860769e 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -21,8 +21,6 @@
 
 #define VCPU_ID	      1
 
-#define PAGE_SIZE  4096
-
 #define SMRAM_SIZE 65536
 #define SMRAM_MEMSLOT ((1 << 16) | 1)
 #define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index e683d0ac3e45..19b35c607dc6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -32,7 +32,6 @@
 #define MSR_IA32_TSC_ADJUST 0x3b
 #endif
 
-#define PAGE_SIZE	4096
 #define VCPU_ID		5
 
 #define TSC_ADJUST_VALUE (1ll << 32)
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 865e17146815..bcd370827859 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -23,7 +23,6 @@
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
-#define PAGE_SIZE		4096
 
 #define DUMMY_REGION_GPA	(SHINFO_REGION_GPA + (2 * PAGE_SIZE))
 #define DUMMY_REGION_SLOT	11
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index adc94452b57c..b30fe9de1d4f 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -15,7 +15,6 @@
 
 #define HCALL_REGION_GPA	0xc0000000ULL
 #define HCALL_REGION_SLOT	10
-#define PAGE_SIZE		4096
 
 static struct kvm_vm *vm;
 
-- 
2.31.1


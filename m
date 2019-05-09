Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA761970E
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEJD0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:26:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39939 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJD0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:26:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id d31so2269101pgl.7
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U2uVpmRk96wJlhxFMhGGmnUcggR0ktIHeFn8tAOrUXA=;
        b=Pxm7ttlaicaukRNDpFbuVn63aTM1/BNGX982Rz/JvNlVQTKBXN8A+zsN53KYfWzt/r
         UA2ZbxqJElI7c8rkVRJCVno19XBnsY7Ucyr5Eqyg89Q/yqFMEKPj+NFIKSe+/iTziFyu
         Ghz0WcWlr8QzvoAQkaQ35LGn3B/rTak6IMdOd9y/W3mhJiDBeBRAzumv4xnQqCbHVgwE
         by5LwUyPAkeUsKrJiMzKoD8SIFxsbvS9Lp2hFWCIt6AdhqiOhSloOppv5nlptrM9USgH
         jVn6nbwZqdgMKyeD3R6EfOlaGee9askj9lm0s2lHqHxfP0LYOl5vWSIlkIgTVAW55z6s
         COSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U2uVpmRk96wJlhxFMhGGmnUcggR0ktIHeFn8tAOrUXA=;
        b=Wtbyq0t5HSvww5Dw+S6ltFeK4Q9dRfp03slseZJVMqCFmHQACBaVp128Y6NZ69eh6u
         6T2Wadu4YkMIHYj0T1D4kallTb2WCJoE4EB+geGogV3Ka5fUNu1URjL6up+3d3rm3z7b
         1S6NxfjJL3Ywz5i9OjCRWCL3JIGWZCvh5j4+CgZjKl7bHGSBp8/aNffTZGiaw5hbf72b
         SzZxK5Tx3JubOpJQ9V+Jh/vBtzyvkEA/2h0Tx4YUJmFY7oAkgbNxixXqJxnVt7xvCVqu
         yk+ISxaCtj3LbH9WeJFUOsEKDAwQlIZfT5xTDrE/xcCsQTRV+nb4mvZVtVRTMc2bfSQI
         NlHQ==
X-Gm-Message-State: APjAAAVS0EdcIyAFRI68u+xSI4r43RsOCtCCK436av+qSo1PXs7oI3JB
        7H0/w7nSXBZ7cGtY+pOpWiE=
X-Google-Smtp-Source: APXvYqxMkJe9SO8GyICE5pCKPdPFKSrFu4DJ7odik7XCPHZahKiPXT556xqHnhuGGPwmYR5R0Xss/Q==
X-Received: by 2002:aa7:8296:: with SMTP id s22mr10969001pfm.52.1557458769491;
        Thu, 09 May 2019 20:26:09 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id z66sm5225592pfz.83.2019.05.09.20.26.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:26:08 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v3 2/4] x86: Remove redundant page zeroing
Date:   Thu,  9 May 2019 13:05:56 -0700
Message-Id: <20190509200558.12347-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509200558.12347-1-nadav.amit@gmail.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that alloc_page() zeros the page, remove the redundant page zeroing.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/intel-iommu.c    |  5 -----
 x86/eventinj.c           |  1 -
 x86/hyperv_connections.c |  4 ----
 x86/vmx.c                | 10 ----------
 x86/vmx_tests.c          | 11 -----------
 5 files changed, 31 deletions(-)

diff --git a/lib/x86/intel-iommu.c b/lib/x86/intel-iommu.c
index 3f3f211..c811ba5 100644
--- a/lib/x86/intel-iommu.c
+++ b/lib/x86/intel-iommu.c
@@ -125,7 +125,6 @@ static void vtd_setup_root_table(void)
 {
 	void *root = alloc_page();
 
-	memset(root, 0, PAGE_SIZE);
 	vtd_writeq(DMAR_RTADDR_REG, virt_to_phys(root));
 	vtd_gcmd_or(VTD_GCMD_ROOT);
 	printf("DMAR table address: %#018lx\n", vtd_root_table());
@@ -135,7 +134,6 @@ static void vtd_setup_ir_table(void)
 {
 	void *root = alloc_page();
 
-	memset(root, 0, PAGE_SIZE);
 	/* 0xf stands for table size (2^(0xf+1) == 65536) */
 	vtd_writeq(DMAR_IRTA_REG, virt_to_phys(root) | 0xf);
 	vtd_gcmd_or(VTD_GCMD_IR_TABLE);
@@ -153,7 +151,6 @@ static void vtd_install_pte(vtd_pte_t *root, iova_t iova,
 		offset = PGDIR_OFFSET(iova, level);
 		if (!(root[offset] & VTD_PTE_RW)) {
 			page = alloc_page();
-			memset(page, 0, PAGE_SIZE);
 			root[offset] = virt_to_phys(page) | VTD_PTE_RW;
 		}
 		root = (uint64_t *)(phys_to_virt(root[offset] &
@@ -195,7 +192,6 @@ void vtd_map_range(uint16_t sid, iova_t iova, phys_addr_t pa, size_t size)
 
 	if (!re->present) {
 		ce = alloc_page();
-		memset(ce, 0, PAGE_SIZE);
 		memset(re, 0, sizeof(*re));
 		re->context_table_p = virt_to_phys(ce) >> VTD_PAGE_SHIFT;
 		re->present = 1;
@@ -209,7 +205,6 @@ void vtd_map_range(uint16_t sid, iova_t iova, phys_addr_t pa, size_t size)
 
 	if (!ce->present) {
 		slptptr = alloc_page();
-		memset(slptptr, 0, PAGE_SIZE);
 		memset(ce, 0, sizeof(*ce));
 		/* To make it simple, domain ID is the same as SID */
 		ce->domain_id = sid;
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 8064eb9..d2dfc40 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -398,7 +398,6 @@ int main(void)
 
 	pt = alloc_page();
 	cr3 = (void*)read_cr3();
-	memset(pt, 0, 4096);
 	/* use shadowed stack during interrupt delivery */
 	for (i = 0; i < 4096/sizeof(ulong); i++) {
 		if (!cr3[i]) {
diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
index 5d541c9..8eade41 100644
--- a/x86/hyperv_connections.c
+++ b/x86/hyperv_connections.c
@@ -47,7 +47,6 @@ static void setup_hypercall(void)
 	hypercall_page = alloc_page();
 	if (!hypercall_page)
 		report_abort("failed to allocate hypercall page");
-	memset(hypercall_page, 0, PAGE_SIZE);
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, guestid);
 
@@ -105,9 +104,6 @@ static void setup_cpu(void *ctx)
 	hv->post_msg = alloc_page();
 	if (!hv->msg_page || !hv->evt_page || !hv->post_msg)
 		report_abort("failed to allocate synic pages for vcpu");
-	memset(hv->msg_page, 0, sizeof(*hv->msg_page));
-	memset(hv->evt_page, 0, sizeof(*hv->evt_page));
-	memset(hv->post_msg, 0, sizeof(*hv->post_msg));
 	hv->msg_conn = MSG_CONN_BASE + vcpu;
 	hv->evt_conn = EVT_CONN_BASE + vcpu;
 
diff --git a/x86/vmx.c b/x86/vmx.c
index be47800..962ec0f 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -353,7 +353,6 @@ static void test_vmwrite_vmread(void)
 	struct vmcs *vmcs = alloc_page();
 	u32 vmcs_enum_max, max_index = 0;
 
-	memset(vmcs, 0, PAGE_SIZE);
 	vmcs->hdr.revision_id = basic.revision;
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
@@ -373,7 +372,6 @@ static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
 
-	memset(vmcs, 0, PAGE_SIZE);
 	vmcs->hdr.revision_id = basic.revision;
 	assert(!vmcs_clear(vmcs));
 	assert(!make_vmcs_current(vmcs));
@@ -400,7 +398,6 @@ static void test_vmcs_lifecycle(void)
 
 	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
 		vmcs[i] = alloc_page();
-		memset(vmcs[i], 0, PAGE_SIZE);
 		vmcs[i]->hdr.revision_id = basic.revision;
 	}
 
@@ -647,7 +644,6 @@ static void test_vmclear_flushing(void)
 
 	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
 		vmcs[i] = alloc_page();
-		memset(vmcs[i], 0, PAGE_SIZE);
 	}
 
 	vmcs[0]->hdr.revision_id = basic.revision;
@@ -745,7 +741,6 @@ static void split_large_ept_entry(unsigned long *ptep, int level)
 
 	new_pt = alloc_page();
 	assert(new_pt);
-	memset(new_pt, 0, PAGE_SIZE);
 
 	prototype = pte & ~EPT_ADDR_MASK;
 	if (level == 2)
@@ -1220,7 +1215,6 @@ static void init_vmcs_guest(void)
 static int init_vmcs(struct vmcs **vmcs)
 {
 	*vmcs = alloc_page();
-	memset(*vmcs, 0, PAGE_SIZE);
 	(*vmcs)->hdr.revision_id = basic.revision;
 	/* vmclear first to init vmcs */
 	if (vmcs_clear(*vmcs)) {
@@ -1259,7 +1253,6 @@ static void init_vmx(void)
 	ulong fix_cr4_set, fix_cr4_clr;
 
 	vmxon_region = alloc_page();
-	memset(vmxon_region, 0, PAGE_SIZE);
 
 	vmcs_root = alloc_page();
 
@@ -1291,9 +1284,7 @@ static void init_vmx(void)
 	*vmxon_region = basic.revision;
 
 	guest_stack = alloc_page();
-	memset(guest_stack, 0, PAGE_SIZE);
 	guest_syscall_stack = alloc_page();
-	memset(guest_syscall_stack, 0, PAGE_SIZE);
 }
 
 static void do_vmxon_off(void *data)
@@ -1420,7 +1411,6 @@ static void test_vmptrst(void)
 	struct vmcs *vmcs1, *vmcs2;
 
 	vmcs1 = alloc_page();
-	memset(vmcs1, 0, PAGE_SIZE);
 	init_vmcs(&vmcs1);
 	ret = vmcs_save(&vmcs2);
 	report("test vmptrst", (!ret) && (vmcs1 == vmcs2));
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2d6b12d..c52ebc6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -253,7 +253,6 @@ static void msr_bmp_init(void)
 	u32 ctrl_cpu0;
 
 	msr_bitmap = alloc_page();
-	memset(msr_bitmap, 0x0, PAGE_SIZE);
 	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
 	ctrl_cpu0 |= CPU_MSR_BITMAP;
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
@@ -627,8 +626,6 @@ static int iobmp_init(struct vmcs *vmcs)
 
 	io_bitmap_a = alloc_page();
 	io_bitmap_b = alloc_page();
-	memset(io_bitmap_a, 0x0, PAGE_SIZE);
-	memset(io_bitmap_b, 0x0, PAGE_SIZE);
 	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
 	ctrl_cpu0 |= CPU_IO_BITMAP;
 	ctrl_cpu0 &= (~CPU_IO);
@@ -1062,8 +1059,6 @@ static int setup_ept(bool enable_ad)
 	if (__setup_ept(virt_to_phys(pml4), enable_ad))
 		return 1;
 
-	memset(pml4, 0, PAGE_SIZE);
-
 	end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
 	if (end_of_memory < (1ul << 32))
 		end_of_memory = (1ul << 32);
@@ -1135,8 +1130,6 @@ static int ept_init_common(bool have_ad)
 		return VMX_TEST_EXIT;
 	data_page1 = alloc_page();
 	data_page2 = alloc_page();
-	memset(data_page1, 0x0, PAGE_SIZE);
-	memset(data_page2, 0x0, PAGE_SIZE);
 	*((u32 *)data_page1) = MAGIC_VAL_1;
 	*((u32 *)data_page2) = MAGIC_VAL_2;
 	install_ept(pml4, (unsigned long)data_page1, (unsigned long)data_page2,
@@ -1483,7 +1476,6 @@ static int pml_init(struct vmcs *vmcs)
 	}
 
 	pml_log = alloc_page();
-	memset(pml_log, 0x0, PAGE_SIZE);
 	vmcs_write(PMLADDR, (u64)pml_log);
 	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 
@@ -1908,9 +1900,6 @@ static int msr_switch_init(struct vmcs *vmcs)
 	exit_msr_store = alloc_page();
 	exit_msr_load = alloc_page();
 	entry_msr_load = alloc_page();
-	memset(exit_msr_store, 0, PAGE_SIZE);
-	memset(exit_msr_load, 0, PAGE_SIZE);
-	memset(entry_msr_load, 0, PAGE_SIZE);
 	entry_msr_load[0].index = MSR_KERNEL_GS_BASE;
 	entry_msr_load[0].value = MSR_MAGIC;
 
-- 
2.17.1


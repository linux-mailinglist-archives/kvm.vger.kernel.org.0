Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDD877CBF5
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 13:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbjHOLqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbjHOLqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 07:46:15 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B122171F
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 04:46:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-56546b45f30so4056716a12.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692099973; x=1692704773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5CUEWLRkmcz9dl+6zkpGHt4iS84n2REgzhbh4Pkk43E=;
        b=KJ4SPp16dQRhqPSCOI7yGNVPdscjTmnCd2TJYI8cE8aY4uYnfRZMVyPuxHzDGg7VYe
         hUGHpuIaSiq2bS4E+puPqCHMyQz7dz6yc5BbBaGHxz4CcNbXF9+id4vCOK2lFyDV+FQ0
         lJQmuDI50icYIjniqD1WAk/jwVugQTXzQGBldRVk5MHCkBbFynKmroyI0lvET1t1RH++
         UeKnvxgCTuzLKnSEHlxSrZCHWDgxs0vTSzQvkdccTcdCABZSoEakUVfICq9czSHUMX8C
         Zj68lv4dOtCHD7v1xxfMQtthhT5YnmT9oBsyUeTBpfDHZMmNbYNQZO58W6JTsun9PP/W
         bSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692099973; x=1692704773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5CUEWLRkmcz9dl+6zkpGHt4iS84n2REgzhbh4Pkk43E=;
        b=jeUrwReUg2NzH+d/hze67GJ6dm4mpJbMoHQp/7pdGLPB581OEYKhh5TMgz5hdGG2HP
         gEvxCAK2H2tFa1i4sbm/T0GAUEqlLmCK1JRkBEmfqaR6dq9JL8Ty/mA18y1oITLDplGq
         XAFD/dnsv7uACT/iBVs0tOaXQSgePkVZDws20SSYNdyOLfN5prwlEjjlj+TmWUhu27th
         QuuBcJ5WZQBNUM0SNOJNUAdE9E6D+/ykr0MalSF42Zu6jhILdx+DhzytwvrJVfzkin1U
         c/UHIpqUSdK6/gsaZT0zo1Fcgxc4gVeDXuU05eWP2JG6TJKqYq8YOPN3x+6+iWGUyEmY
         UFKA==
X-Gm-Message-State: AOJu0YyoVZxx9hj9Yd9vpbB6PVBbGLjO4abPnY8NsYDsg1zixduGopPQ
        ummDqeGbHJ9+lIJ6b7Ia6Oc=
X-Google-Smtp-Source: AGHT+IGDZUMUTJ/4MQXvUCwwoS7qrhc2aLljOfKYkglcEnbD4XbZEPBpcSDj0q+qYM0jwSup3aSvfA==
X-Received: by 2002:a17:90b:796:b0:268:2b5c:14d with SMTP id l22-20020a17090b079600b002682b5c014dmr10493168pjz.36.1692099973352;
        Tue, 15 Aug 2023 04:46:13 -0700 (PDT)
Received: from debian.butcher ([103.46.203.2])
        by smtp.googlemail.com with ESMTPSA id x23-20020a17090a789700b0026833291740sm11168964pjk.46.2023.08.15.04.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 04:46:13 -0700 (PDT)
From:   Mohammad Natiq Khan <natiqk91@gmail.com>
To:     tglx@linutronix.de
Cc:     bp@alien8.de, kvm@vger.kernel.org,
        Mohammad Natiq Khan <natiqk91@gmail.com>
Subject: [PATCH] kvm/mmu: fixed coding style issues
Date:   Tue, 15 Aug 2023 17:14:49 +0530
Message-Id: <20230815114448.14777-1-natiqk91@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initializing global variable to 0 or false is not necessary and should
be avoided. Issue reported by checkpatch script as:
ERROR: do not initialise globals to 0 (or false).
Along with some other warnings like:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Signed-off-by: Mohammad Natiq Khan <natiqk91@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 105 +++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..8d6578782652 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -64,7 +64,7 @@ int __read_mostly nx_huge_pages = -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
-static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
+static uint __read_mostly nx_huge_pages_recovery_ratio;
 #else
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
@@ -102,7 +102,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * 2. while doing 1. it walks guest-physical to host-physical
  * If the hardware supports that we don't need to do shadow paging.
  */
-bool tdp_enabled = false;
+bool tdp_enabled;
 
 static bool __ro_after_init tdp_mmu_allowed;
 
@@ -116,7 +116,7 @@ static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
 #ifdef MMU_DEBUG
-bool dbg = 0;
+bool dbg;
 module_param(dbg, bool, 0644);
 #endif
 
@@ -161,7 +161,7 @@ struct kvm_shadow_walk_iterator {
 	hpa_t shadow_addr;
 	u64 *sptep;
 	int level;
-	unsigned index;
+	unsigned int index;
 };
 
 #define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
@@ -240,12 +240,12 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
 
 static inline bool is_cr0_pg(struct kvm_mmu *mmu)
 {
-        return mmu->cpu_role.base.level > 0;
+	return mmu->cpu_role.base.level > 0;
 }
 
 static inline bool is_cr4_pae(struct kvm_mmu *mmu)
 {
-        return !mmu->cpu_role.base.has_4_byte_gpte;
+	return !mmu->cpu_role.base.has_4_byte_gpte;
 }
 
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
@@ -320,7 +320,7 @@ static gfn_t get_mmio_spte_gfn(u64 spte)
 	return gpa >> PAGE_SHIFT;
 }
 
-static unsigned get_mmio_spte_access(u64 spte)
+static unsigned int get_mmio_spte_access(u64 spte)
 {
 	return spte & shadow_mmio_access_mask;
 }
@@ -772,14 +772,14 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
 	}
 
 	WARN_ONCE(access != kvm_mmu_page_get_access(sp, index),
-	          "access mismatch under %s page %llx (expected %u, got %u)\n",
-	          sp->role.passthrough ? "passthrough" : "direct",
-	          sp->gfn, kvm_mmu_page_get_access(sp, index), access);
+			"access mismatch under %s page %llx (expected %u, got %u)\n",
+			sp->role.passthrough ? "passthrough" : "direct",
+			sp->gfn, kvm_mmu_page_get_access(sp, index), access);
 
 	WARN_ONCE(gfn != kvm_mmu_page_get_gfn(sp, index),
-	          "gfn mismatch under %s page %llx (expected %llx, got %llx)\n",
-	          sp->role.passthrough ? "passthrough" : "direct",
-	          sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
+			"gfn mismatch under %s page %llx (expected %llx, got %llx)\n",
+			sp->role.passthrough ? "passthrough" : "direct",
+			sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
 static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
@@ -1719,7 +1719,7 @@ static int is_empty_shadow_page(u64 *spt)
 	for (pos = spt, end = pos + SPTE_ENT_PER_PAGE; pos != end; pos++)
 		if (is_shadow_present_pte(*pos)) {
 			printk(KERN_ERR "%s: %p %llx\n", __func__,
-			       pos, *pos);
+					pos, *pos);
 			return 0;
 		}
 	return 1;
@@ -1761,7 +1761,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
-static unsigned kvm_page_table_hashfn(gfn_t gfn)
+static unsigned int kvm_page_table_hashfn(gfn_t gfn)
 {
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
@@ -1827,7 +1827,7 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 	int i;
 
 	if (sp->unsync)
-		for (i=0; i < pvec->nr; i++)
+		for (i = 0; i < pvec->nr; i++)
 			if (pvec->page[i].sp == sp)
 				return 0;
 
@@ -1933,7 +1933,6 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
-
 	/*
 	 * Ignore various flags when verifying that it's safe to sync a shadow
 	 * page using the current MMU context.
@@ -2040,7 +2039,7 @@ struct mmu_page_path {
 
 #define for_each_sp(pvec, sp, parents, i)			\
 		for (i = mmu_pages_first(&pvec, &parents);	\
-			i < pvec.nr && ({ sp = pvec.page[i].sp; 1;});	\
+			i < pvec.nr && ({ sp = pvec.page[i].sp; 1; });	\
 			i = mmu_pages_next(&pvec, &parents, i))
 
 static int mmu_pages_next(struct kvm_mmu_pages *pvec,
@@ -2051,7 +2050,7 @@ static int mmu_pages_next(struct kvm_mmu_pages *pvec,
 
 	for (n = i+1; n < pvec->nr; n++) {
 		struct kvm_mmu_page *sp = pvec->page[n].sp;
-		unsigned idx = pvec->page[n].idx;
+		unsigned int idx = pvec->page[n].idx;
 		int level = sp->role.level;
 
 		parents->idx[level-1] = idx;
@@ -2095,6 +2094,7 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 
 	do {
 		unsigned int idx = parents->idx[level];
+	
 		sp = parents->parent[level];
 		if (!sp)
 			return;
@@ -2483,7 +2483,7 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 }
 
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-				   unsigned direct_access)
+				   unsigned int direct_access)
 {
 	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
 		struct kvm_mmu_page *child;
@@ -2540,7 +2540,7 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 					struct list_head *invalid_list)
 {
 	int zapped = 0;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; ++i)
 		zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
@@ -3707,7 +3707,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->root_role.level;
 	hpa_t root;
-	unsigned i;
+	unsigned int i;
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
@@ -4048,6 +4048,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root.hpa;
+		
 		sp = to_shadow_page(root);
 
 		if (!is_unsync_root(root))
@@ -4986,7 +4987,7 @@ reset_ept_shadow_zero_bits_mask(struct kvm_mmu *context, bool execonly)
 
 static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 {
-	unsigned byte;
+	unsigned int byte;
 
 	const u8 x = BYTE_MASK(ACC_EXEC_MASK);
 	const u8 w = BYTE_MASK(ACC_WRITE_MASK);
@@ -4998,7 +4999,7 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 	bool efer_nx = is_efer_nx(mmu);
 
 	for (byte = 0; byte < ARRAY_SIZE(mmu->permissions); ++byte) {
-		unsigned pfec = byte << 1;
+		unsigned int pfec = byte << 1;
 
 		/*
 		 * Each "*f" variable has a 1 bit for each UWX value
@@ -5057,32 +5058,32 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 }
 
 /*
-* PKU is an additional mechanism by which the paging controls access to
-* user-mode addresses based on the value in the PKRU register.  Protection
-* key violations are reported through a bit in the page fault error code.
-* Unlike other bits of the error code, the PK bit is not known at the
-* call site of e.g. gva_to_gpa; it must be computed directly in
-* permission_fault based on two bits of PKRU, on some machine state (CR4,
-* CR0, EFER, CPL), and on other bits of the error code and the page tables.
-*
-* In particular the following conditions come from the error code, the
-* page tables and the machine state:
-* - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
-* - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
-* - PK is always zero if U=0 in the page tables
-* - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
-*
-* The PKRU bitmask caches the result of these four conditions.  The error
-* code (minus the P bit) and the page table's U bit form an index into the
-* PKRU bitmask.  Two bits of the PKRU bitmask are then extracted and ANDed
-* with the two bits of the PKRU register corresponding to the protection key.
-* For the first three conditions above the bits will be 00, thus masking
-* away both AD and WD.  For all reads or if the last condition holds, WD
-* only will be masked away.
-*/
+ * PKU is an additional mechanism by which the paging controls access to
+ * user-mode addresses based on the value in the PKRU register.  Protection
+ * key violations are reported through a bit in the page fault error code.
+ * Unlike other bits of the error code, the PK bit is not known at the
+ * call site of e.g. gva_to_gpa; it must be computed directly in
+ * permission_fault based on two bits of PKRU, on some machine state (CR4,
+ * CR0, EFER, CPL), and on other bits of the error code and the page tables.
+ *
+ * In particular the following conditions come from the error code, the
+ * page tables and the machine state:
+ * - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
+ * - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
+ * - PK is always zero if U=0 in the page tables
+ * - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
+ *
+ * The PKRU bitmask caches the result of these four conditions.  The error
+ * code (minus the P bit) and the page table's U bit form an index into the
+ * PKRU bitmask.  Two bits of the PKRU bitmask are then extracted and ANDed
+ * with the two bits of the PKRU register corresponding to the protection key.
+ * For the first three conditions above the bits will be 00, thus masking
+ * away both AD and WD.  For all reads or if the last condition holds, WD
+ * only will be masked away.
+ */
 static void update_pkru_bitmask(struct kvm_mmu *mmu)
 {
-	unsigned bit;
+	unsigned int bit;
 	bool wp;
 
 	mmu->pkru_mask = 0;
@@ -5093,7 +5094,7 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 	wp = is_cr0_wp(mmu);
 
 	for (bit = 0; bit < ARRAY_SIZE(mmu->permissions); ++bit) {
-		unsigned pfec, pkey_bits;
+		unsigned int pfec, pkey_bits;
 		bool check_pkey, check_write, ff, uf, wf, pte_user;
 
 		pfec = bit << 1;
@@ -5632,7 +5633,7 @@ static bool detect_write_flooding(struct kvm_mmu_page *sp)
 static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 				    int bytes)
 {
-	unsigned offset, pte_size, misaligned;
+	unsigned int offset, pte_size, misaligned;
 
 	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 		 gpa, bytes, sp->role.word);
@@ -5655,7 +5656,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 
 static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 {
-	unsigned page_offset, quadrant;
+	unsigned int page_offset, quadrant;
 	u64 *spte;
 	int level;
 
@@ -5736,7 +5737,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
+noinline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-- 
2.40.1


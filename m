Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2374C1B6
	for <lists+kvm@lfdr.de>; Sun,  9 Jul 2023 11:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjGIJhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jul 2023 05:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjGIJhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jul 2023 05:37:32 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17887194
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 02:37:30 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4QzMVR6JZ0zBJk4n
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 17:37:19 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1688895439; x=1691487440; bh=QvxCOEycc/QYyn3xclPRD10mRyn
        QaD19qhvQIXlhbT0=; b=0mzb9vuaj2PX/2nIiv1kCK4sbBZ5lbbevxtAHcWaNaU
        3U4rFeRaAIyYrbrke7AtaHPG4KnnLrWQTD10OB0rIXpMTjd0ROw5B7KbQNXhm2Gt
        BPGdqIc0be97Cxo17if9I939X26lJ8G6ncTO7jbndxS73u46qJD7KhqtJjnjC4Lz
        byzGxOiFa0ThK7XY7Rmv8Vry76I8PpHm55oZXW41WnSjX47+5N9p14bCpIYVTS2I
        liK0ayKCMODTizFDFVu9RAh6PP/ogRXFRnmFvYO8pJ83BQO1svhboCjk2rJOJht9
        ty9DVMgMYban2cpgbg6SJGs5mMHPFcysa3PSmlia61g==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id a8h2NPpYzLg3 for <kvm@vger.kernel.org>;
        Sun,  9 Jul 2023 17:37:19 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4QzMVQ71SHzBJBgJ;
        Sun,  9 Jul 2023 17:37:18 +0800 (CST)
MIME-Version: 1.0
Date:   Sun, 09 Jul 2023 17:37:18 +0800
From:   xuanzhenggang001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: prefer 'unsigned int' to bare use of 'unsigned'
In-Reply-To: <20230709093359.30916-1-denghuilong@cdjrlc.com>
References: <20230709093359.30916-1-denghuilong@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <d420c049eb9a3d499769b72adc575781@208suo.com>
X-Sender: xuanzhenggang001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following warnings reported by checkpatch:

arch/x86/kvm/mmu/mmu.c:161: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:320: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:1761: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:2051: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:2483: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:2540: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:3707: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:4986: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:4998: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:5082: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:5093: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:5632: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'
arch/x86/kvm/mmu/mmu.c:5655: WARNING: Prefer 'unsigned int' to bare use 
of 'unsigned'

Signed-off-by: Zhenggang Xuan <xuanzhenggang001@208suo.com>
---
  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
  1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 262b84763f35..b58da7845783 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -158,7 +158,7 @@ struct kvm_shadow_walk_iterator {
      hpa_t shadow_addr;
      u64 *sptep;
      int level;
-    unsigned index;
+    unsigned int index;
  };

  #define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)  
    \
@@ -317,7 +317,7 @@ static gfn_t get_mmio_spte_gfn(u64 spte)
      return gpa >> PAGE_SHIFT;
  }

-static unsigned get_mmio_spte_access(u64 spte)
+static unsigned int get_mmio_spte_access(u64 spte)
  {
      return spte & shadow_mmio_access_mask;
  }
@@ -1758,7 +1758,7 @@ static void kvm_mmu_free_shadow_page(struct 
kvm_mmu_page *sp)
      kmem_cache_free(mmu_page_header_cache, sp);
  }

-static unsigned kvm_page_table_hashfn(gfn_t gfn)
+static unsigned int kvm_page_table_hashfn(gfn_t gfn)
  {
      return hash_64(gfn, KVM_MMU_HASH_SHIFT);
  }
@@ -2048,7 +2048,7 @@ static int mmu_pages_next(struct kvm_mmu_pages 
*pvec,

      for (n = i+1; n < pvec->nr; n++) {
          struct kvm_mmu_page *sp = pvec->page[n].sp;
-        unsigned idx = pvec->page[n].idx;
+        unsigned int idx = pvec->page[n].idx;
          int level = sp->role.level;

          parents->idx[level-1] = idx;
@@ -2480,7 +2480,7 @@ static void link_shadow_page(struct kvm_vcpu 
*vcpu, u64 *sptep,
  }

  static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-                   unsigned direct_access)
+                   unsigned int direct_access)
  {
      if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
          struct kvm_mmu_page *child;
@@ -2537,7 +2537,7 @@ static int kvm_mmu_page_unlink_children(struct kvm 
*kvm,
                      struct list_head *invalid_list)
  {
      int zapped = 0;
-    unsigned i;
+    unsigned int i;

      for (i = 0; i < SPTE_ENT_PER_PAGE; ++i)
          zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
@@ -3704,7 +3704,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu 
*vcpu)
      struct kvm_mmu *mmu = vcpu->arch.mmu;
      u8 shadow_root_level = mmu->root_role.level;
      hpa_t root;
-    unsigned i;
+    unsigned int i;
      int r;

      write_lock(&vcpu->kvm->mmu_lock);
@@ -4983,7 +4983,7 @@ reset_ept_shadow_zero_bits_mask(struct kvm_mmu 
*context, bool execonly)

  static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
  {
-    unsigned byte;
+    unsigned int byte;

      const u8 x = BYTE_MASK(ACC_EXEC_MASK);
      const u8 w = BYTE_MASK(ACC_WRITE_MASK);
@@ -4995,7 +4995,7 @@ static void update_permission_bitmask(struct 
kvm_mmu *mmu, bool ept)
      bool efer_nx = is_efer_nx(mmu);

      for (byte = 0; byte < ARRAY_SIZE(mmu->permissions); ++byte) {
-        unsigned pfec = byte << 1;
+        unsigned int pfec = byte << 1;

          /*
           * Each "*f" variable has a 1 bit for each UWX value
@@ -5079,7 +5079,7 @@ static void update_permission_bitmask(struct 
kvm_mmu *mmu, bool ept)
  */
  static void update_pkru_bitmask(struct kvm_mmu *mmu)
  {
-    unsigned bit;
+    unsigned int bit;
      bool wp;

      mmu->pkru_mask = 0;
@@ -5090,7 +5090,7 @@ static void update_pkru_bitmask(struct kvm_mmu 
*mmu)
      wp = is_cr0_wp(mmu);

      for (bit = 0; bit < ARRAY_SIZE(mmu->permissions); ++bit) {
-        unsigned pfec, pkey_bits;
+        unsigned int pfec, pkey_bits;
          bool check_pkey, check_write, ff, uf, wf, pte_user;

          pfec = bit << 1;
@@ -5629,7 +5629,7 @@ static bool detect_write_flooding(struct 
kvm_mmu_page *sp)
  static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
                      int bytes)
  {
-    unsigned offset, pte_size, misaligned;
+    unsigned int offset, pte_size, misaligned;

      pgprintk("misaligned: gpa %llx bytes %d role %x\n",
           gpa, bytes, sp->role.word);
@@ -5652,7 +5652,7 @@ static bool detect_write_misaligned(struct 
kvm_mmu_page *sp, gpa_t gpa,

  static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int 
*nspte)
  {
-    unsigned page_offset, quadrant;
+    unsigned int page_offset, quadrant;
      u64 *spte;
      int level;

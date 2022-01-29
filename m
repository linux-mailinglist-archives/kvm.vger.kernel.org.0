Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B414A31F6
	for <lists+kvm@lfdr.de>; Sat, 29 Jan 2022 21:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353206AbiA2U60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jan 2022 15:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353175AbiA2U6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jan 2022 15:58:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26FAC061714;
        Sat, 29 Jan 2022 12:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=qDaqx4uPzigiZNs9b0PXl1R6NK3i5Wj+JiU5Hgbuaiw=; b=EIsHDgeS8OmzCpSP31tJgQWAoL
        OGrdQhBrOhDpYthHpbIdgc2YerBNjTRsi4e5NkcFOR7haNtNtauUeXbnvDpu9EzvqJkZ5CJha0b+Y
        Rzb3cRAHbwPA7RShEnnWF3Do5TOKuA8yVWg28sBML1GQl/nVmm3yqYAfpfyPjqLJu9Qy1KDGUn8s8
        rijx55saWJo3B1VzXe1D54Dydznk4pADR1HbpGXF+ei8ZWXpFTOyISBYLhTiSpRy2wzWFM0SUBsmE
        724IiLtCRhfqJ93H8ZFGQmSo2ZaWYdl34W3g/c7o9xcOm01TswfF0zr/uTye+xQVuJ3PkSxTkyII4
        WHbRVg/g==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nDune-005QDy-Or; Sat, 29 Jan 2022 20:58:22 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        James Hogan <jhogan@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] MIPS: KVM: fix vz.c kernel-doc notation
Date:   Sat, 29 Jan 2022 12:58:19 -0800
Message-Id: <20220129205819.23781-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix all kernel-doc warnings in mips/kvm/vz.c as reported by the
kernel test robot:

  arch/mips/kvm/vz.c:471: warning: Function parameter or member 'out_compare' not described in '_kvm_vz_save_htimer'
  arch/mips/kvm/vz.c:471: warning: Function parameter or member 'out_cause' not described in '_kvm_vz_save_htimer'
  arch/mips/kvm/vz.c:471: warning: Excess function parameter 'compare' description in '_kvm_vz_save_htimer'
  arch/mips/kvm/vz.c:471: warning: Excess function parameter 'cause' description in '_kvm_vz_save_htimer'
  arch/mips/kvm/vz.c:1551: warning: No description found for return value of 'kvm_trap_vz_handle_cop_unusable'
  arch/mips/kvm/vz.c:1552: warning: expecting prototype for kvm_trap_vz_handle_cop_unusuable(). Prototype was for kvm_trap_vz_handle_cop_unusable() instead
  arch/mips/kvm/vz.c:1597: warning: No description found for return value of 'kvm_trap_vz_handle_msa_disabled'

Fixes: c992a4f6a9b0 ("KVM: MIPS: Implement VZ support")
Fixes: f4474d50c7d4 ("KVM: MIPS/VZ: Support hardware guest timer")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: kvm@vger.kernel.org
---
 arch/mips/kvm/vz.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-next-20220128.orig/arch/mips/kvm/vz.c
+++ linux-next-20220128/arch/mips/kvm/vz.c
@@ -458,8 +458,8 @@ void kvm_vz_acquire_htimer(struct kvm_vc
 /**
  * _kvm_vz_save_htimer() - Switch to software emulation of guest timer.
  * @vcpu:	Virtual CPU.
- * @compare:	Pointer to write compare value to.
- * @cause:	Pointer to write cause value to.
+ * @out_compare: Pointer to write compare value to.
+ * @out_cause:	Pointer to write cause value to.
  *
  * Save VZ guest timer state and switch to software emulation of guest CP0
  * timer. The hard timer must already be in use, so preemption should be
@@ -1541,11 +1541,14 @@ static int kvm_trap_vz_handle_guest_exit
 }
 
 /**
- * kvm_trap_vz_handle_cop_unusuable() - Guest used unusable coprocessor.
+ * kvm_trap_vz_handle_cop_unusable() - Guest used unusable coprocessor.
  * @vcpu:	Virtual CPU context.
  *
  * Handle when the guest attempts to use a coprocessor which hasn't been allowed
  * by the root context.
+ *
+ * Return: value indicating whether to resume the host or the guest
+ * 	   (RESUME_HOST or RESUME_GUEST)
  */
 static int kvm_trap_vz_handle_cop_unusable(struct kvm_vcpu *vcpu)
 {
@@ -1592,6 +1595,9 @@ static int kvm_trap_vz_handle_cop_unusab
  *
  * Handle when the guest attempts to use MSA when it is disabled in the root
  * context.
+ *
+ * Return: value indicating whether to resume the host or the guest
+ * 	   (RESUME_HOST or RESUME_GUEST)
  */
 static int kvm_trap_vz_handle_msa_disabled(struct kvm_vcpu *vcpu)
 {

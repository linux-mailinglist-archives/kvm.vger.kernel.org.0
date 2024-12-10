Return-Path: <kvm+bounces-33350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BA49EA3C4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:48:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA949282F85
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736425674D;
	Tue, 10 Dec 2024 00:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQiLyMok"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9630D26AEC;
	Tue, 10 Dec 2024 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791674; cv=none; b=D7Rc2CD3oA44UxAGLT/Ago5pmFO3EZ3dsAO7iFao4apu64znKureKGp8pxOT0zpwGIC8EINhNs2JtHRC+XdQ0XFt5u5SYoYbVFlQVh9/n3fe2ytBX/hfbmtQE/JyJx1NNrghqLwJ3wsrpB9x7aNdpg/GCQyaPSRp1bVM7R++fMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791674; c=relaxed/simple;
	bh=ep4sns6fiJ21YowEfKsA+fUSVKFZ3KDavuMkAMgE58c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io/aUqPqYzlFIKh4hgrwY5kFJYkzOMPESjCDWSo/eNaiCszTnu3l526cH927ZlkI0hJFUrW/b3GOTy8om2CBrexWGLWPI/r+pZJYGFgrHGRBBA4ktdYazd+khWt+q22amxl49RmaEv2Bjm3jz8I+xTQaHhuOWzKv3mTtja0hTKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQiLyMok; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791673; x=1765327673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ep4sns6fiJ21YowEfKsA+fUSVKFZ3KDavuMkAMgE58c=;
  b=hQiLyMoklFUovG2Fp3JuimQRioQoEp4ZfxOFudc5p12nmU0V9nRA3Hvp
   u1NBu3VrUHTbuVVR8eTkCeJsPLSzotx/jPgTZiCPooT2kiL1365zjh091
   Nu7mHREiP5/8FWKoV7faUUe91/20fB/Nvl02QAPHW24MbjBub2Ouh1y1X
   sjnORtPiR/PhbtrRgFJSFBAxjsQAlajXrdc/Ujb2+rZtR1uKKji9oKnY2
   OH2SwmaY1k8SQPPiKaqduEXCg8IL/uGL0iMHhvEr4I/0ZPwijyYvuw9CK
   mkknJyqJ8tWWYgFbVxP+MKaABYhai07q/xl2IzzmveacHfJFVKbnI+ERN
   w==;
X-CSE-ConnectionGUID: wWA63IemSyqX7SF5lkBDGg==
X-CSE-MsgGUID: U8hQsCfLT/KjtEWmv/m8Ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793677"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793677"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:53 -0800
X-CSE-ConnectionGUID: ObZ2XeshQneaKj7fiIuDOw==
X-CSE-MsgGUID: qKH5w1WhSKSySGCDAWthuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033006"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:48 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 01/18] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date: Tue, 10 Dec 2024 08:49:27 +0800
Message-ID: <20241210004946.3718496-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a flag KVM_DEBUGREG_AUTO_SWITCH to skip saving/restoring guest
DRs.

TDX-SEAM unconditionally saves/restores guest DRs on TD exit/enter,
and resets DRs to architectural INIT state on TD exit.  Use the new
flag KVM_DEBUGREG_AUTO_SWITCH to indicate that KVM doesn't need to
save/restore guest DRs.  KVM still needs to restore host DRs after TD
exit if there are active breakpoints in the host, which is covered by
the existing code.

MOV-DR exiting is always cleared for TDX guests, so the handler for DR
access is never called, and KVM_DEBUGREG_WONT_EXIT is never set.  Add
a warning if both KVM_DEBUGREG_WONT_EXIT and KVM_DEBUGREG_AUTO_SWITCH
are set.

Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rework changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Update the comment about KVM_DEBUGREG_AUTO_SWITCH.
- Check explicitly KVM_DEBUGREG_AUTO_SWITCH is not set in switch_db_regs
  before restoring guest DRs, because KVM_DEBUGREG_BP_ENABLED could be set
  by userspace. (Paolo)
  https://lore.kernel.org/lkml/ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com/
- Fix the issue that host DRs are not restored in v19 (Binbin)
  https://lore.kernel.org/kvm/20240413002026.GP3039520@ls.amr.corp.intel.com/
- Update the changelog a bit.
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++--
 arch/x86/kvm/vmx/tdx.c          |  1 +
 arch/x86/kvm/x86.c              |  4 +++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index df535f08e004..a0814079777f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -604,8 +604,15 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	/*
+	 * Guest debug registers (DR0-3, DR6 and DR7) are saved/restored by
+	 * hardware on exit from or enter to guest. KVM needn't switch them.
+	 * DR0-3, DR6 and DR7 are set to their architectural INIT value on VM
+	 * exit, host values need to be restored.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
 };
 
 struct kvm_mtrr {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3cf8a4e1fc29..b87daa643e6e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -727,6 +727,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e155ae90e9fa..2b4bd56e9fb4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10965,7 +10965,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs &&
+		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -11012,6 +11013,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		kvm_x86_call(sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
-- 
2.46.0



Return-Path: <kvm+bounces-41806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6F9A6DC91
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 15:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D89753B1EF7
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 14:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92CA25F978;
	Mon, 24 Mar 2025 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c5+jaFFO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77425F786;
	Mon, 24 Mar 2025 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742825133; cv=none; b=d7ZKRG9tkhMgqrF9UHP/aTDVtGmv9J296N48GKIB09yRROLCdQHDE9kWaZbaNgpYTQibu8CjrmR/K8Tpb4Piv0rnh7AXNYHp5PSfOivEvFBlxu5CA3dg58LW/xPfbXpfl/PZzVfDPe1MrjECTIi1PqeB/BpO4TY7UTXQXn5uFw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742825133; c=relaxed/simple;
	bh=c2eCQz13BKIBKZv81BY7z0CDOjaxqpyzhQRwa3SkYKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R7ZkgnyVNP3I7lFU5uBIhke146p9JHkFZCYuDbAY45/BsXak5EJJCOSjeK3Vi3jotBTs57rlZbk2QHH0GSTh3mKrKovrlzu1VHQ6vAOBgD01yvcozMhUKPt2gz92wxFZ9v/hDXI5M+gZonkTXWZPYwDA+CV7zs5rmTRWr2F2yLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c5+jaFFO; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742825132; x=1774361132;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c2eCQz13BKIBKZv81BY7z0CDOjaxqpyzhQRwa3SkYKg=;
  b=c5+jaFFOUAZR48Yo1HTewiZ2eYsqrfVF4ZGSjHL4WbqgMk5+jpGeEQMz
   dTlItEqSZPNiD/kT5D77Dbo6lDMDN1DdNDqziCf834LX4ShjXWKn3pbtI
   wARN3TNRX0G5EWz/DGmgmbsB68mCffiF1ifx2jcVefSPCBjYWEp6d6eDi
   SXa8e1dQTgzILdNVo24aiZB4CbdARQDwd7qOj2TaHQT/8YS08boRyp9Gk
   Ne4h/DRnRS/yscLNymb3MXu8W1Qlg90jULGK4HqecL4xRFYxyWyoC9Bhb
   Gn+m1i1lT/t60zYEws04oAy9qa7fmA2XJM0ualiL1uDsUMGLm57ObAtPe
   Q==;
X-CSE-ConnectionGUID: xSnqsL7LQzy+Fj+KVqV1Mg==
X-CSE-MsgGUID: cx53YatITmO4i4cBnh+zgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11383"; a="54666845"
X-IronPort-AV: E=Sophos;i="6.14,272,1736841600"; 
   d="scan'208";a="54666845"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 07:05:31 -0700
X-CSE-ConnectionGUID: /AnTqYGVQGCBN9JWKPRoPg==
X-CSE-MsgGUID: rqCGAJgMQ6yBS3xkwvUkyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,272,1736841600"; 
   d="scan'208";a="129250116"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 07:05:28 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Date: Mon, 24 Mar 2025 22:08:48 +0800
Message-ID: <20250324140849.2099723-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure the shadow VMCS cache is evicted during an emergency reboot to
prevent potential memory corruption if the cache is evicted after reboot.

This issue was identified through code inspection, as __loaded_vmcs_clear()
flushes both the normal VMCS and the shadow VMCS.

Avoid checking the "launched" state during an emergency reboot, unlike the
behavior in __loaded_vmcs_clear(). This is important because reboot NMIs
can interfere with operations like copy_shadow_to_vmcs12(), where shadow
VMCSes are loaded directly using VMPTRLD. In such cases, if NMIs occur
right after the VMCS load, the shadow VMCSes will be active but the
"launched" state may not be set.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783..dccd1c9939b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -769,8 +769,11 @@ void vmx_emergency_disable_virtualization_cpu(void)
 		return;
 
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
-			    loaded_vmcss_on_cpu_link)
+			    loaded_vmcss_on_cpu_link) {
 		vmcs_clear(v->vmcs);
+		if (v->shadow_vmcs)
+			vmcs_clear(v->shadow_vmcs);
+	}
 
 	kvm_cpu_vmxoff();
 }
-- 
2.46.1



Return-Path: <kvm+bounces-33363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 670369EA3DE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A54E188A2C2
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65BC224884;
	Tue, 10 Dec 2024 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCkScfyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CDF21E0AC;
	Tue, 10 Dec 2024 00:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791721; cv=none; b=BIyfbIc0n4kMcgP1vaIjlQD4SExf/H63y0Vxiz5PPGI/pslcphGXIPfTTNylCutJuX2WjKhE+tGn1ZPOq3j240rNSxdUh8ejIUW62qNAaXsL6OdI42/tPcQS+NSzW4GOQg4MrSaYZsTt/xP9MbVJEkSZfrBHwZrlJbuNHL7pxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791721; c=relaxed/simple;
	bh=fzLIhQN5WxLViXl8Ip86IRGpAtvCs3G+P+plG8lekls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s92zZM3jPQRbKjNXjE5DjV36lNa0JkFzcPMih6zy6ZqCwaj0EkXSd/b/k2pkZKssV83JLC+ikuVf08dojbXcHG9BGd4uMZp2rUFxjWFfDlthBHBfecbU6MKLALbcsOoWQ25B22qOSjyGK/RR6uxTPD/2LoI+T9Z9d9Y/78/DrIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCkScfyz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791720; x=1765327720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fzLIhQN5WxLViXl8Ip86IRGpAtvCs3G+P+plG8lekls=;
  b=HCkScfyzHtDWduSTLsHHsfUbCcgwMjz/QngC5pA1s2Xepq7UI+qRrqZ1
   VummAl2Ykx2VNWJZBfI56eZYSfzZc45c4SaNCPrRdQJ35DvQvBZ1I2bvh
   1pT/1STrIa2nm6M1P/kHSuHqet63AB5+jNJIJJ4yYonweeA/RCdllwrtF
   OIC/stzgl4i+DR7zjq18iPfgBWk+0DHtrtVeTXd0BxMdvLrqVlSAFG71B
   djYi4KB1Sed3YYlIyXw3ybwBeecIzgOdS1GKEnKCyY2elfQoKfiQ9LZAh
   0fevKbfMHbbdroRzz3x2DKiY4Q/VbZA9qu6fMupVA/1nfdPYpPGmhOjDv
   A==;
X-CSE-ConnectionGUID: ffOn9efhQFCmultu3A8NAg==
X-CSE-MsgGUID: vFMVC6/tTGGmzuTZsQohIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793770"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793770"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:40 -0800
X-CSE-ConnectionGUID: rSh7Pie4TZ2CEc3uiWlqiw==
X-CSE-MsgGUID: P57dJcm6R3uQBhx75zhw5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033083"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:36 -0800
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
Subject: [PATCH 14/18] KVM: TDX: Add methods to ignore accesses to TSC
Date: Tue, 10 Dec 2024 08:49:40 +0800
Message-ID: <20241210004946.3718496-15-binbin.wu@linux.intel.com>
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

TDX protects TDX guest TSC state from VMM.  Implement access methods to
ignore guest TSC.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Dropped KVM_BUG_ON() in vt_get_l2_tsc_offset(). (Rick)
---
 arch/x86/kvm/vmx/main.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4a9b176b8a36..81ca5acb9964 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -757,6 +757,42 @@ static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return vmx_set_identity_map_addr(kvm, ident_addr);
 }
 
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_l2_tsc_multiplier(vcpu);
+}
+
+static void vt_write_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc offset can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_offset(vcpu);
+}
+
+static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc multiplier can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_multiplier(vcpu);
+}
+
 #ifdef CONFIG_X86_64
 static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			      bool *expired)
@@ -914,10 +950,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
+	.write_tsc_offset = vt_write_tsc_offset,
+	.write_tsc_multiplier = vt_write_tsc_multiplier,
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-- 
2.46.0



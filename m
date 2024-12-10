Return-Path: <kvm+bounces-33365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E2F9EA3E3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9201B168B0F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F28B22618B;
	Tue, 10 Dec 2024 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJkb9PGb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC561226173;
	Tue, 10 Dec 2024 00:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791729; cv=none; b=B9NuWPMWFQxkYljXxAg7GXsEgFed9H5UVmcQjdHsncP1NDFYoZaflnKJ0R2M1d3f7vu2BkV/yi6MM/2ZQ4yo7SRRml5kqvNTACKwN4jKxrwwwg9eXfSWv6ldHpxFpDHDJ8CNMrqAzuLZZvVK3A8feMVuEPo/b4pjrkUZZfpFLyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791729; c=relaxed/simple;
	bh=30ltR/0kh3Q1IFeb8do8LGhyHFYvpma6JQxut931cHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNP9YrKPrACmbERHqlzl+npK1eGAtXdRGivuYjNDAv241KXqwfImQcKPLJeQuaTyuxIJlca2MjOSQ0r/amo+v+XhIfvImop0OZvkxl+imLwebCyUZ4VebLdLwjkr9VxvH0IQdzmNZ0SiKHmoEd5Xj7b6KZt4kCABUuntP1+ZdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJkb9PGb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791727; x=1765327727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=30ltR/0kh3Q1IFeb8do8LGhyHFYvpma6JQxut931cHM=;
  b=NJkb9PGb2z0aADEDEX/N9hDm2+drtQZxnnRAWJT1N6yQqZud2ahaQE6i
   3EypwwaQoWjdZeN3FCYQbjCopCksLJ6476/z8DiL3CnPkf8T9kvmsPuCS
   wdebnpL2tX7bVbjXWNkYzAAFcoO033YmmBI9rO+C6NjRqwsNRHaid1bUJ
   YoRv1SeHFbd19k780V10wPeTsukVqWriLhp0LOCKagQl/PqkRluiAXfLI
   FO1FLTg40mwvJ/+JxqVQ5wFphphnECru1SN4jNXysMgASTTJqKSonmliD
   Mh1UDhuLk7qdrmC+ATAZCH36UXOt+a+N1ob4v3xumFDvXxKH0VwkGKMRw
   g==;
X-CSE-ConnectionGUID: pOqak0gxTSKAPK30oQbGBQ==
X-CSE-MsgGUID: CKFyqCL0QHykJjZ4Zxbg1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793790"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793790"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:47 -0800
X-CSE-ConnectionGUID: /1tLC4jZT/a/fB9zOgZoWA==
X-CSE-MsgGUID: QOUcOScUS0WS0kCZ7q501w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033103"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:43 -0800
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
Subject: [PATCH 16/18] KVM: TDX: Add a method to ignore hypercall patching
Date: Tue, 10 Dec 2024 08:49:42 +0800
Message-ID: <20241210004946.3718496-17-binbin.wu@linux.intel.com>
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

Because guest TD memory is protected, VMM patching guest binary for
hypercall instruction isn't possible.  Add a method to ignore hypercall
patching.  Note: guest TD kernel needs to be modified to use
TDG.VP.VMCALL for hypercall.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Renamed from
  "KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch"
  to "KVM: TDX: Add a method to ignore hypercall patching".
- Dropped KVM_BUG_ON() in vt_patch_hypercall(). (Rick)
- Remove "with a warning" from "Add a method to ignore hypercall
  patching with a warning." in changelog to reflect code change.
---
 arch/x86/kvm/vmx/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 01ad3865d54f..81b9d2379a74 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -657,6 +657,19 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 	return vmx_get_interrupt_shadow(vcpu);
 }
 
+static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
+				  unsigned char *hypercall)
+{
+	/*
+	 * Because guest memory is protected, guest can't be patched. TD kernel
+	 * is modified to use TDG.VP.VMCALL for hypercall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_patch_hypercall(vcpu, hypercall);
+}
+
 static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	if (is_td_vcpu(vcpu))
@@ -921,7 +934,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
+	.patch_hypercall = vt_patch_hypercall,
 	.inject_irq = vt_inject_irq,
 	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vt_inject_exception,
-- 
2.46.0



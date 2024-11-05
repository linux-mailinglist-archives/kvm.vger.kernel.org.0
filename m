Return-Path: <kvm+bounces-30640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 708E79BC57D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB248B2220E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826261DCB21;
	Tue,  5 Nov 2024 06:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBLE+p1a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260891FCF45
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788608; cv=none; b=otg5RjJZwq+CsJSEClyEXpx/I5ONE6t5li1ZbQ5wH7Lwk3dNWB26JLiYJxmbiVLRDLvFWu7AF/EEuaCV6AYsN4X/KJCq7/d4AMgCCaAQYffZjj7C5gZqWIDbOOgbT+kWmkKsiCRipfgfNi6acyd8btFeyAhlxL5KWgx8Q65oyI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788608; c=relaxed/simple;
	bh=7SB8aGVRHq3cVcRCjG983qVZg5U5xF0U5N0nc3brUHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N9KLFSKlh932wVYVYdHipmhp1QlJbDmNMXLhj6n7lHJdE5N2+PyJZh7Pc9AxzCiysk0Mm5haq9hYmhH7y96IX04eG3JTGlmj3fhH9ZRONBwSIDAmx/CO/whdwnrJGredd/6Vnfukui99pUnBoT1bpSn/Qo/dlz3I+oThqUXxtBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBLE+p1a; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788607; x=1762324607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7SB8aGVRHq3cVcRCjG983qVZg5U5xF0U5N0nc3brUHY=;
  b=nBLE+p1aURZts4J4eHcJdF7GuV+0vzHV5NVRe6zItpZqNvP1ZMtFDm9K
   0JRuAMf2JEpojnAO7GmclJ5WFizFjG18CmItIjrIA+ayn+4fxPBBSippK
   5nusTn9b8N6gHnE3+A0vkSVuyNFvV6a5i7KE4jYtFAfioAlMGsBSxfOJE
   UVPIOYvgvFDjC3Mz98uxtbsyw3eMfT+rke1iFFDaYgeS8u3WqgTuiMeN6
   gfcwdi3qQ5i5+nmKxz3kjKTta37951YO86ZCb757ZdPMSG2zJru/jDD0z
   BIiInwPG5LxbUHsm5cJWzvLVwMDm2LrC6TrAPgp2rHyAGurkHsOo6uZAZ
   g==;
X-CSE-ConnectionGUID: SVxvBjLnQua68VWTXlsofw==
X-CSE-MsgGUID: 32Zmdd2CTdiz71sAQd0U8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689287"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689287"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:47 -0800
X-CSE-ConnectionGUID: CGPXOm3fS/i5ivZLDU97xA==
X-CSE-MsgGUID: d6NqJKe+RIiI+IpNuhCdLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988631"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:43 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 06/60] i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
Date: Tue,  5 Nov 2024 01:23:14 -0500
Message-Id: <20241105062408.3533704-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It will need special handling for TDX VMs all around the QEMU.
Introduce is_tdx_vm() helper to query if it's a TDX VM.

Cache tdx_guest object thus no need to cast from ms->cgs every time.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
changes in v3:
- replace object_dynamic_cast with TDX_GUEST();
---
 target/i386/kvm/tdx.c | 15 ++++++++++++++-
 target/i386/kvm/tdx.h | 10 ++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 907044910fec..ff3ef9bd8657 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -20,8 +20,16 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static TdxGuest *tdx_guest;
+
 static struct kvm_tdx_capabilities *tdx_caps;
 
+/* Valid after kvm_arch_init()->confidential_guest_kvm_init()->tdx_kvm_init() */
+bool is_tdx_vm(void)
+{
+    return !!tdx_guest;
+}
+
 enum tdx_ioctl_level {
     TDX_VM_IOCTL,
     TDX_VCPU_IOCTL,
@@ -105,15 +113,20 @@ static int get_tdx_capabilities(Error **errp)
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     kvm_mark_guest_state_protected();
 
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
+        if (r) {
+            return r;
+        }
     }
 
-    return r;
+    tdx_guest = tdx;
+    return 0;
 }
 
 static int tdx_kvm_type(X86ConfidentialGuest *cg)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index de687457cae6..bca19c833e18 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -1,6 +1,10 @@
 #ifndef QEMU_I386_TDX_H
 #define QEMU_I386_TDX_H
 
+#ifndef CONFIG_USER_ONLY
+#include CONFIG_DEVICES /* CONFIG_TDX */
+#endif
+
 #include "confidential-guest.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -16,4 +20,10 @@ typedef struct TdxGuest {
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
+#ifdef CONFIG_TDX
+bool is_tdx_vm(void);
+#else
+#define is_tdx_vm() 0
+#endif /* CONFIG_TDX */
+
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1



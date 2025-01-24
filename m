Return-Path: <kvm+bounces-36521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5077EA1B716
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DBB41885E27
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E7C142633;
	Fri, 24 Jan 2025 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fRdF8N1i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4A63594E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725956; cv=none; b=AYe7VhQ8kNBHpIASDTHRL1FBVgMwFx827F7+WOFjPvbIzyzmCvLuecm3cXMECLG9AQU5o3+YgemV9P+cQwqin/uoraaJOC0VbP3VZnGdBxt/Mhd69w2Ryz6I14NtfAdwuLIHwHUMn9AH5THNoRUcHD3NKAPDepVny8YVMj8WuLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725956; c=relaxed/simple;
	bh=0CHytoVi2GC8eQQ7AANbOOAGWz2m8eyJezmiyRUq10I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nCb05EP47I3E0mVOIWLhzEgj1YGiUSOAj8HPeeFbZ5fVhN/bVYY2ImfFrypzLeSTfX8LnSjYp/lcFvCfN7WBdzJvsDB4XGTlo/IsnXktvqqcf/+YAXps/mhoMJTeu1xGNh9eu2+xlqJAzmKH3iMv2k9Q8GAkpPCyAfy4Et027Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fRdF8N1i; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725955; x=1769261955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0CHytoVi2GC8eQQ7AANbOOAGWz2m8eyJezmiyRUq10I=;
  b=fRdF8N1ifwbwuYOpY+FOeSNNb1aEUZkUm38sBRsy/h2OEbuuwREfJlPT
   ERyaGj6A+evlWghgkjw9UFXc0vcXeQsgIHcoNNV1rHPJnRno2UZf7Hfym
   g+tDOFqIOozAmYGvVv8wBENTyEck6sXMkY3uw6qPSOQ4D3REM+I8gSPE6
   cZQyi87MFH7pLEwtUbYGMA455K13K30UFt6OdAWtB7gwwjvytB8bLvyqL
   tVRzijYyWxqOxJ0E0+hoU9DCYzAQN+vxkZ3SVErmIMpbswzTSE+O+gzqF
   dfLIMiqaaaE57vKZnP7T+1dyYdsx9+Xp5EDn3abPWhr3fIhRuKvTFaqpU
   Q==;
X-CSE-ConnectionGUID: sxU1OQbNSPiT5rpgvhAnwg==
X-CSE-MsgGUID: WePntlxsTueXkFBVp6d5zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246507"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246507"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:15 -0800
X-CSE-ConnectionGUID: hYbMASohSQSUYNitfkfutA==
X-CSE-MsgGUID: djbbnopIQ36NvvDoZQdgXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804409"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:10 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 35/52] i386/tdx: Disable PIC for TDX VMs
Date: Fri, 24 Jan 2025 08:20:31 -0500
Message-Id: <20250124132048.3229049-36-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy PIC (8259) cannot be supported for TDX VMs since TDX module
doesn't allow directly interrupt injection.  Using posted interrupts
for the PIC is not a viable option as the guest BIOS/kernel will not
do EOI for PIC IRQs, i.e. will leave the vIRR bit set.

Hence disable PIC for TDX VMs and error out if user wants PIC.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 10059ec8cf92..dcbbe350ec91 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -379,6 +379,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EINVAL;
     }
 
+    if (x86ms->pic == ON_OFF_AUTO_AUTO) {
+        x86ms->pic = ON_OFF_AUTO_OFF;
+    } else if (x86ms->pic == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support PIC");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1



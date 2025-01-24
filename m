Return-Path: <kvm+bounces-36535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 375F6A1B72A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C8797A5090
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38DC1200CB;
	Fri, 24 Jan 2025 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MCI8zAAc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DD38632E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737726007; cv=none; b=aHAF+ab7cQmk4RN8UUEEX0uwvXuIDA9Hue3pmy5Hqcy5y2ngt24z5Q1jTZm5mDkFy9JpLnTmwI+JnmsVsC1u5rm4UMtw7un40tcP4+72a+RlEcLPynhejPM9rrhtxQ4lvAIHWIVKLTHbVQthG23K7NgcSDqiXtKwalM1ROcOnpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737726007; c=relaxed/simple;
	bh=lKKhpINOwRUM2TXEgJwHkGVj1DZ5JDaSkIZbWTMQSdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W4CkBdJMXp4dajb+pV7zZ5l0w5MRuRbodOSs01YFUdXBhLlJjrJa9m7XNX1TAHHvRa3VG1OpXeJzoXTzZkpuzByyNhaOz5gwEXEXU7x9SkvrR/Tv/wdQ5XDevLszD7Z4UiRnfNdUOJoqzgLN+2mfxW/E3aEQ4UC+FxSdoWdblLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MCI8zAAc; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737726006; x=1769262006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKKhpINOwRUM2TXEgJwHkGVj1DZ5JDaSkIZbWTMQSdU=;
  b=MCI8zAAcsJCvMnxKRT1A0P8lgP9dvnMJ0wDha1bDU2M3pnlCIdfHX3Gn
   Uu55812sGLKMSm88tvbk83vnclcuowmuVZ6NSorWT/7ZCP/9Fe/CDmpBC
   q65OaWmSqlhXv3VU/TvV2dYXReH++PjANUb8cpjYK+mcgTDUgulKUr6wX
   X8OtaXHp6bDAIi61ApifBF2r0QFzzgygvM6z4S9/JewKba1/pxgI6tAdq
   fu/NuosTVbNa59tbAMEnF/sGgOOmelbVAicUhkbLtV5E8ymntzLoPgJeN
   sna5K890uZNQlOXaVFd1P80vq+7ZPGxHNuq4Ei1xp9BMOC4yXeCLMjxg+
   Q==;
X-CSE-ConnectionGUID: tcxxG/aiTfGzzCLb7T4jCA==
X-CSE-MsgGUID: qEV6hGINQx6amdLW9WxFpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246639"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246639"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:40:06 -0800
X-CSE-ConnectionGUID: sPnsZByDRfuPsoXWvSIhMg==
X-CSE-MsgGUID: oe9IJOeQTK2UOcoe9Kz6MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804485"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:40:02 -0800
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
Subject: [PATCH v7 49/52] i386/tdx: Don't treat SYSCALL as unavailable
Date: Fri, 24 Jan 2025 08:20:45 -0500
Message-Id: <20250124132048.3229049-50-xiaoyao.li@intel.com>
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

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v7:
 - fix CPUID_EXT2_SYSCALL by adding it to actual;
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f6a4f3322e61..58ea6a4d3156 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -804,6 +804,19 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
             continue;
         }
 
+        /* Fixup for special cases */
+        switch (w) {
+        case FEAT_8000_0001_EDX:
+            /*
+             * Intel enumerates SYSCALL bit as 1 only when processor in 64-bit
+             * mode and before vcpu running it's not in 64-bit mode.
+             */
+            actual |= CPUID_EXT2_SYSCALL;
+            break;
+        default:
+            break;
+        }
+
         requested = env->features[w];
         unavailable = requested & ~actual;
         mark_unavailable_features(cpu, w, unavailable, unav_prefix);
-- 
2.34.1



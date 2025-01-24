Return-Path: <kvm+bounces-36522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 184A4A1B715
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6901C161D2A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AE478F20;
	Fri, 24 Jan 2025 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aoWGBbZg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735D93594E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725959; cv=none; b=WEvmYxN4jtuxOPhncSOB5s8eD1A9v4SNWSX4MPQCzX7QryJMtn7Cjc8WfrFA8D+rYrdt1fO4mNkiI8stqJRSqNQqfcRA2qYSIsM+P09XdaA0qogL7YXXnvshiJ2UyT/itDRwMuZAmL9Qo5T0dtydEROPnopSN4fHYlFCu1Rqm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725959; c=relaxed/simple;
	bh=VD5cLhhOxm2rY5XZ6+nf6tMgf/SKVeJGzlvaWHkLI9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsG77C1pr0nbLJTp2UPL6530m34c/qprvt+rUv9f2LbNqRIyz2cdHqimoIpEiCPwQJZhvNlrpRCdLGh8fzJ1GGLfYB1uafr95f/41PfjB6V/JeOecYc/IeLLrxF7o+Yh7xuDx0qsoKiFIL3EPMVAaRl18ThRF+tl/Hzhf/knnWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aoWGBbZg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725959; x=1769261959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VD5cLhhOxm2rY5XZ6+nf6tMgf/SKVeJGzlvaWHkLI9U=;
  b=aoWGBbZgCh/D38e1Q4y56gzX143jBnj8GoHMIAl6stzv6sISKaHQrB9U
   j14SF7YWIgeZm7hjzPIt7FHy1ocGc0FuURhph1OKNCjBl2YShduC0Gmoe
   WB5RRo6vPAyPqYwZYhoM1PtQ0RyirNyPNyaYDl9vZhKxRgfe1lLZUEgjd
   9SVGgdL7cc8J41XhPpIVpiIUlUk1bMcHvTDb9oZfaeGEMon3fZ8xVmkPW
   YQeOdA5gnlGtLaf/eyyqNZ77LgIxmEklRGuUWEX/OCFsITFw8E9V4XypQ
   unoF56KYSR/3aMvV2sp8IqO0MhBrq1VVrQy3O7suykeYXFHhU4srRTLw5
   g==;
X-CSE-ConnectionGUID: K2DQSF+lQC6W49B/2rXSFQ==
X-CSE-MsgGUID: F2wVZfl9TeOCsOf+e6qsRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246515"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246515"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:19 -0800
X-CSE-ConnectionGUID: k5hFUSl5SLWds1zHhX0NtQ==
X-CSE-MsgGUID: ud8VOOXFTjingq/w1aRZCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804414"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:14 -0800
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
Subject: [PATCH v7 36/52] i386/tdx: Don't synchronize guest tsc for TDs
Date: Fri, 24 Jan 2025 08:20:32 -0500
Message-Id: <20250124132048.3229049-37-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 741b50181ed9..ead1d0263385 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -327,7 +327,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.34.1



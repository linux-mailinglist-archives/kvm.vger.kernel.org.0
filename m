Return-Path: <kvm+bounces-67309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A48D2D0077F
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC901303D6B3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1229017C77;
	Thu,  8 Jan 2026 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FY/AZKFX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECD1D5CFE;
	Thu,  8 Jan 2026 00:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767832310; cv=none; b=QgjuVj2BmzZ5/846NgcBf4OUGdbSEvvIBo86/l7zQ4BtJOlpnOM/8ORkyBVmdSjr1O3B8I0qau3wbQzjl8EXwv5KqT36b9Qiomt/6tjYjSjW0lGt9QC2JB2n/s4mRuIiztCZEJ/P7UPb64ZZJGWMgBzCEuGZkPR/1FKFQ8rueJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767832310; c=relaxed/simple;
	bh=qtR1X2zMVu3UKyuOAUPNmj7ECUaiiBQSD90YSKUgiIQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jonN282mzDip2jHjIdiyQc3xOIGDyNhBS7VRCiUbR5SZhJzA7r8CrkozTXytjoObQrjy5W4p+Jq1O4CrRF+RDbIGkHqHdTBiuxP9zaxx0cOf3gBZU13w7XQzIDyjIBCqCMuWUdLftrFrvmiOYsbXZH7to1w/fsRzNcki51rQvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FY/AZKFX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767832309; x=1799368309;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=qtR1X2zMVu3UKyuOAUPNmj7ECUaiiBQSD90YSKUgiIQ=;
  b=FY/AZKFX7I9s+lwbB2A9PraIuC8DxaMGo3TlUSYVHpG/3HhVCAzCzxNe
   ovNb3xO8TkzI/j6ylklYCBiMBgtkbpZ+yqrNkIz7yJ2GPaZNSpVA30KPr
   oPhBGH+d/uIneOCtb1H/CMXvLyiWbWOndwmwUllIilybmfk+EOkg2ZBwg
   hLSSFvGZPrPMcfRifV7mpnTCiyxeaVX3h7CSgATBiUWzhgZHnPUwXgcks
   xRTnV73Y+QAEX5vunZCTecr3DukcHJwTjMTFmFN8P28+SATBdqAxYN6AX
   n6CUH5WevrJYUlL1CGxkrpaejCZKf/5WWDtgZ0lcI+JVBis75RFa/z5oQ
   Q==;
X-CSE-ConnectionGUID: 2/AwX+ejSxe9HdvTD0Xj6w==
X-CSE-MsgGUID: AoZh2z7WQeeKLJki7q7Smg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="86625980"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="86625980"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:48 -0800
X-CSE-ConnectionGUID: Yydjuv6QRWadWg6rftDiZA==
X-CSE-MsgGUID: 7UUwo5/ZQNehoC7GxEH4Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="207908364"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.222.195])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 07 Jan 2026 17:31:29 -0700
Subject: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
In-Reply-To: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
To: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-e44bb
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=qtR1X2zMVu3UKyuOAUPNmj7ECUaiiBQSD90YSKUgiIQ=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDJlxvz6Wvr3Cy5zy6r2gxwsdRef2mkKHU1ukHP/P0TRPW
 XVh6an+jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEyko43hv++qz06nTuZNfj3H
 lTvE2Krcq/uWCXe2+OufM25OlmCu3sTIsEi3kPGp04RZ7/eziDqEiqWInPA9u3Tm76jIVxwOqT+
 tWQE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

It is useful to print the TDX module version in dmesg logs. This allows
for a quick spot check for whether the correct/expected TDX module is
being loaded, and also creates a record for any future problems being
investigated. This was also requested in [1].

Include the version in the log messages during init, e.g.:

  virt/tdx: TDX module version: 1.5.24
  virt/tdx: 1034220 KB allocated for PAMT
  virt/tdx: module initialized

..followed by remaining TDX initialization messages (or errors).

Print the version early in init_tdx_module(), right after the global
metadata is read, which makes it available even if there are subsequent
initialization failures.

Based on a patch by Kai Huang <kai.huang@intel.com> [2]

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/all/CAGtprH8eXwi-TcH2+-Fo5YdbEwGmgLBh9ggcDvd6N=bsKEJ_WQ@mail.gmail.com/ # [1]
Link: https://lore.kernel.org/all/6b5553756f56a8e3222bfc36d0bdb3e5192137b7.1731318868.git.kai.huang@intel.com # [2]
---
 arch/x86/virt/vmx/tdx/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5ce4ebe99774..fba00ddc11f1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1084,6 +1084,11 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	pr_info("Module version: %u.%u.%02u\n",
+		tdx_sysinfo.version.major_version,
+		tdx_sysinfo.version.minor_version,
+		tdx_sysinfo.version.update_version);
+
 	/* Check whether the kernel can support this module */
 	ret = check_features(&tdx_sysinfo);
 	if (ret)

-- 
2.52.0



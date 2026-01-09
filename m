Return-Path: <kvm+bounces-67635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74395D0C073
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F062A3079E90
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DE52EAD0D;
	Fri,  9 Jan 2026 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EXBcDovU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4B62E7F29;
	Fri,  9 Jan 2026 19:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986088; cv=none; b=Quf6BQOBnyRckATrzXBzv+Z7GOJcIPhqqFTYnuIAlbsWL0JnAK+YMJPqATNnX60JupBgrzgTcpwC1JZFmIWSxUsHET8w7hHr0BKHJrmlHaRfNSgjDWnxU0JzleWKjXP2EfMeqROxdxx7MxDsbdE1L9CKRyeqUPNHGbIp5dJGnCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986088; c=relaxed/simple;
	bh=HAST+iBWW1rthNVsK5i+2cKNI0GpuvQ6shdHcZN3PGE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WZR+qpjdkIcdyG6aY1X7yH7Qlae5PKdP87mbajWckUj0leLhZCGOqs1ps/QGbPpoTgPcQ1tSTXt/MOfYSLFSXmZTVrrUpa3syS9wHOO387lnEaQPSAE0N+CrxE/6tvCAUQ0WoFV4/wk9+k6wuar+lZcXdSzo8pSO1KtZFjbVLS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EXBcDovU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767986088; x=1799522088;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=HAST+iBWW1rthNVsK5i+2cKNI0GpuvQ6shdHcZN3PGE=;
  b=EXBcDovU9NjcKgQEYltACE+ZskQUBgrASTnxWIpsjUaRVY6Z9gFmQnXy
   LA4n9DUc5FAx3XOVl10QxDTqP1L/LGgQOAke6Bj3lL/tl8LbKdhH8MhVn
   3HAWpNfPED0mka6dsbMZ10y+zLhakf6ARMN/4MQtcxqL6YKbPfkcaTpHN
   5CFgkr5fUoByUrSTvcmQxeFKWeZc5TEXeOsRIDotQ/sNsG1DI1DRbrE18
   u7Sy5zKkXh8sdctMLZFZ9ZwZGiKCoejna7MPzhLqluap/bVDW/R2pGHhS
   pNRrHQUva5kZ6Oz687aHO0DhJrk1flQiOTXkMVHRZfKojM6LgXxA6qwea
   w==;
X-CSE-ConnectionGUID: 3zxkFx9VQ02/ndeOSEzeaw==
X-CSE-MsgGUID: N8LyUs1HQoqmVjSBHzMp5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="80824263"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="80824263"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:47 -0800
X-CSE-ConnectionGUID: RBevAgCdRMetouLWcPsvbA==
X-CSE-MsgGUID: km6/aHnaRWu5PSJpi0kE7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203456701"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.223.127])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 09 Jan 2026 12:14:31 -0700
Subject: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2047;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=HAST+iBWW1rthNVsK5i+2cKNI0GpuvQ6shdHcZN3PGE=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDJmJwUtWqRSmNf149fOf/NbkzYxam77v/3LX9Py2M3+Xn
 PoTIX1wdkcpC4MYF4OsmCLL3z0fGY/Jbc/nCUxwhJnDygQyhIGLUwAm8ugvw/+C6lv8TA/U73ax
 BwYLnl8ywT/Of1/C1+TJCyZsjddRXbCEkaEr88vkQ0m9f9/kX96weH9kya6pR++9m8vfeyfQTir
 5kgcXAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

It is useful to print the TDX module version in dmesg logs. This is
currently the only way to determine the module version from the host. It
also creates a record for any future problems being investigated. This
was also requested in [1].

Include the version in the log messages during init, e.g.:

  virt/tdx: TDX module version: 1.5.24
  virt/tdx: 1034220 KB allocated for PAMT
  virt/tdx: module initialized

Print the version in get_tdx_sys_info(), right after the version
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
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 0454124803f3..4c9917a9c2c3 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -105,6 +105,12 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	int ret = 0;
 
 	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
+
+	pr_info("Module version: %u.%u.%02u\n",
+		sysinfo->version.major_version,
+		sysinfo->version.minor_version,
+		sysinfo->version.update_version);
+
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);

-- 
2.52.0



Return-Path: <kvm+bounces-36518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7C8A1B712
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A562C7A4378
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A860078F33;
	Fri, 24 Jan 2025 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLTrSpwI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72558200CB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725944; cv=none; b=AU4nFtR76T2rjGIRAwr9QDdlLfuJh+DxPLuF1qd5AnLTqzQPAUb2KFAfmExhGs5NJ5gKpVmopOIufscpSXDdY2EWW2IChRd+ZctxEaE0taw9qwtsE64VRHeEXAD997TTVjcMeap4SrTtG9Dt/4x2Vqxky4bKOxTAVpifpE3NSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725944; c=relaxed/simple;
	bh=gvdGEGL02d6aKTIMX6p6dptSfxOU4tPyFWKuZUDDD8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s3vOTiqwAgWyHOoaeZLDwxUouwWIYsy+xN2ObNRf+2XGmT9YTSIKY2e7+w+P+WbQkcnr07+0shlaz/llLHjkERT1hCf+INVmFBnDQPR534ZtC3suj+KFEWB9gMG17fkrFaXj0eTk0vemqSjOeVFh+USrqgtjQvnX1aEqZiq7+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLTrSpwI; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725944; x=1769261944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gvdGEGL02d6aKTIMX6p6dptSfxOU4tPyFWKuZUDDD8w=;
  b=jLTrSpwIV8sBnM0PcGCnzF46mXRbK7orDpgPTCxiS8by2EARF0ZsTWg8
   8SXdehK6OJ5Huim7wY6aRyaXFx5ypeZBUBEPLf4ZYWuexgnNWqt66Gl5Z
   8wZ8co/0efAzQuf2AG6SdbjctOHyL/tX14TlowE60PWZsnYom2K+vbLCP
   5u0TLhV7OW0IEZcjQ3orOe/GS9ZV5C/1SRc1QjGe9bHFtT1jnISiUPBxy
   RqMh/BIlYSCayRS5VHbkBfOUsLduIVzUc+GiRzicOZHr9690plKfr+qO1
   K2x6NsrpQm9dznLTSeJUqHY1TePA87C4sIqWUxWhxxdcoaV90GXclAaJz
   w==;
X-CSE-ConnectionGUID: leYaUTfKReii/edbeF37Dg==
X-CSE-MsgGUID: pwAzWP4gQn66z7Xg5NKZmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246489"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246489"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:04 -0800
X-CSE-ConnectionGUID: q6lwtWH5Sf2lGTLnpusrCg==
X-CSE-MsgGUID: BrGUpB9IS+KCu6ES9ZYanA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804393"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:59 -0800
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
Subject: [PATCH v7 32/52] i386/tdx: Force exposing CPUID 0x1f
Date: Fri, 24 Jan 2025 08:20:28 -0500
Message-Id: <20250124132048.3229049-33-xiaoyao.li@intel.com>
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

TDX uses CPUID 0x1f to configure TD guest's CPU topology. So set
enable_cpuid_0x1f for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 12c1c2503845..982ed779df4a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -398,7 +398,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
 
 static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
 {
+    X86CPU *x86cpu = X86_CPU(cpu);
+
     object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+
+    x86cpu->enable_cpuid_0x1f = true;
 }
 
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
-- 
2.34.1



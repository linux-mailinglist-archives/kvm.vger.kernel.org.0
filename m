Return-Path: <kvm+bounces-43928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0836FA98887
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC00B5A3028
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA5E26FA7E;
	Wed, 23 Apr 2025 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bC61K0bD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03A726F444
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407607; cv=none; b=HiGk3lkd/2GqaSnu6Bt7A5um/hOV0fZTXycsBbZplp1jPBxXex88tuxAZntBilqGcYNgnkpB4Hmydqx4b54Qk2alKr+JCUtXh3pac10pVbCd7p3jeo464XyN4w6hMei1+O8BcCsQPP09l877dMimL5LiY5jeAy1ndNxvf1KEY1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407607; c=relaxed/simple;
	bh=Ru8y57hh6APWX2y18YyGmRmqQ+sT6KAsNwnfHzd4IY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PPyjBbS9CtBPiA5FXHBZtfVf39Qo3HNUrtlq/TcUzpXVMJGwSYE2mdIle8OgYSntLPXLENOFeu5b+RiApy6+TDDPHP6oYUY9i9R+2/HxPRFD5rkEgXfF9K1r0bFLOzv4BCcWoMulrkksfJtmnO/sYhvHHLKpDGhAH5sL86iMz0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bC61K0bD; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407605; x=1776943605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ru8y57hh6APWX2y18YyGmRmqQ+sT6KAsNwnfHzd4IY4=;
  b=bC61K0bDHNPdJJgPLKQKx9W5lmGEAv+kjOQ49BnjY5uFxvFlKdJopETR
   SX9qDEfnMw6ZGRuahW5f5UAdcyZ/KeZAzXUKQ5/zGzBQuu7uA6vNhzzU+
   ehon+fdOeDFJL0QPByJewfGqcP+rW+ZfJuupL4IdGpo9IorXtiLvw4Ko8
   z1DBMhrKrk2+3T2L7LoYpAToTib6HvErWd6HDQ3nl1ybP0S4n+rdQeX0j
   5BkA348zjrMigFLPJrve9COlEvvOler4DlcDlKEwuGb7dEt+5hvZ62azl
   oAmKuJOy88veb1POWh1MJqiy6EaO7R5jpzwdcErJ6WASBN99WxD9yDyrx
   A==;
X-CSE-ConnectionGUID: NnmzuSpgQGOp1Ftj7ERpjw==
X-CSE-MsgGUID: PyNI3ikSS8eTwGUJZy7Vag==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825325"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825325"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:45 -0700
X-CSE-ConnectionGUID: W9p10uIKSGGYNjTOX4fqYQ==
X-CSE-MsgGUID: b72GhZUaTw6dE7wyqdtjbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150820"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:42 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 09/10] i386/cpu: Enable 0x1f leaf for GraniteRapids by default
Date: Wed, 23 Apr 2025 19:47:01 +0800
Message-Id: <20250423114702.1529340-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Host GraniteRapids CPU has 0x1f leaf by default, so that enable it for
Guest CPU by default as well.

Suggested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2a518b68e67a..38b330aaed4f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4706,8 +4706,11 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             },
             {
                 .version = 3,
-                .note = "with gnr-sp cache model",
+                .note = "with gnr-sp cache model and 0x1f leaf",
                 .cache_info = &xeon_gnr_cache_info,
+                .props = (PropValue[]) {
+                    { "cpuid-0x1f", "on" },
+                }
             },
             { /* end of list */ },
         },
-- 
2.34.1



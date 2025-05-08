Return-Path: <kvm+bounces-45930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9583EAAFE87
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 346701C418A3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5C1284B35;
	Thu,  8 May 2025 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3qa7gjw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521727A454
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716780; cv=none; b=Uy0eIs8aafQn5AfAAUHnzIiHQscueV6SObEwdhaYL7WiLhwTJxMReFZzHxnuPkYKvexpF0fLAMCI6cPO14kAbyekxrdq0z+dxnaADQzpqmkWZY9lHOh7CLmZvJYvB0uaIfOe9FwnOTJ4JqWh3TtYteCQMVcOpEOFgJyunvow0RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716780; c=relaxed/simple;
	bh=JW2hZxKpIvEGOx5tP0im0t9/c+qk8a14dSXIWzZZ4k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJf7cnbKmfeO65cAz/SAhloYsHuj+pLeQkQPP7o/Pmcw1VVoegYpvQ+BVDI7DqHaBZhKrZuy6oplRXImshGAE6jh6HxDggvVqufkSbyhOdaRPfg9dN3aU2KkySFKap7DZHiuarfaBzMf3UDiEMlIlNy5yGbS3b+QSwSuTtpF2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3qa7gjw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716779; x=1778252779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JW2hZxKpIvEGOx5tP0im0t9/c+qk8a14dSXIWzZZ4k4=;
  b=g3qa7gjwEDIRk9KTqTkiPO3twhXLkUvtjKKvIwTgsTnc5oI2k117ljiL
   AvV/55v1Wh3YFRoaQOTvNGCISB4l8ycjIr0mbNUV9Cq1+4Qsh4gBU7cev
   2464FilUriOZWaBBj2+voGsqRwTkPgTB+1TA33u5CDtV43vbgd7cJloPu
   GBoT/QGdP1N6fZVU4Mm1ia/PRJaAbjDwEO7bSWLfH41uUYIsaOyfjAtUe
   oPyumnNQ4nO7RTj2e162QnyooUFTbYH5vrRhb9IukYVf0QJE43HRqCDpF
   FQQkcY/SfvS0cpyu80CJHCqFyzqHeVzpGxUY7lYwYnILjMELklEj7Kpxj
   A==;
X-CSE-ConnectionGUID: fokpeEzWQYKh7ZuLDp2Dbw==
X-CSE-MsgGUID: iDZ2FCOiT0qIE02apK1NiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888226"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888226"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:18 -0700
X-CSE-ConnectionGUID: ZU5LhrNNRr6svUSkdbU55w==
X-CSE-MsgGUID: j7Yn9Wz8TJi77uhl++Amcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440084"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:16 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 27/55] i386/tdx: Enable user exit on KVM_HC_MAP_GPA_RANGE
Date: Thu,  8 May 2025 10:59:33 -0400
Message-ID: <20250508150002.689633-28-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM translates TDG.VP.VMCALL<MapGPA> to KVM_HC_MAP_GPA_RANGE, and QEMU
needs to enable user exit on KVM_HC_MAP_GPA_RANGE in order to handle the
memory conversion requested by TD guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
changes in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b0ee50d76208..0a6db6095e3e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,8 @@
 #include "system/system.h"
 #include "exec/ramblock.h"
 
+#include <linux/kvm_para.h>
+
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
@@ -383,6 +385,11 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    /* TDX relies on KVM_HC_MAP_GPA_RANGE to handle TDG.VP.VMCALL<MapGPA> */
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+        return -EOPNOTSUPP;
+    }
+
     qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
 
     tdx_guest = tdx;
-- 
2.43.0



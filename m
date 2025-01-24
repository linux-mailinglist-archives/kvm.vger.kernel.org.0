Return-Path: <kvm+bounces-36488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C795A1B6E3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 897D5188C606
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424085D8F0;
	Fri, 24 Jan 2025 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBVIYlxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC4288CC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725834; cv=none; b=m6475Ux0IKD/XDKO6doT72VilpktMXwfWgtKj7oNJ8KZLQLoiBNFEw/rYTjT0Z+7gwVK1RsMXG8JJISsoeH6sDL+RR0YN7C7q10ckfS6X5CpWosCmvHE/swUCcu9g5gnCzzyFO9QyaJad4Gvi25jeZXNpEcBut7FTEEdz3GgmjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725834; c=relaxed/simple;
	bh=BZUvfQp9mnJI50UJFjmIm2ZYfyW4FPAxqgosh1xyGt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ot4cCo70MploWZofdiXH/U7FP3CHJAdAeX8G22Mesv0VfdnEE7/tfvGQTniOhz2TSAXlrHqrWiSsg83mFnb4TLzxmkQkRkqjNnaonvDm9H3H1m63cKvvb0poCDaQqTLfic9Vu1jQ7eEkoMdq6dOnO45TLemwYXtwGTxlun7c22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBVIYlxq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725833; x=1769261833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BZUvfQp9mnJI50UJFjmIm2ZYfyW4FPAxqgosh1xyGt4=;
  b=WBVIYlxqgw/SsASnZQYNkrkkjKa+ZYrSs+EvkoReLxZHDsa0Q0CZr/yi
   r0LnN3RQ9IVkyIVXNfX0T25d+UqRp6B72qj1ApXtSwT9oqs0IIyatIWug
   R7m6Q4U/Rz3TRKWlroWjy6XtS5wg9c7e6qNCdsnjgH4vcbvebv+S+LW1g
   b5xsSF+HQfk15AnC9hA5+kE2oAcDgK1BoEqrCbu+FISCHu9yYeNPwCmEO
   SYV+U0JUFOHnRxBvQs8kHfOpwYpi/A+jGrMu3wZclh7FlanZQdqwCOAYI
   kapRTWyI7hAKuoxGIVsdhyVkE+wPRLixqp3vxR5O35Hl9EpjPr1/YHOIr
   w==;
X-CSE-ConnectionGUID: GRTTXzVbQR+2ZxEALUZLFQ==
X-CSE-MsgGUID: 42RRrMa2Rfu1UuYuNsP0RQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246195"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246195"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:13 -0800
X-CSE-ConnectionGUID: /dzKgrkJSOi+NkXxLcTFyQ==
X-CSE-MsgGUID: jSTFy9RQSH6OtrKHF47l4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804135"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:09 -0800
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
Subject: [PATCH v7 03/52] i386/tdx: Implement tdx_kvm_type() for TDX
Date: Fri, 24 Jan 2025 08:19:59 -0500
Message-Id: <20250124132048.3229049-4-xiaoyao.li@intel.com>
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

TDX VM requires VM type to be KVM_X86_TDX_VM. Implement tdx_kvm_type()
as X86ConfidentialGuestClass->kvm_type.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new added patch;
---
 target/i386/kvm/kvm.c |  1 +
 target/i386/kvm/tdx.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee812..4f1cfb529c19 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -191,6 +191,7 @@ static const char *vm_type_name[] = {
     [KVM_X86_SEV_VM] = "SEV",
     [KVM_X86_SEV_ES_VM] = "SEV-ES",
     [KVM_X86_SNP_VM] = "SEV-SNP",
+    [KVM_X86_TDX_VM] = "TDX",
 };
 
 bool kvm_is_vm_type_supported(int type)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index ec84ae2947bb..d785c1f6d173 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,8 +12,17 @@
 #include "qemu/osdep.h"
 #include "qom/object_interfaces.h"
 
+#include "kvm_i386.h"
 #include "tdx.h"
 
+static int tdx_kvm_type(X86ConfidentialGuest *cg)
+{
+    /* Do the object check */
+    TDX_GUEST(cg);
+
+    return KVM_X86_TDX_VM;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -40,4 +49,7 @@ static void tdx_guest_finalize(Object *obj)
 
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
+    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
+
+    x86_klass->kvm_type = tdx_kvm_type;
 }
-- 
2.34.1



Return-Path: <kvm+bounces-36489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DFDA1B6E5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C7D3AEBA5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75F44AEE2;
	Fri, 24 Jan 2025 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VUkDsua4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7A288CC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725838; cv=none; b=EcIwweTve1RSTUllSVI4WN5rwRGF3Ow+kqWYfkbkYlTQIVcetV1797J32SDXiJcKS86vXrw+o0GupBMczVmhwhkk685rkkF8b/diYeO3EyvZYMYj4NdGdD4tYIs+E4NwJ76s1G2PlJC6pr+4hJ6P2dFhYOn1ympBybtI4ttc9KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725838; c=relaxed/simple;
	bh=i9LA0fuEWyXT3xhCEP6n86n3NtpzUzrXs/78mYcqsME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ayuYmvbGQ4sTSjcD1EnykHNGX9ai4Z82xnvZ+6Py3LSbroModCwIAwjpc/Mp9MNOkLjHGB7B/tPZY3AJd/epEf7qcfFs+Ca9K4gWByD0GG+WiFfOwevrh04+IqoyfGXHuRK77x/jQvnt9pLEDBHtn4vqANfmXZNvZoWzx+8WBEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VUkDsua4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725837; x=1769261837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i9LA0fuEWyXT3xhCEP6n86n3NtpzUzrXs/78mYcqsME=;
  b=VUkDsua4ZJUkqEgIIGJiPZnlwxMBRamqRByYOpzylj+6G1qNXUGwRDnA
   66hj7jzn+fJrcgnvrETcyJOkMrf8yr6F/FMwb5aIuVrPe72dOJ4s2rLuh
   39E6heH9qjE1XPFG/KRdMml5KdCnfLv19dtd2/FAPVTEvAblXZEMGqqMi
   ZMPCmsbCXjtK33yNProjnkrXODrz4lQxen/yr1mimjH20Mc6YwGamgBf3
   Fq1OFtOvGtCYGDb1bV3HWLjitp4i4sJDNrkchEwIcxOL9sAioFzxEIClS
   b2A94uzAmHkrLQ8cPYuvpyGtRcc+hrwZ7/1gkIj2pOds1Sny/8xT6Q0HE
   w==;
X-CSE-ConnectionGUID: olVcg8jTRvuqWd7hSPLgEw==
X-CSE-MsgGUID: IraEXB5eScKVN8EWo0EEww==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246203"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246203"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:17 -0800
X-CSE-ConnectionGUID: LXPp8NS6T+eY4He+6eGZug==
X-CSE-MsgGUID: VaujTO9MSPe0H47yz7hBpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804141"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:13 -0800
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
Subject: [PATCH v7 04/52] i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
Date: Fri, 24 Jan 2025 08:20:00 -0500
Message-Id: <20250124132048.3229049-5-xiaoyao.li@intel.com>
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

Implement TDX specific ConfidentialGuestSupportClass::kvm_init()
callback, tdx_kvm_init().

Mark guest state is proctected for TDX VM.  More TDX specific
initialization will be added later.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - remove Acked-by from Gerd since the patch changed due to use
   ConfidentialGuestSupportClass::kvm_init();
---
 target/i386/kvm/kvm.c | 11 +----------
 target/i386/kvm/tdx.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4f1cfb529c19..1af4710556ad 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3206,16 +3206,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     Error *local_err = NULL;
 
     /*
-     * Initialize SEV context, if required
-     *
-     * If no memory encryption is requested (ms->cgs == NULL) this is
-     * a no-op.
-     *
-     * It's also a no-op if a non-SEV confidential guest support
-     * mechanism is selected.  SEV is the only mechanism available to
-     * select on x86 at present, so this doesn't arise, but if new
-     * mechanisms are supported in future (e.g. TDX), they'll need
-     * their own initialization either here or elsewhere.
+     * Initialize confidential guest (SEV/TDX) context, if required
      */
     if (ms->cgs) {
         ret = confidential_guest_kvm_init(ms->cgs, &local_err);
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d785c1f6d173..4ff94860815d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,9 +12,17 @@
 #include "qemu/osdep.h"
 #include "qom/object_interfaces.h"
 
+#include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+    kvm_mark_guest_state_protected();
+
+    return 0;
+}
+
 static int tdx_kvm_type(X86ConfidentialGuest *cg)
 {
     /* Do the object check */
@@ -49,7 +57,9 @@ static void tdx_guest_finalize(Object *obj)
 
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
+    ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
+    klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
 }
-- 
2.34.1



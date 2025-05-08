Return-Path: <kvm+bounces-45938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E26DAAFE90
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0DBAA0057F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13276286894;
	Thu,  8 May 2025 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2EXCn68"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AC627A92F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716805; cv=none; b=qQfKr2mu+K1qTs24Jgw+fK795zVUxhSYeaJr7u/cgA28D2G7ONN5dcxToLt034P6C6+0zh1eCEyi68hOL4ZeHgMOX9KlUlWrflOl9pb3CCeyVK8ih3BNMIIRzoJI94gMJLN2lProRTRXdGb2TivjnCvYFYfClrR8CqC4j4y19NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716805; c=relaxed/simple;
	bh=YmCa7zoYtTHNTICSUV5h/a350LP+yR4U4Wccw1mBbJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjytAx3VHSal72yC4TOlqSgE5rzsk9Kb+twgAI/of7R+icPTFlv0wLsviLWo7druzrC/MVZHui0GiKw33zrb+aTZUWZ2/XLmbik263KG4/n+9aD/FnS5W8s0B5y5aFG7xyW8caMtRIjvX4fpbs5FrYpWDffzg6oB5Y0bBYXUPeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2EXCn68; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716804; x=1778252804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YmCa7zoYtTHNTICSUV5h/a350LP+yR4U4Wccw1mBbJQ=;
  b=g2EXCn68By1rqg/aalYbsMDmFUxpQrQd2lbrwa3/vioZhPui2X8MsSef
   TpuPlY6OnQthVGfAalSYXMXKb7zoWjyimKOduE5Vzp3RUgdF3RQ+8iN98
   YHffDHZOde3oHRFjvHdBlPzqpu754PfQ4Id/MlmJ25ipEUYll8dlf+dxD
   93Ib9bcRsmfqaIwI6XFiKjcks0mRwFRyQNsJ1mPAgHw4VZbW6PmVN+7Vl
   oIfHrDZSHJK42dy7suGH8BqQPpjZkCChoWXkIVSjRddvdytWgwglIrZPa
   /dQ6ZTcjhL4SdgTZuaBePba2pP5Qxs3+ShOPBJGJU+tzX2L1EihyGgal7
   g==;
X-CSE-ConnectionGUID: Z+IYHfh4QTSkU+j7adv+LA==
X-CSE-MsgGUID: OXm8McbtRSiA+9hzNJGo+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888310"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888310"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:43 -0700
X-CSE-ConnectionGUID: a6cIEoN3T9qpGCR3d8txyw==
X-CSE-MsgGUID: JLNsX0GwSO6uYTTMiDUSsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440223"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:40 -0700
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
Subject: [PATCH v9 35/55] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date: Thu,  8 May 2025 10:59:41 -0400
Message-ID: <20250508150002.689633-36-xiaoyao.li@intel.com>
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

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used as shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 32c8f0ba968d..db5a78429cb5 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -391,6 +391,15 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EOPNOTSUPP;
     }
 
+    /*
+     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
+     * memory for shared memory but not for private memory. Besides, whether a
+     * memslot is private or shared is not determined by QEMU.
+     *
+     * Thus, just mark readonly memory not supported for simplicity.
+     */
+    kvm_readonly_mem_allowed = false;
+
     qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
 
     tdx_guest = tdx;
-- 
2.43.0



Return-Path: <kvm+bounces-36525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9EDAA1B71C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5699A3AEB89
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5429814658C;
	Fri, 24 Jan 2025 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GyrlkN45"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1142614658F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725970; cv=none; b=mcWaQtGIXOZg0ZEJW5SjLZmb2Dm6ASZtykiDgxFyOwAuLB9Gf/Pzk3JiHwo7mo+1GtkJdPJ64He60A+ivrwQ+t4GFaNIjZacEKaqsTZYIILXtD2Tdbwgo4YDfz8qXe6JOn+d7Td84x+kbCRUZD5FaUQB782BubhnPoA1M+fwKac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725970; c=relaxed/simple;
	bh=Cg9zFgAAzu9TXNw0/8UbOMWfLRF5mK1sJR1xnM0x7yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gWx/AxdcD6KaRQFnCnkp4a42rqr5euvhUrNAyVp/9gD+1OxSNxvZnbSqDVEdsIfJyAnmbDnBINdvHj+Yhlq1RMgVNthbPOIHCmVrGJH6HUmAFct6QgDZUnnSun3AjpDdiOWpmzwr+3OE2DrP7F6S0fV+RKiFFGq6ktvoBJT2EYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GyrlkN45; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725969; x=1769261969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cg9zFgAAzu9TXNw0/8UbOMWfLRF5mK1sJR1xnM0x7yE=;
  b=GyrlkN45I8ohXUDSnXwX92jTe2Yn7IgH2m5lenjO9suGVOUHo0R2SufQ
   lPaap18ezVEazp44tp8bfFIcDW/KXna7mozHOZpBW5Bhjg8i9pDjmYeAw
   fp5lPpZxdaF+WYDhN57l9vlPZ9vY/OZWTPkFy0oaT26ZrH1u5bvjl5l6V
   eoXADA8WFFrr6cd7cn4crLOSrQdwEouTcGMQi1HpJFVZBGCBdcAh7YWj/
   WyGybGqS0bOnOdQUOj2OzgQyFb6Ux/ObxK31M4tmmAOuwRalSf/pcMe3W
   JdPqqreOAacXK+ohd5+5hYGf3U67SAccK92YXYSUSFkySSulD6RKzXmyd
   A==;
X-CSE-ConnectionGUID: J1dQQnU+SaK7QmP6+SkbCg==
X-CSE-MsgGUID: gJWUTbXxQY+23POWxa33BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246541"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246541"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:29 -0800
X-CSE-ConnectionGUID: QgXs53yKRAimdFJ5U90NLA==
X-CSE-MsgGUID: zZ33BOzxQ56B2EFNvXjAYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804435"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:25 -0800
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
Subject: [PATCH v7 39/52] cpu: Don't set vcpu_dirty when guest_state_protected
Date: Fri, 24 Jan 2025 08:20:35 -0500
Message-Id: <20250124132048.3229049-40-xiaoyao.li@intel.com>
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

QEMU calls kvm_arch_put_registers() when vcpu_dirty is true in
kvm_vcpu_exec(). However, for confidential guest, like TDX, putting
registers is disallowed due to guest state is protected.

Only set vcpu_dirty to true with guest state is not protected when
creating the vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v7:
 - new patch to replace "i386/tdx: Don't get/put guest state for TDX VMs"
   in v6;
---
 accel/kvm/kvm-all.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e35a9fbd687e..c1fea69d582e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -466,7 +466,9 @@ int kvm_create_vcpu(CPUState *cpu)
 
     cpu->kvm_fd = kvm_fd;
     cpu->kvm_state = s;
-    cpu->vcpu_dirty = true;
+    if (!s->guest_state_protected) {
+        cpu->vcpu_dirty = true;
+    }
     cpu->dirty_pages = 0;
     cpu->throttle_us_per_full = 0;
 
-- 
2.34.1



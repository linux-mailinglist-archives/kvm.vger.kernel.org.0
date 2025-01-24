Return-Path: <kvm+bounces-36519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF28A1B713
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D2BF162970
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCE413D8A3;
	Fri, 24 Jan 2025 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQInJ6Ye"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556B3596F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725948; cv=none; b=lgoF9Yz+Kx2Gy8Ds+xDyuBYBQY7h3JSrnZ5blr6TMQtxrrVteq4tfptG8v/5QzvGJWuFyUq4YBgnzPHcS8lhzO2kOP+g+6q0dNlPkP3zVGb2sF+NxgeoO9vvLs7Cg+AsYABBGzeZkvwMqeeeOn/QbBok/gUxq8AWwJfkS0GLlko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725948; c=relaxed/simple;
	bh=UJnACVf3T37Fmb+2OQU8K8i1iB2c5T66nUw1V5dXM4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R4RsCvHZjssyDlJ0yU7Dh7t9cPYGT86hy2P7UdpdEmWnBPQBFOgL6ZWxqwgM/nzwtgjZRmotPlIXh72z0Z0BL/yNbow0PU4BppRI/R+nnYs/suDfvShNh7jNQOaFCYSZORZ6m4OuQaFmCondvnX+6O177Xjv3jH5tHhQp7KmwWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQInJ6Ye; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725948; x=1769261948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UJnACVf3T37Fmb+2OQU8K8i1iB2c5T66nUw1V5dXM4U=;
  b=AQInJ6Ye55//u17K5+WUNb4wtl5SbK2COUE75Tdi+sWc1Pdss7oUUgyJ
   eF8bZx7NPu3afQSROz9dHLfvXWS3I3eT53Sw1gFFm8s11y1he1BIvWH3K
   h3+hTK37vgfM315rHpvxigNjbnW5XSUMOhvdfmWyHtfm2iF9zdiF7Ycmt
   +FNBGTR3xdYs+bHL0EPrM4wnV7CQroPC/TpiDlSy9FgQOdaAmTRVB6i8O
   fhWz6Wn9te4Xj8vDXgVWE1RVawYgtM+z4AlSrF0cJQpsmn0ARRU4icOhv
   4XHzZkyaT39lhIWM2qdlg5Y/NpIqo6OhUugI22xXYUsXIrX4twMlp7RFT
   w==;
X-CSE-ConnectionGUID: qF66athMTpqYvIgyT5C5wg==
X-CSE-MsgGUID: oj9dIcEDTSOj0Dr2M5WcBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246495"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246495"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:08 -0800
X-CSE-ConnectionGUID: NZCk2prLRXuPRRpgoNNQAg==
X-CSE-MsgGUID: aLb6l2I8QYiC9kP7w1rUkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804398"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:03 -0800
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
Subject: [PATCH v7 33/52] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date: Fri, 24 Jan 2025 08:20:29 -0500
Message-Id: <20250124132048.3229049-34-xiaoyao.li@intel.com>
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

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used as shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 982ed779df4a..f4d95b0a4029 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -382,6 +382,15 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
2.34.1



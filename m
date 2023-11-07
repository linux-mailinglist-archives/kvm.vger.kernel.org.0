Return-Path: <kvm+bounces-943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EFB7E428F
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5401BB223B2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE79D358A2;
	Tue,  7 Nov 2023 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f37hAQ1Z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19235882
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:00:01 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1363E3AAF;
	Tue,  7 Nov 2023 06:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369175; x=1730905175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TZ+z91imsScQD0p1/VsSa1GqbET/iM4ZKqAoChx+Rzg=;
  b=f37hAQ1ZcgRrPDT3SKhKZ4Fjto3zUAatbTmgjk6pFX1SopK1yVA/Z33z
   Fv7Ctbg/5mLg9F2cVL3HNNfDJj8gMXFeLQGExSnuAl1XbN6Nwnz6/Ziiy
   AAdI91QV+K+0l+iIJYxTdI5yLn42ElluO5qV+dWn9IRHVb5Pqe+3lkxtz
   KgoXyEjOVxvMcheemQxbpdE06YMe33cyg1F3VoNp3B7ieKxaviH77QulO
   1lAXIMFSotccZx9Qiv8eDsZpB7ufSuftnKgWWB0JaNa9qbO+aW41EhBl8
   45cQbcL7CUhZx4vA/P1Y4+ShNEzxiGtpqtFQT1eHf69JOdzSWAVXagtug
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462387"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462387"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851430"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:15 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 057/116] [MARKER] The start of TDX KVM patch series: TD finalization
Date: Tue,  7 Nov 2023 06:56:23 -0800
Message-Id: <bb2f303b5213b85e98be4034b75a73106bd127f1.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD finalization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index c4d67dd9ddf8..46ae049b6b85 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -11,6 +11,7 @@ What qemu can do
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
+- Qemu can populate initial guest memory image.
 
 Patch Layer status
 ------------------
@@ -20,8 +21,8 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applying
-* TD finalization:                      Not yet
+* TDX EPT violation:                    Applied
+* TD finalization:                      Applying
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-- 
2.25.1



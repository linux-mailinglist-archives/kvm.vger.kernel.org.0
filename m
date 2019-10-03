Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D57CB148
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfJCVjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:52653 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbfJCVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051650"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:58 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 13/13] x86/Kconfig: Add Kconfig for KVM based XO
Date:   Thu,  3 Oct 2019 14:24:00 -0700
Message-Id: <20191003212400.31130-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CONFIG_KVM_XO for supporting KVM based execute only memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 222855cc0158..3a3af2a456e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -802,6 +802,19 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_XO
+	bool "Support for KVM based execute only virtual memory permissions"
+	select DYNAMIC_PHYSICAL_MASK
+	select SPARSEMEM_VMEMMAP
+	depends on KVM_GUEST && X86_64
+	default y
+	help
+	  This option enables support for execute only memory for KVM guests. If
+	  support from the underlying VMM is not detected at boot, this
+	  capability will automatically disable.
+
+	  If you are unsure how to answer this question, answer Y.
+
 config PVH
 	bool "Support for running PVH guests"
 	---help---
-- 
2.17.1


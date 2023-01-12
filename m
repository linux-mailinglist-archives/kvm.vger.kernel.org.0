Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E846E667B38
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbjALQk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbjALQhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C65DEF9;
        Thu, 12 Jan 2023 08:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541230; x=1705077230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7xbvDeVo6hkQKWgPXjbAZQCa6LensbFjiGsnnkXHDAY=;
  b=YJjhabaBQdrwyaHaVVcekXkABnaKDBzcReHlmKA5B1aKB0xc6BWusUtE
   cLA82UYa6L9xEOotkEOKZ0klEb2oUjpjQ1oiYL4xSqk+iqsbUkP0zieYw
   UBEiNRZ4xQKwWXn9D6Kfqy5Vlxy7jlKAcKkhxWUFdU0buPqhjCfhlj4Gh
   nt5NdpPTK9a/oX9gMRQ7Qz7teoCnogZV2sdYM4ymuiyPK246KLLG8tYME
   Y5EDmv+KZDiJEZKZEJAkLul2sbE+BnDVnPaBfXfzyNOkls7B39Da7+D/k
   0CxeB79LGK6UG6FD3Vd2zUkjwR8K+rLL7/mf0AzXPMmLjkBPeGdV/vlfF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811674"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811674"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151644"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151644"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:20 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 007/113] [MARKER] The start of TDX KVM patch series: TDX architectural definitions
Date:   Thu, 12 Jan 2023 08:31:15 -0800
Message-Id: <1868eee72017f04e6fe253118ebb9435f4056868.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TDX architectural
definitions.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../virt/kvm/intel-tdx-layer-status.rst       | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
new file mode 100644
index 000000000000..db32e89e16e9
--- /dev/null
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -0,0 +1,28 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Intel Trust Dodmain Extensions(TDX)
+===================================
+
+Layer status
+============
+What qemu can do
+----------------
+- TDX VM TYPE is exposed to Qemu.
+- Qemu can try to create VM of TDX VM type and then fails.
+
+Patch Layer status
+------------------
+  Patch layer                          Status
+* TDX, VMX coexistence:                 Applied
+* TDX architectural definitions:        Applying
+* TD VM creation/destruction:           Not yet
+* TD vcpu creation/destruction:         Not yet
+* TDX EPT violation:                    Not yet
+* TD finalization:                      Not yet
+* TD vcpu enter/exit:                   Not yet
+* TD vcpu interrupts/exit/hypercall:    Not yet
+
+* KVM MMU GPA shared bits:              Not yet
+* KVM TDP refactoring for TDX:          Not yet
+* KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


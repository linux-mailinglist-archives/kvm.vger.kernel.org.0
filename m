Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D687E6B698D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjCLSEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjCLSDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:03:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F69C4DE36;
        Sun, 12 Mar 2023 10:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643984; x=1710179984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
  b=TKGJTfBkzLQZt14czRMhNYXp/JfpdSy4foR+lM4t1yAJjuuu1o7wAD51
   5Fy9Dco5mwbUplxTnfpgQad0gzbpDhw4WAKCOloGPzGGQT+Bg9VqsBwj2
   MSZPbILsQK9Evuuq74Bp/E+ojR9Vx9eZDJhmPLN/HcU4fGHutDK9sTDM+
   h66Z8TtCrpFAduXHIKNmWVAmv3DhOw1Hs09fe31eodK7EE8jqf1gzXFTd
   iQOvi3fk8OAc3QfbxSoNARz8TD9ktHRKU7X3r4YAgIIzefis2Tu8pU6jI
   /3Ehe9eej7L5atRUnsXLpLiaelU/TFmMYBi9q3YqL3JwHXbY05KJOh2NP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659974"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659974"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596720"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596720"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 069/113] [MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls
Date:   Sun, 12 Mar 2023 10:56:33 -0700
Message-Id: <69c166e90226e45172d1dc6fcbeb74b592884592.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD vcpu
exits, interrupts, and hypercalls.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 33e107bcb5cf..7a16fa284b6f 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -13,6 +13,7 @@ What qemu can do
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
 - Qemu can finalize guest TD.
+- Qemu can start to run vcpu. But vcpu can not make progress yet.
 
 Patch Layer status
 ------------------
@@ -24,7 +25,7 @@ Patch Layer status
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
 * TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applying
+* TD vcpu enter/exit:                   Applied
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


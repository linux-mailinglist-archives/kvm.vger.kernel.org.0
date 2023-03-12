Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576C86B6947
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjCLSBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjCLSAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:00:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEA83C7A8;
        Sun, 12 Mar 2023 10:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643919; x=1710179919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESlsFtK7TCNNodzGvNFsc1Y94K335DvZHywlXfgF6Fc=;
  b=lKp7bqfBdbg7euZcsUz1cJdTojKc9hajT4LpWxA/DAkAMzjdI1F4HB9r
   Rc2/+td2h5B8fJTbS4sSF4hl6YwdriH4qLUz7GjvsdtxCSAZjMO/92Zm5
   r5s2cNIdEffBJ5fsneJOw20/TrJuztzwTzD5VFXu5cAEFxKQ8R+BYuIkM
   BrTJgnsytx+L7ZY1+L9ckvHc4cB0IChHLXjxJYpCEmtFaLcXhm7Oc6WtT
   CvRaqRTlpHRFYi1qDvNtiDmxdo4GntmhsC/HC0Qg4KBnA9qXYSqlpvKnH
   xmVrOvOiipObzFrUBvsL889cO0LFh2MGqq+YPDifsnu5NUQJhu7JpWVOf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863646"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863646"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628397002"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628397002"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 026/113] [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
Date:   Sun, 12 Mar 2023 10:55:50 -0700
Message-Id: <8c0280bdb6bafd7d7f1e36f7c607eb4dfea8d326.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM MMU GPA
shared bits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 25082e9c0b20..8b8186e7bfeb 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -10,6 +10,7 @@ What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
+- Qemu can create/destroy vcpu of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -18,12 +19,12 @@ Patch Layer status
 * TDX, VMX coexistence:                 Applied
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applying
+* TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Not yet
+* KVM MMU GPA shared bits:              Applying
 * KVM TDP refactoring for TDX:          Not yet
 * KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


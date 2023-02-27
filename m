Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D10D6A3C78
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjB0IYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjB0IYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FA01C305;
        Mon, 27 Feb 2023 00:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486251; x=1709022251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yLb9uSg9ibzit6JQaiXE1CHceF2wSNvx507S82c8rJA=;
  b=XFTu2Dj7grgiZpzJz1xJq0jOi7Pw/oGRX71UTROvGTM0HVcBO2m8HGGp
   fqjeGvHY8k/XqOwUvpgwBNAd74wKD07zw4jJC6cmglB4dK6S7s2SJHHxb
   BtmqonHpAkQYFSHLTSATaAkrktgsLaP0S0l5bPb3sOk9Ebo8Rd6cd3zUI
   QssHUkQQQ8Bw/Js/7qDbQ4HFipCKSEf1z4l5Kn7+k+yO+HUkf83n2nRqg
   SO0Hr3vd9M+MiwRGsh0DFr8H98aJAPrHR1kNCaZ+GAty00gjtgj6Eis8o
   IkIQaYs1GvIummS4WFNGLt7C1aIeLKH32OGZt5CiMgEKKwBuD6RX0GCnF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608728"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608728"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242074"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242074"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:03 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 017/106] [MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction
Date:   Mon, 27 Feb 2023 00:22:16 -0800
Message-Id: <1764bee4547d53ee40137737a82b9dd712fe307b.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD vcpu
creation/destruction.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 221372cfb4af..a4ee04271d66 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -9,15 +9,15 @@ Layer status
 What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
-- Qemu can try to create VM of TDX VM type and then fails.
+- Qemu can create/destroy guest of TDX vm type.
 
 Patch Layer status
 ------------------
   Patch layer                          Status
 * TDX, VMX coexistence:                 Applied
 * TDX architectural definitions:        Applied
-* TD VM creation/destruction:           Applying
-* TD vcpu creation/destruction:         Not yet
+* TD VM creation/destruction:           Applied
+* TD vcpu creation/destruction:         Applying
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
-- 
2.25.1


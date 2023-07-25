Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47CE7625EA
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjGYWQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjGYWPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9565C1738;
        Tue, 25 Jul 2023 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323341; x=1721859341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DLPNi9jXjbr4HdbjAnuHBOpBxwIVUIeOA5wtFcSAGOI=;
  b=UPI5p41bqGYTD1i1T5r4Y5Hc7S9u+3dL3ABRce3/xtFCEMjM4lxTu+JZ
   51Boezb9j4KzD+Zkwzz+vTuR9UDl1Nho9QLJsd5PO/A+DCWedQ43EP+X/
   A9vkG1s27SyFAZxJspn6bpGfSNOzcubbTZI0iFJSaDLPhQsX06Fvxf9qw
   g3TYmjFYujICCSKNLIdBcELkDvg7sjgFf7ViGYtfqnhOQu3oUCDpYpDfy
   EjWGKNbErBM83TmDfdrbozdoE6+hK3eDWlp9DbfOM7KQZX5zs/kNUDQC/
   t7aPjQMwKMZJ+rnalHFsjm7a7z/DqP29MGiM6k/MOr9LtCbWWDD58+TRa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863098"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863098"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938810"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938810"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:20 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 014/115] [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
Date:   Tue, 25 Jul 2023 15:13:25 -0700
Message-Id: <860b9552ec678720560e6dc60123b7dae69e0642.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD VM
creation/destruction.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index f11ea701dc19..098150da6ea2 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -16,8 +16,8 @@ Patch Layer status
   Patch layer                          Status
 
 * TDX, VMX coexistence:                 Applied
-* TDX architectural definitions:        Applying
-* TD VM creation/destruction:           Not yet
+* TDX architectural definitions:        Applied
+* TD VM creation/destruction:           Applying
 * TD vcpu creation/destruction:         Not yet
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
-- 
2.25.1


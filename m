Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851E57CAF7F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjJPQeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjJPQdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:33:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9B71993;
        Mon, 16 Oct 2023 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473231; x=1729009231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DLPNi9jXjbr4HdbjAnuHBOpBxwIVUIeOA5wtFcSAGOI=;
  b=jdcZ6oZvg1tBIwusPXCI47aKnxjrHbRCh46hHGvDwrHrzTItxQacZl3R
   TRwhu1COxuEWTdttSkAiGcVmsghYkzwzgBl1XETyK97b7TZdVDBAkkbhH
   Oe35qRR3r61cvIV36WDUr6l+b2zwM1y5vLzeSWrGrUGquAsCI5BGVYS+D
   Ct6a48UQlDu6M9DGM4VuGbRkSTxJ2D2p3+tD0JtEnTvcVTLBIXp6ZSCtk
   ixjxUIo+POWnBQTJ/FCjEnUUJqBf7tsLAU8PN8ZSTiRaDCf4EyNGoEWUI
   C0a6ioSo05IzJLpWEViZIIj1Lzd9FkNB6Mu8uO4M813DpnR1afOFXx0af
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825928"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825928"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126006"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126006"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:26 -0700
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
Subject: [PATCH v16 014/116] [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
Date:   Mon, 16 Oct 2023 09:13:26 -0700
Message-Id: <560ed9d51b7b2fe138aaffb8a45bb45e909ad553.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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


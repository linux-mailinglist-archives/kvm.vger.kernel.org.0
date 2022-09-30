Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC935F084F
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiI3KS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiI3KSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB5A15ED22;
        Fri, 30 Sep 2022 03:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533133; x=1696069133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wbnROJIV0sPi9VRc1Kym0LCeIa3DweI4YQjfi8+X354=;
  b=A3ymsemWVvTrFIRmc9oGI7Yfy7sde4UK8nPLbQvfjaY3dJMfM6gS2BYm
   +GucV7q/UdyP+84vWxzc2JyB2xTm21kQbjRNsTBw6aaj9aW4ajHM0pdxb
   eOcoW5BRFysvhDw2lJoUw4KziBM7CrXk6F9lgQSURWeogRmRzs0V7Db3J
   w5XoOvp6EyK8TNHnfHFdqn379gjHEREnfqgZhDltucQwc3gy8bH7/YuZL
   TF6PCxFr2R67KA0Hd54y9nVbsZzdQUUAEgG4MXIlawbc2pApCEa+ROXqV
   eHGB9cOXe1BypfSrkhJrdalGBt/Rqbgo3Bh77l4xc9qEnULRQjrWqON15
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870062"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870062"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:53 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807547"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807547"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 013/105] [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
Date:   Fri, 30 Sep 2022 03:17:07 -0700
Message-Id: <6f518b2e03b8b8fb1d84fe29096b240b32b65064.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index b7a14bc73853..5e0deaebf843 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -15,8 +15,8 @@ Patch Layer status
 ------------------
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1CD612829
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJ3G2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJ3G0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:26:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A9228;
        Sat, 29 Oct 2022 23:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111060; x=1698647060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aIudZd3USQowTJaovq/Lv5Tlgdhp2EQL5ZZ1g16g3i0=;
  b=ShleHIpnPKu+sII5anUU995YeDbt9ghLqjyN685FePR65J65drzhjwhH
   vBfXWNlzPBxr5C39gJF5xbQ3T8zaBSoPuJXpF/g4e9T6v5MKBpM/hp3n2
   Fr0MnVYj9D8QK3FnVRirGfsVhEobazqEacYf0uFzcLLzEpNeGtkSfuaiS
   FpV6s+t5k6hDf+XRNxNaGUGlnYLx9hRgZUNKvbl4/DuzcdZgdlQe+6bDM
   giBqELVW48xDxSW6RX/6PlOkyh9UnLBY44+0u2zZUVmrbtk3Z1T/nrZeh
   sP+GgfBxW4jh4pNxEU6Wazy9hazshKcPlSW/tUx+0XCd/llDbU4LY2+BM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037179"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037179"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393057"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393057"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 066/108] [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
Date:   Sat, 29 Oct 2022 23:23:07 -0700
Message-Id: <911804bc3c3773bcdc588d665aa472a76e8856f9.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD vcpu
enter/exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 53897312699f..b51e8e6b1541 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -12,6 +12,7 @@ What qemu can do
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
+- Qemu can finalize guest TD.
 
 Patch Layer status
 ------------------
@@ -21,8 +22,8 @@ Patch Layer status
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
-* TD finalization:                      Applying
-* TD vcpu enter/exit:                   Not yet
+* TD finalization:                      Applied
+* TD vcpu enter/exit:                   Applying
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


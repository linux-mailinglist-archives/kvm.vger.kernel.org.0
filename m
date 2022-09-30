Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30405F086F
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiI3KTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiI3KS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77D215ED3C;
        Fri, 30 Sep 2022 03:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533137; x=1696069137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dq/4kTxFog2mJ+pfF6ngUCSHtSzKcfcxTCggESSMMVA=;
  b=lDWrp6461vT9HQdy2m4rHKaIs7xyB6qRSOVllK3C7UImUx9q0JXdhKdz
   j93H1PTBJRdHv4mv7Yq0OTKdAB4KOGuQA/dBhrYjrYB88aJXefsIoqbCm
   B/GAS3lwx82bcB/XYzs8StLlir4fDnBcMeUYOo7p9P0gQTaREs0FbaHdi
   73FLdRiZnylX+f9T2LSrLV3sdLlA4dwT/0zBK6hbxc058ybSTScowfYFR
   +19luK8sBBUu+UN4EDS9Ai/trCsJrvja1XjcWUjMF8KsMlGBZDoKItbBa
   MuxiqL5P+7PPWHK1MDBrW+THcpijifsL/L9pun291UUwVC23uIxga78bp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870075"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870075"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807574"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807574"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 022/105] [MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction
Date:   Fri, 30 Sep 2022 03:17:16 -0700
Message-Id: <0e3ee395f12d761c4e00a1ce1169d820490c6f91.1664530907.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD vcpu
creation/destruction.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 5e0deaebf843..3e8efde3e3f3 100644
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


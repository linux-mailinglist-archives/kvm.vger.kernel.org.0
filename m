Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A3851C78D
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384299AbiEES0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383414AbiEEST6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1921D0FB;
        Thu,  5 May 2022 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774571; x=1683310571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sOBwFi6TijFmWxRR2u7LJCs6ZAO9aD248QKXtMkkXSw=;
  b=kcApizlDGwjCaI/+rwCfs04HIP5M+Jep580Ognvflvymu8K8xRME6FiL
   iHWfn1rIvQ0SzwVjTbj+TDgQrA3LnTWVEYiUVp21/2g9Cy88e4l+7Ll44
   Bc0qtj7uh12wgD1Od6RuEUbpkjCsoBrP7r4NUQU0fSmccZgOO0simiZh0
   EBFdlqEifpe6DyC9Q4tIMdJsP6zHtt0ikZEVr0diecSU+ChbMCiJVDHty
   4MoD53pjBPnTgqbj3ZFxXt+tn3qEyNhOg79m+iI6qIz9EZTwjo7Kx4Ruz
   zzu+PUaeEbokeYvc/P+Efuarr0IgivYGFR4oPCOiGbNw405EV1YTlycMZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268097129"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268097129"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083517"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 104/104] [MARKER] the end of (the first phase of) TDX KVM patch series
Date:   Thu,  5 May 2022 11:15:38 -0700
Message-Id: <054442f5c4e7b2ef5da7fb3cdbde3e3cbdd9aeb1.1651774251.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the end of (the first phase of) patch series
of TDX KVM support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../virt/kvm/intel-tdx-layer-status.rst       | 33 -------------------
 1 file changed, 33 deletions(-)
 delete mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
deleted file mode 100644
index 1cec14213f69..000000000000
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ /dev/null
@@ -1,33 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-===================================
-Intel Trust Dodmain Extensions(TDX)
-===================================
-
-Layer status
-============
-What qemu can do
-----------------
-- TDX VM TYPE is exposed to Qemu.
-- Qemu can create/destroy guest of TDX vm type.
-- Qemu can create/destroy vcpu of TDX vm type.
-- Qemu can populate initial guest memory image.
-- Qemu can finalize guest TD.
-- Qemu can start to run vcpu. But vcpu can not make progress yet.
-
-Patch Layer status
-------------------
-  Patch layer                          Status
-* TDX, VMX coexistence:                 Applied
-* TDX architectural definitions:        Applied
-* TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applied
-* TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applied
-* TD vcpu interrupts/exit/hypercall:    Not yet
-
-* KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applied
-* KVM TDP MMU MapGPA:                   Applied
-- 
2.25.1


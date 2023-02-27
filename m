Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2096A3C82
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjB0IZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjB0IYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B591C7EE;
        Mon, 27 Feb 2023 00:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486252; x=1709022252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UXNXNU4nYYne5av5LrY+aIKSppF2pcXmbEdX5ewBtCU=;
  b=DpCe2wILAIxBKy6MYZyb0FvnRC0DHoNsJYzGlnSdYlxmCZqaOacEwpUo
   R13H6lDVyQ8yC+b7MAUZER4eRyEqk78FLhPwaaHgTUEO4XqyX7ObCi2HC
   +67tZWntDybLvJviE4JLkcnQaHabJDV7SvrG92sLReXTNEts0B+/9nKrh
   43vbjVijhtaMrBNUSX24x8NsrcNNIxj5fC01jZH2dWI7Pc2KT8H4b94eV
   Pilvz6zTsP1GkVP2MBMS+fL4eMc9LhF9BwE6bloRBMa9eJwdoVFnR/CSR
   dQkmhU2VT2qkzcdan7/WMr4oZSiTVUHnIl/U6dWsn6BJrp4sfnmcoJSIu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608743"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608743"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242094"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242094"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 020/106] [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
Date:   Mon, 27 Feb 2023 00:22:19 -0800
Message-Id: <7e3ac5624457cac3d6f06f85c1d8db74e01db4c6.1677484918.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of KVM MMU GPA
shared bits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index a4ee04271d66..88343749d4c2 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -10,6 +10,7 @@ What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
+- Qemu can create/destroy vcpu of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -17,12 +18,12 @@ Patch Layer status
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


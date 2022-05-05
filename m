Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFF251C701
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383268AbiEESTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383087AbiEEST2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2DA140F8;
        Thu,  5 May 2022 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774544; x=1683310544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrRrgKMz4riAK/ebZ/sI81D2KhEbTTaxZ+pXBobqoJ4=;
  b=JjVkR0rW+eVV7UK5ktNuoTohlxjmRuB/Sg6Bbw8bV2sTHClDw9NONjcR
   aJszWGrsiERoWVBSPdMwkxNP/uHH0lc5rHNmPwKtUH47J04YueZh35EVv
   WccbS1eIk9e8TAvHMCler+aYtaQ7O1ya6KdKex7RzDzR/DzO7R6TCNFsp
   CkVSFA+bHhTVMVbxSO7jnEcE2kisMeX7WDDxHvGxvQGllysOqTHupO4I1
   nWEmJHiYllm7f1TmxVaGUtOuqjaI8m4lQKJLA9QMs1bTFdZGRZRqHxtal
   NYVEXt3DOx6kLHSmrK/XYPPtG1YzAMBuL1ilxjHfwoFetPUz2QoavWFnT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248113868"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248113868"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083241"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 032/104] [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
Date:   Thu,  5 May 2022 11:14:26 -0700
Message-Id: <0003cf30319cfbe25dff1654558b3d6664cb5754.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 3e8efde3e3f3..6e3f71ab6b59 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -10,6 +10,7 @@ What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
+- Qemu can create/destroy vcpu of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -17,13 +18,13 @@ Patch Layer status
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
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1


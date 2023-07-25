Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50674762610
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjGYWSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjGYWQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F86359C;
        Tue, 25 Jul 2023 15:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323354; x=1721859354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdJ2GT4ARrSNbJp3F6eaxutpQ4DdrmPtIT6M7sepMRw=;
  b=Etl0ney8n7SyAZmYoZT4xWEByy3ZhcFakDCeOGb7MCX3oJgQn4QK/kg5
   05dCwGnYeXfDTA09jwPoKzy7gNY03c2ZuZDJmzcs3AML6l2RUyh38m/Tv
   XLSEXfbAy3XYKo5s8Y/lRogqrZTRC+r4nHf2q9kHrq4VnJq9rdDReKLsJ
   kj7nbPGJN3Bj10EL3vckemdVCPJszR7zAeuA+tOha5B8ihZHkIAv2MESi
   ACTzA90/SYpzvxxf6VpiE0CAi75iXzjqZAhBSgXZe16XV9bstx8RCVD81
   aJzLbKefJnqUXJcyG5RvD68f5HxKB4uNhCMbSoAVhLyuOgtxW2TNjS9L6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863202"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863202"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938878"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938878"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:32 -0700
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
Subject: [PATCH v15 030/115] [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX
Date:   Tue, 25 Jul 2023 15:13:41 -0700
Message-Id: <b2b14ab253a7419343a9b016a75064b6a92d5d9a.1690322424.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of KVM TDP
refactoring for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 8b8186e7bfeb..e893a3d714c7 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -25,6 +25,6 @@ Patch Layer status
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Applying
-* KVM TDP refactoring for TDX:          Not yet
+* KVM MMU GPA shared bits:              Applied
+* KVM TDP refactoring for TDX:          Applying
 * KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70986B694B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCLSBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCLSAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:00:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44653C7AF;
        Sun, 12 Mar 2023 10:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643920; x=1710179920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VWeErb8XXD2SBqMy8L7JRBcxtOCdpKU+Rt6/TTjVA8Q=;
  b=TmcuS/EWJCCkqP4+H+Pq4hOlL9VUnJc3KBhTSSxgwCXNhar/AC99s1FZ
   l46e3aGMwdrALsrdxWAGankjG2xNGDF+52QB+cUyfrf323ZnwJ/OgrIoc
   c+012lUCy8N8XJbqCacj/J9BmPSVPmUxx0JBgGnICooZRCzwzzLgu4iqz
   gxogWnJR5qlaV3SSGWG0YI52bmiUf2PZNOfrhCz1PZUzczaoxv18Px01z
   hE2EGpVPpkBRfJaP4SJHhecTPjfajOT4qPzosesqjJGKZIeMdikMJWxVN
   xeLBKZdI0ectcnufb6D0wu+3Pcf7iCTXFaCiRJLibdrazDV5J7S/S0FJp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659882"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659882"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596634"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596634"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:05 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 047/113] [MARKER] The start of TDX KVM patch series: TDX EPT violation
Date:   Sun, 12 Mar 2023 10:56:11 -0700
Message-Id: <ec3b439cab5519050eed13faffbcd1075f3754eb.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TDX EPT
violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 7903473abad1..c4d67dd9ddf8 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -20,11 +20,11 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Not yet
+* TDX EPT violation:                    Applying
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applying
+* KVM TDP MMU hooks:                    Applied
-- 
2.25.1


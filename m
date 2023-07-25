Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6980776263F
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjGYWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjGYWTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:19:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5D94693;
        Tue, 25 Jul 2023 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323412; x=1721859412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
  b=Kf1s4V/Ob4WYSCRqLjsPH+miYx0fPd6MlsdzstfYum80ajYvherRHfnm
   Dh+f/KhSeMdZerTyrjVyZR6ijBHof2zX7ocgrgNh6VhiNC0RAFuCumak0
   tWrDd63AHqS7YjlTIRaZb33E2Sc4xWHFZv9TdSSkCvsGfTAl45Az1o8fe
   96lrxGLL0w+t/IMS8ObLOUbFRgULkBv7yZPV7aJnbjjhVrYa10tYYvVL+
   MxR3wRD79HqXIE3nCT4J2P3AnKhq3Ww39OUdPZRSn8Ou40M7ZGBG83HRs
   m5y5Z/wjz+dpoQZsB2A0Fn+Gy5oMRyVLH1S8c5lUtnrkdIGQwVLolRfsW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882567"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882567"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001808"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001808"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:53 -0700
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
Subject: [PATCH v15 069/115] [MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls
Date:   Tue, 25 Jul 2023 15:14:20 -0700
Message-Id: <bfa841f280f00cac3fa81817452a178f27ca8fa0.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TD vcpu
exits, interrupts, and hypercalls.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 33e107bcb5cf..7a16fa284b6f 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -13,6 +13,7 @@ What qemu can do
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
 - Qemu can finalize guest TD.
+- Qemu can start to run vcpu. But vcpu can not make progress yet.
 
 Patch Layer status
 ------------------
@@ -24,7 +25,7 @@ Patch Layer status
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
 * TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applying
+* TD vcpu enter/exit:                   Applied
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


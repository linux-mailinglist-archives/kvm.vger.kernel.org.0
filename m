Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E15A7142B1
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjE2EWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjE2EVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:21:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E078910E;
        Sun, 28 May 2023 21:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334060; x=1716870060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0N39TZmKLiC6CILEgWJyLqxHNkrsso5GLu5HE01vt8=;
  b=PnjCgJv2KExPF7SF9IxEMfzA6aBzUAyqhCvVr8iSgsG13JKSbxpmPh/M
   U7iqNQ4A2QiJISj1ccDLdIDNZlIEXY6RXtEispv+ADXsMQ+8luOijo4Ke
   JtCRrBpUEfoHJ6Hfl3m3H/m+mUruTUAVCDx6/X5Yglz20WMGjBBHJ6VLx
   epBN8eK4m8CvTDeVycCFGm0jWgDirvAGBJ1ROh7EgldQjXLXvwI9q5ji2
   yNghyGMV2Rkc+qVyNLTXQp686HNCOyBBj1PG3ds0NT1NToYS4z8rVwhHL
   AFNnEOQPQ9hrhsMM9Nau3Bozmp8lGq3iAjVEVxT0iAhKoXoXzlJGy/+9U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="418094353"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="418094353"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="683419361"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="683419361"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 023/113] [MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction
Date:   Sun, 28 May 2023 21:19:05 -0700
Message-Id: <6d26fbae450ed58934c47250ddf6ef88d31fbc28.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 098150da6ea2..25082e9c0b20 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -9,7 +9,7 @@ Layer status
 What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
-- Qemu can try to create VM of TDX VM type and then fails.
+- Qemu can create/destroy guest of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -17,8 +17,8 @@ Patch Layer status
 
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


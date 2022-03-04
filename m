Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396FA4CDDED
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiCDUKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiCDUIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:08:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56194240D01;
        Fri,  4 Mar 2022 12:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424150; x=1677960150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pTw5pOvPGI2Hd8b31rw+AUm1nRWyOSusw9yAtue5aNo=;
  b=S97xVRUMucmByPUzIgQW/oFlz3TsDl0abNSPKB/uhwPXgLfgULCIJ6ji
   ltJIni26vo3JfJWBHsXiAc9tUHFUMOQ6ZAbEk0Y0mVjHH9rmJaa1Rpz5F
   W9x41+F6HixfLAjxT0fft8tkkwsm+Ay1G08kYAcc+xw29vVRu6WPwNBJ8
   BgNGDnnhAg0cdCIvHMUFObH0KdI5ct2Ee8v6I4QZSd9r95yJ5QdJRG3sk
   6DJCtscYbFWFQe+Hd381nachcXdGY7uTntihcgLeTBcTAJ5VyeXRfNoiS
   XUI6KsGHrnH94O3cm4Midi33porYKOvVTWkj4DMXmY75DLQXTujWAahoS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983529"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983529"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:25 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344379"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 050/104] [MARKER] The start of TDX KVM patch series: TDX EPT violation
Date:   Fri,  4 Mar 2022 11:49:06 -0800
Message-Id: <4ed6171823c5a6bde8b905bfdce8cade18da00f8.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 9b2b811c5bdf..a14355332d44 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -19,12 +19,12 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Not yet
+* TDX EPT violation:                    Applying
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA stolen bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applying
+* KVM TDP MMU hooks:                    Applied
 * KVM TDP MMU MapGPA:                   Not yet
-- 
2.25.1


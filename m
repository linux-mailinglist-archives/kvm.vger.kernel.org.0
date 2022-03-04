Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F434CDE04
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiCDUFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiCDUEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:04:53 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D12224BA34;
        Fri,  4 Mar 2022 12:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424015; x=1677960015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7IyWVsnhXFpRUM2ZhFNLdK0UoQtYleycerbuuVzASk0=;
  b=T6PRnOSRP2Xo1fhxj0lpIxm12PTLBWu+81lkK8ox1hgqZgWlukSYdLHK
   9+WppOGBMuXbHEyIuOrcK3NS9NNDIv8huXJWT9azsBR2MLjOW0z3jL6sp
   M0epsCY8GYKlvCXKFZej9FKsgtqmGSGxXePFZCWxy0xStSGeS56VLp0bd
   51OCxVqrwykgeZqGxsBm+myjXDChOmuuUAgODr0+bn7rZxTcr0me1tupB
   FvVhWqQINbHJ5foJpqyDrhns/JUtLbavrdhwutd4+83W2B5sYgrzEVoNC
   V/ytlbzZJ2RvDSAzNVedVRlxHPLMEKjvUTs9HrKZUnQ60VOlL7VepjjKE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983276"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983276"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:02 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344054"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:02 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 002/104] x86/virt/tdx: export platform_has_tdx
Date:   Fri,  4 Mar 2022 11:48:18 -0800
Message-Id: <76f23df80480e3587f6f9988f5503086b57dcbd7.1646422845.git.isaku.yamahata@intel.com>
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

TDX KVM uses platform_has_tdx() via hardware_setup().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 60d58b2daabd..da4d1df95503 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1630,3 +1630,4 @@ bool platform_has_tdx(void)
 {
 	return seamrr_enabled() && tdx_keyid_sufficient();
 }
+EXPORT_SYMBOL_GPL(platform_has_tdx);
-- 
2.25.1


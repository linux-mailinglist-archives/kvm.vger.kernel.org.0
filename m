Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723AD51C761
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384080AbiEESXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383176AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BDA15734;
        Thu,  5 May 2022 11:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774551; x=1683310551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+4NUmFZ8LyOytDGfSFdAHw6TxIUqH8yTed5boLRoo/E=;
  b=VM5gwPga+tnFGOfUBPsGK820V90Sy0MjuX/M3JaLZO265aE9O5LXfHnQ
   G3/BYYYAkUZLcCanSCrVn62m+WHD1Y2rnZd35pbkXwPNpdRtpk19tYhpp
   QxyktSGR0ngw7UXW55RBNA4iRqOvUvqHIiXe9Lt2kj+hf5mT1cQYfyOly
   C0dMIwKqnQl4za3UOyHxhU/m3C6HW2GnwlUM+Fopi/1Q3cTxqYWz7Pr+4
   7FX+IHymuJFLdsaMEa3C8G5V8PzeU1+nMMBhI6l3uno1uScjqvG6aJD9a
   VfQkZ3be7d952MajL+nt7y+G9zEyWhppI813VABw0o6lDgHUO4qS2DTWD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248741980"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248741980"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083141"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:39 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 005/104] x86/virt/vmx/tdx: export platform_has_tdx
Date:   Thu,  5 May 2022 11:13:59 -0700
Message-Id: <78d9874f2c6b6006fd9ba4250ead6df064b6b82b.1651774250.git.isaku.yamahata@intel.com>
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

TDX KVM uses platform_has_tdx() via vmx_hardware_setup() to check if the
platform supports TDX, concretely CPU SEAM mode, irrespective of TDX module
is loaded or initialized.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8c49ca40b6ad..b6c82e64ad54 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1715,3 +1715,4 @@ bool platform_has_tdx(void)
 {
 	return seamrr_enabled() && tdx_keyid_sufficient();
 }
+EXPORT_SYMBOL_GPL(platform_has_tdx);
-- 
2.25.1


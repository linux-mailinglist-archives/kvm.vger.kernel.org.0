Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1655CABA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbiF0VzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241233AbiF0Vyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1215B62E0;
        Mon, 27 Jun 2022 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366890; x=1687902890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9aCDkqWmy71QgIukS8SMgSb50YpGTMxCRqgvkc783EI=;
  b=UMPtI7X7SSb1oqPMnvDh5jH6sA8kti5pA5lc5zwrJI8/1heKj5+TLTcn
   4CafRqdgL5QHWAlIIz/U8ZiB+m0Gbs++3Kfqcp7FEPMHfHG1fFsh7zTY4
   UjUXFhAJtvoF9ZWtUqrovofztCqCBAQl6ZKTAZvWlw4gHE/Q0H3kgnMia
   d4DrgjNSUbq2WQmMW5Wu2Gd95sy3CKvRV0A0rme2u/zDt5Xcx7KmE46hx
   LPytWVKJotuuszXH9ZcPVOxwC+xZiyDGXhoIwgqEJSRfoPChhECvXGCPe
   X1zfGjd8j+2Fxv9qNjopOCU00hW5FjWBUohS3ezoEaxgL7VkIBt4fh4J/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282662717"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282662717"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863443"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 005/102] x86/virt/vmx/tdx: export platform_tdx_enabled()
Date:   Mon, 27 Jun 2022 14:52:57 -0700
Message-Id: <a2ee0e66712069ae8dead8f38b49ecee09ea3cb6.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
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

TDX KVM uses platform_tdx_enabled() via vmx_hardware_setup() to check if the
platform supports TDX, concretely CPU SEAM mode, irrespective of TDX module
is loaded or initialized.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1363998ce1a9..f9a6f8bdade8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1285,6 +1285,7 @@ bool platform_tdx_enabled(void)
 {
 	return tdx_keyid_num >= 2;
 }
+EXPORT_SYMBOL_GPL(platform_tdx_enabled);
 
 /**
  * tdx_init - Initialize the TDX module
-- 
2.25.1


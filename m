Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476936C9DB1
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjC0IZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjC0IYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:24:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427BC2D57;
        Mon, 27 Mar 2023 01:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905475; x=1711441475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8lktqN9Ow6nF5dYh+N7FoY+KesvEnknJu52aiBKcpfg=;
  b=ZXke2SCfe+AQphBUYh8eKzJK1aSmls7bCF+lrK+oBXqGCcsCdOxdeqg8
   3ttcSfAUsZLz0OnXqRV1FQtJcuuEEuHzYt6CKb+CkIIXnBdbnpt8cZOL+
   RcAGMIoNFRpUECoNj+2jRoS7CM+fZevW3osVWeBsyrp0qN/tlwkqdvxXN
   xak3o+0wQ+W9WAszv4gz2FAx+5DGEu1Jw1kxfFhLzWjuE5qifePhD59a9
   wDAwwWQwGfo6oIQwbjRF/BH0bL0jLJd6evwMHHzv+WyzX9xVNVZP6qMlE
   peH/phoDBq2SHXIu6dVV9/OCVabKLrOXkt1ShHhrQZ3r0Z9xYYdQQdyq+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338930182"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338930182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:24:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="713787064"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="713787064"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga008.jf.intel.com with ESMTP; 27 Mar 2023 01:24:33 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v6 10/33] x86/fred: add Kconfig option for FRED (CONFIG_X86_FRED)
Date:   Mon, 27 Mar 2023 00:58:15 -0700
Message-Id: <20230327075838.5403-11-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327075838.5403-1-xin3.li@intel.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add the configuration option CONFIG_X86_FRED to enable FRED.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a825bf031f49..da62178bb246 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -500,6 +500,15 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
+config X86_FRED
+	bool "Flexible Return and Event Delivery"
+	depends on X86_64
+	help
+	  When enabled, try to use Flexible Return and Event Delivery
+	  instead of the legacy SYSCALL/SYSENTER/IDT architecture for
+	  ring transitions and exception/interrupt handling if the
+	  system supports.
+
 if X86_32
 config X86_BIGSMP
 	bool "Support for big SMP systems with more than 8 CPUs"
-- 
2.34.1


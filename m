Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E6651B1D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiLTHB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiLTHBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:34 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D62EDEC6;
        Mon, 19 Dec 2022 23:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519693; x=1703055693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9cIpOvm3xSuQ2LLiyXWWa3lHFFJYVxzwwgrBF18MB8=;
  b=jvfiATR6D/T6Bf9n/iNZgvKwDMjZH61tHuIVWh9WDhfpmVhaYQmU02RO
   H6Z5UA40j6yIm63zqVsJ8/4ciVw8+K/tClK2PF1wz0IFpFgYPvI7aHJVp
   H4H/nRijHHHU4RmZZnTa7K0Hu4WxyzdmLx1FYCIUXPM7D2HeN637PQnlS
   9fvmBcwwl9afmCR0CVykWeF+OvUzI0ijLlErO3slfBZhOxLXjvnhzDFiE
   58h6SgXVzne/VkBHzHSClkc3qM1fRm5RuutWlXVe5bqVBtX0CB7EVmgMo
   yOuCJjLQR84Xkude4GjMYpOddqxkr+kZPJg7fDf+rsZPhNOjiPp3PIAHY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302971980"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302971980"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326450"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326450"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:11 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 10/32] x86/fred: add Kconfig option for FRED (CONFIG_X86_FRED)
Date:   Mon, 19 Dec 2022 22:36:36 -0800
Message-Id: <20221220063658.19271-11-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220063658.19271-1-xin3.li@intel.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add the configuration option CONFIG_X86_FRED to enable FRED.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 67745ceab0db..1155d2e06fd1 100644
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


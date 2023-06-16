Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D5373342E
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 17:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345470AbjFPPEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 11:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345857AbjFPPEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 11:04:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1B23A89;
        Fri, 16 Jun 2023 08:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686927835; x=1718463835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mFQp2Dp+OGh9bB+97IQPS3/rYYC1sOLLK8wCF9H2RG0=;
  b=IiiyVsOh5ovozZE6NABV6SS/b8A8tSXrGCoL0K5uuxWFPAn6gSaj6AG2
   uIOG6ZySHUNviQuREFafd7RK9VNWVfjxfFK/ImNgtJcqLxiJpHlrqeuhp
   TteVhtcgZ+NaU+4VrSW28P7nqJJmPFEztcAgiu+FAZVEZOGz2SXq3Xp0V
   kpq4IoiDPyhW9Z/0y02/sd/t50mJuHNh+fS1QQJGDlAj4qVmWr2XjeqG4
   Xn63VhMwygF99xkzl0UeVKkqmpfVgYshtC9sIneb5auxSEShd/z4nkGZf
   9Elk7nPKQGrXn0yvSJFnSFRAFyH/LOkI2l7CElvfWPyRlUbpF73gK3/uI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343970303"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="343970303"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 08:03:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="959650863"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="959650863"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2023 08:02:26 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9914F379; Fri, 16 Jun 2023 18:02:35 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] KVM: x86: Remove PRIx* definitions as they are solely for user space
Date:   Fri, 16 Jun 2023 18:02:33 +0300
Message-Id: <20230616150233.83813-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.40.0.1.gaa8946217a0b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the Linux kernel we do not support PRI.64 specifiers.
Moreover they seem not to be used anyway here. Drop them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kvm/lapic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c300a196bdf..113ca9661ab2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -51,11 +51,6 @@
 #define mod_64(x, y) ((x) % (y))
 #endif
 
-#define PRId64 "d"
-#define PRIx64 "llx"
-#define PRIu64 "u"
-#define PRIo64 "o"
-
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
-- 
2.40.0.1.gaa8946217a0b


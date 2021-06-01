Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C174A396F64
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhFAItt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:49:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:45142 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233773AbhFAItm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:49:42 -0400
IronPort-SDR: 31+FrmYbTJBIL4YUs0STaZNqG1zZLmGZObYRn/5VMehe58Y+TxbzmDO1th8b8EncfG5LWXjqtO
 OU7DqLmgwwNg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381287"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381287"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:00 -0700
IronPort-SDR: eMj/DQuW6Kh5rgYb2frTv4AumtMZRkwm3a+lNo3hyRsEX0HKk9NUScYkg7NZxm9MYwbYDANEQ2
 rcA/M+K2jQCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967736"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:47:58 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 01/15] x86/keylocker: Move KEYSRC_{SW,HW}RAND to keylocker.h
Date:   Tue,  1 Jun 2021 16:47:40 +0800
Message-Id: <1622537274-146420-2-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs the KEYSRC_SWRAND and KEYSRC_HWRAND macro definitions.
Move them to <asm/keylocker.h>

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/keylocker.h | 3 +++
 arch/x86/kernel/keylocker.c      | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 74b8063..9836e68 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -9,6 +9,9 @@
 #include <linux/bits.h>
 #include <asm/msr.h>
 
+#define KEYSRC_SWRAND		0
+#define KEYSRC_HWRAND		BIT(1)
+
 #define KEYLOCKER_CPUID			0x019
 #define KEYLOCKER_CPUID_EAX_SUPERVISOR	BIT(0)
 #define KEYLOCKER_CPUID_EBX_AESKLE	BIT(0)
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 5a784492..17bb2e8 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -66,8 +66,6 @@ void flush_keylocker_data(void)
 	keydata.valid = false;
 }
 
-#define KEYSRC_SWRAND		0
-#define KEYSRC_HWRAND		BIT(1)
 #define KEYSRC_HWRAND_RETRY	10
 
 /**
-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904EB303293
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbhAYJ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 04:26:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:22894 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbhAYJYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:24:50 -0500
IronPort-SDR: DFIi6KXTtVCca3G9b3CbSjhbZmPOiRGrI7YMGo9Y8MAhiQg0YAoMEXd8XEYi50AEKO+Hwrpx/0
 U/eOfGg3vFGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915773"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915773"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:02 -0800
IronPort-SDR: tIJOBhYPaik+XgVUZGNBW0F+itKgGuPAGyUFDby4gueIDHXxaZcmLvdbQ28i0SUvGx7p4dDaP/
 O/HvOMTaZezg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223803"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:00 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 01/12] x86/keylocker: Move LOADIWKEY opcode definition from keylocker.c to keylocker.h
Date:   Mon, 25 Jan 2021 17:06:09 +0800
Message-Id: <1611565580-47718-2-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For later kvm part code easy referrence.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/keylocker.h | 2 ++
 arch/x86/kernel/keylocker.c      | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index a6774ce..8c0792f 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -8,6 +8,8 @@
 #include <linux/bits.h>
 #include <asm/msr.h>
 
+#define LOADIWKEY		".byte 0xf3,0x0f,0x38,0xdc,0xd1"
+
 #define KEYLOCKER_CPUID                0x019
 #define KEYLOCKER_CPUID_EAX_SUPERVISOR BIT(0)
 #define KEYLOCKER_CPUID_EBX_AESKLE     BIT(0)
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index e77e4c3..06a30f0 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -40,7 +40,6 @@ bool check_keylocker_readiness(void)
 }
 
 /* Load Internal (Wrapping) Key */
-#define LOADIWKEY		".byte 0xf3,0x0f,0x38,0xdc,0xd1"
 #define LOADIWKEY_NUM_OPERANDS	3
 #define LOADIWKEY_HWRAND_RETRY	10
 
-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874BE1E5460
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 05:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgE1DLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 23:11:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:35951 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgE1DLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 23:11:24 -0400
IronPort-SDR: 8syiTMz0xyRE3Deu3S6+P/0jx29FY88hFMeIFrJMiWrlKuuwWkB5yrh1eE22hbHmFAiKPPLlhs
 IBkssozOOX9w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 20:11:24 -0700
IronPort-SDR: dalb1FmVAc4anaetpGsxmDx/4ESS/ijY749MVIqAzVgKL8OFW2Va0vqp6c/Af9NDQ6BwpnlgFb
 5847K/zfr8yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="376231240"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 27 May 2020 20:11:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] x86/kvm: Remove defunct KVM_DEBUG_FS Kconfig
Date:   Wed, 27 May 2020 20:11:21 -0700
Message-Id: <20200528031121.28904-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove KVM_DEBUG_FS, which can easily be misconstrued as controlling
KVM-as-a-host.  The sole user of CONFIG_KVM_DEBUG_FS was removed by
commit cfd8983f03c7b ("x86, locking/spinlocks: Remove ticket (spin)lock
implementation").

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig      | 8 --------
 arch/x86/kernel/kvm.c | 1 -
 2 files changed, 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1197b5596d5ad..0ccf4e76acfe8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -818,14 +818,6 @@ config PVH
 	  This option enables the PVH entry point for guest virtual machines
 	  as specified in the x86/HVM direct boot ABI.
 
-config KVM_DEBUG_FS
-	bool "Enable debug information for KVM Guests in debugfs"
-	depends on KVM_GUEST && DEBUG_FS
-	---help---
-	  This option enables collection of various statistics for KVM guest.
-	  Statistics are displayed in debugfs filesystem. Enabling this option
-	  may incur significant overhead.
-
 config PARAVIRT_TIME_ACCOUNTING
 	bool "Paravirtual steal time accounting"
 	depends on PARAVIRT
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb728..89ba09228eaf5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -21,7 +21,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kprobes.h>
-#include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
 #include <asm/timer.h>
-- 
2.26.0


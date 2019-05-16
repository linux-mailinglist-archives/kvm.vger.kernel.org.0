Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA32013F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfEPI0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:26:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:22098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfEPI0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:40 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:38 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 1/6] x86/fpu: Introduce new fpu state for Intel processor trace
Date:   Thu, 16 May 2019 16:25:09 +0800
Message-Id: <1557995114-21629-2-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new fpu state structure pt_state to save Intel
processor trace configuration. The upcoming using
XSAVES/XRSTORS to switch the Intel PT configuration
on VM-Entry/Exit will use this structure.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/fpu/types.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 2e32e17..8cbb42e 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -221,6 +221,19 @@ struct avx_512_hi16_state {
 } __packed;
 
 /*
+ * State component 8 is used for some 64-bit registers
+ * of Intel processor trace.
+ */
+struct pt_state {
+	u64 rtit_ctl;
+	u64 rtit_output_base;
+	u64 rtit_output_mask;
+	u64 rtit_status;
+	u64 rtit_cr3_match;
+	u64 rtit_addrx_ab[0];
+} __packed;
+
+/*
  * State component 9: 32-bit PKRU register.  The state is
  * 8 bytes long but only 4 bytes is used currently.
  */
-- 
1.8.3.1


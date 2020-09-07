Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5F25FB3F
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 15:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgIGNTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 09:19:42 -0400
Received: from 8bytes.org ([81.169.241.247]:41596 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729427AbgIGNRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:17:46 -0400
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 2985EA6D;
        Mon,  7 Sep 2020 15:16:44 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v7 04/72] KVM: SVM: Use __packed shorthand
Date:   Mon,  7 Sep 2020 15:15:05 +0200
Message-Id: <20200907131613.12703-5-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907131613.12703-1-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Use the shorthand to make it more readable.

No functional changes.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/svm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 06e52585aed3..cf13f9e78585 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -150,14 +150,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 
-struct __attribute__ ((__packed__)) vmcb_seg {
+struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
 	u32 limit;
 	u64 base;
-};
+} __packed;
 
-struct __attribute__ ((__packed__)) vmcb_save_area {
+struct vmcb_save_area {
 	struct vmcb_seg es;
 	struct vmcb_seg cs;
 	struct vmcb_seg ss;
@@ -231,7 +231,7 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
-};
+} __packed;
 
 struct ghcb {
 	struct vmcb_save_area save;
@@ -256,11 +256,11 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
 }
 
-struct __attribute__ ((__packed__)) vmcb {
+struct vmcb {
 	struct vmcb_control_area control;
 	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
 	struct vmcb_save_area save;
-};
+} __packed;
 
 #define SVM_CPUID_FUNC 0x8000000a
 
-- 
2.28.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C1523A636
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgHCMpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 08:45:50 -0400
Received: from 8bytes.org ([81.169.241.247]:34698 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgHCM10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:26 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AE694CA2; Mon,  3 Aug 2020 14:27:24 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v3 4/4] KVM: SVM: Use __packed shorthand
Date:   Mon,  3 Aug 2020 14:27:08 +0200
Message-Id: <20200803122708.5942-5-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200803122708.5942-1-joro@8bytes.org>
References: <20200803122708.5942-1-joro@8bytes.org>
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
 arch/x86/include/asm/svm.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 71a308f1fbc8..f41b329943e5 100644
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
@@ -231,9 +231,9 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
-};
+} __packed;
 
-struct __attribute__ ((__packed__)) ghcb {
+struct ghcb {
 	struct vmcb_save_area save;
 	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
 
@@ -242,7 +242,7 @@ struct __attribute__ ((__packed__)) ghcb {
 	u8 reserved_1[10];
 	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
 	u32 ghcb_usage;
-};
+} __packed;
 
 
 static inline void __unused_size_checks(void)
@@ -252,11 +252,11 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_ON(sizeof(struct ghcb) != 4096);
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
2.17.1


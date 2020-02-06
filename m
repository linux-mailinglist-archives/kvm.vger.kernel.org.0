Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E2D1546B0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBFOuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55356 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fPgd99gzsbfnyTVf997Pxp90sDFuBPYNRjGGdOIoAxs=; b=EDwJRSLikLIYKTRHi/CehTbhLN
        B7vRemN3Oksi55jVFo3LHsuIzPGpcbZLXwq1NwnhYQwNsJhE+mN4gWpr0RdRBNZu5h6JlFOqEEy+1
        xxWFzpf3YZzufnL/MTxRiTfUpIsYfX5jflIh4bgYnsF8AGAzyIS2vc8Y6M659MEOA4oYX+T3sPouT
        1FfQ05YTFVNDSYxXcrJ6jE5zJZ2mlToI2PgoT3stm1iYZQ3ySsptvyMBMAioPY06sA5JcbAdPHGt6
        y/Lw1UeCYVC3zbQbF6ideKXV3ARbZDf3C1U4HwwYGdUkc3kMw2wVWkqnswADFf2hY/OqrVCgaxdME
        X/LD2Hpw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IS-AQ; Thu, 06 Feb 2020 14:50:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU7-002nM4-3S; Thu, 06 Feb 2020 15:50:27 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 24/27] docs: kvm: Convert ppc-pv.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:21 +0100
Message-Id: <7c3fb9938b3f7fc913fc1a2c26455ec9e0501fb7.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title and chapter markups;
- Add markups for tables;
- Use list markups;
- Add markups for literal blocks;
- Add blank lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../virt/kvm/{ppc-pv.txt => ppc-pv.rst}       | 26 +++++++++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)
 rename Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst} (91%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 123385d0a74a..d0e17e717461 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -16,6 +16,7 @@ KVM
    mmu
    msr
    nested-vmx
+   ppc-pv
    vcpu-requests
 
    arm/index
diff --git a/Documentation/virt/kvm/ppc-pv.txt b/Documentation/virt/kvm/ppc-pv.rst
similarity index 91%
rename from Documentation/virt/kvm/ppc-pv.txt
rename to Documentation/virt/kvm/ppc-pv.rst
index e26115ce4258..5fdb907670be 100644
--- a/Documentation/virt/kvm/ppc-pv.txt
+++ b/Documentation/virt/kvm/ppc-pv.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
 The PPC KVM paravirtual interface
 =================================
 
@@ -34,8 +37,9 @@ up the hypercall. To call a hypercall, just call these instructions.
 
 The parameters are as follows:
 
+        ========	================	================
 	Register	IN			OUT
-
+        ========	================	================
 	r0		-			volatile
 	r3		1st parameter		Return code
 	r4		2nd parameter		1st output value
@@ -47,6 +51,7 @@ The parameters are as follows:
 	r10		8th parameter		7th output value
 	r11		hypercall number	8th output value
 	r12		-			volatile
+        ========	================	================
 
 Hypercall definitions are shared in generic code, so the same hypercall numbers
 apply for x86 and powerpc alike with the exception that each KVM hypercall
@@ -54,11 +59,13 @@ also needs to be ORed with the KVM vendor code which is (42 << 16).
 
 Return codes can be as follows:
 
+	====		=========================
 	Code		Meaning
-
+	====		=========================
 	0		Success
 	12		Hypercall not implemented
 	<0		Error
+	====		=========================
 
 The magic page
 ==============
@@ -72,7 +79,7 @@ desired location. The first parameter indicates the effective address when the
 MMU is enabled. The second parameter indicates the address in real mode, if
 applicable to the target. For now, we always map the page to -4096. This way we
 can access it using absolute load and store functions. The following
-instruction reads the first field of the magic page:
+instruction reads the first field of the magic page::
 
 	ld	rX, -4096(0)
 
@@ -93,8 +100,10 @@ a bitmap of available features inside the magic page.
 
 The following enhancements to the magic page are currently available:
 
+  ============================  =======================================
   KVM_MAGIC_FEAT_SR		Maps SR registers r/w in the magic page
   KVM_MAGIC_FEAT_MAS0_TO_SPRG7	Maps MASn, ESR, PIR and high SPRGs
+  ============================  =======================================
 
 For enhanced features in the magic page, please check for the existence of the
 feature before using them!
@@ -121,8 +130,8 @@ when entering the guest or don't have any impact on the hypervisor's behavior.
 
 The following bits are safe to be set inside the guest:
 
-  MSR_EE
-  MSR_RI
+  - MSR_EE
+  - MSR_RI
 
 If any other bit changes in the MSR, please still use mtmsr(d).
 
@@ -138,9 +147,9 @@ guest. Implementing any of those mappings is optional, as the instruction traps
 also act on the shared page. So calling privileged instructions still works as
 before.
 
+======================= ================================
 From			To
-====			==
-
+======================= ================================
 mfmsr	rX		ld	rX, magic_page->msr
 mfsprg	rX, 0		ld	rX, magic_page->sprg0
 mfsprg	rX, 1		ld	rX, magic_page->sprg1
@@ -173,7 +182,7 @@ mtsrin	rX, rY		b	<special mtsrin section>
 
 [BookE only]
 wrteei	[0|1]		b	<special wrteei section>
-
+======================= ================================
 
 Some instructions require more logic to determine what's going on than a load
 or store instruction can deliver. To enable patching of those, we keep some
@@ -191,6 +200,7 @@ for example.
 
 Hypercall ABIs in KVM on PowerPC
 =================================
+
 1) KVM hypercalls (ePAPR)
 
 These are ePAPR compliant hypercall implementation (mentioned above). Even
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0303218F5A4
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 14:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgCWNXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 09:23:24 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40558 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgCWNXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 09:23:24 -0400
Received: from zn.tnic (p200300EC2F04F900B1314F6DF04CED4B.dip0.t-ipconnect.de [IPv6:2003:ec:2f04:f900:b131:4f6d:f04c:ed4b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 028CE1EC0C68;
        Mon, 23 Mar 2020 14:23:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1584969802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xW0/HOW9n0qQhxLBUQ2kpOFSlOwhGdDkXLxiBO1huwU=;
        b=Mh0hkLpItJ3GqPbFtp3Zs3wYWNJ6OyGdo9cNRHVORoSYUH3E1Y++GM6WGUkA11+ulapHcJ
        0ONe1jWO6b9GKgjTjuXcU+WiwgDLLtd59L7MWC8zWdX3CfEeB1YkEOJRimSpiK2R/QUr5M
        Q15J8b+p5WjOAtRzFfDaZsS+mbb8Rxo=
Date:   Mon, 23 Mar 2020 14:23:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] KVM: SVM: Use __packed shorthard
Message-ID: <20200323132315.GB4649@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-2-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I guess we can do that ontop.

---
From: Borislav Petkov <bp@suse.de>
Date: Mon, 23 Mar 2020 14:20:08 +0100

... to make it more readable.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/svm.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f36288c659b5..1ec813f02c58 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -151,14 +151,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
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
@@ -233,9 +233,9 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
 	u8 reserved_12[1016];
-};
+} __packed;
 
-struct __attribute__ ((__packed__)) ghcb {
+struct ghcb {
 	struct vmcb_save_area save;
 
 	u8 shared_buffer[2032];
@@ -243,12 +243,12 @@ struct __attribute__ ((__packed__)) ghcb {
 	u8 reserved_1[10];
 	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
 	u32 ghcb_usage;
-};
+} __packed;
 
-struct __attribute__ ((__packed__)) vmcb {
+struct vmcb {
 	struct vmcb_control_area control;
 	struct vmcb_save_area save;
-};
+} __packed;
 
 #define SVM_CPUID_FUNC 0x8000000a
 
-- 
2.21.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

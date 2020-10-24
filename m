Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE04297F04
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764884AbgJXVgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764745AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFF8C0613A6;
        Sat, 24 Oct 2020 14:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bqgZykzwAPXMrTL6XB1bI9Gxco+0bYxPyO2LqSSlo5E=; b=Dkh17TxM3AUC42PghbBYxdE3Ju
        UVOYQmwEIWGw7aZi0y372jPSh2722BiY2HcmFoJpNFZSqloYP75HbFr57nyFZqT7EpOJuUnslAb0m
        kzUVuHA58ImsH/+NZqGaTC4qqEho/TEooA4PYwQ9tpTFoRirLKguS113JRPdKUkCRvd/pjmsxXPW7
        xUMpqqEwKe2hWLvL1i9TlCyGtN2qUZucYN+YFIhPfRuz1rD6mot0Y+QulytqyfQT8T9KxJrIJ3GWS
        feHiTIFCzz4pH5DSJ3lGvj33g1w0sfSNTMCrRfwmONdTQYy3pOdfP76xLPJQZc/ftc3P+ijpYIYB7
        CG2s2EbQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HE-GT; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rOj-26; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 18/35] x86/msi: Remove msidef.h
Date:   Sat, 24 Oct 2020 22:35:18 +0100
Message-Id: <20201024213535.443185-19-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Nothing uses the macro maze anymore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/msidef.h | 57 -----------------------------------
 1 file changed, 57 deletions(-)
 delete mode 100644 arch/x86/include/asm/msidef.h

diff --git a/arch/x86/include/asm/msidef.h b/arch/x86/include/asm/msidef.h
deleted file mode 100644
index ee2f8ccc32d0..000000000000
--- a/arch/x86/include/asm/msidef.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_MSIDEF_H
-#define _ASM_X86_MSIDEF_H
-
-/*
- * Constants for Intel APIC based MSI messages.
- */
-
-/*
- * Shifts for MSI data
- */
-
-#define MSI_DATA_VECTOR_SHIFT		0
-#define  MSI_DATA_VECTOR_MASK		0x000000ff
-#define	 MSI_DATA_VECTOR(v)		(((v) << MSI_DATA_VECTOR_SHIFT) & \
-					 MSI_DATA_VECTOR_MASK)
-
-#define MSI_DATA_DELIVERY_MODE_SHIFT	8
-#define  MSI_DATA_DELIVERY_FIXED	(0 << MSI_DATA_DELIVERY_MODE_SHIFT)
-#define  MSI_DATA_DELIVERY_LOWPRI	(1 << MSI_DATA_DELIVERY_MODE_SHIFT)
-
-#define MSI_DATA_LEVEL_SHIFT		14
-#define	 MSI_DATA_LEVEL_DEASSERT	(0 << MSI_DATA_LEVEL_SHIFT)
-#define	 MSI_DATA_LEVEL_ASSERT		(1 << MSI_DATA_LEVEL_SHIFT)
-
-#define MSI_DATA_TRIGGER_SHIFT		15
-#define  MSI_DATA_TRIGGER_EDGE		(0 << MSI_DATA_TRIGGER_SHIFT)
-#define  MSI_DATA_TRIGGER_LEVEL		(1 << MSI_DATA_TRIGGER_SHIFT)
-
-/*
- * Shift/mask fields for msi address
- */
-
-#define MSI_ADDR_BASE_HI		0
-#define MSI_ADDR_BASE_LO		0xfee00000
-
-#define MSI_ADDR_DEST_MODE_SHIFT	2
-#define  MSI_ADDR_DEST_MODE_PHYSICAL	(0 << MSI_ADDR_DEST_MODE_SHIFT)
-#define	 MSI_ADDR_DEST_MODE_LOGICAL	(1 << MSI_ADDR_DEST_MODE_SHIFT)
-
-#define MSI_ADDR_REDIRECTION_SHIFT	3
-#define  MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
-					/* dedicated cpu */
-#define  MSI_ADDR_REDIRECTION_LOWPRI	(1 << MSI_ADDR_REDIRECTION_SHIFT)
-					/* lowest priority */
-
-#define MSI_ADDR_DEST_ID_SHIFT		12
-#define	 MSI_ADDR_DEST_ID_MASK		0x00ffff0
-#define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & \
-					 MSI_ADDR_DEST_ID_MASK)
-#define MSI_ADDR_EXT_DEST_ID(dest)	((dest) & 0xffffff00)
-
-#define MSI_ADDR_IR_EXT_INT		(1 << 4)
-#define MSI_ADDR_IR_SHV			(1 << 3)
-#define MSI_ADDR_IR_INDEX1(index)	((index & 0x8000) >> 13)
-#define MSI_ADDR_IR_INDEX2(index)	((index & 0x7fff) << 5)
-#endif /* _ASM_X86_MSIDEF_H */
-- 
2.26.2


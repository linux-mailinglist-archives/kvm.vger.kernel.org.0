Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699BE3B07DD
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhFVOvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:51:01 -0400
Received: from 8bytes.org ([81.169.241.247]:49960 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFVOvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 10:51:00 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9AE0F260;
        Tue, 22 Jun 2021 16:48:41 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH 1/3] x86/sev: Add Comments to existing GHCB MSR protocol defines
Date:   Tue, 22 Jun 2021 16:48:23 +0200
Message-Id: <20210622144825.27588-2-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622144825.27588-1-joro@8bytes.org>
References: <20210622144825.27588-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add comments to the defines for SEV Info and CPUID MSR protocol defines
to document to which protocol part they belong.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 629c3df243f0..1cc9e7dd8107 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -11,6 +11,7 @@
 #define GHCB_MSR_INFO_POS		0
 #define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
 
+/* SEV Information Request/Response */
 #define GHCB_MSR_SEV_INFO_RESP		0x001
 #define GHCB_MSR_SEV_INFO_REQ		0x002
 #define GHCB_MSR_VER_MAX_POS		48
@@ -28,6 +29,7 @@
 #define GHCB_MSR_PROTO_MAX(v)		(((v) >> GHCB_MSR_VER_MAX_POS) & GHCB_MSR_VER_MAX_MASK)
 #define GHCB_MSR_PROTO_MIN(v)		(((v) >> GHCB_MSR_VER_MIN_POS) & GHCB_MSR_VER_MIN_MASK)
 
+/* CPUID Request/Response */
 #define GHCB_MSR_CPUID_REQ		0x004
 #define GHCB_MSR_CPUID_RESP		0x005
 #define GHCB_MSR_CPUID_FUNC_POS		32
-- 
2.31.1


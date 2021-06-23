Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41F33B16F2
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFWJfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFWJfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 05:35:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96501C061574;
        Wed, 23 Jun 2021 02:33:01 -0700 (PDT)
Received: from zn.tnic (p200300ec2f114b00a4a414805e84bac1.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:4b00:a4a4:1480:5e84:bac1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5C0EC1EC04DE;
        Wed, 23 Jun 2021 11:32:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624440778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5Dfo3J4t3itaTxlARqlq6y7lR5cwNrkt0PtKQVp6RKA=;
        b=JdGTbEsk9d/Hd8RXQANptDXP5KCvC6M0g+60AxNSox+kKCKFpQ4LjZoL35wSK5KSfd8fW6
        nkXfF+RXg0Zb63m/OKgrJqQpJtPjzzTElNQnp16W167NORjCVdPTJQ5nkbHRMY+u6Fd7UG
        ROgl39XVWIhSOJ/jk6YyfiwwBJONkY8=
Date:   Wed, 23 Jun 2021 11:32:50 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH 2/3] x86/sev: Add defines for GHCB version 2 MSR protocol
 requests
Message-ID: <YNL/wpVY1PmGJASW@zn.tnic>
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org>
 <YNLXQIZ5e1wjkshG@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YNLXQIZ5e1wjkshG@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 08:40:00AM +0200, Joerg Roedel wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add the necessary defines for supporting the GHCB version 2 protocol.
> This includes defines for:
> 
> 	- MSR-based AP hlt request/response
> 	- Hypervisor Feature request/response
> 
> This is the bare minimum of requests that need to be supported by a GHCB
> version 2 implementation. There are more requests in the specification,
> but those depend on Secure Nested Paging support being available.
> 
> These defines are shared between SEV host and guest support, so they are
> submitted as an individual patch without users yet to avoid merge
> conflicts in the future.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/sev-common.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 1cc9e7dd8107..9aa2f29b4c97 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -47,6 +47,21 @@
>  		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
>  		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
>  
> +/* AP Reset Hold */
> +#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
> +#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
> +
> +/* GHCB Hypervisor Feature Request/Response */
> +#define GHCB_MSR_HV_FT_REQ			0x080
> +#define GHCB_MSR_HV_FT_RESP			0x081
> +#define GHCB_MSR_HV_FT_POS			12
> +#define GHCB_MSR_HV_FT_MASK			GENMASK_ULL(51, 0)
> +
> +#define GHCB_MSR_HV_FT_RESP_VAL(v)		\
> +	((unsigned long)((v) >> GHCB_MSR_HV_FT_POS) & GHCB_MSR_HV_FT_MASK)
> +

Ok, so I took a critical look at this and it doesn't make sense to have
a differently named define each time you need the [63:12] slice of
GHCBData. So you can simply use GHCB_DATA(msr_value) instead, see below.

Complaints?

---
From: Brijesh Singh <brijesh.singh@amd.com>
Date: Wed, 23 Jun 2021 08:40:00 +0200
Subject: [PATCH] x86/sev: Add defines for GHCB version 2 MSR protocol requests

Add the necessary defines for supporting the GHCB version 2 protocol.
This includes defines for:

	- MSR-based AP hlt request/response
	- Hypervisor Feature request/response

This is the bare minimum of requests that need to be supported by a GHCB
version 2 implementation. There are more requests in the specification,
but those depend on Secure Nested Paging support being available.

These defines are shared between SEV host and guest support.

  [ bp: Fold in https://lkml.kernel.org/r/20210622144825.27588-2-joro@8bytes.org too.
        Simplify the brewing macro maze into readability. ]

Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/YNLXQIZ5e1wjkshG@8bytes.org
---
 arch/x86/include/asm/sev-common.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 629c3df243f0..2cef6c5a52c2 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -9,8 +9,13 @@
 #define __ASM_X86_SEV_COMMON_H
 
 #define GHCB_MSR_INFO_POS		0
-#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
+#define GHCB_DATA_LOW			12
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(GHCB_DATA_LOW) - 1)
 
+#define GHCB_DATA(v)			\
+	(((unsigned long)(v) & ~GHCB_MSR_INFO_MASK) >> GHCB_DATA_LOW)
+
+/* SEV Information Request/Response */
 #define GHCB_MSR_SEV_INFO_RESP		0x001
 #define GHCB_MSR_SEV_INFO_REQ		0x002
 #define GHCB_MSR_VER_MAX_POS		48
@@ -28,6 +33,7 @@
 #define GHCB_MSR_PROTO_MAX(v)		(((v) >> GHCB_MSR_VER_MAX_POS) & GHCB_MSR_VER_MAX_MASK)
 #define GHCB_MSR_PROTO_MIN(v)		(((v) >> GHCB_MSR_VER_MIN_POS) & GHCB_MSR_VER_MIN_MASK)
 
+/* CPUID Request/Response */
 #define GHCB_MSR_CPUID_REQ		0x004
 #define GHCB_MSR_CPUID_RESP		0x005
 #define GHCB_MSR_CPUID_FUNC_POS		32
@@ -45,6 +51,14 @@
 		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
 		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
 
+/* AP Reset Hold */
+#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
+#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
+
+/* GHCB Hypervisor Feature Request/Response */
+#define GHCB_MSR_HV_FT_REQ			0x080
+#define GHCB_MSR_HV_FT_RESP			0x081
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

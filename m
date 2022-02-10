Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85764B1331
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbiBJQlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:41:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244598AbiBJQln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:41:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750C2E9B
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:41:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso9211390pjg.0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P8SobZ7+Miez6h7a1z0f3HTmOU821ryoP/w2sQxVLj0=;
        b=SyWVZHe9lUOk6jRLGrByGXCzQAmeQ5q2MJUJv6Llvtov0IstRDmX334S0GyRR6Kx21
         L6ry59dqB1nAJkQevI9Ze34rJS75twuJOISPVuGfKF1RccghtdUOrFxtemvos5qg0lcV
         8TtvAL4JTsqHFfTLj99TVBOfn/m9gY+Ax6j32pZd+SPMIVimVQRe6Xdy9U12HddpY2iM
         p3bB9Okx307COlO4MXeOJ+NiqszhajoL42LW2x/ZcANVJ/53wURl5dYAY4YjHNsji7e0
         5knmUWoiHNG/a0Zy7ZgX3u5PrKfPg2MTSO2jaGKJ6jf5jmGQXPgMFBdIQDSRaAm80RRR
         FbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P8SobZ7+Miez6h7a1z0f3HTmOU821ryoP/w2sQxVLj0=;
        b=SoHoiY1GG6mM3CROhk8mOnc7XKJwroYbf5dkqOhUL0PshbMr0RAbqTRsfciQw1435E
         748oO3py3FFFMU/FNiYV3rzDsosIY17qmJXfZSE4xdklTyBq1ityGl9FFA018aoHUq+V
         bWw2WDKaVCEGt3tv8N7Sp+Cj66RDB2amzBIMJRB2P2QnxsmazYT+Dv6e799FTwKkUota
         THuKJk6rieOZVDKkkhBabAB2AcWJ8mg9V/p04TQZ2bUgmoctxhOFuZ11JNyBziDyWOZT
         ytRbLz6EihJWIBlyskVuRNDkVTU8c7QdcOde6boMynK24HlWDvQBRJKKNIXQk/NmbFW9
         dChA==
X-Gm-Message-State: AOAM530LHDOS57ea3p1JfE5wa56NebcAQ6JuIOmguBtkteWx77IBWYZE
        sQiaobS5F8eDb6jgy6/yB1lx9A==
X-Google-Smtp-Source: ABdhPJwSALI+MDCmbBoJhUIPIQ+Eowpr1HkleDSUpcBAPM2qSEatcmM7FYDpC1YDN4ACxyQP2sQ2SQ==
X-Received: by 2002:a17:90a:5d82:: with SMTP id t2mr3639673pji.65.1644511294828;
        Thu, 10 Feb 2022 08:41:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n42sm23964644pfv.29.2022.02.10.08.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:41:34 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:41:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] x86/emulator: Add some tests for
 far jmp instruction emulation
Message-ID: <YgVAOuWPJhqyLbZJ@google.com>
References: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
 <9c1d2125cb8680aff8a69e04461c4d84edb85760.1644481282.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c1d2125cb8680aff8a69e04461c4d84edb85760.1644481282.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022, Hou Wenlong wrote:
> @@ -76,6 +96,17 @@ static struct far_xfer_test far_ret_test = {
>  		     : "eax", "memory");	\
>  })
>  
> +#define TEST_FAR_JMP_ASM(seg, prefix)		\
> +({						\
> +	*(uint16_t *)(&fep_jmp_buf[1]) = seg;	\
> +	asm volatile("lea 1f(%%rip), %%rax\n\t" \
> +		     "movq $1f, (%[mem])\n\t"	\
> +		      prefix "rex64 ljmp *(%[mem])\n\t"\
> +		     "1:"			\
> +		     : : [mem]"r"(fep_jmp_buf_ptr)\
> +		     : "eax", "memory");	\

Align the backslashes for a given macro, even though it means the two TEST_FAR_*_ASM
macros won't share alignment.  This needs an -fPIC tweak for the movq too, but this
one is easy since RAX already holds what we want.

With the below fixup...

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

---
 x86/emulator.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 22a5c9d..56a263e 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -97,15 +97,15 @@ static unsigned long *fep_jmp_buf_ptr = &fep_jmp_buf[0];
 		     : "eax", "memory");	\
 })

-#define TEST_FAR_JMP_ASM(seg, prefix)		\
-({						\
-	*(uint16_t *)(&fep_jmp_buf[1]) = seg;	\
-	asm volatile("lea 1f(%%rip), %%rax\n\t" \
-		     "movq $1f, (%[mem])\n\t"	\
-		      prefix "rex64 ljmp *(%[mem])\n\t"\
-		     "1:"			\
-		     : : [mem]"r"(fep_jmp_buf_ptr)\
-		     : "eax", "memory");	\
+#define TEST_FAR_JMP_ASM(seg, prefix)			\
+({							\
+	*(uint16_t *)(&fep_jmp_buf[1]) = seg;		\
+	asm volatile("lea 1f(%%rip), %%rax\n\t"		\
+		     "movq %%rax, (%[mem])\n\t"		\
+		      prefix "rex64 ljmp *(%[mem])\n\t"	\
+		     "1:"				\
+		     : : [mem]"r"(fep_jmp_buf_ptr)	\
+		     : "eax", "memory");		\
 })

 struct regs {

base-commit: 6bd9c4b6a79ed51c0e3e6a997654f4a9feb9c377
--


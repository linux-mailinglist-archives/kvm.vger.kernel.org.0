Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9648D1614FE
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgBQOra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:47:30 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40159 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728723AbgBQOr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 09:47:29 -0500
Received: by mail-qk1-f193.google.com with SMTP id b7so16379105qkl.7
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l4NNnDQyXR42LBMQRBfPRxnO5itE33bk8+h08qVfM+w=;
        b=fd40BdlFc0ZSsGQeaZ/sDzf0NCoa7sKnsBMdIYRd6exfvedBAXmPxjD+g60no3Q+6g
         fMYFizyGDvpUk6u115Uu1daEyTI1abA5x6HK2O73ZeAEggGFoFXJnyvHLl1qdI0923Qi
         8qw4+CYkbk7zhEMRD928oald5Jv2kVN7ANSeCzZJW47a/SIhfYLEO3xMsXJFAYEBGXk/
         A4TjuEyLsgGvM4u1THTaCprKjtf40JdZwl9ZyWd5JkCruDAK4xgdbGuwcFpVCi+AEJQw
         LYqdHE0fY0LQiXNPsGKzRbi4Kynqj+4xQhZmVM4/4M4oWyGI6a1HF8O0X/XBPuMyNk8W
         +NUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l4NNnDQyXR42LBMQRBfPRxnO5itE33bk8+h08qVfM+w=;
        b=Zu7quEhX6j6CNqfIdKYP/yU7Ghshr0SL3vrx24BxnZgiyQBnIcm8NuI/uz4e6sjvHX
         Rfd5MaESPyjiZtr6Bwrjkzer2Gu4uEqKexmekArZdBhsePvPDDanq7JVU/OIVQNDel/v
         HSaQLBMLfh4OvV5jVcqQnKR3fdLQ815y3imR5pQ95BD8SSRmTWzXgNyyHpExByd6Ng7+
         jpG+BsBS9xQ7uDPHdMD/zltBUj/oPuxmVqi2W9DloKUmuD1LRepDCI5K4slaiSccKO3s
         qxt6sb0SpNdVGAtpUz/0QLe+q7OKJeXqnhndIPlwY4Iev+F1TBHIUMQpp8rjsLpjku7L
         cBFQ==
X-Gm-Message-State: APjAAAXvP563Ru7AOWXaQxgC8GWkJoYN4xAIMV7E7nd/d/VMTGVdB/XN
        vbiqgvjTHu+kPrR9dpKQykh6Ag==
X-Google-Smtp-Source: APXvYqz83/y4bnkuJtKKYBPAPh8fNlPsTpp9aGlnSnYWpC6/muLktI2S/3H8NWew6d/CD/Cyu5+Jnw==
X-Received: by 2002:a37:e81:: with SMTP id 123mr11048325qko.193.1581950846372;
        Mon, 17 Feb 2020 06:47:26 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h13sm281713qtu.23.2020.02.17.06.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 06:47:25 -0800 (PST)
Message-ID: <1581950844.7365.82.camel@lca.pw>
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
From:   Qian Cai <cai@lca.pw>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 17 Feb 2020 09:47:24 -0500
In-Reply-To: <28680b99-d043-ee02-dab3-b5ce8c2e625b@redhat.com>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
         <20200214165923.GA20690@linux.intel.com> <1581700124.7365.70.camel@lca.pw>
         <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
         <1581707646.7365.72.camel@lca.pw>
         <28680b99-d043-ee02-dab3-b5ce8c2e625b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-02-14 at 20:33 +0100, Paolo Bonzini wrote:
> On 14/02/20 20:14, Qian Cai wrote:
> > > It seems misguided to define a local variable just to get an implicit
> > > cast from (void *) to (fastop_t). Sean's first suggestion gives you
> > > the same implicit cast without the local variable. The second
> > > suggestion makes both casts explicit.
> > 
> > OK, I'll do a v2 using the first suggestion which looks simpler once it passed
> > compilations.
> > 
> 
> Another interesting possibility is to use an unnamed union of a
> (*execute) function pointer and a (*fastop) function pointer.
> 

This?

diff --git a/arch/x86/include/asm/kvm_emulate.h
b/arch/x86/include/asm/kvm_emulate.h
index 03946eb3e2b9..2a8f2bd2e5cf 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -292,6 +292,14 @@ enum x86emul_mode {
 #define X86EMUL_SMM_MASK             (1 << 6)
 #define X86EMUL_SMM_INSIDE_NMI_MASK  (1 << 7)
 
+/*
+ * fastop functions are declared as taking a never-defined fastop parameter,
+ * so they can't be called from C directly.
+ */
+struct fastop;
+
+typedef void (*fastop_t)(struct fastop *);
+
 struct x86_emulate_ctxt {
 	const struct x86_emulate_ops *ops;
 
@@ -324,7 +332,10 @@ struct x86_emulate_ctxt {
 	struct operand src;
 	struct operand src2;
 	struct operand dst;
-	int (*execute)(struct x86_emulate_ctxt *ctxt);
+	union {
+		int (*execute)(struct x86_emulate_ctxt *ctxt);
+		fastop_t fop;
+	};
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 	/*
 	 * The following six fields are cleared together,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ddbc61984227..dd19fb3539e0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -191,25 +191,6 @@
 #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
 #define FASTOP_SIZE 8
 
-/*
- * fastop functions have a special calling convention:
- *
- * dst:    rax        (in/out)
- * src:    rdx        (in/out)
- * src2:   rcx        (in)
- * flags:  rflags     (in/out)
- * ex:     rsi        (in:fastop pointer, out:zero if exception)
- *
- * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
- * different operand sizes can be reached by calculation, rather than a jump
- * table (which would be bigger than the code).
- *
- * fastop functions are declared as taking a never-defined fastop parameter,
- * so they can't be called from C directly.
- */
-
-struct fastop;
-
 struct opcode {
 	u64 flags : 56;
 	u64 intercept : 8;
@@ -311,8 +292,19 @@ static void invalidate_registers(struct x86_emulate_ctxt
*ctxt)
 #define ON64(x)
 #endif
 
-typedef void (*fastop_t)(struct fastop *);
-
+/*
+ * fastop functions have a special calling convention:
+ *
+ * dst:    rax        (in/out)
+ * src:    rdx        (in/out)
+ * src2:   rcx        (in)
+ * flags:  rflags     (in/out)
+ * ex:     rsi        (in:fastop pointer, out:zero if exception)
+ *
+ * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
+ * different operand sizes can be reached by calculation, rather than a jump
+ * table (which would be bigger than the code).
+ */
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 
 #define __FOP_FUNC(name) \
@@ -5683,7 +5675,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 	if (ctxt->execute) {
 		if (ctxt->d & Fastop)
-			rc = fastop(ctxt, (fastop_t)ctxt->execute);
+			rc = fastop(ctxt, ctxt->fop);
 		else
 			rc = ctxt->execute(ctxt);
 		if (rc != X86EMUL_CONTINUE)

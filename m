Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97E07521DC
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjGMMuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 08:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbjGMMuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 08:50:05 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3502D71
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 05:49:32 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1vY95tpFzBRSTq
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 20:48:29 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689252509; x=1691844510; bh=XyMYDjcQC6+dgPnu3BuklwgtWvG
        Wtys2VxsyHNQ9PoA=; b=h95VI81ggq2q3DfCYRMYuveknTG8eEwq2cag/vN26YP
        Nvlsri1dzoME6V0xg5YDuwAlCTzVsnWKEOSXgkN94R/df2vcrx/tEj4OQkrkRLh4
        GDxJwbr0wdbxrioV5RgMOBZ0NVS5KXZV8S4JKea4DnHVC77JaTg/JkVq1Ey8dCzu
        gqlZF8IjjxnlYWn/RhJfvL1e2gPhy1ep0iTKTgOXoyJESIIUygrggG+GO5rYSDO1
        9VI5lnC725gRZ5r0CtS40LY0nBSlWaLLvppahNY8RjLtbW9kA30NyMhyrx/EfHGw
        oVrohJf+HhiGDai66hUENIWxlBwgodgoxp2SG6HOtpw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9PPjiy5mdjMq for <kvm@vger.kernel.org>;
        Thu, 13 Jul 2023 20:48:29 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1vY91vJqzBRRLw;
        Thu, 13 Jul 2023 20:48:29 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 13 Jul 2023 20:48:29 +0800
From:   huzhi001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix warnings in kvm_emulate.h
In-Reply-To: <tencent_415AB86AA63A22065D7B022D94B2209BB707@qq.com>
References: <tencent_415AB86AA63A22065D7B022D94B2209BB707@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <a96564ba2d5b643fdbca000f686f2843@208suo.com>
X-Sender: huzhi001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warnings are removed:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Signed-off-by: ZhiHu <huzhi001@208suo.com>
---
  arch/x86/kvm/kvm_emulate.h | 16 ++++++++--------
  1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index ab65f3a47dfd..652020025457 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -95,14 +95,14 @@ struct x86_emulate_ops {
       *
       * @reg: gpr number.
       */
-    ulong (*read_gpr)(struct x86_emulate_ctxt *ctxt, unsigned reg);
+    ulong (*read_gpr)(struct x86_emulate_ctxt *ctxt, unsigned int reg);
      /*
       * write_gpr: write a general purpose register (rax - r15)
       *
       * @reg: gpr number.
       * @val: value to write.
       */
-    void (*write_gpr)(struct x86_emulate_ctxt *ctxt, unsigned reg, 
ulong val);
+    void (*write_gpr)(struct x86_emulate_ctxt *ctxt, unsigned int reg, 
ulong val);
      /*
       * read_std: Read bytes of standard (non-emulated/special) memory.
       *           Used for descriptor reading.
@@ -240,10 +240,10 @@ struct operand {
          unsigned long *reg;
          struct segmented_address {
              ulong ea;
-            unsigned seg;
+            unsigned int seg;
          } mem;
-        unsigned xmm;
-        unsigned mm;
+        unsigned int xmm;
+        unsigned int mm;
      } addr;
      union {
          unsigned long val;
@@ -508,7 +508,7 @@ void emulator_invalidate_register_cache(struct 
x86_emulate_ctxt *ctxt);
  void emulator_writeback_register_cache(struct x86_emulate_ctxt *ctxt);
  bool emulator_can_use_gpa(struct x86_emulate_ctxt *ctxt);

-static inline ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned 
nr)
+static inline ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned 
int nr)
  {
      if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
          nr &= NR_EMULATOR_GPRS - 1;
@@ -520,7 +520,7 @@ static inline ulong reg_read(struct x86_emulate_ctxt 
*ctxt, unsigned nr)
      return ctxt->_regs[nr];
  }

-static inline ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned 
nr)
+static inline ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned 
int nr)
  {
      if (KVM_EMULATOR_BUG_ON(nr >= NR_EMULATOR_GPRS, ctxt))
          nr &= NR_EMULATOR_GPRS - 1;
@@ -533,7 +533,7 @@ static inline ulong *reg_write(struct 
x86_emulate_ctxt *ctxt, unsigned nr)
      return &ctxt->_regs[nr];
  }

-static inline ulong *reg_rmw(struct x86_emulate_ctxt *ctxt, unsigned 
nr)
+static inline ulong *reg_rmw(struct x86_emulate_ctxt *ctxt, unsigned 
int nr)
  {
      reg_read(ctxt, nr);
      return reg_write(ctxt, nr);

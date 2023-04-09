Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B76DBEEF
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjDIGmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIGmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:42:20 -0400
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3B4EF8
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1681022534;
        bh=0xoq0VZblymNffNwmojFXnhxMT/n2/0TJ5ITpjunB3c=;
        h=From:To:Cc:Subject:Date;
        b=Crzc7B2pmGXuaii9GljrlOEkH7bBSkgu7CrejpVhUzg7jbOTleqQ4FUW9Kpgqfboq
         DVDM/7OwFkueXkJh7fS/vNoZMkumI5mzx0wiKCkqhsgLNTyMn9mrdJB0oPplZKuOyi
         it6jGonMHpo/XlLyID+qW+j0uZpNL7cGwyx7WrCQ=
Received: from rtoax.. ([111.199.190.121])
        by newxmesmtplogicsvrszc2-0.qq.com (NewEsmtp) with SMTP
        id 99CACC8D; Sun, 09 Apr 2023 14:38:28 +0800
X-QQ-mid: xmsmtpt1681022308txf8ucmpa
Message-ID: <tencent_A1425D591197F22A02AF2CA3EA8858068D08@qq.com>
X-QQ-XMAILINFO: NDgMZBR9sMma+AV5IAtjyQJ66oIlUw4U0lmGi0LnBKiZgf9CE8IGpuPIGlC4xS
         wUeIEiZqwI829Zp2scj9yKpJv4Y41DbBcbQk4zOBfz5NqxB43PjjipriofkBzMnjn+oaVorzWGb5
         6UiWQ5rY/wgWaq9pDmPpwzVRQBoXdJz6bwyqMI5CbjnS4p1URUyqgJ0CWRggIK/cIHhilZJGQKAV
         isdePkPrfm5xQK3I/UHCHx35skR6JJ1Q1q9ry7poWN5vsUl4ikQOW69ZmPOFYMQobFFlBesb6q+6
         oleUNcDGCJl8Om/zFTi5gKKFJcnqiWAPHGjO2YhLiYM09l86NtQbdWw2uiHA4/6i6EOM9Z2z4SoI
         b8z/D4Fm/FJVSGsXOiw0HAkmWDwe052Yz+JdWXVsoZtbnOWbA6RqNtn/XrYm+VmPjT59qemH6uYV
         ofRYUkX8YEcTe3oCA53ZbzMhF9N3Gt4JvpIc5iLm2Xor5qiZjKD4/axqux7LOzyAb10uEAPM6M/d
         D4Cd449VMfR+iCLXfbQ8v4gMRg3+vmpCRDSbnMAcub0RUXXvga3GY1GzJW9/C9V0AJ20oX8dFcuw
         a74lOOjOKutxwti7rtpl/7vYwUEL+mJzrszCzNUZ5DPtQ0MkrAn5SP7CPxeP6UH+V/f8RQq6VwYc
         5c7hx9qS6Txfvgs0AXdC3Gk//fDOdep12AnjYDazxO21weDBX49+iPTWOkTrHBeLnnNd5mrjhSlt
         Vqkf81PoqbSmxGXJKZzJYWVAoQ9xF+W+Lt5slwBxw0FLXLWcwPZDzFJCgchfrnnoGlHG/C+XUCza
         Q9DLmBI22wWOnEEl6H87fqAxnBi2oJZIHfw5T8YrFUbUFCSz7K+S+lMcO2qHdy+vACB9ToHNPLsJ
         n0eyKmLKXTTHRdObfyc/RfLorGf3BhqEfOTIhuw2HTzEImFvtYp2OE6G/j8a1ftEwMEJABFk9iF1
         t1f01RBHtM9eBBUMvySLo2CdxnN1qQ
From:   Rong Tao <rtoax@foxmail.com>
To:     seanjc@google.com
Cc:     rongtao@cestc.cn, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] KVM: x86/emulator: Use tabs instead of spaces for indentation
Date:   Sun,  9 Apr 2023 14:38:27 +0800
X-OQ-MSGID: <20230409063827.167207-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Code indentation should use tabs.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 arch/x86/kvm/emulate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a20bec931764..b45ef99ebfab 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2259,13 +2259,13 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 
 static int em_ret_far_imm(struct x86_emulate_ctxt *ctxt)
 {
-        int rc;
+	int rc;
 
-        rc = em_ret_far(ctxt);
-        if (rc != X86EMUL_CONTINUE)
-                return rc;
-        rsp_increment(ctxt, ctxt->src.val);
-        return X86EMUL_CONTINUE;
+	rc = em_ret_far(ctxt);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+	rsp_increment(ctxt, ctxt->src.val);
+	return X86EMUL_CONTINUE;
 }
 
 static int em_cmpxchg(struct x86_emulate_ctxt *ctxt)
-- 
2.39.2


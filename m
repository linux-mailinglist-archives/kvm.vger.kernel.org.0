Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44B2D081A
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgLFXlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgLFXlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF01C0613D1
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:44 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id p8so11055603wrx.5
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B/NrR5V+/HZCdWuAnYAqhfTZDaNUhGvFBTcglSmrBsA=;
        b=m4z3WWoyk+Rg3BjX02RHRMctF6LXJkoNf3ztaE25+iOXC9vzlk5ns3EEXqsXAFIleR
         HcOahTgCJFR6V6F0LhW7mG9nwgsYYPBcwgHruLbE4h0Om005WfLjbM54R8ntvbLJfxep
         oJb2JFQMDn607DTV0uDAvPe7H8A74HIiBu7XZxsxYfTDQbB7DtY7I1hKezTnb7qnoFY5
         GyB36yDYuaP1V5BhCwU2rGqWKD10FlXUoyu54XfXWWeXiuYIjhWb7TrvK6VFWqz6DPih
         YiHl66Z2/hp9/Z8bM18m8sNGbJB377p6Ek3mwICiNHoarz/Pqa9UvHACAuTO2988L0uQ
         M/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=B/NrR5V+/HZCdWuAnYAqhfTZDaNUhGvFBTcglSmrBsA=;
        b=OcJ4rhNwAp/QTYYicrgzvkIp3+FchDtpTSq5cfSLRr9TxWCN70lUF6RTfXF4ggzlXy
         aHi5JyXJ/WCsogUA897C0tvEyjN+mbrVAOzddymhjT0SmB+fTcyrtk1nWca4NjHUw1kg
         MSJwKutT0DPCdR/CUpTg4b7E8ci/LX0M45BfKV7I7w3zyqc1N74PbbL3Zuasj3nQieJ1
         IuRywYDtcMsoxE29Ky4HBRc9MnijmMxvL017wiX7X+TzRAo33+fUr7/9xgzQYerG3Zae
         3RKK2Jv8zCEKQIRi+Mlryk2IFoW4G1THfrQarvDkNKcuZNSOvMsJfgxuhg3Pdf9V8fLs
         6oWQ==
X-Gm-Message-State: AOAM532GYvvfLIKBpIjv0rFyE3qoFg/HlcALkOnDl3pgaB1S5HDje352
        EV3S5KTPP3XKKRFVHQ8PI8M=
X-Google-Smtp-Source: ABdhPJwmEAy9N8jHYAPoMpDouYPkT9Pj6b8gyMnw9VTr/7xAEcomMuXXl66GctcoGDdBkCySGNDXGQ==
X-Received: by 2002:adf:b74d:: with SMTP id n13mr16913334wre.101.1607298043036;
        Sun, 06 Dec 2020 15:40:43 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n10sm12603481wrv.77.2020.12.06.15.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:42 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 10/19] target/mips: Add !CONFIG_USER_ONLY comment after #endif
Date:   Mon,  7 Dec 2020 00:39:40 +0100
Message-Id: <20201206233949.3783184-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help understand ifdef'ry, add comment after #endif.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/helper.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index bb962a3e8cc..6d33809fb8b 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -455,7 +455,8 @@ void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val)
         }
     }
 }
-#endif
+
+#endif /* !CONFIG_USER_ONLY */
 
 static void raise_mmu_exception(CPUMIPSState *env, target_ulong address,
                                 int rw, int tlb_error)
@@ -537,6 +538,7 @@ static void raise_mmu_exception(CPUMIPSState *env, target_ulong address,
 }
 
 #if !defined(CONFIG_USER_ONLY)
+
 hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
     MIPSCPU *cpu = MIPS_CPU(cs);
@@ -550,9 +552,7 @@ hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
     }
     return phys_addr;
 }
-#endif
 
-#if !defined(CONFIG_USER_ONLY)
 #if !defined(TARGET_MIPS64)
 
 /*
@@ -886,7 +886,7 @@ refill:
     return true;
 }
 #endif
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
@@ -1017,7 +1017,7 @@ static const char * const excp_names[EXCP_LAST + 1] = {
     [EXCP_MSADIS] = "MSA disabled",
     [EXCP_MSAFPE] = "MSA floating point",
 };
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 target_ulong exception_resume_pc(CPUMIPSState *env)
 {
@@ -1080,7 +1080,8 @@ static inline void set_badinstr_registers(CPUMIPSState *env)
         env->CP0_BadInstrP = cpu_ldl_code(env, env->active_tc.PC - 4);
     }
 }
-#endif
+
+#endif /* !CONFIG_USER_ONLY */
 
 void mips_cpu_do_interrupt(CPUState *cs)
 {
@@ -1480,7 +1481,7 @@ void r4k_invalidate_tlb(CPUMIPSState *env, int idx, int use_extra)
         }
     }
 }
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
                                           uint32_t exception,
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F065E2D9F55
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407662AbgLNSj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408892AbgLNSij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:39 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AEEC06179C
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:58 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id x22so14680711wmc.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkYIisFgK6Je25iDH+AcvdFQgbr8b03Vk9AV0zMlHWI=;
        b=hgL3Ac52u3mHBafiHWMQFZ22Iz9iA+Su5rN5IOY9SxxsUtNm3tSIXIZgoUPSbW35cm
         c2SVS3s/gtJEm0xzO+5g7DRoQmlZ4fwJEgCwd1trER19AAl5aD1P30esrymA8yESj3ND
         l8tbsA6hnXMPal+/PgwbdFUAVa6uUKbTCIxkzxYUzyNPD5jBKTOuCBvizf382DksF7JP
         YbNBCSN5D3xjr5rq8dIL/lR8YDyXg/iYvUYglHdyRPTNoQq9DjEU01Gqd8tIt2V91JKz
         STe93f1h68AdAskIYZb/HAua3Tc4iNJAxv8u2rKyNuJnQEq4VHADmGiJNBmBGVhNZcK1
         X6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=tkYIisFgK6Je25iDH+AcvdFQgbr8b03Vk9AV0zMlHWI=;
        b=ZgQ5nUaPCTcpgx+Az41WScR4tSsIz05KHQNicTXrZe8YU8A7Lk55gWnhh7JrbKfyKP
         96nIuQ8fZ+ucEdpZqcH+bPijRJCtzIoGDwv5CAwi9GFt6Yk+3BglDjOYWcywIcZ4Oa66
         pMhTGzedLJqqebh7WXLCxCzrkco14ElsYShixngArsObZCGJuTfZGoFQj998XW2e55gm
         Q4NC3NSxBLJskOVAEczmqJsSBsUfvWg1JAeYGY+LC2uiSRRa7yles+J94Gws0gj3QUV0
         /D9GIa1hVMfmkB5KuaLhp5fuDfywiK+ZzP53YFQ38VVj8MwgnHrWrl34QBmbGfeC6qw+
         ww+A==
X-Gm-Message-State: AOAM531bG1dXB920nMVlz3e43Oqj/r8EVYgYLretzWzRfOl/6kvaxSoA
        fmC+bgeYqgGG6VTufa9CWVU=
X-Google-Smtp-Source: ABdhPJwzkNHg3Tv/g0fScefe8FqRMtvselhx3j0oy/GqpnxEqHkfTN6UAORwsjlkl1T0lM6wjnSslA==
X-Received: by 2002:a1c:6a10:: with SMTP id f16mr29145023wmc.106.1607971077643;
        Mon, 14 Dec 2020 10:37:57 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id p15sm24306743wrt.15.2020.12.14.10.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:37:56 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 03/16] target/mips: Add !CONFIG_USER_ONLY comment after #endif
Date:   Mon, 14 Dec 2020 19:37:26 +0100
Message-Id: <20201214183739.500368-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help understand ifdef'ry, add comment after #endif.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/helper.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index 87296fbad69..cdd7704789d 100644
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
@@ -550,7 +552,7 @@ hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
     }
     return phys_addr;
 }
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 #if !defined(CONFIG_USER_ONLY)
 #if !defined(TARGET_MIPS64)
@@ -886,7 +888,7 @@ refill:
     return true;
 }
 #endif
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
@@ -1088,7 +1090,8 @@ static inline void set_badinstr_registers(CPUMIPSState *env)
         env->CP0_BadInstrP = cpu_ldl_code(env, env->active_tc.PC - 4);
     }
 }
-#endif
+
+#endif /* !CONFIG_USER_ONLY */
 
 void mips_cpu_do_interrupt(CPUState *cs)
 {
@@ -1482,7 +1485,7 @@ void r4k_invalidate_tlb(CPUMIPSState *env, int idx, int use_extra)
         }
     }
 }
-#endif
+#endif /* !CONFIG_USER_ONLY */
 
 void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
                                           uint32_t exception,
-- 
2.26.2


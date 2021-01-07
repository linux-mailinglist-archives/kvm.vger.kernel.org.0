Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A724F2EE872
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbhAGWZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbhAGWZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:01 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918E2C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:46 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m5so7108705wrx.9
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r446af/BEgIH/8cqnACVmQPnVuqEMMgc7/K3JtKHKOk=;
        b=qpGFzj6m5FFszD8aYLBDnx6u1j4Fcq3cD4+18rtk/1dXSmrBZ7SxbOv+JTQbaOoamo
         VghsaUWLHh3z1PxUodplat8odiJmWx0t9EH3Q/5sbMdZ7yuAfERITlKxX45V4kIVnboF
         6+nZogq77Fzm63hXVLs2L9smY3wRGF1TnuDgwiY8F2/qfk4PtM8n9oWO27kWk6uAuJak
         t/xMkhi8cXqFgMrt7l4jsAkxM5Q1BjXqqKeCshZ9geLomJE24dPBOxRMz5FqGrGmwys1
         qRomXr8fWuRAPa1ec5UgGXS6gIxpF3CdnYl/+tUhko6aT43mCjZkXl4Gxk0HAkJf9tvl
         EcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=r446af/BEgIH/8cqnACVmQPnVuqEMMgc7/K3JtKHKOk=;
        b=gTpWyhjFjBFKoEiDvzfFgETHEFkU9NlXhNI9bbiwMqdY/rSiZ3stmo0hQW528Rx0ib
         553W8GpWJfoICzQ4YK7cSxzeJs8pzz9efRV5XgKKnPaY+t68s/5Uh8ToCe6v9uh2vOQ9
         kXwXXngxKVOVOn9GVnccq6/UrDD0EjNGN04v3NJd2kBWEshFpGkM81k9U0mMI5y/U5MH
         1AKrZKfO/S0oJOlE2a6vQE+HJBPwZbVFwQHmKRvKBpkgsI4TzIR5Lj30hONEVYtdIncE
         2IF5AEHOmN033JiGBd5haJE014u/ALnBVCT3r+je8BtV33ZkVq8Fj7evwI5wOEC9N1ID
         J8Ow==
X-Gm-Message-State: AOAM531/RXZmS7CYPR5CBH86EGhkrNQe/S6CEHftQTv4m5KUc9ih5zIm
        ywD6AoZJQhoRPZUpnnez426CtnsSVqc=
X-Google-Smtp-Source: ABdhPJwCsmyU6k2gmlk9eYhvqhY92VyIIL3GWXGM3B7ZnDJ3ScTAoH3Xic2OzXnKHm6okNdHJVKirQ==
X-Received: by 2002:a5d:4ad0:: with SMTP id y16mr662380wrs.424.1610058285366;
        Thu, 07 Jan 2021 14:24:45 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id n9sm10103105wrq.41.2021.01.07.14.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:44 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 21/66] target/mips: Add !CONFIG_USER_ONLY comment after #endif
Date:   Thu,  7 Jan 2021 23:22:08 +0100
Message-Id: <20210107222253.20382-22-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help understand ifdef'ry, add comment after #endif.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-4-f4bug@amsat.org>
---
 target/mips/helper.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index d1b6bb6fb23..92bd3fb8550 100644
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


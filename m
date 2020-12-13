Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204EE2D907A
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgLMUX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405812AbgLMUWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:15 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F5C0613D6
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:34 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w206so7881922wma.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IDtGX2egqT20QSVpEfuV5BUBIdAjxxq0FJmWInmLOws=;
        b=Rxe8/tK8x4o7R657Ex50CPpjB7/EeLZSFOP/XW+Mp4GBXVOrmqCRbWCxCDTTx9gQik
         x0rBQFDVRBfCSceRMW6vr0zWpwdDCV5lTNHemp/PDmd2xIab4knatraB71vETXn7AK7P
         RaNYEktPRVo/AgDkUZkmq+4gZV7c0YwWEqxeNLxTR7RWm5qW/1YAY7u+bn3Syll+J/G/
         qr5Onq688Qk5UTFBdCX/MytWg0Esf5gND5ozdRUZFhagfjUrlaf79+cD6Sr+9UyKaJqk
         GDbwH1buILB/J3O50q+c6kXzfv2nc/cn2hPveeyXR0JTBMuhp0slv+HJywc43jEmgZta
         /X/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IDtGX2egqT20QSVpEfuV5BUBIdAjxxq0FJmWInmLOws=;
        b=Ry3D/BF8bAWkkVrX38yab0CtKs93j5WOW/pLDXzqipcqP+Dc18YNeDM/RMysFVOSYH
         DTDU6klcVzgoBu4m6kgl4pl4ua2oNGsSYwOh9MdQXM7M2ango2oqODb3zQ+cXuKujMZL
         Sl9LejfoCby1SbDYiJR6BaTU3TDgdNPRgYrlmnYwRblNoIMaskbWREFiyxQshz4zxpQN
         i7VVGWzI7Baw/TKOBz8gk5Zgba8PDs6n6dxihxRbrttD+adlfPI9dr2Xuwo8IzpkLbWf
         rXiWHcaCektkAQZc9cu9yhOArN1gd+/ba4jS1rp0cp9pqwxmVxL8jH/g45BFdhaUTrfe
         yKcg==
X-Gm-Message-State: AOAM533NfMGhdVs8DMEit1q/UqX2pxw8U2mUn7L7pxQ0Opcf+8Cmwy06
        m7ugl2rktn9M9TZQjD6NcTIBOtkfrkI=
X-Google-Smtp-Source: ABdhPJw978QeLLZUhsM1IEM53GS3n3KXCYYFMbTvhHOFyz2/tV3RpsUG9gPyUqOu8SIdUbYNfVOzxA==
X-Received: by 2002:a05:600c:211:: with SMTP id 17mr24471325wmi.84.1607890893645;
        Sun, 13 Dec 2020 12:21:33 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v189sm28388850wmg.14.2020.12.13.12.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:33 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 21/26] target/mips: Extract cpu_supports*/cpu_set* translate.c
Date:   Sun, 13 Dec 2020 21:19:41 +0100
Message-Id: <20201213201946.236123-22-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move cpu_supports*() and cpu_set_exception_base() from
translate.c to cpu.c.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-9-f4bug@amsat.org>
---
 target/mips/cpu.c       | 18 ++++++++++++++++++
 target/mips/translate.c | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 9d7edc1ca21..3024c51a211 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -315,3 +315,21 @@ bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask)
 {
     return (env->cpu_model->insn_flags & isa_mask) != 0;
 }
+
+bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa)
+{
+    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
+    return (mcc->cpu_def->insn_flags & isa) != 0;
+}
+
+bool cpu_type_supports_cps_smp(const char *cpu_type)
+{
+    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
+    return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
+}
+
+void cpu_set_exception_base(int vp_index, target_ulong address)
+{
+    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
+    vp->env.exception_base = address;
+}
diff --git a/target/mips/translate.c b/target/mips/translate.c
index ccc82abce04..84d2d44e5d5 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31766,24 +31766,6 @@ void cpu_mips_realize_env(CPUMIPSState *env)
     mvp_init(env);
 }
 
-bool cpu_type_supports_cps_smp(const char *cpu_type)
-{
-    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
-    return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
-}
-
-bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa)
-{
-    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
-    return (mcc->cpu_def->insn_flags & isa) != 0;
-}
-
-void cpu_set_exception_base(int vp_index, target_ulong address)
-{
-    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
-    vp->env.exception_base = address;
-}
-
 void cpu_state_reset(CPUMIPSState *env)
 {
     CPUState *cs = env_cpu(env);
-- 
2.26.2


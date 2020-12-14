Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEE12D9F4F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408894AbgLNSil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408883AbgLNSi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:28 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D1CC061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:48 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 3so16186139wmg.4
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PkbswluQKWjRx3dBtHaGXoEp5nk30ZYfIfOdkw/Z4mE=;
        b=so87HLcUDeHLMSRrrBIoaQWUwBf8G3+RiGUHx0pXI0M8i8oVclm5u38oWxGVU+nRE9
         H1/I+bkvfeohZvPRDLGNrptdMb+bS/XgK3I3hemaCE4VuYbp+oP8+OEm6BaxdYpVWC5q
         7kdq8C+VkX1BkPWurVnCHTbxnFpB1RkgtRNapuqHjZDaFp5gokompzmmnRBHp7irMovG
         HplSBu+h5qd5YPQpXjbyjrz2Qx+8dbFmeEToshnQT5AEFmjWT8/8pf5RXYihAN8NPqqV
         XW+aOXYWZUP/uJ/OYB3uskd5w4ddXWksjA52rV84hF4Rzc6VUX3VxpFwzSY8JvoiQx3F
         TryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=PkbswluQKWjRx3dBtHaGXoEp5nk30ZYfIfOdkw/Z4mE=;
        b=UI89hgdL5ad2wwoZyquraF7rzcMQH0rqtMizGceRnufjEEN92OAVdJYsXS2NILSajH
         SOfAcjLHrxsNHpEsS0vRJn4cbE0dMolpxMbc8JeRtPiDUykX0ximEuZwR8u2pRRyB+ln
         X+xmVpyVQhiY2754fxruyCSLdCu4Z7A+3eh6OAcrXkA/4kKLNXsXkquGfIZCkPCVd5bc
         i7eo8/fTIyiRtbUtQnJXUxkwai+UtSCWfnuqXxNoTKIfYnuT1z5wEN+CZzpv4PobTCuQ
         7JKSKmv5IlKSlsBjSi15Q0SGHcEWCAjtrq/hT2vP+FZeBuavNeAGQDuy3QCmRUYwW7al
         MLOA==
X-Gm-Message-State: AOAM530R8i2JuEUxycXQdq9heHRhR0w6PJrBqRfyx97xNQEOBvNmGHdt
        J5p7pkirnIhtzquTVmJhdKo=
X-Google-Smtp-Source: ABdhPJwGXLAxo6yN+sLIdbUznMxVePFYOVX87wckAVWiT7wsnNmHFrE3HhgsbKkK5tMFh6Kt4WouSg==
X-Received: by 2002:a1c:2c83:: with SMTP id s125mr29306057wms.161.1607971067021;
        Mon, 14 Dec 2020 10:37:47 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id y7sm33139083wmb.37.2020.12.14.10.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:37:46 -0800 (PST)
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
Subject: [PATCH v2 01/16] target/mips: Inline cpu_state_reset() in mips_cpu_reset()
Date:   Mon, 14 Dec 2020 19:37:24 +0100
Message-Id: <20201214183739.500368-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index aadc6f8e74d..7a0dcb11ecd 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -104,10 +104,16 @@ static bool mips_cpu_has_work(CPUState *cs)
 
 #include "translate_init.c.inc"
 
-/* TODO QOM'ify CPU reset and remove */
-static void cpu_state_reset(CPUMIPSState *env)
+static void mips_cpu_reset(DeviceState *dev)
 {
-    CPUState *cs = env_cpu(env);
+    CPUState *cs = CPU(dev);
+    MIPSCPU *cpu = MIPS_CPU(cs);
+    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
+    CPUMIPSState *env = &cpu->env;
+
+    mcc->parent_reset(dev);
+
+    memset(env, 0, offsetof(CPUMIPSState, end_reset_fields));
 
     /* Reset registers to their default values */
     env->CP0_PRid = env->cpu_model->CP0_PRid;
@@ -330,20 +336,6 @@ static void cpu_state_reset(CPUMIPSState *env)
         /* UHI interface can be used to obtain argc and argv */
         env->active_tc.gpr[4] = -1;
     }
-}
-
-static void mips_cpu_reset(DeviceState *dev)
-{
-    CPUState *s = CPU(dev);
-    MIPSCPU *cpu = MIPS_CPU(s);
-    MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(cpu);
-    CPUMIPSState *env = &cpu->env;
-
-    mcc->parent_reset(dev);
-
-    memset(env, 0, offsetof(CPUMIPSState, end_reset_fields));
-
-    cpu_state_reset(env);
 
 #ifndef CONFIG_USER_ONLY
     if (kvm_enabled()) {
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACE2D0818
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgLFXlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgLFXlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:19 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C21C061A53
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:34 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a12so4230892wrv.8
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aknicxq69ir15ZLnRnKAAOwqB9N6TW01pMwQWojqcCI=;
        b=SMcwF9Y38HdM3cHw+XUBTdWjcIxdXMevhr+d3RMSQzJm7SV4btb/jzsKL6dyAT8J4N
         RF/q0qOF69NuRBYtyjFNGzlvDciWaIjIoQVXTlKFg3tNb+UMTvzOHNi8cTjrAvr38IOB
         7gxFGtyOi+UX+l/vxT+ZZYH98m14+QNyVTZyi5LpzA4E9c7w2hx1RKB5VHo0meETNuh6
         5BvCm5p+lwkR3annd+3tgsEfLQdKYojvFNrou4sqlExf9n+yKPonUV1PUUHYd51z2D8V
         fre8cnC9LZsoexMnX6V4/ERaQtZ9XG4ZVXhtBJRs6VxhywP0thKFBNq8kwz6b45vW5Qn
         b69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Aknicxq69ir15ZLnRnKAAOwqB9N6TW01pMwQWojqcCI=;
        b=Oz+KkGeeEy5OLjZueaiw1pfRsDCKfaJ/X/o0p7R/AKWNhm6dvhe4oErva7wscPbcxr
         pP+DLGE8AC/y3RMdZDa0UOpYrQFiCEvd9sONhHaH2dcWmaIeQyY3f185uODio7ytNgys
         vQAusB+ozRBbhUlRNKS/ShpVuoFm+vPAED1KHisUDdS4SX5JLhGZHL7a4VIpRo9tg2oF
         vQaNiRtfPcqt/Tt/4Goh6D+UeOhhGePtLvRVWUZPQ6FeCKJ4uKSzAJ79T/z/da5hMnU8
         gOnjMzOXMDeJOF37dj5cKNymbtlxF34waU0PySEY73U1TB4iJ9gwmuDrgXt3RtmmbMey
         aYww==
X-Gm-Message-State: AOAM533vJ/IN2IANEuHy3ptx/cmEKID7wAYNhoG/3OU8G0cL2zkq8s4T
        xpYAwd6k2oJBeqrOqRD64H8=
X-Google-Smtp-Source: ABdhPJxxew9ajV5OxcxEX4k8jrJziKOpQJ8c03uGsdsLbbr/Q/8/WsepohI0sQWMGW6MqgyNb1BSYA==
X-Received: by 2002:adf:f48c:: with SMTP id l12mr16503466wro.280.1607298032990;
        Sun, 06 Dec 2020 15:40:32 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a12sm12721260wrq.58.2020.12.06.15.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:32 -0800 (PST)
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
Subject: [PATCH 08/19] target/mips: Extract cpu_supports*/cpu_set* translate.c
Date:   Mon,  7 Dec 2020 00:39:38 +0100
Message-Id: <20201206233949.3783184-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move cpu_supports*() and cpu_set_exception_base() from
translate.c to cpu.c.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.c       | 18 ++++++++++++++++++
 target/mips/translate.c | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 76d50b00b42..8d9ef139f07 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -310,3 +310,21 @@ MIPSCPU *mips_cpu_create_with_clock(const char *cpu_type, Clock *cpu_refclk)
 
     return MIPS_CPU(cpu);
 }
+
+bool cpu_supports_cps_smp(const char *cpu_type)
+{
+    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
+    return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
+}
+
+bool cpu_supports_isa(const char *cpu_type, uint64_t isa)
+{
+    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
+    return (mcc->cpu_def->insn_flags & isa) != 0;
+}
+
+void cpu_set_exception_base(int vp_index, target_ulong address)
+{
+    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
+    vp->env.exception_base = address;
+}
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 346635370c4..dbb71fdaa5d 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31766,24 +31766,6 @@ void cpu_mips_realize_env(CPUMIPSState *env)
     mvp_init(env, env->cpu_model);
 }
 
-bool cpu_supports_cps_smp(const char *cpu_type)
-{
-    const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
-    return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
-}
-
-bool cpu_supports_isa(const char *cpu_type, uint64_t isa)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FD62DB6B8
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgLOW67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOW67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:58:59 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B63C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:18 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cw27so22811503edb.5
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gfAK/5l8oepBv1m9fLlqhZZJOh/VztlrVhqk0ziS8jY=;
        b=FdLu6d7skwAkLOlWHhnw6CiK9nTmqSFMQ2+f3bQKkxDBeFfIIsep4RJ4VxOZ3Yy17p
         SGAek2pKHRsx1RZHfY/x/wHRH8f30dESCnX3vmr3QoIk/GXgq/tytDYV8D8tZQHHpEHP
         6sl0NKCEuQJoTlEzGwITjQQI3hnDr8e7FSckAnVzfged+2Dv0dtlSlYKPgLd5FLt2fWf
         icL46mdmQhgYhLDRRRg7AFhiPKLdBTdLWsfb0nEPikLlNnRLt8ANtxLEPeS6IFORnamV
         Bdd+ZmX04Wlh5Fbu/j7W2Cfhz/g6WuGHhj4JYiT4yzvSx92fmBLqgGw3a5ChUkktz1gP
         OXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gfAK/5l8oepBv1m9fLlqhZZJOh/VztlrVhqk0ziS8jY=;
        b=AUbjSTiN//sP88oRDQ1Gk5XTtgCOnEw6Uo4d1ehIpk7IpEEc9yreRYKawHtdHTjh00
         p5SHWLle9A6mES8ugRrHQIdeEsx3MrIZz4/jYpMLhpKF2VzdCD9jYmuPnGfy1ClY/kZE
         ICVBk3oppsFOrMP07TiPNMhQhiF9XRCvdg0pTKdzWMx14FzQp5zIWQCmPSOhxuGzP5vc
         jZH17qYst+G/AeMHkMg0eHgGcdm2ni+G6vQ71ujy/WWkVE0A6rJym3L7yfRccVPw8WHN
         3DR7dXLKmsrMGzesdN1lKBMeluJp7trYkQQbVoJIOH9P0z+17KxQC4aoXgwIy/oZRstK
         /CKg==
X-Gm-Message-State: AOAM532p4bxIusuMbh2Ty6KbOZ0chptJMiSHBUxKh8CvZdeyLfI31MQb
        jz6VOlwwcyoN4Ri3Z/QUGnA=
X-Google-Smtp-Source: ABdhPJzMV5ebQ8WKtlqOKKPT4HVLHg+DJtP96dH2LzWIIc/qEDJS0DRMCBuv96y66yLjeOVyXmrpnQ==
X-Received: by 2002:a05:6402:30ac:: with SMTP id df12mr32562213edb.175.1608073097456;
        Tue, 15 Dec 2020 14:58:17 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id g18sm19135013edt.2.2020.12.15.14.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:16 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available() helper
Date:   Tue, 15 Dec 2020 23:57:36 +0100
Message-Id: <20201215225757.764263-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the isa_rel6_available() helper to check if the
CPU supports the Release 6 ISA.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.h | 1 +
 target/mips/cpu.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 3ac21d0e9c0..c6a556efad5 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1289,6 +1289,7 @@ int cpu_mips_signal_handler(int host_signum, void *pinfo, void *puc);
 bool cpu_type_supports_cps_smp(const char *cpu_type);
 bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask);
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
+bool isa_rel6_available(const CPUMIPSState *env);
 
 /* Check presence of multi-threading ASE implementation */
 static inline bool ase_mt_available(CPUMIPSState *env)
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 4191c0741f4..9f082518076 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -789,6 +789,14 @@ bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask)
     return (env->cpu_model->insn_flags & isa_mask) != 0;
 }
 
+bool isa_rel6_available(const CPUMIPSState *env)
+{
+    if (TARGET_LONG_BITS == 64) {
+        return cpu_supports_isa(env, ISA_MIPS64R6);
+    }
+    return cpu_supports_isa(env, ISA_MIPS32R6);
+}
+
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa)
 {
     const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3BB2D9066
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404842AbgLMUVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404790AbgLMUVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:30 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132B1C061793
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:50 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r14so14392745wrn.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnT/tPVrq2N2FYMYgZtTYaFHIckks0AviU81Qc91KKs=;
        b=e7LJbWzXLCuWedqjvI5ydJ2stCtieu6T9nS0X2Z2XF1+hXLOERf0REW678SVLmTByf
         /KpoBrysIy6bH9ANZcG8c3oIefq4OOZdzYwUW/Hx6z6ZzcPJ6MKk/m01+u/1jayMf0n1
         J2Yb+7rQOJAifWCWTnmJ4kUIf4Xkx0uPWSDB0dRgQcV6iEydsv3upnUr04u1av3QxYKr
         Bp5FiYV4ab/2n/IR81zIlZ0p7RnBOUVGw4x2JBLaZdnAJLZ5KS0rp52l8MZtUqADo9UN
         mU7V24Xf1Sb7ebVUWeQQXyZcvtg9KJPohNXC2l1NaGFTMVoAi0s2yE3CYR4SOh/0Hnt5
         CnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vnT/tPVrq2N2FYMYgZtTYaFHIckks0AviU81Qc91KKs=;
        b=kkfnXsdl41kbQ6LLr8OReOlcizAU6Hns6F49CAHc1kviauDCOEa2KZeZAP0zwNw5/8
         E0CGaIJgauZKJ4MDDnDsx+q4kQxbMkhmT67LBI+8llCpjqDiRwjnJ0TT+NWPmhTyWAkJ
         OTTPKubdNku/GfTQnQB/Iav7KGn3aqpgyCvt/AUaw6Hc3DYiZOdYBLx3pgwm4L6RFPGt
         rRqLrHJfYbwAcuNFcEJ2c1jzn8VbX9/ihwDGhYfylUGNUYdtl+7l3vAuhGMsxeDghm/Z
         EqxMl9LR3ewpmRAWkkWYKpChxfbV88R/qqPf35GmKDUEljJ08+02CGeMEwV7gMW2CWo2
         NxIA==
X-Gm-Message-State: AOAM530Pcc5sbfWE+zkQvwNC4yVfmQQapQ/nadbsIV6cHp2kzGgJlTSh
        3GiIVFtYfYCfjzw+Hk/rHGo=
X-Google-Smtp-Source: ABdhPJyNXoF7M7zDUTyKW48WK9Rf71RnICejRsTbBIzFiJxN3s8CoHQZP6272kqsV94+tQ9HPAT6nA==
X-Received: by 2002:adf:f344:: with SMTP id e4mr24467434wrp.25.1607890848889;
        Sun, 13 Dec 2020 12:20:48 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id j15sm28136891wrr.85.2020.12.13.12.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:48 -0800 (PST)
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
Subject: [PULL 12/26] target/mips: Introduce cpu_supports_isa() taking CPUMIPSState argument
Date:   Sun, 13 Dec 2020 21:19:32 +0100
Message-Id: <20201213201946.236123-13-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce cpu_supports_isa() which takes a CPUMIPSState
argument, more useful at runtime when the CPU is created
(no need to call the extensive object_class_by_name()).

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201207215257.4004222-3-f4bug@amsat.org>
---
 target/mips/cpu.h | 1 +
 target/mips/cpu.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 9c65c87bf99..e8bca75f237 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1287,6 +1287,7 @@ int cpu_mips_signal_handler(int host_signum, void *pinfo, void *puc);
 #define CPU_RESOLVING_TYPE TYPE_MIPS_CPU
 
 bool cpu_type_supports_cps_smp(const char *cpu_type);
+bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask);
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
 void cpu_set_exception_base(int vp_index, target_ulong address);
 
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 76d50b00b42..687e2680dd1 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -310,3 +310,8 @@ MIPSCPU *mips_cpu_create_with_clock(const char *cpu_type, Clock *cpu_refclk)
 
     return MIPS_CPU(cpu);
 }
+
+bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask)
+{
+    return (env->cpu_model->insn_flags & isa_mask) != 0;
+}
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1888A2D906C
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405251AbgLMUVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405038AbgLMUVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:51 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A63C061248
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:09 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q75so13417277wme.2
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H63X5j82a+LliFWq3Jbhu57DqrlxgL6DTtMOErZtbQQ=;
        b=lPbs7U1Oj6rFYBbgUiPOqTZ6521oG6m+tJxriuzaHqVF5erscvscVQ3dhMqHQsbHNQ
         5r9lEXG2Gscm2RVAf9pZE28wmVUPfVz1xp/azb5nsQ+p8xRdcz+/rFA5qDhVfAa3RqV4
         moCXUB4u6iiAHyqx3vEkswuoqCZJ8b4afHlsipDajERjcJBYzGwLIQ9hINcsUjMtS9Oy
         xp7SflzOtoo6X2jQA+ewdqeXJvIXeZnC8PtpfnS+k6j6Cnd8mXs03HgnrF2P4Nx9nALF
         D/D8YdWZxqKzUbigIhvS9SQBnkXcnFZ/0Xr5dUbBbgMSxPsXAcwf2RFJvxZ3CJKe8XSI
         AeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=H63X5j82a+LliFWq3Jbhu57DqrlxgL6DTtMOErZtbQQ=;
        b=PtZcPUFRIpRZMMw9uQmY4t+ge/fx4HXHAxST0SWibJQ25UCGxd6laSPMAGjslQ785S
         HXlYIBchDI7FS8DKvJ+YUg5/AgwXQksLCzY94cXeVda+bQ6rt1ftk45+tkO7VY3XLacS
         QT82apXEGM+isUx6eGrTHxjW9UcmiicSeeLHpN7NotBlGyeRBc1lj8LLjD7vK7IqRu/U
         0PYVLTmBpZDCb5RT6zZuVqtgCsoCcTAy7O8rR1Uh5/mn9UmJ7fe26H41hUi17NUjyjmj
         UgiZ167lrTWJ9cZA3GMbQ8ppr4cJ7Cl7r+HBebeoKVrnAHYo2UPlOTzcjk6b/5CoWV7L
         Vrjg==
X-Gm-Message-State: AOAM5321aipXz7u5M92e1/O6v/kv5BW8YtIhfnThjIEI2+pd5YtXLZXo
        QOqkePAoVacv5/4YfgTgXwk=
X-Google-Smtp-Source: ABdhPJz3/rQrsUemKBe0Gm+tyYr3IRJvrRwSyn2Alp0P+Zr8a+YhxOpvSZRX/WsAXlj7ubTDzVcY9g==
X-Received: by 2002:a1c:6383:: with SMTP id x125mr24420960wmb.46.1607890868670;
        Sun, 13 Dec 2020 12:21:08 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id q73sm28249910wme.44.2020.12.13.12.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:08 -0800 (PST)
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
Subject: [PULL 16/26] target/mips: Remove mips_def_t unused argument from mvp_init()
Date:   Sun, 13 Dec 2020 21:19:36 +0100
Message-Id: <20201213201946.236123-17-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mvp_init() doesn't require any CPU definition (beside the
information accessible via CPUMIPSState). Remove the unused
argument.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201204222622.2743175-2-f4bug@amsat.org>
---
 target/mips/translate.c          | 2 +-
 target/mips/translate_init.c.inc | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index e87f472a8d1..f218997f049 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31763,7 +31763,7 @@ void cpu_mips_realize_env(CPUMIPSState *env)
     mmu_init(env, env->cpu_model);
 #endif
     fpu_init(env, env->cpu_model);
-    mvp_init(env, env->cpu_model);
+    mvp_init(env);
 }
 
 bool cpu_type_supports_cps_smp(const char *cpu_type)
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 79f75ed863c..5a926bc6df3 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -989,7 +989,7 @@ static void fpu_init (CPUMIPSState *env, const mips_def_t *def)
     memcpy(&env->active_fpu, &env->fpus[0], sizeof(env->active_fpu));
 }
 
-static void mvp_init (CPUMIPSState *env, const mips_def_t *def)
+static void mvp_init(CPUMIPSState *env)
 {
     env->mvp = g_malloc0(sizeof(CPUMIPSMVPContext));
 
-- 
2.26.2


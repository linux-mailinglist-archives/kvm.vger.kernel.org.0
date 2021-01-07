Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83972EE86A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbhAGWYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbhAGWYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:37 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A528C0612A0
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:20 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w5so7085236wrm.11
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H9zOVt5mC6BKrn8/aJIajQg1rLT3CbXMbjoqCH1psww=;
        b=beBwsrVB1OdeBJyHJfBZqSSkiXc2Ue4xXXcXCdc0Jq1ATjpysiX0D7pLfbYYgs9p94
         hzHmgbY8uphkM+OngIndbv618FCoFRiRQiGsaEbwCy8vo2/EblQvr/e876PpdWqGDr2P
         g0ZFsGLnVB0GURPU9O5ZweBRIQ97Tnuscuroddyz5MAR2HH4tb5vgbAWK+RLVWUihMJr
         FDiMccnI/iLbgv+VDCTgO1O47+aOCVltiBppBQn7Vx8qDI9vWTjpe/tXqqcvzAmj3maa
         pQQVd3VRhUjkIC13xujo2SqAmmnADXXIAquaq+TJ5wmyRWfdN+5A8b96KQ/eZv46wPUA
         a/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=H9zOVt5mC6BKrn8/aJIajQg1rLT3CbXMbjoqCH1psww=;
        b=h4fqvY5uDkHllpwO+wIiIHG0jCrOgSZNPdC0OWfwRmygFmF0NV1pXnqAltIvl+BP13
         FP1BISDLz7eQ4PSs7hYbHXk177kbmMrchkD8gJVkE54pYK5Nm2ZsXHKifX6CM9upsEZ4
         uABrpNRo+20C0XVDEdjrdLKpQ6wlM0Vlgo/InEE+0VxMHx0bONjTQFxIwY4WNrNahBjv
         sQTrwGz3lFWDViuZe4XdUvG1IrgMJBOnsL93crX7gGRErBGdP97hz7EW/Q2hOP9g7BFM
         9tZ1UARP4Ivq4Jgx9Iw4eAnSTH/Z0JDiW8xj8CEiSKCkeGaC4IMPrm0UJm6r3JsrVIGD
         8pjQ==
X-Gm-Message-State: AOAM530TUgYRoUKvCu8DuDbTorMRLz+KlK4KsTdJCIpyMHHB7rLxbGH4
        MQZsYwHa3YUtQyaXSN1O3V4=
X-Google-Smtp-Source: ABdhPJzWKwcEhW2PD8mOSa2fKu6MVLKZYReyP+7sdgmKhxVPAKNtE8mLuWtkAEUYiNitLhmQDoaWQg==
X-Received: by 2002:a05:6000:144f:: with SMTP id v15mr692233wrx.138.1610058259241;
        Thu, 07 Jan 2021 14:24:19 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id s205sm9587176wmf.46.2021.01.07.14.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:18 -0800 (PST)
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
Subject: [PULL 16/66] target/mips/mips-defs: Rename ISA_MIPS32R3 as ISA_MIPS_R3
Date:   Thu,  7 Jan 2021 23:22:03 +0100
Message-Id: <20210107222253.20382-17-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS ISA release 3 is common to 32/64-bit CPUs.

To avoid holes in the insn_flags type, update the
definition with the next available bit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-14-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index d1eeb69dfd7..12ff2b3280c 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -18,7 +18,7 @@
 #define ISA_MIPS5         0x0000000000000010ULL
 #define ISA_MIPS_R1       0x0000000000000020ULL
 #define ISA_MIPS_R2       0x0000000000000040ULL
-#define ISA_MIPS32R3      0x0000000000000200ULL
+#define ISA_MIPS_R3       0x0000000000000080ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
 #define ISA_NANOMIPS32    0x0000000000008000ULL
@@ -77,7 +77,7 @@
 #define CPU_MIPS64R2    (CPU_MIPS64R1 | CPU_MIPS32R2)
 
 /* MIPS Technologies "Release 3" */
-#define CPU_MIPS32R3    (CPU_MIPS32R2 | ISA_MIPS32R3)
+#define CPU_MIPS32R3    (CPU_MIPS32R2 | ISA_MIPS_R3)
 #define CPU_MIPS64R3    (CPU_MIPS64R2 | CPU_MIPS32R3)
 
 /* MIPS Technologies "Release 5" */
-- 
2.26.2


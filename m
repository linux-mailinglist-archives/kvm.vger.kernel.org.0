Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E82EE85A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbhAGWXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:23:42 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A72AC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:02 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t30so7148942wrb.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fW0mwAJFoILMKm9wYoK9XOOf/CSaqeng2a0yxdXuwlk=;
        b=AH6CvUU40CZjmLEhU77ijgxJ0hPcSMVJ2GzOlTsKVCyXCFn5YpBwssc/U0Qs/dA6hn
         G0d9aoDgsdMQhvNtJj+FOu1D6AoghLx7jVtVuZrB3juWVTd/6kOmcUQlTsoVh8QCwF8/
         dK9th7CfpxglazqSCFZEEGkjpywpTrx5RlstQS5rsnMWHGN9VwYfJHutIBLLyU4g1gVN
         XLNCObf8hgaAVGAsdzAKclkUfGIUc80m3ZOe2pMrJ6+Idto37dbwYx7qd1okKyi8EXNv
         UKxvhPOXw+lyHe2I+u9lYHLl7HNcCZpvhT995xNTOOryONIvDtZ4aTEFrBCVbnTuG9kn
         e5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fW0mwAJFoILMKm9wYoK9XOOf/CSaqeng2a0yxdXuwlk=;
        b=TSqx1Aj6S3HHIY+G8K2fbyHzT0nddS8q7TQsNIVkNGhISXn7kxcDvnnMnfc/W8aOGJ
         JoUI+6jz9pL09Mb+HlPllxNE3hCOnZ1HXjY8QxOdAX1X6J2vEVHJPPYVdNm8w52sCr9m
         /V4xPLOaqP8jdedJg8sqkBfRZ7WbodZ9UKk/nu658wTXDDwgs2THeUeyk8tUqjm+iy2k
         TA9nlKrYwTJqmWUeeUoCa2BWQwsVSaRoR1Byyt0tWvdLzDKNfLzZwUu7fuDSqTSsiaKw
         Kb8hK4aMRfuxBbMm2wvTqLPkJS7Yb6DQuVg8/GLSD7pMhMaANV6LWZ3azPYtaYWBXLL4
         zoYA==
X-Gm-Message-State: AOAM53121l2S5h+N+GH+Uhj7jOCv+qr366omOssrD/OGh8pkzx1nyn5q
        BVBCPsZ+bEJ33CT9vbG2P5s=
X-Google-Smtp-Source: ABdhPJxClHvusZYqPYf/w2zXO0+Cg3NpWMcgUHjWirXKV2TwoH7uxBpXmD1ODQrmjp71U9B2+y3JdQ==
X-Received: by 2002:adf:80ae:: with SMTP id 43mr705077wrl.50.1610058180999;
        Thu, 07 Jan 2021 14:23:00 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id s20sm8990109wmj.46.2021.01.07.14.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:00 -0800 (PST)
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
Subject: [PULL 01/66] target/mips: Add CP0 Config0 register definitions for MIPS3 ISA
Date:   Thu,  7 Jan 2021 23:21:48 +0100
Message-Id: <20210107222253.20382-2-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS3 and MIPS32/64 ISA use different definitions
for the CP0 Config0 register.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201201132817.2863301-2-f4bug@amsat.org>
---
 target/mips/cpu.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 4cbc31c3e8d..0086f95ea2a 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -828,7 +828,7 @@ struct CPUMIPSState {
 #define CP0EBase_WG 11
     target_ulong CP0_CMGCRBase;
 /*
- * CP0 Register 16
+ * CP0 Register 16 (after Release 1)
  */
     int32_t CP0_Config0;
 #define CP0C0_M    31
@@ -845,6 +845,14 @@ struct CPUMIPSState {
 #define CP0C0_VI   3
 #define CP0C0_K0   0     /*  2..0  */
 #define CP0C0_AR_LENGTH 3
+/*
+ * CP0 Register 16 (before Release 1)
+ */
+#define CP0C0_Impl 16    /* 24..16 */
+#define CP0C0_IC   9     /* 11..9 */
+#define CP0C0_DC   6     /*  8..6 */
+#define CP0C0_IB   5
+#define CP0C0_DB   4
     int32_t CP0_Config1;
 #define CP0C1_M    31
 #define CP0C1_MMU  25    /* 30..25 */
-- 
2.26.2


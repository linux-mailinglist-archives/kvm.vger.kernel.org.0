Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED02EE865
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbhAGWYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbhAGWYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:22 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CADC0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:54 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t16so7141852wra.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sk0GjPOwaKw1OtxDzWJCyQVWdlOOm+hBJhH4fWESj5c=;
        b=Ss0ycgCC5JZfXAux5JSOCrB+Q7Y5oqbTi5F+SEeySab4XeeCqTXtN/8qp6l0WDGpKd
         KXuq5mhizBunxtgT+Er8zJ1orH4OQwEjnRAk2iPfdq+HWF7BRrXxXEZJOQKKu6iol899
         WZWTnN2JizHSe6SSJXtNJwngopejB7ndJUtWMqgWW536xbtkVaLgmVR2+1A6hd/R0zax
         LTrpT5inlf3doNGpekfnDOZaEVZf056NLjMbj8Yh7KLIDk5Ruk6RRKy4s0l8/jARVSsj
         YwVP0MIx/OOp708ZCZvMlKYFEzHGb55D5mRGwJueAFt0Ph20MC/Sq7arfh8KOC4Pu79+
         Oytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Sk0GjPOwaKw1OtxDzWJCyQVWdlOOm+hBJhH4fWESj5c=;
        b=Yy4tN89FcbB1iEkm+luYn1J4IQPS5kxK/ylaosUf2VcgUvDywVRXvB0IVxaRlZy2+F
         1Su9IfEvYiFVP5kaDWsDXrYhLuJgIgfpvO5YQSyjYtZFqQ/BlkDiY5bUlDdQ2c4MlcTC
         xu9DLT0i5nQyrHMhXi3Q3DgST6+V5zEPBNuJSZmr6df5LPdAIgRS1bxANKeLg62nU342
         xciqHLUpDolaRvGQeWx/2GPUs8u04gA/CFJpXa4zY2V0D8fmuBqq7c816rtfLC1sytMj
         GKmFKrJKagSavBVXBa+4ltOSP2o+du3lfhA0UbmmlxyksUx8NHKb6lERIJtzuc4G2UGq
         l90A==
X-Gm-Message-State: AOAM532MCiz/6COEbqsS4IznRe0StpjUDSTQZSFMf7SFPi9ZVKyG4mgb
        oYoAjpqJDYbkHKWNzYG9bwVzF3iC1Mw=
X-Google-Smtp-Source: ABdhPJxfMY/2VlzrtrNQv5zadl7d7OP9CwGcm/sT/2JQXSTpWmw1iz3t3qwI+FOR73I7mUwUdKKAgA==
X-Received: by 2002:adf:e688:: with SMTP id r8mr687398wrm.20.1610058233425;
        Thu, 07 Jan 2021 14:23:53 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id j9sm9990483wrm.14.2021.01.07.14.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:52 -0800 (PST)
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
Subject: [PULL 11/66] target/mips/mips-defs: Use ISA_MIPS32R3 definition to check Release 3
Date:   Thu,  7 Jan 2021 23:21:58 +0100
Message-Id: <20210107222253.20382-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the single ISA_MIPS32R3 definition to check if the Release 3
ISA is supported, whether the CPU support 32/64-bit.

For now we keep '32' in the definition name, we will rename it
as ISA_MIPS_R3 in few commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-9-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index b36b59c12d3..ccdde0b4a43 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -19,7 +19,6 @@
 #define ISA_MIPS32        0x0000000000000020ULL
 #define ISA_MIPS32R2      0x0000000000000040ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
-#define ISA_MIPS64R3      0x0000000000000400ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
 #define ISA_MIPS64R5      0x0000000000001000ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
@@ -81,7 +80,7 @@
 
 /* MIPS Technologies "Release 3" */
 #define CPU_MIPS32R3    (CPU_MIPS32R2 | ISA_MIPS32R3)
-#define CPU_MIPS64R3    (CPU_MIPS64R2 | CPU_MIPS32R3 | ISA_MIPS64R3)
+#define CPU_MIPS64R3    (CPU_MIPS64R2 | CPU_MIPS32R3)
 
 /* MIPS Technologies "Release 5" */
 #define CPU_MIPS32R5    (CPU_MIPS32R3 | ISA_MIPS32R5)
-- 
2.26.2


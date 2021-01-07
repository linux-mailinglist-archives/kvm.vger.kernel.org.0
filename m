Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB52EE8A3
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbhAGW21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbhAGW21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:27 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB3C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:11 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r3so7146785wrt.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlfAUa3yzIuzGTG6Nw//8ZjnEqUFLfQ9i/y2dfj6avA=;
        b=NyodmDecPOGhzzmkDVaoq/JjSTYPPVIBfksj1Br9WTnPBXGPZyhJ5iLWjMZKKHtYQP
         z13kr8wLAzYahuf3gn4wmt/WlnpWwIYxr+rmt7ZO5XpCIWQhXcQMmqS6V785bD09gVlx
         LGlUSCOQIHEkIheNYuSSGsj2VQrmeDlRRiXll6d2Gmn2IGsF6OFJVEcS+KsJ+AhCNA4+
         hidp2Py9Xrdk/P3eOJ9xcUBTo+AvW/8g60D+PDn300ERGn/u/Jvk38u39gfoPubMO4Ql
         DNx+XG/7my7jL5StC0YkkhGgmO4ccwzg8QaZRQyMi7Qw39P4iMg2ZiQWo9vOVP7b7Gcw
         Zjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=jlfAUa3yzIuzGTG6Nw//8ZjnEqUFLfQ9i/y2dfj6avA=;
        b=mt6AqCLIrGfsUJB7cqK83T1PkF9gHB+O1Ax5p6T8JmIimzsGAd/i+EvV4GmJNE7svd
         JR/ZaCinugNn0OF8FNnp5xU6cUJOhSsVf4bf8uilA0XECXjrwANKIc/sFJ++u+AyEEme
         xCmob0vnkdGnNlxwCPaBwOsULBczYYNLDa2yagp3S8jU+BoIBb6QgXhGVgMFMiE0ALVH
         z2xjmzhVPv0mP45zLDqkqZnuYAsbiZCnivn0wJBXyS9pCSY1B1DDiQbPWrEhDgi0c7m2
         f6qaNUI+pwla/1C8GhFjmVoSDCNqBp/sXfSJWeznlaTnYY3EWGXaNJTm4z7xWVg2qBrx
         qm/g==
X-Gm-Message-State: AOAM533Asf7P1J8bTlmDGVD+GHBvn+mn6o3s0Um++8SBYzw3XPdfGvV8
        rkwKrUF9H9uH7bqPVn0Iblo=
X-Google-Smtp-Source: ABdhPJxQ2uYbbyM0jNrN7Wau7cpOMcgEfAdSDonzO/lX6iY/F9AduoIVoTwOtu2AvYXchXHB30BTvw==
X-Received: by 2002:adf:9d82:: with SMTP id p2mr691905wre.330.1610058490365;
        Thu, 07 Jan 2021 14:28:10 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id d191sm9498068wmd.24.2021.01.07.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:09 -0800 (PST)
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
Subject: [PULL 61/66] target/mips: Convert Rel6 LWL/LWR/SWL/SWR opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:48 +0100
Message-Id: <20210107222253.20382-62-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LWL/LWR/SWL/SWR opcodes have been removed from the Release 6.

Add a single decodetree entry for the opcodes, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-10-f4bug@amsat.org>
---
 target/mips/mips32r6.decode | 5 +++++
 target/mips/translate.c     | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index e3b3934539a..89a0085fafd 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -20,5 +20,10 @@ REMOVED             010011 ----- ----- ----- ----- ------   # COP1X (COP3)
 
 REMOVED             011100 ----- ----- ----- ----- ------   # SPECIAL2
 
+REMOVED             100010 ----- ----- ----------------     # LWL
+REMOVED             100110 ----- ----- ----------------     # LWR
+REMOVED             101010 ----- ----- ----------------     # SWL
+REMOVED             101110 ----- ----- ----------------     # SWR
+
 REMOVED             101111 ----- ----- ----------------     # CACHE
 REMOVED             110011 ----- ----- ----------------     # PREF
diff --git a/target/mips/translate.c b/target/mips/translate.c
index e8389738c57..0d729293f6b 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28589,11 +28589,10 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* Fallthrough */
     case OPC_LWL:
     case OPC_LWR:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
-         /* Fallthrough */
     case OPC_LB:
     case OPC_LH:
     case OPC_LW:
@@ -28604,8 +28603,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
          break;
     case OPC_SWL:
     case OPC_SWR:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
-        /* fall through */
     case OPC_SB:
     case OPC_SH:
     case OPC_SW:
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA12EE8B1
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbhAGW3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbhAGW3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:29:23 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCD0C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i9so7148169wrc.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d4Gj//OkD5jKhI/4P4VQprZ7+6fnm/3amg1m9obP+eI=;
        b=btSc1YFi2LkwM2+EAdgZ56w6Qe52rwg/g+fmeS/hD3F68F2fEFYUhlDqUxB33dh1gj
         xOYJ4UZ8CN/NTQcanjgvNXqtwdaLTVhDW8Sav3kCpJ7B0+ZIUqVWlQBhH0fEe8wc9OEV
         kK1dVmMJcIBi1TumZ7MxLX9shUchuLu0bnXJ4yeimJeC4gFUQK6rqLNVvsRForqedVnL
         0d0CHDhdUFMjAaOtrL6QL2447KxIpU6h+WvZ6NdCoSVPcGrZK1u/EAqPzOJK8OHe4CWU
         woZXW1JsNZG8HEY2OaN964q8Y0N1/EIGnEX2OyllI3J+E99MYPhjmAi3xHJwUnt5A7mB
         8Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=d4Gj//OkD5jKhI/4P4VQprZ7+6fnm/3amg1m9obP+eI=;
        b=SBorK1soHwZZdIDuyQdjHYLGj+zTpTK8W1YLXLrB5vPKXFdQjO8XVyKqySLeS5RZrF
         R8T3KK0RRvWY2YgUrQNu9+uQ7DGZjYSbJugJEZl6bx8UfY90zlztKlHcAJQVeMrpVlv1
         BTcGscUC7So+VpRyu9gppkMLD9WHOY+A2oJ6poKVGNXEXN+ysDfP7hNTWqhNGfB5AwsD
         Id+0dwZrKObfeBEzexgbFgv/xYSTKsYlycBC+8U35JK3sWH2flAlrK5C+zBmfnAphcFZ
         l80OAy5lzkQXscRmVA3/gO+67OBPuFwSPpWdgpi8aHWuWk/wPy6utPjRE1WoUtyehIf5
         gE1A==
X-Gm-Message-State: AOAM530tI/G8ZO/SY673O9JZBJ8qIFptn9b2cmU3MNMNlTbJA/pYvQXV
        aL2T+TSB7BygCtyzdOog7Rk=
X-Google-Smtp-Source: ABdhPJyeb/1d59aZ9MSRmZedPlgjNOORpFfUrYpwLVOmJ2MAgpomcFip6GYr8+4/7KkvOopf0mTobA==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr677700wrv.384.1610058510668;
        Thu, 07 Jan 2021 14:28:30 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c6sm10851358wrh.7.2021.01.07.14.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:30 -0800 (PST)
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
Subject: [PULL 65/66] target/mips: Convert Rel6 LL/SC opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:52 +0100
Message-Id: <20210107222253.20382-66-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LL/SC opcodes have been removed from the Release 6.

Add a single decodetree entry for the opcodes, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-14-f4bug@amsat.org>
---
 target/mips/mips32r6.decode | 2 ++
 target/mips/translate.c     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index 3ec50704cf2..489c20aa4e9 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -31,4 +31,6 @@ REMOVED             101010 ----- ----- ----------------     # SWL
 REMOVED             101110 ----- ----- ----------------     # SWR
 
 REMOVED             101111 ----- ----- ----------------     # CACHE
+REMOVED             110000 ----- ----- ----------------     # LL
 REMOVED             110011 ----- ----- ----------------     # PREF
+REMOVED             111000 ----- ----- ----------------     # SC
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 9f717aab287..b5b7706a7c2 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28585,7 +28585,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* Fallthrough */
     case OPC_LWL:
     case OPC_LWR:
@@ -28606,7 +28605,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
          break;
     case OPC_SC:
         check_insn(ctx, ISA_MIPS2);
-         check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
-- 
2.26.2


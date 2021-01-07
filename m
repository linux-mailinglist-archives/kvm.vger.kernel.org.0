Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1942EE8A9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbhAGW2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbhAGW2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:47 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52FEC0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:06 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d26so7091732wrb.12
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3otSOREwspFZTGVmnwaLoO3N9uKJi1c7L45V7c+1Mcw=;
        b=HT9D+afyPYopDhOH8xG1yMnVMl2R5yK8GjRTe7gP0CD+O/KURKNF3XELfGkuu+BszE
         HXttADITpCa74d+4/2TzIJtS27kpebkg7PEvXIAJvgCmsm3rULxeNFPDN9IkIc2OKA5l
         vu99Vo01PsCL3DPJEruDzh6k9Rdu08Dy7NApOWJ7HpvBBFUIdj/niEN8v6ySrjhScUV2
         udCkWMHIyteQ3ewxG0k8s/F1R3V5BnO9/v5ZawlqXZrCWdyDfnVZbJ30/7WRxbFMnNSl
         qTcj3qmfoi3g16iLrF5bfmqAXcMKfQrwXjOizVJJ/vV5t8EgF64X9j/iQm38zOg+cNcl
         NJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3otSOREwspFZTGVmnwaLoO3N9uKJi1c7L45V7c+1Mcw=;
        b=lnuT3XLjddpUtNf8L8H+8l8sk68h120rno8pfNLrmFsk9/D8ILS7naqX/+Eiw/gmiW
         GZGNjoT9eGgsSqBHUj/L/F8YKmo/kOVQzz53PmiGNAsAYH2VEvt1XA9r67M/M+EBPl9Q
         +eoAoL05ldf01g2/vgJT0BMecY2appJF/9Alq7UDYRha60vhPDUD3zkpGntODnFMMwY5
         g6GsMCNWJfbCMIxKPu5gqcBOUaeHQhpMUFjDwTfBbQWzOWGHyPrHEfnri6iBQE50tpKZ
         Zn8TsvWz64lYp/4hnmUqNHDRnyrelAMKY99Um5XC1AzF+bcyaNZy3CyoRaUbMjKZxd+N
         D29w==
X-Gm-Message-State: AOAM531R7RaU1VdobjOlZS5/hGy0h60B7lWubrGAmqoNMj1l7j2VkXp4
        gaSnQLWb4+tFUsGxaVgT3xw=
X-Google-Smtp-Source: ABdhPJxtW3I/nOKsLXx6mQmay0VzhVUHJw1O3mSe8PkgVEl0dPlY1zMTbBvNRkTAatGVNp2b5SssbA==
X-Received: by 2002:a5d:4905:: with SMTP id x5mr667882wrq.75.1610058485483;
        Thu, 07 Jan 2021 14:28:05 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id r20sm9154498wmh.15.2021.01.07.14.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:04 -0800 (PST)
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
Subject: [PULL 60/66] target/mips: Convert Rel6 CACHE/PREF opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:47 +0100
Message-Id: <20210107222253.20382-61-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CACHE/PREF opcodes have been removed from the Release 6.

Add a single decodetree entry for the opcodes, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-9-f4bug@amsat.org>
---
 target/mips/mips32r6.decode | 3 +++
 target/mips/translate.c     | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index 7b12a1bff25..e3b3934539a 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -19,3 +19,6 @@ LSA                 000000 ..... ..... ..... 000 .. 000101  @lsa
 REMOVED             010011 ----- ----- ----- ----- ------   # COP1X (COP3)
 
 REMOVED             011100 ----- ----- ----- ----- ------   # SPECIAL2
+
+REMOVED             101111 ----- ----- ----------------     # CACHE
+REMOVED             110011 ----- ----- ----------------     # PREF
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 52397bce84b..e8389738c57 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28620,7 +28620,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         gen_st_cond(ctx, rt, rs, imm, MO_TESL, false);
         break;
     case OPC_CACHE:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         check_cp0_enabled(ctx);
         check_insn(ctx, ISA_MIPS3 | ISA_MIPS_R1);
         if (ctx->hflags & MIPS_HFLAG_ITC_CACHE) {
@@ -28629,7 +28628,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         /* Treat as NOP. */
         break;
     case OPC_PREF:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->insn_flags & INSN_R5900) {
             /* Treat as NOP. */
         } else {
-- 
2.26.2


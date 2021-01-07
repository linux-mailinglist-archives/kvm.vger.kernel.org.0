Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5D92EE8AE
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbhAGW25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbhAGW25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:57 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8640DC0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:16 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 190so6381522wmz.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yq3mxfTZKdf/fjKj8fFk3v2tF8q6uI5ug94fHU9oH8s=;
        b=Gd82pxS4+zzvVBDBN4HENJ44Mz7QxhZU8UloC1P6jP13F72cJ1g34MUWYAWomwmLeN
         2/A/ouAET0qQIZ38QJbEmi1RMN3rf1WPjaSCpzvlBzTVdPI3Z4/TbI3S1LLx54yFTwFp
         5ti2dy+nF9HmEr8DCSO4RtzQmHPOEF8iby5YeukNi9AlSJqS+3pKPdqGHnVpHNKOzOus
         P9QwZVrNPwz2VNdmmyINVxIEiQIyHv/dewREky1tgJyp3NaCaXh89mYxWSEAXQIAFnVw
         JQ2WyK9sDprS+omnTUjYMY3S0BevUtsCalHviNOwMRPGdurcSm8BPgTOGQzRhHiE/HLO
         P0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Yq3mxfTZKdf/fjKj8fFk3v2tF8q6uI5ug94fHU9oH8s=;
        b=Vyofm2nY6sV9+dvi+C8JeBLo3/6pmDogu9BKZlVXU3euXzjayY8NtJ9Siew3C24GFr
         2w5tIuN+4q1mqFwSkXuChYPndwbMc4N4Cn85qb9MwNCA6UGkZwf9YqieqxuFI20VrPk8
         V++n1GH5pOGpg6azN9KcHgw5Djv3OEVGMx+X266Soni0DTyZwN/rDM0fB/9BBKNY2CW8
         DG8GPgwLRaq3mw+MVf4lo4rRrHK7M1RxEq//jcZRs4es432kRRMopVjrKK9YTmaCLQD0
         MsUcpMiv31KJhEvxYnNxGsS7M1SDpaJm1s249Lw15UY8KlBXu2SmTj+8QVqrOamsB23I
         Ok2Q==
X-Gm-Message-State: AOAM531JhaoU37qhIN8QjrEG92q6RMX9NRaCbirawqIlBD+3q3KgNprc
        dnuuER3AkzUFQ21/btH93U0=
X-Google-Smtp-Source: ABdhPJxD8yDTAfSjw1MvU0PUYHwY/6OzpFw719ayDQklkKKFRhWW9uo0SP6oCkINV8b+kAq1EiW3TA==
X-Received: by 2002:a7b:c184:: with SMTP id y4mr534072wmi.92.1610058495363;
        Thu, 07 Jan 2021 14:28:15 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id m14sm10311543wrh.94.2021.01.07.14.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:14 -0800 (PST)
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
Subject: [PULL 62/66] target/mips: Convert Rel6 LWLE/LWRE/SWLE/SWRE opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:49 +0100
Message-Id: <20210107222253.20382-63-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LWLE/LWRE/SWLE/SWRE (EVA) opcodes have been removed from
the Release 6. Add a single decodetree entry for the opcodes,
triggering Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-11-f4bug@amsat.org>
---
 target/mips/mips32r6.decode | 5 +++++
 target/mips/translate.c     | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index 89a0085fafd..3ec50704cf2 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -20,6 +20,11 @@ REMOVED             010011 ----- ----- ----- ----- ------   # COP1X (COP3)
 
 REMOVED             011100 ----- ----- ----- ----- ------   # SPECIAL2
 
+REMOVED             011111 ----- ----- ----------  011001   # LWLE
+REMOVED             011111 ----- ----- ----------  011010   # LWRE
+REMOVED             011111 ----- ----- ----------  100001   # SWLE
+REMOVED             011111 ----- ----- ----------  100010   # SWRE
+
 REMOVED             100010 ----- ----- ----------------     # LWL
 REMOVED             100110 ----- ----- ----------------     # LWR
 REMOVED             101010 ----- ----- ----------------     # SWL
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 0d729293f6b..73efbd24585 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28122,8 +28122,6 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
         switch (op1) {
         case OPC_LWLE:
         case OPC_LWRE:
-            check_insn_opc_removed(ctx, ISA_MIPS_R6);
-            /* fall through */
         case OPC_LBUE:
         case OPC_LHUE:
         case OPC_LBE:
@@ -28135,8 +28133,6 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
             return;
         case OPC_SWLE:
         case OPC_SWRE:
-            check_insn_opc_removed(ctx, ISA_MIPS_R6);
-            /* fall through */
         case OPC_SBE:
         case OPC_SHE:
         case OPC_SWE:
-- 
2.26.2


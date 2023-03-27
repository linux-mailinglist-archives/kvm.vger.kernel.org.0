Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1B6CAAF7
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjC0Qty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjC0Qtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:49:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51806213C
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:49:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f22so4884303plr.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935792;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=DrjYNVn/XrUZ7De3DWAyMEfNXt5xR47EPuDuqzl54H8yLyvQsQzec7yBsdxHTqrCP2
         JDBpDsS7dK7v054WTSmiK6tn6IuLOUS87LAXTp81No+VOoTWnvGNLrk3iuQe+D1So8zc
         8QWdyHCxdJVPyiXG6Bx5mzYNkKe1tcjN/dfW84SvToC15fbtdUHGoFjvQ69cPc/rv56n
         t3gwGf/FZepjefg6ObDAbm+Qfgo09/EwadE/HXDWyBCxqqpP8UwcbWSeY1CU3DjMq581
         7IctosOFB2OILR3hIIN7xwmhSjG7vY5m7iJJ6L7mcbsnDJdO13ZwqBhh7vjhFrr13y4O
         Crdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935792;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZD7AFVtobxh1FGjEKQD2QW8IDIT5bzbSx/S1GQl+8U=;
        b=bJcLMt01lJqw8mf/HHsllfta5h7JEOd+vJKE2g3jRPYPbEt4nNhfUZPf0SHwl8tGF1
         Xv/e08ETPDaFIm4DuzC/R04ak8ChIXZO66JynyA2ri26mz6Y6Nk+kmvYSApn3DXH3Aif
         LMobPIoy46ZeZMf5fZ5RMtNn4LzQvUI2dVNlkIu36i12ZFqBX8B1QMqXi9X7mzSF5S6E
         NPHT1yDK9eS46IGTd5C03WOnCH7h/kNpLO0Zr3Y4kQkxlb/hbGfWzJjoWmhThdgc0UK9
         HV0irpIfm5+l6mXApjNgKClEN0djvMJw61l4y+OS+G16RdSlUZ1hbkXTeQ+SzOovS6us
         3I5Q==
X-Gm-Message-State: AO0yUKVf13Jeit7vOh6767Fh+uOo+Px5eopSlWQbIiWr5uu34p4S/+3J
        xMkpOg2GWG7FKzuOp8ddMSKH8g==
X-Google-Smtp-Source: AK7set+WEKuQejo7OWoTNvElULfoKX69nTqrkV5rQ/pJeuh4jTWt7crWI7OgztZP2pQiD///y2qCMg==
X-Received: by 2002:a05:6a20:2a10:b0:d3:5224:bbc2 with SMTP id e16-20020a056a202a1000b000d35224bbc2mr11795629pzh.42.1679935791866;
        Mon, 27 Mar 2023 09:49:51 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:49:51 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v17 01/20] riscv: Rename __switch_to_aux() -> fpu
Date:   Mon, 27 Mar 2023 16:49:21 +0000
Message-Id: <20230327164941.20491-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

The name of __switch_to_aux() is not clear and rename it with the
determine function: __switch_to_fpu(). Next we could add other regs'
switch.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/switch_to.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 60f8ca01d36e..4b96b13dee27 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -46,7 +46,7 @@ static inline void fstate_restore(struct task_struct *task,
 	}
 }
 
-static inline void __switch_to_aux(struct task_struct *prev,
+static inline void __switch_to_fpu(struct task_struct *prev,
 				   struct task_struct *next)
 {
 	struct pt_regs *regs;
@@ -66,7 +66,7 @@ static __always_inline bool has_fpu(void)
 static __always_inline bool has_fpu(void) { return false; }
 #define fstate_save(task, regs) do { } while (0)
 #define fstate_restore(task, regs) do { } while (0)
-#define __switch_to_aux(__prev, __next) do { } while (0)
+#define __switch_to_fpu(__prev, __next) do { } while (0)
 #endif
 
 extern struct task_struct *__switch_to(struct task_struct *,
@@ -77,7 +77,7 @@ do {							\
 	struct task_struct *__prev = (prev);		\
 	struct task_struct *__next = (next);		\
 	if (has_fpu())					\
-		__switch_to_aux(__prev, __next);	\
+		__switch_to_fpu(__prev, __next);	\
 	((last) = __switch_to(__prev, __next));		\
 } while (0)
 
-- 
2.17.1


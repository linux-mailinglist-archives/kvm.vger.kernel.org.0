Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F216C6BCE
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCWPCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjCWPCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:02:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1053298CA
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ja10so22561484plb.5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583674;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=WVySlEfxqDWV/IQZE+oLOQ0wO+duX+c8vFyXLiyJTO/x6njrE+NXSvUp4U7SbhlmAa
         e3vIJwBitYU7bQFELWAorOZWaW5Ygi61aiL6LAKJx3TKW7xvpiA3+or3+K+TiDyz09hm
         g+QyZzE/7LB+9xXQk7NZunq8TuIPP2iKcHm2RiHeMiAEKP7LL1QIEYhsg45Yp77co4uP
         YcRTK1ZEsYUfMs4g9mAyToSQLHgadRVMtO62rVhtzPwtgp/9qYO++Wv1sAOUBPh9RODK
         uCM5Y26DzOX7s3YDNZloU38f2UWvbFmt9NrBayRYHsiMxHTG/fCCWPbiXW2fy2H3mD3P
         SXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583674;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/srIeqtOeL8WlVYBrDSAnb/WyWsrKaiEJtMn58iONk=;
        b=skSzLe4X5kyajzCHrNUu/+gmkTUQprLywdQ+qPxkOzwRQ/vdZJIJ6ghvVK/z0PRPTD
         o6Wmn8EYOgkWUtBjOP0jt+qNycSNP3/IeYmcSNCPQrDUmgxEZSyoa9iOZf0H4jOSm8R+
         rGKCIz9bin1f6O00ubQ/MKcAlF2mwnZsRxixH7qgiMhTnhA983VXIrTZZD7xbp44emV4
         +PXJruyFL7ZeF2Ck+Fu4wu8DY7ML1SqotHiyzTYfBMFhwguzyJNGKQfkT4Xh7hway3RV
         c1OPAak57MvIgy3h3xtrA78EYNFvCaIUVhoX7ogbSBb9zxPrC38U+qqMmodOZrhsRtzZ
         7LNg==
X-Gm-Message-State: AO0yUKUxLZkpqmA+8GcCh1CYwMVBm8P3eunxieoIZWbIX4pESUIsjse7
        0ldVYHSXAUksDxDLFy6VAenxtQ==
X-Google-Smtp-Source: AK7set/L3cVGLRza2ds3tB3eAlc8YjsgRg8DqSZzrpSTVdPBTBMhw0vBkaTe8IhXbUtRRWsR0LQz6Q==
X-Received: by 2002:a17:902:ecc2:b0:1a1:e01e:7279 with SMTP id a2-20020a170902ecc200b001a1e01e7279mr9171143plh.4.1679583673757;
        Thu, 23 Mar 2023 08:01:13 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:01:13 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Guo Ren <guoren@kernel.org>
Subject: [PATCH -next v16 16/20] riscv: prevent stack corruption by reserving task_pt_regs(p) early
Date:   Thu, 23 Mar 2023 14:59:20 +0000
Message-Id: <20230323145924.4194-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Early function calls, such as setup_vm(), relocate_enable_mmu(),
soc_early_init() etc, are free to operate on stack. However,
PT_SIZE_ON_STACK bytes at the head of the kernel stack are purposedly
reserved for the placement of per-task register context pointed by
task_pt_regs(p). Those functions may corrupt task_pt_regs if we overlap
the $sp with it. In fact, we had accidentally corrupted sstatus.VS in some
tests, treating the kernel to save V context before V was actually
allocated, resulting in a kernel panic.

Thus, we should skip PT_SIZE_ON_STACK for $sp before making C function
calls from the top-level assembly.

Co-developed-by: ShihPo Hung <shihpo.hung@sifive.com>
Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/head.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index e16bb2185d55..11c3b94c4534 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -301,6 +301,7 @@ clear_bss_done:
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
 	XIP_FIXUP_OFFSET sp
+	addi sp, sp, -PT_SIZE_ON_STACK
 #ifdef CONFIG_BUILTIN_DTB
 	la a0, __dtb_start
 	XIP_FIXUP_OFFSET a0
@@ -318,6 +319,7 @@ clear_bss_done:
 	/* Restore C environment */
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
+	addi sp, sp, -PT_SIZE_ON_STACK
 
 #ifdef CONFIG_KASAN
 	call kasan_early_init
-- 
2.17.1


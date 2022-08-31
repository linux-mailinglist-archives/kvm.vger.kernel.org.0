Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF445A8510
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiHaSJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiHaSIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8567E3983;
        Wed, 31 Aug 2022 11:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5460661C19;
        Wed, 31 Aug 2022 18:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BF0C433D7;
        Wed, 31 Aug 2022 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969323;
        bh=RRltkuwJX7LP5kK/3k3rhHeIM5Hot3r7Dzu5sm7vQRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjEWyJtWNJyqF1sWOIQ+uxemOhBF9KufKpx8qD5bN+fkZAdqi4a7jrAo/HlErp4DX
         4JrXURA91d8hkInkWBE1es3vrtKJEag1lSCmaRnzz/itVcR4MM49ZWA6Sbm0vfsvkl
         LOHM5808le50a4zKPFn3IrO63brm4V6tnNWJi2O6bhA0pc5h0MhAMnuebmuyonXou+
         EVydrw1bfEdiLIKpA4cWmrqlj1kMnVUEf1psTVIEu7NzLvcHfSjXgazSbSDtAH45c1
         A0YVzkG7josdrwFMYuKygXDRDEu9f0kfHCgrnCQ2M2/cymSWDY1wcmJYpoREFT34mN
         xw6vWRBUCvd3A==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 3/5] riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Date:   Thu,  1 Sep 2022 01:59:18 +0800
Message-Id: <20220831175920.2806-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
References: <20220831175920.2806-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move POSIX CPU timer expiry and signal delivery into task context to
allow PREEMPT_RT setups to coexist with KVM.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 79e52441e18b..7a8134fd7ec9 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -104,6 +104,7 @@ config RISCV
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_STACKPROTECTOR
-- 
2.34.1


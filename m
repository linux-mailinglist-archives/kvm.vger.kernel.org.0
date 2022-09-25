Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324995E9467
	for <lists+kvm@lfdr.de>; Sun, 25 Sep 2022 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIYQdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 12:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiIYQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 12:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E223B2CDDC;
        Sun, 25 Sep 2022 09:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E86B8075E;
        Sun, 25 Sep 2022 16:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837F4C433D6;
        Sun, 25 Sep 2022 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664123615;
        bh=RRltkuwJX7LP5kK/3k3rhHeIM5Hot3r7Dzu5sm7vQRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjlJCcJV0QLRS/2I5WmZcRYy+Fq+ZGX664xoh7M7CFkrLCN2vCY45z/EooBFQ0YHV
         u3Q29Vpvh/y/bGaGHTl3lEjVDZHm9SM9um6UV9VFdQX+M+x+7a2pWsRcHVcGmX2NWZ
         tAQKB71huoS7KtZZGo55h0YFq0jgkE4fSbCL65Ult0LCuQUsBdWQnuxqmY6FBTlQ60
         vyqHgyrCjH+LFlBCESK/PdDWZGw8TdMaJNx3WdCYjdglkV0dFYnQbjjeLnRRHwr812
         5R1Fn1oGFDtim8kl0vRLzsK/bcwb1GxaVZ5dZRF9YlLR3jKZq4Y7tjt7O0lBMVAoDm
         IDpCNxrnrIBEg==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v3 3/3] riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Date:   Mon, 26 Sep 2022 00:24:00 +0800
Message-Id: <20220925162400.1606-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220925162400.1606-1-jszhang@kernel.org>
References: <20220925162400.1606-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


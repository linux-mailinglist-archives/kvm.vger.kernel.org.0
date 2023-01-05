Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE30365E1C7
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 01:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbjAEAlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 19:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240662AbjAEAiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 19:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D90BB1B;
        Wed,  4 Jan 2023 16:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC47561890;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF4C433F1;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879095;
        bh=Dk3fbmwrwKI+Ju1OKvba1E6k//C52GxxfEwKgJeFV/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiOT16+5fy+ZmlY3dQ4rBYsTA89IkFc+A4RtgWUMm8g2H27yGepuXpenbS3q+7Fen
         Yx9qedTGLeb2TG7J+JgxnX3VlWN+r1jCHZzXQ8hIWpQdqo+sEy6p5G+7gYq6TpQANG
         JJL4jlHAbAMXa7dvcsyOZPZ+gT2k69uYrvw0pvj21ot5Jbq27mUqcSrRHbi6k+fRyM
         7D/hGfrezAZpbakTuKPhgqM3t6uu8v1J9nihITN51oGbesCYuEBUz55kGA/kPZU+O/
         Syr6yvA9o1/kr7cIGRB8rZnxb4fr7oWSMrPDeDY+RcF0U/cLTMQ698RB2/u4yLdAXD
         TQtcUHdY/9e/g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BE0335C149B; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: [PATCH rcu 05/27] arch/riscv/kvm: Remove "select SRCU"
Date:   Wed,  4 Jan 2023 16:37:51 -0800
Message-Id: <20230105003813.1770367-5-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the SRCU Kconfig option is unconditionally selected, there is
no longer any point in selecting it.  Therefore, remove the "select SRCU"
Kconfig statements.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: <kvm@vger.kernel.org>
Cc: <kvm-riscv@lists.infradead.org>
Cc: <linux-riscv@lists.infradead.org>
---
 arch/riscv/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index f36a737d5f96d..6bc9b290c1283 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -27,7 +27,6 @@ config KVM
 	select KVM_XFER_TO_GUEST_WORK
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
-	select SRCU
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.31.1.189.g2e36527f23


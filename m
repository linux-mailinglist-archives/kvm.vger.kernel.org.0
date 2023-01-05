Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4544F65E1C8
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 01:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbjAEAlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 19:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbjAEAiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 19:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2985EB0E;
        Wed,  4 Jan 2023 16:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1DED61888;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128B8C433F0;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879095;
        bh=y8xRrU76YdOECfRSbYnfV2Bk66MTu1Uv/uSklehNSxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeGs2XWr+ifvcauS1t6kJhZsfDir+pO9qE+SmEvi+Sog0DQIef3EBJu8ofLTX4FnO
         q2N17PIMXbO7h0rvE8z+Fruvfjfv6KIx6z4FtNuanxUPURmQnX1ygqH/KTGWSghf15
         LR9BybAtj5nsWOWUx+8XI/hox2tkt/vcRHRdj4neuMipbmrnO20QywihHplvL4DsKL
         4umYJ40GGFSOqElocb6+wrqdin9x2kbu3XyAbWhc4IUMkRqLa/JlEE8Rdwm71HI2cO
         ed6lnoNZ7JEPvsESENzfaYpM8timAtBosa6km+HOTgCcKLn3s5jcfehpvrfodSD+4Y
         M+59Q57JyUvHg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B9D2B5C08E5; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH rcu 03/27] arch/mips/kvm: Remove "select SRCU"
Date:   Wed,  4 Jan 2023 16:37:49 -0800
Message-Id: <20230105003813.1770367-3-paulmck@kernel.org>
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
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <linux-mips@vger.kernel.org>
Cc: <kvm@vger.kernel.org>
---
 arch/mips/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 91d197bee9c0a..591f46a5d7be1 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -26,7 +26,6 @@ config KVM
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select MMU_NOTIFIER
-	select SRCU
 	select INTERVAL_TREE
 	help
 	  Support for hosting Guest kernels.
-- 
2.31.1.189.g2e36527f23


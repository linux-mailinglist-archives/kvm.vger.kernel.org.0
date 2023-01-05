Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB665E1C1
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 01:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbjAEAlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 19:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbjAEAip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 19:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BAC327;
        Wed,  4 Jan 2023 16:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A23C261886;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B91FC433D2;
        Thu,  5 Jan 2023 00:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672879095;
        bh=Csa7ZOvocT4iHE2+eFHJkdwdqaRGDl3I3p+hry5hXgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQIDbChw8YO6o7XPlNJcgIE+x0DZX/DlurmnU8opQn7/BIOPNsCDUollJiqi4bc55
         FUAUQqBDPi1gvF8QBqkZFaMxtinhx5MAqAXqXTpEYUr4z6pB0aopwLXBxpdevF3RW3
         jrGk9OUAXy2NOoLkaYXy3LdJ3LfCxEIL+IRL2JMDu5Ygi9IQWVcnm7v8xHtYihzuaW
         c7yoiYtYFTE7KJYPkpEPRWnOhdsZV3W6448meglV3pNnV9XLZQ4iBnJch8YSZ85PWK
         jcJYS4wfOrvgIoTJ7X3VHrpRcLwRiYiT0jZzpnjX4JoN4h/hIF2Qd/a6/9T9Q5ede1
         QB26Gbw1B5aoQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B54025C05CA; Wed,  4 Jan 2023 16:38:14 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH rcu 01/27] arch/x86: Remove "select SRCU"
Date:   Wed,  4 Jan 2023 16:37:47 -0800
Message-Id: <20230105003813.1770367-1-paulmck@kernel.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <x86@kernel.org>
Cc: <kvm@vger.kernel.org>
---
 arch/x86/Kconfig     | 2 --
 arch/x86/kvm/Kconfig | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3604074a878b8..4a9175fe7dd18 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -283,7 +283,6 @@ config X86
 	select RTC_LIB
 	select RTC_MC146818_LIB
 	select SPARSE_IRQ
-	select SRCU
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
@@ -1938,7 +1937,6 @@ config X86_SGX
 	depends on X86_64 && CPU_SUP_INTEL && X86_X2APIC
 	depends on CRYPTO=y
 	depends on CRYPTO_SHA256=y
-	select SRCU
 	select MMU_NOTIFIER
 	select NUMA_KEEP_MEMINFO if NUMA
 	select XARRAY_MULTI
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbeaa9ddef598..9306d99585188 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
-	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	help
-- 
2.31.1.189.g2e36527f23


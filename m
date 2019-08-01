Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E157DE06
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbfHAOiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36218 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731467AbfHAOiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:20 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDX-0000mF-Rw; Thu, 01 Aug 2019 16:38:07 +0200
Message-Id: <20190801143658.166001448@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:55 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [patch 5/5] x86: Select POSIX_CPU_TIMERS_TASK_WORK
References: <20190801143250.370326052@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

X86 handles task work in KVM now. Enable the delegation of posix cpu timer
expiry into task work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -213,6 +213,7 @@ config X86
 	select NEED_SG_DMA_LENGTH
 	select PCI_DOMAINS			if PCI
 	select PCI_LOCKLESS_CONFIG		if PCI
+	select POSIX_CPU_TIMERS_TASK_WORK
 	select PERF_EVENTS
 	select RTC_LIB
 	select RTC_MC146818_LIB



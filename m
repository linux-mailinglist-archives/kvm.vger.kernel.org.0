Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793D16630EE
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 21:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbjAIUG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 15:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbjAIUF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 15:05:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DCD2BE3;
        Mon,  9 Jan 2023 12:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20DAB80DAA;
        Mon,  9 Jan 2023 20:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A30C433EF;
        Mon,  9 Jan 2023 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673294754;
        bh=yYs+qSiXSo4rOaJUjY69RaOD8scU/NtwsObjXwdlD+s=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=jaAwXHC+BFmOKh7m7WSuWE/MACludp41gnQPDqrxYXOjYys5lmUVGr8bZHDGQ81cG
         WBssMW6PNC4tDb3aTdv9RzrNAHTxVSOA9pTWdlJd/Y7+8T3pUJCMKRKf78rRch4DK3
         h7QM7Un9PAa3XhYfL6zdu88Y5jEWPbreXFewEs7buZJK+l9AV4UgVIfh4qvtTDySA1
         Ck5OMI9bAsyE0l96y43VQtRgoYGhaqny5Th/GcHVDIYsUIPlgZ6fCknVBRH5Bh7mUo
         DWh7ixR8k1hibd1IDPKbNmsXFKKlSrrbvaiqQJwHmn00m+plkgryD9J/iufCSFbEis
         83+sBJv6bV5WQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 000725C05C8; Mon,  9 Jan 2023 12:05:53 -0800 (PST)
Date:   Mon, 9 Jan 2023 12:05:53 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH rcu 01/27] arch/x86: Remove "select SRCU"
Message-ID: <20230109200553.GA4154229@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-1-paulmck@kernel.org>
 <Y7xSO2dW1sy21RVz@google.com>
 <20230109192228.GV4028633@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109192228.GV4028633@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 11:22:28AM -0800, Paul E. McKenney wrote:
> On Mon, Jan 09, 2023 at 05:43:23PM +0000, Sean Christopherson wrote:
> > On Wed, Jan 04, 2023, Paul E. McKenney wrote:
> > > Now that the SRCU Kconfig option is unconditionally selected, there is
> > > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > > Kconfig statements.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: <x86@kernel.org>
> > > Cc: <kvm@vger.kernel.org>
> > > ---
> > 
> > ...
> > 
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index fbeaa9ddef598..9306d99585188 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -46,7 +46,6 @@ config KVM
> > >  	select KVM_XFER_TO_GUEST_WORK
> > >  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > >  	select KVM_VFIO
> > > -	select SRCU
> > 
> > Would it be too much trouble to bundle all of the KVM changes into a single patch?
> > The SRCU requirement is a generic KVM requirement that's handled in the arch Kconfigs
> > purely because of KVM's somewhat roundabout Kconfig setup.
> 
> No problem, and will do on my next rebase.  I might end up with a long
> list of Cc's, but so it goes.  I will of course send the result as a
> reply to this message.

Like this?  (Given the acks, the Cc list wasn't as long as I feared that
it would be.)

							Thanx, Paul

------------------------------------------------------------------------

commit 8bde7256e3bdcf4519ee783b0bd919685b960402
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Tue Nov 22 15:45:39 2022 -0800

    kvm: Remove "select SRCU"
    
    Now that the SRCU Kconfig option is unconditionally selected, there is
    no longer any point in selecting it.  Therefore, remove the "select SRCU"
    Kconfig statements from the various KVM Kconfig files.
    
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
    Cc: Huacai Chen <chenhuacai@kernel.org>
    Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
    Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Cc: Michael Ellerman <mpe@ellerman.id.au>
    Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
    Cc: Sean Christopherson <seanjc@google.com>
    Cc: Paolo Bonzini <pbonzini@redhat.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: <kvm@vger.kernel.org>
    Acked-by: Marc Zyngier <maz@kernel.org>
    Acked-by: Anup Patel <anup@brainfault.org>
    Acked-by: Heiko Carstens <hca@linux.ibm.com>
    Reviewed-by: John Ogness <john.ogness@linutronix.de>

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 05da3c8f7e88f..312f0e9869111 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -28,7 +28,6 @@ menuconfig KVM
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_XFER_TO_GUEST_WORK
-	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
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
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index a9f57dad6d916..902611954200d 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
-	select SRCU
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
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
 
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 33f4ff909476c..45fdf2a9b2e32 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -31,7 +31,6 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
-	select SRCU
 	select KVM_VFIO
 	select INTERVAL_TREE
 	select MMU_NOTIFIER
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

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2166E301
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 10:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfGSI7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 04:59:38 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46833 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfGSI7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 04:59:37 -0400
Received: by mail-oi1-f196.google.com with SMTP id 65so23702547oid.13;
        Fri, 19 Jul 2019 01:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBusBZhQcLKBWDanQAGbHMALYypzWJ4WXbnd8gqcE3w=;
        b=hzQUCbzumVp7OrDT0mxpxR3wMx4ptyZYpa6YUNaWZPMrRycx8xtDDqJXyYTTAGhRoQ
         mka1Z7qRSaSNvxu9QSd3RzxuZclNptcC6dYCbJBvRYk6RB/K9v7lKHYZ+dPy2t204zDG
         8N8aV6KlPlWZoj607hSatkWfw5L2pTyTxUXmFOWPNhqGdLZYpnQpzAwIgvvAzLfrC1JI
         eqiZxe/3w3ZF+rYttmsr3JQhPutJmcdGhZrWWjFL8aTLYCN+dHTlx5MU4AN4XhQWFlJv
         snwD0vfxkiSuL+//2Wh85TxuU7E8dkMJIV4+a91zaiLdcz3S6JMMsYJh97qjyx0ciDHJ
         I21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBusBZhQcLKBWDanQAGbHMALYypzWJ4WXbnd8gqcE3w=;
        b=WfLT+ga7JYV4BIEDmpGdqoHJleYQTKOfnKtHq6g0wQi3yihNb+VEhB9ErP3pxrRutY
         pablp5GCh9R4rkVPp6vOY3FvsdCqfgVuJSyuINUBMIBziZw8gqjyW4g+rKMTiQ+7iAn3
         joyDzZv9JxrMnZQqY1fR30IY+/Cjn7FKqEjxmChi9Z0xDEdpq8vNjnoMOkSaILAHtoXj
         VUx8wl9/N0KuTCgKISTqoxTp+qL+82LN036aoGedR/9jg9Dmyadkhc4gltoeykyf5n8t
         Zrgl2QnbHrfEExdQL8Gv7/R1kg4XOPUuv8gkFB6to7V63JpnvLSVpo4lcUlLETcQL6Un
         6Vvg==
X-Gm-Message-State: APjAAAX+HDauyeBvs62Lmg6r1h0ApkrcBPcRYQAeMmcOUatgh3soxBx6
        VvVinBMQ2V7lzmwXXFmvk8Q9N9ydchdJv3gMDVgW8bS+ces=
X-Google-Smtp-Source: APXvYqxkeToemgSjhvUX7UQTyztvFqqM2CAb21z3wyp+gF2R8lPYi/gkwN79NQrxS+EPPCdNYXXQg9mhLqXK9xHzGBw=
X-Received: by 2002:aca:b9d4:: with SMTP id j203mr25350397oif.5.1563526776730;
 Fri, 19 Jul 2019 01:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <217248af-e980-9cb0-ff0d-9773413b9d38@thomaslambertz.de>
In-Reply-To: <217248af-e980-9cb0-ff0d-9773413b9d38@thomaslambertz.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 19 Jul 2019 16:59:25 +0800
Message-ID: <CANRm+CxWbkr0=DB7DBdaQOsTTt0XS5vSk_BRL2iFeAAm81H8Bg@mail.gmail.com>
Subject: Re: [5.2 regression] x86/fpu changes cause crashes in KVM guest
To:     Thomas Lambertz <mail@thomaslambertz.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rik van Riel <riel@surriel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc kvm ml,
On Thu, 18 Jul 2019 at 08:08, Thomas Lambertz <mail@thomaslambertz.de> wrote:
>
> Since kernel 5.2, I've been experiencing strange issues in my Windows 10
> QEMU/KVM guest.
> Via bisection, I have tracked down that the issue lies in the FPU state
> handling changes.
> Kernels before 8ff468c29e9a9c3afe9152c10c7b141343270bf3 work great, the
> ones afterwards are affected.
> Sometimes the state seems to be restored incorrectly in the guest.
>
> I have managed to reproduce it relatively cleanly, on a linux guest.
> (ubuntu-server 18.04, but that should not matter, since it occured on
> windows aswell)
>
> To reproduce the issue, you need prime95 (or mprime), from
> https://www.mersenne.org/download/ .
> This is just a stress test for the FPU, which helps reproduce the error
> much quicker.
>
> - Run it in the guest as 'Benchmark Only', and choose the '(2) Small
> FFTs' torture test. Give it the maximum amount of cores (for me 10).
> - On the host, run the same test. To keep my pc usable, I limited it to
> 5 cores. I do this to put some pressure on the system.
> - repeatedly focus and unfocus the qemu window
>
> With this config, errors in the guest usually occur within 30 seconds.
> Without the refocusing, takes ~5min on average, but the variance of this
> time is quite large.
>
> The error messages are either
>      "FATAL ERROR: Rounding was ......., expected less than 0.4"
> or
>      "FATAL ERROR: Resulting sum was ....., expexted: ......",
> suggesting that something in the calculation has gone wrong.
>
> On the host, no errors are ever observed!

I found it is offended by commit 5f409e20b (x86/fpu: Defer FPU state
load until return to userspace) and can only be reproduced when
CONFIG_PREEMPT is enabled. Why restore qemu userspace fpu context to
hardware before vmentry in the commit?
https://lkml.org/lkml/2017/11/14/945 Actually I suspect the commit
f775b13eedee2 (x86,kvm: move qemu/guest FPU switching out to vcpu_run)
inaccurately save guest fpu state which in xsave area into the qemu
userspace fpu buffer. However, Rik replied in
https://lkml.org/lkml/2017/11/14/891, "The scheduler will save the
guest fpu context when a vCPU thread is preempted, and restore it when
it is scheduled back in." But I can't find any scheduler codes do
this. In addition, below codes can fix the mprime error warning.
(Still not sure it is correct)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58305cf..18f928e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3306,6 +3306,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

     kvm_x86_ops->vcpu_load(vcpu, cpu);

+    if (test_thread_flag(TIF_NEED_FPU_LOAD))
+        switch_fpu_return();
+
     /* Apply any externally detected TSC adjustments (due to suspend) */
     if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
         adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -7990,10 +7993,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
     trace_kvm_entry(vcpu->vcpu_id);
     guest_enter_irqoff();

-    fpregs_assert_state_consistent();
-    if (test_thread_flag(TIF_NEED_FPU_LOAD))
-        switch_fpu_return();
-
     if (unlikely(vcpu->arch.switch_db_regs)) {
         set_debugreg(0, 7);
         set_debugreg(vcpu->arch.eff_db[0], 0);

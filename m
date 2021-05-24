Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20D838F0D2
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbhEXQG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbhEXQFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 12:05:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2605C045A7E
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:32:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so11450799pjt.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTLQS1Z8FEOlhUo8e2ilHpdsLeUEYIz1e8HwtA36wZk=;
        b=ELl8gQHks3M1m3jDMgds2oCt9ZzM+QGOqQzNafipEtpgJV3IDTx/dWwW9bOtykOWN4
         bL0nlV4qIv6mSlWJR9QsfqLylH+wsJlRat9n64rzY2U7khdoAGjD12/9U4Ztk60Pb45s
         otzNVn6x4WCeK5aFLxqnX/SzETjkZGwszG5xL/lAedFiowI/hN8Pdu2St4HUdCqnxzfJ
         bM5jToCtqUxksi9U/+qqOkahEGvv6Nvqgk22C3iBCgOv/1wgxpg2MGoy+4BlbFvssZs8
         2xDtSt/OT3Cg7mY5JcnUi/Lq6bl5mZT0r11pilfsKin4MNThXHZH9UkreA9RzuTeAzmJ
         iSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTLQS1Z8FEOlhUo8e2ilHpdsLeUEYIz1e8HwtA36wZk=;
        b=B2Q6bEFY9xoc2of2/y48nKQuVTGdlN11LnGbpGksOmADQUIMAqu4Q1uqmMC5p/L/WZ
         2dNnap8zmyf+6eWHDmn4GfM/bU+htdrxCPOzNEzYfV4g/KQzNE2EweptwFle/dbdyyXP
         bLG1Ts7cN4ZDRouiKRSh2Os8vWd7cRCBYo7NUEPXWhEUXzn50oIGgsYU8ydMr8GmcOIm
         9vsTGKvILxN+sX8oJYlUvlRsM1BsrfroTtrAymeXNP8b2FG+I5dKcMSi1/botXaaIkY2
         QvxTc3BYxrGHOlrkSKtoNlpXbcabVWroppD2PnpRvPmyzl5/xfv0yfltGuQFgXgwK4je
         Lz0g==
X-Gm-Message-State: AOAM530LKaMlYSN9KJAfuYbzbLM13jZ6h/S9FmGHaMEo6ZNzUizo0YtC
        zJgCWFy42wl8bEL+eNxlhQyqPg==
X-Google-Smtp-Source: ABdhPJzv8M36y7M+fAk2A5ZVct66fqarKzloUPfE3zH7nFYkpU2HKrbENkvu7RK07vtFMywuEM7+jg==
X-Received: by 2002:a17:902:b7c3:b029:ef:8d29:a7d1 with SMTP id v3-20020a170902b7c3b02900ef8d29a7d1mr25994712plz.55.1621870362015;
        Mon, 24 May 2021 08:32:42 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t22sm11118530pfl.50.2021.05.24.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 08:32:41 -0700 (PDT)
Date:   Mon, 24 May 2021 15:32:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: X86: Fix warning caused by stale emulation context
Message-ID: <YKvHFbPfGnaQ4huw@google.com>
References: <1621830954-31963-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621830954-31963-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 23, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
>   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
>   RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
>   Call Trace:
>    kvm_mmu_page_fault+0x126/0x8f0 [kvm]
>    vmx_handle_exit+0x11e/0x680 [kvm_intel]
>    vcpu_enter_guest+0xd95/0x1b40 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
>    kvm_vcpu_ioctl+0x389/0x630 [kvm]
>    __x64_sys_ioctl+0x8e/0xd0
>    do_syscall_64+0x3c/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
> adds hardware breakpoints check before emulation the instruction and parts of 
> emulation context initialization, actually we don't have EMULTYPE_NO_DECODE flag 
> here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86: 
> set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
> catches the stale emulation context has #UD, however, it is not during instruction 
> decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
> the second part emulation context initialization before hardware breakpoints check.
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> 
> Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04..eca69f9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7552,6 +7552,13 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  
>  	init_emulate_ctxt(vcpu);
>  
> +	ctxt->interruptibility = 0;
> +	ctxt->have_exception = false;
> +	ctxt->exception.vector = -1;
> +	ctxt->perm_ok = false;

What about moving this block all the way into init_emulate_ctxt()?

> +	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;

This can be left where it is since ctxt->ud is consumed only by x86_decode_insn().
I don't have a strong preference as it really only matters for the backport.  For
upstream, we can kill it off in a follow-up patch by passing emulation_type to
x86_decode_insn() and dropping ctxt->ud altogether.  Tracking that info in ctxt
for literally one call is silly.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8a0ccdb56076..b62944046d7d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5322,7 +5322,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)

        ctxt->execute = opcode.u.execute;

-       if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
+       if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
+           likely(!(ctxt->d & EmulateOnUD)))
                return EMULATION_FAILED;

        if (unlikely(ctxt->d &
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index f016838faedd..2ad32600a8e3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -314,7 +314,6 @@ struct x86_emulate_ctxt {
        int interruptibility;

        bool perm_ok; /* do not check permissions if true */
-       bool ud;        /* inject an #UD if host doesn't support insn */
        bool tf;        /* TF value before instruction (after for syscall/sysret) */

        bool have_exception;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a224601d89e2..48b49c24c086 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7552,8 +7552,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,

        init_emulate_ctxt(vcpu);

-       ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
        /*
         * We will reenter on the same instruction since we do not set
         * complete_userspace_io. This does not handle watchpoints yet,
@@ -7563,7 +7561,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
            kvm_vcpu_check_breakpoint(vcpu, &r))
                return r;

-       r = x86_decode_insn(ctxt, insn, insn_len);
+       r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);

        trace_kvm_emulate_insn_start(vcpu);
        ++vcpu->stat.insn_emulation;

> +
>  	/*
>  	 * We will reenter on the same instruction since we do not set
>  	 * complete_userspace_io. This does not handle watchpoints yet,
> @@ -7561,13 +7568,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>  	    kvm_vcpu_check_breakpoint(vcpu, &r))
>  		return r;
>  
> -	ctxt->interruptibility = 0;
> -	ctxt->have_exception = false;
> -	ctxt->exception.vector = -1;
> -	ctxt->perm_ok = false;
> -
> -	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
> -
>  	r = x86_decode_insn(ctxt, insn, insn_len);
>  
>  	trace_kvm_emulate_insn_start(vcpu);
> -- 
> 2.7.4
> 

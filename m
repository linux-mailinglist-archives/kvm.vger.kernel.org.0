Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7C61A4836
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 18:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgDJQFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 12:05:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53156 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726177AbgDJQFB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Apr 2020 12:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586534700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxOJV+PXw0OWe981JdPu+MdBwKVnkcb6yaLM9gtV+Uw=;
        b=MjBNN0auNnRkDbZjJOecf0fIrHxDe53aHwR1DwLJGVd8ynGAVKun1ieeyaUdWvyGFbfw2e
        KBc9hDt5MLulc+hEO5PhGmHlPbH09O9VmSTC/8NlPPaY8q4wZBqcHpm2BgO9Fbx+DS+bhy
        ujuVx1bRau7X6Thh7UgliFDseGUmu4A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-IJpC3aRJNwOr-orlU8ccbQ-1; Fri, 10 Apr 2020 12:04:57 -0400
X-MC-Unique: IJpC3aRJNwOr-orlU8ccbQ-1
Received: by mail-wr1-f71.google.com with SMTP id n7so1421545wru.9
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 09:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cxOJV+PXw0OWe981JdPu+MdBwKVnkcb6yaLM9gtV+Uw=;
        b=VgD48keKr0DLuFYIKTI3MN1dbey54bPnwkW3dyDQ2gqs7VpLjFyJqkWPORGPSYns5y
         /OOQRnirkMDEB9h3NcnofY2RvOT1vGix3uJtN6bfOafahSG3Z7OpSdbNZYOlg7/EGjmG
         FtrD36H8g9wV0DjQjhTivWzsYFAIZzGD3lSDJlZj1GDvAE0JzepbtR1nSjQClGKSD71X
         0ZUGyyCLsS46n7asT0eF7L87Gs3BedL2uWEBmJ0jP0MykKcHdrEkF517d97ucqHHJWyJ
         nq006hQami3oPiYZuarXeNvqRFi4wYBaVk8EyXJuVHke5BXSXtLiIvwpz8/SXHqh7XKd
         gNgg==
X-Gm-Message-State: AGi0Pubgq8iNvUYmnnapSfMjjl5aZxm0rqpUYRtjcmyGoPJukxobZ2l/
        UFmxsIUYhh7c1C5DEli8ggGqZ32L3HPxp1w6LRdx9GSR8D+qUk50Fx/vQjy+Oxbw4GYJIY8eOC/
        0DDfV27s0rCgv
X-Received: by 2002:a1c:6545:: with SMTP id z66mr5590631wmb.81.1586534695912;
        Fri, 10 Apr 2020 09:04:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypIUoTNzgT8EHUupmSiQmqAgjl7+0TQSoQpIjhsdXJ4SNG1cJk937+fQ4caZS5evjdxQhgMaNA==
X-Received: by 2002:a1c:6545:: with SMTP id z66mr5590603wmb.81.1586534695605;
        Fri, 10 Apr 2020 09:04:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b7:b34c:3ace:efb6? ([2001:b07:6468:f312:f4b7:b34c:3ace:efb6])
        by smtp.gmail.com with ESMTPSA id j10sm3249165wru.85.2020.04.10.09.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 09:04:54 -0700 (PDT)
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>, Marco Elver <elver@google.com>
Cc:     "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
 <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
 <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
 <B798749E-F2F0-4A14-AFE3-F386AB632AEB@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1d6db024-82d1-5530-2e78-478ee333173e@redhat.com>
Date:   Fri, 10 Apr 2020 18:04:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <B798749E-F2F0-4A14-AFE3-F386AB632AEB@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 17:50, Qian Cai wrote:
> This works,
> 
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>  
> -static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> +static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
> Does anyone has any idea why svm_vcpu_run() would be a problem for KCSAN_INTERRUPT_WATCHER=y?

All of svm_vcpu_run() has interrupts disabled anyway, but perhaps KCSAN
checks the interrupt flag?  That could be a problem because
svm_vcpu_run() disables the interrupts with GIF not IF (and in fact
IF=1).

You can try this patch which moves the problematic section inside
the assembly language trampoline:

 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 27f4684a4c20..6ffa07d42e5e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3337,8 +3337,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	local_irq_enable();
-
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
	/* Eliminate branch target predictions from guest mode */
@@ -3373,8 +3368,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	reload_tss(vcpu);
 
-	local_irq_disable();
-
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index fa1af90067e9..a2608ede0975 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -78,6 +78,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_AX
 
 	/* Enter guest mode */
+	sti
 1:	vmload %_ASM_AX
 	jmp 3f
 2:	cmpb $0, kvm_rebooting
@@ -99,6 +100,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	ud2
 	_ASM_EXTABLE(5b, 6b)
 7:
+	cli
+
 	/* "POP" @regs to RAX. */
 	pop %_ASM_AX
 

Paolo


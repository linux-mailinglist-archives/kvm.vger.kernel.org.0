Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B517A2D8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCEKIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:08:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgCEKIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:08:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a++OnOLHx7X8yF6qTfZsk/CBiAFakXwwpWB/hlFxqQk=;
        b=SHxUw6UnW4w3sBeRYx1g8BfAzhflcOHnhnON7ZcGta1R4qEw1FXzKtQFhLo+E9mvKVeEza
        x0YEU1jiuDD7m5x6D+x1R1iwD2nO5WEZDAMwkxPxxZZO9oO93LDtwnRL0m4i1Jc+H6bcEJ
        o50EFZg1TWllUSaR566wJOb3YLogi1Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-O_gN0nsjP-S084ZcD2mxow-1; Thu, 05 Mar 2020 05:08:43 -0500
X-MC-Unique: O_gN0nsjP-S084ZcD2mxow-1
Received: by mail-wr1-f70.google.com with SMTP id w8so2092082wrn.7
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 02:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=a++OnOLHx7X8yF6qTfZsk/CBiAFakXwwpWB/hlFxqQk=;
        b=s5SeAdO8O+VWVZPJz0IMA20Qs01l34A5xMDo2aVeyVGEgZr21Tproucgjy0kNRqi7o
         gwAkfwEcdg1/X56b1T1u/rqkJzmdLNLyaFVcfzl9obYYLz/yEGo2hOG0U4PRqnwqSvzt
         OwnngDyzppKVyTIfBIhAn1w5C82Eb/PRxgEEy+cGn+jskRwj8a1T662T4QSP2KyVk+dA
         gi2HZS0cuQJP35kIDwpDQdxHOBjjIBy1E+m3fQfyixh53RmirnkfGURbivIQJeCE4Ckq
         rnXRLCL8Jt8mVsemzY7dSli1DJWuYxwGmaLKnor0n6k+t2kqrE18+FRlwurIDdo8rDs6
         wuhw==
X-Gm-Message-State: ANhLgQ1K5IJtLa4eaRGIgn+TRMXtrMrUjvLSY3Dic4hIXsNktmCNULNb
        A4gH80hPQC2gPx/Qo6euRM48QGvJmr6oRruXitvBI+weWIq5J7zW0Vtz7JWPXM3wCxGSYYzX8w8
        gfyIvqPM3b584
X-Received: by 2002:a1c:f008:: with SMTP id a8mr8497017wmb.81.1583402921632;
        Thu, 05 Mar 2020 02:08:41 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsbhjFKaAeSfPW48bnxoeEB0ks/A9uEmzLV2bTa/Ugj9be5kTg7qhyLsAMwgyzYk+RO9VUxug==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr8497006wmb.81.1583402921444;
        Thu, 05 Mar 2020 02:08:41 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i6sm10535928wra.42.2020.03.05.02.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:08:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
In-Reply-To: <1583375731-18219-1-git-send-email-linmiaohe@huawei.com>
References: <1583375731-18219-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 05 Mar 2020 11:08:39 +0100
Message-ID: <87tv33cdw8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> (X86_EFLAGS_IOPL | X86_EFLAGS_VM) indicates the eflag bits that can not be
> owned by realmode guest, i.e. ~RMODE_GUEST_OWNED_EFLAGS_BITS. Use wrapper
> macro directly to make it clear and also improve readability.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 743b81642ce2..9571f8dea016 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1466,7 +1466,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	vmx->rflags = rflags;
>  	if (vmx->rmode.vm86_active) {
>  		vmx->rmode.save_rflags = rflags;
> -		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> +		rflags |= ~RMODE_GUEST_OWNED_EFLAGS_BITS;
>  	}
>  	vmcs_writel(GUEST_RFLAGS, rflags);
>  
> @@ -2797,7 +2797,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
>  	flags = vmcs_readl(GUEST_RFLAGS);
>  	vmx->rmode.save_rflags = flags;
>  
> -	flags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> +	flags |= ~RMODE_GUEST_OWNED_EFLAGS_BITS;
>  
>  	vmcs_writel(GUEST_RFLAGS, flags);
>  	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);

Double negations are evil, let's define a macro for 'X86_EFLAGS_IOPL |
X86_EFLAGS_VM' instead (completely untested):

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ee19fb35cde..d838f93bd6d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -139,7 +139,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
 #define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
 
-#define RMODE_GUEST_OWNED_EFLAGS_BITS (~(X86_EFLAGS_IOPL | X86_EFLAGS_VM))
+#define RMODE_HOST_OWNED_EFLAGS_BITS (X86_EFLAGS_IOPL | X86_EFLAGS_VM)
+#define RMODE_GUEST_OWNED_EFLAGS_BITS (~RMODE_HOST_OWNED_EFLAGS_BITS)
 
 #define MSR_IA32_RTIT_STATUS_MASK (~(RTIT_STATUS_FILTEREN | \
        RTIT_STATUS_CONTEXTEN | RTIT_STATUS_TRIGGEREN | \
@@ -1468,7 +1469,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
        vmx->rflags = rflags;
        if (vmx->rmode.vm86_active) {
                vmx->rmode.save_rflags = rflags;
-               rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+               rflags |= RMODE_HOST_OWNED_EFLAGS_BITS;
        }
        vmcs_writel(GUEST_RFLAGS, rflags);
 
@@ -2794,7 +2795,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
        flags = vmcs_readl(GUEST_RFLAGS);
        vmx->rmode.save_rflags = flags;
 
-       flags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+       flags |= RMODE_HOST_OWNED_EFLAGS_BITS;
 
        vmcs_writel(GUEST_RFLAGS, flags);
        vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);

-- 
Vitaly


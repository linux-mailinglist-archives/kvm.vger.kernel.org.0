Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E707820D434
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 21:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgF2TGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:06:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730188AbgF2TGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 15:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wiA60jnjSVk1PN6FvCwFOWuyAKPOYAY44lt2HUcQNf4=;
        b=Fce1K0OhI4n8GXXkr71jHl24wl4Cn5c1UK2uzi7eDRUgQozU7BMbOCFVNgH2BfebMgmcT7
        5THjliWzZixzSxbfbn+ppcPeVR/XnnYlYz1ufDx2dB/ZlhzK6mmI29VdKFzsKcMxri9Vil
        VVLr+Ku+YqyLsuJJzxTplIZdsJiPEP8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-qj4UeuNxNJmL9nMGRDMfKw-1; Mon, 29 Jun 2020 11:03:44 -0400
X-MC-Unique: qj4UeuNxNJmL9nMGRDMfKw-1
Received: by mail-wm1-f71.google.com with SMTP id y204so7463426wmd.2
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 08:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wiA60jnjSVk1PN6FvCwFOWuyAKPOYAY44lt2HUcQNf4=;
        b=TgG3riH5N6y9xKQRPUO/eKmi5YALDYKVBQnKuLsJEBWbKLF9CVLz/R9q/4QFMiLwU7
         DiUVsEMsXq4jgds6UqVrWzXebvJyKa/qH6O7XLRZ9ZO+97qAvYiPRIvEekqqXVimH+qh
         gWkzU7po2zpU/uFS7kt2LwWAzcuVjfJQEJvHiATFAlcAJZDYkz8ZnYcF1RjW4lIy7ieS
         v48dsqukFNOcALYmDXsOszc1mwwQ008FM1JqjN1FyDp+mwmAb754JyZlso7933spUdIj
         kEnpYQFXqXVFzSFR1FquntJ6+4mn3qEJdQeb7+aaCZdHCpz4kitxNq90u18QTKWVM0sp
         ez2A==
X-Gm-Message-State: AOAM53074p3VebJnELqRh4P+evctWu4Jqq6pRxLbH0TLBN+5TZ2azXyX
        I3TqDtccJ1VM/ui1dh4pt4n/RTrQqzmQG64dvRiFi+2Pl3BWhnAplQzkSEqtLuj23hIORI4jBjh
        tmDVC1diwJ1v3
X-Received: by 2002:a7b:c185:: with SMTP id y5mr17739368wmi.85.1593443023600;
        Mon, 29 Jun 2020 08:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfWzhvzup1XHO1uAaeVJMlYTx2UJCwm1ZI0mJJ7N8UF2kln9C5WXC5FIAYwAJfdIO20eLgbA==
X-Received: by 2002:a7b:c185:: with SMTP id y5mr17739339wmi.85.1593443023215;
        Mon, 29 Jun 2020 08:03:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b0e5:c632:a580:8b9a? ([2001:b07:6468:f312:b0e5:c632:a580:8b9a])
        by smtp.gmail.com with ESMTPSA id a126sm63300wme.28.2020.06.29.08.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 08:03:42 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60b8326d-3979-6218-4a41-79c86ffab3bd@redhat.com>
Date:   Mon, 29 Jun 2020 17:03:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/20 12:26, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Syzbot reported that:
> 
>   CPU: 1 PID: 6780 Comm: syz-executor153 Not tainted 5.7.0-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:__apic_accept_irq+0x46/0xb80
>   Call Trace:
>    kvm_arch_async_page_present+0x7de/0x9e0
>    kvm_check_async_pf_completion+0x18d/0x400
>    kvm_arch_vcpu_ioctl_run+0x18bf/0x69f0
>    kvm_vcpu_ioctl+0x46a/0xe20
>    ksys_ioctl+0x11a/0x180
>    __x64_sys_ioctl+0x6f/0xb0
>    do_syscall_64+0xf6/0x7d0
>    entry_SYSCALL_64_after_hwframe+0x49/0xb3
>  
> The testcase enables APF mechanism in MSR_KVM_ASYNC_PF_EN with ASYNC_PF_INT 
> enabled w/o setting MSR_KVM_ASYNC_PF_INT before, what's worse, interrupt 
> based APF 'page ready' event delivery depends on in kernel lapic, however, 
> we didn't bail out when lapic is not in kernel during guest setting 
> MSR_KVM_ASYNC_PF_EN which causes the null-ptr-deref in host later. 
> This patch fixes it.
> 
> Reported-by: syzbot+1bf777dfdde86d64b89b@syzkaller.appspotmail.com
> Fixes: 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event delivery)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2..1c0b4f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2693,6 +2693,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  	if (data & 0x30)
>  		return 1;
>  
> +	if (!lapic_in_kernel(vcpu))
> +		return 1;
> +
>  	vcpu->arch.apf.msr_en_val = data;
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu)) {
> 

Queued, thanks.

Paolo


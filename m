Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D356117A498
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 12:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgCELta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 06:49:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726990AbgCELta (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 06:49:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583408969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jjEqvtB2T3AtCQceC0s+9bXMXtVod456eAE+2om8cIk=;
        b=WElYReDp0mSyv2i33b08pu5v1TggpJGwjlg/5gbRQIS/vNpptYSDiEE/OykTEr+fF8gPQv
        y++ohRJ7DFTrnapS3yi2NEk+lR1LXEpL+w7erqXnmTQZGw/EOnixDyJpgnpx3XAj3XSO6N
        Nsd+RqdYs62veDqw4UUI0R100oXrujk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-XaM7QyrmNdC6KHxwXNbwhQ-1; Thu, 05 Mar 2020 06:49:27 -0500
X-MC-Unique: XaM7QyrmNdC6KHxwXNbwhQ-1
Received: by mail-wr1-f72.google.com with SMTP id f10so2206102wrv.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 03:49:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjEqvtB2T3AtCQceC0s+9bXMXtVod456eAE+2om8cIk=;
        b=f5Ab21y5cD4rEN2qBLI27vcrPbIhD/PZNrSLEX6TSRJ/bcBWjSpfpq/cAmAcirCi6l
         P1yf18Bv6ByU2rjuG3s9tCyPlyDdfZylRY/m/quLuzoEJ9G54NiVqJBfosXcRAt1L0nP
         Rj5TzS3CS64gbKqNSRgyx6smVpsaLPiCzVHQxhaakWYdo0+7hK8JX/uwCgFPobCwE0VC
         qeE5L0q8WK0oiejDvQh01naBPwDi682nqDFWKqrsyaHG+q9MFa5K4WW6iYGdgom9Wtso
         DjEh3Tfvgeivrl0tD+OM8BlwQQo/dyCA6AHuIY7ix6Lz6JYGlo3VaI4PjcLs3Mmlj8YD
         GNUg==
X-Gm-Message-State: ANhLgQ2RP+oGP51Nr85XL0z0Z/q/KhskzAUhVzivAkIFVOvJgfsz/MW0
        EtEge1LQ7AcSGUuiNaSAi5gX3fzre/qdXmWMPxSgMAWAKc1kVl8tVR4rfXb2vpsqVaoD8yHJT3A
        LuznX2dcoXS1T
X-Received: by 2002:a5d:4f03:: with SMTP id c3mr9700623wru.336.1583408966553;
        Thu, 05 Mar 2020 03:49:26 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvWp4hDVBVG1qtAYBSlwG0TuP+swcJOdAhM8+FTa0BbErmeYy/trLgrnVFpjM/xmz56FptGfA==
X-Received: by 2002:a5d:4f03:: with SMTP id c3mr9700595wru.336.1583408966345;
        Thu, 05 Mar 2020 03:49:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id n3sm9523174wmc.27.2020.03.05.03.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 03:49:25 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro
 ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1583375731-18219-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f5aaab6f-8111-8d12-754f-027989fd4b06@redhat.com>
Date:   Thu, 5 Mar 2020 12:49:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583375731-18219-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 03:35, linmiaohe wrote:
> (X86_EFLAGS_IOPL | X86_EFLAGS_VM) indicates the eflag bits that can not be
> owned by realmode guest, i.e. ~RMODE_GUEST_OWNED_EFLAGS_BITS.

... but ~RMODE_GUEST_OWNED_EFLAGS_BITS is the bits that are owned by the
host; they could be 0 or 1 and that's why the code was using
X86_EFLAGS_IOPL | X86_EFLAGS_VM.

I understand where ~RMODE_GUEST_OWNED_EFLAGS_BITS is better than
X86_EFLAGS_IOPL | X86_EFLAGS_VM, but I cannot think of a way to express
it that is the best of both worlds.

Paolo

 Use wrapper
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


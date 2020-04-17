Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73A1AE06F
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgDQPGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 11:06:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728347AbgDQPGS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 11:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587135977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bp+vURr2biqLIQDqjBK7OKDMnAtcGss9u7I1kEvxU7o=;
        b=A4VkbwwiG7ebOzWEUEw3bnLJre4UUJGCRnH6W673/nsZ6VnY3CGEuUn2J5GIieB1k2h83u
        LCxc4DiX498RwHMZB6jEv8QG0RapjxV9fTESjZFeMky9azHgX55IkDO87XaL7gjK9KjeoW
        NeoI1XWRyzsfNtltwK6rcd1NxyrbBXA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-E3dsEIAlPGeHJb27WfXc9A-1; Fri, 17 Apr 2020 11:06:14 -0400
X-MC-Unique: E3dsEIAlPGeHJb27WfXc9A-1
Received: by mail-wr1-f69.google.com with SMTP id p2so412904wrx.12
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 08:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bp+vURr2biqLIQDqjBK7OKDMnAtcGss9u7I1kEvxU7o=;
        b=Urt1bwgm7W9+HAS8WuAo4qYLAqn7ZDJQ0BX8PBuAgfYi2WEwAYLyfDUf34yLcLwDF2
         pGIZzfV3A851WGb1YxK2CybjQlOePJ3hBfVsvJUMdCY0nn1glrA59OYKF64VO+e6vJFH
         26oiXMmvmhfKPxBRuOMITkYyulRusxzYraCRYGPomQTE/Zrg0+9MPMnZpcag0+9QRlp2
         +MDaFGkBys9u1wL+Ar0j3ZhciQ0i8zybocEYCIDC1KEQcHgpzejO1G89U3mFkX/71vyL
         ajLsWzmESVomOFh2WqrIappopdW14CnI3z8XZwfObIbZGh5Y1yRW4ejH9lg4pXQAEbdK
         muMw==
X-Gm-Message-State: AGi0Puai8tefKMpkTAY5XUn9cPrjQuK9WsdLcNXHA8xXZ4BDP7bdhbM4
        v4Si7SYz09rzaqWfhvYAw4pgCboG6T1aRAeW4yRPluCmMVWAQ01oFRTUs7Zybbj7PRyC5d+Bsxx
        fGojTyJ8iuUMp
X-Received: by 2002:a1c:2842:: with SMTP id o63mr3814748wmo.73.1587135972739;
        Fri, 17 Apr 2020 08:06:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypIybFDt/Q7QlgX//9mu4+TS1KJE72qr+HgPLt/Lgs3Djdgs7WyjOeORMFpznBkzJGOS8lshRw==
X-Received: by 2002:a1c:2842:: with SMTP id o63mr3814705wmo.73.1587135972411;
        Fri, 17 Apr 2020 08:06:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id g25sm8045149wmh.24.2020.04.17.08.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 08:06:11 -0700 (PDT)
Subject: Re: [PATCH] KVM: Remove CREATE_IRQCHIP/SET_PIT2 race
To:     Jon Cargille <jcargill@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steve Rutherford <srutherford@google.com>
References: <20200416191152.259434-1-jcargill@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7b8ca30-21fa-5268-7f17-889f10b90187@redhat.com>
Date:   Fri, 17 Apr 2020 17:06:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416191152.259434-1-jcargill@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 21:11, Jon Cargille wrote:
> From: Steve Rutherford <srutherford@google.com>
> 
> Fixes a NULL pointer dereference, caused by the PIT firing an interrupt
> before the interrupt table has been initialized.
> 
> SET_PIT2 can race with the creation of the IRQchip. In particular,
> if SET_PIT2 is called with a low PIT timer period (after the creation of
> the IOAPIC, but before the instantiation of the irq routes), the PIT can
> fire an interrupt at an uninitialized table.
> 
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Jon Cargille <jcargill@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 027dfd278a973..3cc3f673785c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5049,10 +5049,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = -EFAULT;
>  		if (copy_from_user(&u.ps, argp, sizeof(u.ps)))
>  			goto out;
> +		mutex_lock(&kvm->lock);
>  		r = -ENXIO;
>  		if (!kvm->arch.vpit)
> -			goto out;
> +			goto set_pit_out;
>  		r = kvm_vm_ioctl_set_pit(kvm, &u.ps);
> +set_pit_out:
> +		mutex_unlock(&kvm->lock);
>  		break;
>  	}
>  	case KVM_GET_PIT2: {
> @@ -5072,10 +5075,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = -EFAULT;
>  		if (copy_from_user(&u.ps2, argp, sizeof(u.ps2)))
>  			goto out;
> +		mutex_lock(&kvm->lock);
>  		r = -ENXIO;
>  		if (!kvm->arch.vpit)
> -			goto out;
> +			goto set_pit2_out;
>  		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
> +set_pit2_out:
> +		mutex_unlock(&kvm->lock);
>  		break;
>  	}
>  	case KVM_REINJECT_CONTROL: {
> 

Queued, thanks.

Paolo


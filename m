Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B8715A831
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgBLLpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:45:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728049AbgBLLpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581507940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHa7p/GKnBvLzuu4QbsQ7jX/HvnO0aLikEJRRufEnjE=;
        b=KpXzz9tMgA87mlXU1HW6+Cc0H0e+3w8qi6wNUcDj83Yy76BqLQXegYn0UddgT1NS7y9qKC
        5JjHIacTRMfDSHSNxkZSV1HCr+nuSMkcx9TmYGC4Dfv5VYXzK+KX1K6UfWsIEbtpi/f7Bd
        TY3HWSUZ064U5cawsX4HkikPVnHKaKM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-SRAT-c_RPame1jth88ErjQ-1; Wed, 12 Feb 2020 06:45:38 -0500
X-MC-Unique: SRAT-c_RPame1jth88ErjQ-1
Received: by mail-wm1-f71.google.com with SMTP id y24so829849wmj.8
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xHa7p/GKnBvLzuu4QbsQ7jX/HvnO0aLikEJRRufEnjE=;
        b=RiNmAbrhK5Or4X6Ng9yL78dFwqK89dSIPfJ1jjc0gIZvOM43P0p0AnGTuX7ZypPm9r
         dveA0mKPNLzZBKfX0h4PtmRU96246MBYsovp0m3JwCHwt6EaHFd/356OV1/sGbOLBlZu
         yjX8wloL8BQO1ruJ7XxDEFEyMvx4cxgZqncvHJgyTk3AydA7GWURWWGu+3NV+szLMah4
         NsTAA3KRAdVDoI31oSW9zwu6FcQbr22pPJ420xRFrkQGyH0w/nIvmGc9zM1hMNdIEWWD
         DiAknv6n62MJ1zybP+szqiJ91zDozR3pFZojQ6ursYhwuygvvfOBsJvStyVYFpMBsoSj
         4EJA==
X-Gm-Message-State: APjAAAXAKLy7RXY0v5iwi4es3cJphRBxRUVzA6u7OlSYDLni507yUQbO
        HH7fz2N77nA8J2yiWWJUcHtan+IVCKT8Ri9ajJg6zWlFR1gplDgwZEwHXqTgwHMmgjtkVM8EX24
        m4bm27G/4KxC4
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr15120670wrq.104.1581507937027;
        Wed, 12 Feb 2020 03:45:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqymgry8s5CPyNlN/xpDmM97UGbnWzc/qdRpwVaty0USC4aB2hAo5lCGpzT0Ossub3L7KFkQWQ==
X-Received: by 2002:a5d:4a04:: with SMTP id m4mr15120639wrq.104.1581507936776;
        Wed, 12 Feb 2020 03:45:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id r5sm297552wrt.43.2020.02.12.03.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:45:36 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: remove duplicated KVM_REQ_EVENT request
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581089271-3431-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55eb3a20-9660-4155-1e2a-ece8b31dbbfc@redhat.com>
Date:   Wed, 12 Feb 2020 12:45:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581089271-3431-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 16:27, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The KVM_REQ_EVENT request is already made in kvm_set_rflags(). We should
> not make it again.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> v1->v2:
> Collected Vitaly's R-b
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..212282c6fb76 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8942,7 +8942,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  
>  	kvm_rip_write(vcpu, ctxt->eip);
>  	kvm_set_rflags(vcpu, ctxt->eflags);
> -	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	return 1;
>  }
>  EXPORT_SYMBOL_GPL(kvm_task_switch);
> 

Queued, thanks.

Paolo


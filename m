Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35D0423F80
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhJFNix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 09:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239025AbhJFNil (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 09:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1r1X4bOpqP9McySpdOj88aq9sWNjOIuSeMOSdgf+nE=;
        b=fLoCIZ3yndHO0ITaWsU/4mKaXDmePSR7zL9cj9Tyuhil6XGYNdZ54GP+AMDLq8jzx125VR
        IPSso7s0HiVzzXvummGT3siMu9oYiMZcBpgICQrT6CBl/51eVVxXEg0cWqf9z0/XF5Tz3C
        66JzvqTLWsq61eWoIrbcl//zsefHzNw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-7dYJSSdZPnWswu5V3mXjEQ-1; Wed, 06 Oct 2021 09:36:47 -0400
X-MC-Unique: 7dYJSSdZPnWswu5V3mXjEQ-1
Received: by mail-ed1-f72.google.com with SMTP id v2-20020a50f082000000b003db24e28d59so2690751edl.5
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 06:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H1r1X4bOpqP9McySpdOj88aq9sWNjOIuSeMOSdgf+nE=;
        b=oINap88uS0XYjDxrQ5tY1eN57kTBpM4rtGN8Im8vewI0JK13MaDLcZdb9KuspiuNyY
         zpPxhU8VRVVH6TNoW0o+IAQVtFP+U+rUeFpSaFl7xXEZbADzmBUMem2GGG/ZtOnwdt7n
         w0/ZjdoR282SpXdfA3o3Ei7zLm8rP8YqOJvJz57C182aVU0A0f6U4FMQ6+tZ/eNqvhJ9
         IBj3ZsCUR9JF0/Ygm0vzU3GJa9eCKhQLzR5PA7+j7qElC1KOyy6+XA/4PB7PpeIRJuBy
         5oFMjuQxd51WdUxGzJ9zistjhgpVoc7walxLTQgBDebikWPO3kMp/L7rEYwIrweYI9Vl
         MlzA==
X-Gm-Message-State: AOAM5304gh3BYL0nIqNEMdc8Rb01xb1aYAGl3aSe7AkX42WY4CiEgtt7
        /31p7UbABJdDLdu2D6ytoNGNlTAPWFeIZZKm2a64q7ad/JKKJy8rEUDBJXFfiPKLyKzouRAbMIQ
        p2C4VX9/TidmC
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr32986826ejn.361.1633527406637;
        Wed, 06 Oct 2021 06:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg8tE1Dxc+9NT6zB2CZ4aGAo7WvRYAbiq4+FBTXyUz2IJSCg4m7bJF/FBN5UEGX6pdSOIcoA==
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr32986801ejn.361.1633527406407;
        Wed, 06 Oct 2021 06:36:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g10sm8874810ejj.44.2021.10.06.06.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:45 -0700 (PDT)
Message-ID: <36ee367e-3575-a237-991e-4cab07ce7041@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 8/9] KVM: x86: nSVM: restore int_vector in
 svm_clear_vintr
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-8-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit aee77e1169c1900fe4248dc186962e745b479d9e ]
> 
> In svm_clear_vintr we try to restore the virtual interrupt
> injection that might be pending, but we fail to restore
> the interrupt vector.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 69639f9624f5..19d6ffdd3f73 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1601,6 +1601,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>   
>   		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
>   			V_IRQ_INJECTION_BITS_MASK;
> +
> +		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
>   	}
>   
>   	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


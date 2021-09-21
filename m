Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818D7413926
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhIURvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231775AbhIURvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632246606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Z2PolRqIGMr2xNU27IWiova+R5tE/K6n/IJmumOaXg=;
        b=M7YyGqyLK7/26i/ZKqHA1/k1ITsArMQ31g1w9PPDsrFN9IaDEEx2n0bEwnFPs9KKoPlYVO
        J8k3Ee41W6jv2gdo+VbeTYOVRnfiqjsHDvgzhqghZit5K17ne2+pjFD1dvlDIYAAhsll5b
        EXq1Dqyh1RJ/aTWRMD6WLuGdZqW8tN8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-DIqEmR2OMlaYJzS3Q6MErg-1; Tue, 21 Sep 2021 13:50:05 -0400
X-MC-Unique: DIqEmR2OMlaYJzS3Q6MErg-1
Received: by mail-ed1-f71.google.com with SMTP id b7-20020a50e787000000b003d59cb1a923so18916961edn.5
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Z2PolRqIGMr2xNU27IWiova+R5tE/K6n/IJmumOaXg=;
        b=fSYLi7baZiAoFfSeUxSFYcTMbjSjqslCbNhDXbzzqPwSNjhw/2DPQWHO8xFhI7fsnW
         VLWfOR9f+HWOnDLuhQsNGgW9oXVOpNtIGnQ2jzOkNyVjRx2znkERkrZZmUP2lReGe0Kf
         sOAvoflvWtBHECTb9vFkx1fCNbckJIwfkC3U2kATSKAAuVsrGlgik5HhgGBtAiiIwKoT
         6OAasR+O1E5+ZQz4Nh8HSl29TnZkbAhPUNhrQgbZZp5YeO9YyjNB3kqZkPxIpkt5OixX
         M8V74l2c7KOMqp1InmG3/BK25y5e94VqkXBNXIps11ZENZrrAcUodqhtDXO32/6+8LL1
         L1Gg==
X-Gm-Message-State: AOAM533Xn1gDpMX0pZcRWGW3LEc8eQ1cJ+r4vmu+/mEyUKUO83WHWz+O
        mF7oZo6zwwu+HnJK61YPSWDmDn5WjGNPPxneC4IZE6kcXr2g2SDcrHOJAaBCeLBEV/BSEQn/U8n
        hrD1r57UM3DNp
X-Received: by 2002:aa7:c2d3:: with SMTP id m19mr37037157edp.57.1632246603112;
        Tue, 21 Sep 2021 10:50:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0hlOxCPHRCeODAso0ApC62KfNbelRAejTEfzzZ3nS1WRW0BvJMgl056iYBoxZz04xJCByVw==
X-Received: by 2002:aa7:c2d3:: with SMTP id m19mr37037131edp.57.1632246602924;
        Tue, 21 Sep 2021 10:50:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f18sm4262674edt.60.2021.09.21.10.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:50:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: fix comments of handle_vmon()
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6a2a32a9-3de9-acda-f00e-46424c5614a8@redhat.com>
Date:   Tue, 21 Sep 2021 19:50:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/09/21 19:17, Yu Zhang wrote:
> "VMXON pointer" is saved in vmx->nested.vmxon_ptr since
> commit 3573e22cfeca ("KVM: nVMX: additional checks on
> vmxon region"). Also, handle_vmptrld() & handle_vmclear()
> now have logic to check the VMCS pointer against the VMXON
> pointer.
> 
> So just remove the obsolete comments of handle_vmon().
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..90f34f12f883 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4862,14 +4862,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
>   	return -ENOMEM;
>   }
>   
> -/*
> - * Emulate the VMXON instruction.
> - * Currently, we just remember that VMX is active, and do not save or even
> - * inspect the argument to VMXON (the so-called "VMXON pointer") because we
> - * do not currently need to store anything in that guest-allocated memory
> - * region. Consequently, VMCLEAR and VMPTRLD also do not verify that the their
> - * argument is different from the VMXON pointer (which the spec says they do).
> - */
> +/* Emulate the VMXON instruction. */
>   static int handle_vmon(struct kvm_vcpu *vcpu)
>   {
>   	int ret;
> 

Queued, thanks.

Paolo


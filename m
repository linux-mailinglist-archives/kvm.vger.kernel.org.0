Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB39849B828
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbiAYQDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:03:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353866AbiAYQCi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643126555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IcXE3mGr5yfM3UtM9LVtuUY7Hip9fv9Bn5lXnjAC8TA=;
        b=Kuh0+vXUqLFif/OvHd6PP5XVnIW/qwvmSXLM8PkSeeB1ciQ7HY5ZW5LXWqqtLDYP0S5weq
        qCsoiOIwn4U4OQ/XzN/MvyTxAHHtFeDSzuGUxsWbLi3wfaeo2N+jnHCkur/4WO07zub+Tx
        Muj2g/xuad9V3xie1lF71HLeJ+qfoXY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-Sq0N0h6TNcmCHMHqBQpmWw-1; Tue, 25 Jan 2022 11:02:33 -0500
X-MC-Unique: Sq0N0h6TNcmCHMHqBQpmWw-1
Received: by mail-ed1-f69.google.com with SMTP id eg24-20020a056402289800b00407f95c4c35so4744049edb.10
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IcXE3mGr5yfM3UtM9LVtuUY7Hip9fv9Bn5lXnjAC8TA=;
        b=l9LqibJ+MlKeo7zuqwMbGz2XI4s305kjBEghGRO2HNroZEOLK+rRJgbEB0Dn3F76r2
         2m0eVXMpUSrpBuoauKySTRXzLXo0Ev0Y6ZJCapZh2eK/J4RcQM1qG98ovnhrRPCx+q7N
         THguaDIGzsq26o7QKZzyO6MINBB1QhssPUoMbAkdWYA+YFawNn2dUh04bF04X6CfPCgj
         O1TydIbLaaXFCuq77zuUbFrWsoP0NdzLTfxJmhYOqu0wD1Lr41fbjo2Rxwc7FgVkDNx1
         HWTHg/my1WshNAxEXQPHwtyuesTLjjLkfo5/Q7POIQel+zBqVbDaMcl/u10/VH5fFALO
         MfqQ==
X-Gm-Message-State: AOAM5339TqaBQdAoEgoF+qtF7RXJy+ZajPDcZB/qfa4Cr7WuK2DKqnWy
        YrhROuoCyO2qOKKDxQGOOuUIZpDkkJ1AqO5Gt1Z/8kHb8hq31IEfI+5Y9jmv3CqBwK5g4oSBYqi
        S+N/EB2aKor5R
X-Received: by 2002:a17:907:72c4:: with SMTP id du4mr8767054ejc.243.1643126552082;
        Tue, 25 Jan 2022 08:02:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwU53k0R46hrB5fKDfPkTXRr1Nq6+8sBmzHPfHo09CnOTd5BXa/VXr/nYQ7KlVvTDXEMsvf5Q==
X-Received: by 2002:a17:907:72c4:: with SMTP id du4mr8767031ejc.243.1643126551881;
        Tue, 25 Jan 2022 08:02:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g8sm6445025ejt.26.2022.01.25.08.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:02:31 -0800 (PST)
Message-ID: <e2e1c0bd-1a7e-7e21-2c38-99414e8a7cab@redhat.com>
Date:   Tue, 25 Jan 2022 17:02:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 07/19] KVM: x86/svm: Remove unused "vcpu" of
 nested_svm_check_tlb_ctl()
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125095909.38122-1-cloudliang@tencent.com>
 <20220125095909.38122-8-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125095909.38122-8-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 10:58, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The "struct kvm_vcpu *vcpu" parameter of nested_svm_check_tlb_ctl()
> is not used, so remove it. No functional change intended.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>

This might be useful later if the code needs to check guest CPUID bits. 
  Leaving it in for now.

Paolo

> ---
>   arch/x86/kvm/svm/nested.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cf206855ebf0..5a1a2678a2b1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -209,7 +209,7 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
>   	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>   }
>   
> -static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
> +static bool nested_svm_check_tlb_ctl(u8 tlb_ctl)
>   {
>   	/* Nested FLUSHBYASID is not supported yet.  */
>   	switch(tlb_ctl) {
> @@ -240,7 +240,7 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>   					   IOPM_SIZE)))
>   		return false;
>   
> -	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
> +	if (CC(!nested_svm_check_tlb_ctl(control->tlb_ctl)))
>   		return false;
>   
>   	return true;


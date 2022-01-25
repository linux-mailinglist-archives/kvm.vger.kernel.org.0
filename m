Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C804949B8C1
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583673AbiAYQdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:33:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1453748AbiAYQbL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:31:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReaBFbcLhGuXS2ueJc4WerhmCTBoSrJa8O+uDsGwdwU=;
        b=DUjzoNQLvTr9EuzR426/7cCvOxZfjOHfd1iZswoUj5o6CoRc8rw31vznHUD8z/Ak+2g6bG
        /4UaOyDyHPH98LE1lbecR55iDgU6AfSD2zkiguommTHQW0CGk+cN+w++VE/fppC7lNo+nh
        oI9K5kGiwqAAhoewMC5SngRXLPsTzec=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-rIKYOw5dNceYdb-Q72dXMw-1; Tue, 25 Jan 2022 11:31:09 -0500
X-MC-Unique: rIKYOw5dNceYdb-Q72dXMw-1
Received: by mail-ed1-f69.google.com with SMTP id k5-20020a508ac5000000b00408dec8390aso2609771edk.13
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:31:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ReaBFbcLhGuXS2ueJc4WerhmCTBoSrJa8O+uDsGwdwU=;
        b=cCTKyg789rc9vqycC7jWLC9DNimlf7jNyeEE2e8KQtkVlKOYoht14kRlNxdHKsCsHS
         8I61ikxIRJw0Li4cwZPUZGh7xNDPqVlkIRKDcoR0NfpAXdWsu14vLgpxdzvUNIsKpc5M
         fnffKwuB4zJZlJDTjt+I3zmGVMt/zlmkuaGYWeaI2HhFQeiiJs21qd61us75vnnre4dP
         iwCK+TSxMWXNNDL3UNhsmb7Mpvm4kDN7dvmhHri6HUAPU0MknTFYNVK5CAyPgxgwgI9j
         b8vqY9YA3Y5YW+FI6oeywv1Ty7yZsRe6APgreHy2habFDKr+FaAAC2HLBlDVU7rMl4vc
         /Jjg==
X-Gm-Message-State: AOAM533+IHsWunF2I9UR3ZAvBu9hbClIZZfVoDRf1QAq4qp8hD60GkcO
        1m756ptS3VrH2B1lHT4hmlO8mIxh2bYzLJCbGf9RQvAsEXchh3nB6W0rZIHoSmuDB5s2WEm1rrz
        DhIhUmDlqwbsH
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr3245503ejc.117.1643128268317;
        Tue, 25 Jan 2022 08:31:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzhPjvYjqPGvGy/MBqxMjdO2IyfjnQJkOdM0pGh2VfimaHz7DdDd6i5qmMSQiyP7HIsTj0pw==
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr3245486ejc.117.1643128268135;
        Tue, 25 Jan 2022 08:31:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h19sm2158726edv.90.2022.01.25.08.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:31:07 -0800 (PST)
Message-ID: <5c5e274f-a09c-8a90-f7b1-51f969dd4c2d@redhat.com>
Date:   Tue, 25 Jan 2022 17:31:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 16/19] KVM: x86: Remove unused "vcpu" of
 kvm_arch_tsc_has_attr()
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
 <20220125095909.38122-17-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125095909.38122-17-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 10:59, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The "struct kvm_vcpu *vcpu" parameter of kvm_arch_tsc_has_attr()
> is not used, so remove it. No functional change intended.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index df46d0737b85..22b73b918884 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5003,8 +5003,7 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> -static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
> -				 struct kvm_device_attr *attr)
> +static int kvm_arch_tsc_has_attr(struct kvm_device_attr *attr)
>   {
>   	int r;
>   
> @@ -5099,7 +5098,7 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
>   
>   	switch (ioctl) {
>   	case KVM_HAS_DEVICE_ATTR:
> -		r = kvm_arch_tsc_has_attr(vcpu, &attr);
> +		r = kvm_arch_tsc_has_attr(&attr);
>   		break;
>   	case KVM_GET_DEVICE_ATTR:
>   		r = kvm_arch_tsc_get_attr(vcpu, &attr);

I can't make my mind on this.  I think it's better to have the argument 
in case some attributes depend on VM capabilities in the future.

Paolo


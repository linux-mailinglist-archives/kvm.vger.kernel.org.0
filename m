Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B75436837
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhJUQp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 12:45:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231644AbhJUQp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 12:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634834620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5v94nwDg9QYxMvOs0730j3EnVKA5L8JlNmCKy7RXcVo=;
        b=ewQFiVACwkVsjrPzlln/nKVuhV4DbYUQUiveO/4tRJvPKU5I9Mcx+8ybC3LQYtGzG0RB1V
        76fkpWfSDDDnXdZNU77yei+T44gZ3zsPsEGzbo+fWkJSEQ8rKbl0X9CIk2PvcIVPwHnLlo
        vAjJZyM7KnsOOivnul92aoTUohSHAAo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-Yf6CasZoPdOHLv6Wa7CK3A-1; Thu, 21 Oct 2021 12:43:38 -0400
X-MC-Unique: Yf6CasZoPdOHLv6Wa7CK3A-1
Received: by mail-ed1-f72.google.com with SMTP id z20-20020a05640240d400b003dce046ab51so941839edb.14
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 09:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5v94nwDg9QYxMvOs0730j3EnVKA5L8JlNmCKy7RXcVo=;
        b=U6EautHgni8SYM9qD5K5qXdRJI5EV+/4+XSHO6Q+2/+Kh1CBdeOJcdoReY0LTf6O7X
         kV0YrW4YTz1Xuo7DaS61C3FonTVilWVEVmyp+BK8TkoYx5RE+ZahPwiEsYj9Q3i/T91J
         KObMveu4kfdrOsW85V2wfrXO5WqNhHi9uDPwiz4+DTrZRNJl6VhJap+JoOQt6KG+EJQb
         xzjKv6ThMhv2dbxXdP1ex2aECCigvTrEbkUGdYQCs3ecsI50InKbKsT5ZiXtUJgZerBY
         FPK8Pcn7C+KL84jIllvb+B0KNb2eNzluJAQ+ybfxXpHRfhjXyKlFXrSDhvWPEPP4A2PL
         aPVA==
X-Gm-Message-State: AOAM532on5CVEslDWsE7d9dowPnMyEjt7UJSCL0I7jKe94WKqn9Ji1H0
        yOLxABwuoVpcQaFefjW0qslvxpvcV1gruktSByAR7lKRn+ITe8RGznNeciQlJ6JYkePuZU9wagO
        KDJDdAVK3aoV/
X-Received: by 2002:a17:906:c205:: with SMTP id d5mr8292125ejz.528.1634834617406;
        Thu, 21 Oct 2021 09:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfehaFfyd8KGE6ZUi8glSF5BUqch1ZEmK7sOS5K6SxFsvXMKYwALWwixyVigPDtGePBh8y0g==
X-Received: by 2002:a17:906:c205:: with SMTP id d5mr8292097ejz.528.1634834617172;
        Thu, 21 Oct 2021 09:43:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o12sm3108914edw.84.2021.10.21.09.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 09:43:36 -0700 (PDT)
Message-ID: <1661def3-45d1-9aab-aeb4-5b934179d3ab@redhat.com>
Date:   Thu, 21 Oct 2021 18:43:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 08/16] KVM: SVM: include CR3 in initial VMSA state for
 SEV-ES guests
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>,
        linux-kselftest@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
References: <20211005234459.430873-1-michael.roth@amd.com>
 <20211006203747.13479-1-michael.roth@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006203747.13479-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 22:37, Michael Roth wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c1a2dd0024b2..d724fa185bef 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10400,8 +10400,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
>   
>   	vcpu->arch.cr2 = sregs->cr2;
>   	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
> -	vcpu->arch.cr3 = sregs->cr3;
> -	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> +	static_call(kvm_x86_set_cr3)(vcpu, sregs->cr3);
>   
>   	kvm_set_cr8(vcpu, sregs->cr8);
>   
> 

Can you instead make the hook "post_set_sregs", and keep these two lines 
in __set_sregs_common?

Thanks,

Paolo


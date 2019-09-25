Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC3BDF05
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391558AbfIYNbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391508AbfIYNbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:31:33 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9496E5117D
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 13:31:32 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id s19so2077535wmj.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HbTRgs4ZwTBdvJESliM5GK5A8G5L+4nogU+I4sznOA=;
        b=NktjQICsUyGplqeMR7gcHmLB8nwkZQighQLaND4CMwsjgK8J9cTJP1oRaw6eQnHVYN
         h1JTtmt+RO3kM6rsqw9ApYo/pX/OgpZ53XUWGLy6C+qnZay5GTUa0EaaAHp2t3I4Eso1
         wnzKViDshtUYLaKhgGYWUbrjX8ej8PYA3s5MbJV/MZ42Utsc6+N4FMpZ8OnFsJGcTlsT
         W3F8tSpPt80/2muW5gtFZbcCUjEgXw6+nO/c35PN5XDynI3Q7Bdz4UrXLD5yDqKdLCfl
         qJveAW+wUFdLvPQmgCo0TyS5ocIAtHxVyyx2tp9JiSa+MjzWghOOMfcLyXHBhKPG1MvQ
         /WFw==
X-Gm-Message-State: APjAAAXp+CdACfjl1fpe0xhZLBS+50EL2UJ/zqxrRxuX407E2Rs6ZPwA
        eksaLVFZ163PWtYn0PVIczrIigfjkURlNB7lYX9TH4+czQxgfk7PPdpwDb8TUecFFqds4UwHKqM
        QRLbrkSkE5q4E
X-Received: by 2002:adf:e392:: with SMTP id e18mr9131923wrm.87.1569418291256;
        Wed, 25 Sep 2019 06:31:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwAwrqt6cqOZT+pbnFbG1k738GvnZ33vFNLMbkxyi7H/nPq5zKKsf7SGWlbYT53E8q7HgKA0A==
X-Received: by 2002:adf:e392:: with SMTP id e18mr9131904wrm.87.1569418290977;
        Wed, 25 Sep 2019 06:31:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id g185sm6562186wme.10.2019.09.25.06.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:31:30 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: vmx: fix build warnings in
 hv_enable_direct_tlbflush() on i386
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
References: <20190925133035.7576-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ed9d9b67-0d2b-fc08-e5f3-5a8dcca0ef1c@redhat.com>
Date:   Wed, 25 Sep 2019 15:31:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925133035.7576-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 15:30, Vitaly Kuznetsov wrote:
> The following was reported on i386:
> 
>   arch/x86/kvm/vmx/vmx.c: In function 'hv_enable_direct_tlbflush':
>   arch/x86/kvm/vmx/vmx.c:503:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> pr_debugs() in this function are  more or less useless, let's just
> remove them. evmcs->hv_vm_id can use 'unsigned long' instead of 'u64'.
> 
> Also, simplify the code a little bit.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a7c9922e3905..d5b978068209 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -495,23 +495,19 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  	 * Synthetic VM-Exit is not enabled in current code and so All
>  	 * evmcs in singe VM shares same assist page.
>  	 */
> -	if (!*p_hv_pa_pg) {
> +	if (!*p_hv_pa_pg)
>  		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -		if (!*p_hv_pa_pg)
> -			return -ENOMEM;
> -		pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
> -		       (u64)&vcpu->kvm);
> -	}
> +
> +	if (!*p_hv_pa_pg)
> +		return -ENOMEM;
>  
>  	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
>  
>  	evmcs->partition_assist_page =
>  		__pa(*p_hv_pa_pg);
> -	evmcs->hv_vm_id = (u64)vcpu->kvm;
> +	evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
>  	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
>  
> -	pr_debug("KVM: Hyper-V: enabled DIRECT flush for %llx\n",
> -		 (u64)vcpu->kvm);
>  	return 0;
>  }
>  
> 

Queued, thanks.

Paolo

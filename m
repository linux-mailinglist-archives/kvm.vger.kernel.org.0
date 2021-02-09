Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12052314B8B
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 10:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhBIJ0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 04:26:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230198AbhBIJXi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 04:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612862531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLJXL0fbef5ZhSy7tA+pbwvz1MlswubwVD2OJTOPiME=;
        b=DI8dXJGmeZtzgu3rT+IV66xG0E6c0MkA5U1NcryWoOlywvIMw5I1+td5UVHH1sRyOANzzX
        LyADIV3Ndyq9jWi4bV0DyACZmI4GqDac+z4Jdl06kkkF73lNMUkGymvrs/LjU1z5pUZ+Jo
        eByCywj3XzG4NXKSa1fqQucfoeGduO8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-PAyyOPr6OgeudLMCjWOlqQ-1; Tue, 09 Feb 2021 04:22:09 -0500
X-MC-Unique: PAyyOPr6OgeudLMCjWOlqQ-1
Received: by mail-wr1-f70.google.com with SMTP id u15so16459896wrn.3
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 01:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLJXL0fbef5ZhSy7tA+pbwvz1MlswubwVD2OJTOPiME=;
        b=DzBub790RNLPIPbdxTwz8t4zTy2Bek7+qxt7feWuDiIT+cZnhUSTWwtJj/s4FST6fw
         7fXSQrNeL3SPq1qLa5mDewS9H131exyYoDzHCe/XUhWU1BeTIO5wnLjQRxQtSiVam+ua
         trkevTYLLU92mA8eLixmbfIqe+QYAXI+N657enPQ9C93+gsAIXYUPumAAz96vry2f7iy
         Uhlx+/e2O309ykXI69xgv+H8tjfi6YfbgXgsPUf2j5X/7j6WVS7p5USzM2D+iSUIRPdG
         pLwd++DHjmma1f77bVrEGe12bQaokK3mG3qnGISqzBe5yKX5bneAph8yesBov/QDT5vD
         FuEA==
X-Gm-Message-State: AOAM532YDQrj5DNUsM/potYIKeKRd1e6Ua8E7KfBnb3alMR/J/9CvtPk
        9azzNtfTlNXniohnDQgLZdl3q0Jf/b/owdbKGHl5UeenUEbj/AGobUuFAz6cuhZJ5xeYVfrcrZw
        PwaQs/Zi/lFhL
X-Received: by 2002:a1c:2143:: with SMTP id h64mr2470881wmh.60.1612862528688;
        Tue, 09 Feb 2021 01:22:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkMCs5uQpjL/srq3+PF7FLK8YUY8Ts39302ljk4yTFV8t2/V0uFg6R+sRtIXpKbtXwONjLsQ==
X-Received: by 2002:a1c:2143:: with SMTP id h64mr2470867wmh.60.1612862528511;
        Tue, 09 Feb 2021 01:22:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t15sm3221252wmi.48.2021.02.09.01.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 01:22:07 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/xen: Use hva_t for holding hypercall page
 address
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210208201502.1239867-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c37dad6-c869-b66d-f8e6-2ba7c1591556@redhat.com>
Date:   Tue, 9 Feb 2021 10:22:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208201502.1239867-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 21:15, Sean Christopherson wrote:
> Use hva_t, a.k.a. unsigned long, for the local variable that holds the
> hypercall page address.  On 32-bit KVM, gcc complains about using a u64
> due to the implicit cast from a 64-bit value to a 32-bit pointer.
> 
>    arch/x86/kvm/xen.c: In function ‘kvm_xen_write_hypercall_page’:
>    arch/x86/kvm/xen.c:300:22: error: cast to pointer from integer of
>                               different size [-Werror=int-to-pointer-cast]
>    300 |   page = memdup_user((u8 __user *)blob_addr, PAGE_SIZE);
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 2cee0376455c..deda1ba8c18a 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -286,8 +286,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   				return 1;
>   		}
>   	} else {
> -		u64 blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
> -				   : kvm->arch.xen_hvm_config.blob_addr_32;
> +		/*
> +		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
> +		 * false for a 32-bit kernel, i.e. when hva_t is only 4 bytes.
> +		 */
> +		hva_t blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
> +				     : kvm->arch.xen_hvm_config.blob_addr_32;
>   		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
>   				  : kvm->arch.xen_hvm_config.blob_size_32;
>   		u8 *page;
> 

Queued, thanks.

Paolo


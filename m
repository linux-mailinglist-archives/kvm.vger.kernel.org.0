Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E24F423CC5
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhJFL1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238432AbhJFLZO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+j8kGyfSEc1b5J6pZ1nvHDgoskjSsEnkTn7JsOcRG8=;
        b=ifnbneA+dTYkcaq71YZKn7HwC6W5dPZwlEQYOh5INZWHmCf9CbC3evmcaKuF0yi+jvweeI
        TvCshIXU3ib8Fav5nB0O45YCF8jrN0JbvP38HHD3LiS7PiHjsWFlb1FXwAkBSnSdT9g8N/
        cBk0pn9f2n5eDv6FRW1GiQ9xCTMJiZo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-M3iqIKESMTOSc4cXYTDlZw-1; Wed, 06 Oct 2021 07:23:20 -0400
X-MC-Unique: M3iqIKESMTOSc4cXYTDlZw-1
Received: by mail-ed1-f69.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso2358904edi.1
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K+j8kGyfSEc1b5J6pZ1nvHDgoskjSsEnkTn7JsOcRG8=;
        b=cImZlH4KsdLbbcJ9hjrztIJ7tGsFp28PgwpDXpfpOCNnWVsx4gOCrkZE0gpAnnzhhH
         v6cVQUCXqmgfP98BRDiIwXuZq6BcvMJB4Hp6MrJ49n3AgNJBrh+3D6V9s2BxkJIALCtr
         IejZ5WGT0P2/wUwJZs5/P8ALOY8H/SYQc9166T17n8ztK3n4TY0PDCbvb+4WhygtW3BL
         AhJ29tVDlKOBBzTH3xtK9t+LhNmwfNGb+IyA669us0rk2D9koJKjnE2Uvg6/H2Ogo97p
         Q4xBPJTVtfaGQdXfCm2Ggr6CjKq724jaRw/A6W68qYV2/DFw2gBwfCxtVMbnuKnZc84t
         kTyw==
X-Gm-Message-State: AOAM532lqTcRUYJdzWq/hSGcJAQ+2rL2lszm9Jp4BHO2lBJiANKo1+Kv
        AZ5Yq8Jj5H2uYpkW46orOFr8dNOacx919/i8PSpy15cAKgUP/qifbnbGgNsZ/If2EBxnuaxH1Mh
        P9EkmGlW+x3Wq
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr30836880ejc.134.1633519399604;
        Wed, 06 Oct 2021 04:23:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSbrR9RR6C4+3Fp2VVhrEAk9547+8U10Y9UDSOeD6CeQ+ifciYYe5Ljeu4bqSDszAHdpZXPA==
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr30836865ejc.134.1633519399407;
        Wed, 06 Oct 2021 04:23:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s3sm8842345eja.87.2021.10.06.04.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:18 -0700 (PDT)
Message-ID: <f4abdd97-d451-f689-75c4-26d412bcc920@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 6/7] KVM: x86: nSVM: restore int_vector in
 svm_clear_vintr
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
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
> index 1c23aee3778c..5e1d7396a6b8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1497,6 +1497,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>   			(svm->nested.ctl.int_ctl & V_TPR_MASK));
>   		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
>   			V_IRQ_INJECTION_BITS_MASK;
> +
> +		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
>   	}
>   
>   	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


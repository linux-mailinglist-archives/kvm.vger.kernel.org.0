Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137591E7AE0
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgE2KrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 06:47:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgE2KrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 06:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590749219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZyzBn3kN44DFoEairny9wYPI8hbjny9xpu0cs3OwKg=;
        b=c6NLU0q/mOwDHLTD4UmUoYb5xIBYKgY5+Hk9w6hKpLxD2tr168QsO/c46SiOSAMQEZO4nA
        VvOPkAR/IMftDFfY7vHQFDkhqbVminhc54q4KabJTVEK1bS3bcZ9Cl+UGm3bR4O4UEKOoB
        SogbMxwmnD+q9LRSZaDY/IhUUQ5kvJs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-KZL_ehNtPx6xSmLDVHXA8Q-1; Fri, 29 May 2020 06:46:57 -0400
X-MC-Unique: KZL_ehNtPx6xSmLDVHXA8Q-1
Received: by mail-wm1-f71.google.com with SMTP id b63so2452176wme.1
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 03:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ZyzBn3kN44DFoEairny9wYPI8hbjny9xpu0cs3OwKg=;
        b=IpgRMFC3tq9FrpKgml8KPipFET7GEfXTPg16T4bsZ2xSBxfKkJ3dM4dCL4bmlkZi/w
         psQBBvnVP8qY4V6iDByeBLaaa6dHjuOFP106KY1qxoVOOVtRDK99G2aF2m9c6A6YtqHM
         AJLe7Qq+yn0GdoRSxHkiVwBb+7EtOuRijZJy08cTRf6RrtR82z7zaM31WOAQENR8e5qM
         c5cUQ/HoGJ1WrMRFneryv2R8Eftb2a9WB84l0/tObJWhHgvnsDPGMPzWqTvuDgmsqvYp
         1EyMmnO75rjeRnHMgYyqSoBLea09xSPtXjOjOUgYOXTNy06V8E60ud7wqk5fT1an+Sv9
         uO4Q==
X-Gm-Message-State: AOAM5337ZanbyTHqhwpbLcAj2GeYtfriceX+iTKg83bsidLcIrf8oEfD
        URIJF28mnxrln9E7BJ2DuZ7+3whHW80qh6oobeIoU4jArtvl/O/bTfk5KTkspwFdsYOKjyc6gID
        nlSMnxKRKQBHz
X-Received: by 2002:adf:eb47:: with SMTP id u7mr8080975wrn.14.1590749216772;
        Fri, 29 May 2020 03:46:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNhQ9hgZbqSGo6sl++puYpTtIz8IbEag41ylRf1VuiwlQ/i6x9UvRQaKcyQ6yqMpbfGSY4jQ==
X-Received: by 2002:adf:eb47:: with SMTP id u7mr8080963wrn.14.1590749216587;
        Fri, 29 May 2020 03:46:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id u3sm11928336wmg.38.2020.05.29.03.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 03:46:55 -0700 (PDT)
Subject: Re: [PATCH v11 4/7] x86/kvm/hyper-v: Add support for synthetic
 debugger capability
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-5-arilou@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <12df4348-3dc1-a4cc-aa41-4492cd42dcc8@redhat.com>
Date:   Fri, 29 May 2020 12:46:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424113746.3473563-5-arilou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 13:37, Jon Doron wrote:
> +static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +	if (!syndbg->active && !host)
> +		return 1;
> +

One small thing: is the ENABLE_CAP and active field needed?  Can you
just check if the guest has the syndbg CPUID bits set?

Thanks,

Paolo


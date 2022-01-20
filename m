Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17024952F7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377259AbiATRNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377256AbiATRNq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 12:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642698825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fC9Rz1nl0EcRlodZgKlLvJmeGdyFjLwk5wksOksI7Rg=;
        b=EfwNF0r2WqjSCgXBiAmPNLF6LNfZqJLyqaecVr81p8SxC9NeEnH/MqEHBYl4wAaozLOlro
        h3Ads0Uv2D9Q2Z3jKsXz+SW58IYm87/fee/U8e22spFaX7ihJQ0cObh1WeRFM+qg6okZlA
        LuJFhviQ1ijkrxaR3evRktMAVZi+F6Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-MLc_PjorPb22oa9k3AQ6VA-1; Thu, 20 Jan 2022 12:13:41 -0500
X-MC-Unique: MLc_PjorPb22oa9k3AQ6VA-1
Received: by mail-wm1-f72.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso7317992wmq.6
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fC9Rz1nl0EcRlodZgKlLvJmeGdyFjLwk5wksOksI7Rg=;
        b=GI1VABQBli5AMZmZcu7wK2uIwmJqGBNUMkF8zEeStjkL21ePuk+kTzyK8dSLvv+UuV
         NWMv4ZP60uGSV8SUnVa/sRJZX1HwF5VrZ1TQDKPenpjNjs8vDebhKnvL8++10UkZnDO4
         eX9X7ZnqZ+m67ywwgZCt3LrhveDp5FEzFWSFz3qjsxaloCssJFw0hQCAiFaMoZAudpI8
         Hl8QNog2c3+yEA7r/LV8fMR0phjnGmLvJx4VCwp6O81JpIqBtFnrz+AwSMybzjFsJWw0
         mlbcBmZ9ue+xGM6sS3gzpc1IQDsVbP9tN4jk8nrtilSe7sLG1q10Ff/Zbb97W54t1RRX
         gyHA==
X-Gm-Message-State: AOAM531GJexrEAlYaczD3q+oOJlBzENBzRLhzoIbf04vrd/qAiQHuhzJ
        28M+7A+eLKeM0vFAh8K5EBeJmAz0EA7KVgx24p8DvYg4H5sJ0BIOr1kWkZ6bIHDj9508kRfGvOS
        bkonE8icSHeXW
X-Received: by 2002:a05:6000:1c1d:: with SMTP id ba29mr44921wrb.78.1642698820504;
        Thu, 20 Jan 2022 09:13:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSRCeywcM8eh72JNxUN49HsBHUyB5WOOk/6NBHCfm9T8/pz+/9qoxd3PuDX/ZTwiwJwLUUSw==
X-Received: by 2002:a05:6000:1c1d:: with SMTP id ba29mr44901wrb.78.1642698820240;
        Thu, 20 Jan 2022 09:13:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a18sm3616586wrw.5.2022.01.20.09.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 09:13:39 -0800 (PST)
Message-ID: <39bb00be-e4e4-1eb5-de25-192d66aa2bc4@redhat.com>
Date:   Thu, 20 Jan 2022 18:13:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] docs: kvm: fix WARNINGs from api.rst
Content-Language: en-US
To:     Wei Wang <wei.w.wang@intel.com>, sfr@canb.auug.org.au
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220120045003.315177-1-wei.w.wang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220120045003.315177-1-wei.w.wang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 05:50, Wei Wang wrote:
> Use the api number 134 for KVM_GET_XSAVE2, instead of 42, which has been
> used by KVM_GET_XSAVE.
> Also, fix the WARNINGs of the underlines being too short.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>   Documentation/virt/kvm/api.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d3791a14eb9a..bb8cfddbb22d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5545,8 +5545,8 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
>   The Stats Data block contains an array of 64-bit values in the same order
>   as the descriptors in Descriptors block.
>   
> -4.42 KVM_GET_XSAVE2
> -------------------
> +4.134 KVM_GET_XSAVE2
> +--------------------
>   
>   :Capability: KVM_CAP_XSAVE2
>   :Architectures: x86
> @@ -7363,7 +7363,7 @@ trap and emulate MSRs that are outside of the scope of KVM as well as
>   limit the attack surface on KVM's MSR emulation code.
>   
>   8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
> ------------------------------
> +-------------------------------------
>   
>   Architectures: x86
>   

Queued, thanks.

Paolo


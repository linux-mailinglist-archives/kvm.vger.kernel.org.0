Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF1487C1D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbiAGSVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:21:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240915AbiAGSVX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641579681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6HZu8WA2ydj4C6Y+yks4Ifx8Vim2n8c4t7+gsJ4hSQ=;
        b=MlLommlk4W2f6ZpdG/2V/bj62CMI1NgA14JWcScYYg6PWXhXcwnymLeTG1CAoQVBKIOpLq
        oQzSy8Lc72fRI/FXnraxIO+uDw+fCNQGCnOwallnVAzPu4SOkDaLj0eg0ZpcprBcQZKwY4
        VGBImDTLuR6dq6yACaAnvLGeVmnT/hY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-hbKk_O2iPwOh_jZv8yOcgg-1; Fri, 07 Jan 2022 13:18:10 -0500
X-MC-Unique: hbKk_O2iPwOh_jZv8yOcgg-1
Received: by mail-ed1-f69.google.com with SMTP id m8-20020a056402510800b003f9d22c4d48so5294878edd.21
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 10:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y6HZu8WA2ydj4C6Y+yks4Ifx8Vim2n8c4t7+gsJ4hSQ=;
        b=PCqZ2GaIDOC2s0LlH7+nsCePia73TQdaOIrhceQkrE0MHJki6m1OF8E8CgezwrTTl2
         kt5TnntfOCIKFtmfEBvTS78o76+xixg+DH2AOIILjRdUehvivjEntilTgNO8MCjjwdBF
         DvaIaadA4LBGLCDOK2kiploCZAyGX5FQp+PNGuTC/M3Db7UkH9jJh29q1XsW7hztuQBp
         xtNWMvM/RElzjDkL/iMUSdxuj78V927eOA9TDJuGVjX88JPpiexVPw0aXzkqgYu0GdKF
         xfKa1/+DMfBM5qBzanCrrpr5lMXvtEj+LUv5EgYN2TgtfdfYCUJW2anjZqvWyDrVVc6V
         bYeg==
X-Gm-Message-State: AOAM5328jBtHfwYKWpGSgquMlKGYJXVO/7zTW2ctXJviujDQc74t7FQ/
        GP68NtmAKEV2dwvS1PjTDGJMvG3+xnzHlSZyRQJywT17aP0oPH3tu0iHQBua+r0QGJ8HeNar/YR
        JmYHw5dfmMRW+
X-Received: by 2002:a17:906:70b:: with SMTP id y11mr2268929ejb.364.1641579489096;
        Fri, 07 Jan 2022 10:18:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDYZ4ZBWSaGG8/mC9MAYNxHC55ystbMPGoIQqQuf/pU64IeQg+E8G2TfiSfXyqRSl3ZUx0ag==
X-Received: by 2002:a17:906:70b:: with SMTP id y11mr2268920ejb.364.1641579488887;
        Fri, 07 Jan 2022 10:18:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e18sm2229374edq.77.2022.01.07.10.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 10:18:08 -0800 (PST)
Message-ID: <88aad2b3-8f60-fda4-15fb-81ea712c1dae@redhat.com>
Date:   Fri, 7 Jan 2022 19:18:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/pt: Do not advertise Intel PT Event Trace
 capability
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220106085533.84356-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220106085533.84356-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 09:55, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The Inte PT Event Trace capability (Intel SDM Vol3, 32.2.4 Event Tracing)
> is a new CPU feature that "exposes details about the asynchronous events,
> when they are generated, and when their corresponding software event
> handler completes execution".
> 
> It is not possible for KVM to emulate all events including interrupts,
> VM exits, VM entries, INIT, SIPI events and etc. for guests and to
> emulate the simultaneous writing of Control Flow Events and Event Data
> packets generated by the KVM to the guest PT buffer.
> 
> For KVM, it is best not to advertise the Event Trace feature and just
> let it be a system-wide-only tracing capability.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> Off topic, other new PT features such as "PSB and PMI Preservation Supported"
> and "TNT disable" are under investigation or awaiting host support to move on.

Yeah, I think it's better to be safe and ignore _all_ unknown capabilities.

Paolo

>   arch/x86/kvm/cpuid.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b920e12bb6d..1028c57377e9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -901,6 +901,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			break;
>   		}
>   
> +		/* Not advertise Event Trace capability due to endless emulation */
> +		entry->ebx &= ~BIT(7);
>   		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
>   			if (!do_host_cpuid(array, function, i))
>   				goto out;


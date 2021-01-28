Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65F33075CB
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhA1MR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:17:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231599AbhA1MRU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611836154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrqGJq2riIoD7x6HkWiK3CnGK6BLWjtu07oDAsxWGJY=;
        b=FqJEvr2+Ii+oRDquC0iQgYGurML6dONeiDjBKinqhivtxigpsTbDGnLY9JW7umgiH5MYZk
        f0yVYMlcln2Gm2KyL63akZfYtYqRAf02pdVTDwkALu//JOJh8bNj756qekJxrljTNMHC4l
        /WjJskgTxyu7GJ8KH75GiPaL2YEN4PM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-8bdCfxFBOMqCVVPOf5IkaQ-1; Thu, 28 Jan 2021 07:15:52 -0500
X-MC-Unique: 8bdCfxFBOMqCVVPOf5IkaQ-1
Received: by mail-ej1-f70.google.com with SMTP id le12so2083563ejb.13
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qrqGJq2riIoD7x6HkWiK3CnGK6BLWjtu07oDAsxWGJY=;
        b=EE/3VnB75P7nsYHMgR/E/EYV94SV0lNktk9Dt+0JU9NyW0iLaFfH4xTpf6LmvRVTXR
         LbCYI2qJ/dRCyHJeUMgq41L7w+YOB3OSliRIWefaMUUpsOYnz57qlrw/vOP1xJFabCsq
         TcwbeXy7t4UfOOsasjMvn5/Ksoi5bvf0HTZ49/6miczc8Qvjv9bB98e1pz3z1rZ+G2iV
         KLlOv1qjyNQjNaEnDSJ47YkdKHuHuIjXr7aaWgfRGdwFG+5UcNpWY1i3KplOlf2Qx1zI
         R7GmCZOGyD7g3JcNt/KyFQlEabNxLgE2/3iE6JSNOb94rIxAPBF/baHXJ58+xo1wM8G5
         KlJw==
X-Gm-Message-State: AOAM532fhVab8aMh/3O7HKW9SW8ZgKC4PksSNkRjUMIPF13KJwNYANKI
        O1RYLeqhPg9i5ZB8B7U7UncpKcMUn2thVGnfItuoI9dP1/7ZCKngJOYW60YrET8pIxShNoj5Ysm
        29r5a2R0Gz4oN
X-Received: by 2002:a17:906:e98:: with SMTP id p24mr5656632ejf.67.1611836150912;
        Thu, 28 Jan 2021 04:15:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLCeWhv/rRx6eF7PBwKx6uDPM4fuSDcElccierenfUeb7gSyN1itVJVFlA2G0tEa6oQFQang==
X-Received: by 2002:a17:906:e98:: with SMTP id p24mr5656608ejf.67.1611836150752;
        Thu, 28 Jan 2021 04:15:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s18sm3066240edw.66.2021.01.28.04.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:15:49 -0800 (PST)
Subject: Re: [PATCH v5 13/16] KVM: x86/xen: register runstate info
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-14-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da71c190-ce0a-a1c6-48ac-47f774a703d1@redhat.com>
Date:   Thu, 28 Jan 2021 13:15:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111195725.4601-14-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 20:57, David Woodhouse wrote:
> 
> +		v->arch.xen.runstate_set = true;
> +		v->arch.xen.current_runstate = RUNSTATE_blocked;
> +		v->arch.xen.last_state_ns = ktime_get_ns();

Can you explain current_runstate and also why last_state_ns is not part 
of the struct that userspace gets/sets?

Paolo



> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -157,6 +292,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		}
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		if (v->arch.xen.runstate_set) {
> +			data->u.vcpu_attr.gpa = v->arch.xen.runstate_cache.gpa;
> +			r = 0;
> +		}
> +		break;


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999B0423C9F
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbhJFLZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238285AbhJFLZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHNPWvH8IdSItCatEhURToP4NiNrO6JvBUwAheoZRXE=;
        b=E8BBYGua+gyOVT1LY8055TTH6alTmP156uTNKrravlCsaZKCuZMJyHhL234f98IMDMqOop
        EselYh2P7G9eL17qzUMNzUbE7KuxtDLEiQjQuCibiqn6r/7piJmYAmFaZzE+J6qCJhxjBN
        xCVPwVKuoxTK0B4qZo96mx1mbu5fURo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-GJLZaJfDO7W-u0jBEWxvzg-1; Wed, 06 Oct 2021 07:23:07 -0400
X-MC-Unique: GJLZaJfDO7W-u0jBEWxvzg-1
Received: by mail-ed1-f70.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso2331898edf.7
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IHNPWvH8IdSItCatEhURToP4NiNrO6JvBUwAheoZRXE=;
        b=0fD2iuFd13eMn4DqMGZ3WB9Zrt8PNr+hR1rxEebcDN++rZtJDrGQQockmKD1Xl5zK7
         HjvI7j/E0uPaHR+jxt5g0Juh3CqNcqJHcJONDu/o5mCzexUW82bRZvdFrpKK64MivFh2
         +Tlh6lDmFgi3t0v9fJ1ACOkhaNK4OpF022gT46TTTP4QQfz0DgkK3ijg/d5iufXzrp5l
         U9Ps5NLvR7W/zwbyBKUr71Vd1E3o9G6ac+QEV8wA+UJjapzaTaNUwdSc5aQfvTmqM9+1
         dpfRJKed8C3KSSI/eScoaOPNJzVJ716P44mfuDirVjXJLf8CUG5IsyGX0MwWPTjOhZqI
         pXQw==
X-Gm-Message-State: AOAM533mmNhRmCtjQi/4X9JmXZEQydlI/AdvifGznIDvm3ciOnl1q/PW
        hYrPFlaOpx/YGiSCeJ0ewF21nXWjEMAAqiFiqUHwuZPO/rfgen3pJIpNFESwD93FLZIS5kq7dER
        sCE5pmToTTzvW
X-Received: by 2002:a17:906:280f:: with SMTP id r15mr30187275ejc.559.1633519386422;
        Wed, 06 Oct 2021 04:23:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1R5OiDfTUFCbiGI85SCjOZAdyXVSTkog8lUinznoJ4IdzInmYSLsZl+IRVq4M3m708noiMw==
X-Received: by 2002:a17:906:280f:: with SMTP id r15mr30187247ejc.559.1633519386187;
        Wed, 06 Oct 2021 04:23:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r22sm4669140ejd.109.2021.10.06.04.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:05 -0700 (PDT)
Message-ID: <9664819e-a767-3a92-5e5d-6a0418984cd4@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 3/7] KVM: do not shrink halt_poll_ns below
 grow_start
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> [ Upstream commit ae232ea460888dc5a8b37e840c553b02521fbf18 ]
> 
> grow_halt_poll_ns() ignores values between 0 and
> halt_poll_ns_grow_start (10000 by default). However,
> when we shrink halt_poll_ns we may fall way below
> halt_poll_ns_grow_start and endup with halt_poll_ns
> values that don't make a lot of sense: like 1 or 9,
> or 19.
> 
> VCPU1 trace (halt_poll_ns_shrink equals 2):
> 
> VCPU1 grow 10000
> VCPU1 shrink 5000
> VCPU1 shrink 2500
> VCPU1 shrink 1250
> VCPU1 shrink 625
> VCPU1 shrink 312
> VCPU1 shrink 156
> VCPU1 shrink 78
> VCPU1 shrink 39
> VCPU1 shrink 19
> VCPU1 shrink 9
> VCPU1 shrink 4
> 
> Mirror what grow_halt_poll_ns() does and set halt_poll_ns
> to 0 as soon as new shrink-ed halt_poll_ns value falls
> below halt_poll_ns_grow_start.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20210902031100.252080-1-senozhatsky@chromium.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0e4310c415a8..57c0c3b18bde 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2756,15 +2756,19 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>   
>   static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
>   {
> -	unsigned int old, val, shrink;
> +	unsigned int old, val, shrink, grow_start;
>   
>   	old = val = vcpu->halt_poll_ns;
>   	shrink = READ_ONCE(halt_poll_ns_shrink);
> +	grow_start = READ_ONCE(halt_poll_ns_grow_start);
>   	if (shrink == 0)
>   		val = 0;
>   	else
>   		val /= shrink;
>   
> +	if (val < grow_start)
> +		val = 0;
> +
>   	vcpu->halt_poll_ns = val;
>   	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


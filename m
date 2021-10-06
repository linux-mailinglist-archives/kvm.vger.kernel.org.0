Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE792423CB7
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhJFLZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238640AbhJFLZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXB7eOJ4jU1YE2+TG3vqwnVpm5fFk9vucXP1hsFqMZs=;
        b=hNoyujBkWPiO1/+VpDBlwRthM4A2uBUyAAfqWjBbTV42N1zTbuuU5uclLcFt1UpIOJerFs
        sdFPr6GTbc2VMHJONvVH/W2SOnIhlGIFgpp20Si6PGsfnTHlCsrReSuBoXZk6YierI1DT4
        cEp/oAX6AmMDuBBLJRi8vIgnABxBHcE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-y3ePA07EO22Gx2fY41Bvew-1; Wed, 06 Oct 2021 07:23:37 -0400
X-MC-Unique: y3ePA07EO22Gx2fY41Bvew-1
Received: by mail-ed1-f72.google.com with SMTP id p13-20020a056402044d00b003db3256e4f2so2360811edw.3
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XXB7eOJ4jU1YE2+TG3vqwnVpm5fFk9vucXP1hsFqMZs=;
        b=sMKB2oVbjxHJEzBRfziiop1vN3vs+n0O/0cTqvMW2MTLB8dePWGSErrfHGwI3ai/UO
         MOg8lASKLwO7zvxEVX/7dT58y6mqxXRxzUumYZmCJNs4u0/SbOFm5MY7xH76pb4rCkim
         HPRvge/I3liNpi64t7WFlBLPwUhV2z67+x0Q6GKn5o7tKXlGCkDH5FGG5arkYoRKGTe4
         zCzQ24O/AXseTuXEqWxbTOVekwZdo+9oIVgrbVKpQSt0LELVuTKqdefsQGSm47tsoAhy
         5kkeunu5QZTUt1RVSTexEmJJxbu5L6bmDe+IWHn8R+GZ1pddwPMl2qNGKjKqaOmnHlQa
         e6Ag==
X-Gm-Message-State: AOAM532m8BVuwj0UIHAhM/k70j/xQkQl5snMkoiCKU3ZOxyzoB5k0G4B
        IQmMpIL1JcOzuVG26zJoBdFyvzdtfdeqp2g9YohxXWtDK0HJWKmVsAMf1PI1CNXsDQsgkrBZD6t
        XQXrosw7qL1mS
X-Received: by 2002:a05:6402:12c2:: with SMTP id k2mr7524613edx.210.1633519416595;
        Wed, 06 Oct 2021 04:23:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz63vEemX7QVRga6psJR5nHqQw5FSKT4d2mILsiOy+xV/h9VWWZ+iAXJYGMVQ6X5F4KPwNHag==
X-Received: by 2002:a05:6402:12c2:: with SMTP id k2mr7524593edx.210.1633519416406;
        Wed, 06 Oct 2021 04:23:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h9sm7534331edr.67.2021.10.06.04.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:35 -0700 (PDT)
Message-ID: <6991b886-180f-de65-42c7-48c9c0b813b0@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.4 2/4] KVM: do not shrink halt_poll_ns below
 grow_start
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org
References: <20211006111250.264294-1-sashal@kernel.org>
 <20211006111250.264294-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111250.264294-2-sashal@kernel.org>
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
> index 77f84cbca740..f31976010622 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2470,15 +2470,19 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
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


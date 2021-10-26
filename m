Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731AA43B6A9
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhJZQRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234604AbhJZQRD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635264879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAAzOJIZshLT5gRfcvPfI+wHgBi/Zbeh5mViB3wqN9Y=;
        b=O/lDzm7zZYqbdiM1iFXgFqqruPyAljILclxOJXGiQgsYFLR62kPq69THQPjipJr6kbER8a
        hfyR7N0EoUCYeJLA+nTj7nFyrwuNw5FhXzFbtHv8V/NtvcjvzOx7/GBGkjTMtHhLeluxwR
        oq4E70Ce2H1+NDhXJXoxtvyOzHVgbBw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-2YHOAsHFOg28q_oCFbklNg-1; Tue, 26 Oct 2021 12:14:37 -0400
X-MC-Unique: 2YHOAsHFOg28q_oCFbklNg-1
Received: by mail-ed1-f72.google.com with SMTP id f4-20020a50e084000000b003db585bc274so2810422edl.17
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nAAzOJIZshLT5gRfcvPfI+wHgBi/Zbeh5mViB3wqN9Y=;
        b=IlIpCi0zKHQy9Oiah4mICYWczMOfszWlXlWl9jHxbp5a3qRNsMyCqSocGSJ2NqzER9
         XdmSTspo9GZBi6N0kBuxJmanZQTcWwr5kTO54n3H4e6kWrvQ7NqS9KS+MUSBr7q+ZAZb
         Z2Fa0t2FpH0BfmPjFOL9ejbNHhIKJTTcBPYIgYfXsqC8EqpVhG3A1Kp6eXQjQCUb2x/m
         XZOLTXZrMh8VKw48GQKfDh406rmd4Q1BOYclfYLS7PYkiVsOmou2TtEaCGTdVAN1Crku
         8/aUpnxT9rIPGvcL1YaS/YSRE2uui78K2obZP1crgc62mIcP5UpGYa1Oj2rJMuX4/y0F
         SKyg==
X-Gm-Message-State: AOAM532PtFjQjX3y9HM+05CsMRrOZIqakVd5FN8kKYNIDgU+9vDSqe0X
        7VzscsQZG78d63P94ENFCfeb91OaGXsPcYChzoncFEwiCyr5uanvqFYDQvR7os3hr5qOtBN+Ngr
        LKGdZDNBxny13
X-Received: by 2002:a17:906:2bd5:: with SMTP id n21mr31835023ejg.337.1635264876465;
        Tue, 26 Oct 2021 09:14:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsmXT1S2dUXbLniu/Vt6Q3qHqeqq2MVl17CxSLBokD1O3xPho3oeqmwVbFxih2dz8J6zWXgA==
X-Received: by 2002:a17:906:2bd5:: with SMTP id n21mr31834996ejg.337.1635264876220;
        Tue, 26 Oct 2021 09:14:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cb17sm3694530edb.11.2021.10.26.09.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:14:35 -0700 (PDT)
Message-ID: <9c88dadb-8cae-9bbe-1241-dfc06afe13d5@redhat.com>
Date:   Tue, 26 Oct 2021 18:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 1/5] KVM: X86: fix lazy allocation of rmaps
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
References: <20211025203828.1404503-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211025203828.1404503-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 22:38, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit fa13843d1565d4c5b3aeb9be3343b313416bef46 ]
> 
> If allocation of rmaps fails, but some of the pointers have already been written,
> those pointers can be cleaned up when the memslot is freed, or even reused later
> for another attempt at allocating the rmaps.  Therefore there is no need to
> WARN, as done for example in memslot_rmap_alloc, but the allocation *must* be
> skipped lest KVM will overwrite the previous pointer and will indeed leak memory.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b0e866e9f08..60d9aa0ab389 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11341,7 +11341,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>   		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
>   					  slot->base_gfn, level) + 1;
>   
> -		WARN_ON(slot->arch.rmap[i]);
> +		if (slot->arch.rmap[i])
> +			continue;
>   
>   		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
>   		if (!slot->arch.rmap[i]) {
> 

NACK

There is no lazy allocation of rmaps in 5.14, and any failure to 
allocate goes straight to memslot_rmap_free followed by return -ENOMEM. 
  So the WARN_ON is justified there.

Paolo


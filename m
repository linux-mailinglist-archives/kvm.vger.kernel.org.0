Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A432D423F7B
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhJFNi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 09:38:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238802AbhJFNi0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 09:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v4OPt14HI09D78HsjyWQkPcigjMl6xalqCC+QbfcQbM=;
        b=Q0OB3NWf3/zAly13vX+ATT8rBQpgE4qR+pnH2gqV3FlsGVjZOviutJy21xScfJGwrZviiO
        gPj42cX1ePQyq5Mh7Ldxshs5Ww8TJKy34CFF2PqN9NaCZK6aYDkY/mx10a0VIYwozcQkF0
        Ygai5s70QPC2lRJvUMu/SYutnQ/p2Fc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-t67JionONwmB261G6c15VA-1; Wed, 06 Oct 2021 09:36:33 -0400
X-MC-Unique: t67JionONwmB261G6c15VA-1
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so2613614edj.21
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 06:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v4OPt14HI09D78HsjyWQkPcigjMl6xalqCC+QbfcQbM=;
        b=0qIKyvD3sbrT4AapPlovHEG5xVbKGViykQAP4i/ytTNgY5cZbcbuZWFRujbOOndsgt
         u4zTDXVGhhHDtZ03l38oR2+po+TWYDdZalXTqyl0800DoUG2n5VD/jY8hXv9+mW9vkBk
         3kLL39aXJiMc40H3bf8jXpqhRAVZxd0Vrz1hSUtoNqd4I+KeYYL/kExLsKPMaUFCxnox
         udBEnNgrGCPZe4fB7ysqiAM/2lkepsgEJBSUdxI4GQZhKln2NjU8ANjnmvYYrtFaADh0
         eoyFz9Y0ix20xrlo97iuWgaioHTh1hKoRgX4rVj2xevNRkfFq8kZmE8uRwidkWomrUdj
         ZAgA==
X-Gm-Message-State: AOAM533m/ClEFuC3Xd8am53cp5+67NJkAb4/0tXJtk9Opu7ODdes2xjC
        Q97u44kC9p/8E8iOrT/5eS7XtizKXqG3BQ3n21fUY6M3jQkylP0bb0oJsa+bhfEoWHvnQBmVnZY
        P/8C+h76EBt17
X-Received: by 2002:a17:906:70c5:: with SMTP id g5mr33648376ejk.63.1633527391916;
        Wed, 06 Oct 2021 06:36:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEccjrvl7ipmlMGGicz3yBAzw5yy0GjNrs8gM/LHDZMRy4nvbLaHjNpu6InlojAK4L0aETjg==
X-Received: by 2002:a17:906:70c5:: with SMTP id g5mr33648358ejk.63.1633527391741;
        Wed, 06 Oct 2021 06:36:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id e15sm7581619ejr.58.2021.10.06.06.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:31 -0700 (PDT)
Message-ID: <e5b8a6d4-6d5c-ada9-bb36-7ed3c8b7d637@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 4/9] KVM: x86: reset pdptrs_from_userspace
 when exiting smm
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit 37687c403a641f251cb2ef2e7830b88aa0647ba9 ]
> 
> When exiting SMM, pdpts are loaded again from the guest memory.
> 
> This fixes a theoretical bug, when exit from SMM triggers entry to the
> nested guest which re-uses some of the migration
> code which uses this flag as a workaround for a legacy userspace.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210913140954.165665-4-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b3f855d48f72..1e7d629bbf36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7659,6 +7659,13 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
>   
>   		/* Process a latched INIT or SMI, if any.  */
>   		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
> +		/*
> +		 * Even if KVM_SET_SREGS2 loaded PDPTRs out of band,
> +		 * on SMM exit we still need to reload them from
> +		 * guest memory
> +		 */
> +		vcpu->arch.pdptrs_from_userspace = false;
>   	}
>   
>   	kvm_mmu_reset_context(vcpu);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


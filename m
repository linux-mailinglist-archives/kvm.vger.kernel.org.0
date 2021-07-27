Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DF23D80F6
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 23:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhG0VKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 17:10:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232696AbhG0VIn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 17:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627420122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUpUKaHU71NYL6/47as07mmBCcnbbXJebfKydCKE4tk=;
        b=f10rzjpeX/QnzOkvue8r3z1fBx3nLM6NliSZv6A/yX6zt9Q9e0fGQ2bfUYH13RYZWdxaSo
        d/Ya3HInZhACm5zNpw0Hutb7uhviW/BJZrU3f0hIQBbnEvDX2FkapQKXtsMTYlX4p/vyE8
        WDMudzqXl2eu3qN+X7uTq631PeWrkJU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-NulbfrOWMiyPKYWg7CXS-w-1; Tue, 27 Jul 2021 17:08:41 -0400
X-MC-Unique: NulbfrOWMiyPKYWg7CXS-w-1
Received: by mail-ej1-f72.google.com with SMTP id kf3-20020a17090776c3b0290536d9b62eb6so165214ejc.2
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 14:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUpUKaHU71NYL6/47as07mmBCcnbbXJebfKydCKE4tk=;
        b=JjAIrDx3q4LrZZ+KNpGXJ9KSz0qjTGTmffRiUDVDn1VMQTuo41gTnQqUZuf3IW9qMc
         Ude6U0V7V8gJxzGWFJNonl5ZZ2J1n8M0NRoQIgtPKOexCiUq/YfvXLrQYjblhss3vy3u
         3/Ugew1OPBEBSp0wPCjndR7ruiW53CjtUz/yzfpUaPdOE16K8hNZFShNgsMwnEzZM/ro
         KWE/I7H90KxR4vAinZrKlQQOmkqzYvLCwVRzhQ/ta4+m/K5/QJQmTcX1O5rvJNW6TnQO
         8vpLovSNTIpeaMELQAj1pUU9FneJaqJdL5W4cZmTT46hAimIPL93aoccCL326PDIk6IM
         P68A==
X-Gm-Message-State: AOAM533YY5Rt0EHgVJyAMLKDAp7Iz9CXzCvv9EGkiZEACNbu3xlDgrxa
        KynDQoP0vGDAR+gPNmwlhhGcsp+UVBhtM5ZeT8ji3zZhqcv7i/SxHHt4+VujcIPPxqCG7Eo1avs
        xfoPQkkSGwkLX
X-Received: by 2002:a50:fd17:: with SMTP id i23mr30313190eds.270.1627420120369;
        Tue, 27 Jul 2021 14:08:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk1VtOYP3rrDEaPWF4C6xsoU2R3/eMAg1NRsJWDrGHre7V3ZZhApRMbe+bviVTVGcOJBusTg==
X-Received: by 2002:a50:fd17:: with SMTP id i23mr30313172eds.270.1627420120204;
        Tue, 27 Jul 2021 14:08:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u5sm1701982edv.64.2021.07.27.14.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 14:08:39 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
References: <20210727170620.1643969-1-pbonzini@redhat.com>
 <YQBzgtBXZ4SIz9jF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: accept userspace interrupt only if no event
 is injected
Message-ID: <9ae42cf8-e3e5-b8aa-ba86-d680feb09830@redhat.com>
Date:   Tue, 27 Jul 2021 23:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQBzgtBXZ4SIz9jF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/21 22:58, Sean Christopherson wrote:
>> ---
>>   arch/x86/kvm/x86.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4116567f3d44..5e921f1e00db 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4358,8 +4358,18 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>>   
>>   static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>>   {
>> +	/*
>> +	 * Do not cause an interrupt window exit if an exception
>> +	 * is pending or an event needs reinjection; userspace
>> +	 * might want to inject the interrupt manually using KVM_SET_REGS
>> +	 * or KVM_SET_SREGS.  For that to work, we must be at an
>> +	 * instruction boundary and with no events half-injected.
>> +	 */
>>   	return kvm_arch_interrupt_allowed(vcpu) &&
>> -		kvm_cpu_accept_dm_intr(vcpu);
>> +		kvm_cpu_accept_dm_intr(vcpu) &&
> 
> Opportunistically align this indentation?

Yep, good idea.

>> +	        !kvm_event_needs_reinjection(vcpu)
> 
> Missing &&, apparently the mysterious cherry-pick didn't go so well :-)

Well, yeah.  The only way I can excuse myself, is by not being the kind 
of person that yells for such stupid things...

Paolo


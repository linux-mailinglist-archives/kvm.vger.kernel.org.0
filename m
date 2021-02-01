Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600A930A388
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhBAIsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:48:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231915AbhBAIsN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 03:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612169202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycWUhqyahgW6IbcyQn5bJ44NFVrcMkISQf6Y9h9Fp5s=;
        b=NgLrEyzbA1MXi3OyAVEsFGoh03A+6N5EDhIbbsbNKE5SM9rynS9FxnJfzFAnpJmZU9Krsh
        2alQ7juPKMMDLeJjEu1G9qkOZ+cbu3wCF2xOYvt/rTfxhA8Xn+uzz230pSf5nLovkML2ww
        G2/AWpG1N9odm/9vQj8I6IhLi48ZAwY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-RZ2F8gs6MQqhhB-kgus1pg-1; Mon, 01 Feb 2021 03:46:40 -0500
X-MC-Unique: RZ2F8gs6MQqhhB-kgus1pg-1
Received: by mail-wr1-f72.google.com with SMTP id s15so10024008wrt.14
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 00:46:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ycWUhqyahgW6IbcyQn5bJ44NFVrcMkISQf6Y9h9Fp5s=;
        b=R7pC54dEn4IoKwmFc0ts3BSiA2qOdDHg+kKYtT4T8h6wD2QtzCXavLz/hMVMYf0Usw
         r9iZJrDnZcuZE0OCKDE9CpVZpE+k/1IEEXx/8/LFuYy8XEMd7j/+6OMW97+gPSg6srQc
         Dvl4gLPyzEwHRKDo6U52ibVSvxwTJ8DZY5ARGVKISDrZHCauEqOMIErub2AvkCZZJv+l
         Vy6wiJdoRftGSix87iszJwp/UkAYQZsz2HuO8H9TrBc2b+IqC+hWRz/c6v4xViEKAMdI
         PBqF1WvAyCnI79WitxHsfPGn26gG3vbV8kzHl4Cw6PEv8OlwTo89d05LlCGZFbDwF8Mx
         zVFA==
X-Gm-Message-State: AOAM532BaBZHrCxU6KYK3fCUwMPyev2bEwe2TrJe0+Lg6MeMUANpuhqp
        pEVJCMbrImN0jTgYRdLNihoYGgjclJxmRUkCYEhfjMjeloPIyykonBx5+C7NYC1IUgNlZ+v6ghv
        aEClZauFznhLE
X-Received: by 2002:a05:600c:4f93:: with SMTP id n19mr5190605wmq.163.1612169199833;
        Mon, 01 Feb 2021 00:46:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZiGrlpS95bTxFWPHk0H8gkcJErwBOJHg2jZs2Os89BYpZwVwwXeSl0i1NzT+E6UMGTN8RZw==
X-Received: by 2002:a05:600c:4f93:: with SMTP id n19mr5190597wmq.163.1612169199660;
        Mon, 01 Feb 2021 00:46:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w4sm19835679wmc.13.2021.02.01.00.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 00:46:38 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20210129101912.1857809-1-pbonzini@redhat.com>
 <YBQ+peAEdX2h3tro@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
Message-ID: <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
Date:   Mon, 1 Feb 2021 09:46:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBQ+peAEdX2h3tro@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/21 17:58, Sean Christopherson wrote:
> On Fri, Jan 29, 2021, Paolo Bonzini wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 76bce832cade..15733013b266 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1401,7 +1401,7 @@ static u64 kvm_get_arch_capabilities(void)
>>   	 *	  This lets the guest use VERW to clear CPU buffers.
> 
> 
> This comment be updated to call out the new TSX_CTRL behavior.
> 
> 	/*
> 	 * On TAA affected systems:
> 	 *      - nothing to do if TSX is disabled on the host.
> 	 *      - we emulate TSX_CTRL if present on the host.
> 	 *	  This lets the guest use VERW to clear CPU buffers.
> 	 */

Ok.

>>   	 */
>>   	if (!boot_cpu_has(X86_FEATURE_RTM))
>> -		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
>> +		data &= ~ARCH_CAP_TAA_NO;
> 
> Hmm, simply clearing TSX_CTRL will only preserve the host value.  Since
> ARCH_CAPABILITIES is unconditionally emulated by KVM, wouldn't it make sense to
> unconditionally expose TSX_CTRL as well, as opposed to exposing it only if it's
> supported in the host?  I.e. allow migrating a TSX-disabled guest to a host
> without TSX.  Or am I misunderstanding how TSX_CTRL is checked/used?

I'm a bit wary of having a combination (MDS_NO=0, TSX_CTRL=1) that does 
not exist on bare metal.  There are other cases where such combinations 
can happen, especially with the Spectre and SSBD mitigations (for 
example due to AMD CPUID bits for Intel processors), but at least those 
are just redundancies in the CPUID bits and it's more likely that the 
guest does something sensible with them.

Paolo

>>   	else if (!boot_cpu_has_bug(X86_BUG_TAA))
>>   		data |= ARCH_CAP_TAA_NO;
>>   
>> -- 
>> 2.26.2
>>
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB145473D1A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhLNGTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLNGTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:19:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDEC061574;
        Mon, 13 Dec 2021 22:19:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so60350281edu.4;
        Mon, 13 Dec 2021 22:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=okXmE9n70i5mN9tZ3BS4jx1+GOye2/2pT9K5asNw8SE=;
        b=amWbMm9XtgIGPc4+PzfMkJEjdfm9CIKgzOo+e2mdwZmsmXL7LG5xccgCLKi3m3jLLT
         bbhzzBGVr66+vccfORZ1/J5id6U2j4e4y4lS+PUtInQDjZgyP5HA/E57aJ4vbs4+QSom
         dBR4N0SKWVy/CSNtbupjPljp2GUsXcgDHe6WIjZ1VeVABcFAgSR7WqX+6xPxHmVyeZez
         Qpf21jCHk5e+LPARZ4wg30qCqzObFqB/VvVj0VCTblGdphVJPKOaTemzlL/8Louu9LWY
         5UHNYvPWItXMsxFGvTdFX/UO+HXCtV/JczCpiwFZ9slsL5J86ElTSqY8rZnMqAVEbflf
         2dGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=okXmE9n70i5mN9tZ3BS4jx1+GOye2/2pT9K5asNw8SE=;
        b=iubYYSupuB7DC/B+YlR+hu6JOZJ2E+Sx+XFq5wF5TVHPfFhtuh3YgjyKg0s5saAlqJ
         s2Q0zBWANHPJkc+JzVuGgK+1qWv+k5Tdrg/6AetBT2EV7WctnWn+GBG2b1up6UT9kuec
         VL1xOzAezFvzJ9YV+ebs6o02Ei/Mhra50IcKTh2Muqdg9BStF+Iz77G15xczv7bjhBeU
         ZG8ZGrS3GRmGWWdKBmza4llPah4bUdzh18GqWIcbtY2RJS6fTvFKYDrTejyOg8C/CHht
         jBC0nOhtZ7SqlB04ptj04aLdC0RfGcvaNDK8X1C8Y3Tfj/dbRD/VlekXBqKcg8fKKypZ
         GfhA==
X-Gm-Message-State: AOAM5324kEyVeenEnFyWfFm3+r5nyPxySPyz5/KifSd/SeiJp4tNyexd
        ID/PW5QSb5pDPhtp5gFVnnc=
X-Google-Smtp-Source: ABdhPJyqRkRHhs97Es6imNHslMAnqhjlRoNZKRYHUB0xKOPAM1grGFyr6V+8zeMqAWtYfCDXoNm1EQ==
X-Received: by 2002:a05:6402:3549:: with SMTP id f9mr5396842edd.23.1639462741733;
        Mon, 13 Dec 2021 22:19:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u10sm7093813edo.16.2021.12.13.22.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 22:19:01 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
Date:   Tue, 14 Dec 2021 07:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
 <3ec6019a551249d6994063e56a448625@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3ec6019a551249d6994063e56a448625@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 07:06, Wang, Wei W wrote:
> On Monday, December 13, 2021 5:24 PM, Paolo Bonzini wrote:
>> There is no need for struct kvm_xsave2, because there is no need for a "size"
>> argument.
>>
>> - KVM_GET_XSAVE2 *is* needed, and it can expect a buffer as big as the return
>> value of KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
> 
> Why would KVM_GET_XSAVE2 still be needed in this case?
> 
> I'm thinking it would also be possible to reuse KVM_GET_XSAVE:
> 
> - If userspace calls to KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2),
>   then KVM knows that the userspace is a new version and it works with larger xsave buffer using the "size" that it returns via KVM_CAP_XSAVE2.
>   So we can add a flag "kvm->xsave2_enabled", which gets set upon userspace checks KVM_CAP_XSAVE2.

You can use KVM_ENABLE_CAP(KVM_CAP_XSAVE2) for that, yes.  In that case 
you don't need KVM_GET_XSAVE2.

Paolo

> - On KVM_GET_XSAVE, if "kvm->xsave2_enabled" is set,
>   then KVM allocates buffer to load xstates and copies the loaded xstates data to the userspace buffer
>   using the "size" that was returned to userspace on KVM_CAP_XSAVE2.
>   If "kvm->xsave2_enabled" isn't set, using the legacy "4KB" size.
> 
> Thanks,
> Wei
> 


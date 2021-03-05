Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA532EE14
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 16:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCEPNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 10:13:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhCEPNg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 10:13:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614957215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asQEDK/IFlF1AzTuh7B6Z7PmHKHnowQYucM/TtzqZLc=;
        b=duOYCxHJaWN5UetkXmSatKuTgtT26bQUNXjKJA1sSFaZKCUclpKTQVstSvou6yDllNn1I9
        277+dfbUZq2d81DJAH6aT1gbDNPRnpcWzt5ziflXq8RpwW2Vdzo0XLaUge+5+IqoOuW74l
        e403N48Qvf9LfbqDeYM8UDI4FKmC9N4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-Re5f6JtnMQKLLrTuCL7JsQ-1; Fri, 05 Mar 2021 10:13:34 -0500
X-MC-Unique: Re5f6JtnMQKLLrTuCL7JsQ-1
Received: by mail-wm1-f70.google.com with SMTP id o9so525823wmq.9
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 07:13:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=asQEDK/IFlF1AzTuh7B6Z7PmHKHnowQYucM/TtzqZLc=;
        b=IBvS0vvZWw7c+cndqHUamlqPT9xwjt3ELvQxSHlrXRv9o/KomHEMs7MrAWLIOBsvyo
         ZoZyt/D2QXo3ILC+PmN6oD4twpLut1K5Y956DMsUWe/ezycaJ4lNjCv8FGcZyBjwWOxg
         +8ba0W/q9VNEUB5lQ9eJoTMZG8PuesAE2+1T1GusMbgVrAsgw3MDCX2qnGNPyCgGHyTi
         f+xrF2V2l9SfOiJMqXWzd2KOjkuSeFu6nyMTtWlrPC3Kj1E04q//AniWwZ8czPkwWUCC
         Tt82RgYzKGQRqr3Fbr93wsvhF6rtObmqx4MHbpfzj4U8XHu+wgACGZGNqcPAZOYugrsA
         nyHg==
X-Gm-Message-State: AOAM5325PeSojX+RRIAAjjJrH7KtRHdmvMbZN5A2X1wCW48teb/7yYmH
        GY6/qKqMTCmlDYNN20PJBG56a4kvOLnVouXhVfu5Ar9BW/gi0vOkyTjlcPEkFl2zPxzKHJtMIM2
        a2dgwT7vRtdIY
X-Received: by 2002:a05:6000:250:: with SMTP id m16mr10096780wrz.325.1614957213007;
        Fri, 05 Mar 2021 07:13:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxh+5UfU/c1pKkqPKD4eP6McHeuqr7RK32/Td72w0GoL12d9wQEN1qTVtQpkkZESPLSpJa3Ew==
X-Received: by 2002:a05:6000:250:: with SMTP id m16mr10096752wrz.325.1614957212735;
        Fri, 05 Mar 2021 07:13:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n6sm5213171wrt.1.2021.03.05.07.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 07:13:31 -0800 (PST)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>
Cc:     thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, rientjes@google.com, brijesh.singh@amd.com
References: <20210224085915.28751-1-natet@google.com>
 <20210305140409.GA2116@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ba4121bd-cad7-49f3-d53c-d1b03d95ca39@redhat.com>
Date:   Fri, 5 Mar 2021 16:13:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305140409.GA2116@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 15:04, Ashish Kalra wrote:
>> +	/* Mirrors of mirrors should work, but let's not get silly */
>> +	if (is_mirroring_enc_context(kvm)) {
>> +		ret = -ENOTTY;
>> +		goto failed;
>> +	}
> How will A->B->C->... type of live migration work if mirrors of
> mirrors are not supported ?

Each host would only run one main VM and one mirror, wouldn't it?

Paolo


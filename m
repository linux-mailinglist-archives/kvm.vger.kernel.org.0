Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E331E26E8
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgEZQ1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:27:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgEZQ1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 12:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590510418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCnWrZNmGewtztk5OT8mZdJ1tPplBUz0YKtbn24flIo=;
        b=ZbhRCqmgY3jRtXFkzb/d/tGBLowCmj/xCLBiSRTWjH7KwAjOrIXZc+r4pbvMd5ZdbyORpj
        U40aVnGbiLjfeND+B9JW/n5KMM03/4psrn8ek9pcGqo9aovL4+sjxDHQckz7YvaoT3V6Je
        xn34ixJ5Jpu/tAoC6IL4UnhTh1QHENE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-eHKEK-eHOfOaRLabHWsLlA-1; Tue, 26 May 2020 12:26:56 -0400
X-MC-Unique: eHKEK-eHOfOaRLabHWsLlA-1
Received: by mail-wr1-f72.google.com with SMTP id h12so10046580wrr.19
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 09:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SCnWrZNmGewtztk5OT8mZdJ1tPplBUz0YKtbn24flIo=;
        b=f4MtfKZYKplPXV4UGxFH/UJXzucDaqWe/HEqbeyau7/Je0RXr1GQgNjfLEPjdYTHub
         3qj7PRlGk1RS5EE5QvoYOKDLeFAffo3kKX1KKJX+B9EhzF//6HZsGGkeNSdvUcI38v+H
         bedaZFhqcX8HNXMzQKNNdudsyIeSjsBIgRD9rC1u0nk/KpZPXr1kqc824Aa+xMCVB2+O
         J70xVK/iT+PvxOlL1DRl0pinJsLOZ0sWijnjW4Bo5oAYA7udhm80fk3nyiOwOxmVCETS
         ffcD5IJd0eVrqrkDqWxweRfrlPSgQiVhcj97gsV2weibgo8AJXamENLurUkCpHAFVokG
         63cw==
X-Gm-Message-State: AOAM532NpSULybPj0PrOBdGJ3adn8H/JUcF8i6YTYU4Og7FUNeWbNcMk
        +/s9X1IE26dJgX34nS1EzgHRJOORylY8J/CT7PuHMkJ4SwCLt+QaTwalC0DdDNzVJuuikOMPRSq
        +rhVMOeZf02OI
X-Received: by 2002:a1c:dc44:: with SMTP id t65mr58401wmg.128.1590510415663;
        Tue, 26 May 2020 09:26:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJjFyYyNmpvkQNurDHbK4Z6Nie01L1Ii5M8w+9hdIxWt/RqM01SOTwzTbxcWbiUqcWDAKIZg==
X-Received: by 2002:a1c:dc44:: with SMTP id t65mr58384wmg.128.1590510415400;
        Tue, 26 May 2020 09:26:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id q144sm49919wme.0.2020.05.26.09.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 09:26:54 -0700 (PDT)
Subject: Re: #DE
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <0fa0acac-f3b6-96c0-6ac8-18ec4d573aab@redhat.com>
 <233a810765c8b026778e76e9f8828a9ad0b3716d.camel@redhat.com>
 <b58b5d08-97a6-1e64-d8db-7ce74084553a@redhat.com>
 <3957e9600ae84bf8548d05ab8fbeb343d0239843.camel@redhat.com>
 <deb611de-76a9-b0b4-751b-8ef91d5f8902@redhat.com>
 <db1da9b57ac55d436e8a83bca614de9a8691fd58.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4fe935bd-eadc-c046-07a6-57473fc56d4a@redhat.com>
Date:   Tue, 26 May 2020 18:26:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <db1da9b57ac55d436e8a83bca614de9a8691fd58.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/20 17:30, Maxim Levitsky wrote:
>>> Now the problem is that it is next to impossible to know the source
>>> of the VINTR pending flag. Even if we remember that host is currently
>>> setup an interrupt window, the guest afterwards could have used
>>> EVENTINJ + interrupt disabled nested guest, to raise that flag as
>>> well, and might need to know about it.
>> Actually it is possible!  is_intercept tests L0's VINTR intercept
>> (see get_host_vmcb in svm.h), and that will be true if and only if
>> we are abusing the V_IRQ/V_INTR_PRIO/V_INTR_VECTOR fields.
> Yep. I wasn't aware of logic in svm_check_nested_events.
> In fact I think that it was added by the path that I found via bisect,
> since which the nesting started to not work well.
> 
> BTW, since nesting is broken with that #DE on mainline, should we prepare
> some patches to -stable to fix that?

I think 5.7 is going to remain broken.  But for 5.8 we need to fix Hyper-V.

Paolo


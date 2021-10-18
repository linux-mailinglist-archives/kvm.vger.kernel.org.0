Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B4E432658
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJRSba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:31:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhJRSb2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 14:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634581757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+zrJzRq36uZrK1pQoD4cVchCz3CVWNsoHXcKclsvSjE=;
        b=Lbw9f1E0GpfUKbsvYq+QGLeWydsaSH1YhK9/rDdkGXJqcmlEBpMASzcuS946G0eS6oIzcD
        2+8069uH+BFy93kHCPzfRnfo500bxwNZwWQLX5w/coOE1t7NkYNUF/4zVYxumXl31vqqu4
        Kknhi8ue1tzCZ53nru8+Kxr1x+q3djw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-enzkncDMMb6YQyjZuMY0aA-1; Mon, 18 Oct 2021 14:29:15 -0400
X-MC-Unique: enzkncDMMb6YQyjZuMY0aA-1
Received: by mail-ed1-f71.google.com with SMTP id l22-20020aa7c316000000b003dbbced0731so15199963edq.6
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+zrJzRq36uZrK1pQoD4cVchCz3CVWNsoHXcKclsvSjE=;
        b=7BrRLWhpTQ30fyd+J86gZeC2syfYNutc5HPQKBFcJG+u0GWqWoBtcRUx+vQwwQBozx
         g23nBtWDSRSR61ozKhvmayea2DH5QJEZWJRfeCUqSMnXYTDqIvwWl8n/4dPQ06tWczP6
         CvfTRZxGk611v40+aZlRfCxRyVZaaEV1NJApZzhGk1EA68wNBh2CbSe9bRGMhvDoXMyn
         naDNSHrTFUFvFdFdctRYDhlOKQDirzfbUTQVpVJn2phC5CNtPw6DfQh0kUAUYGlwt4GA
         gTgNeiR6nnywEgIbkNvg8aMr+oNaL1UiHi662VODHv5KmFqGc6/Ep9nBnBcUZgXeur0y
         JT1Q==
X-Gm-Message-State: AOAM530KBdNuLimmpW18p1dStCWGmoOpBh+UV/GTl7I/vSQJ3MNZF5u1
        50cKDH2HqXaSpBPhMgTojuOEuhNIN8WcKQCxLrSjLH10/HeHjtt2tw15SunpGzjb9cAjKtFp++7
        fl/be825NGQhW
X-Received: by 2002:aa7:cb10:: with SMTP id s16mr49380883edt.311.1634581754592;
        Mon, 18 Oct 2021 11:29:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/L8ULpPs3NPQuxX00gJmUT3pfBNY82BNyjykCPa2tBJ4Vti+M0Cbd2x62rSJlw3P2Odb9eA==
X-Received: by 2002:aa7:cb10:: with SMTP id s16mr49380870edt.311.1634581754432;
        Mon, 18 Oct 2021 11:29:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a13sm9116280ejx.39.2021.10.18.11.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:29:13 -0700 (PDT)
Message-ID: <93d4156f-4d81-da15-b93e-79f3ec9bebdb@redhat.com>
Date:   Mon, 18 Oct 2021 20:29:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM fixes for Linux 5.15-rc7
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20211018174137.579907-1-pbonzini@redhat.com>
 <CAHk-=wg0+bWDKfApDHVR70hsaRA_7bEZfG1XtN2DxZGo+np9Ug@mail.gmail.com>
 <daba6b06-66cb-6564-b7b0-26cb994a07cd@redhat.com>
 <CAHk-=wgScNWP7Ohh5eEKgcs3NLp9GZOoQ6Z-Kz0aByRtHoJSrw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHk-=wgScNWP7Ohh5eEKgcs3NLp9GZOoQ6Z-Kz0aByRtHoJSrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 20:15, Linus Torvalds wrote:
>>           * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
>>           * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
>>           * (this is extremely unlikely to be short-circuited as true).
> That makes very little sense.
> 
> It seems to be avoiding a 'jcc' and replace it with a 'setcc' and an
> 'or'. Which is likely both bigger and slower.

The compiler knows that the setcc is unnecessary, because a!=0|b!=0 is 
the same as (a|b)!=0.

> If the jcc were unpredictable, maybe that would be one thing. But at
> least from a quick look, that doesn't even seem likely
> 
>   The other use of that function has a "WARN_ONCE()" on it, so
> presumably it normally doesn't ever trigger either of the boolean
> conditions.

Yes, and that was why it used a "|".

Anyway, not worth arguing for or against; I'll just change it to logical OR.

Paolo


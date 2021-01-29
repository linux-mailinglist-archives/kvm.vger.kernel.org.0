Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66736308CD0
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 19:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhA2Syr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 13:54:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhA2Syp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 13:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611946387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2lQG7NOq1Y30ihZ3JvjW7LHsEzNf1l5ZIU262Ux5yw=;
        b=c0PgIOjsr976CNPR89OESQ0xSsQ9hu4Lw3TcbFho97eBvzcNxipZGJzdi1cOaStyx7zRJ3
        0YGYQjvlWUkJU4g2Ww88KsHp2txdbOWmDSs/aE+xXzKi2KvZeXZUnWhsyn8QfMbda/cD0T
        Y1phN9Ph0/y16LurcAA3uGkojVefAMg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-zHMhC-cJMdqHelxNz2vpcA-1; Fri, 29 Jan 2021 13:53:04 -0500
X-MC-Unique: zHMhC-cJMdqHelxNz2vpcA-1
Received: by mail-wr1-f71.google.com with SMTP id l10so5728517wry.16
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 10:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2lQG7NOq1Y30ihZ3JvjW7LHsEzNf1l5ZIU262Ux5yw=;
        b=ZvMkYJyf2qM5YxxLePhPWtC2x2JBOrQo1vfibBi3ZqjLMRapz6Oq6Vr5JbpUWPjVnx
         ZbDxnCr37ecr3ydMpwkbmjc+yqzOzWr8iZQ9686siKp38vu1m8+THnkRcJ+ct2H92lPw
         tsBZu07TVzqT0U0Z4D7568uPXcAaXfHIQcnWFGkQMrMylgeWvC26x+AtFXtT+PI1/Ep0
         rvy4YYvs87Y9da9S+DS7eWNyIik5mN4W/bbo9FkZ44H8nK+Svo8hO77BGCN2lac3hqAR
         2QOHN6gQZibgoJoVasY0B8DGBaFk62a/g54NzBursKQbVmRkxFam5hYzw1kb1EqP5j0d
         lEUw==
X-Gm-Message-State: AOAM533eqgUmal0STrCYMZzIxQrlnCExB4w9vPDadLS99Aw1fL9eGkU9
        TvOQ4zGvWG2WI+tAxGtzTB8AYc+tgRBMt4GJYUv7lUijQsQg9YJl3VmPuo32r6VOOmrjzVkENdH
        oPkgRWJt21lQW
X-Received: by 2002:a1c:9609:: with SMTP id y9mr5027753wmd.75.1611946382859;
        Fri, 29 Jan 2021 10:53:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhbUhkw2usSXuyBhWcgXQlVTDKUdIPuIMDaI+Sf+8W+zkgRq8BrEHInJgZztI5WgVvi9yPgw==
X-Received: by 2002:a1c:9609:: with SMTP id y9mr5027741wmd.75.1611946382729;
        Fri, 29 Jan 2021 10:53:02 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id 9sm3199432wra.80.2021.01.29.10.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 10:53:01 -0800 (PST)
Subject: Re: [PATCH v4 09/12] target/arm: Make m_helper.c optional via
 CONFIG_ARM_V7M
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-10-philmd@redhat.com>
 <d9af8896-efec-c850-655e-1d1eb2629762@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <d57cc48a-2eb4-011d-7903-91042de507d3@redhat.com>
Date:   Fri, 29 Jan 2021 19:53:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d9af8896-efec-c850-655e-1d1eb2629762@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/20 11:48 AM, Richard Henderson wrote:
> On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
>> +arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
>> +
>>  arm_ss.add(zlib)
>>  
>>  arm_ss.add(when: 'CONFIG_TCG', if_true: files('arm-semi.c'))
>> +arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
> 
> I'm a bit surprised about adding the file twice.
> Since ARM_V7M depends on TCG, isn't the second line redundant?

This does:

if TCG
    if CONFIG_ARM_V7M
        files('m_helper.c')
    else #!V7M
        files('m_helper-stub.c'))
    endif
else #!TCG
    files('m_helper-stub.c'))
endif

So:

if !TCG or !V7M
    files('m_helper-stub.c'))
else
    files('m_helper.c')
endif

There might be a better way to express that in Meson...
I only understood how to do AND with arrays, but not OR.

Paolo/Marc-André, is it possible?

Thanks,

Phil.


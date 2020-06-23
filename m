Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD95204DED
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgFWJ35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:29:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731952AbgFWJ35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592904595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=yuYLlLgvyrJeXUSy4NWBnp41zSw2A25KjBbHFWApQ5E=;
        b=dWSuVi2McwbXYaMRtboIlFtw+MAs3L5EV53cneC12EBLtXBFe+BrSVnwdaEwHAjeAdLSXb
        DKnoCClG8yMqBv8kSWpRDOSs9IOLrfrFIqh689PwdjFA9Yf6stQhhZ/E041iHSjo5MCKbw
        qCbK1DlE6a/wVj2Wj/qSczWQw8BuVsY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-Kqh4woSsMXW83MKKh4o1Ug-1; Tue, 23 Jun 2020 05:29:53 -0400
X-MC-Unique: Kqh4woSsMXW83MKKh4o1Ug-1
Received: by mail-wm1-f72.google.com with SMTP id 23so3348368wmi.4
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yuYLlLgvyrJeXUSy4NWBnp41zSw2A25KjBbHFWApQ5E=;
        b=Mm5a0wqG238VS0gRCqFSU8i1bLTOunPwpnBOHBLe51GV0ANyfiBLFVYegJLKQ8OwZ3
         menjbjTSUPnEfCCFB28AQezb5hoSjgd4UaMZgIkMfwgnnInoE+kOr+jTABPT9+J476XD
         1kPevhzcpRGPbE6p5ZOjAQNzY1eJFsIooldZ57BmjLMllrVpAJeJT8h2VIEfyBneNQO7
         FDUp37s5uYdeolXpYFFKUAHmtLsWlMzwQ6vgBm/NzBW6rvpTQGSvZKOWha2Hi30TVjDJ
         3vj70DIrPXCk9EmXHar1i0nGVZVT0MyrlXgqEHmQF7Q+XaNwoD+/BG8QYZVPqLPUNwfJ
         kIJg==
X-Gm-Message-State: AOAM530EvRs5JnTXzr0NHqMUfur80sLBOnnhglwG8c83w/6idildMYQg
        MFBes3nC6sapd4f58YAb2MXxT4bZAUFTjljo9w9gmL1uAfttEKcZa0trpgujJShgnrl5kL1Bwe8
        qAYvUBy8JkBWC
X-Received: by 2002:a1c:9c49:: with SMTP id f70mr22539756wme.74.1592904592750;
        Tue, 23 Jun 2020 02:29:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf4SsUIv3m7W17TCwkn5fbF4otpNtUGOyAFMEQr+waRyNBd8cK83XMfm2mZaML8v1qhPHJCg==
X-Received: by 2002:a1c:9c49:: with SMTP id f70mr22539735wme.74.1592904592564;
        Tue, 23 Jun 2020 02:29:52 -0700 (PDT)
Received: from [192.168.1.41] (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id g25sm2802178wmh.18.2020.06.23.02.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:29:52 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] target/arm: Fix using pmu=on on KVM
To:     Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200623090622.30365-1-philmd@redhat.com>
 <20200623091807.vlqy53ckagcrhoah@kamzik.brq.redhat.com>
 <CAFEAcA-2-g=ZMMRkxoT-ncxqbdjc5vV1WbFzGXw7R8o7QOb6hQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <1ec46d92-ae37-0d78-0a5e-7615d91d36b6@redhat.com>
Date:   Tue, 23 Jun 2020 11:29:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-2-g=ZMMRkxoT-ncxqbdjc5vV1WbFzGXw7R8o7QOb6hQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/20 11:19 AM, Peter Maydell wrote:
> On Tue, 23 Jun 2020 at 10:18, Andrew Jones <drjones@redhat.com> wrote:
>>
>> On Tue, Jun 23, 2020 at 11:06:20AM +0200, Philippe Mathieu-Daudé wrote:
>>> Since v2:
>>> - include Drew test fix (addressed Peter review comments)
>>> - addressed Drew review comments
>>> - collected R-b/A-b
>>>
>>> Andrew Jones (1):
>>>   tests/qtest/arm-cpu-features: Add feature setting tests
>>>
>>> Philippe Mathieu-Daudé (1):
>>>   target/arm: Check supported KVM features globally (not per vCPU)
>>>
>>>  target/arm/kvm_arm.h           | 21 ++++++++-----------
>>>  target/arm/cpu.c               |  2 +-
>>>  target/arm/cpu64.c             | 10 ++++-----
>>>  target/arm/kvm.c               |  4 ++--
>>>  target/arm/kvm64.c             | 14 +++++--------
>>>  tests/qtest/arm-cpu-features.c | 38 ++++++++++++++++++++++++++++++----
>>>  6 files changed, 56 insertions(+), 33 deletions(-)
>>>
>>> --
>>> 2.21.3
>>>
>>>
>>
>> Hi Phil,
>>
>> Thanks for including the test patch. To avoid breaking bisection, if one
>> were to use qtest to bisect something, then the order of patches should
>> be reversed.

Oops :)

>> I guess Peter can apply them that way without a repost
>> though.
> 
> Yeah, I can just flip the order.

Thanks both!


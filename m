Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E4811F37C
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 19:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLNSRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 13:17:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbfLNSRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 13:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576347449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sg5IoKLUjPL3d9d5tWOmLplt+9UU7U7u3KeGeq6Z2Ro=;
        b=CkD5IodEOzKK7CdIUPQL4KvjWzrVswbCNjGMaT0GFMgXgxHBoXqtmuaYIBDriPro0Dmb81
        PbJdjqgoUmfD8C4v95/i30rdoSN6qsc/qWmOpQLvSi44EjvIXUNTW1r5ULPgWeu1axltRu
        KBxKkODKm0bmTAbmxHhq4I0P89gLL6U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-1HvuQ6MUM1C13G65pefXDg-1; Sat, 14 Dec 2019 13:17:27 -0500
X-MC-Unique: 1HvuQ6MUM1C13G65pefXDg-1
Received: by mail-wr1-f71.google.com with SMTP id f17so1256396wrt.19
        for <kvm@vger.kernel.org>; Sat, 14 Dec 2019 10:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sg5IoKLUjPL3d9d5tWOmLplt+9UU7U7u3KeGeq6Z2Ro=;
        b=WOQs7Dc6co0WnGuCLlym8GP1z/yS1KRX07UVPBCMDnfj1HmP285cmTgFv1mmr0HnEq
         oa3ZGZ7y8VPv9+0pNuPM43IA40oA9oyUTnhNqzHFKUoHG5gkdejX7L7ZgJM64bFOqzmC
         6zV0rKNozAPuQy9mdEPBfeuUPzbz37Ptzu0Bj1KivGMlsAnf1kDyUCxKQWBU3GPCdzPV
         +mB4EY28KwK28T1aSBAPreUWA/NTCL0ZnSVqV+gtRL0/KYW9RfxQhCAqezYHW/AGRXOt
         C+32aeSE15m0UALWIi9EvOOaJKeuAlhJMqbkb5ewQyqx2wgf0K05WxntCS6TFDkb6B/O
         wzAg==
X-Gm-Message-State: APjAAAU6fgpB96xQ5UMYa2NnMy469/ADQMwpYuc8wi/Dt7X4lmKFIrKB
        GAJuSlkPZ3eFFNCLOrbAyl7ZG2s6uANUItsGvvvfgkiPiV6chT3DlTGYVvDtts0WtQPSB/ZI2Wa
        JskzF1lTdrse3
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr19560642wrm.278.1576347446203;
        Sat, 14 Dec 2019 10:17:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwa4vn4ff+Qn7Yr7sIor5+nJ8HSxrr0XhsEVlpcFJzSQc5WvO7C89H+O/cXVwaqad6m8td6Hw==
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr19560619wrm.278.1576347445986;
        Sat, 14 Dec 2019 10:17:25 -0800 (PST)
Received: from [192.168.1.35] (34.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.34])
        by smtp.gmail.com with ESMTPSA id n8sm14941968wrx.42.2019.12.14.10.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 10:17:25 -0800 (PST)
Subject: Re: [PATCH 0/8] Simplify memory_region_add_subregion_overlap(...,
 priority=0)
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20191214155614.19004-1-philmd@redhat.com>
 <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <31acb07b-a61b-1bc4-ee6e-faa511745a61@redhat.com>
Date:   Sat, 14 Dec 2019 19:17:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/19 5:28 PM, Peter Maydell wrote:
> On Sat, 14 Dec 2019 at 15:56, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>
>> Hi,
>>
>> In this series we use coccinelle to replace:
>> - memory_region_add_subregion_overlap(..., priority=0)
>> + memory_region_add_subregion(...)
>>
>> Rationale is the code is easier to read, and reviewers don't
>> have to worry about overlapping because it isn't used.
> 
> So our implementation of these two functions makes them
> have the same behaviour, but the documentation comments
> in memory.h describe them as different: a subregion added
> with memory_region_add_subregion() is not supposed to
> overlap any other subregion unless that other subregion
> was explicitly marked as overlapping. My intention with the
> API design here was that using the _overlap() version is
> a statement of intent -- this region is *expected* to be
> overlapping with some other regions, which hopefully
> have a priority set so they go at the right order wrt this one.

I didn't notice the documentation differences, now it is clear.

> Use of the non-overlap function says "I don't expect this
> to overlap". (It doesn't actually assert that it doesn't
> overlap because we have some legacy uses, notably
> in the x86 PC machines, which do overlap without using
> the right function, which we've never tried to tidy up.)
> 
> We used to have some #if-ed out code in memory.c which
> was able to detect incorrect overlap, but it got removed
> in commit b613597819587. I thought then and still do
> that rather than removing code and API distinctions that
> allow us to tell if the board code has done something
> wrong (unintentional overlap, especially unintentional
> overlap at the same priority value) it would be better to
> fix the board bugs so we could enable the warnings/asserts...

Maybe we can a warning if priority=0, to force board designers to use 
explicit priority (explicit overlap).


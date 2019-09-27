Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68C9C06D9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfI0OAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60471 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfI0OAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:00:13 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 367E6757CF
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 14:00:12 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id z8so1045283wrs.14
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 07:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/OdoyPZCMccqXXjc+1N583bkKKd2Z+1Dhr6ugLufJbI=;
        b=KrkdMka4vhwaksm6j1fCODDiANiceRKcbYDLxQILPqYT9uInHAB9orwkscFXsd+pl5
         S/+UjIq/wx4DKVo7wC11f1tsd+NhxSanQ6QEPRzRF8E98ut2vJdNIjW+D92p29+Na9n+
         YfWKdBCOg+Jgw9M/rbJdJUUhTNWT5I/cZFYfCBezQtaME6hHDsn6IVaHQO9PfbKvoqBH
         mbX0eb+Yt9GJmqaaEWWVRfQPqEafzY33WX+++Cm98vU4Him3d6+WuJl9H5nR79mQJCKI
         90i4rJ4KnjugN+GvtH5gCDFoo/9+pVCaK6BgFiMzLge/lrSTzDxux3/vh7FmyMBGhQ4d
         OlXg==
X-Gm-Message-State: APjAAAW67pUE8RC9qJ8RSFR8ycPvWzwk/FckFb7ylJV3DkQ3iNn1nnZi
        XL71k1EV9LwqavQ+lJsfr8OPzm1r6VeezWe9PeQSiFSr5iLajsIEf5hQr6HZ07UzADj1zg8lWca
        nPGgJ0KM9OaZT
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr7465409wmc.140.1569592810748;
        Fri, 27 Sep 2019 07:00:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwU0mWODVsdotMCbIW7OfD3zO54AN48B/Jysamjp8eMfick8GypiygUwBVCdbBg7qUC3inl0A==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr7465392wmc.140.1569592810509;
        Fri, 27 Sep 2019 07:00:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id s19sm3943573wrb.14.2019.09.27.07.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 07:00:09 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190821182004.102768-1-jmattson@google.com>
 <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
Date:   Fri, 27 Sep 2019 16:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87ftkh6e19.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 15:53, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> Queued, thanks.
> 
> I'm sorry for late feedback but this commit seems to be causing
> selftests failures for me, e.g.:
> 
> # ./x86_64/state_test 
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> Guest physical address width detected: 46
> ==== Test Assertion Failure ====
>   lib/x86_64/processor.c:1089: r == nmsrs
>   pid=14431 tid=14431 - Argument list too long
>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>      3	0x00007f881eb453d4: ?? ??:0
>      4	0x0000000000401287: _start at ??:?
>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
> 
> Is this something known already or should I investigate?

No, I didn't know about it, it works here.

Paolo

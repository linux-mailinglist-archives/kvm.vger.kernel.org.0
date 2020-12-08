Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213992D2B5E
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 13:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgLHMsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 07:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgLHMsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 07:48:52 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93668C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 04:48:12 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 4so6932828plk.5
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 04:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2xC/30zdoPJZixJb/Fmz+ZJRVHITwlCsE0s1lEl9W7M=;
        b=ZB+RGQDZfBDtEGPWfQY2vs5cX4BvWRZd1sL0TPeo9a9YiKOMcbLa4slmAhUWYHncN2
         vz/1KHvacnY9wxxpv/fR6fq6XQtjRwwavcg3hHRAGF8DO6RkimvI+HufBrquGsfAxUiZ
         gTl9h4FAwx0tRyE4Z4MRjGheXk47EEDJ2inI/rkTZMrioaqWyBTU53MTn3ZSRLzMreUx
         ipSHN/255fHVnZYB8eMbtPR4tDzsDXrkQoO5nOhdIQ6ueEJ2oejudrlsvh4Ccu/WrAcK
         dAjYnhU7OYvQKjO97U/5b5qD7qGVItoNxNRunQypCW8HQPtSZOUZJd/qoCZ26pSN1Q/6
         pJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2xC/30zdoPJZixJb/Fmz+ZJRVHITwlCsE0s1lEl9W7M=;
        b=hwPPIE5/pVHtjjHoLloNL4O+v3LVokYaXXGN/GXetyLypO6JYbksb0eqlzufKutfH9
         m76uxnt/ro9oRNEBhlL8MWfF9YGXQN0RbBaL3m3CxlEB0V0fWyZlONivQ3bal0XazTaw
         gZV8M4Upg5tAZDKpU75tgpQxQX6mCGwGdiPGp85SzcIc3H/NTX7+ikHCx8LtEeYLJzmk
         DR1ZWDC0OuGRNIeQgQASidC4FxiNSIh/HfpEmUzBpgtKTPtf+JNp/dSBNktqGSw1K6wM
         1LZs98lVGWg6o4X87b18nQqfH6plLt4I+/fBw9Mr2JsrhRb6OoVhLCd2CneCpiqXff2d
         kZUg==
X-Gm-Message-State: AOAM533ETNUR7OMAm7+q7+SkfrdsB1i0m6GONjcSAYhfEmogHXzPdEyb
        DzPQdVWfq5DWSaXMznjAXYM=
X-Google-Smtp-Source: ABdhPJxO+2Gdx6YENVZJv2MbAWKYIyv9QTADEb/jnTEBZ1QLsrxkPyBaWFloFILlbYH17JGcleTrwg==
X-Received: by 2002:a17:902:a711:b029:da:f065:1315 with SMTP id w17-20020a170902a711b02900daf0651315mr11441448plq.36.1607431691690;
        Tue, 08 Dec 2020 04:48:11 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:5c98:e5b3:1ddc:54ce? ([2601:647:4700:9b2:5c98:e5b3:1ddc:54ce])
        by smtp.gmail.com with ESMTPSA id a17sm14997636pga.56.2020.12.08.04.48.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Dec 2020 04:48:11 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of
 the page allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201208110010.7d05bd3a@ibm-vm>
Date:   Tue, 8 Dec 2020 04:48:09 -0800
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <7D823148-A383-470A-9611-E77C2E442524@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
 <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
 <20201208101510.4e3866dc@ibm-vm>
 <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
 <20201208110010.7d05bd3a@ibm-vm>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 8, 2020, at 2:00 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> On Tue, 8 Dec 2020 01:23:59 -0800
> Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>>> On Dec 8, 2020, at 1:15 AM, Claudio Imbrenda
>>> <imbrenda@linux.ibm.com> wrote:
>>>=20
>>> On Mon, 7 Dec 2020 17:10:13 -0800
>>> Nadav Amit <nadav.amit@gmail.com> wrote:
>>>=20
>>>>> On Dec 7, 2020, at 4:41 PM, Nadav Amit <nadav.amit@gmail.com>
>>>>> wrote:=20
>>>>>> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
>>>>>> <imbrenda@linux.ibm.com> wrote:
>>>>>>=20
>>>>>> This is a complete rewrite of the page allocator.   =20
>>>>>=20
>>>>> This patch causes me crashes:
>>>>>=20
>>>>> lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
>>>>>=20
>>>>> It appears that two areas are registered on AREA_LOW_NUMBER, as
>>>>> setup_vm() can call (and calls on my system)
>>>>> page_alloc_init_area() twice.
>>>>>=20
>>>>> setup_vm() uses AREA_ANY_NUMBER as the area number argument but
>>>>> eventually this means, according to the code, that
>>>>> __page_alloc_init_area() would use AREA_LOW_NUMBER.
>>>>>=20
>>>>> I do not understand the rationale behind these areas well enough
>>>>> to fix it.   =20
>>>>=20
>>>> One more thing: I changed the previous allocator to zero any
>>>> allocated page. Without it, I get strange failures when I do not
>>>> run the tests on KVM, which are presumably caused by some
>>>> intentional or unintentional hidden assumption of kvm-unit-tests
>>>> that the memory is zeroed.
>>>>=20
>>>> Can you restore this behavior? I can also send this one-line fix,
>>>> but I do not want to overstep on your (hopeful) fix for the
>>>> previous problem that I mentioned (AREA_ANY_NUMBER). =20
>>>=20
>>> no. Some tests depend on the fact that the memory is being touched
>>> for the first time.
>>>=20
>>> if your test depends on memory being zeroed on allocation, maybe you
>>> can zero the memory yourself in the test?
>>>=20
>>> otherwise I can try adding a function to explicitly allocate a
>>> zeroed page. =20
>>=20
>> To be fair, I do not know which non-zeroed memory causes the failure,
>> and debugging these kind of failures is hard and sometimes
>> non-deterministic. For instance, the failure I got this time was:
>>=20
>> 	Test suite: vmenter
>> 	VM-Fail on vmlaunch: error number is 7. See Intel 30.4.
>>=20
>> And other VM-entry failures, which are not easy to debug, especially
>> on bare-metal.
>=20
> so you are running the test on bare metal?
>=20
> that is something I had not tested

Base-metal / VMware.

>=20
>> Note that the failing test is not new, and unfortunately these kind =
of
>> errors (wrong assumption that memory is zeroed) are not rare, since
>> KVM indeed zeroes the memory (unlike other hypervisors and
>> bare-metal).
>>=20
>> The previous allocator had the behavior of zeroing the memory to
>=20
> I don't remember such behaviour, but I'll have a look

See https://www.spinics.net/lists/kvm/msg186474.html

>=20
>> avoid such problems. I would argue that zeroing should be the default
>> behavior, and if someone wants to have the memory =E2=80=9Cuntouched=E2=
=80=9D for a
>> specific test (which one?) he should use an alternative function for
>> this matter.
>=20
> probably we need some commandline switches to change the behaviour of
> the allocator according to the specific needs of each testcase
>=20
>=20
> I'll see what I can do

I do not think commandline switches are the right way. I think that
reproducibility requires the memory to always be on a given state before =
the
tests begin. There are latent bugs in kvm-unit-tests that are not =
apparent
when the memory is zeroed. I do not think anyone wants to waste time on
resolving these bugs.


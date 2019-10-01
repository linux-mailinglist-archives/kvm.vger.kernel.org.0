Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC76C2B96
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 03:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfJABOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 21:14:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33000 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfJABOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 21:14:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so6702644pfl.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 18:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oJ2YYB0wfUWvcMyPHe+VCvwlDe7RwIY5GJ67RiArZ+A=;
        b=mvIa67j7Xnqcm04TaKdnHPkwrPIqBkWs85MeqHT4DJ0jsFwA2spbQYe0NerHaK+ei0
         nSvgVHAW4AbozNl/PjVZO4UeULMGugyzjLY/bbX0msIH7VxDWE8js3WGsOhH9Kz/IK6A
         ED1wv/bGoqcbwe2DdI9egU/mKGt19c2HkjENhdxnMPmWZzDayD84YSH1y9pjNijJ0GNp
         8IMK8P85QFKi1aRMrbbRK65K2ZbZxtW4ePSxBYvMh4VXOg/bZYblYrlVVLU76LXWRz7z
         xnXh4XnpB45ZPgeu/48fjAy9WqUrLPnoHx8z57WPeibU5a/cMyG6KGkOrF75a8O21mOe
         csiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oJ2YYB0wfUWvcMyPHe+VCvwlDe7RwIY5GJ67RiArZ+A=;
        b=VT0MEARe9kxjmmiKSqLwb6oJb+vm/UalfNm6HJ7IIEuLI5wEE2eHz+5BZSIVQGhObK
         IFgPl//xfxlZ29y0cYFUYabxIcUJw6mEBiPyRJ/Jcvz5FyRqhW+iM3hERZ4vBRyMUlfl
         h2X4cu2z9B7gO/3RS5egm4v5EVHVvdfi6aQV0RK6RzSeUKVX2Vgfzd+f6bSs7wmIqzF7
         YwUIhnpniDFwjPy5q/SBrbELB64375sGmTsjiCERK44wlaa1fWfruRpvGo6zQ3G/wYWf
         ZoCICDk20W/LU4dVdOf1TxAPWsXI9WuLH8j2iWzvwTvMsluwVq10rwfKeE3aTBtS+V2Q
         xZBA==
X-Gm-Message-State: APjAAAWxpllwMYMVTqXL4ICu5VtSxlz1p0NR9XuhOnNx7chdnZMeWdZ6
        a4gmbgML3MaCGJK1M21PqiImWaLsijjdXA==
X-Google-Smtp-Source: APXvYqztZXq7Bt3bq0VgvNSPu63WL14qXw0WhH5JuYn+MTOP3jZCyTDmgqfCh7w4sumoFy+cgHbUNQ==
X-Received: by 2002:a17:90a:f98f:: with SMTP id cq15mr2403606pjb.54.1569892469567;
        Mon, 30 Sep 2019 18:14:29 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id x10sm20862856pfr.44.2019.09.30.18.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 18:14:28 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
Date:   Mon, 30 Sep 2019 18:14:27 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 30, 2019, at 5:48 PM, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 1 Oct 2019, at 2:02, Nadav Amit <nadav.amit@gmail.com> wrote:
>>=20
>>> On Sep 19, 2019, at 5:52 AM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>=20
>>> Hi,
>>>=20
>>> This patch series aims to add a vmx test to verify the functionality
>>> introduced by KVM commit:
>>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>>>=20
>>> The test verifies the following functionality:
>>> 1) An INIT signal received when CPU is in VMX operation
>>> is latched until it exits VMX operation.
>>> 2) If there is an INIT signal pending when CPU is in
>>> VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
>>> 3) Exit from VMX non-root mode on VMExit do not clear
>>> pending INIT signal in LAPIC.
>>> 4) When CPU exits VMX operation, pending INIT signal in
>>> LAPIC is processed.
>>>=20
>>> In order to write such a complex test, the vmx tests framework was
>>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>>> implemented in patches 1-7. The test itself is implemented at patch =
8.
>>> This enhancement to the vmx tests framework is a bit hackish, but
>>> I believe it's OK because this functionality is rarely required by
>>> other VMX tests.
>>>=20
>>> Regards,
>>> -Liran
>>=20
>> Hi Liran,
>>=20
>> I ran this test on bare-metal and it fails:
>>=20
>> Test suite: vmx_init_signal_test
>> PASS: INIT signal blocked when CPU in VMX operation
>> PASS: INIT signal during VMX non-root mode result in exit-reason =
VMX_INIT (3)
>> FAIL: INIT signal processed after exit VMX operation
>> SUMMARY: 8 tests, 1 unexpected failures
>>=20
>> I don=E2=80=99t have time to debug this issue, but let me know if you =
want some
>> print-outs.
>>=20
>> Nadav
>=20
> Thanks Nadav for running this on bare-metal. This is very useful!
>=20
> It seems that when CPU exited on exit-reason VMX_INIT (3), the LAPIC =
INIT pending event
> was consumed instead of still being latched until CPU exits VMX =
operation.
>=20
> In my commit which this unit-test verifies 4b9852f4f389 ("KVM: x86: =
Fix INIT signal handling in various CPU states=E2=80=9D),
> I have assumed that such exit-reason don=E2=80=99t consume the LAPIC =
INIT pending event.
> My assumption was based on the phrasing of Intel SDM section 25.2 =
OTHER CAUSES OF VM EXITS regarding INIT signals:
> "Such exits do not modify register state or clear pending events as =
they would outside of VMX operation."
> I thought Intel logic behind this is that if an INIT signal is sent to =
a CPU in VMX non-root mode, it would exit
> on exit-reason 3 which would allow hypervisor to decide to exit VMX =
operation in order to consume INIT signal.

I think this sentence can be read differently. It also reasonable not to
bound the host to get an INIT signal the moment it disabled vmx.

> Nadav, can you attempt to just add a delay in =
init_signal_test_thread() between calling vmx_off() & setting =
init_signal_test_thread_continued to true?
> It may be that real hardware delays a bit when the INIT signal is =
released from LAPIC after exit VMX operation.

I added =E2=80=9Cdelay(100000)=E2=80=9D between them, but got the same =
result.


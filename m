Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1701C14BFE9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgA1Scj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:32:39 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38226 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgA1Scj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 13:32:39 -0500
Received: by mail-pj1-f65.google.com with SMTP id j17so630950pjz.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 10:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WodcJpWVZbO4g1u0/wCvmEoR70ko/sm4LwMAucejRls=;
        b=FKjw17QAJ2C5aMZ8I2VYzd9uly3973g2BQTH2df4+fWxwE3qZllE3tkNINIyKegv/T
         ghSqIcuutAVfI0ExFBHYyo9anwdYVYD5T2eummj23dBAM/EhC787yd4ZKXGQ9kYY5dEP
         J43E6RHrdnqr6ioMbWhlcvST53B+Dp5mtlHhsGTt5h65slrFKU+VJN/biNO2NNVmtRap
         UTBkrMQ47JX+aY8WWWM7m/knP3CMsCCrA3ikvZoB5qBMyA9ZHqJUz1G1n30/9a7t8mLT
         8CyCAULulbEGa/2m2ZMmashbkZHfgjUxgIdfsgoYWQhW0Jw04FCL3qfnClF9h6fhZcjQ
         pmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WodcJpWVZbO4g1u0/wCvmEoR70ko/sm4LwMAucejRls=;
        b=CirDps+Dtk/QROecU6wB7dHXX9rRmrJvheNjdTbXQDtpVp+UQA+zOv7oDePRhKK7OS
         VPwD6HJCPoh830p6XqQJQ3VOUkmMAR8QLIM+lknryWvHPjno34MS5Uqo474zgDZHbnsP
         mGzyEK6jONhMIsK7yo6f9HZKjTdcBbib4TvuFyEeTOdRlWuqUSx0jUacIHAxJ13f5oJa
         pWSCPnqN3Sy+zmz+jkL3Ld8RpCCVHax5kqeVh7nyMt8k1ThsVY/6kW89TBKbWx9mRGVb
         CldID39qp+NZxp9gl988R9MRPzxkqd74Pd9TxU6lQLECHxpowCFjHiwYFyh9rgvPvAbz
         FZCw==
X-Gm-Message-State: APjAAAUpf2J5SuKsCY8ehOqwNPrNx2fn8+0YjztWDsuO7QqtN+Jln8YN
        +ZUpsXmOMQ/f9v9DUi3qyMg=
X-Google-Smtp-Source: APXvYqzo8O3jsse+rjMnqyhW5avmp8YN+er4F6CTpw00IkbjFGDzl0utB0Gqrs+hNsnfwM6v1BnkqA==
X-Received: by 2002:a17:902:be06:: with SMTP id r6mr21951006pls.99.1580236358553;
        Tue, 28 Jan 2020 10:32:38 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id u7sm20435255pfh.128.2020.01.28.10.32.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jan 2020 10:32:37 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
Date:   Tue, 28 Jan 2020 10:32:36 -0800
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6E9D4FAF-D484-49FD-8AAB-29470F8966CC@gmail.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
 <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
 <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
 <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
 <20200127205606.GC2523@linux.intel.com>
 <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jan 28, 2020, at 9:59 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
>>> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> =
wrote:
>>>>>=20
>>>>> If I had to guess, you probably have SMM malware on your host. =
Remove
>>>>> the malware, and the test should pass.
>>>>=20
>>>> Well, malware will always be an option, but I doubt this is the =
case.
>>>=20
>>> Was my innuendo too subtle? I consider any code executing in SMM to =
be malware.
>>=20
>> SMI complications seem unlikely.  The straw that broke the camel's =
back
>> was a 1152 cyle delta, presumably the other failing runs had similar =
deltas.
>> I've never benchmarked SMI+RSM, but I highly doubt it comes anywhere =
close
>> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. I
>> wouldn't be surprised if just SMI+RSM is over 1500 cycles.
>=20
> Good point. What generation of hardware are you running on, Nadav?
>=20
>>>> Interestingly, in the last few times the failure did not reproduce. =
Yet,
>>>> thinking about it made me concerned about MTRRs configuration, and =
that
>>>> perhaps performance is affected by memory marked as UC after boot, =
since
>>>> kvm-unit-test does not reset MTRRs.
>>>>=20
>>>> Reading the variable range MTRRs, I do see some ranges marked as UC =
(most of
>>>> the range 2GB-4GB, if I read the MTRRs correctly):
>>>>=20
>>>>  MSR 0x200 =3D 0x80000000
>>>>  MSR 0x201 =3D 0x3fff80000800
>>>>  MSR 0x202 =3D 0xff000005
>>>>  MSR 0x203 =3D 0x3fffff000800
>>>>  MSR 0x204 =3D 0x38000000000
>>>>  MSR 0x205 =3D 0x3f8000000800
>>>>=20
>>>> Do you think we should set the MTRRs somehow in KVM-unit-tests? If =
yes, can
>>>> you suggest a reasonable configuration?
>>>=20
>>> I would expect MTRR issues to result in repeatable failures. For
>>> instance, if your VMCS ended up in UC memory, that might slow things
>>> down quite a bit. But, I would expect the VMCS to end up at the same
>>> address each time the test is run.
>>=20
>> Agreed on the repeatable failures part, but putting the VMCS in UC =
memory
>> shouldn't affect this type of test.  The CPU's internal VMCS cache =
isn't
>> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen to =
be
>> UC.
>=20
> But the internal VMCS cache only contains selected fields, doesn't it?
> Uncached fields would have to be written to memory on VM-exit. Or are
> all of the mutable fields in the internal VMCS cache?

In that regard, the SDM says that "To ensure proper behavior in VMX
operation, software should maintain the VMCS region and related =
structures
(enumerated in Section 24.11.4) in writeback cacheable memory.=E2=80=9D

Is it relevant? This means the MTRRs should be set up regardless of the
RDTSC test failure.

I did not have time to further investigate this issue yet. I did =
encounter
additional strange failures (EPT A/D and PML test failures, which are
persistent) due to Paolo=E2=80=99s patch that allows memory above 4GB to =
be used, so
I need to see if these issues are somehow related.


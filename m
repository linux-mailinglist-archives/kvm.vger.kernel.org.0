Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CF614C07F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 20:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA1TDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 14:03:05 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46829 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgA1TDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 14:03:05 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so5461002pll.13
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 11:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=meR2z+oikEcAPESh6OpEj9x7pSthc1jFdSDLvI7rv94=;
        b=OPW0DZHd1pYzhlWJvg9Y2xSJE6xFotEUvv1lWDhOTJhRAThHzC3hUV+L+4FGpgoabz
         eQeN48DwRkjbNlHFnZ4OLqfFbxTUXK7kxMXVN247izHqEIQyubVFOJ0yvUAyxunLGJjA
         1qHP7cE6ccfNzZ8T15s0EDSctbzY0dQysmYjgjPA2zOMPHJ9x3r6u45s3dt2uNOKYwEB
         MboIKu0wQcKkEbIH1NGduaft1wNwyhMYSQpCAY9IfWN1mxU1TQ4c+dSFDW7q9w2eI3+i
         qewCFV7HAnddsWm/E7Ixl3UukU+kMKxi5YR+N9Y4PZVwVZHzxqxdbamqiM/ccnmBtxeJ
         aiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=meR2z+oikEcAPESh6OpEj9x7pSthc1jFdSDLvI7rv94=;
        b=DzZg+w3p/TXXE9MEQ3Re9ltGP11DlEG3vYylbrlLvvHsPwQO4TYmidoyuf6mgQZ7/d
         /B24/YiwSo96Ndx0xrm2ijxzHNj0rol6jolEtGYqcITY+eC7jOZ78I1l8514x2nS0Krg
         yTwiLIi1sfCY4xLeibkLkrr1cemd7IzhOIKiLLuxWjSSmOkr2pXunU8lrHRDRtMw738U
         x+W5mFfzdajq1uBXYJosHWlok47BZRJbGfPRapS0aul2EIokwgowEyccdX0sMMJPT6AB
         ek3u6RDX3NNFYaWaBhY7YFtmRvaiQva6GrKA959lRltzpyckuQMcFeRBK6kZERoXZSWE
         PYfw==
X-Gm-Message-State: APjAAAUH9VmyD/XhnW2Pg7+ySOtPj7ULAjUHgEQyJ5XcwCiRUmpCE+VQ
        dprRslj0J/EH88d5OS/RGGc=
X-Google-Smtp-Source: APXvYqyJkPBeZ0vOktM4BNZFeX0cn3n1l5/A5Z87GrdGS3lHR1uPsX37CYyGW8PVVcBJYovEdgs5sw==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr24389867plp.156.1580238183682;
        Tue, 28 Jan 2020 11:03:03 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id k21sm21092879pgt.22.2020.01.28.11.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jan 2020 11:03:02 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eQF_afgLw6vRq8wHQT1kQsVAfz-PcAymVepqD2018d-BA@mail.gmail.com>
Date:   Tue, 28 Jan 2020 11:03:01 -0800
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <961A121B-2572-4FAC-BBD6-30A84D5A4EFD@gmail.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
 <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
 <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
 <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
 <CALMp9eQYS3W5_PB8wP36UBBGHRHSoJmBDUEJ95AUcXYQ1sC9mQ@mail.gmail.com>
 <20200127205606.GC2523@linux.intel.com>
 <CALMp9eRrE5onJT4HgfCqrxMYYVjaeVMDT4YKVA2mr4jfT7jkaA@mail.gmail.com>
 <20200128183345.GB18652@linux.intel.com>
 <71E3EDDD-9DEA-43A1-BD77-FD31F10D8DEA@gmail.com>
 <CALMp9eQF_afgLw6vRq8wHQT1kQsVAfz-PcAymVepqD2018d-BA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jan 28, 2020, at 10:43 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Tue, Jan 28, 2020 at 10:42 AM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> On Jan 28, 2020, at 10:33 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> On Tue, Jan 28, 2020 at 09:59:45AM -0800, Jim Mattson wrote:
>>>> On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
>>>> <sean.j.christopherson@intel.com> wrote:
>>>>> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
>>>>>> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>>>> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> =
wrote:
>>>>>>>>=20
>>>>>>>> If I had to guess, you probably have SMM malware on your host. =
Remove
>>>>>>>> the malware, and the test should pass.
>>>>>>>=20
>>>>>>> Well, malware will always be an option, but I doubt this is the =
case.
>>>>>>=20
>>>>>> Was my innuendo too subtle? I consider any code executing in SMM =
to be malware.
>>>>>=20
>>>>> SMI complications seem unlikely.  The straw that broke the camel's =
back
>>>>> was a 1152 cyle delta, presumably the other failing runs had =
similar deltas.
>>>>> I've never benchmarked SMI+RSM, but I highly doubt it comes =
anywhere close
>>>>> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. =
I
>>>>> wouldn't be surprised if just SMI+RSM is over 1500 cycles.
>>>>=20
>>>> Good point. What generation of hardware are you running on, Nadav?
>>>=20
>>> Skylake.
>>=20
>> Indeed. Thanks for answering on my behalf ;-)
>>=20
>>>>>>> Interestingly, in the last few times the failure did not =
reproduce. Yet,
>>>>>>> thinking about it made me concerned about MTRRs configuration, =
and that
>>>>>>> perhaps performance is affected by memory marked as UC after =
boot, since
>>>>>>> kvm-unit-test does not reset MTRRs.
>>>>>>>=20
>>>>>>> Reading the variable range MTRRs, I do see some ranges marked as =
UC (most of
>>>>>>> the range 2GB-4GB, if I read the MTRRs correctly):
>>>>>>>=20
>>>>>>> MSR 0x200 =3D 0x80000000
>>>>>>> MSR 0x201 =3D 0x3fff80000800
>>>>>>> MSR 0x202 =3D 0xff000005
>>>>>>> MSR 0x203 =3D 0x3fffff000800
>>>>>>> MSR 0x204 =3D 0x38000000000
>>>>>>> MSR 0x205 =3D 0x3f8000000800
>>>>>>>=20
>>>>>>> Do you think we should set the MTRRs somehow in KVM-unit-tests? =
If yes, can
>>>>>>> you suggest a reasonable configuration?
>>>>>>=20
>>>>>> I would expect MTRR issues to result in repeatable failures. For
>>>>>> instance, if your VMCS ended up in UC memory, that might slow =
things
>>>>>> down quite a bit. But, I would expect the VMCS to end up at the =
same
>>>>>> address each time the test is run.
>>>>>=20
>>>>> Agreed on the repeatable failures part, but putting the VMCS in UC =
memory
>>>>> shouldn't affect this type of test.  The CPU's internal VMCS cache =
isn't
>>>>> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen =
to be
>>>>> UC.
>>>>=20
>>>> But the internal VMCS cache only contains selected fields, doesn't =
it?
>>>> Uncached fields would have to be written to memory on VM-exit. Or =
are
>>>> all of the mutable fields in the internal VMCS cache?
>>>=20
>>> Hmm.  I can neither confirm nor deny?  The official Intel response =
to this
>>> would be "it's microarchitectural".  I'll put it this way: it's in =
Intel's
>>> best interest to minimize the latency of VMREAD, VMWRITE, VM-Enter =
and
>>> VM-Exit.
>>=20
>> I will run some more experiments and get back to you. It is a shame =
that
>> every experiment requires a (real) boot=E2=80=A6
>=20
> Yes! It's not just a shame; it's a serious usability issue.

The easy way to run these experiments would have been to use an Intel =
CRB
(Customer Reference Board), which boots relatively fast, with an ITP
(In-Target Probe). This would have simplified testing and debugging
considerably. Perhaps some sort of PXE-boot would also be beneficial.
Unfortunately, I do not have the hardware and it does not seem other =
care
that much so far.

Despite the usability issues, running the tests on bare-metal already
revealed several bugs in KVM (and one SDM issue), which were not =
apparent
since the tests were wrong.


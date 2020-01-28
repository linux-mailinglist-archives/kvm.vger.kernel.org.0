Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D214C003
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgA1SmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:42:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42060 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgA1SmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 13:42:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so7109658pfz.9
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 10:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rN96JUgZ4RAnMxy+du12kc+p+cjbag46Jd1yIYyFwIc=;
        b=oNHp7n5sRdEXW6ziQlVHqrWa+9W/Ak3K01lrkGxUAyzclyhpMY9u7D3yhXFOolB0PV
         819Ff4LRfNE8ErgECueyjZY9cW22STG8zs2XYkpAGmpiNsPh7X9wsmKC5T0R30BC80Gz
         lKWHdm6QnDo3xB282C7AyNis0UhRAJ6QaChtcoUwc4gW68dMqupXvtf/FlYoXgjgyI69
         zXH1+a0terKUbGAwfn2vB7p7g5bjrsbs6UYniXRlt4VI0oWo+GWjAWmsbk1R6MC3ymEH
         s8GUXiCT0jQnX9IwPX5ZZUEiQNwClSp1Hzz210wfp82MRivT3uH/q30WFBliAPutFsQw
         4IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rN96JUgZ4RAnMxy+du12kc+p+cjbag46Jd1yIYyFwIc=;
        b=slOXuEtSTC8FLpdXOa0d3KmnF4qwo+OiAGIhY0oNmcRFrMuir0FIhiCvNEa0fESsoH
         P2HWplKAs4GQJizll0n0Z4QWEkOG8bXfWY5CEDJGjfN/nB2mv31+/gyE6+42DlKPj0zM
         QmCPVyj1ZoXj6yC6qoy14lgMHETATK7dBulncTLbtK3DgK/s3AJ8WC1iNt0GRGIn7hk0
         voVCwIzzjrig29sdjKUX3W4ZbrKy6p8nGYHHgbkeexVDvJk47mwgwFYYBrcPS8T0NXSW
         W+JZy6WQQ4Pif1FTcFbV3e0gnp8pVtKZN9AlAzjPteoJnu3An4PfdMe3QowEvKp30PZb
         V/XQ==
X-Gm-Message-State: APjAAAXha698IOwJVRLZQCSoDNCWj7201luP8xKMMmyQK2YccsoP2qQ+
        DNlmyrNIwaWp17IBWz8QH/OCO256l7E=
X-Google-Smtp-Source: APXvYqxjUeicRDYBsjJMVaxY0a0GgC2VM0C9SO+2Xmimm04YXwj2rI4x8TwK1OI9RjaZwez5PbN4JQ==
X-Received: by 2002:a62:2cd8:: with SMTP id s207mr5217151pfs.247.1580236930050;
        Tue, 28 Jan 2020 10:42:10 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id g10sm20060861pgh.35.2020.01.28.10.42.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jan 2020 10:42:08 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200128183345.GB18652@linux.intel.com>
Date:   Tue, 28 Jan 2020 10:42:07 -0800
Cc:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <71E3EDDD-9DEA-43A1-BD77-FD31F10D8DEA@gmail.com>
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
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jan 28, 2020, at 10:33 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Jan 28, 2020 at 09:59:45AM -0800, Jim Mattson wrote:
>> On Mon, Jan 27, 2020 at 12:56 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>> On Mon, Jan 27, 2020 at 11:24:31AM -0800, Jim Mattson wrote:
>>>> On Sun, Jan 26, 2020 at 8:36 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> =
wrote:
>>>>>>=20
>>>>>> If I had to guess, you probably have SMM malware on your host. =
Remove
>>>>>> the malware, and the test should pass.
>>>>>=20
>>>>> Well, malware will always be an option, but I doubt this is the =
case.
>>>>=20
>>>> Was my innuendo too subtle? I consider any code executing in SMM to =
be malware.
>>>=20
>>> SMI complications seem unlikely.  The straw that broke the camel's =
back
>>> was a 1152 cyle delta, presumably the other failing runs had similar =
deltas.
>>> I've never benchmarked SMI+RSM, but I highly doubt it comes anywhere =
close
>>> to VM-Enter/VM-Exit's super optimized ~400 cycle round trip.  E.g. I
>>> wouldn't be surprised if just SMI+RSM is over 1500 cycles.
>>=20
>> Good point. What generation of hardware are you running on, Nadav?
>=20
> Skylake.

Indeed. Thanks for answering on my behalf ;-)

>=20
>>>>> Interestingly, in the last few times the failure did not =
reproduce. Yet,
>>>>> thinking about it made me concerned about MTRRs configuration, and =
that
>>>>> perhaps performance is affected by memory marked as UC after boot, =
since
>>>>> kvm-unit-test does not reset MTRRs.
>>>>>=20
>>>>> Reading the variable range MTRRs, I do see some ranges marked as =
UC (most of
>>>>> the range 2GB-4GB, if I read the MTRRs correctly):
>>>>>=20
>>>>>  MSR 0x200 =3D 0x80000000
>>>>>  MSR 0x201 =3D 0x3fff80000800
>>>>>  MSR 0x202 =3D 0xff000005
>>>>>  MSR 0x203 =3D 0x3fffff000800
>>>>>  MSR 0x204 =3D 0x38000000000
>>>>>  MSR 0x205 =3D 0x3f8000000800
>>>>>=20
>>>>> Do you think we should set the MTRRs somehow in KVM-unit-tests? If =
yes, can
>>>>> you suggest a reasonable configuration?
>>>>=20
>>>> I would expect MTRR issues to result in repeatable failures. For
>>>> instance, if your VMCS ended up in UC memory, that might slow =
things
>>>> down quite a bit. But, I would expect the VMCS to end up at the =
same
>>>> address each time the test is run.
>>>=20
>>> Agreed on the repeatable failures part, but putting the VMCS in UC =
memory
>>> shouldn't affect this type of test.  The CPU's internal VMCS cache =
isn't
>>> coherent, and IIRC isn't disabled if the MTRRs for the VMCS happen =
to be
>>> UC.
>>=20
>> But the internal VMCS cache only contains selected fields, doesn't =
it?
>> Uncached fields would have to be written to memory on VM-exit. Or are
>> all of the mutable fields in the internal VMCS cache?
>=20
> Hmm.  I can neither confirm nor deny?  The official Intel response to =
this
> would be "it's microarchitectural".  I'll put it this way: it's in =
Intel's
> best interest to minimize the latency of VMREAD, VMWRITE, VM-Enter and
> VM-Exit.

I will run some more experiments and get back to you. It is a shame that
every experiment requires a (real) boot=E2=80=A6


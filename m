Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A943FC2BAF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 03:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfJAB36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 21:29:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39691 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfJAB36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 21:29:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so6710953pff.6
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 18:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GjLol3BRm0Gt4DDsWaX4tpcuSnFfm0uQsNCckzcUeaY=;
        b=bAMblDrtkrCbqWsm93Jt+4PgJk18axx3zCswRa/TazzhRhA+jUeQXO3gtNB6Bw+Enb
         ykxvMuJQqD00JGS/Krh3nGddnBbYLgICyB5APUGs1g6CXEx5vc5YgqDogOvT6RS/5QqT
         Pb28EFHvu/s14/siV6FI8Er2MmqKwkRzPYs0xnpyI4KXwM2+uwVS9x9I82cBGR59zFby
         YwXE62maiToRvB4tBOyaqqQaYmyZdh5xpLVRLI41xe79z7nIz4AeEjAc9juJEtnzT/0/
         9frJffsJHFsomu2GcMneWo7t0e+3YEni3jiNfvpPQgNDedDhutjedS9QW6P47iNO+Hg1
         4M3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GjLol3BRm0Gt4DDsWaX4tpcuSnFfm0uQsNCckzcUeaY=;
        b=j5qUOHv6khcnbMKVj5NgXVe9Sxu610vePakZfCQK+VR+9YdymeZfhZ0xH1Uymoaguu
         dpCBilahBvbEVNKm5Opkfmq9nyhSRFJ4Fp0Qx2pRFfamIEsQGhs6zmk7dpjQkCRarcVP
         wYZUj2TU1Q66XuhAJd/NzRcZHBVJG7kJ4u1f1qRV+VYWclQBesxZD9/3a5K3izJsLmUm
         wifgjNBgch6p6dolHS8yAkeqqhc4hX9DLjzOlQrwqLrNoAIbpYWAXdmWcqzUjYPlfXsH
         aEyI3hFjh7XIixM95s1WZg6HmkcSWzEQZgD0mDkCr1GlmTDm0O93gwo7/xltqBk4VFYJ
         juWw==
X-Gm-Message-State: APjAAAVBy8cPUtp6s77z78QPEO4ERW5Q1cpxyimAEzSxKVbTWxSM4nmV
        Az7Pop95FucKefzG0pnapK4=
X-Google-Smtp-Source: APXvYqwoc5XQwX5v9YnGRq5KwnLNBzWdKY/mdbpss+1o14Uw2B56DatLam7mNjV+cxtZZ/GWG7Gd0A==
X-Received: by 2002:a17:90a:28c5:: with SMTP id f63mr2461714pjd.67.1569893395526;
        Mon, 30 Sep 2019 18:29:55 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id k9sm13070129pfk.72.2019.09.30.18.29.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 18:29:54 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
Date:   Mon, 30 Sep 2019 18:29:52 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 30, 2019, at 6:23 PM, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 1 Oct 2019, at 4:14, Nadav Amit <nadav.amit@gmail.com> wrote:
>>=20
>>> On Sep 30, 2019, at 5:48 PM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>=20
>>>=20
>>>=20
>>>> On 1 Oct 2019, at 2:02, Nadav Amit <nadav.amit@gmail.com> wrote:
>>>>=20
>>>>> On Sep 19, 2019, at 5:52 AM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>>>=20
>>>>> Hi,
>>>>>=20
>>>>> This patch series aims to add a vmx test to verify the =
functionality
>>>>> introduced by KVM commit:
>>>>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>>>>>=20
>>>>> The test verifies the following functionality:
>>>>> 1) An INIT signal received when CPU is in VMX operation
>>>>> is latched until it exits VMX operation.
>>>>> 2) If there is an INIT signal pending when CPU is in
>>>>> VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
>>>>> 3) Exit from VMX non-root mode on VMExit do not clear
>>>>> pending INIT signal in LAPIC.
>>>>> 4) When CPU exits VMX operation, pending INIT signal in
>>>>> LAPIC is processed.
>>>>>=20
>>>>> In order to write such a complex test, the vmx tests framework was
>>>>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>>>>> implemented in patches 1-7. The test itself is implemented at =
patch 8.
>>>>> This enhancement to the vmx tests framework is a bit hackish, but
>>>>> I believe it's OK because this functionality is rarely required by
>>>>> other VMX tests.
>>>>>=20
>>>>> Regards,
>>>>> -Liran
>>>>=20
>>>> Hi Liran,
>>>>=20
>>>> I ran this test on bare-metal and it fails:
>>>>=20
>>>> Test suite: vmx_init_signal_test
>>>> PASS: INIT signal blocked when CPU in VMX operation
>>>> PASS: INIT signal during VMX non-root mode result in exit-reason =
VMX_INIT (3)
>>>> FAIL: INIT signal processed after exit VMX operation
>>>> SUMMARY: 8 tests, 1 unexpected failures
>>>>=20
>>>> I don=E2=80=99t have time to debug this issue, but let me know if =
you want some
>>>> print-outs.
>>>>=20
>>>> Nadav
>>>=20
>>> Thanks Nadav for running this on bare-metal. This is very useful!
>>>=20
>>> It seems that when CPU exited on exit-reason VMX_INIT (3), the LAPIC =
INIT pending event
>>> was consumed instead of still being latched until CPU exits VMX =
operation.
>>>=20
>>> In my commit which this unit-test verifies 4b9852f4f389 ("KVM: x86: =
Fix INIT signal handling in various CPU states=E2=80=9D),
>>> I have assumed that such exit-reason don=E2=80=99t consume the LAPIC =
INIT pending event.
>>> My assumption was based on the phrasing of Intel SDM section 25.2 =
OTHER CAUSES OF VM EXITS regarding INIT signals:
>>> "Such exits do not modify register state or clear pending events as =
they would outside of VMX operation."
>>> I thought Intel logic behind this is that if an INIT signal is sent =
to a CPU in VMX non-root mode, it would exit
>>> on exit-reason 3 which would allow hypervisor to decide to exit VMX =
operation in order to consume INIT signal.
>>=20
>> I think this sentence can be read differently. It also reasonable not =
to
>> bound the host to get an INIT signal the moment it disabled vmx.
>=20
> If INIT signal won=E2=80=99t be kept pending until exiting VMX =
operation, target CPU which was sent with INIT signal
> when it was running guest, basically lost INIT signal forever and just =
received an exit-reason it cannot do much with.
> That=E2=80=99s why I thought Intel designed this mechanism like I =
specified above.

Well, the host can always issue an INIT using an IPI.

>=20
> I also remembered to verify this behaviour against some discussions =
made online:
> 1) =
https://software.intel.com/en-us/forums/virtualization-software-developmen=
t/topic/355484
> * "When the 16-bit guest issues an INIT IPI to itself using the APIC, =
I run into an infinite VMExit situation that my hypervisor cannot seem =
to recover from.=E2=80=9D
> * "In response to the VMExit with a reason of 3 (which is expected), =
the hypervisor resets the 16-bit guest's registers, limits, access =
rights, etc. to simulate starting execution from a known initialization =
point.  However, it seems that as soon as the hypervisor resumes guest =
execution, the VMExit occurs again, repeatedly.=E2=80=9D
> 2) https://patchwork.kernel.org/patch/2244311/
> "I actually find it very useful. On INIT vmexit hypervisor may call =
vmxoff and do proper reset."
>=20
> Anyway, Sean, can you assist verifying inside Intel what should be the =
expected behaviour?

It might always be (yet) another kvm-unit-tests bug that is only =
apparent on
bare-metal. But if Sean can confirm what the expected behavior is, it =
would
save time.

I do not have an ITP, so debugging on bare-metal is not fun at all...


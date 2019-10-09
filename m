Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68AD17EF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfJITAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 15:00:47 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46121 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJITAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 15:00:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so2190330pfg.13
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 12:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stDmN6TKePUIXeps+xk6We78kT7Ipd8kFD7nNNIjAn8=;
        b=csX2M7iajluBeCzKDUjRG0A3vBzuZHOl55PKHMhbOa9sObrv1KftTJsZjZAQ6bEfZO
         iwvikGITrJKTjIMw9An+v1e+zIWRVnRXmKemQ8w9B6MVz5Q//SJ9zsUCx3VL/70Np56e
         WqAjqYl1Qcjkr9D9HPx+wGb/D8qFRnbg0EOJxctP50b0yck108dJE7H+7Fwy4yZjXEBg
         yMwWr9nMJQhUQ4tL6VSMQwbEWTjg4tU/nOhaztN/Qm0dLVtrye7DPwPwAsNFChEGHDc4
         7Ts3XnK5SKgqrMyHO7Xr1H3p4wHTZ5j/Yz2hVQ1tpGmxbz4wSrxgmh8XuBNRTmY3JFAS
         jaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=stDmN6TKePUIXeps+xk6We78kT7Ipd8kFD7nNNIjAn8=;
        b=hoFtutwhJ1kwEzVXy+6zDnI1aJZQRpYdCh9oueMlwpND2YGgiaGu9qrTQN5FAKwa3n
         HYU5hLxrphS+htJgMd8rO8VpRth/R/prea0Veg1FDSSs3ptUrQCB4Jd5vUqtqb2oqZO5
         eA1IavHic3ieW2NrGj7Y3XvX0JfnI7v0LY57PFSaUCqaAZIsAfNsGcVE/f4L5aZk7lMj
         WYYScqfT+eAYsvFHRIEjrmuyM4ukJ8SZ2gKOfvcyA/P3l45wjlFqk+J235oV2tJh//7k
         v6FkcEKGs4xHnIfsaCTwRDU/k6cwcr/lTe84//t3djKcNizd3Im1v1q/M61SuWg31Xlh
         Ysdw==
X-Gm-Message-State: APjAAAWQZCrrmfjqmKlOtZq+oUk/rKWNmEJuxA8NdxGgjLLCbL49X4NW
        TDUsNnmTFSbdRM9L6lonyYE=
X-Google-Smtp-Source: APXvYqwXY+W29SKl1ZEsc/guFS0UyI9H4TmewfbjLG6Krr7t1yon1wM7Oo88i8voZRjs6chnUEgZ8A==
X-Received: by 2002:a65:66d1:: with SMTP id c17mr5911112pgw.169.1570647645472;
        Wed, 09 Oct 2019 12:00:45 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id w189sm3321130pfw.101.2019.10.09.12.00.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 12:00:44 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: KVM-unit-tests on AMD
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <8f1df357-b186-5899-79e1-b5d727a46c4e@redhat.com>
Date:   Wed, 9 Oct 2019 12:00:43 -0700
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BE39EBF-F1F0-4BB5-AC90-AEB934A6DA38@gmail.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com>
 <912C44BF-308B-4F74-A145-04FF58F94046@gmail.com>
 <E01ED83B-53E8-4AEE-915C-3AE1DA1660E8@gmail.com>
 <6534845f-df5b-67d7-57b8-e049bb258db6@redhat.com>
 <96411F08-F442-42E1-9F28-33365184BFED@gmail.com>
 <8f1df357-b186-5899-79e1-b5d727a46c4e@redhat.com>
To:     Cathy Avery <cavery@redhat.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Oct 9, 2019, at 11:53 AM, Cathy Avery <cavery@redhat.com> wrote:
>=20
> On 10/9/19 1:32 PM, Nadav Amit wrote:
>> On Oct 9, 2019, at 4:39 AM, Cathy Avery <cavery@redhat.com> wrote:
>>> On 10/8/19 4:02 PM, Nadav Amit wrote:
>>>>> On Oct 8, 2019, at 9:30 AM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>=20
>>>>>> On Oct 8, 2019, at 5:19 AM, Vitaly Kuznetsov =
<vkuznets@redhat.com> wrote:
>>>>>>=20
>>>>>> Nadav Amit <nadav.amit@gmail.com> writes:
>>>>>>=20
>>>>>>> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>>>>>> It is supposed to but it doesn't :-) Actually, not only =
kvm-unit-tests
>>>>>> but the whole SVM would appreciate some love ...
>>>>>>=20
>>>>>>> Clearly, I ask since they do not pass on AMD on bare-metal.
>>>>>> On my AMD EPYC 7401P 24-Core Processor bare metal I get the =
following
>>>>>> failures:
>>>>>>=20
>>>>>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>>>>>=20
>>>>>> (Why can't we just check
>>>>>> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>>>>>>=20
>>>>>> FAIL svm (15 tests, 1 unexpected failures)
>>>>>>=20
>>>>>> There is a patch for that:
>>>>>>=20
>>>>>> =
https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.co=
m/T/#t
>>>>>>=20
>>>>>> Inside a VM on this host I see the following:
>>>>>>=20
>>>>>> FAIL apic-split (timeout; duration=3D90s)
>>>>>> FAIL apic (timeout; duration=3D30)
>>>>>>=20
>>>>>> (I manually inreased the timeout but it didn't help - this is =
worrisome,
>>>>>> most likely this is a hang)
>>>>>>=20
>>>>>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>>>>>=20
>>>>>> - same as on bare metal
>>>>>>=20
>>>>>> FAIL port80 (timeout; duration=3D90s)
>>>>>>=20
>>>>>> - hang again?
>>>>>>=20
>>>>>> FAIL svm (timeout; duration=3D90s)
>>>>>>=20
>>>>>> - most likely a hang but this is 3-level nesting so oh well..
>>>>>>=20
>>>>>> FAIL kvmclock_test
>>>>>>=20
>>>>>> - bad but maybe something is wrong with TSC on the host? Need to
>>>>>> investigate ...
>>>>>>=20
>>>>>> FAIL hyperv_clock
>>>>>>=20
>>>>>> - this is expected as it doesn't work when the clocksource is not =
TSC
>>>>>> (e.g. kvm-clock)
>>>>>>=20
>>>>>> Are you seeing different failures?
>>>>> Thanks for your quick response.
>>>>>=20
>>>>> I only ran the =E2=80=9Capic=E2=80=9D tests so far and I got the =
following failures:
>>>>>=20
>>>>> FAIL: correct xapic id after reset
>>>>> =E2=80=A6
>>>>> x2apic not detected
>>>>> FAIL: enable unsupported x2apic
>>>>> FAIL: apicbase: relocate apic
>>>>>=20
>>>>> The test gets stuck after =E2=80=9Capicbase: reserved low bits=E2=80=
=9D.
>>>>>=20
>>>>> Well, I understand it is not a bare-metal thing.
>>>> I ran the SVM test, and on bare-metal it does not pass.
>>>>=20
>>>> I don=E2=80=99t have the AMD machine for long enough to fix the =
issues, but for the
>>>> record, here are test failures and crashes I encountered while =
running the
>>>> tests on bare-metal.
>>>>=20
>>>> Failures:
>>>> - cr3 read intercept emulate
>>>> - npt_nx
>>>> - npt_rsvd
>>>> - npt_rsvd_pfwalk
>>>> - npt_rw_pfwalk
>>>> - npt_rw_l1mmio
>>>>=20
>>>> Crashes:
>>>> - test_dr_intercept - Access to DR4 causes #UD
>>>> - tsc_adjust_prepare - MSR access causes #GP
>>>>=20
>>> Interesting. I just ran the latest on bare-metal and it did pass.
>>>=20
>>> enabling apic
>>> enabling apic
>>> paging enabled
>>> cr0 =3D 80010011
>>> cr3 =3D 62a000
>>> cr4 =3D 20
>>> NPT detected - running all tests with NPT enabled
>>> PASS: null
>>> PASS: vmrun
>>> PASS: ioio
>>> PASS: vmrun intercept check
>>> PASS: cr3 read intercept
>>> PASS: cr3 read nointercept
>>> PASS: cr3 read intercept emulate
>>> PASS: dr intercept check
>>> PASS: next_rip
>>> PASS: msr intercept check
>>> PASS: mode_switch
>>> PASS: asid_zero
>>> PASS: sel_cr0_bug
>>> PASS: npt_nx
>>> PASS: npt_us
>>> PASS: npt_rsvd
>>> PASS: npt_rw
>>> PASS: npt_rsvd_pfwalk
>>> PASS: npt_rw_pfwalk
>>> PASS: npt_l1mmio
>>> PASS: npt_rw_l1mmio
>>> PASS: tsc_adjust
>>>     Latency VMRUN : max: 49300 min: 3160 avg: 3228
>>>     Latency VMEXIT: max: 607780 min: 2940 avg: 2999
>>> PASS: latency_run_exit
>>>     Latency VMLOAD: max: 29720 min: 300 avg: 306
>>>     Latency VMSAVE: max: 31660 min: 280 avg: 282
>>>     Latency STGI:   max: 18860 min: 40 avg: 54
>>>     Latency CLGI:   max: 16060 min: 40 avg: 53
>>> PASS: latency_svm_insn
>>> SUMMARY: 24 tests
>> Just to make sure, you actually ran it on bare-metal? Without KVM?
>>=20
> The tests were run on a Fedora 29 server with recent upstream kernel, =
qemu, and yes with KVM.

So I regard a different setup - No KVM, running the tests directly
on bare-metal. Running tests in this manner exposes bugs in the
tests themselves, since they sometime make the wrong assumption on
how hardware behaves.

And of course bugs in the tests sometimes indicate bugs in KVM as
well. For instance:

=
https://lore.kernel.org/kvm/20190919125211.18152-6-liran.alon@oracle.com/T=
/#ebb7e52ae77cccbc8b2455466b34c2e28a9b4c56d
https://patchwork.kernel.org/patch/10951713/


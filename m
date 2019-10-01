Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D3C2BA7
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 03:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfJABYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 21:24:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfJABYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 21:24:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x911IvXv059071;
        Tue, 1 Oct 2019 01:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=4fnxShBCZyI1efD67f2WxwsWEI4ezVbnpV62xIWvC0U=;
 b=SQlr+mtclGWTxB/LgDu2W0AYY6vF9WlSTxTrQ93bD3wlVqh91zt+mWmlf3Iuo06Gmie1
 9oHT22D5ac91D/fO/wCFVnqTGzg84Ef7ap37JnQl3AhT3NIknPRSROZZlePgRToeJXO8
 fuEJ92WQ5mVsZuBSTIatRoZp0HOPnrEvSu+VASils54RZ3oIybn62ICQHnPUigHxzm9i
 WpHvDL8FmbnnRUcfTtFVxxnpt1I78cHIjXk1flvPsyyBcbH4go6BeMY/XFYirdhJjoKZ
 V6G3ydNdeaiLKf5LCQIbAULoWHjQsKsErroEC56LPti9PthWZmrm+BTmNTJhlfL22hpk 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rjjrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 01:23:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x911Njdu073543;
        Tue, 1 Oct 2019 01:23:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vbmpxcxm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 01:23:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x911Ne48016904;
        Tue, 1 Oct 2019 01:23:40 GMT
Received: from [10.74.124.134] (/10.74.124.134)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 18:23:40 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
Date:   Tue, 1 Oct 2019 04:23:35 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
To:     Nadav Amit <nadav.amit@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010012
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 1 Oct 2019, at 4:14, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Sep 30, 2019, at 5:48 PM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 1 Oct 2019, at 2:02, Nadav Amit <nadav.amit@gmail.com> wrote:
>>>=20
>>>> On Sep 19, 2019, at 5:52 AM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>>=20
>>>> Hi,
>>>>=20
>>>> This patch series aims to add a vmx test to verify the =
functionality
>>>> introduced by KVM commit:
>>>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>>>>=20
>>>> The test verifies the following functionality:
>>>> 1) An INIT signal received when CPU is in VMX operation
>>>> is latched until it exits VMX operation.
>>>> 2) If there is an INIT signal pending when CPU is in
>>>> VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
>>>> 3) Exit from VMX non-root mode on VMExit do not clear
>>>> pending INIT signal in LAPIC.
>>>> 4) When CPU exits VMX operation, pending INIT signal in
>>>> LAPIC is processed.
>>>>=20
>>>> In order to write such a complex test, the vmx tests framework was
>>>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>>>> implemented in patches 1-7. The test itself is implemented at patch =
8.
>>>> This enhancement to the vmx tests framework is a bit hackish, but
>>>> I believe it's OK because this functionality is rarely required by
>>>> other VMX tests.
>>>>=20
>>>> Regards,
>>>> -Liran
>>>=20
>>> Hi Liran,
>>>=20
>>> I ran this test on bare-metal and it fails:
>>>=20
>>> Test suite: vmx_init_signal_test
>>> PASS: INIT signal blocked when CPU in VMX operation
>>> PASS: INIT signal during VMX non-root mode result in exit-reason =
VMX_INIT (3)
>>> FAIL: INIT signal processed after exit VMX operation
>>> SUMMARY: 8 tests, 1 unexpected failures
>>>=20
>>> I don=E2=80=99t have time to debug this issue, but let me know if =
you want some
>>> print-outs.
>>>=20
>>> Nadav
>>=20
>> Thanks Nadav for running this on bare-metal. This is very useful!
>>=20
>> It seems that when CPU exited on exit-reason VMX_INIT (3), the LAPIC =
INIT pending event
>> was consumed instead of still being latched until CPU exits VMX =
operation.
>>=20
>> In my commit which this unit-test verifies 4b9852f4f389 ("KVM: x86: =
Fix INIT signal handling in various CPU states=E2=80=9D),
>> I have assumed that such exit-reason don=E2=80=99t consume the LAPIC =
INIT pending event.
>> My assumption was based on the phrasing of Intel SDM section 25.2 =
OTHER CAUSES OF VM EXITS regarding INIT signals:
>> "Such exits do not modify register state or clear pending events as =
they would outside of VMX operation."
>> I thought Intel logic behind this is that if an INIT signal is sent =
to a CPU in VMX non-root mode, it would exit
>> on exit-reason 3 which would allow hypervisor to decide to exit VMX =
operation in order to consume INIT signal.
>=20
> I think this sentence can be read differently. It also reasonable not =
to
> bound the host to get an INIT signal the moment it disabled vmx.

If INIT signal won=E2=80=99t be kept pending until exiting VMX =
operation, target CPU which was sent with INIT signal
when it was running guest, basically lost INIT signal forever and just =
received an exit-reason it cannot do much with.
That=E2=80=99s why I thought Intel designed this mechanism like I =
specified above.

I also remembered to verify this behaviour against some discussions made =
online:
1) =
https://software.intel.com/en-us/forums/virtualization-software-developmen=
t/topic/355484
* "When the 16-bit guest issues an INIT IPI to itself using the APIC, I =
run into an infinite VMExit situation that my hypervisor cannot seem to =
recover from.=E2=80=9D
* "In response to the VMExit with a reason of 3 (which is expected), the =
hypervisor resets the 16-bit guest's registers, limits, access rights, =
etc. to simulate starting execution from a known initialization point.  =
However, it seems that as soon as the hypervisor resumes guest =
execution, the VMExit occurs again, repeatedly.=E2=80=9D
2) https://patchwork.kernel.org/patch/2244311/
"I actually find it very useful. On INIT vmexit hypervisor may call =
vmxoff and do proper reset."

Anyway, Sean, can you assist verifying inside Intel what should be the =
expected behaviour?

>=20
>> Nadav, can you attempt to just add a delay in =
init_signal_test_thread() between calling vmx_off() & setting =
init_signal_test_thread_continued to true?
>> It may be that real hardware delays a bit when the INIT signal is =
released from LAPIC after exit VMX operation.
>=20
> I added =E2=80=9Cdelay(100000)=E2=80=9D between them, but got the same =
result.
>=20

Weird. Then I have no idea why this happening=E2=80=A6

Thanks,
-Liran



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B64C2B6B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfJAAt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:49:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40944 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJAAt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:49:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910muD5040225;
        Tue, 1 Oct 2019 00:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=4VFTJtJR8eBtywmu4HtcI/CgatxgsSusKcadKjpNHMQ=;
 b=BYPOK0BHalANjoVF9l5l1Y39llRtnl/nKXaN1/k26TiEcEDMcLgnaK2CTEdbmZcgsBAI
 9Moc4flGVm0x3vBCW3VdoKkMuFxejDoaOihRTOD0Bm6q57Uc7zKOVC/oWFlkAbXu67Bl
 nu5Jj1kIbOpyMxJPghiU5pP1aAtnfZBdZl9bvyf4HN0hZGSkTjJwN2EtEzqV8BGkh5uM
 Lb0nLxXdiVYoSA1fLYTyYaZju4Lv6cUmL7gChNKO8F0BkEcZyc5dHsiIGIvxonVZkAM7
 gR1DKYpBp8dTNKl+Ix0eHXs+RTW7NJA5+5AjzbpvYrx8kIOSjDit2KLVPiv37kNriWXy kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxujk5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:48:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910lmuX030731;
        Tue, 1 Oct 2019 00:48:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vbnqbqwq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:48:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x910msPF014335;
        Tue, 1 Oct 2019 00:48:54 GMT
Received: from [192.168.14.112] (/79.183.234.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 17:48:54 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
Date:   Tue, 1 Oct 2019 03:48:50 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
To:     Nadav Amit <nadav.amit@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 1 Oct 2019, at 2:02, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Sep 19, 2019, at 5:52 AM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>> Hi,
>>=20
>> This patch series aims to add a vmx test to verify the functionality
>> introduced by KVM commit:
>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>>=20
>> The test verifies the following functionality:
>> 1) An INIT signal received when CPU is in VMX operation
>> is latched until it exits VMX operation.
>> 2) If there is an INIT signal pending when CPU is in
>> VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
>> 3) Exit from VMX non-root mode on VMExit do not clear
>> pending INIT signal in LAPIC.
>> 4) When CPU exits VMX operation, pending INIT signal in
>> LAPIC is processed.
>>=20
>> In order to write such a complex test, the vmx tests framework was
>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>> implemented in patches 1-7. The test itself is implemented at patch =
8.
>> This enhancement to the vmx tests framework is a bit hackish, but
>> I believe it's OK because this functionality is rarely required by
>> other VMX tests.
>>=20
>> Regards,
>> -Liran
>=20
> Hi Liran,
>=20
> I ran this test on bare-metal and it fails:
>=20
> Test suite: vmx_init_signal_test
> PASS: INIT signal blocked when CPU in VMX operation
> PASS: INIT signal during VMX non-root mode result in exit-reason =
VMX_INIT (3)
> FAIL: INIT signal processed after exit VMX operation
> SUMMARY: 8 tests, 1 unexpected failures
>=20
> I don=E2=80=99t have time to debug this issue, but let me know if you =
want some
> print-outs.
>=20
> Nadav
>=20

Thanks Nadav for running this on bare-metal. This is very useful!

It seems that when CPU exited on exit-reason VMX_INIT (3), the LAPIC =
INIT pending event
was consumed instead of still being latched until CPU exits VMX =
operation.

In my commit which this unit-test verifies 4b9852f4f389 ("KVM: x86: Fix =
INIT signal handling in various CPU states=E2=80=9D),
I have assumed that such exit-reason don=E2=80=99t consume the LAPIC =
INIT pending event.
My assumption was based on the phrasing of Intel SDM section 25.2 OTHER =
CAUSES OF VM EXITS regarding INIT signals:
"Such exits do not modify register state or clear pending events as they =
would outside of VMX operation."
I thought Intel logic behind this is that if an INIT signal is sent to a =
CPU in VMX non-root mode, it would exit
on exit-reason 3 which would allow hypervisor to decide to exit VMX =
operation in order to consume INIT signal.

Nadav, can you attempt to just add a delay in init_signal_test_thread() =
between calling vmx_off() & setting init_signal_test_thread_continued to =
true?
It may be that real hardware delays a bit when the INIT signal is =
released from LAPIC after exit VMX operation.

Thanks,
-Liran



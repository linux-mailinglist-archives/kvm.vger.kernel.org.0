Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A9F9317
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKLOvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 09:51:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbfKLOvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 09:51:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xACEkk0C121571
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 09:51:17 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w7xmrgd8p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 09:51:16 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 12 Nov 2019 14:47:24 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 12 Nov 2019 14:47:22 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xACElKAC59703300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 14:47:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF6DAA4053;
        Tue, 12 Nov 2019 14:47:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BB6A4040;
        Tue, 12 Nov 2019 14:47:20 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Nov 2019 14:47:20 +0000 (GMT)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, imbrenda@linux.ibm.com, mihajlov@linux.ibm.com,
        mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <41fb411d-68b5-96be-fc0e-c88570df9d19@de.ibm.com>
 <20191104152603.76f50c60.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABtCVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+iQI3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbauQINBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABiQIfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
Date:   Tue, 12 Nov 2019 15:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104152603.76f50c60.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oZUDBCwfom9G0Dcpf96XYJ4Jpkc2BjkKx"
X-TM-AS-GCONF: 00
x-cbid: 19111214-4275-0000-0000-0000037D1897
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111214-4276-0000-0000-0000389076C7
Message-Id: <fb5837ee-0868-85df-fe61-381484162f47@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911120132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oZUDBCwfom9G0Dcpf96XYJ4Jpkc2BjkKx
Content-Type: multipart/mixed; boundary="En3MMsjz1gQRzn0mEizSQkXYAY1vUmNKZ"

--En3MMsjz1gQRzn0mEizSQkXYAY1vUmNKZ
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/4/19 3:26 PM, Cornelia Huck wrote:
> On Fri, 1 Nov 2019 09:53:12 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>=20
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> From: Vasily Gorbik <gor@linux.ibm.com>
>>>
>>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
>>> protected virtual machines hosting support code.
>>>
>>> Add "prot_virt" command line option which controls if the kernel
>>> protected VMs support is enabled at runtime.
>>>
>>> Extend ultravisor info definitions and expose it via uv_info struct
>>> filled in during startup.
>>>
>>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>>> ---
>>>  .../admin-guide/kernel-parameters.txt         |  5 ++
>>>  arch/s390/boot/Makefile                       |  2 +-
>>>  arch/s390/boot/uv.c                           | 20 +++++++-
>>>  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++-=
-
>>>  arch/s390/kernel/Makefile                     |  1 +
>>>  arch/s390/kernel/setup.c                      |  4 --
>>>  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++=
++
>>>  arch/s390/kvm/Kconfig                         |  9 ++++
>>>  8 files changed, 126 insertions(+), 9 deletions(-)
>>>  create mode 100644 arch/s390/kernel/uv.c
>=20
> (...)
>=20
>>> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
>>> index d3db3d7ed077..652b36f0efca 100644
>>> --- a/arch/s390/kvm/Kconfig
>>> +++ b/arch/s390/kvm/Kconfig
>>> @@ -55,6 +55,15 @@ config KVM_S390_UCONTROL
>>>
>>>  	  If unsure, say N.
>>>
>>> +config KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>>> +	bool "Protected guests execution support"
>>> +	depends on KVM
>>> +	---help---
>>> +	  Support hosting protected virtual machines isolated from the
>>> +	  hypervisor.
>>> +
>>> +	  If unsure, say Y.
>>> +
>>>  # OK, it's a little counter-intuitive to do this, but it puts it nea=
tly under
>>>  # the virtualization menu.
>>>  source "drivers/vhost/Kconfig"
>>>  =20
>>
>> As we have the prot_virt kernel paramter there is a way to fence this =
during runtime
>> Not sure if we really need a build time fence. We could get rid of
>> CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST and just use CONFIG_KVM =
instead,
>> assuming that in the long run all distros will enable that anyway.=20
>=20
> I still need to read through the rest of this patch set to have an
> informed opinion on that, which will probably take some more time.
>=20
>> If other reviewers prefer to keep that extra option what about the fol=
lowing to the
>> help section:
>>
>> ----
>> Support hosting protected virtual machines in KVM. The state of these =
machines like
>> memory content or register content is protected from the host or host =
administrators.
>>
>> Enabling this option will enable extra code that talks to a new firmwa=
re instance
>=20
> "...that allows the host kernel to talk..." ?

"allows a Linux hypervisor to talk..." ?

>=20
>> called ultravisor that will take care of protecting the guest while al=
so enabling
>> KVM to run this guest.
>>
>> This feature must be enable by the kernel command line option prot_vir=
t.
>=20
> s/enable by/enabled via/
>=20
>>
>> 	  If unsure, say Y.
>=20
> Looks better. I'm continuing to read the rest of this series before I
> say more, though :)
>=20



--En3MMsjz1gQRzn0mEizSQkXYAY1vUmNKZ--

--oZUDBCwfom9G0Dcpf96XYJ4Jpkc2BjkKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3KxfgACgkQ41TmuOI4
ufjyehAAtfdPYkB8+mybPu49oVshXYq+8dlOAuHNARIspPtWIP9ZCpz2Wh9bFCh4
K2I3r0/U2gmXrvtZ3LqYRZ2GXPvkW9U1nnwDtb8W0XYhkJrXRmc/zD4qLVzyWRJ/
RCmqb389GUDClKFGnjzo3/JnP9A8EwTFkqBWkUTrSruDqoUXoVU7kHrjZxcyG9Vk
/NI7i5pn1XhwV6Q3wCYLeSFUesUI+BuXhxji/7gTCQpQWiQi14DWeq3tDRtuSrLZ
IxThyMyJUUOP1Uji3Arz972WSg4OtKgPnbeMgbT5RwfvFGYrH0z5A5lTSps6rRrH
Frqc9g/o7FgWM2ASGcyv++44pDQBm26hHkcTm4LrSy7/S3g0Bn+pD6+VugpVRXuW
ltVE9sUIJptTCHj7llnz7Uqj/pw688KOsZLRwuF1ul0UMQ8MhidyfiMKwkNEeilv
HT+G9ygMfJ3JiXdbFrS0POVl9hT5zkCdQLvGRJPbxPKchoozVmbKdcNdThBOtJjJ
Niuem8xN+yI1hPgzepCHg5tQV18DlvVXYm6mbc8hKHLBmOlIhXc6mKqOTZmzZg8R
k4rlo5+Zk4H97queOu8zeF5trJehENWf+X24IboqPdf2MsVfaqPa+1r20snXMVmo
faG00pPoZ3i0AojPx2ziZgnQi5KynEIIn9sPWQqdbOo4YNZZBr4=
=9Ltf
-----END PGP SIGNATURE-----

--oZUDBCwfom9G0Dcpf96XYJ4Jpkc2BjkKx--


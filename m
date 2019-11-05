Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D740DF053D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbfKESkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 13:40:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390520AbfKESkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 13:40:43 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA5Id3ae146262
        for <kvm@vger.kernel.org>; Tue, 5 Nov 2019 13:40:42 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3cnan4pe-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 13:39:52 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 5 Nov 2019 18:37:38 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 5 Nov 2019 18:37:35 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA5IbYAs41353458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Nov 2019 18:37:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7FAE4C046;
        Tue,  5 Nov 2019 18:37:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AD974C044;
        Tue,  5 Nov 2019 18:37:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.78])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Nov 2019 18:37:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Improve architectural
 compliance for diag308
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com
References: <20191105162828.2490-1-frankja@linux.ibm.com>
 <70BDB5DE-489D-4718-B6C2-0EABD89414D2@redhat.com>
 <0560e27d-dac8-a569-2e3f-f8188724c822@de.ibm.com>
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
Date:   Tue, 5 Nov 2019 19:37:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <0560e27d-dac8-a569-2e3f-f8188724c822@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lDvsFhYLqksJ9htjUDiZIGGfuoNmYiGhy"
X-TM-AS-GCONF: 00
x-cbid: 19110518-0008-0000-0000-0000032AFB6A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110518-0009-0000-0000-00004A4A56B4
Message-Id: <2cb61837-dc0e-2b9f-cf40-1abb430af404@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911050155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lDvsFhYLqksJ9htjUDiZIGGfuoNmYiGhy
Content-Type: multipart/mixed; boundary="hiK6TBRwoasKh5T0lZd7EpwsS64YJ1iVb"

--hiK6TBRwoasKh5T0lZd7EpwsS64YJ1iVb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/19 7:23 PM, Christian Borntraeger wrote:
>=20
>=20
> On 05.11.19 18:34, David Hildenbrand wrote:
>>
>>
>>> Am 05.11.2019 um 17:29 schrieb Janosch Frank <frankja@linux.ibm.com>:=

>>>
>>> =EF=BB=BFWhen testing diag308 subcodes 0/1 on lpar with virtual mem s=
et up, I
>>> experienced spec PGMs and addressing PGMs due to the tests not settin=
g
>>> short psw bit 12 and leaving the DAT bit on.
>>>
>>> The problem was not found under KVM/QEMU, because Qemu just ignores
>>> all cpu mask bits... I'm working on a fix for that too.
>>>
>>
>> I don=E2=80=98t have access to documentation. Is what LPAR does docume=
nted behavior or is this completely undocumented and therefore undefined =
behavior? Then we should remove these test cases completely instead.
>=20
> Yes. It was just that KVM/QEMU never looked at the mask and just used a=
 default
> one. The short PSW on address 0 clearly contains a mask and we should b=
etter set
> it.

Yeah, we're currently reviewing the QEMU patch to fix this, I'll send it
out tomorrow.

>>
>>> Janosch Frank (2):
>>>  s390x: Add CR save area
>>>  s390x: Remove DAT and add short indication psw bits on diag308 reset=

>>>
>>> lib/s390x/asm-offsets.c  |  3 ++-
>>> lib/s390x/asm/arch_def.h |  5 +++--
>>> lib/s390x/interrupt.c    |  4 ++--
>>> lib/s390x/smp.c          |  2 +-
>>> s390x/cstart64.S         | 29 ++++++++++++++++++++---------
>>> 5 files changed, 28 insertions(+), 15 deletions(-)
>>>
>>> --=20
>>> 2.20.1
>>>



--hiK6TBRwoasKh5T0lZd7EpwsS64YJ1iVb--

--lDvsFhYLqksJ9htjUDiZIGGfuoNmYiGhy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3BwW0ACgkQ41TmuOI4
ufjJ1Q/9EpHnSJULLtzLNF3Yndqa3ythbwbA+v27tqA/cz7f9ghddFdQ5I90fpG0
GcpVa3NW14lnKEmBTATYYe+Ba3iZliy33P3rlSPlGCFJInqVLwDe7Q0yB3jHGioV
wc73Th15sE/p7EFxmsUeSEmvG8MwAvLQvvu+gNrUaPBv+hnYhHR0O+ZILn1l30Pd
+n1rJa6VE5Iz6zSX8JYkP7TK94DxHlvBP5TvINEkb8coxM92Vc9LpeGPNx2+I+mK
UWXmL8QlzvX/c0j+nimq15Rk7w1eCxxEM/GXg0buFAd2eliYZYciU805Fv4gXob5
2+XbI5vJipWuW3pIU0SLmIMeuLuEBkMSozosw1WL4rz419mMB5zuhXHRh6zkliJP
2usMrPkVv5L2Bw1WIywUWbVJMosyAqmaAgH36JBG7y9feFKhdVeGm5afSeqTvWuE
MwnCmjpXiMk8cV38ktC5hGZjfFtT6K66aBo9yXiIBwVRp3PIo43cYbjt5sV8atf8
niHG7gGEOrC28FhVqTJxzaQwzxCMF2OiLq7HUbFycih5HJoYEtQRaRkp/1ephSt8
Ve6mF8+vuorIsImvRfe68SX9pt3aXDC4LbBArUtsqVdSha7VGdu1L38MTkR87wbT
KwboSCt/p6LXhSCJhBa3mQHAhT+a94Sq2OPULLj27W8DE4KmP+c=
=zEjd
-----END PGP SIGNATURE-----

--lDvsFhYLqksJ9htjUDiZIGGfuoNmYiGhy--


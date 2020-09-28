Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C0D27AA7A
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 11:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgI1JNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 05:13:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgI1JNd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 05:13:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S91wIV125580;
        Mon, 28 Sep 2020 05:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=+fnxOmYt5Sd/B6QBpFPIwJ+OwUhbRhQuiUxDdpQAJG8=;
 b=VqX7A/oK8O8BTHCmnkttJazPHP0R9O1olLHUCJikOygrAAQ17ity5TZtvYPZT5Tv9i6Y
 sVCxlXTMZcRJlAUfB7Z2kJcpjrDbXfLdT3DryobkWVvWnFXv2Aa9QC4PS97eyoG3Ck02
 CqCNuojJ28tI+hW27r7jwcoxxu5ORoRfWANoYIhgUWNhn1BAZKUVvjeMsyM2ZY6QgPAa
 40RcbvbLC494mOUWTp8vnirV1xKYs9qdqSn3yn+ngkOU5tamW50r+jZY60Rxon3TZ0F9
 6i1t+Sd9nCozfz244VTGm9PqPXC9iLtQ3QQzi6hiDlXpjmDuGwHcG99ZyzY05vUd5Y31 yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uck8rs9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 05:13:05 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08S92GXJ127159;
        Mon, 28 Sep 2020 05:13:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uck8rs8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 05:13:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S9CGiu009987;
        Mon, 28 Sep 2020 09:13:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33u5r9gbb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 09:13:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S9D0kg30409048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 09:13:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75DE14C040;
        Mon, 28 Sep 2020 09:13:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 690104C04A;
        Mon, 28 Sep 2020 09:12:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.48.120])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 09:12:59 +0000 (GMT)
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <45117fcc-d6b8-fab9-11dc-79181058ed62@redhat.com>
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
Message-ID: <b896ea83-7b98-7c86-f147-446faf2dbc44@linux.ibm.com>
Date:   Mon, 28 Sep 2020 11:12:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <45117fcc-d6b8-fab9-11dc-79181058ed62@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VfA9Q2MEC6jqxTvBZM48CGM7TI8K8VyRY"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_07:2020-09-24,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009280071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VfA9Q2MEC6jqxTvBZM48CGM7TI8K8VyRY
Content-Type: multipart/mixed; boundary="Kz97w4axyoHn1iOg02JLWtj5V7UOUmbLC"

--Kz97w4axyoHn1iOg02JLWtj5V7UOUmbLC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/23/20 2:47 PM, Paolo Bonzini wrote:
> On 22/09/20 03:48, Sean Christopherson wrote:
>> This should be genericized to not be SEV specific.  TDX has a similar
>> scarcity issue in the form of key IDs, which IIUC are analogous to SEV=
 ASIDs
>> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doub=
t it
>> would change anything, I think it'd just be a bunch of renaming.  The =
hardest
>> part would probably be figuring out a name :-).
>>
>> Another idea would be to go even more generic and implement a KVM cgro=
up
>> that accounts the number of VMs of a particular type, e.g. legacy, SEV=
,
>> SEV-ES?, and TDX.  That has potential future problems though as it fal=
ls
>> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a nee=
d to
>> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees=
 the
>> light of day.
>=20
> Or also MANY:1 (we are thinking of having multiple VMs share the same
> SEV ASID).
>=20
> It might even be the same on s390 and PPC, in which case we probably
> want to implement this in virt/kvm.  Paul, Janosch, do you think this
> would make sense for you?  The original commit message is below.
>=20
> Paolo
>=20
>> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>>> Hello,
>>>
>>> This patch series adds a new SEV controller for tracking and limiting=

>>> the usage of SEV ASIDs on the AMD SVM platform.
>>>
>>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes=

>>> but this resource is in very limited quantity on a host.
>>>
>>> This limited quantity creates issues like SEV ASID starvation and
>>> unoptimized scheduling in the cloud infrastructure.
>>>
>>> SEV controller provides SEV ASID tracking and resource control
>>> mechanisms.
>=20

On s390 we currently support a few million protected guests per LPAR so
guest IDs are not exactly scarce. However having accounting for them
might add some value nevertheless, especially when having large amount
of protected containers.

@Christian: Any thoughts on this?


--Kz97w4axyoHn1iOg02JLWtj5V7UOUmbLC--

--VfA9Q2MEC6jqxTvBZM48CGM7TI8K8VyRY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9xqRoACgkQ41TmuOI4
ufiRzw//RQLYgVIDnvQ53hh7q4lVn4eqNunUK4JM6ZVR6uv5/qUq49XGb1Qhnxf7
HCNyzi4jR30hu/gs+Bp6YPAlyjc8KLQUDSFvHYSWwrkeJuQQ/MZAQfxOR6xX0lo4
/TP3WrtxU+9gQSoa0Zr1QdZBmgMC2bkqgST7JEwVMrY9zNqQR9BfFPxcyEHoOcq9
6dBqP4icN5fNA8p7naD/do70gNR80yji0InDPmKvNP4HEczXwH/gDEYt6LECwIKq
cwL3MX6iJI0BHBrOxSHKvYvQlR7df0VyUPpdsTNXZrUUYpLyA7drX5jsJdRz5Fmq
cOIJlmawm0LxAzYP9EtvzCIsSrysuSrgzqznCRWyi8dnJB2paEqKZ/UCs2nXH28v
lWEu/B7UCEDKDZnZG/KStBiTkwvepN1Dvo2jGlee9S8zEzcniTVtIdl+lfyB4c/m
ozSco0feBmH6m2KC3c6MHkYZTJR8eiLb7aZflWlxm5Mx0lrurH2vr8lTXC5BOrpw
WTxc/OEJ3hxwdW0e7WecjvaAKMckDaJaS5bD2uJP1Lg5YZKcx7icp4Jn/DjXut98
b4EzqcAlj8D9PwZXZizo135eyasTQ9b4GpZEUX5E5Yq2m53/GNdO1BhP4iP+B87W
6oAKnmpbrgsGkuZaQlfmUMvxG0JEuq88gbRX15BvTKkivnPJG/c=
=WSBY
-----END PGP SIGNATURE-----

--VfA9Q2MEC6jqxTvBZM48CGM7TI8K8VyRY--


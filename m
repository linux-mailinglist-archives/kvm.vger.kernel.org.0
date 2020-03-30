Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669101975D5
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgC3HhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 03:37:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61588 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729533AbgC3HhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 03:37:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U7Xvds048467
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:37:09 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3021d4a38v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:37:09 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 30 Mar 2020 08:36:55 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 08:36:51 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02U7b3Ht63111336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 07:37:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21B3BA4057;
        Mon, 30 Mar 2020 07:37:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D73ADA4055;
        Mon, 30 Mar 2020 07:37:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.28])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 07:37:02 +0000 (GMT)
Subject: Re: [1/1] s390x/smp: fix detection of "running"
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20200327163355.24524-1-borntraeger@de.ibm.com>
 <107a282c-dec0-3e82-fcdb-c237e47f49c8@redhat.com>
 <6380d856-6a5c-d491-77a4-713c09482e13@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 30 Mar 2020 09:37:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6380d856-6a5c-d491-77a4-713c09482e13@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WFEGLJoiT4dcqMOzTHWtbS0Uc4Q3TOj8F"
X-TM-AS-GCONF: 00
x-cbid: 20033007-0020-0000-0000-000003BE1827
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033007-0021-0000-0000-00002216B229
Message-Id: <54643032-d90e-b667-c13a-0a5a75770c42@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WFEGLJoiT4dcqMOzTHWtbS0Uc4Q3TOj8F
Content-Type: multipart/mixed; boundary="9x94duQtl1VnnGEYu4igqVMpU0nTHAPXw"

--9x94duQtl1VnnGEYu4igqVMpU0nTHAPXw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/27/20 7:01 PM, Christian Borntraeger wrote:
>=20
>=20
> On 27.03.20 17:55, David Hildenbrand wrote:
>> On 27.03.20 17:33, Christian Borntraeger wrote:
>>> On s390x hosts with a single CPU, the smp test case hangs (loops).
>>> The check is our restart has finished is wrong.
>>> Sigp sense running status checks if the CPU is currently backed by a
>>> real CPU. This means that on single CPU hosts a sigp sense running
>>> will never claim that a target is running. We need to check for not
>>> being stopped instead.
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>  lib/s390x/smp.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>> index 2555bf4..5ed8b7b 100644
>>> --- a/lib/s390x/smp.c
>>> +++ b/lib/s390x/smp.c
>>> @@ -128,7 +128,7 @@ static int smp_cpu_restart_nolock(uint16_t addr, =
struct psw *psw)
>>>  	 * The order has been accepted, but the actual restart may not
>>>  	 * have been performed yet, so wait until the cpu is running.
>>>  	 */
>>> -	while (!smp_cpu_running(addr))
>>> +	while (smp_cpu_stopped(addr))
>>>  		mb();
>>>  	cpu->active =3D true;
>>>  	return 0;
>>>
>>
>> Yeah, same as the other issue we fixed before. There is no trusting on=

>> SIGP SENSE RUNNING STATUS.
>>
>> Can you please get rid of smp_cpu_running()? (looks like this was the
>> last user)
>=20
> I think we should keep it and rename it to smp_cpu_running_status. This=
 bug
> actually showed that we should be able to test this feature (which is u=
sed
> for spinlocks in Linux) somehow.
>=20

We need to move it to the smp test case and at least test it but not use
it for any library stuff. When I do firmware testing with the unit tests
I need to be able to exercise as much sigp orders as possible.


--9x94duQtl1VnnGEYu4igqVMpU0nTHAPXw--

--WFEGLJoiT4dcqMOzTHWtbS0Uc4Q3TOj8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6BoZ4ACgkQ41TmuOI4
ufh4lw//aHRzMOZVfKs08nI0CJeGAvlDbuIAF7Aug8J+DFU4JXH5q6dEDFpGUgRB
SXDNJ+c2nIQ9Ojda9rONLctA16aotF+eho42u4+icEy3eHvRoQfns8fjB6QE3Hig
v1/Wtl6fvSo3JkUDhF8XKBWj1E8jduAdecfr+UonuPvXOi26CKgBHpIVsv/QJX7V
XXGYtKzGMcSXucB4NquYIXhv8asq1lX+Ic5ZMo7Xi+SODBjwA3GP/JTwzof444QI
m//GIgmSLI142pyf5NdmxGspK8+WEGb7lBg+hiUegNep7lJSJU5d0DuupCII+Q7R
P6rnW5nz/PFyZxzFh6B5FijZPYsYYQkRYqnvL87tX/fAA+22MBK2ASwGEIcmQEu4
TLN4IWelJKZ125N5g5QPGiTZFxWUKG5DiiyJaXoiGy8N50lbNWQVeP1xFrxsB9cM
EBmtkrLlvY9kk+QnVPrGIGDRtj00yJ5PlUXqfjJyrC/qsy/v4K84MwrVA3VKHyFu
nSsKH+F9dnopzQdUuRjMDwjJhj5zP20STwjl5ZKyicnA+RuVAWWPRLUAtOVDmG2J
Tt3tDXo9BgHlCQ3hoEC3B2/KHUMxwgaGxWe5pLv6YYwbGyXynnfok16/ZPYpAeuF
Ug9SWiBhUQF4Q3mfg5QmWuLcqJdHKPCJQBojUSQhWmFsK2BwVRM=
=HswD
-----END PGP SIGNATURE-----

--WFEGLJoiT4dcqMOzTHWtbS0Uc4Q3TOj8F--


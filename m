Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220339762C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfHUJ2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 05:28:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726353AbfHUJ2w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 05:28:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7L9RQou073979
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 05:28:50 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uh2hat8s3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 05:28:50 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 10:28:48 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 10:28:47 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7L9SkQM38470052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 09:28:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0364952057;
        Wed, 21 Aug 2019 09:28:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B4FF35204F;
        Wed, 21 Aug 2019 09:28:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 0/3] s390x: More emulation tests
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <09b66729-1263-381f-9af5-9f68332c5415@redhat.com>
 <35c4aa37-c0c8-4f27-66e0-23145fe48182@linux.ibm.com>
 <6addbd2b-435b-9367-8a13-152b094707ac@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 21 Aug 2019 11:28:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6addbd2b-435b-9367-8a13-152b094707ac@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7qH6F8qSQCqrrxCu9OA6ppy3ZqeffagAT"
X-TM-AS-GCONF: 00
x-cbid: 19082109-0012-0000-0000-000003410C27
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082109-0013-0000-0000-0000217B32FA
Message-Id: <6c6fb63c-af8a-ecea-957b-9e5a48edf399@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7qH6F8qSQCqrrxCu9OA6ppy3ZqeffagAT
Content-Type: multipart/mixed; boundary="XPm09mOedldALs5EOtZtOnaj9t24tk4TO";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <6c6fb63c-af8a-ecea-957b-9e5a48edf399@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] s390x: More emulation tests
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <09b66729-1263-381f-9af5-9f68332c5415@redhat.com>
 <35c4aa37-c0c8-4f27-66e0-23145fe48182@linux.ibm.com>
 <6addbd2b-435b-9367-8a13-152b094707ac@redhat.com>
In-Reply-To: <6addbd2b-435b-9367-8a13-152b094707ac@redhat.com>

--XPm09mOedldALs5EOtZtOnaj9t24tk4TO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/19 10:53 AM, David Hildenbrand wrote:
> On 21.08.19 10:48, Janosch Frank wrote:
>> On 8/20/19 9:04 PM, David Hildenbrand wrote:
>>> On 20.08.19 12:55, Janosch Frank wrote:
>>>> The first patch allows for CECSIM booting via PSW restart.
>>>> The other ones add diag288 and STSI tests.
>>>>
>>>> I chose to start with these since they are low controversy. My queue=

>>>> still contains the sclp patches and a simple smp library with
>>>> tests. They will follow later.
>>>
>>> On which branch do these patches apply? I fail to am 2+3 on master (w=
ell
>>> I didn't try too hard to resolve ;) ). Do you have a branch somewhere=
?
>>>
>>
>> That is currently on top of master (24efc22), the only merge conflicts=

>> might be s390x/Makefile or unittests.conf if your branch is not clean.=

>> I'm trying to get a public github account for that and qemu.
>>
>=20
> t460s: ~/git/kvm-unit-tests master $ git fetch origin
> t460s: ~/git/kvm-unit-tests master $ git reset --hard origin/master
> HEAD is now at 03b1e45 x86: Support environments without test-devices
> t460s: ~/git/kvm-unit-tests master $ git am \[kvm-unit-tests\ PATCH\ *
> Applying: s390x: Support PSW restart boot
> Applying: s390x: Diag288 test
> error: patch failed: s390x/Makefile:11
> error: s390x/Makefile: patch does not apply
> error: patch failed: s390x/unittests.cfg:61
> error: s390x/unittests.cfg: patch does not apply
> Patch failed at 0002 s390x: Diag288 test
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".=

>=20
> Are you sure?
>=20


The internal mirror did not pick up the changes of the last few days...


--XPm09mOedldALs5EOtZtOnaj9t24tk4TO--

--7qH6F8qSQCqrrxCu9OA6ppy3ZqeffagAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1dDs0ACgkQ41TmuOI4
ufh4hQ/+NC1gfvEtdZamkcJUTvTcCnkrfIMZ70U+Pc0t3L8wWCAtr0ylORLgptoH
MiJ3qpl4XyZ+AnrdyHhuReZjCJcE2I+FR2ORestd0HUvP9FbP1lVsyuVyUWWD7GE
nWFhXXH67JH2SzUe0sc5q7/xNOpM0DcAFTzIdPsYE5Ry2XwxLt94JruSOCUa9cGD
K+qn6KGFNXy8W4w0ben3Isao1D+Y8ZJV+AsoitbWBt8puW0TBAzcdC7MvgRp6WYG
+doRlmCOZceds4++RymAdhEMmv/AH58L6OhBatpRRrHvyrrE2rD/Ez0tF6/tIC/F
DhpKhEb+pwpNewAq2DnNodrcWTTQ92d0Pvf1ylDHNmJcpsJS3VkewtBbNqtKAJn5
VHNnZgTwRn8t3Zv2r62MyiiimWNqW/2aHRXUKTMdsIRhTNdm3OOGG7nMZTlcdSaL
l9eF5NC4DKe82DV+OQLnaGTFreIiT1uRdUREJG0rmZNcK276V6/aLLjHguElenD4
/dUoEMIgtRTmP7h4LiLgYqEWI5F16oD3JIBkNLf+13TomATBbI3eKYhBrNBYwflL
MGaZVqN9ThgWeuOUy9qXN0SyMJHjxwd3CffOM0aTpg1zwq7FiDu4O79CH3dUSVla
honb3LmK/HSoOkoWs0U98D5LO6eLMbnXdn46fIEm1UVZuqhLvzg=
=JOFT
-----END PGP SIGNATURE-----

--7qH6F8qSQCqrrxCu9OA6ppy3ZqeffagAT--


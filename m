Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71719D719
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 15:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgDCNDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 09:03:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbgDCNDM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 09:03:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033C3k6t086201
        for <kvm@vger.kernel.org>; Fri, 3 Apr 2020 09:03:11 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 305s83b509-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 09:03:11 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 3 Apr 2020 14:02:56 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 Apr 2020 14:02:53 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 033D350Y57999404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Apr 2020 13:03:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 944B7AE045;
        Fri,  3 Apr 2020 13:03:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27146AE051;
        Fri,  3 Apr 2020 13:03:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.156.196])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Apr 2020 13:03:05 +0000 (GMT)
Subject: Re: [PATCH v1 5/5] KVM: s390: vsie: gmap_table_walk() simplifications
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20200402184819.34215-1-david@redhat.com>
 <20200402184819.34215-6-david@redhat.com>
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
Date:   Fri, 3 Apr 2020 15:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200402184819.34215-6-david@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VlNIpXV7boDOQ3LRBC6v8WVFkTOdQwvN5"
X-TM-AS-GCONF: 00
x-cbid: 20040313-0008-0000-0000-00000369BC29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040313-0009-0000-0000-00004A8B4BE5
Message-Id: <99c824d1-88ca-c98d-c4e9-75a97c2a8a7b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_07:2020-04-02,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VlNIpXV7boDOQ3LRBC6v8WVFkTOdQwvN5
Content-Type: multipart/mixed; boundary="USmy0Wzc73PZu5yOZsW92xu6k5FR7HGDU"

--USmy0Wzc73PZu5yOZsW92xu6k5FR7HGDU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/2/20 8:48 PM, David Hildenbrand wrote:
> Let's use asce_type where applicable. Also, simplify our sanity check f=
or
> valid table levels and convert it into a WARN_ON_ONCE(). Check if we ev=
en
> have a valid gmap shadow as the very first step.
>=20
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/mm/gmap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index fd32ab566f57..3c801dae7988 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -790,17 +790,18 @@ static inline unsigned long *gmap_table_walk(stru=
ct gmap *gmap,
>  	const int asce_type =3D gmap->asce & _ASCE_TYPE_MASK;
>  	unsigned long *table;
> =20
> -	if ((gmap->asce & _ASCE_TYPE_MASK) + 4 < (level * 4))
> -		return NULL;
>  	if (gmap_is_shadow(gmap) && gmap->removed)
>  		return NULL;
> =20
> +	if (WARN_ON_ONCE(level > (asce_type >> 2) + 1))
> +		return NULL;
> +
>  	if (WARN_ON_ONCE(asce_type !=3D _ASCE_TYPE_REGION1) &&
>  			 gaddr & (-1UL << (31 + (asce_type >> 2) * 11)))
>  		return NULL;
> =20
>  	table =3D gmap->table;

We could also initialize this variable at the top, no?

> -	switch (gmap->asce & _ASCE_TYPE_MASK) {
> +	switch (asce_type) {
>  	case _ASCE_TYPE_REGION1:
>  		table +=3D (gaddr & _REGION1_INDEX) >> _REGION1_SHIFT;
>  		if (level =3D=3D 4)
>=20



--USmy0Wzc73PZu5yOZsW92xu6k5FR7HGDU--

--VlNIpXV7boDOQ3LRBC6v8WVFkTOdQwvN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6HNAgACgkQ41TmuOI4
ufj06BAAqPVN3ay5tibFacZICN2+AtixZeGC9aBiEXKkIPbn3vJLKfuxqGEJIAqR
sa83dUYL4lYbsvOOC0UGTVDX9/ZcDIB1WIMOG6drCQO2TnOnwSs+u2RiIKnPUdTO
q1nKtOWfSf2nHGHiIDozvnI2/ggdu0+VRx911rsbU51K07CSYStbransnkYwnlk/
CLf5axqBAHm+yIIuZUXB+5GZ2DOwyNt1ALnq/2YPG1ekqsq6WEAAR2bsJ5zubipg
6EtV0sN8ABBhnbAocbs/gDgc9siZOkL63UtuEJStsj1ADUp/2h9Dmoj8+NjXDoLQ
zDwJbg6xVovcH6v3vG1E+msXr7kZpX4I4BQ6lXXWwJav1ilGfBqRMuouaXHb2jR6
kwdRP16ekDsQSer35ahYJQqSjw5UDhYbhLNCdauXtgSBLXF+h8VMzMmEU4dyb3pS
UAcZLq/wPPtQ+s2eI79XEaMkAopkKkhlhntukJptLKx2e5Av3+kS1lT2fW/64zBi
mRs1E0Os8ATZNBmykyOR2n6l3fyBqWgOfoApWXFtf/VwlbIQofE3uKcSjFizOAPo
IRbFuMEbHLKxra2XfI7u8rWbzEDsC93txiPO9+YWl96xSsAKucRv8sl+l1gp3Oe7
1ROLm6bU2r9PG2vqZsG77evtwJwVixhYxQJDj8muar8dJzOW0RA=
=Lk4v
-----END PGP SIGNATURE-----

--VlNIpXV7boDOQ3LRBC6v8WVFkTOdQwvN5--


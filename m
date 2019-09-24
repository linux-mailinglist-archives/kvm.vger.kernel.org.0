Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4ABC91E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbfIXNrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:47:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfIXNrN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Sep 2019 09:47:13 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8ODeeQf087921;
        Tue, 24 Sep 2019 09:47:03 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v7j7k5gsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 09:46:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8ODailS015223;
        Tue, 24 Sep 2019 13:46:26 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 2v5bg7c3dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 13:46:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8ODkPdk26673454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 13:46:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B66F112064;
        Tue, 24 Sep 2019 13:46:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EA0A112063;
        Tue, 24 Sep 2019 13:46:24 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Sep 2019 13:46:24 +0000 (GMT)
Message-ID: <77a2a670b900dcde3e4d88094d5d04752db27b86.camel@linux.ibm.com>
Subject: Re: [PATCH 0/3] Replace current->mm by kvm->mm on powerpc/kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Date:   Tue, 24 Sep 2019 10:46:19 -0300
In-Reply-To: <20190924020008.GA4011@oak.ozlabs.ibm.com>
References: <20190923212409.7153-1-leonardo@linux.ibm.com>
         <20190924020008.GA4011@oak.ozlabs.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2jqimbQY+p+IkhB2VQWm"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=995 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909240136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-2jqimbQY+p+IkhB2VQWm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-09-24 at 12:00 +1000, Paul Mackerras wrote:
> On Mon, Sep 23, 2019 at 06:24:06PM -0300, Leonardo Bras wrote:
> > By replacing, we would reduce the use of 'global' current on code,
> > relying more in the contents of kvm struct.
> >=20
> > On code, I found that in kvm_create_vm() there is:
> > kvm->mm =3D current->mm;
> >=20
> > And that on every kvm_*_ioctl we have tests like that:
> > if (kvm->mm !=3D current->mm)
> >         return -EIO;
> >=20
> > So this change would be safe.
> >=20
> > I split the changes in 3 patches, so it would be easier to read
> > and reject separated parts. If decided that squashing is better,
> > I see no problem doing that.
>=20
> The patch series looks fine.  It has missed the 5.4 merge window, and
> it doesn't fix any bugs, so I will queue it up for the 5.5 merge
> window, meaning that I will put it into my kvm-ppc-next branch when I
> prepare it for the 5.5 merge window, probably in about a month from
> now.
>=20
> This remark also applies to your other patch "Reduce calls to get
> current->mm by storing the value locally".
>=20
> Thanks,
> Paul.

Thanks!
Leonardo Bras

--=-2jqimbQY+p+IkhB2VQWm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl2KHisACgkQlQYWtz9S
ttQIfA/9G1Z3gXIzBuQy/Li1ffXn/K6+pga8zrZXxcXGnu3on0Qze5Z3sE4EKhhG
w+BjJ2ir+JBsExKPpyAtO8AaBHk2TjeCxUha0z0g4o5QQ2wz62FRxTXv2u3MwR/4
q8KqRuIdWd5lVAJ0YG7cR0NR/ICfoOErsX2uYRCMwFgHxkh9yjy63GrCaTZNQA+o
YXBlqP/FfdEOI5OceveW7YZoNLGUuXgXXj/vWYY/+ry6yX46ctcwTCpboeOoc0uN
lSupIJrX+jYULmH4pKlGqwWnanolzJ4oHV/zmVdqB+O0vU42EPPPymLB2Uh0USdw
RY9wbKSxdqj074uPECr/mEMJCpFcvtRaRITG25V27b0KCn7u2GQPEt8cuKAXPCoa
qlPyRMTtOFmLRrn5piFUrgXHYaIFtQCfWqUZ+prKK39Sbwugu9NMbrwABoCAVS3y
vGywSZAukwlqgEYtaJsx2TlScMz92Pryze14HHxl4hDR5jtWWosAwtNxnjLm1tyQ
QQBrD19Vh5g6XPUlf8ekSEBvLf0XKKMeQWNrJwUtWED26jnNCF1ux0xfaCbMkLif
nV1w/WJQzH3fhxIptL8c2NnBDnLF1JE4bBaSs6sKeFcU2NFjx/a/RsitLLF/PHKP
cvlBqahmGrl72efAnKyXHMrrGj2zl0AXoGcBI7uwGq2GMlQu0bw=
=zz1z
-----END PGP SIGNATURE-----

--=-2jqimbQY+p+IkhB2VQWm--


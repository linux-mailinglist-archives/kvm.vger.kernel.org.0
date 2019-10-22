Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF8E064C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 16:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfJVOW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 10:22:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbfJVOW5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 10:22:57 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9MEL0U1036619;
        Tue, 22 Oct 2019 10:22:47 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt36m0tb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 10:22:46 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9MEKGIJ025328;
        Tue, 22 Oct 2019 14:22:45 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 2vqt47esgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 14:22:45 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MEMhRm60096864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 14:22:44 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE8DBC6055;
        Tue, 22 Oct 2019 14:22:43 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0458C605A;
        Tue, 22 Oct 2019 14:22:42 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.46])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Oct 2019 14:22:42 +0000 (GMT)
Message-ID: <b5f2729e4a42a343c72fe003eaa813b1ca687425.camel@linux.ibm.com>
Subject: Re: [PATCH 2/3] powerpc/kvm/book3e: Replace current->mm by kvm->mm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Date:   Tue, 22 Oct 2019 11:22:41 -0300
In-Reply-To: <20191022004335.GA30981@oak.ozlabs.ibm.com>
References: <20190923212409.7153-1-leonardo@linux.ibm.com>
         <20190923212409.7153-3-leonardo@linux.ibm.com>
         <20191022004335.GA30981@oak.ozlabs.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uDADG7dX79Rc0jw4EvZC"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-uDADG7dX79Rc0jw4EvZC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-10-22 at 11:43 +1100, Paul Mackerras wrote:
> On Mon, Sep 23, 2019 at 06:24:08PM -0300, Leonardo Bras wrote:
> > Given that in kvm_create_vm() there is:
> > kvm->mm =3D current->mm;
> >=20
> > And that on every kvm_*_ioctl we have:
> > if (kvm->mm !=3D current->mm)
> > 	return -EIO;
> >=20
> > I see no reason to keep using current->mm instead of kvm->mm.
> >=20
> > By doing so, we would reduce the use of 'global' variables on code, rel=
ying
> > more in the contents of kvm struct.
> >=20
> > Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> > ---
> >  arch/powerpc/kvm/booke.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> > index be9a45874194..383108263af5 100644
> > --- a/arch/powerpc/kvm/booke.c
> > +++ b/arch/powerpc/kvm/booke.c
> > @@ -775,7 +775,7 @@ int kvmppc_vcpu_run(struct kvm_run *kvm_run, struct=
 kvm_vcpu *vcpu)
> >  	debug =3D current->thread.debug;
> >  	current->thread.debug =3D vcpu->arch.dbg_reg;
> > =20
> > -	vcpu->arch.pgdir =3D current->mm->pgd;
> > +	vcpu->arch.pgdir =3D kvm->mm->pgd;
> >  	kvmppc_fix_ee_before_entry();
> > =20
> >  	ret =3D __kvmppc_vcpu_run(kvm_run, vcpu);
>=20
> With this patch, I get compile errors for Book E configs:
>=20
>   CC      arch/powerpc/kvm/booke.o
> /home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c: In function =E2=80=98kv=
mppc_vcpu_run=E2=80=99:
> /home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c:778:21: error: =E2=80=98=
kvm=E2=80=99 undeclared (first use in this function)
>   vcpu->arch.pgdir =3D kvm->mm->pgd;
>                      ^
> /home/paulus/kernel/kvm/arch/powerpc/kvm/booke.c:778:21: note: each undec=
lared identifier is reported only once for each function it appears in
> make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/po=
werpc/kvm/booke.o] Error 1
> make[2]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:509: arch/po=
werpc/kvm] Error 2
> make[1]: *** [/home/paulus/kernel/kvm/Makefile:1649: arch/powerpc] Error =
2
> make: *** [/home/paulus/kernel/kvm/Makefile:179: sub-make] Error 2
>=20
> It seems that you didn't compile-test this patch.
>=20
> Paul.

Sorry Paul,=20
I remember dealing with this before, but it looks like it was lost
during git context/branch switching.=20

I will make sure that doesn't happen again.
A v2 will come soon, I will test it on travis.

Best regards,
Leonardo Bras


--=-uDADG7dX79Rc0jw4EvZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl2vELEACgkQlQYWtz9S
ttQYbQ/9GHjl5o6WkdAHXy/P1i/KaQ4dwyVQ3VNELoLQUci98/B1WYo+dC6Vtdyb
sSR89aHRh4mWRcR8/qGKWxZy1scK2MSuAQFeudnyRXbQGiiST4FktMGl6mIdywF6
DrRKD3nnPKiF2zXAfy8z+HdXEIjEHT2OW+zgpu8CpQRR3kynbYeYSUzmzlf4RD2m
5wQUNPRfO3fQMEmbVedNVlegzTJA6iBuL/jCtwnkzJjIc7zAHutqQ9CSSCHZr087
2HPtGUgZ0MHDjJY4PoYD9d4nU/IgdTJk1TUTYOy1eDd1YwsVdNDqiuM1JliHInow
m01uWdRYmctTD0yhU87JmkYsfTfX8SABIJs6pP3DuBkCikNKQoomIdiPik1x0Iu0
iZCuIw2mTD0AL2LLEeKz2saurE9eqY0AhONoL3HxjW79n7w9uCaOHKhsMiW/NS2k
k+5UuAwc1r4xgqGCnN+7Iy+qHCIYv3TSboYnZP8w6up1tJ2aS86n4odTEBAhDS53
IJ6wmNfstwvnOyeVbniGpOUOWJogEYBnx/uIcE4arKGK8mtFMVyIpCRJisyqHt0n
bSczgwmeEdhxLMlavWv2aooxioMXmawC39YFjTND998Fnpc1Sk5F3XpACpyl5AwW
k+JQjPRbPKZDHQLc+j3aLIDT8pwANJPwX5RvudkNfbtEz4pgEME=
=8F10
-----END PGP SIGNATURE-----

--=-uDADG7dX79Rc0jw4EvZC--


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8830C23A07E
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgHCHuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 03:50:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725806AbgHCHuD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 03:50:03 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0737VBBI010294;
        Mon, 3 Aug 2020 03:49:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32p0x3f9fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 03:49:49 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0737ViFN011822;
        Mon, 3 Aug 2020 03:49:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32p0x3f9eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 03:49:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0737kGkf024889;
        Mon, 3 Aug 2020 07:49:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 32n0181wx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 07:49:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0737niSe60227764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Aug 2020 07:49:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D09F11C050;
        Mon,  3 Aug 2020 07:49:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2474F11C04A;
        Mon,  3 Aug 2020 07:49:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.116])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Aug 2020 07:49:43 +0000 (GMT)
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
To:     David Gibson <david@gibson.dropbear.id.au>, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-devel@nongnu.org, pbonzini@redhat.com,
        brijesh.singh@amd.com
Cc:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8be75973-65bc-6d15-99b0-fbea9fe61c80@linux.ibm.com>
Date:   Mon, 3 Aug 2020 09:49:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200724025744.69644-11-david@gibson.dropbear.id.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2fxRwrbVrMAI1zvZ6gPpjcPJiQfMeRSf6"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_04:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030051
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2fxRwrbVrMAI1zvZ6gPpjcPJiQfMeRSf6
Content-Type: multipart/mixed; boundary="lidBJFTmxBsn4S6fZs64zOcZgpGrLd7vp"

--lidBJFTmxBsn4S6fZs64zOcZgpGrLd7vp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/24/20 4:57 AM, David Gibson wrote:
> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
>=20
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled bythe "host-trust-limitation"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
>=20
> To integrate this with the option used by other platforms, we
> implement the following compromise:
>=20
>  - When the host-trust-limitation option is set, s390 will recognize
>    it, verify that the CPU can support PV (failing if not) and set
>    virtio default options necessary for encrypted or protected guests,
>    as on other platforms.  i.e. if host-trust-limitation is set, we
>    will either create a guest capable of entering PV mode, or fail
>    outright
>=20
>  - If host-trust-limitation is not set, guest's might still be able to
>    enter PV mode, if the CPU has the right model.  This may be a
>    little surprising, but shouldn't actually be harmful.

As I already explained, they have to continue to work without any change
to the VM's configuration.

Our users already expect PV to work without HTL. This feature is already
being used and the documentation has been online for a few months. I've
already heard enough complains because users found small errors in our
documentation. I'm not looking forward to complains because suddenly we
need to specify new command line arguments depending on the QEMU version.=


@Cornelia: QEMU is not my expertise, am I missing something here?

>=20
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=3Dpv0 -machine host-trust-limitation=3Dpv0=

>=20
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/s390x/pv.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++=

>  1 file changed, 61 insertions(+)
>=20
> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
> index ab3a2482aa..4bf3b345b6 100644
> --- a/hw/s390x/pv.c
> +++ b/hw/s390x/pv.c
> @@ -14,8 +14,11 @@
>  #include <linux/kvm.h>
> =20
>  #include "cpu.h"
> +#include "qapi/error.h"
>  #include "qemu/error-report.h"
>  #include "sysemu/kvm.h"
> +#include "qom/object_interfaces.h"
> +#include "exec/host-trust-limitation.h"
>  #include "hw/s390x/ipl.h"
>  #include "hw/s390x/pv.h"
> =20
> @@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
>      /* Report that we are unable to enter protected mode */
>      env->regs[r1 + 1] =3D DIAG_308_RC_INVAL_FOR_PV;
>  }
> +
> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> +#define S390_PV_GUEST(obj)                              \
> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
> +
> +typedef struct S390PVGuestState S390PVGuestState;
> +
> +/**
> + * S390PVGuestState:
> + *
> + * The S390PVGuestState object is basically a dummy used to tell the
> + * host trust limitation system to use s390's PV mechanism.  guest.
> + *
> + * # $QEMU \
> + *         -object s390-pv-guest,id=3Dpv0 \
> + *         -machine ...,host-trust-limitation=3Dpv0
> + */
> +struct S390PVGuestState {
> +    Object parent_obj;
> +};
> +
> +static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
> +{
> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> +        error_setg(errp,
> +                   "CPU model does not support Protected Virtualizatio=
n");
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    HostTrustLimitationClass *gmpc =3D HOST_TRUST_LIMITATION_CLASS(oc)=
;
> +
> +    gmpc->kvm_init =3D s390_pv_kvm_init;
> +}
> +
> +static const TypeInfo s390_pv_guest_info =3D {
> +    .parent =3D TYPE_OBJECT,
> +    .name =3D TYPE_S390_PV_GUEST,
> +    .instance_size =3D sizeof(S390PVGuestState),
> +    .class_init =3D s390_pv_guest_class_init,
> +    .interfaces =3D (InterfaceInfo[]) {
> +        { TYPE_HOST_TRUST_LIMITATION },
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void
> +s390_pv_register_types(void)
> +{
> +    type_register_static(&s390_pv_guest_info);
> +}
> +
> +type_init(s390_pv_register_types);
>=20



--lidBJFTmxBsn4S6fZs64zOcZgpGrLd7vp--

--2fxRwrbVrMAI1zvZ6gPpjcPJiQfMeRSf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8nwZYACgkQ41TmuOI4
ufgSUQ//YOx2TY/NlyQ89YJqr1gwtN4Qojnb/yUNQNOoJu9mr4KW8SkHIINnmPto
hR8t3Ad933fx9pbHS46ANNT0zvuHWxjbWJrT0TGg2Q1XI5R38BBGoYQpLyfbZ+MV
np7T8BVqsD6ko1cUkmbLWyyhovN0ts1WQ/dQt8sXLds0sHNApNfM7SF/JbZ+tBvp
z+n7YHKmVZ6gDNVgjJbUgoU4NRVEeUXIg+7/r0SVcgkTsMffykH148t7Fq5oM5NC
vT67D1kUlvouChsCx3D0fLc02BiHZAi9tUUL3s+pEsOtiZBsidNLNEM4Sz8epjoc
fg1cloQ2v475rHpueca9EWT9/ugvSNlvb1qUXaGk1GPfsWzIKEj/+7ksrnNQ16Hn
YS1GZmkWP04dW03N/qFCvRKj+zPcmZ7aMXOTsjoOUMCRD18CMp+MgZaX7B4Kw7Xj
vepmXxZpbaLdPnLLfDgjU+8TJzvNS7N8HRk//Gq1lyZm4Kl+CombclzTPiGXzVpi
NJrXIQp2R8xGUM+L/OeAWhCWIaYpprdUpwUxKkOq/zhHurRIJUm1zxVp50erUzd+
PEfZi4Ps75WdhsXKztt7sEBOKmW4A6kd99XkH2OMgbxBjxuqnpGckvExd8ZaUrWH
JTE+zbI+ky0tTJhd2MLhGTdSDL4RPQZtBXh6620cZM2cBMVj2F8=
=OJS9
-----END PGP SIGNATURE-----

--2fxRwrbVrMAI1zvZ6gPpjcPJiQfMeRSf6--


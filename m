Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E699223A070
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 09:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgHCHlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 03:41:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725806AbgHCHlD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 03:41:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0737YUbl064886;
        Mon, 3 Aug 2020 03:40:37 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32pdqv94tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 03:40:37 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0737Z2Zw066956;
        Mon, 3 Aug 2020 03:40:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32pdqv94sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 03:40:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0737ZhZv024982;
        Mon, 3 Aug 2020 07:40:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 32n0181wve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 07:40:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0737eVNw57802894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Aug 2020 07:40:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 684C811C050;
        Mon,  3 Aug 2020 07:40:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5874811C05B;
        Mon,  3 Aug 2020 07:40:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.116])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Aug 2020 07:40:30 +0000 (GMT)
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
To:     Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <20200727175040.7beca3dd.cohuck@redhat.com>
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
Message-ID: <2967ea9e-9d6d-51bd-bf0e-4aae15c63fbb@linux.ibm.com>
Date:   Mon, 3 Aug 2020 09:40:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200727175040.7beca3dd.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ag1RgI6hSAz88L8GD7V7rABgWS6V6sov3"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_07:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030053
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ag1RgI6hSAz88L8GD7V7rABgWS6V6sov3
Content-Type: multipart/mixed; boundary="OdzRqdVvtbWlykFm3IivWSMZPlcFmhBc3"

--OdzRqdVvtbWlykFm3IivWSMZPlcFmhBc3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/20 5:50 PM, Cornelia Huck wrote:
> On Fri, 24 Jul 2020 12:57:44 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
>> At least some s390 cpu models support "Protected Virtualization" (PV),=

>> a mechanism to protect guests from eavesdropping by a compromised
>> hypervisor.
>>
>> This is similar in function to other mechanisms like AMD's SEV and
>> POWER's PEF, which are controlled bythe "host-trust-limitation"
>> machine option.  s390 is a slightly special case, because we already
>> supported PV, simply by using a CPU model with the required feature
>> (S390_FEAT_UNPACK).
>>
>> To integrate this with the option used by other platforms, we
>> implement the following compromise:
>>
>>  - When the host-trust-limitation option is set, s390 will recognize
>>    it, verify that the CPU can support PV (failing if not) and set
>>    virtio default options necessary for encrypted or protected guests,=

>>    as on other platforms.  i.e. if host-trust-limitation is set, we
>>    will either create a guest capable of entering PV mode, or fail
>>    outright
>>
>>  - If host-trust-limitation is not set, guest's might still be able to=

>>    enter PV mode, if the CPU has the right model.  This may be a
>>    little surprising, but shouldn't actually be harmful.
>=20
> This could be workable, I guess. Would like a second opinion, though.
>=20
>>
>> To start a guest supporting Protected Virtualization using the new
>> option use the command line arguments:
>>     -object s390-pv-guest,id=3Dpv0 -machine host-trust-limitation=3Dpv=
0
>>
>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>> ---
>>  hw/s390x/pv.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+
>>  1 file changed, 61 insertions(+)
>>
>> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
>> index ab3a2482aa..4bf3b345b6 100644
>> --- a/hw/s390x/pv.c
>> +++ b/hw/s390x/pv.c
>> @@ -14,8 +14,11 @@
>>  #include <linux/kvm.h>
>> =20
>>  #include "cpu.h"
>> +#include "qapi/error.h"
>>  #include "qemu/error-report.h"
>>  #include "sysemu/kvm.h"
>> +#include "qom/object_interfaces.h"
>> +#include "exec/host-trust-limitation.h"
>>  #include "hw/s390x/ipl.h"
>>  #include "hw/s390x/pv.h"
>> =20
>> @@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
>>      /* Report that we are unable to enter protected mode */
>>      env->regs[r1 + 1] =3D DIAG_308_RC_INVAL_FOR_PV;
>>  }
>> +
>> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
>> +#define S390_PV_GUEST(obj)                              \
>> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
>> +
>> +typedef struct S390PVGuestState S390PVGuestState;
>> +
>> +/**
>> + * S390PVGuestState:
>> + *
>> + * The S390PVGuestState object is basically a dummy used to tell the
>> + * host trust limitation system to use s390's PV mechanism.  guest.
>> + *
>> + * # $QEMU \
>> + *         -object s390-pv-guest,id=3Dpv0 \
>> + *         -machine ...,host-trust-limitation=3Dpv0
>> + */
>> +struct S390PVGuestState {
>> +    Object parent_obj;
>> +};
>> +
>> +static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
>> +{
>> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
>> +        error_setg(errp,
>> +                   "CPU model does not support Protected Virtualizati=
on");
>> +        return -1;
>> +    }
>> +
>> +    return 0;
>> +}
>=20
> So here's where I'm confused: If I follow the code correctly, the
> ->kvm_init callback is invoked before kvm_arch_init() is called. The
> kvm_arch_init() implementation for s390x checks whether
> KVM_CAP_S390_PROTECTED is available, which is a pre-req for
> S390_FEAT_UNPACK. Am I missing something? Can someone with access to PV=

> hardware check whether this works as intended?

Doesn't look good:

=2E/s390x-run s390x/stsi.img -object s390-pv-guest,id=3Dpv0 -machine
host-trust-limitation=3Dpv0
/usr/local/bin/qemu-system-s390x -nodefaults -nographic -machine
s390-ccw-virtio,accel=3Dkvm -chardev stdio,id=3Dcon0 -device
sclpconsole,chardev=3Dcon0 -kernel s390x/stsi.img -object
s390-pv-guest,id=3Dpv0 -machine host-trust-limitation=3Dpv0 # -initrd
/tmp/tmp.uacr85fJnw
qemu-system-s390x: CPU model does not support Protected Virtualization
qemu-system-s390x: failed to initialize kvm: Operation not permitted


Without the htl it's happy.

>=20
>> +
>> +static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
>> +{
>> +    HostTrustLimitationClass *gmpc =3D HOST_TRUST_LIMITATION_CLASS(oc=
);
>> +
>> +    gmpc->kvm_init =3D s390_pv_kvm_init;
>> +}
>> +
>> +static const TypeInfo s390_pv_guest_info =3D {
>> +    .parent =3D TYPE_OBJECT,
>> +    .name =3D TYPE_S390_PV_GUEST,
>> +    .instance_size =3D sizeof(S390PVGuestState),
>> +    .class_init =3D s390_pv_guest_class_init,
>> +    .interfaces =3D (InterfaceInfo[]) {
>> +        { TYPE_HOST_TRUST_LIMITATION },
>> +        { TYPE_USER_CREATABLE },
>> +        { }
>> +    }
>> +};
>> +
>> +static void
>> +s390_pv_register_types(void)
>> +{
>> +    type_register_static(&s390_pv_guest_info);
>> +}
>> +
>> +type_init(s390_pv_register_types);
>=20



--OdzRqdVvtbWlykFm3IivWSMZPlcFmhBc3--

--Ag1RgI6hSAz88L8GD7V7rABgWS6V6sov3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8nv20ACgkQ41TmuOI4
ufhC/xAAhkewbX0tfuW2wFvChG/kdDuVj9H8ULqfvq5p5V3hwGaOxv9GOdhoUt7A
k+DSIcHQeZuplKP2KwdxLM2TCWhQZoP1odgdZAu2DDOidQKrSvyE8H4iICKBk3co
FlrYurKdlC653rO9mX7fm0qGHPLcSFFVojIL0a1L9wmATywrYuZmmDkQNVAkbRv2
zlzm9Y+8F95b8DO6SNRcNQuYnOhzskK4jgZagwMIMq5/OjeaIRwxRoFAzhVpN11e
uYTHO+PuROWUNsbQqAxu8Pc1jLxzbMjuVvYfhrf9iVzg1DN93QjpWzmLTPftyblN
oKKyi2xquog0yqagKOFzXTm4DlbYYshRwkpE5nUdymxtnTrFjVtKqgTiFynSxrYl
cly34CDIvo0sNwzaWsfrLUG7LpeO26mYaCdfSyFubNkoeiO7SCErzisk08ufcOeO
hsbA+PeDZOVeoMg5b1dSk3WFM+nsg9tJz8fTAWy4DqG08dPMzxhKJ50rQjG2261m
H4YXNGE/yD6CzKJsdNaGhWZ8UUa1zgPNyRDd2txMEAIdQPBYAEscHgbJoeH2yUUj
+X9i/Lk14Fg2RvXAlyn09fcuRFvPzkpodeoMrhiulSVDhYbacRXVePIWXeUM3JD0
PUI9s2SgDPD3+adE4ydUs8NH71vHTBJbpBp8R5eL+umehvC4JYQ=
=tpFi
-----END PGP SIGNATURE-----

--Ag1RgI6hSAz88L8GD7V7rABgWS6V6sov3--


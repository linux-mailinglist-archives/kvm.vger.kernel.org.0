Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6BC14A137
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 10:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgA0Jwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 04:52:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727816AbgA0Jwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jan 2020 04:52:43 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00R9aZkX068070
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 04:52:41 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xrgqdhy86-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 04:52:41 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 27 Jan 2020 09:52:39 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 Jan 2020 09:52:37 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00R9pjGT48431604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 09:51:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6976E4C04E;
        Mon, 27 Jan 2020 09:52:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 121264C044;
        Mon, 27 Jan 2020 09:52:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.5.135])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jan 2020 09:52:35 +0000 (GMT)
Subject: Re: [PATCH v7] KVM: s390: Add new reset vcpu API
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20200110114540.90713-1-frankja@linux.ibm.com>
 <5a26e1af-ecdc-b815-248e-ee93a7c51ff5@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 27 Jan 2020 10:52:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5a26e1af-ecdc-b815-248e-ee93a7c51ff5@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g4OvIP98IRpDGBfv6m5cnR3O6RSIZEFCA"
X-TM-AS-GCONF: 00
x-cbid: 20012709-0008-0000-0000-0000034D066F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012709-0009-0000-0000-00004A6D7B28
Message-Id: <db6d8d0f-8a5e-8c4a-bfbb-027102a21213@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001270082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g4OvIP98IRpDGBfv6m5cnR3O6RSIZEFCA
Content-Type: multipart/mixed; boundary="02iP0sB2oxB1TW2ZyRm2TC88btekSx4Xo"

--02iP0sB2oxB1TW2ZyRm2TC88btekSx4Xo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/27/20 9:05 AM, Christian Borntraeger wrote:
>=20
>=20
> On 10.01.20 12:45, Janosch Frank wrote:
> [...]
>> +static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sync_regs *regs =3D &vcpu->run->s.regs;
>> +
>> +	/* Clear reset is a superset of the initial reset */
>> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>> +
>> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
>=20
>=20
>=20
>> +	/* Will be picked up because of save_fpu_regs() in the initial reset=
 */
>> +	memset(&current->thread.fpu.vxrs, 0, sizeof(current->thread.fpu.vxrs=
));
>=20
> So I checked with a userspace that sets f8(call-saved) to 0x123 during =
this ioctl.
> f8 is 0 afterwards. The guest f8 is also correct, just because QEMU doe=
s clear out
> its copy of the fprs and syncs that back via synv regs.
>=20
> So this must be
>=20
> 	/* we have not synced the registers from kvm_run to the thread
> 	   structure. We must clear out kvm_run*/
> 	memset(&regs->vrs, 0, sizeof(regs->vrs));

Great, thanks!
Meanwhile I had a look at the missing pieces and the guarded storage rese=
ts.

>=20
>=20
>> +	memset(&regs->acrs, 0, sizeof(regs->acrs));
>> +
>> +	regs->etoken =3D 0;
>> +	regs->etoken_extension =3D 0;
>> +
>> +	memset(&regs->gscb, 0, sizeof(regs->gscb));
> [....]
>=20



--02iP0sB2oxB1TW2ZyRm2TC88btekSx4Xo--

--g4OvIP98IRpDGBfv6m5cnR3O6RSIZEFCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4usuMACgkQ41TmuOI4
ufjCwQ/+LQARNMZP0wkIZDaccxY9c3rXw2pEet7nb2i3nWW62BOYl0kYYJrGffgC
J1GnuW8wrJj/7LZ3ULkHlvW67Tsup5EAuUgJ/AomZclaeoetDeq7i7gRBSsKVd3d
LNqwLKwQ5AU1v5vSV6igIB7PLZxniZiQojkJMbxpOW74BK/Fb+v/y3raP2MINiWC
8rZAOVwAAoeku8quNHb1tFi4anQtEcvJOxX0z8d+R9CgFQdkXxPgu5X5FV6+5gAB
HJpT1S282PQUVYcbI9zt1fW2il/8gZp1CzyV8HKWAyvyC8KBIBqsuFaQr1b7bvN2
n/OQBpiNn0IVA89gZjc5+TVSrgNe+AZDr6G3ZQEHImTPF1FX2StqJ0l4gNaQB3rm
NwsMb6y5QdKBf8f7rnuvAtZCvOQvECaELn3mN7m/QSjFUuzh2xobFKG3faK+47n1
36ojml6/JeUjbMFAE1Hyesv+9nqtJAfkEHLPDm/S336dP+p+68Yli5CiFJD814qT
k1pYkxVCV8R4DWY0XL9rqmsa7jnDBhTVAl1mU+Sv5oI9ovtry2JIJNTvC0iPHMnW
duCBqJMls8zta9DO51D00lkDxNOEy7nxLecwk1TiUN1o5y96EnO8jhYFtaRxRmzS
GNL6CubZzeSiMVhjbt//TNbnNJ3U/VTmcndh98AMZxigPduAM/o=
=UQ9y
-----END PGP SIGNATURE-----

--g4OvIP98IRpDGBfv6m5cnR3O6RSIZEFCA--


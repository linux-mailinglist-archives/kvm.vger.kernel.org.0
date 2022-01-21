Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BB495EFD
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 13:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380351AbiAUM2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 07:28:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7650 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234491AbiAUM2K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 07:28:10 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LBGU3l002905;
        Fri, 21 Jan 2022 12:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1f6+YZcnlbXQA5lxohs1+84d9CY/OX4HMtGiT0LP01U=;
 b=e7KEChgSAFgBiMCJJxDuC/A8NETcGS85m27+uPyls5P+3gTV0/egehJxOV7337VMmXya
 WbB/458baX7eAe7NQ4re8vm4kGpR4O+ptRi0XZx2kc9D5jnf68oF7UkAOo+tzwPONBlh
 Vf9jtRrO0bZOUJvwQBmFgpeRd1LxLwOJ3A9jHoWBUNtVeumS8ZkLM0Pt08Q+Fp3cm1jy
 ovcXrYVn+Zar4AsYbHOrkZV/uek/AG0TFyy82XFqlegSbm13MoK8drg3PysPexS54U+y
 nLnxkCIGS6mq0y+mvClyH032YSY8tSRJxmAWPLR22jzzg0bfK81CNEMcX8U+fS7hOdlc eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqutjsbq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 12:28:09 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LBGbgX003114;
        Fri, 21 Jan 2022 12:28:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqutjsbpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 12:28:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LCBx1N031591;
        Fri, 21 Jan 2022 12:28:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dqj37ver7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 12:28:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LCS4aI38207876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 12:28:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40C1CAE059;
        Fri, 21 Jan 2022 12:28:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF043AE05D;
        Fri, 21 Jan 2022 12:28:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.16])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 12:28:03 +0000 (GMT)
Date:   Fri, 21 Jan 2022 13:28:01 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 04/10] KVM: s390: selftests: Test TEST PROTECTION
 emulation
Message-ID: <20220121132801.12ea572f@p-imbrenda>
In-Reply-To: <06422388-8389-6954-00c7-7b582b4cf1bb@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
        <20220118095210.1651483-5-scgl@linux.ibm.com>
        <c5ce5d0b-444b-ba33-a670-3bd3893af475@linux.ibm.com>
        <06422388-8389-6954-00c7-7b582b4cf1bb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wm9f8tVj-C_33B3hqwjpUM5nHuOE1fhx
X-Proofpoint-GUID: AfvP6VQSoO0oDHQ0emhGL6vcHt_kkM99
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jan 2022 12:03:20 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

[...]

> >> +
> >> +static int set_storage_key(void *addr, uint8_t key)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 int not_mapped =3D 0;
> >> + =20
> >=20
> > Maybe add a short comment:
> > Check if address is mapped via lra and set the storage key if it is.
> >  =20
> >> +=C2=A0=C2=A0=C2=A0 asm volatile (
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "lra=C2=A0=C2=A0=C2=A0 %[addr], 0(0,%[addr])\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 jz=C2=
=A0=C2=A0=C2=A0 0f\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 llill=
=C2=A0=C2=A0=C2=A0 %[not_mapped],1\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 j=C2=
=A0=C2=A0=C2=A0 1f\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "0:=C2=A0=C2=A0=C2=A0 sske=
=C2=A0=C2=A0=C2=A0 %[key], %[addr]\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "1:"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [addr] "+&a" (addr), [no=
t_mapped] "+r" (not_mapped) =20
> >=20
> > Shouldn't this be a "=3Dr" instead of a "+r" for not_mapped? =20
>=20
> I don't think so. We only write to it on one code path and the compiler m=
ustn't conclude
> that it can remove the =3D 0 assignment because the value gets overwritte=
n anyway.
>=20
> Initially I tried to implement the function like this:
>=20
> static int set_storage_key(void *addr, uint8_t key)
> {
>         asm goto ("lra  %[addr], 0(0,%[addr])\n\t"
>                   "jnz  %l[not_mapped]\n\t"
>                   "sske %[key], %[addr]\n"
>                 : [addr] "+&a" (addr)
>                 : [key] "r" (key)
>                 : "cc", "memory"
>                 : not_mapped
>         );
>         return 0;
> not_mapped:
>         return -1;
> }
>=20
> Which I think is nicer, but the compiler just optimized that completely a=
way.
> I have no clue why it (thinks it) is allowed to do that.
>=20
> >  =20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [key] "r" (key)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : "cc"
> >> +=C2=A0=C2=A0=C2=A0 );
> >> +=C2=A0=C2=A0=C2=A0 return -not_mapped;
> >> +}
> >> +
> >> +enum permission {
> >> +=C2=A0=C2=A0=C2=A0 READ_WRITE =3D 0,
> >> +=C2=A0=C2=A0=C2=A0 READ =3D 1,
> >> +=C2=A0=C2=A0=C2=A0 NONE =3D 2,
> >> +=C2=A0=C2=A0=C2=A0 UNAVAILABLE =3D 3, =20
> >=20
> > TRANSLATION_NA ?
> > I'm not completely happy with these names but I've yet to come up with =
a better naming scheme here. =20
>=20
> Mentioning translation is a good idea. Don't think there is any harm in u=
sing
> TRANSLATION_NOT_AVAILABLE or TRANSLATION_UNAVAILABLE.

it's too long, it actually makes the code harder to read when used

maybe consider something like TRANSL_UNAVAIL as well

> >  =20
> >> +};
> >> +
> >> +static enum permission test_protection(void *addr, uint8_t key)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 uint64_t mask;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 asm volatile (
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "tprot=C2=A0=C2=A0=C2=A0 %[addr], 0(%[key])\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 ipm=C2=
=A0=C2=A0=C2=A0 %[mask]\n"
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [mask] "=3Dr" (mask)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : [addr] "Q" (*(char *)add=
r),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [key] "a" (key)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : "cc"
> >> +=C2=A0=C2=A0=C2=A0 );
> >> +
> >> +=C2=A0=C2=A0=C2=A0 return (enum permission)mask >> 28; =20
> >=20
> > You could replace the shift with the "srl" that we normally do. =20
>=20
> I prefer keeping the asm as small as possible, C is just so much easier t=
o understand.

we use srl everywhere, but I agree that explicitly using C makes it
less obscure. and in the end the compiler should generate the same
instructions anyway.

my only comment about the above code is that you are casting the
uint64_t to enum permission _and then_ shifting. _technically_ it
should still work (enums are just ints), but I think it would
look cleaner if you write

	return (enum permission)(mask >> 28);

>=20
> [...]
>=20
> > It's __really__ hard to understand this since the state is changed both=
 by the guest and host. Please add comments to this and maybe also add some=
 to the test struct explaining why you expect the results for each test.
> >  =20
>=20
> I think I'll concentrate the comments at the tests array so we have one l=
ocation
> that lays out the complete logic and then one only has to check if the gu=
est
> and host match up with that, respectively, instead of having to model the=
ir interaction
> in ones head.
>=20
> I'll incorporate your other feedback, too.
>=20
> Thanks!


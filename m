Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C96EFAE91
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKMKbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:31:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26920 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbfKMKbd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 05:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573641091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngzfD8RgnsUHYaJzCiev7qxHfXql3bU5Gv+F4NrA+Hw=;
        b=Ge4+VEmD/y3hlFsv7R0RCA0lyAxhGGLm+gC0R81WpJdUt6zkYQig9ReeGRsVbTn0UbB3IA
        EGOpCWF5npDuFEN7kH4n9TfadDPXMNQjndnzD6HDYbTFBBAABIuTINiDuaFciwkhyt2Lr4
        8AeOxfmn3WVBizIZAVRrD9gh/rlsBdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-ICP2ydTpOGO7yyJciouADw-1; Wed, 13 Nov 2019 05:31:30 -0500
X-MC-Unique: ICP2ydTpOGO7yyJciouADw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CA52107ACC8;
        Wed, 13 Nov 2019 10:31:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05FD264044;
        Wed, 13 Nov 2019 10:31:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Load reset psw on diag308
 reset
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-4-frankja@linux.ibm.com>
 <7683adc7-2cd0-1103-d231-8a1577f1e673@redhat.com>
 <a22f8407-efb1-ab0e-eaf6-77d0b853c6de@linux.ibm.com>
 <f3be87c4-135e-dd42-b9b4-aadc0d0c90ca@redhat.com>
 <1dac633a-65f3-5331-ecd7-6173acffa360@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e54ce8f8-7ed5-3eee-6715-8b5051cb49fb@redhat.com>
Date:   Wed, 13 Nov 2019 11:31:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1dac633a-65f3-5331-ecd7-6173acffa360@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7FwqGp62SifqDXvSaC1UXcZE0ONliOhAT"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7FwqGp62SifqDXvSaC1UXcZE0ONliOhAT
Content-Type: multipart/mixed; boundary="oBK8PMOFVFjb1pClwrnoecfZftzI6XA8l"

--oBK8PMOFVFjb1pClwrnoecfZftzI6XA8l
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/11/2019 11.04, Janosch Frank wrote:
> On 11/12/19 5:17 PM, Thomas Huth wrote:
>> On 12/11/2019 14.42, Janosch Frank wrote:
>>> On 11/12/19 1:09 PM, David Hildenbrand wrote:
>>>> On 11.11.19 16:33, Janosch Frank wrote:
>>>>> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
>>>>> without DAT. Also we need to set the short psw indication to be
>>>>> compliant with the architecture.
>>>>>
>>>>> Let's therefore define a reset PSW mask with 64 bit addressing and
>>>>> short PSW indication that is compliant with architecture and use it.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>  lib/s390x/asm-offsets.c  |  1 +
>>>>>  lib/s390x/asm/arch_def.h |  3 ++-
>>>>>  s390x/cstart64.S         | 24 +++++++++++++++++-------
>>>>>  3 files changed, 20 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>>>>> index 4b213f8..61d2658 100644
>>>>> --- a/lib/s390x/asm-offsets.c
>>>>> +++ b/lib/s390x/asm-offsets.c
>>>>> @@ -58,6 +58,7 @@ int main(void)
>>>>>  =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>>>>>  =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>>>>>  =09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>>>>> +=09OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>>>>>  =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>>>>>  =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>>>>>  =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
>>>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>>>> index 07d4e5e..7d25e4f 100644
>>>>> --- a/lib/s390x/asm/arch_def.h
>>>>> +++ b/lib/s390x/asm/arch_def.h
>>>>> @@ -79,7 +79,8 @@ struct lowcore {
>>>>>  =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
>>>>>  =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
>>>>>  =09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
>>>>> -=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
>>>>> +=09struct psw=09sw_int_psw;=09=09=09/* 0x0388 */
>>>>> +=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0390];=09/* 0x0390 */
>>>>>  =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
>>>>>  =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
>>>>>  =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
>> [...]
>>>> This patch breaks the smp test under TCG (no clue and no time to look
>>>> into the details :) ):
>>>
>>> I forgot to fixup the offset calculation at the top of the patch once
>>> again...
>>
>> Maybe add a
>>
>> _Static_assert(sizeof(struct lowcore) =3D=3D xyz)
>>
>> after the struct definitions, to avoid that this happens again?
>>
>>  Thomas
>>
>=20
> How about this?
> Or do we want to extend the struct to 8K and test for that?
>=20
> diff --git i/lib/s390x/asm/arch_def.h w/lib/s390x/asm/arch_def.h
> index 5f034a7..cf6e1ca 100644
> --- i/lib/s390x/asm/arch_def.h
> +++ w/lib/s390x/asm/arch_def.h
> @@ -99,6 +99,7 @@ struct lowcore {
>         uint8_t         pad_0x1400[0x1800 - 0x1400];    /* 0x1400 */
>         uint8_t         pgm_int_tdb[0x1900 - 0x1800];   /* 0x1800 */
>  } __attribute__ ((__packed__));
> +_Static_assert(sizeof(struct lowcore) =3D=3D 0x1900, "Lowcore size");

Fine for me either way (either checking for 0x1900 or extending the
struct to 8192).
Hmm, maybe we should go with 0x1900 for now, and extend the struct to
8192 bytes later if there is a reason to do it.

 Thomas


--oBK8PMOFVFjb1pClwrnoecfZftzI6XA8l--

--7FwqGp62SifqDXvSaC1UXcZE0ONliOhAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl3L23QACgkQLtnXdP5w
LbV6sBAAkVGgbboD3p2JLGS9KeQCGJeTczxVgfpFuTdMvbe0gzfj074nbxZjcdrS
i8wyPwxv1/c1Ezus8ORjiXnMW+UmawBmD3PqCUiVG6VglN8nbRXZMKAMv7etthwu
do+/XVKSc2HcU74tne8pDxbTRtKikpXX9UIC4FULioiTGgYzlfXZBj+kVgsdA7ut
jrhaRRCQQ0DN8ArufuUc4ut7wHJfrf703OmnDrnNa9tBmE3cPDp8hnwwYMoZnXEh
W95qbLXxVb06hiUONvx7DWh2zoKiuEe+Z1b7C5P9uXyc61rST2E+UQJ7mpKxK+dh
VDObWD2Vz8iVy6/7hezLJf4pm2VsqPjOucY7KKIj3UF/7AJY7jH79DBMSPZn3GeV
gu/B8GT15MrkDWI3LGsrgiw03en1uFcan37oZF5aHPjn2U5We6SVy0wsj856vI96
hfm55I3QPlMiT6wPjLfGSYzMwBnzH3AyrIHQSO3gtJfJbNF4k7rmzCNxne3Kc2Lh
Lkrm7yINog6yshIngYEHm5bQ7M7X4oGrxohw/057I7RHB1DhucAhqn4ROxpWp88C
9uCZRImS+5xEqt6FHjgbAgeVbQpTmKsT/468wHm+MaYHZuyLL9/3scjMCfojOF3A
ENVZATJObbu5vuVCu3h3DC916yyZVy5+6/99uWG/0I5fBRdtzV8=
=gIbZ
-----END PGP SIGNATURE-----

--7FwqGp62SifqDXvSaC1UXcZE0ONliOhAT--


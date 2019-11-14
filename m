Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA6DFCB81
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKNRJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 12:09:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbfKNRJx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 12:09:53 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEGnMGV142340
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 12:09:52 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w99hbvhqg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 12:09:52 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 17:09:50 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 17:09:48 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEH9A8m23986622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 17:09:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5488FA4054;
        Thu, 14 Nov 2019 17:09:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14241A4060;
        Thu, 14 Nov 2019 17:09:47 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 17:09:47 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <db451544-fcb1-9d81-7042-ef91c8324204@linux.ibm.com>
 <81ef68d4-5ec5-b14e-6c3d-6935e9a6a1c1@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 18:09:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <81ef68d4-5ec5-b14e-6c3d-6935e9a6a1c1@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bDgQcatBFO5NPM7l0ZjVZFK5shJZdHzBr"
X-TM-AS-GCONF: 00
x-cbid: 19111417-4275-0000-0000-0000037DC1F2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111417-4276-0000-0000-00003891291B
Message-Id: <b5ce5e92-9412-d491-8d7c-270a92f3bff0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bDgQcatBFO5NPM7l0ZjVZFK5shJZdHzBr
Content-Type: multipart/mixed; boundary="W4KtuUDDr0deCMounFwMWplOYmhRUaFkQ"

--W4KtuUDDr0deCMounFwMWplOYmhRUaFkQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 5:38 PM, Pierre Morel wrote:
>=20
> On 2019-11-14 10:15, Janosch Frank wrote:
>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>> This simple test test the I/O reading by the SUB Channel by:
>>> - initializing the Channel SubSystem with predefined CSSID:
>>>    0xfe000000 CSSID for a Virtual CCW
>>>    0x00090000 SSID for CCW-PONG
>>> - initializing the ORB pointing to a single READ CCW
>>> - starts the STSH command with the ORB
>>> - Expect an interrupt
>>> - writes the read data to output
>>>
>>> The test implements lots of traces when DEBUG is on and
>>> tests if memory above the stack is corrupted.
>> What happens if we do not habe the pong device?
>=20
> CC error on stsch() which is currently not cached (but will in the next=
=20
> version)
>=20
> CC error on msch() and on ssch() which is cached and makes the test to =
fail.
>=20
>=20
>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   lib/s390x/css.h      | 244 ++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>>>   lib/s390x/css_dump.c | 141 +++++++++++++++++++++++++++++
>> Hmm, what about splitting the patch into css.h/css_dump.c and the actu=
al
>> test in s390x/css.c?
>=20
> OK
>=20
>=20
>>
>>>   s390x/Makefile       |   2 +
>>>   s390x/css.c          | 222 ++++++++++++++++++++++++++++++++++++++++=
++++++
>>>   s390x/unittests.cfg  |   4 +
>>>   5 files changed, 613 insertions(+)
>>>   create mode 100644 lib/s390x/css.h
>>>   create mode 100644 lib/s390x/css_dump.c
>>>   create mode 100644 s390x/css.c
>>>
>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>> new file mode 100644
>=20
> OK to all comments...=C2=A0 (I sniped out for clarity)
>=20
> ...snip...
>=20
>=20
>>> +static char buffer[4096];
>>> +
>>> +static void delay(int d)
>>> +{
>>> +	int i, j;
>>> +
>>> +	while (d--)
>>> +		for (i =3D 1000000; i; i--)
>>> +			for (j =3D 1000000; j; j--)
>>> +				;
>>> +}
>> You could set a timer.
>=20
>=20
> Hum, do we really want to do this?

Why exactly do you need it if you can't have an exact time to wait for?

>=20
>=20
>>
>>> +
>>> +static void set_io_irq_subclass_mask(uint64_t const new_mask)
>>> +{
>>> +	asm volatile (
>>> +		"lctlg %%c6, %%c6, %[source]\n"
>>> +		: /* No outputs */
>>> +		: [source] "R" (new_mask));
>> arch_def.h has lctlg() and ctl_set/clear_bit
>=20
>=20
> OK, thanks
>=20
>=20
>>
>>> +}
>>> +
>>> +static void set_system_mask(uint8_t new_mask)
>>> +{
>>> +	asm volatile (
>>> +		"ssm %[source]\n"
>>> +		: /* No outputs */
>>> +		: [source] "R" (new_mask));
>>> +}
>>> +
>>> +static void enable_io_irq(void)
>>> +{
>>> +	set_io_irq_subclass_mask(0x00000000ff000000);
>>> +	set_system_mask(PSW_PRG_MASK >> 56);
>> load_psw_mask(extract_psw_mask() | PSW_PRG_MASK); no need for another
>> inline asm function :)
>>
>> Or add a psw_set/clear_bit function and fixup enter_pstate()
>=20
> I look at this.
>=20
>=20
>>
>>> +}
>>> +
>>> +void handle_io_int(sregs_t *regs)
>>> +{
> ,,,snip...
>>> +
>>> +	delay(1);
>>> +
>>> +	stsch(CSSID_PONG, &schib);
>>> +	dump_schib(&schib);
>> Is all that dumping necessary or just a dev remainder?
>=20
>=20
> it goes in the logs, so I thought it could be interresting to keep it.

Depends on how much output is produced.
If I have to scroll through your dumps to get to the ouptuts
 of the reports then they are .

See the answer below...

>=20
>=20
>>
>>> +	DBG("got: %s\n", buffer);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +#define MAX_ERRORS 10
>>> +static int checkmem(phys_addr_t start, phys_addr_t end)
>>> +{
>>> +	phys_addr_t curr;
>>> +	int err =3D 0;
>>> +
>>> +	for (curr =3D start; curr !=3D end; curr +=3D PAGE_SIZE)
>>> +		if (memcmp((void *)start, (void *)curr, PAGE_SIZE)) {
>>> +			report("memcmp failed %lx", true, curr);
>> How many errors do you normally run into (hopefully 0)?
>=20
>=20
> hopefully.
>=20
> However I thought it could be interesting to know how many pages have=20
> been dirtied.

Honestly, for debugging a failing test we would need to add prints or
attach gdb anyway. So I see no reason to not fail on the first occurrence=
=2E

>=20
>=20
>>
>>> +			if (err++ > MAX_ERRORS)
>>> +				break;
>>> +		}
>>> +	return err;
>>> +}
>>> +
>>> +extern unsigned long bss_end;
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +	phys_addr_t base, top;
>>> +	int check_mem =3D 0;
>>> +	int err =3D 0;
>>> +
>>> +	if (argc =3D=3D 2 && !strcmp(argv[1], "-i"))
>>> +		check_mem =3D 1;
>>> +
>>> +	report_prefix_push("css");
>>> +	phys_alloc_get_unused(&base, &top);
>>> +
>>> +	top =3D 0x08000000; /* 128MB Need to be updated */
>>> +	base =3D (phys_addr_t)&stacktop;
>>> +
>>> +	if (check_mem)
>>> +		memset((void *)base, 0x00, top - base);
>>> +
>>> +	if (check_mem)
>>> +		err =3D checkmem(base, top);
>>> +	if (err)
>>> +		goto out;
>>> +
>>> +	err =3D css_run(0);
>>> +	if (err)
>>> +		goto out;
>>> +
>>> +	if (check_mem)
>>> +		err =3D checkmem(base, top);
>>> +
>>> +out:
>>> +	if (err)
>>> +		report("Tested", 0);
>>> +	else
>>> +		report("Tested", 1);
>> Normally we report the sucsess or failure of single actions and a
>> summary will tell us if the whole test ran into errors.
>=20
> Right, will be enhanced.
>=20
> Thanks for the comments.
>=20
> Regards,
>=20
> Pierre
>=20
>=20



--W4KtuUDDr0deCMounFwMWplOYmhRUaFkQ--

--bDgQcatBFO5NPM7l0ZjVZFK5shJZdHzBr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NiloACgkQ41TmuOI4
ufg77hAAwPLc3BTzlUisc2uhHCc5S/c892QuRG6ZIlPAQ4zXkO3IYbhu9GcfYnmY
S2dM0dWAguHYm9eskBhYXURIi9Yb0fBqUQZQ0y24OO1wXUL9b3AwE7GxiN26SAY9
Io6fDaPLOLYZY+8cyhxysnzhMWihK9f+v3HYXCxcgQhSrCq3NgssBo6pMnbF9+02
xuBLg2YTfB7ls/IdG/TUqD1hwR5m1/D2dY3wS6ls8016pOOXxfIDcI2ucKfV6QZj
rb763I8QdD2yIF3RG6KTlJLIaVT6GIxzO5jI+HfLtz8vhRZ2UrOu3wDalgLlWrNf
V1TxcBT0crztm6rTdmYaYxNs7TAlgiaovUsBPd4vX3t7jXXjbd8ePTaz5ioE9CpA
O1ntjgSUhpeL7xI4sN/j1FE1ZxK1sWnGo6NaTbWHifmwa3StWdbuNL5/91TcwK7N
7f73iK1EAL4E31JWRkajiGpztyS2rdyNmzgM9FJiDHxETlfF4INUGgnALTU+3VYg
Ijkjrzf8/GlN41MOCGBtKq/J/r46pHJib32BVBnv9Tj8zwIEFtnDw0emICmZDvHg
hR2zd3pPBuxUzAMLcG65HqPQzpsUZwIAnUc0lDfTpNJ1MfVKaQOnw8Q7O7CFRAAh
q0LmabGJl9uAAullCMkp0E6F0Se338fIQobmj7QJxNSo25/WGSc=
=tC+M
-----END PGP SIGNATURE-----

--bDgQcatBFO5NPM7l0ZjVZFK5shJZdHzBr--


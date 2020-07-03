Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F041D2139AF
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgGCMCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 08:02:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725984AbgGCMCA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 08:02:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063C1fJl089311;
        Fri, 3 Jul 2020 08:01:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0t9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 08:01:57 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063C1uSx091124;
        Fri, 3 Jul 2020 08:01:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0t8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 08:01:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BuRSL010537;
        Fri, 3 Jul 2020 12:01:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 31wwch6s9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 12:01:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063C1puK63635624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 12:01:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 575AC11C04A;
        Fri,  3 Jul 2020 12:01:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E57A411C04C;
        Fri,  3 Jul 2020 12:01:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.180.107])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 12:01:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
 <d8b2ed8c-3948-1cba-47af-ef2a8cdf27ed@redhat.com>
 <0aaab65b-7856-9be9-c6dc-4da8e8d529d4@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <75982e29-5df8-abf3-57aa-ff717a4868d6@linux.ibm.com>
Date:   Fri, 3 Jul 2020 14:01:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0aaab65b-7856-9be9-c6dc-4da8e8d529d4@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QKIBioCp2dHTAz4FbE9l1ty1waX2iSH7o"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 cotscore=-2147483648 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QKIBioCp2dHTAz4FbE9l1ty1waX2iSH7o
Content-Type: multipart/mixed; boundary="wz2sV3eMKvbNw10rKNgrHGkidQr08jZuL"

--wz2sV3eMKvbNw10rKNgrHGkidQr08jZuL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/3/20 11:05 AM, Pierre Morel wrote:
>=20
>=20
> On 2020-07-03 10:41, Thomas Huth wrote:
>> On 02/07/2020 18.31, Pierre Morel wrote:
>>> After a channel is enabled we start a SENSE_ID command using
>>> the SSCH instruction to recognize the control unit and device.
>>>
>>> This tests the success of SSCH, the I/O interruption and the TSCH
>>> instructions.
>>>
>>> The SENSE_ID command response is tested to report 0xff inside
>>> its reserved field and to report the same control unit type
>>> as the cu_type kernel argument.
>>>
>>> Without the cu_type kernel argument, the test expects a device
>>> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>> [...]
>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>> index 0ddceb1..9c22644 100644
>>> --- a/lib/s390x/css.h
>>> +++ b/lib/s390x/css.h
>>> @@ -11,6 +11,8 @@
>>>   #ifndef CSS_H
>>>   #define CSS_H
>>>  =20
>>> +#define lowcore_ptr ((struct lowcore *)0x0)
>>
>> I'd prefer if you could either put this into the css_lib.c file or in
>> lib/s390x/asm/arch_def.h.
>=20
> I have a patch ready for this :)
> But I did not want to add too much new things in this series that could=
=20
> start a new discussion.
>=20
> I have 2 versions of the patch:
> - The simple one with just the declaration in arch_def.h
> - The complete one with update of all tests (but smp) using a pointer t=
o=20
> lowcore.
>=20

I've seen that patch on your branch and like most maintainers I'm not
incredibly happy with patches touching a single line in a lot of files.

Maybe we can achieve a compromise and only clean up our library. The
tests can be changed when they need to be touched for other changes.

Anyway for now I think css_lib.c might be the right place. We can talk
about a lowcore cleanup next week if you want.

>=20
>>
> ...snip...
>=20
>>>   static inline int ssch(unsigned long schid, struct orb *addr)
>>> @@ -251,6 +271,16 @@ void dump_orb(struct orb *op);
>>>  =20
>>>   int css_enumerate(void);
>>>   #define MAX_ENABLE_RETRIES      5
>>> -int css_enable(int schid);
>>> +int css_enable(int schid, int isc);
>>> +
>>> +
>>
>> In case you respin: Remove one empty line?
>=20
> yes
>=20
>>
>>> +/* Library functions */
>>> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
>=20
> ...snip...
>=20
>>> +	lowcore_ptr->io_int_param =3D 0;
>>> +
>>> +	memset(&senseid, 0, sizeof(senseid));
>>> +	ret =3D start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
>>> +			       &senseid, sizeof(senseid), CCW_F_SLI);
>>> +	if (ret) {
>>> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
>>> +		       test_device_sid, ret);
>>> +		goto unreg_cb;
>>> +	}
>>
>> I'd maybe rather do something like:
>>
>> 	report(ret =3D=3D 0, "SENSE ID on sch %08x has good CC (%d)", ...)
>> 	if (ret)
>> 		goto unreg_cb;
>>
>> and avoid report(0, ...) statements. Also for the other tests below. B=
ut
>> maybe that's really just a matter of taste.
>=20
> I prefer to use report(0,....) when an unexpected error occurs: This=20
> keep the test silent when what is expected occurs.
>=20
> And use report(ret =3D=3D xxx, ....) as the last report to report overa=
ll=20
> success or failure of the test.
>=20
> Other opinions?

So, I'm not a big fan of changes to the amount of output depending on
the test PASS/FAIL. It screws with my ability to parse the output.

However this is your test, I don't expect other people touching this in
the near future and the output has lots of information where stuff went
wrong. As long as you debug the fails I'm ok with that style :)

>=20
>>
>>> +	wait_for_interrupt(PSW_MASK_IO);
>=20
> ...snip...
>=20
>>
>> Apart from the nits, I'm fine with the patch.
>>
>> Acked-by: Thomas Huth <thuth@redhat.com>

Acked-by: Janosch Frank <frankja@de.ibm.com>

>>
>=20
> Thanks,
> Pierre
>=20
>=20



--wz2sV3eMKvbNw10rKNgrHGkidQr08jZuL--

--QKIBioCp2dHTAz4FbE9l1ty1waX2iSH7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7/Hi4ACgkQ41TmuOI4
ufj3og//WoHnbb8K2e7rrgrbtTVFFJAT544OylKaH7dN9N8R5BZjd6vTVDkVozQE
wwxaUiPAJ8tkUI0uO5amGQSLrUVxLb+PuXmTn01onZJXwY1MH0vb3z8hKeYV1wGt
AOl1KJEq7bpEk7NkB8AGl4ftAO4MAvlV7BgHSqDK2xx4HsDXFO0088zXVzodzUUy
nw5HWsfp3BIZUIRq4wU7p4Y5E0c8gI2PE0wE3NBPaXNwZPo4Zy8nUjZu3382Vear
GiUt9HXfSmA+Ib9IzkaEjZxbTJbWBmSR3VSJAGkNcyjCNf5SKC5rVOMw8NxTbd0+
uptLrCYgM6MdA0XrAKBQNeoxi8wsLZaS1UjM1AXN2bd2xhKs16PYMj6ZNUA1+nCD
/i4+nE/44IJmug0JOlNZQquiKaANxOmxmvON7RBjC8FbHSZ9hlap5cD41t4cW+uc
F2hlmafXHFDQhPkXn4IfB3nyT9YCIJhjzzKM0TSjPLTbVCy+y9cE8tpWlu4VdWlL
Ww83ukGG5FyY4nteET914qq5NtcoOVHZQ8XO75MvpkSJt7qtALT5yXgPfapPKvz0
5PwPpnDb7Dd+ZXk1xOAZuiVFfviJT6eybfRvZSklRazVvyBVQ9ikYIbI1bErLkcs
KorSjNo87M9xPWVDo3SwHe8gaemhs9Fg8/Eodou1RXrR8GTgfo8=
=Nugx
-----END PGP SIGNATURE-----

--QKIBioCp2dHTAz4FbE9l1ty1waX2iSH7o--


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5336BAE90D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfIJLZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 07:25:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbfIJLZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Sep 2019 07:25:39 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8ABMPUG071387
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:25:37 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ux91x48ds-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:25:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 10 Sep 2019 12:25:35 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Sep 2019 12:25:32 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8ABPV5B43581524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 11:25:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C283511C04A;
        Tue, 10 Sep 2019 11:25:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8650711C058;
        Tue, 10 Sep 2019 11:25:31 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Sep 2019 11:25:31 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/6] s390x: Use interrupts in SCLP and
 add locking
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190905103951.36522-1-frankja@linux.ibm.com>
 <20190905103951.36522-2-frankja@linux.ibm.com>
 <bc431c45-3cb5-8f8e-e8ec-2f0011f454b2@redhat.com>
 <261b1c62-21cf-05bc-2cec-75a53c9211a7@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 10 Sep 2019 13:25:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <261b1c62-21cf-05bc-2cec-75a53c9211a7@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ee5yiPEFqaf1SXFrF2iMQlCcG2LzxBvBO"
X-TM-AS-GCONF: 00
x-cbid: 19091011-0020-0000-0000-0000036A785F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091011-0021-0000-0000-000021BFFEC2
Message-Id: <34976021-7257-c363-208d-681f7a239d9e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909100115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ee5yiPEFqaf1SXFrF2iMQlCcG2LzxBvBO
Content-Type: multipart/mixed; boundary="bOYQDOEdOk7u1L74b87V9isie9U32B5wp";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <34976021-7257-c363-208d-681f7a239d9e@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] s390x: Use interrupts in SCLP and
 add locking
References: <20190905103951.36522-1-frankja@linux.ibm.com>
 <20190905103951.36522-2-frankja@linux.ibm.com>
 <bc431c45-3cb5-8f8e-e8ec-2f0011f454b2@redhat.com>
 <261b1c62-21cf-05bc-2cec-75a53c9211a7@redhat.com>
In-Reply-To: <261b1c62-21cf-05bc-2cec-75a53c9211a7@redhat.com>

--bOYQDOEdOk7u1L74b87V9isie9U32B5wp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/10/19 1:24 PM, David Hildenbrand wrote:
> On 10.09.19 12:14, David Hildenbrand wrote:
>> On 05.09.19 12:39, Janosch Frank wrote:
>>> We need to properly implement interrupt handling for SCLP, because on=

>>> z/VM and LPAR SCLP calls are not synchronous!
>>>
>>> Also with smp CPUs have to compete for sclp. Let's add some locking,
>>> so they execute sclp calls in an orderly fashion and don't compete fo=
r
>>> the data buffer.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm/interrupt.h |  2 ++
>>>  lib/s390x/interrupt.c     | 12 +++++++--
>>>  lib/s390x/sclp-console.c  |  2 ++
>>>  lib/s390x/sclp.c          | 55 +++++++++++++++++++++++++++++++++++++=
--
>>>  lib/s390x/sclp.h          |  3 +++
>>>  5 files changed, 70 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>>> index 013709f..f485e96 100644
>>> --- a/lib/s390x/asm/interrupt.h
>>> +++ b/lib/s390x/asm/interrupt.h
>>> @@ -11,6 +11,8 @@
>>>  #define _ASMS390X_IRQ_H_
>>>  #include <asm/arch_def.h>
>>> =20
>>> +#define EXT_IRQ_SERVICE_SIG	0x2401
>>> +
>>>  void handle_pgm_int(void);
>>>  void handle_ext_int(void);
>>>  void handle_mcck_int(void);
>>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>>> index cf0a794..7832711 100644
>>> --- a/lib/s390x/interrupt.c
>>> +++ b/lib/s390x/interrupt.c
>>> @@ -12,6 +12,7 @@
>>>  #include <libcflat.h>
>>>  #include <asm/interrupt.h>
>>>  #include <asm/barrier.h>
>>> +#include <sclp.h>
>>> =20
>>>  static bool pgm_int_expected;
>>>  static struct lowcore *lc;
>>> @@ -107,8 +108,15 @@ void handle_pgm_int(void)
>>> =20
>>>  void handle_ext_int(void)
>>>  {
>>> -	report_abort("Unexpected external call interrupt: at %#lx",
>>> -		     lc->ext_old_psw.addr);
>>> +	if (lc->ext_int_code !=3D EXT_IRQ_SERVICE_SIG) {
>>> +		report_abort("Unexpected external call interrupt: at %#lx",
>>> +			     lc->ext_old_psw.addr);
>>> +	} else {
>>> +		lc->ext_old_psw.mask &=3D ~PSW_MASK_EXT;
>>> +		lc->sw_int_cr0 &=3D ~(1UL << 9);
>>> +		sclp_handle_ext();
>>> +		lc->ext_int_code =3D 0;
>>> +	}
>>>  }
>>> =20
>>>  void handle_mcck_int(void)
>>> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
>>> index bc01f41..a5ef45f 100644
>>> --- a/lib/s390x/sclp-console.c
>>> +++ b/lib/s390x/sclp-console.c
>>> @@ -17,6 +17,7 @@ static void sclp_set_write_mask(void)
>>>  {
>>>  	WriteEventMask *sccb =3D (void *)_sccb;
>>> =20
>>> +	sclp_mark_busy();
>>>  	sccb->h.length =3D sizeof(WriteEventMask);
>>>  	sccb->mask_length =3D sizeof(unsigned int);
>>>  	sccb->receive_mask =3D SCLP_EVENT_MASK_MSG_ASCII;
>>> @@ -37,6 +38,7 @@ void sclp_print(const char *str)
>>>  	int len =3D strlen(str);
>>>  	WriteEventData *sccb =3D (void *)_sccb;
>>> =20
>>> +	sclp_mark_busy();
>>>  	sccb->h.length =3D sizeof(WriteEventData) + len;
>>>  	sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
>>>  	sccb->ebh.length =3D sizeof(EventBufferHeader) + len;
>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>> index b60f7a4..56fca0c 100644
>>> --- a/lib/s390x/sclp.c
>>> +++ b/lib/s390x/sclp.c
>>> @@ -14,6 +14,8 @@
>>>  #include <asm/page.h>
>>>  #include <asm/arch_def.h>
>>>  #include <asm/interrupt.h>
>>> +#include <asm/barrier.h>
>>> +#include <asm/spinlock.h>
>>>  #include "sclp.h"
>>>  #include <alloc_phys.h>
>>>  #include <alloc_page.h>
>>> @@ -25,6 +27,8 @@ static uint64_t max_ram_size;
>>>  static uint64_t ram_size;
>>> =20
>>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>> +static volatile bool sclp_busy;
>>> +static struct spinlock sclp_lock;
>>> =20
>>>  static void mem_init(phys_addr_t mem_end)
>>>  {
>>> @@ -41,17 +45,62 @@ static void mem_init(phys_addr_t mem_end)
>>>  	page_alloc_ops_enable();
>>>  }
>>> =20
>>> +static void sclp_setup_int(void)
>>> +{
>>> +	uint64_t mask;
>>> +
>>> +	ctl_set_bit(0, 9);
>>> +
>>> +	mask =3D extract_psw_mask();
>>> +	mask |=3D PSW_MASK_EXT;
>>> +	load_psw_mask(mask);
>>> +}
>>> +
>>> +void sclp_handle_ext(void)
>>> +{
>>> +	ctl_clear_bit(0, 9);
>>> +	spin_lock(&sclp_lock);
>>> +	sclp_busy =3D false;
>>> +	spin_unlock(&sclp_lock);
>>> +}
>>> +
>>> +void sclp_wait_busy(void)
>>> +{
>>> +	while (sclp_busy)
>>> +		mb();
>>> +}
>>> +
>>> +void sclp_mark_busy(void)
>>> +{
>>> +	/*
>>> +	 * With multiple CPUs we might need to wait for another CPU's
>>> +	 * request before grabbing the busy indication.
>>> +	 */
>>> +	while (true) {
>>> +		sclp_wait_busy();
>>> +		spin_lock(&sclp_lock);
>>> +		if (!sclp_busy) {
>>> +			sclp_busy =3D true;
>>> +			spin_unlock(&sclp_lock);
>>> +			return;
>>> +		}
>>> +		spin_unlock(&sclp_lock);
>>> +	}
>>> +}
>>> +
>>>  static void sclp_read_scp_info(ReadInfo *ri, int length)
>>>  {
>>>  	unsigned int commands[] =3D { SCLP_CMDW_READ_SCP_INFO_FORCED,
>>>  				    SCLP_CMDW_READ_SCP_INFO };
>>> -	int i;
>>> +	int i, cc;
>>> =20
>>>  	for (i =3D 0; i < ARRAY_SIZE(commands); i++) {
>>> +		sclp_mark_busy();
>>>  		memset(&ri->h, 0, sizeof(ri->h));
>>>  		ri->h.length =3D length;
>>> =20
>>> -		if (sclp_service_call(commands[i], ri))
>>> +		cc =3D sclp_service_call(commands[i], ri);
>>> +		if (cc)
>>>  			break;
>>>  		if (ri->h.response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
>>>  			return;
>>> @@ -66,12 +115,14 @@ int sclp_service_call(unsigned int command, void=
 *sccb)
>>>  {
>>>  	int cc;
>>> =20
>>> +	sclp_setup_int();
>>>  	asm volatile(
>>>  		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
>>>  		"       ipm     %0\n"
>>>  		"       srl     %0,28"
>>>  		: "=3D&d" (cc) : "d" (command), "a" (__pa(sccb))
>>>  		: "cc", "memory");
>>> +	sclp_wait_busy();
>>>  	if (cc =3D=3D 3)
>>>  		return -1;
>>>  	if (cc =3D=3D 2)
>>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>>> index 583c4e5..63cf609 100644
>>> --- a/lib/s390x/sclp.h
>>> +++ b/lib/s390x/sclp.h
>>> @@ -213,6 +213,9 @@ typedef struct ReadEventData {
>>>  } __attribute__((packed)) ReadEventData;
>>> =20
>>>  extern char _sccb[];
>>> +void sclp_handle_ext(void);
>>> +void sclp_wait_busy(void);
>>> +void sclp_mark_busy(void);
>>>  void sclp_console_setup(void);
>>>  void sclp_print(const char *str);
>>>  int sclp_service_call(unsigned int command, void *sccb);
>>>
>>
>> I was wondering whether it would make sense to enable sclp interrupts =
as
>> default for all CPUs (once in a reasonable state after brought up), an=
d
>> simply let any CPU process the request. Initially, we could only let t=
he
>> boot CPU handle them.
>>
>> You already decoupled sclp_mark_busy() and sclp_setup_int() already. T=
he
>> part would have to be moved to the CPU init stage and sclp_handle_ext(=
)
>> would simply not clear the interrupt-enable flag.
>>
>> Opinions?
>>
>=20
> OTOH, the s390x-ccw bios enables interrupts on the single cpu after
> sending the request, and disables them again in the interrupt handler. =
I
> guess we should never get more than one interrupt per SCLP request?
>=20

Didn't old qemu versions do exactly that an we currently catch that in
the kernel?


--bOYQDOEdOk7u1L74b87V9isie9U32B5wp--

--ee5yiPEFqaf1SXFrF2iMQlCcG2LzxBvBO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl13iCsACgkQ41TmuOI4
ufjK/hAAl51/FA8pa7QVAiW2vs23z4k302S1Bm8/OZUHDAORtY4VmM5TxWfdxZCF
m5GQIqXoIcsN1sFMyGmft8uBjnRSna8VcoGclQGjxcW5K01fBacZfm5lTezJBW4q
rCwTzo2p9+ya6y8Qn1DaG+YFA89ZAdlQhsrITANS1ypYSNX53bafZoGyzv0iG88R
wzLrNuR53woY6tDFd4yH8goO0unBWiyTfU/6bE90YviAlDhXtN35eBK8FgW0JZM2
BN4Isps2cE7QhctqYRKkKXAJEUWGlccW0mi9MyCHTCKjCG+aV3O2rKtPAMausQPs
hvpLAmmI+C9appRTMySLYe8PuAkDr7M2g372yO7DrNMxgvJwDcBE1ZU77u0b36mE
VBgf+f8TY56jRTjcq8N4aRbQHxNEHWfwcclFpyCvfP01yySS7UCaWGhl6RySO3PD
OjbPyOQOw3E7B6SGAne8CtdJwWghFp1c/tnaUZh0LxcuhueRfOmdL3SDj047llan
W0WuU84zEAKB2t8C70AZfhiCCj16yyvX51wjOmK9IAu0DhNDFLIrdEy2EyWaRZa4
CFYcaIoMNbn3bqX1dfyKHNfjrw6ILDnkjxkQtNeL+kwyZadt905fI7E46v8J5GoJ
JEgL+j89qUvJIJpVDjzjYIfBPWEHXqcdQsMmncmZLcxNcgL6aMo=
=sseL
-----END PGP SIGNATURE-----

--ee5yiPEFqaf1SXFrF2iMQlCcG2LzxBvBO--


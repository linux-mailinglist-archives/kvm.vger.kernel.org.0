Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2764127BDDF
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 09:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgI2HUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 03:20:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18354 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2HUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 03:20:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T71Wfo073218;
        Tue, 29 Sep 2020 03:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=+HT7cJkjqc9WPC8Z7NJCzs1RLLtLioH61+cu+as0zzA=;
 b=YDRLh30p387VrJbBE0dVFn7g/O+h07QBiAaHVMy4KWY7Wp/PVU48c2QjMLF5EDOTAYjj
 tzNorlBd45b/YZiPYySpUmro7JZu68EhT2vAaVGWUGIymspDxYTqsr1AGKY+OQPEDCmp
 BtfmDzHSwLKGljPef6SGTKZiytFg0D6ueoHPHMezVmmjFJkUMx45FuCpN1eOTJM1gNQS
 hi91v2FZPRdkzPG6z56aGvweTy5yPVWH3ZH5KYW1UjO8jEyrZ9c48b7rME3x5AyKM1+q
 CmLk/PUbztjZtqEgZrRjCHJ48KGUMc87phZmTccAsxyU6FsHy2UiL1z1gpkeKAxhnzCe xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ux7vv75u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 03:20:00 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08T721wL075426;
        Tue, 29 Sep 2020 03:19:59 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ux7vv74x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 03:19:59 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08T7ICq5006812;
        Tue, 29 Sep 2020 07:19:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 33u5r9hca8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 07:19:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08T7JsqL27853218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 07:19:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91883A4060;
        Tue, 29 Sep 2020 07:19:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 341B5A4054;
        Tue, 29 Sep 2020 07:19:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 07:19:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
Date:   Tue, 29 Sep 2020 09:19:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928173147.750e7358.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iiiQSkrXsPKYyn6hwcsD5QoaBubDcAav7"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iiiQSkrXsPKYyn6hwcsD5QoaBubDcAav7
Content-Type: multipart/mixed; boundary="Lfgq9VU12Zqw1KZol0kYxaePWe3xduDxo"

--Lfgq9VU12Zqw1KZol0kYxaePWe3xduDxo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/28/20 5:31 PM, Cornelia Huck wrote:
> On Mon, 28 Sep 2020 16:23:34 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>=20
>> Some architectures need allocations to be done under a
>> specific address limit to allow DMA from I/O.
>>
>> We propose here a very simple page allocator to get
>> pages allocated under this specific limit.
>>
>> The DMA page allocator will only use part of the available memory
>> under the DMA address limit to let room for the standard allocator.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>  lib/alloc_dma_page.c | 57 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  lib/alloc_dma_page.h | 24 +++++++++++++++++++
>>  lib/s390x/sclp.c     |  2 ++
>>  s390x/Makefile       |  1 +
>>  4 files changed, 84 insertions(+)
>>  create mode 100644 lib/alloc_dma_page.c
>>  create mode 100644 lib/alloc_dma_page.h
>=20
> (...)
>=20
>> diff --git a/lib/alloc_dma_page.h b/lib/alloc_dma_page.h
>> new file mode 100644
>> index 0000000..85e1d2f
>> --- /dev/null
>> +++ b/lib/alloc_dma_page.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Page allocator for DMA definitions
>> + *
>> + * Copyright (c) IBM, Corp. 2020
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify =
it
>> + * under the terms of the GNU Library General Public License version =
2.
>> + */
>> +#ifndef _ALLOC_DMA_PAGE_H_
>> +#define _ALLOC_DMA_PAGE_H_
>> +
>> +#include <asm/page.h>
>> +
>> +void put_dma_page(void *dma_page);
>> +void *get_dma_page(void);
>> +phys_addr_t dma_page_alloc_init(phys_addr_t start_pfn, phys_addr_t nb=
_pages);
>> +
>> +#define DMA_MAX_PFN	(0x80000000 >> PAGE_SHIFT)
>> +#define DMA_ALLOC_RATIO	8
>=20
> Hm, shouldn't the architecture be able to decide where a dma page can
> be located? Or am I misunderstanding?

Before we start any other discussion on this patch we should clear up if
this is still necessary after Claudio's alloc revamp.

I think he added options to request special types of memory.

>=20
>> +
>> +#endif /* _ALLOC_DMA_PAGE_H_ */
> (...)
>=20



--Lfgq9VU12Zqw1KZol0kYxaePWe3xduDxo--

--iiiQSkrXsPKYyn6hwcsD5QoaBubDcAav7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9y4BkACgkQ41TmuOI4
ufj/2w//ZOQr/ojVVCunhMxmxNclgvBMh7EJdZJWaeNygf1W9mdbh16F+bBxmkPA
Ac0JF4anHo/AlhHJHx/9bgyibPIS5b2guazvRKYnmZZe6Uqv4gBT1a/hB5AIZbH/
Y9CjPdz82kh1J/YLjrUajpNSrG8yi+QYUD51UuKPKM/ougGkOFm7Ih0ZajsFh8iI
gotO5hsE07aBbIm/6rG0wHWd+1qCKAca2frdqjLzpQ9tX/huykj11euA5DMB3pf0
lvb9K2ie1NpBjeLjKRQRnucMELkQjBv8LZH5w/xG9oXi2auBqnhlAhAqz2aJHCTh
01koHPNTct1POCTy8IUnnfSAF4MegaXWqRHxbb6A3N/qUT5F/DQqZ7JA3wwQZSom
dq+kc++A/YNdRXXJbeeQYJFtwKCiuYxUi0Bk4aw56YlsjDReqFtWsm49T4zXt7M7
eZAi2b63cjtGtjJ4590XJRbHL9YRnU3Avq8w7BrfyAtSN0fxf36pq2ewtPXIXuQE
ODDKuFFz1JjhtKbG4AKyj/hfuMJfmd/E7PkVaj+Pa1YS8UtwLDMXReskb1RiOQ9e
GjQwL+6udgJN3Oq3aDlbjiiiPFcDJMUihzsVYd3WyqMsO1dwL/+U2cgdPxQwVZdA
eVASMSfmsAvNSfxiJ6duLr7FWzChpedcg9M7p48Ipk2AIXOROYQ=
=9AWW
-----END PGP SIGNATURE-----

--iiiQSkrXsPKYyn6hwcsD5QoaBubDcAav7--


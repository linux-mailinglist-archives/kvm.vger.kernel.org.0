Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79676D8774
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjDETzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjDETzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:55:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C6519B;
        Wed,  5 Apr 2023 12:55:09 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335IaUSH026306;
        Wed, 5 Apr 2023 19:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=c9VC5hdrrWwsBs+pGpOkdpCxT99nMDFBxDumN11HrTc=;
 b=pgLXsYlQyDI7/3eyD2w7kG/a0zvP9F45FC7kgQf39BfoSVabZ8ZFjlxOd1cBaN90Ilnl
 LTKlMD+dOj88tzXh6EZa0hREs4a/+djPkLIxOMzYTDZ27PjiW2FHMKd/Qkzh/wR4SWlW
 ysjC52ZycGuODpx/5XBgMbR//DgLmzwPFOnDL9DJjS75ouwsX20u15XU5zN7MLW+qd7v
 spQNf1H2LSCa1WwNLUT9z61SLEawBR7EDIylat/dGP58F6Tlvk/sUeutmPB3lA3fJi7n
 CBjNWNsVi4ZbiyfEHjN0scvNFI5C9V/RQE+LX5hmhjhQ8TfOXDpwIItUtr+9ij1tffgy 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75jnxhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 19:55:08 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 335JgRPe001248;
        Wed, 5 Apr 2023 19:55:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps75jnxgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 19:55:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 335JClxq018271;
        Wed, 5 Apr 2023 19:55:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86tqqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 19:55:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 335Jt1rN29622956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 19:55:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61BCB20043;
        Wed,  5 Apr 2023 19:55:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3762120040;
        Wed,  5 Apr 2023 19:55:01 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 19:55:01 +0000 (GMT)
Message-ID: <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without
 MSO/MSL
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Wed, 05 Apr 2023 21:55:01 +0200
In-Reply-To: <20230327082118.2177-5-nrb@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
         <20230327082118.2177-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9nQJqKlpet9nGNBMM8kCX2E--xx4cRC2
X-Proofpoint-ORIG-GUID: rFQ-FqImkTeGAK9xjdCupBvtune6eKsr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_13,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050175
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-03-27 at 10:21 +0200, Nico Boehr wrote:
> Since we now have the ability to run guests without MSO/MSL, add a test
> to make sure this doesn't break.
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile             |   2 +
>  s390x/sie-dat.c            | 121 +++++++++++++++++++++++++++++++++++++
>  s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
>  s390x/unittests.cfg        |   3 +
>  4 files changed, 184 insertions(+)
>  create mode 100644 s390x/sie-dat.c
>  create mode 100644 s390x/snippets/c/sie-dat.c
>=20

Test looks good to me. Some comments below.
[...]

> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> new file mode 100644
> index 000000000000..37e46386181c
> --- /dev/null
> +++ b/s390x/sie-dat.c
> @@ -0,0 +1,121 @@
>=20
[...]
> +
> +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TOTAL_PAGE_COUNT 256

This (1M) is the maximum snippet size (see snippet_setup_guest), is this in=
tentional?
In that case the comment is inaccurate, since you'd want to sync it with th=
e maximum snippet size.
You also know the actual snippet size SNIPPET_LEN(c, sie_dat) so I don't se=
e why you'd need a define
at all.

> +
> +static void test_sie_dat(void)
> +{
>=20
[...]
> +
> +	/* the guest will now write to an unmapped address and we check that th=
is causes a segment translation */

I'd prefer "causes a segment translation exception"

[...]


> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> new file mode 100644
> index 000000000000..c9f7af0f3a56
> --- /dev/null
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -0,0 +1,58 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <stddef.h>
> +#include <inttypes.h>
> +#include <string.h>
> +#include <asm-generic/page.h>
> +
> +/* keep in sync with GUEST_TEST_PAGE_COUNT in s390x/sie-dat.c */
> +#define TEST_PAGE_COUNT 10
> +static uint8_t test_page[TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__a=
ligned__(PAGE_SIZE)));
> +
> +/* keep in sync with GUEST_TOTAL_PAGE_COUNT in s390x/sie-dat.c */
> +#define TOTAL_PAGE_COUNT 256
> +
> +static inline void force_exit(void)
> +{
> +	asm volatile("	diag	0,0,0x44\n");

Pretty sure the compiler will generate a leading tab, so this will be doubl=
y indented.
> +}
> +
> +static inline void force_exit_value(uint64_t val)
> +{
> +	asm volatile(
> +		"	diag	%[val],0,0x9c\n"
> +		: : [val] "d"(val)
> +	);
> +}
> +
> +__attribute__((section(".text"))) int main(void)

Why is the attribute necessary? I know all the snippets have it, but I don'=
t see
why it's necessary.
@Janosch ?

> +{
> +	uint8_t *invalid_ptr;
> +
> +	memset(test_page, 0, sizeof(test_page));
> +	/* tell the host the page's physical address (we're running DAT off) */
> +	force_exit_value((uint64_t)test_page);
> +
> +	/* write some value to the page so the host can verify it */
> +	for (size_t i =3D 0; i < TEST_PAGE_COUNT; i++)
> +		test_page[i * PAGE_SIZE] =3D 42 + i;
> +
> +	/* indicate we've written all pages */
> +	force_exit();
> +
> +	/* the first unmapped address */
> +	invalid_ptr =3D (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);

Why not just use an address high enough you know it will not be mapped?
-1 should do just fine.

> +	*invalid_ptr =3D 42;
> +
> +	/* indicate we've written the non-allowed page (should never get here) =
*/
> +	force_exit();
> +
> +	return 0;
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index d97eb5e943c8..aab0e670f2d4 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -215,3 +215,6 @@ file =3D migration-skey.elf
>  smp =3D 2
>  groups =3D migration
>  extra_params =3D -append '--parallel'
> +
> +[sie-dat]
> +file =3D sie-dat.elf


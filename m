Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6A74D90A
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjGJO3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 10:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjGJO3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 10:29:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5448E;
        Mon, 10 Jul 2023 07:29:42 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AEHtwY032765;
        Mon, 10 Jul 2023 14:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=HFCguy5WtHdTlfdRrcTwFYuLdcQdJ+e2/Z9CJWGXU90=;
 b=qCVoSZtkGyWC65dpCbi6uTJFEWrP+6YOSo8c2saCjvpGn6VoBk8LxoIZ0TyA0DNbVTZE
 tiCNUdm/npqchSukNQ6Xb/qKmAj6ZvZuhg08mOqO62ZbTfQzi5VRPCneKNxJudyM/Cvn
 F1b+JIMX1Rtq70lmtQ41vGWQ4YYP2JPc6MVInpn9b7gc0/E77um3J/C2m+R7RqUm/tJN
 MQoUg0aYkXmTmavQtrl3gb+bUtiZ4IAXY5ipcBqy9xsE5dWlam55BhugJFjUhgNXUlrF
 KHK+k3GY8/ZFtrHjtT7jqW48bigmGqFs0jxR+jCkmXTO3O6RTcIc5vwLlsCYZcVJAAhd 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrkma8ar1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 14:29:41 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36AEIgki003607;
        Mon, 10 Jul 2023 14:29:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrkma8aph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 14:29:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36AAamm6009382;
        Mon, 10 Jul 2023 14:29:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5990x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 14:29:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36AETZFd21234254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 14:29:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 903392004B;
        Mon, 10 Jul 2023 14:29:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6267120043;
        Mon, 10 Jul 2023 14:29:35 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.1.107])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jul 2023 14:29:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ab1047c5-77f1-d68b-cf05-4bcda44909ed@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com> <20230601070202.152094-7-nrb@linux.ibm.com> <ab1047c5-77f1-d68b-cf05-4bcda44909ed@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: add a test for SIE without MSO/MSL
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Message-ID: <168899937501.42553.5805213823249646110@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 10 Jul 2023 16:29:35 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8NEI2yd9WYneZ5BsZ0U9dPw8DB4OYT9d
X-Proofpoint-GUID: Pdzb0jnBZQ6PUHaw1nvoHC5He-qnEsvT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307100127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-05 11:57:58)
[...]
> > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > new file mode 100644
> > index 000000000000..c490a2aa825c
[...]
> > +#include <libcflat.h>
> > +#include <vmalloc.h>
> > +#include <asm/asm-offsets.h>
>=20
> I only did a cursory glance and wasn't able to see a use for this include.

Yep, thanks, I cleaned up the includes a bit.

[...]
> > +static void test_sie_dat(void)
> > +{
> > +     uint8_t r1;
> > +     bool contents_match;
> > +     uint64_t test_page_gpa, test_page_hpa;
> > +     uint8_t *test_page_hva;
> > +
> > +     /* guest will tell us the guest physical address of the test buff=
er */
> > +     sie(&vm);
> > +
> > +     r1 =3D (vm.sblk->ipa & 0xf0) >> 4;
> > +     test_page_gpa =3D vm.save_area.guest.grs[r1];
> > +     test_page_hpa =3D virt_to_pte_phys(guest_root, (void*)test_page_g=
pa);
> > +     test_page_hva =3D __va(test_page_hpa);
> > +     report(vm.sblk->icptcode =3D=3D ICPT_INST &&
> > +            (vm.sblk->ipa & 0xFF00) =3D=3D 0x8300 && vm.sblk->ipb =3D=
=3D 0x9c0000,
> > +            "test buffer gpa=3D0x%lx hva=3D%p", test_page_gpa, test_pa=
ge_hva);
>=20
> You could rebase on my pv_icptdata.h patch.
> Also the report string and boolean don't really relate to each other.

Which patch are we talking about? pv_icptdata_check_diag()?

Note that this is not a PV test, so I guess it's not applicable here?

> Not every exit needs to be a report.
> Some should rather be asserts() or report_info()s.

Yeah, I have made report()s where it doesn't make sense to continue assert(=
)s

> > +     contents_match =3D true;
> > +     for (unsigned int i =3D 0; i < GUEST_TEST_PAGE_COUNT; i++) {
> > +             uint8_t expected_val =3D 42 + i;
>=20
> Just because you can doesn't mean that you have to.
> At least leave a \n when declaring new variables...

I am a bit confused but I *guess* you wanted me to move the declaration of
expected_val to the beginning of the function?

[...]
> > diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> > new file mode 100644
> > index 000000000000..e156d0c36c4c
> > --- /dev/null
> > +++ b/s390x/snippets/c/sie-dat.c
> > @@ -0,0 +1,58 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
> > + *
> > + * Copyright (c) 2023 IBM Corp
> > + *
> > + * Authors:
> > + *  Nico Boehr <nrb@linux.ibm.com>
> > + */
> > +#include <stddef.h>
> > +#include <inttypes.h>
> > +#include <string.h>
> > +#include <asm-generic/page.h>
> > +
> > +/* keep in sync with GUEST_TEST_PAGE_COUNT in s390x/sie-dat.c */
> > +#define TEST_PAGE_COUNT 10
> > +static uint8_t test_page[TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((_=
_aligned__(PAGE_SIZE)));
> > +
> > +/* keep in sync with GUEST_TOTAL_PAGE_COUNT in s390x/sie-dat.c */
> > +#define TOTAL_PAGE_COUNT 256
> > +
> > +static inline void force_exit(void)
> > +{
> > +     asm volatile("diag      0,0,0x44\n");
> > +}
> > +
> > +static inline void force_exit_value(uint64_t val)
> > +{
> > +     asm volatile(
> > +             "diag   %[val],0,0x9c\n"
> > +             : : [val] "d"(val)
> > +     );
> > +}
>=20
> It feels like these need to go into a snippet lib.

A bunch of other tests do similar things, so I'll write a TODO and tackle i=
t in
a seperate series.

[...]
> > +
> > +__attribute__((section(".text"))) int main(void)
>=20
> The attribute shouldn't be needed anymore.

OK, removed.

[...]
> > +{
> > +     uint8_t *invalid_ptr;
> > +
> > +     memset(test_page, 0, sizeof(test_page));
> > +     /* tell the host the page's physical address (we're running DAT o=
ff) */
> > +     force_exit_value((uint64_t)test_page);
> > +
> > +     /* write some value to the page so the host can verify it */
> > +     for (size_t i =3D 0; i < TEST_PAGE_COUNT; i++)
>=20
> Why is i a size_t type?

Because it's a suitable unsigned type for use as an array index.

What should it be instead?

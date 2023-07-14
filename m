Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA4075351C
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjGNIfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbjGNIf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:35:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE7A1BEB;
        Fri, 14 Jul 2023 01:35:26 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36E8YuXq016860;
        Fri, 14 Jul 2023 08:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=S9WdxDUjDGi56PpysM3wbTHSgFlTgIAUvxXGbSLAYP0=;
 b=Lu97x3VqE90HStfioVf0MaooQ/0wdU46lPvBmBIwsZ+VMqli0LY7FbdWG9J3gcGwC2bZ
 L9R5EwpmyPbebvih+iUC+WC2HfC4JOncYW5Jgo8LDzIrtwPxxJvLRTJ62uaH8Ny/zvGa
 otxl2zxQRhFpOhkxWn6SlsLjh5QRHu0AWKlpK8iLZzXFh6ZuC/3RTqCTxQxAd9azYyGB
 iIzfGs08VMj6BKobL30UYI1oje6AgKx3RMoEYGs5Qr852Gtshjtg2RalDq1XhNBscyeo
 2x4qnsxYxqm+R4cMxGg7Zrqi0hzeurGYGPQoYin0ZD4S/8mdOcCGjC9wT3gj8owU75Gd Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru2t685p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:35:26 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36E8Nfo9020374;
        Fri, 14 Jul 2023 08:35:25 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru2t685nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:35:25 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36E4iWuM007370;
        Fri, 14 Jul 2023 08:35:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rtpvs193e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:35:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36E8ZLDT19923604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 08:35:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EDD020043;
        Fri, 14 Jul 2023 08:35:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2949320040;
        Fri, 14 Jul 2023 08:35:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.42.10])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 08:35:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1aac769e-7523-a858-8286-35625bfb0145@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-7-nrb@linux.ibm.com> <1aac769e-7523-a858-8286-35625bfb0145@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: add a test for SIE without MSO/MSL
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168932372015.12187.10530769865303760697@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Jul 2023 10:35:20 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NVY8gRditOVgGwzMNFLD9A5waYa8Mud9
X-Proofpoint-GUID: gopZEPtC8q0Fk7rjmRv6swAi2BscCcpg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 mlxlogscore=942 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-13 10:29:48)
[...]
> > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > new file mode 100644
> > index 000000000000..b326995dfa85
> > --- /dev/null
> > +++ b/s390x/sie-dat.c
> > @@ -0,0 +1,115 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Tests SIE with paging.
> > + *
> > + * Copyright 2023 IBM Corp.
> > + *
> > + * Authors:
> > + *    Nico Boehr <nrb@linux.ibm.com>
> > + */
> > +#include <libcflat.h>
> > +#include <vmalloc.h>
> > +#include <asm/pgtable.h>
> > +#include <mmu.h>
> > +#include <asm/page.h>
> > +#include <asm/interrupt.h>
> > +#include <alloc_page.h>
> > +#include <sclp.h>
> > +#include <sie.h>
> > +#include <snippet.h>
> > +
> > +static struct vm vm;
> > +static pgd_t *guest_root;
> > +
> > +/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> > +#define GUEST_TEST_PAGE_COUNT 10
> > +
> > +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> > +#define GUEST_TOTAL_PAGE_COUNT 256
>=20
> I'd maybe put the defines rather in a header a la s390x/snippets/c/sie-da=
t.h=20
> and include that header here and in the snippet C code.

I'd have to

#include "../s390x/snippets/c/sie-dat.h"

and it feels like I shouldn't be doing this, should I?

Or move the include to lib, but we agreed we don't want test-specific stuff
in the lib.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C453637A09
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKXNeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKXNeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:34:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DB586A53
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:34:18 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOAfDYV014195
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : to : subject : message-id : date; s=pp1;
 bh=WQQIOnFneWAXOzyd+W6JU6ehswHce3ce7N1Dq+yJ51s=;
 b=BTIshCTccgsgteo0OV+WouvCh6MJRhhNIYpVmZn6yWmMQ/WiBeXRncXSnew9gDAwaege
 sgFwTb88xz1ivDZI8AzFehIU2G+c39CdvI5FVz+T/fxXrWgoRiEAbJkrjDuVk0uKatsi
 P9VpCgTVwdSTLNI52zE/X75ZQmeRcyDXLwj4ZprD5KuIXu58HSmHknz3Co8p2u7Q/Jpe
 N1oExTAiJL0A0NyEOE8VOydhH7PBLyiaH0BQ0MiuPsxRtPecep8YGhklIBNVa2XgjRWh
 kQ7TnRzN7TbKoiwNB0558qb4P0j4lyC7vPklbYaXqxfIEOUiQyNjQo5gXmLU+7wgGCKy 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153u74s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:34:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AODHeWv019659
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:34:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1153u741-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:34:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AODLJpM008902;
        Thu, 24 Nov 2022 13:34:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps90825-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:34:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AODRtRo12911354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 13:27:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D8142042;
        Thu, 24 Nov 2022 13:34:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D82142047;
        Thu, 24 Nov 2022 13:34:12 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.54.27])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 13:34:12 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221123132555.38e68669@p-imbrenda>
References: <20221122161243.214814-1-nrb@linux.ibm.com> <20221122161243.214814-3-nrb@linux.ibm.com> <20221123132555.38e68669@p-imbrenda>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add CMM test during migration
Message-ID: <166929685142.7765.5952184081736824569@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 24 Nov 2022 14:34:11 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QLtOWxPMvfF4_0alwsrHZt_TA2bzc7dJ
X-Proofpoint-GUID: KAv052CV57XTAg2j1w-21aqtq7XtImik
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_09,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=684 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211240102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-11-23 13:25:55)
[...]
> > diff --git a/s390x/migration-during-cmm.c b/s390x/migration-during-cmm.c
> > new file mode 100644
> > index 000000000000..3c96283d7b00
> > --- /dev/null
> > +++ b/s390x/migration-during-cmm.c
> > @@ -0,0 +1,111 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Perform CMMA actions while migrating.
> > + *
> > + * Copyright IBM Corp. 2022
> > + *
> > + * Authors:
> > + *  Nico Boehr <nrb@linux.ibm.com>
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <smp.h>
> > +#include <asm-generic/barrier.h>
> > +
> > +#include "cmm.h"
> > +
> > +#define NUM_PAGES 128
>=20
> is 128 enough to allow multiple iterations of the thread?

Enough for about 16.000 iterations on my box :)

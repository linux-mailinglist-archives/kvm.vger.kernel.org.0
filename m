Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F1163EAE0
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLAINB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLAIM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:12:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51E743857
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:12:57 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B17jelL004440;
        Thu, 1 Dec 2022 08:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=NnIjuiIUXGbdY93w8W9O4jnx4O2WhcjycEW7K9FJViY=;
 b=BR4ln+udLObqtUvjb0JhHjAIPZKCYY/kJi4vWhT1QbUiDwfsg5H/0+pJJpRy2R3/OWom
 abujukDXepzcnRYlR2SJAWSbf/L88iODIAd34iQUlFTxqYokV2O/l+jtkyotQ0JkEid8
 0XUkoMeMYTlFOVwCw/Pto6ifWWpvHYABYMyLiMHK5ErehDyMethGEkRasOxsNA3sdrOH
 UsJee5+bexsSbQo2MWaDdiWpZ9POQwtAcxFSKXqyuoMbwgeS/r1DuXdsRW6b9+ZQm2F/
 49vHZtL2bsKgwe37MA9E0ApTtZ6wuqaqpFYNwqIt/Q6Xl/IoT3w0icbz6OIxK0H70W+p 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6r5r8s3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:12:54 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B17ri8Q011610;
        Thu, 1 Dec 2022 08:12:54 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6r5r8s2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:12:54 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B184x3n002721;
        Thu, 1 Dec 2022 08:12:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3m3ae9537b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:12:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B18CmCl1573458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 08:12:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6628A404D;
        Thu,  1 Dec 2022 08:12:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80A55A4040;
        Thu,  1 Dec 2022 08:12:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.88.185])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 08:12:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221130183006.7cf99578@p-imbrenda>
References: <20221130142249.3558647-1-nrb@linux.ibm.com> <20221130142249.3558647-2-nrb@linux.ibm.com> <20221130183006.7cf99578@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: add function to request migration
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <166988236777.186408.5088630858403642195@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 01 Dec 2022 09:12:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BhnuRBmdQEzH3bNCvx3rujleDY1ja1RE
X-Proofpoint-ORIG-GUID: q4YKkCQI1fS65trbuqJcWnw-san151GL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=924 mlxscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212010054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-11-30 18:30:06)
> On Wed, 30 Nov 2022 15:22:46 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
[...]
> > diff --git a/lib/migrate.c b/lib/migrate.c
> > new file mode 100644
> > index 000000000000..50e78fb08865
> > --- /dev/null
> > +++ b/lib/migrate.c
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Migration-related functions
> > + *
> > + * Copyright IBM Corp. 2022
> > + * Author: Nico Boehr <nrb@linux.ibm.com>
> > + */
> > +#include <libcflat.h>
> > +#include "migrate.h"
> > +
> > +/* static for now since we only support migrating exactly once per tes=
t. */
> > +static void migrate(void)
> > +{
> > +     puts("Please migrate me, then press return\n");
>=20
> the other architectures use a slightly different message, maybe we
> should use that also on s390x?
>=20
> In the end it _should_ not matter, since the migrate_cmd looks for one
> specific keyword, but I still think we should try to minimize the
> impact of this series. And I know that changing the migration message
> will not break anything on s390x.

Oh yes, that's a very good point. Changed.

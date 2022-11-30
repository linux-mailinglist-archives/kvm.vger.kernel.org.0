Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C2963DC0F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiK3RfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3RfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:35:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383CC22BFA
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:35:22 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUHTTqV030432;
        Wed, 30 Nov 2022 17:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4erfAPecRBXB6FYRYG6vd4/JUg1Y5hrgIvJx5g6O4A8=;
 b=H2JZQpOaogYscvaWCboN1bZUnLbCB9g4sY9GAq7nKnghCnZEH8rMJFMd6pTEys2CEAII
 llfk9W1XDdmA6iwG+IbWVEgEVnHnwB74ys+ej6vWynO1qUTFu0gU6Lg8b+FrF9T/fFgu
 ZNXQqlhcg8lE4p1R6hO8Kv9okknbMkYZxv+5z7H/75JNIxxE/FfpvlrnaMIAmv4m9olN
 cO4mePeKS+p1YiQC+IVrI8r81VGVlmEOPM7ZXGPGlbVyspGKOX1bGK+tQgNO3BUT1tvh
 cFYH6AYtKsToJ96vQuhF1kLs5C35BKsneJubMxXfC4VwciR4E1XRSZ1TdIiRbSTL4UCu bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6bmd85ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 17:35:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUHVA9h008423;
        Wed, 30 Nov 2022 17:35:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6bmd85x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 17:35:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUHKMwY024543;
        Wed, 30 Nov 2022 17:35:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hx6y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 17:35:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUHZCoU9634486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 17:35:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AD1FA4040;
        Wed, 30 Nov 2022 17:35:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E35CA404D;
        Wed, 30 Nov 2022 17:35:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 17:35:12 +0000 (GMT)
Date:   Wed, 30 Nov 2022 18:30:06 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: add function to request
 migration
Message-ID: <20221130183006.7cf99578@p-imbrenda>
In-Reply-To: <20221130142249.3558647-2-nrb@linux.ibm.com>
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
        <20221130142249.3558647-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xSUm3_nQygn0oc5aS3f_Jq6Rd0KI0UE1
X-Proofpoint-GUID: muoB-DooX0VkuMxiev7tZ1KFHT48ALrZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Nov 2022 15:22:46 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Migration tests can ask migrate_cmd to migrate them to a new QEMU
> process. Requesting migration and waiting for completion is hence a
> common pattern which is repeated all over the code base. Add a function
> which does all of that to avoid repeating the same pattern.
> 
> Since migrate_cmd currently can only migrate exactly once, this function
> is called migrate_once() and is a no-op when it has been called before.
> This can simplify the control flow, especially when tests are skipped.
> 
> Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

I like the code, I only have one concern

> ---
>  lib/migrate.c | 34 ++++++++++++++++++++++++++++++++++
>  lib/migrate.h |  9 +++++++++
>  2 files changed, 43 insertions(+)
>  create mode 100644 lib/migrate.c
>  create mode 100644 lib/migrate.h
> 
> diff --git a/lib/migrate.c b/lib/migrate.c
> new file mode 100644
> index 000000000000..50e78fb08865
> --- /dev/null
> +++ b/lib/migrate.c
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Migration-related functions
> + *
> + * Copyright IBM Corp. 2022
> + * Author: Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include "migrate.h"
> +
> +/* static for now since we only support migrating exactly once per test. */
> +static void migrate(void)
> +{
> +	puts("Please migrate me, then press return\n");

the other architectures use a slightly different message, maybe we
should use that also on s390x?

In the end it _should_ not matter, since the migrate_cmd looks for one
specific keyword, but I still think we should try to minimize the
impact of this series. And I know that changing the migration message
will not break anything on s390x.

> +	(void)getchar();
> +	report_info("Migration complete");
> +}
> +
> +/*
> + * Initiate migration and wait for it to complete.
> + * If this function is called more than once, it is a no-op.
> + * Since migrate_cmd can only migrate exactly once this function can
> + * simplify the control flow, especially when skipping tests.
> + */
> +void migrate_once(void)
> +{
> +	static bool migrated;
> +
> +	if (migrated)
> +		return;
> +
> +	migrated = true;
> +	migrate();
> +}
> diff --git a/lib/migrate.h b/lib/migrate.h
> new file mode 100644
> index 000000000000..3c94e6af761c
> --- /dev/null
> +++ b/lib/migrate.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Migration-related functions
> + *
> + * Copyright IBM Corp. 2022
> + * Author: Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +void migrate_once(void);


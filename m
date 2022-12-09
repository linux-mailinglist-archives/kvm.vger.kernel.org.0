Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1A6485B6
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 16:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiLIPl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 10:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLIPlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 10:41:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270AA12AA3
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 07:41:24 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9DSfS8015203;
        Fri, 9 Dec 2022 15:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xqLRr+WVbJ3Rbas5KHEPr5xYgWA2H+4rD4uiJtvWVuQ=;
 b=Pm5wQfImLuEbNlcHCX1zNK9fwx0si6fmoAH6boKpE1AOgI0mHRkzKyO0m7vvz2h6mu8D
 OavyPKJCY0EQfVY7EgEH1B7bQBYDZkufmre3MfWpvf7HaZCMQWU/mLMQBLypYcA/7fPe
 OpGuzpK6UJSb4TI0Hc/Erh0eJHXizGSjLhcb++3rysLDort9ncRU4zgGdVO5soiuvcQC
 NoDQ6h7AtdmmVW5LP+9rMlmdpfwa/F0vMxHRaLSrOYLqymmjY6HbtEKsuzDicTb/5j/P
 aNKl8JjuOgPD/PdNtuEdec3XMTbH95ZItapGbY9MfaFgDlsV7r9A1IRnUVT9PHZz5lBx hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mc10qtkjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 15:41:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9FGVK6024983;
        Fri, 9 Dec 2022 15:41:20 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mc10qtkhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 15:41:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B98uh1o002516;
        Fri, 9 Dec 2022 15:41:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3m9mb24jeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 15:41:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9FfEjs30933276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 15:41:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22D7A2004D;
        Fri,  9 Dec 2022 15:41:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93B1020043;
        Fri,  9 Dec 2022 15:41:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.67.167])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri,  9 Dec 2022 15:41:13 +0000 (GMT)
Date:   Fri, 9 Dec 2022 16:41:11 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib: add function to request
 migration
Message-ID: <20221209164111.4a3f8da2@p-imbrenda>
In-Reply-To: <20221209134809.34532-2-nrb@linux.ibm.com>
References: <20221209134809.34532-1-nrb@linux.ibm.com>
        <20221209134809.34532-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e3Umo0Z7GZer6vR91GASok6Vv2kgjx4I
X-Proofpoint-ORIG-GUID: jXHtM-yaM1B8-8m7Gpkc_NWYSc4NX4Sv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_09,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  9 Dec 2022 14:48:06 +0100
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/migrate.h |  9 +++++++++
>  lib/migrate.c | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
>  create mode 100644 lib/migrate.h
>  create mode 100644 lib/migrate.c
> 
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
> diff --git a/lib/migrate.c b/lib/migrate.c
> new file mode 100644
> index 000000000000..527e63ae189b
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
> +	puts("Now migrate the VM, then press a key to continue...\n");
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1662F4FBCA3
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346297AbiDKNBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345215AbiDKNBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:01:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B62E18E26;
        Mon, 11 Apr 2022 05:59:27 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BBmG4W029170;
        Mon, 11 Apr 2022 12:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MiMB6R56uYK0VynEat8FPmICo9Z+Tfv1DUMB85Xchow=;
 b=tLWammrCmraGNUYCIkvLsD56N5CZNMTwcBf0b6vZOaE39pQ8QrzEMPHd6HVTGsXtS1vf
 hqmrbwd4Ko6ZSgIVZ5bUcfkSvCTMsX4IIYswPT/vBTcF5aXK39tIvfM1GCWWH1dLZxsM
 sE4+prBTEWMbc+US0mApEUOOyLDZeusC3A8ihyYrG93P43uOrmEtIod65a9ThXd+u6vu
 waQqJlueEQBMkBTLOVLkKytRCbDI8eaGHp57qBKJZrkj2t4hFqRMb3gAkAe80IbfpcJY
 6BKEQQrodlPxDR4U1hOesK073rzYskHaeEtY9N2jBWwnTZzjQ1FAUTBZkT4K/wwIk1US Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcks91f89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BCgijT015515;
        Mon, 11 Apr 2022 12:59:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcks91f7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrfxt008599;
        Mon, 11 Apr 2022 12:59:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj35mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:59:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BCxTrk47448428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:59:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C4D4C044;
        Mon, 11 Apr 2022 12:59:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 431AA4C040;
        Mon, 11 Apr 2022 12:59:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 12:59:20 +0000 (GMT)
Date:   Mon, 11 Apr 2022 14:49:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
Message-ID: <20220411144944.690d19f5@p-imbrenda>
In-Reply-To: <20220411100750.2868587-5-nrb@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
        <20220411100750.2868587-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lPM0cVzsf38choLog-PnnCqOad8O5Om6
X-Proofpoint-ORIG-GUID: fY6ep3A7KhQIv0yGMCLaM44_2lV8s9hS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Apr 2022 12:07:50 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a selftest to check we can do migration tests.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile             |  1 +
>  s390x/selftest-migration.c | 27 +++++++++++++++++++++++++++
>  s390x/unittests.cfg        |  4 ++++
>  3 files changed, 32 insertions(+)
>  create mode 100644 s390x/selftest-migration.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 62e197cb93d7..2e43e323bcb5 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
>  tests += $(TEST_DIR)/firq.elf
> +tests += $(TEST_DIR)/selftest-migration.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
> new file mode 100644
> index 000000000000..8884322a84ca
> --- /dev/null
> +++ b/s390x/selftest-migration.c
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Migration Selftest
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +
> +int main(void)
> +{
> +	/* don't say migrate here otherwise we will migrate right away */
> +	report_prefix_push("selftest migration");
> +
> +	/* ask migrate_cmd to migrate (it listens for 'migrate') */
> +	puts("Please migrate me\n");
> +
> +	/* wait for migration to finish, we will read a newline */
> +	(void)getchar();

how hard would it be to actually check that you got the newline?

> +
> +	report_pass("Migrated");
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 1600e714c8b9..b0417a69705d 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -24,6 +24,10 @@ groups = selftest
>  # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
>  extra_params = -append 'test 123'
>  
> +[selftest-migration]
> +file = selftest-migration.elf
> +groups = selftest migration
> +
>  [intercept]
>  file = intercept.elf
>  


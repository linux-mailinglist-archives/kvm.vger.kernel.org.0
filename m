Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD964CB7B
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 14:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbiLNNmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 08:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLNNms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 08:42:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8104326AB7
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 05:42:47 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEDfkuk002439
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mND3bd1UCYcBaVnemS+sf722MiAE8qM3xBpYN+p3MlY=;
 b=Hxj4pExVK06E1yOLHyU1PpPLCOdoWfh8xuFlJ+Hikk85eaju44rVKAvFajj+UCjTk9sW
 bINzy8QJTkusrw/QjZI4aniL4R1bjzkVjscNjNM+K+vV6H7vGBntqguPqc7AVYCVivv8
 WK9hGUYKP8BCcnfMHkvpm+r/g5yqhxNbyVerFTbEhuoUeO8LE6ZvJPdKV0zH1k8pO7nN
 LU5yug6SqgE48mKKTfLBRrO77igiXe18H0scVMTeLce/tb0dlem+o7Rt/mvv8NEbfXwD
 bXYnsOJaDGpza2/Hyt6jr+2xBTI3KLNgZgeWtCRl/kXz9qmiOXWah6JnxwechSAM3YaQ 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mffkjr0w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:42:47 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEDg1AH003247
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:42:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mffkjr0va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:42:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE9sCo7024423;
        Wed, 14 Dec 2022 13:42:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3meyjbhbc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:42:44 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEDgeWS20120238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 13:42:40 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8770020040;
        Wed, 14 Dec 2022 13:42:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C14C20049;
        Wed, 14 Dec 2022 13:42:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 13:42:40 +0000 (GMT)
Date:   Wed, 14 Dec 2022 14:42:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add parallel skey
 migration test
Message-ID: <20221214144238.27b886bd@p-imbrenda>
In-Reply-To: <20221214123814.651451-2-nrb@linux.ibm.com>
References: <20221214123814.651451-1-nrb@linux.ibm.com>
        <20221214123814.651451-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qVQV7b7QDN3AUZ4MYqWN7DhW3Rn0dLkc
X-Proofpoint-ORIG-GUID: HN8JuP7d2KaHDj24_0lpwb7RP1nQGGrr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Dec 2022 13:38:14 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Right now, we have a test which sets storage keys, then migrates the VM
> and - after migration finished - verifies the skeys are still there.
> 
> Add a new version of the test which changes storage keys while the
> migration is in progress. This is achieved by adding a command line
> argument to the existing migration-skey test.

just some small cosmetic issues

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/migration-skey.c | 218 +++++++++++++++++++++++++++++++++++++----
>  s390x/unittests.cfg    |  15 ++-
>  2 files changed, 210 insertions(+), 23 deletions(-)
> 
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> index a91eb6b5a63e..0f862cc9d821 100644
> --- a/s390x/migration-skey.c
> +++ b/s390x/migration-skey.c
> @@ -2,6 +2,12 @@
>  /*
>   * Storage Key migration tests
>   *
> + * There are two variants of this test:
> + * - sequential: sets some storage keys on pages, migrates the VM and then

"set storage keys on some pages"?
or just "set some storage keys"

> + *   verifies the storage keys are still as we expect.

s/the/that the/

> + * - parallel: start migration of a VM and set and check storage keys on some

s/of a VM/of VM/  or  s/of a VM/of the VM/  or even just  s/of the VM//

> + *   pages while migration is in process.
> + *
>   * Copyright IBM Corp. 2022
>   *
>   * Authors:
> @@ -13,16 +19,45 @@
>  #include <asm/facility.h>
>  #include <asm/page.h>
>  #include <asm/mem.h>
> -#include <asm/interrupt.h>
> +#include <asm/barrier.h>
>  #include <hardware.h>
> +#include <smp.h>
> +

[...]

> +
> +static void print_usage(void)
> +{
> +	report_info("Usage: migration-skey [parallel|sequential]");

--parallel and --sequential

> +}
> +

[...]


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DB73EA22E
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhHLJjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:39:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235166AbhHLJjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 05:39:10 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C9Y9uc059214;
        Thu, 12 Aug 2021 05:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B4ESlgt/+Lrp/jkfBwwhu0O4mVP/rZklSNvJOeUHJ00=;
 b=JEvjBxQiKB3go/b8ZLo8hKWMxZrgmoK4/4ZKw6tbT9pftDQjSck8tXHnWniV8wPk9BjD
 C275GCcKXAmqOaHFSk0Ieofo0vAj9jZR9LjsLM1WuSohIcjp7rAYQEXaNpLXu3r6ZLLM
 J7ucEFheJy3v0ogEB3g4vOo4p6wtjoDOJoYTEhO8T6kOGKHnRDhU19csOyTkfsGdXrBq
 mv/jWP0oDU/X6fkTIGJC6wLJRAPbeODkS6K8u6+J03ToCqGvbb038VbwAbUhBWHX9JZf
 /yhi7/JQw36rS0yQ9LVKjuyjjtfchOdRgBbssXE24khyhk2Tl69yPCZ0PmH/qQipfkMx kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abrr6n7q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 05:38:44 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17C9YCTx059457;
        Thu, 12 Aug 2021 05:38:44 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abrr6n7jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 05:38:44 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17C9btgT017359;
        Thu, 12 Aug 2021 09:38:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn768vk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 09:38:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17C9ca1E54526306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 09:38:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 684DEA404D;
        Thu, 12 Aug 2021 09:38:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B1C8A405F;
        Thu, 12 Aug 2021 09:38:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.58.112])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 09:38:35 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-4-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] s390x: topology: Check the Perform
 Topology Function
Message-ID: <ae1eb2bc-8570-d114-9f45-4aaf40d23d3f@linux.ibm.com>
Date:   Thu, 12 Aug 2021 11:38:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1628612544-25130-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 213GjdATOgSCM_V-7B0mtVshbOHL_Uxx
X-Proofpoint-GUID: e3IqL7tTT1UHeKW3kEkSKmgeo4ooCJlh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_03:2021-08-11,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/21 6:22 PM, Pierre Morel wrote:
> We check the PTF instruction.
> 
> - We do not expect to support vertical polarization.

KVM does not support vertical polarization and we don't expect it to be
added in the future?

> 
> - We do not expect the Modified Topology Change Report to be
> pending or not at the moment the first PTF instruction with
> PTF_CHECK function code is done as some code already did run
> a polarization change may have occur.

ENOPARSE

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |  1 +
>  s390x/topology.c    | 99 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  3 ++
>  3 files changed, 103 insertions(+)
>  create mode 100644 s390x/topology.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 6565561b..c82b7dbf 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>  tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
> +tests += $(TEST_DIR)/topology.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 00000000..a0dc3b9e
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <smp.h>
> +#include <sclp.h>
> +
> +static int machine_level;
> +
> +#define PTF_REQ_HORIZONTAL	0
> +#define PTF_REQ_VERTICAL	1
> +#define PTF_REQ_CHECK		2
> +
> +#define PTF_ERR_NO_REASON	0
> +#define PTF_ERR_ALRDY_POLARIZED	1
> +#define PTF_ERR_IN_PROGRESS	2
> +
> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"       .insn   rre,0xb9a20000,%1,0\n"
> +		"       ipm     %0\n"
> +		"       srl     %0,28\n"
> +		: "=d" (cc), "+d" (fc)
> +		: "d" (fc)
> +		: "cc");
> +
> +	*rc = fc >> 8;
> +	return cc;
> +}
> +
> +static void test_ptf(void)
> +{
> +	unsigned long rc;
> +	int cc;
> +
> +	report_prefix_push("Topology Report pending");
> +	/*
> +	 * At this moment the topology may already have changed
> +	 * since the VM has been started.
> +	 * However, we can test if a second PTF instruction
> +	 * reports that the topology did not change since the
> +	 * preceding PFT instruction.
> +	 */
> +	ptf(PTF_REQ_CHECK, &rc);
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 0, "PTF check clear");
> +
> +	/*
> +	 * In the LPAR we can not assume the state of the polarizatiom

polarization

> +	 * at this moment.
> +	 * Let's skip the tests for LPAR.
> +	 */

Any idea what happens on z/VM?
We don't necessarily need to support z/VM but we at least need to skip
like we do on lpar :-)

Maybe also add a TODO, so we know we could improve the test?

> +	if (machine_level < 3)
> +		goto end;
> +

Add comments:
We're always horizontally polarized in KVM.

> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "PTF horizontal already configured");
> +

KVM doesn't support vertical polarization.

> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
> +	       "PTF vertical non possible");

s/non/not/

> +
> +end:
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	report_prefix_push("CPU Topology");
> +
> +	if (!test_facility(11)) {
> +		report_skip("Topology facility not present");
> +		goto end;
> +	}
> +
> +	machine_level = stsi_get_fc();
> +	report_info("Machine level %d", machine_level);
> +
> +	test_ptf();
> +
> +end:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9e1802fd..0f84d279 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -109,3 +109,6 @@ file = edat.elf
>  
>  [mvpg-sie]
>  file = mvpg-sie.elf
> +
> +[topology]
> +file = topology.elf
> 


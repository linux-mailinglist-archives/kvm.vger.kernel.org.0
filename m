Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7D3E43A8
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhHIKNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:13:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233565AbhHIKNR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:13:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A4jNg078514;
        Mon, 9 Aug 2021 06:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NKVVi+n9mtJZzCDIiSEAmn69bl6QKSQ83f1B9r4bnb4=;
 b=f0laSEpaKWQLWm3uxtgBXMpcAptZlvl4mDcHq2FV8t4BsI15Eaph4fVZ2yChZxbDBDXo
 O+6yeWMaD7Cm4oaJDAXtXnBSQrtIKZp3ekkyCo/p4YFs2uPJMZ/OCeXfWjnHqmAgqNxk
 07XLAf4M21EskFoLczyd7oRvubkkVtnJoWcfvkYaKohXkycE6Kqo8GK3XAKKlN7K49O+
 1mU+c+yWeKE9fHb0l6mZs9AqQR0YznK3sSpMh4N033mbJOE/hDgvxK4waSZqrKZ/hmX+
 3K1Drph1pKPRSIS0WkIf7ozuxR/PE+LQNtidTyb7Uz+3UeBvr3zVS7ZRDTU0CJf7Mi1y 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab28mr7ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:12:56 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179A4i97078393;
        Mon, 9 Aug 2021 06:12:55 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab28mr7c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:12:55 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179A6xRO015760;
        Mon, 9 Aug 2021 10:12:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8usjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:12:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179ACov657409818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:12:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0C7EA4060;
        Mon,  9 Aug 2021 10:12:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80390A4066;
        Mon,  9 Aug 2021 10:12:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.74])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 10:12:49 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: topology: check the Perform
 Topology Function
Message-ID: <9590216d-9cfd-0725-e77a-9bd13f8a2d60@linux.ibm.com>
Date:   Mon, 9 Aug 2021 12:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nbhieWCvGeWafsR__nvKXFr3GzUR1CYj
X-Proofpoint-ORIG-GUID: 1z9_4_DCn3JHA3ocRTP-1Izv-vfPT05x
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/21 10:48 AM, Pierre Morel wrote:
> We check the PTF instruction.
> 
> - We do not expect to support vertical polarization.
> 
> - We do not expect the Modified Topology Change Report to be
> pending or not at the moment the first PTF instruction with
> PTF_CHECK function code is done as some code already did run
> a polarization change may have occur.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |  1 +
>  s390x/topology.c    | 87 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  3 ++
>  3 files changed, 91 insertions(+)
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
> index 00000000..4146189a
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,87 @@
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
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));

We don't actually need that I made a mistake in stsi_get_fc().
I'll comment in the other patch.

> +int machine_level;
> +int mnest;
> +
> +#define PTF_HORIZONTAL	0
> +#define PTF_VERTICAL	1

PTF_REQ_*

> +#define PTF_CHECK	2> +
> +#define PTF_ERR_NO_REASON	0
> +#define PTF_ERR_ALRDY_POLARIZED	1
> +#define PTF_ERR_IN_PROGRESS	2
> +
> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"       .insn   rre,0xb9a20000,%1,%1\n"
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
> +	ptf(PTF_CHECK, &rc);
> +	cc = ptf(PTF_CHECK, &rc)> +	report(cc == 0, "PTF check clear");

Please leave a \n after a report for readability.

> +	cc = ptf(PTF_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "PTF horizontal already configured");
> +	cc = ptf(PTF_VERTICAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
> +	       "PTF vertical non possible");

I've yet to look into your KVM/qemu code so I don't really understand
what you're testing here and why we can expect to get those results.

Maybe add a comment?
Also what will happen if we start this test under LPAR or z/VM, will it
fail?

> +
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	report_prefix_push("stsi");

Where did you copy that test from? :-)

> +
> +	if (!test_facility(11)) {
> +		report_skip("Topology facility not present");
> +		goto end;
> +	}
> +
> +	report_info("Machine level %ld", stsi_get_fc(pagebuf));
> +
> +	test_ptf();
> +end:

report_prefix_pop is missing here

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


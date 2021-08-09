Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EC63E43CD
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhHIKWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:22:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234389AbhHIKWn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:22:43 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A9SmD128649;
        Mon, 9 Aug 2021 06:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EFE00oIa9fkoLnQ2Pu08DXN76EOIm8nTIjNvI3QaPrs=;
 b=tNFiAmnBaRPm/Mptyhl3c8JiJnI+t8R+IWQmL1t1/OK3US/KJv45o/Fbypdsbof5oxXv
 enwzoFJxaKFN6afUSVgLOSfzH/O03nL+ocwr8GtrtXsXqZBDJRmuGSA52SG+bxjGTojF
 icYtFaipe1/sFP0mMin4iKqgyaCUXTvaNyIPhlY/4sYbtPhlD76K49iv1aki2Di5NuO0
 R6uhjsYqcjdccxXUiMJtsZb1M4hvDmbtAD++v6kgnGxYWOCC2r/cY+MTzMMa8R19pQfO
 k9HutTkqQTddLd73WIg69VPxGaXzXUySwxrbrK/3PzcdQGnenIlyFnN2eIe1nNsKqCti Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa78t3y15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:23 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179ABscs136084;
        Mon, 9 Aug 2021 06:22:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa78t3y0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179AD0PP019941;
        Mon, 9 Aug 2021 10:22:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8usxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:22:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179AMG6t42598780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:22:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D063B5204F;
        Mon,  9 Aug 2021 10:22:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.223])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 89F035206B;
        Mon,  9 Aug 2021 10:22:16 +0000 (GMT)
Date:   Mon, 9 Aug 2021 12:03:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: topology: check the
 Perform Topology Function
Message-ID: <20210809120306.6bd78354@p-imbrenda>
In-Reply-To: <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
        <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SOi6TbDdMF2jM72qPLc-ruFhNjPbt5ht
X-Proofpoint-GUID: Ro50Sz1HTOqnO-Del3qlgPaHibZ7Phnc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Aug 2021 10:48:53 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

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
>  s390x/topology.c    | 87
> +++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> 3 ++ 3 files changed, 91 insertions(+)
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
> +static uint8_t pagebuf[PAGE_SIZE * 2]
> __attribute__((aligned(PAGE_SIZE * 2))); +int machine_level;
> +int mnest;
> +
> +#define PTF_HORIZONTAL	0
> +#define PTF_VERTICAL	1
> +#define PTF_CHECK	2
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
> +		"       .insn   rre,0xb9a20000,%1,%1\n"

I know you copied this from the kernel, but the second argument is not
really there according to the PoP, so maybe it's better to have this
instead?

	.insn   rre,0xb9a20000,%1,0\n

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
> +	cc = ptf(PTF_CHECK, &rc);
> +	report(cc == 0, "PTF check clear");
> +	cc = ptf(PTF_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "PTF horizontal already configured");
> +	cc = ptf(PTF_VERTICAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
> +	       "PTF vertical non possible");

*not possible

> +
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	report_prefix_push("stsi");

should this really be "stsi" ?

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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6300648AE31
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 14:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240328AbiAKNLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 08:11:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239945AbiAKNLb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 08:11:31 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BAwF2n022698;
        Tue, 11 Jan 2022 13:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=f4clDWAT1VSI/K9jIEfWPV92G+ixpChzi+pyeFaJE/A=;
 b=W5AFqqw8i1J1WSdTXhewE4zFkI1XbXqdtaqmjmO2UojwRMM/nEPl5pDvyI75Xb7hYXcc
 VsbCnXE11Xb447Bzre3c7ljD5gEkue0EaFy7mmEOqOT4ASv2F/fOEHDiy8c63Kq/TU04
 4E1UdJdsqaCjIMt2qLd9PoXHsjXNSXYib19mWNo5FnVkvhrKFpxOsyG3SehAGHj9s8Fc
 +wCQyq2URGfS1xmvwq6h/DejNb3XzO43J8I5q6f7Rm6NVVVfQ1oaCbBx33xicIjMpogV
 mehQ4gvtlLGcpeLNAM5re8v/aMl57UOe00GjqULeWniIG7on1RCO5icIMELEurAiQZSQ 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh8m12q7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:30 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BCrUDU014110;
        Tue, 11 Jan 2022 13:11:30 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh8m12q7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BD7tNu007392;
        Tue, 11 Jan 2022 13:11:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhj13nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BDBDO447383022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 13:11:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C29D011C06E;
        Tue, 11 Jan 2022 13:11:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6149E11C075;
        Tue, 11 Jan 2022 13:11:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.78])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 13:11:13 +0000 (GMT)
Date:   Tue, 11 Jan 2022 12:25:26 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: topology: Check the
 Perform Topology Function
Message-ID: <20220111122526.60e31b38@p-imbrenda>
In-Reply-To: <20220110133755.22238-4-pmorel@linux.ibm.com>
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
        <20220110133755.22238-4-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x9OJfX1dCRwRF6P66XAQo-tmPHtH1gRE
X-Proofpoint-ORIG-GUID: _hgYtXjAn5fj3T0c_KUMwrMWpLhCfFV6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jan 2022 14:37:54 +0100
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
>  s390x/Makefile      |   1 +
>  s390x/topology.c    | 115 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 ++
>  3 files changed, 119 insertions(+)
>  create mode 100644 s390x/topology.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 1e567c11..fa21a882 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
>  tests += $(TEST_DIR)/firq.elf
> +tests += $(TEST_DIR)/topology.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 00000000..a227555e
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,115 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright (c) 2021 IBM Corp

Copyright IBM Corp. 2021

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
> +#include <s390x/vm.h>
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
> +	report(cc == 0, "PTF check should clear topology report");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("Topology polarisation check");
> +	/*
> +	 * We can not assume the state of the polarization for
> +	 * any Virtual Machine but KVM.
> +	 * Let's skip the polarisation tests for other VMs.
> +	 */
> +	if (!vm_is_kvm()) {
> +		report_skip("Topology polarisation check is done for KVM only");
> +		goto end;
> +	}
> +
> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "KVM always provides horizontal polarization");
> +
> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
> +	       "KVM doesn't support vertical polarization.");
> +
> +end:
> +	report_prefix_pop();
> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] = {
> +	{ "PTF", test_ptf},
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("CPU Topology");
> +
> +	if (!test_facility(11)) {
> +		report_skip("Topology facility not present");
> +		goto end;
> +	}
> +
> +	report_info("Machine level %ld", stsi_get_fc());
> +
> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +end:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 054560c2..e2d3e6a5 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -122,3 +122,6 @@ extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -devi
>  file = firq.elf
>  timeout = 20
>  extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
> +
> +[topology]
> +file = topology.elf


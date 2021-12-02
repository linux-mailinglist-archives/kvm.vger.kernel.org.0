Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A24663EC
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358008AbhLBMtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:49:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1347388AbhLBMtT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 07:49:19 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2C0RNh012031;
        Thu, 2 Dec 2021 12:45:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GgPk0wOzh9cnRT2AV+KNgN1eD7g0Vm02C+ygvejE3wc=;
 b=EI/Iga9MORZgUho48oHlV+7ksuYJCtDH3twfFN0Kl2XSCYRZtkJZd4m9BbojmIreGJi/
 DR48cCszx7Dc1kwWgwEQHbCD/mOQuQXBBCjicUHQayD0QVKYouLWY4VGm78dqKFIrQda
 wyH+8szeEFxbuft8LNEuF9j2CXIA5mhCtCx5nFpMYC98/MqlhVIg9CoFLUWK7UE6CyUc
 YdQ2qlFeCU7T0XLtVxMHM7aul+b7JtXMIPY7BvRLw9wZJGFZgIqfpACbHplODBXvIUQG
 JVw1xNs2Wy9N2voaWjbMKGAHcwkFTfx99Z6zaVp2OmpdEiirwbZ0MyQm+wnjRHbfvfB8 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpuvgbats-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:45:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2CaDk8023852;
        Thu, 2 Dec 2021 12:45:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpuvgbat5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:45:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2CdZuA025220;
        Thu, 2 Dec 2021 12:45:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckcaa487k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 12:45:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2CjobF25297384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 12:45:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 827174C05C;
        Thu,  2 Dec 2021 12:45:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 076C94C04A;
        Thu,  2 Dec 2021 12:45:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.140])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 12:45:49 +0000 (GMT)
Date:   Thu, 2 Dec 2021 13:45:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
Message-ID: <20211202134548.24aa2e4d@p-imbrenda>
In-Reply-To: <20211202123553.96412-3-david@redhat.com>
References: <20211202123553.96412-1-david@redhat.com>
        <20211202123553.96412-3-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A2udH9L4ZikQJURhvpJDZLy27FVaF3tk
X-Proofpoint-GUID: Algwm3Y_AYs9eNoyxq8HgczZ0L78N_Ur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_07,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Dec 2021 13:35:53 +0100
David Hildenbrand <david@redhat.com> wrote:

> We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
> kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
> stuck forever because a CPU in the wait state would not get woken up.
> 
> The issue can be triggered when CPUs are created in a nonlinear fashion,
> such that the CPU address ("core-id") and the KVM cpu id don't match.
> 
> So let's start with a floating interrupt test that will trigger a
> floating interrupt (via SCLP) to be delivered to a CPU in the wait state.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sclp.c    |  11 ++--
>  lib/s390x/sclp.h    |   1 +
>  s390x/Makefile      |   1 +
>  s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  10 ++++
>  5 files changed, 142 insertions(+), 3 deletions(-)
>  create mode 100644 s390x/firq.c
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 0272249..33985eb 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -60,9 +60,7 @@ void sclp_setup_int(void)
>  void sclp_handle_ext(void)
>  {
>  	ctl_clear_bit(0, CTL0_SERVICE_SIGNAL);
> -	spin_lock(&sclp_lock);
> -	sclp_busy = false;
> -	spin_unlock(&sclp_lock);
> +	sclp_clear_busy();
>  }
>  
>  void sclp_wait_busy(void)
> @@ -89,6 +87,13 @@ void sclp_mark_busy(void)
>  	}
>  }
>  
> +void sclp_clear_busy(void)
> +{
> +	spin_lock(&sclp_lock);
> +	sclp_busy = false;
> +	spin_unlock(&sclp_lock);
> +}
> +
>  static void sclp_read_scp_info(ReadInfo *ri, int length)
>  {
>  	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 61e9cf5..fead007 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -318,6 +318,7 @@ void sclp_setup_int(void);
>  void sclp_handle_ext(void);
>  void sclp_wait_busy(void);
>  void sclp_mark_busy(void);
> +void sclp_clear_busy(void);
>  void sclp_console_setup(void);
>  void sclp_print(const char *str);
>  void sclp_read_info(void);
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f95f2e6..1e567c1 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
> +tests += $(TEST_DIR)/firq.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/firq.c b/s390x/firq.c
> new file mode 100644
> index 0000000..1f87718
> --- /dev/null
> +++ b/s390x/firq.c
> @@ -0,0 +1,122 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Floating interrupt tests.
> + *
> + * Copyright 2021 Red Hat Inc
> + *
> + * Authors:
> + *    David Hildenbrand <david@redhat.com>
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm-generic/barrier.h>
> +
> +#include <sclp.h>
> +#include <smp.h>
> +#include <alloc_page.h>
> +
> +static void wait_for_sclp_int(void)
> +{
> +	/* Enable SCLP interrupts on this CPU only. */
> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
> +
> +	/* Enable external interrupts and go to the wait state. */
> +	wait_for_interrupt(PSW_MASK_EXT);
> +}
> +
> +/*
> + * Some KVM versions might mix CPUs when looking for a floating IRQ target,
> + * accidentially detecting a stopped CPU as waiting and resulting in the actually
> + * waiting CPU not getting woken up for the interrupt.
> + */
> +static void test_wait_state_delivery(void)
> +{
> +	struct psw psw;
> +	SCCBHeader *h;
> +	int ret;
> +
> +	report_prefix_push("wait state delivery");
> +
> +	if (smp_query_num_cpus() < 3) {
> +		report_skip("need at least 3 CPUs for this test");
> +		goto out;
> +	}
> +
> +	if (stap()) {
> +		report_skip("need to start on CPU #0");
> +		goto out;
> +	}
> +
> +	/*
> +	 * We want CPU #2 to be stopped. This should be the case at this
> +	 * point, however, we want to sense if it even exists as well.
> +	 */
> +	ret = smp_cpu_stop(2);
> +	if (ret) {
> +		report_skip("CPU #2 not found");
> +		goto out;
> +	}
> +
> +	/*
> +	 * We're going to perform an SCLP service call but expect
> +	 * the interrupt on CPU #1 while it is in the wait state.
> +	 */
> +	sclp_mark_busy();
> +
> +	/* Start CPU #1 and let it wait for the interrupt. */
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)wait_for_sclp_int;
> +	ret = smp_cpu_setup(1, psw);
> +	if (ret) {
> +		sclp_clear_busy();
> +		report_skip("cpu #1 not found");
> +		goto out;
> +	}
> +
> +	/*
> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
> +	 * wait state.
> +	 *
> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
> +	 * until not reported as running -- after all, our SCLP processing
> +	 * will take some time as well and smp_cpu_setup() returns when we're
> +	 * either already in wait_for_sclp_int() or just about to execute it.
> +	 */
> +	while(smp_sense_running_status(1));
> +
> +	h = alloc_page();
> +	h->length = 4096;
> +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
> +	if (ret) {
> +		sclp_clear_busy();
> +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
> +		goto out_destroy;
> +	}
> +
> +	/*
> +	 * Wait until the interrupt gets delivered on CPU #1, marking the
> +	 * SCLP requests as done.
> +	 */
> +	sclp_wait_busy();
> +
> +	report(true, "sclp interrupt delivered");
> +
> +out_destroy:
> +	free_page(h);
> +	smp_cpu_destroy(1);
> +out:
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("firq");
> +
> +	test_wait_state_delivery();
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3b454b7..054560c 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -112,3 +112,13 @@ file = mvpg-sie.elf
>  
>  [spec_ex-sie]
>  file = spec_ex-sie.elf
> +
> +[firq-linear-cpu-ids]
> +file = firq.elf
> +timeout = 20
> +extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
> +
> +[firq-nonlinear-cpu-ids]
> +file = firq.elf
> +timeout = 20
> +extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1


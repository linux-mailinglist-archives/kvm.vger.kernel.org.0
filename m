Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC92E4661E9
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346214AbhLBLFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:05:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1357113AbhLBLEy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:04:54 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2ApAq6023077;
        Thu, 2 Dec 2021 11:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UDu1/KqloCRJmOmqgG+HzlAXgcg3ZXFexKu2bFjTSYc=;
 b=n3rXlkCIiJf+f9NsO27ofEqSAK6EC7T0mcZHyEYsY4jG4rd/9WZ7QZl4HNXtAw9wLKyR
 r9p7AJkwODHrLETyi731MKsHgRdUniBHzPWgU3bOnEgDOPVbr3hF8uRNP3Kutyk86gPt
 IEJGvaTMSOkjWg+grGJ8npeOGAc4aeZrs8thravAsSateFFIegg6wUZk6wS/A2RSUvJT
 F0F1o3D5LlJOWHM/qzhW7Yen3BIcn+dEGtjg7IsZX/C8S9BhfeVxRvK5Qx7GE+Qxyi7A
 pPtR4HUY7C0RgIvDgguYx98lYPfeLx1jAKEimcas7KsnjqKNSqJ75hUSJaFG7jI0heAq cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpvrpg5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:29 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2ArhME000798;
        Thu, 2 Dec 2021 11:01:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cpvrpg5x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2AxWxt009048;
        Thu, 2 Dec 2021 11:01:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3cncgmqnsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 11:01:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2ArrmM25035042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 10:53:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 067C442049;
        Thu,  2 Dec 2021 11:01:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F60342059;
        Thu,  2 Dec 2021 11:01:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 11:01:22 +0000 (GMT)
Date:   Thu, 2 Dec 2021 12:01:13 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt
 test
Message-ID: <20211202120113.2dd279a8@p-imbrenda>
In-Reply-To: <20211202095843.41162-3-david@redhat.com>
References: <20211202095843.41162-1-david@redhat.com>
        <20211202095843.41162-3-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H4g7Ms1_1azqFUauAANU0KH9Luk5vfDh
X-Proofpoint-ORIG-GUID: FBo99-HsDiT75D8xLT2IhbS6O467eCcS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_05,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Dec 2021 10:58:43 +0100
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
> ---
>  s390x/Makefile      |   1 +
>  s390x/firq.c        | 141 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  10 ++++
>  3 files changed, 152 insertions(+)
>  create mode 100644 s390x/firq.c
> 
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
> index 0000000..3e60681
> --- /dev/null
> +++ b/s390x/firq.c
> @@ -0,0 +1,141 @@
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
> +static int testflag = 0;
> +
> +static void wait_for_flag(void)
> +{
> +	while (!testflag)
> +		mb();
> +}
> +
> +static void set_flag(int val)
> +{
> +	mb();
> +	testflag = val;
> +	mb();
> +}
> +
> +static void wait_for_sclp_int(void)
> +{
> +	/* Enable SCLP interrupts on this CPU only. */
> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
> +
> +	set_flag(1);

why not just WRITE_ONCE/READ_ONCE?

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

this means that now no SCLP command can happen as long as the flag
stays set....

> +	set_flag(0);
> +
> +	/* Start CPU #1 and let it wait for the interrupt. */
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)wait_for_sclp_int;
> +	ret = smp_cpu_setup(1, psw);
> +	if (ret) {
> +		report_skip("cpu #1 not found");

...which means that this will hang, and so will all the other report*
functions. maybe you should manually unset the flag before calling the
various report* functions.

> +		goto out;
> +	}
> +
> +	/* Wait until the CPU #1 at least enabled SCLP interrupts. */
> +	wait_for_flag();
> +
> +	/*
> +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
> +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
> +	 * wait state.
> +	 *
> +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
> +	 * until not reported as running -- after all, our SCLP processing
> +	 * will take some time as well and make races very rare.
> +	 */
> +	while(smp_sense_running_status(1));
> +
> +	h = alloc_page();

do you really need to dynamically allocate one page?
is there a reason for not using a simple static buffer? (which you can
have aligned and statically initialized)

> +	memset(h, 0, sizeof(*h));

otherwise, if you really want to allocate the memory, get rid of the
memset; the allocator always returns zeroed memory (unless you
explicitly ask not to by using flags)

> +	h->length = 4096;
> +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
> +	if (ret) {
> +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
> +		goto out_destroy;
> +	}
> +
> +	/*
> +	 * Wait until the interrupt gets delivered on CPU #1, marking the

why do you expect the interrupt to be delivered on CPU1? could it not
be delivered on CPU0?

> +	 * SCLP requests as done.
> +	 */
> +	sclp_wait_busy();

this is logically not wrong (and should stay, because it makes clear
what you are trying to do), but strictly speaking it's not needed since
the report below will hang as long as the SCLP busy flag is set. 

> +
> +	report(true, "firq delivered");
> +
> +out_destroy:
> +	smp_cpu_destroy(1);
> +	free_page(h);
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D182D467613
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 12:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380291AbhLCLWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 06:22:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243475AbhLCLWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 06:22:04 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3ALcUc031462;
        Fri, 3 Dec 2021 11:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tgtYEOBhSMwyMTLH+vQ2urChOw3c2eGXkNV2uYMpZ8s=;
 b=rpN2cjYme4uxDnLeHU2DSUnt/tRfIRRfvJ/lJca3OPzaDeG4j0gdvUv2b3IkW7ApjVVJ
 eFCGNmD1M27wa24XD/PLgroozd0ZwOVnE6jqSafmLQDuhiX4f3cF94jUOOBpSInpY+gi
 4DiC4kRKXLmI0aYNJw+BR+njQr8hKV4VEpaB+EJZs/o1k0jzFdjemNMJb4xEqZfem5WK
 VnnCXGrvjoc5eP23XG797Yq5DuLFg1681LG4TM3/XLUky+lWnjOBEOjJ6TIpIuN96rKh
 HR+AX4snYweRU6m/fffjLR+dHD1qjQ5SO0A/dnYB3D2jKCTKjjRT9GJSuIOkylXg3OGH rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqhdv0yxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:18:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3ALolo031817;
        Fri, 3 Dec 2021 11:18:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqhdv0ywx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:18:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3BERDf016409;
        Fri, 3 Dec 2021 11:18:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkw6x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:18:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3BAp6U28246450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 11:10:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E69435205A;
        Fri,  3 Dec 2021 11:18:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6D0B052050;
        Fri,  3 Dec 2021 11:18:22 +0000 (GMT)
Date:   Fri, 3 Dec 2021 12:18:19 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
Message-ID: <20211203121819.145696b0@p-imbrenda>
In-Reply-To: <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
References: <20211202123553.96412-1-david@redhat.com>
        <20211202123553.96412-3-david@redhat.com>
        <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vjWe-BdYXqhGHEb3WwT3aJWa9XSR2c9Q
X-Proofpoint-ORIG-GUID: 9op0JyJO2cYf5XK5svrmf9V31vr1oD3B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_05,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Dec 2021 11:55:31 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 02/12/2021 13.35, David Hildenbrand wrote:
> > We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
> > kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
> > stuck forever because a CPU in the wait state would not get woken up.
> > 
> > The issue can be triggered when CPUs are created in a nonlinear fashion,
> > such that the CPU address ("core-id") and the KVM cpu id don't match.
> > 
> > So let's start with a floating interrupt test that will trigger a
> > floating interrupt (via SCLP) to be delivered to a CPU in the wait state.  
> 
> Thank you very much for tackling this! Some remarks below...
> 
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   lib/s390x/sclp.c    |  11 ++--
> >   lib/s390x/sclp.h    |   1 +
> >   s390x/Makefile      |   1 +
> >   s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
> >   s390x/unittests.cfg |  10 ++++
> >   5 files changed, 142 insertions(+), 3 deletions(-)
> >   create mode 100644 s390x/firq.c
> > 
> > diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> > index 0272249..33985eb 100644
> > --- a/lib/s390x/sclp.c
> > +++ b/lib/s390x/sclp.c
> > @@ -60,9 +60,7 @@ void sclp_setup_int(void)
> >   void sclp_handle_ext(void)
> >   {
> >   	ctl_clear_bit(0, CTL0_SERVICE_SIGNAL);
> > -	spin_lock(&sclp_lock);
> > -	sclp_busy = false;
> > -	spin_unlock(&sclp_lock);
> > +	sclp_clear_busy();
> >   }
> >   
> >   void sclp_wait_busy(void)
> > @@ -89,6 +87,13 @@ void sclp_mark_busy(void)
> >   	}
> >   }
> >   
> > +void sclp_clear_busy(void)
> > +{
> > +	spin_lock(&sclp_lock);
> > +	sclp_busy = false;
> > +	spin_unlock(&sclp_lock);
> > +}
> > +
> >   static void sclp_read_scp_info(ReadInfo *ri, int length)
> >   {
> >   	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
> > diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> > index 61e9cf5..fead007 100644
> > --- a/lib/s390x/sclp.h
> > +++ b/lib/s390x/sclp.h
> > @@ -318,6 +318,7 @@ void sclp_setup_int(void);
> >   void sclp_handle_ext(void);
> >   void sclp_wait_busy(void);
> >   void sclp_mark_busy(void);
> > +void sclp_clear_busy(void);
> >   void sclp_console_setup(void);
> >   void sclp_print(const char *str);
> >   void sclp_read_info(void);
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index f95f2e6..1e567c1 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -25,6 +25,7 @@ tests += $(TEST_DIR)/uv-host.elf
> >   tests += $(TEST_DIR)/edat.elf
> >   tests += $(TEST_DIR)/mvpg-sie.elf
> >   tests += $(TEST_DIR)/spec_ex-sie.elf
> > +tests += $(TEST_DIR)/firq.elf
> >   
> >   tests_binary = $(patsubst %.elf,%.bin,$(tests))
> >   ifneq ($(HOST_KEY_DOCUMENT),)
> > diff --git a/s390x/firq.c b/s390x/firq.c
> > new file mode 100644
> > index 0000000..1f87718
> > --- /dev/null
> > +++ b/s390x/firq.c
> > @@ -0,0 +1,122 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Floating interrupt tests.
> > + *
> > + * Copyright 2021 Red Hat Inc
> > + *
> > + * Authors:
> > + *    David Hildenbrand <david@redhat.com>
> > + */
> > +#include <libcflat.h>
> > +#include <asm/asm-offsets.h>
> > +#include <asm/interrupt.h>
> > +#include <asm/page.h>
> > +#include <asm-generic/barrier.h>
> > +
> > +#include <sclp.h>
> > +#include <smp.h>
> > +#include <alloc_page.h>
> > +
> > +static void wait_for_sclp_int(void)
> > +{
> > +	/* Enable SCLP interrupts on this CPU only. */
> > +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
> > +
> > +	/* Enable external interrupts and go to the wait state. */
> > +	wait_for_interrupt(PSW_MASK_EXT);
> > +}  
> 
> What happens if the CPU got an interrupt? Should there be a "while (true)" 

it should not get any interrupts, but if it does anyway...

> at the end of the function to avoid that the CPU ends up crashing at the end 
> of the function?

... we have this in smp_cpu_setup_state, after the call to the actual
function body:

/* If the function returns, just loop here */
0:      j       0

so if the function returns, it will hang in there anyway

>
> > +/*
> > + * Some KVM versions might mix CPUs when looking for a floating IRQ target,
> > + * accidentially detecting a stopped CPU as waiting and resulting in the actually
> > + * waiting CPU not getting woken up for the interrupt.
> > + */
> > +static void test_wait_state_delivery(void)
> > +{
> > +	struct psw psw;
> > +	SCCBHeader *h;
> > +	int ret;
> > +
> > +	report_prefix_push("wait state delivery");
> > +
> > +	if (smp_query_num_cpus() < 3) {
> > +		report_skip("need at least 3 CPUs for this test");
> > +		goto out;
> > +	}
> > +
> > +	if (stap()) {
> > +		report_skip("need to start on CPU #0");
> > +		goto out;
> > +	}  
> 
> I think I'd rather turn this into an assert() instead ... no strong opinion 
> about it, though.

I agree, including the part about no strong opinions (which is why I
did not comment on it before)

> 
> > +
> > +	/*
> > +	 * We want CPU #2 to be stopped. This should be the case at this
> > +	 * point, however, we want to sense if it even exists as well.
> > +	 */
> > +	ret = smp_cpu_stop(2);
> > +	if (ret) {
> > +		report_skip("CPU #2 not found");  
> 
> Since you already queried for the availablity of at least 3 CPUs above, I 
> think you could turn this into a report_fail() instead?

either that or an assert, but again, no strong opinions

> 
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * We're going to perform an SCLP service call but expect
> > +	 * the interrupt on CPU #1 while it is in the wait state.
> > +	 */
> > +	sclp_mark_busy();
> > +
> > +	/* Start CPU #1 and let it wait for the interrupt. */
> > +	psw.mask = extract_psw_mask();
> > +	psw.addr = (unsigned long)wait_for_sclp_int;
> > +	ret = smp_cpu_setup(1, psw);
> > +	if (ret) {
> > +		sclp_clear_busy();
> > +		report_skip("cpu #1 not found");
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * We'd have to jump trough some hoops to sense e.g., via SIGP
> > +	 * CONDITIONAL EMERGENCY SIGNAL if CPU #1 is already in the
> > +	 * wait state.
> > +	 *
> > +	 * Although not completely reliable, use SIGP SENSE RUNNING STATUS
> > +	 * until not reported as running -- after all, our SCLP processing
> > +	 * will take some time as well and smp_cpu_setup() returns when we're
> > +	 * either already in wait_for_sclp_int() or just about to execute it.
> > +	 */
> > +	while(smp_sense_running_status(1));
> > +
> > +	h = alloc_page();
> > +	h->length = 4096;
> > +	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
> > +	if (ret) {
> > +		sclp_clear_busy();
> > +		report_fail("SCLP_CMDW_READ_CPU_INFO failed");
> > +		goto out_destroy;
> > +	}
> > +
> > +	/*
> > +	 * Wait until the interrupt gets delivered on CPU #1, marking the
> > +	 * SCLP requests as done.
> > +	 */
> > +	sclp_wait_busy();
> > +
> > +	report(true, "sclp interrupt delivered");
> > +
> > +out_destroy:
> > +	free_page(h);
> > +	smp_cpu_destroy(1);
> > +out:
> > +	report_prefix_pop();
> > +}  
> 
> Anyway, code looks fine for me, either with my comments addressed or not:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A59EE4C6C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504807AbfJYNix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 09:38:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502112AbfJYNix (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 09:38:53 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PDclCK105390
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:38:52 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv1tygrek-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:38:48 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 25 Oct 2019 14:38:39 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 14:38:36 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PDcZhv43385128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 13:38:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B193A4054;
        Fri, 25 Oct 2019 13:38:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A668A405C;
        Fri, 25 Oct 2019 13:38:35 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 13:38:34 +0000 (GMT)
Date:   Thu, 24 Oct 2019 17:40:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 5/5] s390x: SCLP unit test
In-Reply-To: <1189848719.8181299.1571834913066.JavaMail.zimbra@redhat.com>
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
        <1571741584-17621-6-git-send-email-imbrenda@linux.ibm.com>
        <1189848719.8181299.1571834913066.JavaMail.zimbra@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102513-4275-0000-0000-000003778C27
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102513-4276-0000-0000-0000388ABA2B
Message-Id: <20191024174048.2f0ab8d7@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Oct 2019 08:48:33 -0400 (EDT)
Thomas Huth <thuth@redhat.com> wrote:

> ----- Original Message -----
> > From: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
> > Sent: Tuesday, October 22, 2019 12:53:04 PM
> > 
> > SCLP unit test. Testing the following:
> > 
> > * Correctly ignoring instruction bits that should be ignored
> > * Privileged instruction check
> > * Check for addressing exceptions
> > * Specification exceptions:
> >   - SCCB size less than 8
> >   - SCCB unaligned
> >   - SCCB overlaps prefix or lowcore
> >   - SCCB address higher than 2GB
> > * Return codes for
> >   - Invalid command
> >   - SCCB too short (but at least 8)
> >   - SCCB page boundary violation
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  s390x/Makefile      |   1 +
> >  s390x/sclp.c        | 373
> >  ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  s390x/unittests.cfg |   3 +
> >  3 files changed, 377 insertions(+)
> >  create mode 100644 s390x/sclp.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 3744372..ddb4b48 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
> >  tests += $(TEST_DIR)/stsi.elf
> >  tests += $(TEST_DIR)/skrf.elf
> >  tests += $(TEST_DIR)/smp.elf
> > +tests += $(TEST_DIR)/sclp.elf
> >  tests_binary = $(patsubst %.elf,%.bin,$(tests))
> >  
> >  all: directories test_cases test_cases_binary
> > diff --git a/s390x/sclp.c b/s390x/sclp.c
> > new file mode 100644
> > index 0000000..d7a9212
> > --- /dev/null
> > +++ b/s390x/sclp.c
> > @@ -0,0 +1,373 @@
> > +/*
> > + * Store System Information tests  
> 
> Copy-n-paste from stsi.c ?

Oops

> 
> > + * Copyright (c) 2019 IBM Corp
> > + *
> > + * Authors:
> > + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + *
> > + * This code is free software; you can redistribute it and/or
> > modify it
> > + * under the terms of the GNU General Public License version 2.
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <asm/page.h>
> > +#include <asm/asm-offsets.h>
> > +#include <asm/interrupt.h>
> > +#include <sclp.h>  
> [...]
> > +static int test_one_run(uint32_t cmd, uint64_t addr, uint16_t len,
> > +			uint16_t clear, uint64_t exp_pgm, uint16_t
> > exp_rc) +{
> > +	char sccb[4096];
> > +	void *p = sccb;
> > +
> > +	if (!len && !clear)
> > +		p = NULL;
> > +	else
> > +		memset(sccb, 0, sizeof(sccb));
> > +	((SCCBHeader *)sccb)->length = len;
> > +	if (clear && (clear < 8))  
> 
> Please remove the parentheses around "clear < 8".

I usually prefer to have more parentheses than necessary
than fewer, but I'll fix it

> 
> > +		clear = 8;
> > +	return test_one_sccb(cmd, addr, clear, p, exp_pgm, exp_rc);
> > +}
> > +
> > +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
> > +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
> > +#define PGM_BIT_PRIV	(1ULL <<
> > PGM_INT_CODE_PRIVILEGED_OPERATION) +
> > +#define PGBUF	((uintptr_t)pagebuf)
> > +#define VALID	(valid_sclp_code)
> > +
> > +static void test_sccb_too_short(void)
> > +{
> > +	int cx;
> > +
> > +	for (cx = 0; cx < 8; cx++)
> > +		if (!test_one_run(VALID, PGBUF, cx, 8,
> > PGM_BIT_SPEC, 0))
> > +			break;
> > +
> > +	report("SCCB too short", cx == 8);
> > +}
> > +
> > +static void test_sccb_unaligned(void)
> > +{
> > +	int cx;
> > +
> > +	for (cx = 1; cx < 8; cx++)
> > +		if (!test_one_run(VALID, cx + PGBUF, 8, 8,
> > PGM_BIT_SPEC, 0))
> > +			break;
> > +	report("SCCB unaligned", cx == 8);
> > +}
> > +
> > +static void test_sccb_prefix(void)
> > +{
> > +	uint32_t prefix, new_prefix;
> > +	int cx;
> > +
> > +	for (cx = 0; cx < 8192; cx += 8)
> > +		if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_SPEC,
> > 0))
> > +			break;
> > +	report("SCCB low pages", cx == 8192);
> > +
> > +	new_prefix = (uint32_t)(intptr_t)prefix_buf;
> > +	memcpy(prefix_buf, 0, 8192);
> > +	asm volatile("stpx %0": "+Q"(prefix));  
> 
> Isn't "=Q" sufficient enough here?

Ooops. think I copypasted this from somewhere else. Will fix.

> 
> > +	asm volatile("spx %0": "+Q"(new_prefix));  
> 
> Shouldn't that be just an input parameter instead? ... and maybe also
> better add "memory" to the clobber list, since the memory layout has
> changed.

same

> 
> > +	for (cx = 0; cx < 8192; cx += 8)
> > +		if (!test_one_run(VALID, new_prefix + cx, 8, 8,
> > PGM_BIT_SPEC, 0))
> > +			break;
> > +	report("SCCB prefix pages", cx == 8192);
> > +
> > +	memcpy(prefix_buf, 0, 8192);
> > +	asm volatile("spx %0": "+Q"(prefix));  
> 
> dito?

same

> 
> > +}  
> 
>  Thomas
> 


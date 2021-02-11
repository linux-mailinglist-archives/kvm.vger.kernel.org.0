Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388C3318A63
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhBKMWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 07:22:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231715AbhBKMTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 07:19:52 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BC7UQ5156002;
        Thu, 11 Feb 2021 07:18:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=zVMYcFg1iHjKdXKBcJCfRbXDXSWVlJYlg7Sk6cHtzQE=;
 b=jVZUhTMzktATOv1Jp/qf6J36s9fBbiku81n+aWT53Hg50iaDwXdF/MimBldTQSV+eHz4
 NtEtSdOCPmhki0iE3bpE3ZhyPTcBy+iKaBQ/4zzOWM980MUhn4GrtUw0BcP9xM9SBNxW
 FW7UXQXcLzIka33dotvV6DTeojnDLeNkAZrjZwpAUM8cDQluHxAyB2tPBusDmCssQG3u
 yA9lSIueVm4WnVL00YR9igsVhGKmNYS88eiyPkOnu81zImfg0H2DoA1T41Ooc4bATuSj
 XMGKYWrnqYCa7CIgAvcqS+Mz2QvDHFCO7zpoSn5qlOwc49tSYQjGA0WYqLfBqR9OwVeu cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n3xhheqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:18:39 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BC7lxe157644;
        Thu, 11 Feb 2021 07:18:39 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n3xhheq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:18:39 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BCC3RQ026341;
        Thu, 11 Feb 2021 12:18:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr830f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 12:18:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BCIXV661604200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:18:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95554A4060;
        Thu, 11 Feb 2021 12:18:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 346BFA405C;
        Thu, 11 Feb 2021 12:18:33 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 12:18:33 +0000 (GMT)
Date:   Thu, 11 Feb 2021 13:18:31 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: edat test
Message-ID: <20210211131831.7a6d726d@ibm-vm>
In-Reply-To: <b069ad4e-b899-218b-a6a3-a371e4238f87@redhat.com>
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
        <20210209143835.1031617-5-imbrenda@linux.ibm.com>
        <b069ad4e-b899-218b-a6a3-a371e4238f87@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Feb 2021 12:35:49 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 09/02/2021 15.38, Claudio Imbrenda wrote:
> > Simple EDAT test.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   s390x/Makefile      |   1 +
> >   s390x/edat.c        | 238
> > ++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> >  3 + 3 files changed, 242 insertions(+)
> >   create mode 100644 s390x/edat.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 08d85c9f..fc885150 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -20,6 +20,7 @@ tests += $(TEST_DIR)/sclp.elf
> >   tests += $(TEST_DIR)/css.elf
> >   tests += $(TEST_DIR)/uv-guest.elf
> >   tests += $(TEST_DIR)/sie.elf
> > +tests += $(TEST_DIR)/edat.elf
> >   
> >   tests_binary = $(patsubst %.elf,%.bin,$(tests))
> >   ifneq ($(HOST_KEY_DOCUMENT),)
> > diff --git a/s390x/edat.c b/s390x/edat.c
> > new file mode 100644
> > index 00000000..504a1501
> > --- /dev/null
> > +++ b/s390x/edat.c
> > @@ -0,0 +1,238 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * EDAT test.
> > + *
> > + * Copyright (c) 2021 IBM Corp
> > + *
> > + * Authors:
> > + *	Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + */
> > +#include <libcflat.h>
> > +#include <vmalloc.h>
> > +#include <asm/facility.h>
> > +#include <asm/interrupt.h>
> > +#include <mmu.h>
> > +#include <asm/pgtable.h>
> > +#include <asm-generic/barrier.h>
> > +
> > +#define TEID_ADDR	PAGE_MASK
> > +#define TEID_AI		0x003
> > +#define TEID_M		0x004
> > +#define TEID_A		0x008
> > +#define TEID_FS		0xc00
> > +
> > +#define LC_SIZE	(2 * PAGE_SIZE)
> > +#define VIRT(x)	((void *)((unsigned long)(x) + (unsigned
> > long)mem)) +
> > +static uint8_t prefix_buf[LC_SIZE]
> > __attribute__((aligned(LC_SIZE))); +static unsigned int tmp[1024]
> > __attribute__((aligned(PAGE_SIZE))); +static void *root, *mem, *m;
> > +static struct lowcore *lc;
> > +volatile unsigned int *p;
> > +
> > +/* Expect a program interrupt, and clear the TEID */
> > +static void expect_dat_fault(void)
> > +{
> > +	expect_pgm_int();
> > +	lc->trans_exc_id = 0;
> > +}
> > +
> > +/* Check if a protection exception happened for the given address
> > */ +static bool check_pgm_prot(void *ptr)
> > +{
> > +	unsigned long teid = lc->trans_exc_id;
> > +
> > +	if (lc->pgm_int_code != PGM_INT_CODE_PROTECTION)
> > +		return 0;  
> 
> return false.
> It's a bool return type.

yeah, that looks cleaner, I'll fix it

> > +	if (~teid & TEID_M)  
> 
> I'd maybe rather write this as:
> 
>          if (!(teid & TEID_M))
> 
> ... but it's just a matter of taste.

yes, I actually had it that way in the beginning, but using ~ is
shorter and does not need parentheses

> > +		return 1;  
> 
>                  return true;
> 
> So this is for backward compatiblity with older Z systems that do not
> have the corresponding facility? Should there be a corresponding
> facility check somewhere? Or maybe add at least a comment?

no, it's not for backwards compatibility as far as I know. If I read
the documentation correctly, that bit might be zero under some
circumstances, and here I will just give up instead of checking if the
circumstances were actually correct.

> > +	return (~teid & TEID_A) &&
> > +		((teid & TEID_ADDR) == ((uint64_t)ptr &
> > PAGE_MASK)) &&
> > +		!(teid & TEID_AI);  
> 
> So you're checking for one specific type of protection exception here
> only ... please add an appropriate comment.

more or less, but I'll add a comment to explain what's going on

> > +}
> > +
> > +static void test_dat(void)
> > +{
> > +	report_prefix_push("edat off");
> > +	/* disable EDAT */
> > +	ctl_clear_bit(0, 23);
> > +
> > +	/* Check some basics */
> > +	p[0] = 42;
> > +	report(p[0] == 42, "pte, r/w");
> > +	p[0] = 0;
> > +
> > +	protect_page(m, PAGE_ENTRY_P);
> > +	expect_dat_fault();
> > +	p[0] = 42;
> > +	unprotect_page(m, PAGE_ENTRY_P);
> > +	report(!p[0] && check_pgm_prot(m), "pte, ro");
> > +
> > +	/* The FC bit should be ignored because EDAT is off */
> > +	p[0] = 42;  
> 
> I'd suggest to set p[0] = 0 here...
> 
> > +	protect_dat_entry(m, SEGMENT_ENTRY_FC, 4);  
> 
> ... and change the value to 42 after enabling the protection ...
> otherwise you don't really test the non-working write protection
> here, do you?

but this is not the write protection. here I'm setting the bit for
large pages. so first I write something, then I set the bit, then I
check if I can still read it. if not, it means that the FC bit was not
ignored (i.e. the entry was considered as a large page instead of a
normal segment table entry pointing to a page table)

Write protection for segment entries _should_ work even with EDAT off,
and that is in fact what the next test checks...

> > +	report(p[0] == 42, "pmd, fc=1, r/w");
> > +	unprotect_dat_entry(m, SEGMENT_ENTRY_FC, 4);
> > +	p[0] = 0;
> > +

... this one here:

> > +	/* Segment protection should work even with EDAT off */
> > +	protect_dat_entry(m, SEGMENT_ENTRY_P, 4);
> > +	expect_dat_fault();
> > +	p[0] = 42;
> > +	report(!p[0] && check_pgm_prot(m), "pmd, ro");
> > +	unprotect_dat_entry(m, SEGMENT_ENTRY_P, 4);
> > +
> > +	/* The FC bit should be ignored because EDAT is off*/  
> 
> Set p[0] to 0 again before enabling the protection? Or maybe use a
> different value than 42 below...?

why? we already checked that p[0] == 0, and if p[0] somehow still is
42, we are going to set it to 42 again

> > +	protect_dat_entry(m, REGION3_ENTRY_FC, 3);
> > +	p[0] = 42;

but! we should set it to 42 BEFORE setting the FC bit!
I will fix this

and maybe add a few more comments to explain what's going on

> > +	report(p[0] == 42, "pud, fc=1, r/w");
> > +	unprotect_dat_entry(m, REGION3_ENTRY_FC, 3);
> > +	p[0] = 0;
> > +
> > +	/* Region1/2/3 protection should not work, because EDAT is
> > off */
> > +	protect_dat_entry(m, REGION_ENTRY_P, 3);
> > +	p[0] = 42;
> > +	report(p[0] == 42, "pud, ro");
> > +	unprotect_dat_entry(m, REGION_ENTRY_P, 3);
> > +	p[0] = 0;
> > +
> > +	protect_dat_entry(m, REGION_ENTRY_P, 2);
> > +	p[0] = 42;
> > +	report(p[0] == 42, "p4d, ro");
> > +	unprotect_dat_entry(m, REGION_ENTRY_P, 2);
> > +	p[0] = 0;
> > +
> > +	protect_dat_entry(m, REGION_ENTRY_P, 1);
> > +	p[0] = 42;
> > +	report(p[0] == 42, "pgd, ro");
> > +	unprotect_dat_entry(m, REGION_ENTRY_P, 1);
> > +	p[0] = 0;
> > +
> > +	report_prefix_pop();
> > +}  
> 
>   Thomas
> 


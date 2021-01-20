Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6F2FD0C6
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbhATMwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728260AbhATM1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:27:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KC3FgF139680;
        Wed, 20 Jan 2021 07:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5TsowimppOBOmIql7pgZrTiR0QQjqaNl1bFViZGunQo=;
 b=Zz5bnLO1buNfpgGXsdWFYwksLoiugWfm9zj4UVjc8NQDCnO8ZlO94sTy2A5LvqK8ht3v
 VmKsjuI/5/kJpT/D3yyYy0uFpLtqKNxkm0MXnQE4ul5v7vviCkaFjfRbDo/Jg1uqavPp
 n6zpoIqXyax5Obpna7Up0rJ1CeZ7FSzWbbWpB2TfkCJDafG4f30WPaPuC+TTfA2h+tYg
 kqPPLmlKDbmDw+XiSsb/vrfkaO8RbhWWoupjM1HzREQBJu3XLBoQsSB/LONsnCpwDs5P
 EZA1zpTISxMstVkILlxnfqBom3HSLuq1Qp21Ovltir+wCsxDGZjcKAde5ERMq6nAl1Pw cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366jnb38eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:26:52 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KC4eYR149785;
        Wed, 20 Jan 2021 07:26:52 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366jnb38eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:26:52 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KCDWb6017105;
        Wed, 20 Jan 2021 12:26:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3668parjg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 12:26:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KCQlJL37290480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:26:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EE054203F;
        Wed, 20 Jan 2021 12:26:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D1E42041;
        Wed, 20 Jan 2021 12:26:46 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.4.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 12:26:46 +0000 (GMT)
Date:   Wed, 20 Jan 2021 13:25:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, drjones@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: define UV compatible I/O
 allocation
Message-ID: <20210120132539.236dd224@ibm-vm>
In-Reply-To: <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
        <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 20:52:23 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> To centralize the memory allocation for I/O we define
> the alloc_io_page/free_io_page functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/malloc_io.c | 50
> +++++++++++++++++++++++++++++++++++++++++++ lib/s390x/malloc_io.h |
> 18 ++++++++++++++++ s390x/Makefile        |  1 +
>  3 files changed, 69 insertions(+)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..2a946e0
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,50 @@
> +/*
> + * I/O page allocation
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify
> it
> + * under the terms of the GNU General Public License version 2.
> + *
> + * Using this interface provide host access to the allocated pages in
> + * case the guest is a secure guest.
> + * This is needed for I/O buffers.
> + *
> + */
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/uv.h>
> +#include <malloc_io.h>
> +#include <alloc_page.h>
> +#include <asm/facility.h>
> +
> +void *alloc_io_page(int size)
> +{
> +	void *p;
> +
> +	assert(size <= PAGE_SIZE);

I agree with Thomas here, remove size, or use it as a page count or
page order.

> +	p = alloc_pages_flags(1, AREA_DMA31);

you are allocating 2 pages here...

> +	if (!p)
> +		return NULL;
> +	memset(p, 0, PAGE_SIZE);

...and then clearing only one

but since you did not specify FLAG_DONTZERO, the page has been cleared
already by the allocator

> +
> +	if (!test_facility(158))
> +		return p;
> +
> +	if (uv_set_shared((unsigned long)p) == 0)
> +		return p;
> +
> +	free_pages(p);
> +	return NULL;
> +}
> +
> +void free_io_page(void *p)
> +{
> +	if (test_facility(158))
> +		uv_remove_shared((unsigned long)p);
> +	free_pages(p);
> +}
> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
> new file mode 100644
> index 0000000..f780191
> --- /dev/null
> +++ b/lib/s390x/malloc_io.h
> @@ -0,0 +1,18 @@
> +/*
> + * I/O allocations
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify
> it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#ifndef _S390X_MALLOC_IO_H_
> +#define _S390X_MALLOC_IO_H_
> +
> +void *alloc_io_page(int size);
> +void free_io_page(void *p);
> +
> +#endif /* _S390X_MALLOC_IO_H_ */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b079a26..4b6301c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -63,6 +63,7 @@ cflatobjs += lib/s390x/smp.o
>  cflatobjs += lib/s390x/vm.o
>  cflatobjs += lib/s390x/css_dump.o
>  cflatobjs += lib/s390x/css_lib.o
> +cflatobjs += lib/s390x/malloc_io.o
>  
>  OBJDIRS += lib/s390x
>  


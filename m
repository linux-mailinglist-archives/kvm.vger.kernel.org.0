Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719BD3004A5
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbhAVN6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 08:58:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbhAVN6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 08:58:07 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MDVk8V012486;
        Fri, 22 Jan 2021 08:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CFWYmU+Qzl5eVBCKyLpp3dG/6nrt3EIO5BJBTJuoXZo=;
 b=kPND/LPf342I1lHoXf+nouyT8Z7q0F/Mmdbd57E9JIAX/vI6x+ciKihag8f3jzkKmbpL
 dvwZagIhcd7bZjyRrbR5S4uyl0RJUUL7ukWASXbMIQbwuU4H0fMPzRK2AgUMX/4/QmbN
 DDjuFljE7ewXgWw98NYKfVqmOw5nT+v54cVPsU1T0xIOf0Id2nHs/K8tXVxLEXTBAOCP
 yxZ0qL0IqQjbL7+xB2Ak18NS+UyuQFHSlrIDkOQdXD2G0+nN+uM1vT/fv2v76/SxDS3G
 Zg1sgVyNJEY0t9V+5DbDaBB+i36RToUtdFBYvPK7/9sxRPbAN+BgMmVVcCmR4PRCYmcs tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367w68nbvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:57:25 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MDVn4x012784;
        Fri, 22 Jan 2021 08:57:25 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367w68nbux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:57:25 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDrd3V005279;
        Fri, 22 Jan 2021 13:57:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 367k0s8mks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:57:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDvKjC20906422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:57:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BB40AE053;
        Fri, 22 Jan 2021 13:57:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C21AAE051;
        Fri, 22 Jan 2021 13:57:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.26.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 13:57:19 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
Message-ID: <fcb7e165-d1a6-9d0b-a8e8-e91f39e2e0f7@linux.ibm.com>
Date:   Fri, 22 Jan 2021 14:57:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:27 PM, Pierre Morel wrote:
> To centralize the memory allocation for I/O we define
> the alloc_io_mem/free_io_mem functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> These functions allocate on a page integral granularity to
> ensure a dedicated sharing of the allocated objects.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Acked-by: Janosch Frank <frankja@de.ibm.com>

> ---
>  lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  3 files changed, 117 insertions(+)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..b01222e
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * I/O page allocation
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * Using this interface provide host access to the allocated pages in
> + * case the guest is a secure guest.

s/secure/protected/

> + * This is needed for I/O buffers.
> + *
> + */
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/uv.h>
> +#include <malloc_io.h>
> +#include <alloc_page.h>
> +#include <asm/facility.h>
> +#include <bitops.h>
> +
> +static int share_pages(void *p, int count)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < count; i++, p += PAGE_SIZE)
> +		if (uv_set_shared((unsigned long)p))
> +			break;
> +	return i;
> +}
> +
> +static void unshare_pages(void *p, int count)
> +{
> +	int i;
> +
> +	for (i = count; i > 0; i--, p += PAGE_SIZE)
> +		uv_remove_shared((unsigned long)p);
> +}
> +
> +void *alloc_io_mem(int size, int flags)
> +{
> +	int order = get_order(size >> PAGE_SHIFT);
> +	void *p;
> +	int n;
> +
> +	assert(size);
> +
> +	p = alloc_pages_flags(order, AREA_DMA31 | flags);

Pardon my lack of IO knowledge but do we also need to restrict the data
to below 2g or only the IO control structures?

Not that it currently matters much for a unit test with 256mb of memory...

> +	if (!p || !test_facility(158))
> +		return p;
> +
> +	n = share_pages(p, 1 << order);
> +	if (n == 1 << order)
> +		return p;
> +
> +	unshare_pages(p, n);
> +	free_pages(p);
> +	return NULL;
> +}
> +
> +void free_io_mem(void *p, int size)
> +{
> +	int order = get_order(size >> PAGE_SHIFT);
> +
> +	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
> +
> +	if (test_facility(158))
> +		unshare_pages(p, 1 << order);
> +	free_pages(p);
> +}
> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
> new file mode 100644
> index 0000000..cc5fad7
> --- /dev/null
> +++ b/lib/s390x/malloc_io.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * I/O allocations
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#ifndef _S390X_MALLOC_IO_H_
> +#define _S390X_MALLOC_IO_H_
> +
> +/*
> + * Allocates a page aligned page bound range of contiguous real or
> + * absolute memory in the DMA31 region large enough to contain size
> + * bytes.
> + * If Protected Virtualisation facility is present, shares the pages

s/Virtualisation/Virtualization/

But I can fix this and the nitpick above up when picking.

> + * with the host.
> + * If all the pages for the specified size cannot be reserved,
> + * the function rewinds the partial allocation and a NULL pointer
> + * is returned.
> + *
> + * @size: the minimal size allocated in byte.
> + * @flags: the flags used for the underlying page allocator.
> + *
> + * Errors:
> + *   The allocation will assert the size parameter, will fail if the
> + *   underlying page allocator fail or in the case of protected
> + *   virtualisation if the sharing of the pages fails.
> + *
> + * Returns a pointer to the first page in case of success, NULL otherwise.
> + */
> +void *alloc_io_mem(int size, int flags);
> +
> +/*
> + * Frees a previously memory space allocated by alloc_io_mem.
> + * If Protected Virtualisation facility is present, unshares the pages
> + * with the host.
> + * The address must be aligned on a page boundary otherwise an assertion
> + * breaks the program.
> + */
> +void free_io_mem(void *p, int size);
> +
> +#endif /* _S390X_MALLOC_IO_H_ */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 08d85c9..f3b0fcc 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -64,6 +64,7 @@ cflatobjs += lib/s390x/smp.o
>  cflatobjs += lib/s390x/vm.o
>  cflatobjs += lib/s390x/css_dump.o
>  cflatobjs += lib/s390x/css_lib.o
> +cflatobjs += lib/s390x/malloc_io.o
>  
>  OBJDIRS += lib/s390x
>  
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB93E2FEB6A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 14:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbhAUK3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 05:29:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728677AbhAUJrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:47:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L9Yueh028785;
        Thu, 21 Jan 2021 04:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FFq/jLUgipa+v8grVAkOFIPlWlY+P2rrLTYR8nZRqDc=;
 b=J5Ym7mU4yPBLZ5AAVzancozEjbmLEPGnfw3akmFjbT/U57NniNFcD1yfBcsBi82rtn8G
 LRqS6i+EfNGBQOeknjlQkFv8AC43fELTFG0HexIxjIllcD6UQNGf44vIKPw6WVKERDoA
 y5LGrTlBD/GD8IjMnG4Z+5Ue7ywg0OhYAGRCE0fHubNpGOStmY+W3T8S7eqs73jiPl6Q
 /cdQJenVt7aKj8QzcP3Gz6CvBAQiCQjAfYoX5GEGAavY8CH5oFuYqz/lAT4rTKXj7Iu4
 QqwhVDFOSlR2/w8O/bQFo3UaT2ma4ygSglq6TJFFGs/wdSnyXj/PGCfqJZDAsNTSSmek 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36771kgefn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:46:40 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L9ZtWd036477;
        Thu, 21 Jan 2021 04:46:39 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36771kgeep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:46:39 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9awUK006103;
        Thu, 21 Jan 2021 09:46:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwsgtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:46:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9kXu639059810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:46:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D291511C052;
        Thu, 21 Jan 2021 09:46:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5131D11C04A;
        Thu, 21 Jan 2021 09:46:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.35])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:46:33 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
Message-ID: <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:46:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 10:13 AM, Pierre Morel wrote:
> To centralize the memory allocation for I/O we define
> the alloc_io_page/free_io_page functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  MAINTAINERS           |  1 +
>  lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  4 files changed, 117 insertions(+)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 54124f6..89cb01e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>  M: David Hildenbrand <david@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
>  R: Cornelia Huck <cohuck@redhat.com>
> +R: Pierre Morel <pmorel@linux.ibm.com>

If you're ok with the amount of mails you'll get then go ahead.
But I think maintainer file changes should always be in a separate patch.

>  L: kvm@vger.kernel.org
>  L: linux-s390@vger.kernel.org
>  F: s390x/*
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..bfe8c6a
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0

I think we wanted to use:
/* SPDX-License-Identifier: GPL-2.0-or-later */

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
> +static int share_pages(void *p, int count)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < count; i++, p += PAGE_SIZE)
> +		if (uv_set_shared((unsigned long)p))
> +			return i;
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
> +void *alloc_io_pages(int size, int flags)
> +{
> +	int order = (size >> PAGE_SHIFT);
> +	void *p;
> +	int n;
> +
> +	assert(size);
> +
> +	p = alloc_pages_flags(order, AREA_DMA31 | flags);
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
> +void free_io_pages(void *p, int size)
> +{
> +	int order = size >> PAGE_SHIFT;
> +
> +	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
> +
> +	if (test_facility(158))
> +		unshare_pages(p, 1 << order);

I have a lib file in the making that will let you check UV features like
test_facility(). When that's ready I'm gonna check for unshare here.

> +	free_pages(p);
> +}
> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
> new file mode 100644
> index 0000000..494dfe9
> --- /dev/null
> +++ b/lib/s390x/malloc_io.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
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
> + * If Protected Virtualization facility is present, shares the pages
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
> +void *alloc_io_pages(int size, int flags);
> +
> +/*
> + * Frees a previously memory space allocated by alloc_io_pages.
> + * If Protected Virtualization facility is present, unshares the pages
> + * with the host.
> + * The address must be aligned on a page boundary otherwise an assertion
> + * breaks the program.
> + */
> +void free_io_pages(void *p, int size);
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
> 


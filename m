Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FB2E288D
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 19:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgLXSUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 13:20:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgLXSUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 13:20:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOI8wLW109413;
        Thu, 24 Dec 2020 18:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uRioHjes1jrALtVzK7cWfsY3nA+eDXhnqIe84jMZzI8=;
 b=kFJIT3Z9caX/M/DjDRWUECp/7XproIMp9nDDiJ/efKqnSye114rVgCr8UW4co21dVF0+
 SLJt8eU1n7J+qPEgXposd6+TI4b4irYQIm3OtWWZXthSLK40/pW+jBNBTCtanelzFUSz
 bxozsOckhuM9FFQ13TL+7KyERVec1zS0WaihvlkJu6DBYvNKrjeiziw6QyGLJDIw0pQY
 ALTTBH0qp/vezT2LBjgJwRwnTXjRHD0RBEj71I3eHENqbZK5H7J+eXMOVVJzpwla74im
 iRAO73PMgy3q99AGOBGcimc13nbOfR1UFuGJgEDYS4+aPe7xzruaAobC6fAebf1YhIfw kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35ku8dxjjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 18:19:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIBggc061210;
        Thu, 24 Dec 2020 18:17:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35k0e51266-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Dec 2020 18:17:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BOIHLLp006109;
        Thu, 24 Dec 2020 18:17:21 GMT
Received: from localhost.localdomain (/10.159.237.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Dec 2020 10:17:21 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v1 06/12] lib/alloc.h: remove align_min
 from struct alloc_ops
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-7-imbrenda@linux.ibm.com>
Message-ID: <efd03516-a0cc-b897-5b12-e25114103f71@oracle.com>
Date:   Thu, 24 Dec 2020 10:17:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012240115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012240115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> Remove align_min from struct alloc_ops, since it is no longer used.
>
> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> ---
>   lib/alloc.h      | 1 -
>   lib/alloc_page.c | 1 -
>   lib/alloc_phys.c | 9 +++++----
>   lib/vmalloc.c    | 1 -
>   4 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/lib/alloc.h b/lib/alloc.h
> index 9b4b634..db90b01 100644
> --- a/lib/alloc.h
> +++ b/lib/alloc.h
> @@ -25,7 +25,6 @@
>   struct alloc_ops {
>   	void *(*memalign)(size_t alignment, size_t size);
>   	void (*free)(void *ptr);
> -	size_t align_min;
>   };
>   
>   extern struct alloc_ops *alloc_ops;
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 8d2700d..b1cdf21 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -385,7 +385,6 @@ void *memalign_pages_area(unsigned int area, size_t alignment, size_t size)
>   static struct alloc_ops page_alloc_ops = {
>   	.memalign = memalign_pages,
>   	.free = free_pages,
> -	.align_min = PAGE_SIZE,
>   };
>   
>   /*
> diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
> index 72e20f7..a4d2bf2 100644
> --- a/lib/alloc_phys.c
> +++ b/lib/alloc_phys.c
> @@ -29,8 +29,8 @@ static phys_addr_t base, top;
>   static void *early_memalign(size_t alignment, size_t size);
>   static struct alloc_ops early_alloc_ops = {
>   	.memalign = early_memalign,
> -	.align_min = DEFAULT_MINIMUM_ALIGNMENT
>   };
> +static size_t align_min;


I don't see any caller of phys_alloc_set_minimum_alignment(). So when 
you are comparing against this variable in phys_alloc_aligned_safe() 
below, you are comparing against zero. Is that what you is intended or 
should 'align_min' be set some default ?

>   
>   struct alloc_ops *alloc_ops = &early_alloc_ops;
>   
> @@ -39,8 +39,7 @@ void phys_alloc_show(void)
>   	int i;
>   
>   	spin_lock(&lock);
> -	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
> -		(u64)early_alloc_ops.align_min);
> +	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
>   	for (i = 0; i < nr_regions; ++i)
>   		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
>   			(u64)regions[i].base,
> @@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
>   {
>   	assert(align && !(align & (align - 1)));
>   	spin_lock(&lock);
> -	early_alloc_ops.align_min = align;
> +	align_min = align;
>   	spin_unlock(&lock);
>   }
>   
> @@ -83,6 +82,8 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
>   		top_safe = MIN(top_safe, 1ULL << 32);
>   
>   	assert(base < top_safe);
> +	if (align < align_min)
> +		align = align_min;
>   
>   	addr = ALIGN(base, align);
>   	size += addr - base;
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 7a49adf..e146162 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -190,7 +190,6 @@ static void vm_free(void *mem)
>   static struct alloc_ops vmalloc_ops = {
>   	.memalign = vm_memalign,
>   	.free = vm_free,
> -	.align_min = PAGE_SIZE,
>   };
>   
>   void __attribute__((__weak__)) find_highmem(void)

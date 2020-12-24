Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634692E288B
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgLXSTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 13:19:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgLXSTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 13:19:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIAtCG179067;
        Thu, 24 Dec 2020 18:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PgpK8DEes4iglxMlISs/xKKrfhr3GuEqRJXBBBbz5Xk=;
 b=aJEr2orgfHh3nIpVlgXftsDVuYjfGUuEyUjJ2xo3Fw8JOoeFvMLbdnd9jfJmSrbq3Ag4
 VdYrnRyTFcmgOOTBXn9VZ+d98E7KQzcrEjaA2YKoOEXLgThFh7DrWRbG+jEuDsMo6qtn
 9zzXBbmXFmaLSGKFs1NYZGQdheWdcsHnqlnD/9ekNkKjg3QVNHgzn/mVRuNh1wVlJv4Y
 vILfFKsJvPrQBx/mwq9v0UiWxYu13LZMuoq/hxl3kSXxoGdmCm2Van943GJIUEnEyHgk
 Xf96KO3ToEpMKVbYQobFdNtxRk/S8xUDn4/B9h7pCmfzJUomdn4k6nm+bsrU/tn/xhw6 nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35k0cwcb94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 18:18:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIBlQB061404;
        Thu, 24 Dec 2020 18:16:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35k0e511yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Dec 2020 18:16:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BOIGtWA011995;
        Thu, 24 Dec 2020 18:16:55 GMT
Received: from localhost.localdomain (/10.159.237.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Dec 2020 10:16:55 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v1 03/12] lib/vmalloc: add some asserts and
 improvements
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-4-imbrenda@linux.ibm.com>
Message-ID: <80b20b32-64e6-5e69-0b0f-5d72aefe8398@oracle.com>
Date:   Thu, 24 Dec 2020 10:16:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012240115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0
 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012240115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> Add some asserts to make sure the state is consistent.
>
> Simplify and improve the readability of vm_free.
>
> Fixes: 3f6fee0d4da4 ("lib/vmalloc: vmalloc support for handling allocation metadata")
>
> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> ---
>   lib/vmalloc.c | 20 +++++++++++---------
>   1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 986a34c..7a49adf 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -162,13 +162,14 @@ static void *vm_memalign(size_t alignment, size_t size)
>   static void vm_free(void *mem)
>   {
>   	struct metadata *m;
> -	uintptr_t ptr, end;
> +	uintptr_t ptr, page, i;
>   
>   	/* the pointer is not page-aligned, it was a single-page allocation */


Do we need an assert() for 'mem' if it is NULL for some reason ?

>   	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
>   		assert(GET_MAGIC(mem) == VM_MAGIC);
> -		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> -		free_page(phys_to_virt(ptr));
> +		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> +		assert(page);
> +		free_page(phys_to_virt(page));
>   		return;
>   	}
>   
> @@ -176,13 +177,14 @@ static void vm_free(void *mem)
>   	m = GET_METADATA(mem);
>   	assert(m->magic == VM_MAGIC);
>   	assert(m->npages > 0);
> +	assert(m->npages < BIT_ULL(BITS_PER_LONG - PAGE_SHIFT));


NIT:  Combine the two assert()s for 'npages' perhaps ?

>   	/* free all the pages including the metadata page */
> -	ptr = (uintptr_t)mem - PAGE_SIZE;
> -	end = ptr + m->npages * PAGE_SIZE;
> -	for ( ; ptr < end; ptr += PAGE_SIZE)
> -		free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
> -	/* free the last one separately to avoid overflow issues */
> -	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
> +	ptr = (uintptr_t)m & PAGE_MASK;
> +	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
> +		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
> +		assert(page);
> +		free_page(phys_to_virt(page));
> +	}
>   }
>   
>   static struct alloc_ops vmalloc_ops = {

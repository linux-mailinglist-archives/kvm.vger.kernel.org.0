Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374892EA18F
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 01:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAEAkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 19:40:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbhAEAkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 19:40:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1050ZLeO180866;
        Tue, 5 Jan 2021 00:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9JPhEgnXfezee4UwBY5wlaKC/W5VSot/NGX6wVtN1Ms=;
 b=uragTyLS5PStCaJ5iOa3sPz2L8A0QzQNOgdp29k5aJorojiusp125ErN0SFVIEJ40FnN
 TGXzsoHFNa9DUMx4O2R3S6pKAmdjzNEFQZe1ALWiYwl16uYKSUq8MuuwZ8Sa9ev+HyZr
 77EIZvDpJpfYaTkVoM/uPjaJhP1O2cHwOQf0Adj56x+0pQFbLtXQE5kC3lWxTKPpH9mM
 Z5+9jqpg9pRL0Q+ZoYYFzpInLB1+ooErVYu2u0RDt6c/7wdW0CHjpHsMONnJk9AAJ6sa
 WdmJgzcTTAOp6YjU93pijGSyd+RGw2lGPJ2knTjqxMP5SCiINAaBU/r4MGJqOJW3jLai zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35tg8qxrn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 00:39:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1050UKsd070001;
        Tue, 5 Jan 2021 00:39:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35uxnrxfgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 00:39:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1050diRI031099;
        Tue, 5 Jan 2021 00:39:44 GMT
Received: from localhost.localdomain (/10.159.130.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 00:39:43 +0000
Subject: Re: [kvm-unit-tests PATCH v1 06/12] lib/alloc.h: remove align_min
 from struct alloc_ops
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-7-imbrenda@linux.ibm.com>
 <efd03516-a0cc-b897-5b12-e25114103f71@oracle.com>
 <20210104140510.25ee0c71@ibm-vm>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ccac6f66-30a3-199a-23f9-00b196a74b7d@oracle.com>
Date:   Mon, 4 Jan 2021 16:39:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210104140510.25ee0c71@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/4/21 5:05 AM, Claudio Imbrenda wrote:
> On Thu, 24 Dec 2020 10:17:20 -0800
> Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>
>> On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
>>> Remove align_min from struct alloc_ops, since it is no longer used.
>>>
>>> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
>>> ---
>>>    lib/alloc.h      | 1 -
>>>    lib/alloc_page.c | 1 -
>>>    lib/alloc_phys.c | 9 +++++----
>>>    lib/vmalloc.c    | 1 -
>>>    4 files changed, 5 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/lib/alloc.h b/lib/alloc.h
>>> index 9b4b634..db90b01 100644
>>> --- a/lib/alloc.h
>>> +++ b/lib/alloc.h
>>> @@ -25,7 +25,6 @@
>>>    struct alloc_ops {
>>>    	void *(*memalign)(size_t alignment, size_t size);
>>>    	void (*free)(void *ptr);
>>> -	size_t align_min;
>>>    };
>>>    
>>>    extern struct alloc_ops *alloc_ops;
>>> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
>>> index 8d2700d..b1cdf21 100644
>>> --- a/lib/alloc_page.c
>>> +++ b/lib/alloc_page.c
>>> @@ -385,7 +385,6 @@ void *memalign_pages_area(unsigned int area,
>>> size_t alignment, size_t size) static struct alloc_ops
>>> page_alloc_ops = { .memalign = memalign_pages,
>>>    	.free = free_pages,
>>> -	.align_min = PAGE_SIZE,
>>>    };
>>>    
>>>    /*
>>> diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
>>> index 72e20f7..a4d2bf2 100644
>>> --- a/lib/alloc_phys.c
>>> +++ b/lib/alloc_phys.c
>>> @@ -29,8 +29,8 @@ static phys_addr_t base, top;
>>>    static void *early_memalign(size_t alignment, size_t size);
>>>    static struct alloc_ops early_alloc_ops = {
>>>    	.memalign = early_memalign,
>>> -	.align_min = DEFAULT_MINIMUM_ALIGNMENT
>>>    };
>>> +static size_t align_min;
>>
>> I don't see any caller of phys_alloc_set_minimum_alignment(). So when
> lib/arm/setup.c:150
> lib/powerpc/setup.c:150
>
>> you are comparing against this variable in phys_alloc_aligned_safe()
>> below, you are comparing against zero. Is that what you is intended
>> or should 'align_min' be set some default ?
> if the architecture specific code did not specify anything better, 0 is
> ok.
>   
>>>    
>>>    struct alloc_ops *alloc_ops = &early_alloc_ops;
>>>    
>>> @@ -39,8 +39,7 @@ void phys_alloc_show(void)
>>>    	int i;
>>>    
>>>    	spin_lock(&lock);
>>> -	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
>>> -		(u64)early_alloc_ops.align_min);
>>> +	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
>>> (u64)align_min); for (i = 0; i < nr_regions; ++i)
>>>    		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
>>>    			(u64)regions[i].base,
>>> @@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t
>>> align) {
>>>    	assert(align && !(align & (align - 1)));
>>>    	spin_lock(&lock);
>>> -	early_alloc_ops.align_min = align;
>>> +	align_min = align;
>>>    	spin_unlock(&lock);
>>>    }
>>>    
>>> @@ -83,6 +82,8 @@ static phys_addr_t
>>> phys_alloc_aligned_safe(phys_addr_t size, top_safe = MIN(top_safe,
>>> 1ULL << 32);
>>>    	assert(base < top_safe);
>>> +	if (align < align_min)
>>> +		align = align_min;
>>>    
>>>    	addr = ALIGN(base, align);
>>>    	size += addr - base;
>>> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
>>> index 7a49adf..e146162 100644
>>> --- a/lib/vmalloc.c
>>> +++ b/lib/vmalloc.c
>>> @@ -190,7 +190,6 @@ static void vm_free(void *mem)
>>>    static struct alloc_ops vmalloc_ops = {
>>>    	.memalign = vm_memalign,
>>>    	.free = vm_free,
>>> -	.align_min = PAGE_SIZE,
>>>    };
>>>    
>>>    void __attribute__((__weak__)) find_highmem(void)
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

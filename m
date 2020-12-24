Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38742E2888
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgLXSSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 13:18:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgLXSSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 13:18:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOI8jqc109339;
        Thu, 24 Dec 2020 18:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MnY+U7XfRDqdc1Rs1zEn7FJ/klKVWICZtwK9lgl1BTc=;
 b=ng/TSJKwDe2TDBj3TciO8yly0AwLDh9bd/NBlAupm3GtOIlkIOzHZ0bMK+ihH6AQDfME
 ju+BQwYtw2kpdv0RT6s8NXqZsiJpTbNpH9Dj0o2lVreWHbADbXOxkbuKUiZQcvGx2eB2
 Oy33xVbuy2XttKFa6d5/ps581VA1hseco3mnJl0R5crSkJhpkQh/Fjz1M6HnWIj5Ssgz
 oXEQzWKFj3zs9ptJSm6EqBeSPQjPRrMz3oHO2qbZ5BfycMCcGsiOdWdWr+KnCqXz5mu5
 H4mt1RxlTnycRfG2lyVp6bb8SDeL3RV7J0A/Fhap5HUFG4qtPN386vXfKTDGMM2RCB2q HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35ku8dxjfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 18:17:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIBhMn061347;
        Thu, 24 Dec 2020 18:17:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35k0e5127s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Dec 2020 18:17:33 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BOIHWvX012212;
        Thu, 24 Dec 2020 18:17:32 GMT
Received: from localhost.localdomain (/10.159.237.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Dec 2020 10:17:32 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v1 12/12] lib/alloc_page: default flags and
 zero pages by default
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-13-imbrenda@linux.ibm.com>
Message-ID: <c61ee0fb-5d06-8c61-fa97-975c6a603599@oracle.com>
Date:   Thu, 24 Dec 2020 10:17:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-13-imbrenda@linux.ibm.com>
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


On 12/16/20 12:12 PM, Claudio Imbrenda wrote:
> The new function page_alloc_set_default_flags can be used to set the
> default flags for allocations. The passed value will be ORed with the
> flags argument passed to the allocator at each allocation.
>
> The default value for the default flags is FLAG_ZERO, which means that
> by default all allocated memory is now zeroed, restoring the default
> behaviour that had been accidentally removed by a previous commit.
>
> If needed, a testcase can call page_alloc_set_default_flags(0) in order
> to get non-zeroed pages from the allocator. For example, if the
> testcase will need fresh memory, the zero flag should be removed from
> the default.
>
> Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page allocator")
> Reported-by: Nadav Amit<nadav.amit@gmail.com>
>
> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> ---
>   lib/alloc_page.h | 3 +++
>   lib/alloc_page.c | 8 ++++++++
>   2 files changed, 11 insertions(+)
>
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 1039814..8b53a58 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -22,6 +22,9 @@
>   /* Returns true if the page allocator has been initialized */
>   bool page_alloc_initialized(void);
>   
> +/* Sets the default flags for the page allocator, the default is FLAG_ZERO */
> +void page_alloc_set_default_flags(unsigned int flags);
> +
>   /*
>    * Initializes a memory area.
>    * n is the number of the area to initialize
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 4d5722f..08e0d05 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -54,12 +54,19 @@ static struct mem_area areas[MAX_AREAS];
>   static unsigned int areas_mask;
>   /* Protects areas and areas mask */
>   static struct spinlock lock;
> +/* Default behaviour: zero allocated pages */
> +static unsigned int default_flags = FLAG_ZERO;
>   
>   bool page_alloc_initialized(void)
>   {
>   	return areas_mask != 0;
>   }
>   
> +void page_alloc_set_default_flags(unsigned int flags)
> +{
> +	default_flags = flags;


Who calls this functions ?

Just wondering if default flag should be a static set of flag values 
which the caller can override based on needs rather than the caller 
setting the default flag.

> +}
> +
>   /*
>    * Each memory area contains an array of metadata entries at the very
>    * beginning. The usable memory follows immediately afterwards.
> @@ -394,6 +401,7 @@ static void *page_memalign_order_flags(u8 ord, u8 al, u32 flags)
>   	void *res = NULL;
>   	int i, area, fresh;
>   
> +	flags |= default_flags;
>   	fresh = !!(flags & FLAG_FRESH);
>   	spin_lock(&lock);
>   	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;

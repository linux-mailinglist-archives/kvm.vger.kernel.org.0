Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145CC133F2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 21:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfECTNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 15:13:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfECTNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 15:13:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43J9Ukg072476;
        Fri, 3 May 2019 19:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qhgfz7e9YGEFNxtiPzmFBjeh6CPFHRJyMgrZF6sl1V4=;
 b=gh8B2PO9bUSMNoKQpTESn5MzOXBqsfXgM319JkALNEeM7Y/FhDC+0GqKGHMr8I5Jndxw
 YBdAaHDvx3mDxxE6c+Hc0nea7W/rdJnF4fGIViFwzQc4dr+W5VbEStedVobhfVN/Q0l+
 cZjHtJQ6q1luAcV2UUZbyN18CwrseH7hKI/x8kK+58T2rO8V2k++/AMewBrBOIPDMhDe
 O1/p84bXh69LCSr7eR8KBM8LO3P0p86KJNqa8FcjwSU4zN0cV/DuxLRy4VEOLbv2muDo
 qoiMEBS561oHCuRf27QqBENGptZgUP7z2xDzcns7KBYfD+XgFH3hgxPWfmSrx7rAlAaP pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s6xj00r1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:12:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43J9iFC086339;
        Fri, 3 May 2019 19:10:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2s7p8agekr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:10:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x43JApKm009079;
        Fri, 3 May 2019 19:10:51 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 12:10:51 -0700
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/alloc_page: Zero allocated
 pages
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
 <20190503103207.9021-2-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <7372014b-7f78-8c88-12c1-e4e2572dad69@oracle.com>
Date:   Fri, 3 May 2019 12:10:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190503103207.9021-2-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/03/2019 03:32 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> One of the most important properties of tests is reproducibility. For
> tests to be reproducible, the same environment should be set on each
> test invocation.
>
> When it comes to memory content, this is not exactly the case in
> kvm-unit-tests. The tests might, mistakenly or intentionally, assume
> that memory is zeroed (by the BIOS or KVM).  However, failures might not
> be reproducible if this assumption is broken.
>
> As an example, consider x86 do_iret(), which mistakenly does not push
> SS:RSP onto the stack on 64-bit mode, although they are popped
> unconditionally on iret.
>
> Do not assume that memory is zeroed. Clear it once it is allocated to
> allow tests to easily be reproduced.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/alloc_page.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 730f2b5..97d1339 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -65,6 +65,8 @@ void *alloc_page()
>   	freelist = *(void **)freelist;
>   	spin_unlock(&lock);
>   
> +	if (p)
> +		memset(p, 0, PAGE_SIZE);
>   	return p;
>   }
>   
> @@ -126,6 +128,8 @@ void *alloc_pages(unsigned long order)
>   		}
>   	}
>   	spin_unlock(&lock);
> +	if (run_start)
> +		memset(run_start, 0, n * PAGE_SIZE);
>   	return run_start;
>   }
>   

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

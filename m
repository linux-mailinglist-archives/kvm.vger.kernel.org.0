Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD68E365C9D
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhDTPst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:48:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232997AbhDTPsr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:48:47 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KFYjli126065;
        Tue, 20 Apr 2021 11:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TxswjpVhyEvHLjRsx4og9KobLmPUrg0SoUft8KUXBZ8=;
 b=KJwzmWMk7q6YrzjH4rDQ12pp23N04AuV8L8pq/FpwY0f1Dn8mYiEwStZMUa3hz8THzom
 3JOT1sA32FZpbp5kM/EhSJhXWIfAQCxf/i9QM6fdcC9kaL3kMO6bt+7ifZG8ltvxuMDV
 Dtc2cnT5YwHzVOFteL+0RemEahIxhIdfDZwL58+AWYKgumpaLr5t9Nla3MaNpf3nN0gH
 QnGgNhBsQ/opY4BxXxCVDWohCwx/tnlJx/p1Z2GWIlUYNcY1l9YjyEcrNQybYqtEaEbZ
 yXSkjzKIyZ4iIuoQ6Kc0xXVQDM0N09u0v1+v3KqbIOIfzywq7bA6u+EtZvU9JJsv79e6 PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381x5ufshw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KFYnHW127061;
        Tue, 20 Apr 2021 11:48:14 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381x5ufsgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:14 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KFm5o4021038;
        Tue, 20 Apr 2021 15:48:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 37yqa8906p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 15:48:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KFlksD31392020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 15:47:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4BD4C04E;
        Tue, 20 Apr 2021 15:48:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A627D4C040;
        Tue, 20 Apr 2021 15:48:09 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 15:48:09 +0000 (GMT)
Date:   Tue, 20 Apr 2021 16:18:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/6] s390x: Test for share/unshare call
 support before using them
Message-ID: <20210420161833.23bcda35@ibm-vm>
In-Reply-To: <20210316091654.1646-5-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
        <20210316091654.1646-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kg1Cwcax46xDUT-iDvpIn435fabXW_yd
X-Proofpoint-GUID: 06Y1K9phCF3c8IAZp_tL2oPcl_niY1Jh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_07:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 09:16:52 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Testing for facility only means the UV Call facility is available.
> The UV will only indicate the share/unshare calls for a protected
> guest 2, so let's also check that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/malloc_io.c | 5 +++--
>  s390x/uv-guest.c      | 6 ++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> index 1dcf1691..78582eac 100644
> --- a/lib/s390x/malloc_io.c
> +++ b/lib/s390x/malloc_io.c
> @@ -19,6 +19,7 @@
>  #include <alloc_page.h>
>  #include <asm/facility.h>
>  #include <bitops.h>
> +#include <uv.h>
>  
>  static int share_pages(void *p, int count)
>  {
> @@ -47,7 +48,7 @@ void *alloc_io_mem(int size, int flags)
>  	assert(size);
>  
>  	p = alloc_pages_flags(order, AREA_DMA31 | flags);
> -	if (!p || !test_facility(158))
> +	if (!p || !uv_os_is_guest())
>  		return p;
>  
>  	n = share_pages(p, 1 << order);
> @@ -65,7 +66,7 @@ void free_io_mem(void *p, int size)
>  
>  	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>  
> -	if (test_facility(158))
> +	if (uv_os_is_guest())
>  		unshare_pages(p, 1 << order);
>  	free_pages(p);
>  }
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 95a968c5..8915b2f1 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -16,6 +16,7 @@
>  #include <asm/facility.h>
>  #include <asm/uv.h>
>  #include <sclp.h>
> +#include <uv.h>
>  
>  static unsigned long page;
>  
> @@ -141,6 +142,11 @@ int main(void)
>  		goto done;
>  	}
>  
> +	if (!uv_os_is_guest()) {
> +		report_skip("Not a protected guest");
> +		goto done;
> +	}
> +
>  	page = (unsigned long)alloc_page();
>  	test_priv();
>  	test_invalid();


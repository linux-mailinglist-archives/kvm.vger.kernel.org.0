Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7896424EFA
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhJGIQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:16:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233489AbhJGIQ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:16:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1976abRx002840;
        Thu, 7 Oct 2021 04:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M0TXmQvl93a/fK+y76L8SEuVr6KJ4TvgLWUIr6DwMnc=;
 b=R+uGdAnq3nVOqdRbMTtMnqhgWcaKo+gTWxr5ac8yQSYo1WYhRmV6dpBPR/4EsmzXwF7x
 AmdHVXrdWa3c1L0Iie77DrmzUk5q7rEjIGBa6x9agz2D8WI0pUl6z+8gtec0kYbGu6o4
 OqiAnRYSATDG5yVZe76f7ISAdxye7kje8UG56paYtz9jeikK5EPiWYwRvmO4Hz3/7Lvc
 6JdBRFV7wbnvB0i4i5GOoQxDmQtiH+bIsF3BUHo3F2Xm/1XkY99uGtxI6Z7Q6QcoyFoz
 L7Z8TItMVyyuYOSkAlSvXpQQgNnC7SBIIx9H0HgSYL0+/0R17tifCCa6h2Vr4a266Ti7 Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh1wwd4ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:14:34 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1977CEEp039398;
        Thu, 7 Oct 2021 04:14:34 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh1wwd4u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:14:34 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19787uoN019670;
        Thu, 7 Oct 2021 08:14:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2aj84h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:14:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978EPmx35848526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:14:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FFB511C04A;
        Thu,  7 Oct 2021 08:14:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B3811C06C;
        Thu,  7 Oct 2021 08:14:24 +0000 (GMT)
Received: from [9.145.66.140] (unknown [9.145.66.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:14:24 +0000 (GMT)
Message-ID: <6b4b6ae0-6cee-e435-189a-8657159de97f@linux.ibm.com>
Date:   Thu, 7 Oct 2021 10:14:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] s390x/mvpg-sie: Remove unused variable
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20211007072136.768459-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211007072136.768459-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EZxq5IeQ9zxhWAiVj76ZlAXJBJPmC2Nl
X-Proofpoint-GUID: i4I9VQY2oHHroO5GutdPeo-AXe7rks-0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 09:21, Thomas Huth wrote:
> The guest_instr variable is not used, which was likely a
> copy-n-paste issue from the s390x/sie.c test.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Janosch Fran <frankja@linux.ibm.com>
Thanks, picked.

Weird that the compiler didn't complain with a set but not used message...

> ---
>   s390x/mvpg-sie.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index ccc273b..5adcec1 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -21,7 +21,6 @@
>   #include <sie.h>
>   
>   static u8 *guest;
> -static u8 *guest_instr;
>   static struct vm vm;
>   
>   static uint8_t *src;
> @@ -94,8 +93,6 @@ static void setup_guest(void)
>   
>   	/* Allocate 1MB as guest memory */
>   	guest = alloc_pages(8);
> -	/* The first two pages are the lowcore */
> -	guest_instr = guest + PAGE_SIZE * 2;
>   
>   	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>   
> 


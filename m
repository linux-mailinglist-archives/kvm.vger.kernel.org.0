Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9341244D8EA
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKKPNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:13:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233616AbhKKPNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:13:07 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABF81jU019116
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 15:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rvW+OoQEUbCyjMJRK48+rjNY+gO7EwCSlY/Dd/asy5w=;
 b=UvPioGWgMbNI1VTbAp/XuD8Pnht7PPnd4SoI1eQ/eI5iaeX7TFpF3+Qow84IPo5msFQf
 dwp8IxXUu/P6fwUssp8R2EA+uwqx2SH2rAvRD4haEAncDvMdejNkz6/wNhODL/VuGHLN
 QlQNpKSmk2pT80rNpOgx52H35EFHE//t/uejmR79xhLU+JlwmwlJRSJa8KkdleQhGq93
 qt+nZf6j4MNgS62VAhO8IEeY/Y8jea27NbjULGM0qTe7zw17MTC5VIQElkpb24Ru1COs
 hMzAkA/z5b1FDHuIr18cUJNouLtY8SMM6KWWrNgiKHVchRGxukgtPSby5sV14h+aLZZE uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c956frpw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 15:10:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABF8EIf020284
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 15:10:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c956frpuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 15:10:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABF7L30002502;
        Thu, 11 Nov 2021 15:10:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3c5hbavqpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 15:10:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABFACE029491546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 15:10:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FC0BA4059;
        Thu, 11 Nov 2021 15:10:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8021A405F;
        Thu, 11 Nov 2021 15:10:11 +0000 (GMT)
Received: from [9.145.12.141] (unknown [9.145.12.141])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 15:10:11 +0000 (GMT)
Message-ID: <ad34f00f-06a5-223c-1d93-6f53025311d9@linux.ibm.com>
Date:   Thu, 11 Nov 2021 16:10:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <20211111100153.86088-1-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211111100153.86088-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dUiLRKpxkVLFt9WvExgfxV5xlqINnHdh
X-Proofpoint-ORIG-GUID: qOGt5aXVHageVNyUNaGqMRuYT8hR-o_b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_04,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 11:01, Pierre Morel wrote:
> The allocator allocate pages it follows the size must be rounded
> to pages before the allocation.
> 
> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/malloc_io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> index 78582eac..080fc694 100644
> --- a/lib/s390x/malloc_io.c
> +++ b/lib/s390x/malloc_io.c
> @@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
>   
>   void *alloc_io_mem(int size, int flags)
>   {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>   	void *p;
>   	int n;
>   
> @@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
>   
>   void free_io_mem(void *p, int size)
>   {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>   
>   	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>   
> 


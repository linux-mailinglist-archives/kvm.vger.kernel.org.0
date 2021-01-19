Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048022FBAE4
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 16:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbhASPRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 10:17:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389390AbhASPNO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 10:13:14 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JF2fYP070723;
        Tue, 19 Jan 2021 10:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LcwXqIwRmdpbmKPPJQs8G9FRguwJnkeiswKKQnQJ/70=;
 b=USvRGZRA1At+RQRIREocvjGGYO7J3+SW3uuXtwMAw2JaKDCrYXdhReTDhNYfkVUInaac
 lgaAPg0FvBvao3hJKxmROkjKD3TdqWP0DdDx1EtK9v6ols2I3Q/Y7/QEBATlJxJjQOgN
 H5juT8Vl3hEaw0oIzoxxd36/nFHyHVhD3spV1ak+bqYjVeVcqacpRl92lyPOYhvb+nqK
 gDUSIU1xxc/Gy2DsGrF+OfIj5su0hClM/H3Sd0/Csj2xvbNwJyRwYsFpUFaGGu8sO86I
 Cabp3FeeMQ5XZZ1D1/hj1SEh45U991SxkJDUxRvlcfTbUlgKp3+9VKxOMSEt1yiqQ9ED YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ytem539-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:12:22 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JF4J3p077746;
        Tue, 19 Jan 2021 10:12:22 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ytem51m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:12:22 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JF8gMZ002334;
        Tue, 19 Jan 2021 15:12:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 363t0y9knq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:12:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JFCBpW25559428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:12:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 330DA52059;
        Tue, 19 Jan 2021 15:12:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.160.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9566752054;
        Tue, 19 Jan 2021 15:12:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 01/11] lib/x86: fix page.h to include
 the generic header
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
 <20210115123730.381612-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <7ac2c483-6657-bc0d-622f-f02b04ae7e95@linux.ibm.com>
Date:   Tue, 19 Jan 2021 16:12:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115123730.381612-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 1:37 PM, Claudio Imbrenda wrote:
> Bring x86 in line with the other architectures and include the generic header
> at asm-generic/page.h .
> This provides the macros PAGE_SHIFT, PAGE_SIZE, PAGE_MASK, virt_to_pfn, and
> pfn_to_virt.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/x86/asm/page.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
> index 1359eb7..2cf8881 100644
> --- a/lib/x86/asm/page.h
> +++ b/lib/x86/asm/page.h
> @@ -13,9 +13,7 @@
>  typedef unsigned long pteval_t;
>  typedef unsigned long pgd_t;
>  
> -#define PAGE_SHIFT	12
> -#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK	(~(PAGE_SIZE-1))
> +#include <asm-generic/page.h>
>  
>  #ifndef __ASSEMBLY__
>  
> 


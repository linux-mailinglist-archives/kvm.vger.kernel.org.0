Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68A422709
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 14:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhJEMxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 08:53:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232046AbhJEMx3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 08:53:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195CQxPa027924;
        Tue, 5 Oct 2021 08:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gufGg+KwiJOwpPevxvZnja5Dy7o8YWhGQ9ezAuSci2Y=;
 b=j9b8Mkk0jOKtvvrFFpCj7oZ6LGPgjnyToNdMupWUSUSrarUWfmvKwURGqurM0rbm5Dr1
 OueCdcxyV0smI8eNBFaudYsV+NYhiEBpnJU8fKfxerLz85yRvyhvANYPrz2DMWCs6qAj
 UJRdY0Ksy2kfW9fHtixCq9/UzRoBIklURoMpi3BJjMznld+DuQVZMjArz05KhXHL5PPW
 k0MkW/jrlvXnSwyTGlR1aqSNnHAzmPX8eNpLlcRQWO5MM/Ft4MeE142On/o+nardzg3w
 xnBZuixqRFwkF3FlX9xOCwKs+f0RWop/eZpKRG7/lAlVVBWFIJQ+X3QG9MpovYa2zQnH jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgpbshatc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 08:51:38 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195CR6Qm028838;
        Tue, 5 Oct 2021 08:51:38 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgpbshasy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 08:51:38 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195CglaC022818;
        Tue, 5 Oct 2021 12:51:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3bef29g9q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 12:51:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195CpWrq60883298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 12:51:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BB56A4053;
        Tue,  5 Oct 2021 12:51:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C425AA405B;
        Tue,  5 Oct 2021 12:51:31 +0000 (GMT)
Received: from [9.145.45.132] (unknown [9.145.45.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 12:51:31 +0000 (GMT)
Message-ID: <0ab2acc7-47da-59fc-c959-1d61417ca181@linux.ibm.com>
Date:   Tue, 5 Oct 2021 14:51:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Remove assert from
 arch_def.h
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-2-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211005091153.1863139-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mvRgRxHPjwMJyLxT3n8-qInR2GyeR9qW
X-Proofpoint-ORIG-GUID: o6QKeQYB0wfHXCQ8YnSOIiHlW_r91YKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_01,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 11:11, Janis Schoetterl-Glausch wrote:
> Do not use asserts in arch_def.h so it can be included by snippets.
> The caller in stsi.c does not need to be adjusted, returning -1 causes
> the test to fail.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

A few days ago I had a minute to investigate what needed to be added to 
be able to link the libcflat. Fortunately it wasn't a lot and I'll try 
to post it this week so this patch can hopefully be dropped.

> ---
>   lib/s390x/asm/arch_def.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 302ef1f..4167e2b 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -334,7 +334,7 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>   	return cc;
>   }
>   
> -static inline unsigned long stsi_get_fc(void)
> +static inline int stsi_get_fc(void)
>   {
>   	register unsigned long r0 asm("0") = 0;
>   	register unsigned long r1 asm("1") = 0;
> @@ -346,7 +346,8 @@ static inline unsigned long stsi_get_fc(void)
>   		     : "+d" (r0), [cc] "=d" (cc)
>   		     : "d" (r1)
>   		     : "cc", "memory");
> -	assert(!cc);
> +	if (cc != 0)
> +		return -1;
>   	return r0 >> 28;
>   }
>   
> 


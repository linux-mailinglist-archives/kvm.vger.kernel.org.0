Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4966316560
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBJLkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:40:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhBJLi1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 06:38:27 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AB5DwT075329
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6VHucfYEOxqLyo92ooch9PSi7dE+sRX42DNbtTrS+as=;
 b=RFqX3cYY2VycdIN2F9uX1iqzsojNr4946wWw3dsjncxFU1Na/zHeBYcxM2PTsuugz4NF
 jIEFrXkm8TvCo4ZZxEs4lb3EwoiquwYIicYB+UWJX4vkhx/NnvwlNLkUrejtzaPBhQju
 DTWF7RJc/eog+5xUacLIHRmE9FmnS2Vu1IAXAhFx8imPIYBHkFN1wPawz8sW6b8dtaZZ
 +NNCd+IhzXhyc8fbs7pujbnPQFNHR2s7XhosRyWV2KigSc/oaKXlPQd7CpNIZhpBYeqE
 Dj6hZxOOlfz2+y6A88Ba7U9mcsHD+2/IZQlbmRjPkzXZh09hRcuGzW9/o85HWfc4OlWR 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36me7wh48s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:37:28 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11ABOMZh154239
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 06:37:27 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36me7wh46h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 06:37:27 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ABRCdC011340;
        Wed, 10 Feb 2021 11:32:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2rv14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 11:32:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ABWLLj57737606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 11:32:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9025FA4055;
        Wed, 10 Feb 2021 11:32:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C2F9A4051;
        Wed, 10 Feb 2021 11:32:21 +0000 (GMT)
Received: from [9.145.24.226] (unknown [9.145.24.226])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 11:32:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: introduce leave_pstate to
 leave userspace
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
 <20210209185154.1037852-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <8fa5dc8b-64f5-b19e-aea7-7c95402ef313@linux.ibm.com>
Date:   Wed, 10 Feb 2021 12:32:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209185154.1037852-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102100108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 7:51 PM, Claudio Imbrenda wrote:
> In most testcases, we enter problem state (userspace) just to test if a
> privileged instruction causes a fault. In some cases, though, we need
> to test if an instruction works properly in userspace. This means that
> we do not expect a fault, and we need an orderly way to leave problem
> state afterwards.
> 
> This patch introduces a simple system based on the SVC instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |  5 +++++
>  lib/s390x/interrupt.c    | 12 ++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 9c4e330a..9902e9fe 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -276,6 +276,11 @@ static inline void enter_pstate(void)
>  	load_psw_mask(mask);
>  }
>  
> +static inline void leave_pstate(void)
> +{
> +	asm volatile("	svc 1\n");

Magic constants being magic :-)

> +}
> +
>  static inline int stsi(void *addr, int fc, int sel1, int sel2)
>  {
>  	register int r0 asm("0") = (fc << 28) | sel1;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1ce36073..59e01b1a 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -188,6 +188,14 @@ int unregister_io_int_func(void (*f)(void))
>  
>  void handle_svc_int(void)
>  {
> -	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
> -		     stap(), lc->svc_old_psw.addr);
> +	uint16_t code = lc->svc_int_code;
> +
> +	switch (code) {
> +	case 1:
> +		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		break;
> +	default:
> +		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
> +			      code, stap(), lc->svc_old_psw.addr);
> +	}
>  }
> 


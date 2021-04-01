Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A173510CF
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 10:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhDAIZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 04:25:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10098 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233050AbhDAIYu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 04:24:50 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13184atQ012640
        for <kvm@vger.kernel.org>; Thu, 1 Apr 2021 04:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+evbQ4+cmuFlhSFjbQzlqskkftjaWwOuYejc2xaSfX0=;
 b=oUoD+uCxs/E8VB+LeMp/1VW+4SBApkhQ7aQSnLYLyYVrChXuzDdbjC/Vhav09Bm5TXg8
 bQzTyMN7Qx1UTqtSxRDj5+4G01oW27CL02PvQNn6aseinl8hv8xioSv/qudhXL9z2Lmd
 yYMLcMlL6akZgbb/WOqR7T44m2p8494HXu0KnmXTnYOR4wIsWdW3+UFT4wgJ2YvVCbub
 5ziZpO1xinAdsen8ieEnfnOrIYBSmYx89U3Ysbmtv6T5Q81/F/PUtbQdkhoo6/s9qtEy
 ETkyPcNURwTZy9aO5d/iw2zM/C1QbKrO5O0j5uzJH4c3RdMFgCL0/fnRTgekSGW+0boi rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n2eru7dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 04:24:49 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13185bqt016185
        for <kvm@vger.kernel.org>; Thu, 1 Apr 2021 04:24:48 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n2eru7d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 04:24:48 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13188Rsx025339;
        Thu, 1 Apr 2021 08:24:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37n28v8at3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 08:24:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1318Ohd236503858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Apr 2021 08:24:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8FEC52052;
        Thu,  1 Apr 2021 08:24:43 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.23.196])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 96D1852057;
        Thu,  1 Apr 2021 08:24:43 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for
 IRQ and check I/O completion
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
Message-ID: <da1235fa-e79e-81d1-333c-95c6ef885f26@linux.ibm.com>
Date:   Thu, 1 Apr 2021 10:24:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i7mE8FGcV3aXaDEUaFTJLVxpMyYG_HRt
X-Proofpoint-ORIG-GUID: Op_7NCSt1nCVEH1A1fY6WuaTksEzSGUU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_03:2021-03-31,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 10:39 AM, Pierre Morel wrote:
> We will may want to check the result of an I/O without waiting
> for an interrupt.
> For example because we do not handle interrupt.
> Let's separate waiting for interrupt and the I/O complretion check.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     |  1 +
>   lib/s390x/css_lib.c | 13 ++++++++++---
>   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 0058355..5d1e1f0 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
>   
>   void enable_io_isc(uint8_t isc);
>   int wait_and_check_io_completion(int schid);
> +int check_io_completion(int schid);
>   
>   /*
>    * CHSC definitions
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f5c4f37..1e5c409 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -487,18 +487,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>   }
>   
>   /* wait_and_check_io_completion:
> + * @schid: the subchannel ID
> + */
> +int wait_and_check_io_completion(int schid)
> +{
> +	wait_for_interrupt(PSW_MASK_IO);
> +	return check_io_completion(schid);
> +}
> +
> +/* check_io_completion:
>    * @schid: the subchannel ID
>    *
>    * Makes the most common check to validate a successful I/O
>    * completion.
>    * Only report failures.
>    */
> -int wait_and_check_io_completion(int schid)
> +int check_io_completion(int schid)
>   {
>   	int ret = 0;
>   
> -	wait_for_interrupt(PSW_MASK_IO);
> -
>   	report_prefix_push("check I/O completion");
>   
>   	if (lowcore_ptr->io_int_param != schid) {
> 

Hum, sorry, it seems I forgot here --^ to move the check on io_int_param 
inside the interrupt routine.
I change this for the next spin

regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D083417FC
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCSJJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:09:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229720AbhCSJJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:09:49 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J953gA062993
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v8I4sdX8ZzF6jjBS/pikkjrBZZ+S3qKOl5fO11JqHYk=;
 b=ZRTVFp4zV7o4EXnQVRDd1Hg/2EDh8p7ktW11UYqg85dcIaNx78Bxv8OHQFX0B1D1wBTq
 qQKPDGKIYPpS2hX3SX4gv4hNcZHETi8yctZ7ruBCEVGoJBPv9r+2JKFN/H3yrjIyBaV4
 ASTHn8N+78cIaRkEJAJ0PxUzyhAinPKLqONtb9XKlu3AJikhWOYnJivu0o3+nBDgrshY
 JOWOd4khKGDRuw50vFLJCqMPMg1Tj5DMIEwr80RRaX65urYrgNcvR5xfMSLwYyBF2ZsC
 lJYDIRryqYK3VJ+oXTI10pi1L2mXczVwIvvCB68Kg6ISZqDt8tXR3PFg/Tr17OoC+QgD RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrea0w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:09:49 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12J95Cck063818
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:09:48 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrea0vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 05:09:48 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12J97hSO006491;
        Fri, 19 Mar 2021 09:09:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 378mnhaxqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 09:09:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12J99hw446530902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 09:09:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 341C552051;
        Fri, 19 Mar 2021 09:09:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.32.248])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C78E15204E;
        Fri, 19 Mar 2021 09:09:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 4/6] s390x: lib: css: add expectations
 to wait for interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <c9a38bd8-f091-d3e4-dea5-0ffd9f1cdf12@linux.ibm.com>
Date:   Fri, 19 Mar 2021 10:09:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=968 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103190065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/21 2:26 PM, Pierre Morel wrote:
> When waiting for an interrupt we may need to check the cause of
> the interrupt depending on the test case.
> 
> Let's provide the tests the possibility to check if the last valid
> IRQ received is for the expected instruction.

s/instruction/command/?

We're checking for some value in an IO structure, right?
Instruction makes me expect an actual processor instruction.

Is there another word that can be used to describe what we're checking
here? If yes please also add it to the "pending" variable. "pending_fc"
or "pending_scsw_fc" for example.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  2 +-
>  lib/s390x/css_lib.c | 11 ++++++++++-
>  s390x/css.c         |  4 ++--
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 65fc335..add3b4e 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -316,7 +316,7 @@ void css_irq_io(void);
>  int css_residual_count(unsigned int schid);
>  
>  void enable_io_isc(uint8_t isc);
> -int wait_and_check_io_completion(int schid);
> +int wait_and_check_io_completion(int schid, uint32_t pending);
>  
>  /*
>   * CHSC definitions
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 211c73c..4cdd7ad 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -537,7 +537,7 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>   * completion.
>   * Only report failures.
>   */
> -int wait_and_check_io_completion(int schid)
> +int wait_and_check_io_completion(int schid, uint32_t pending)
>  {
>  	int ret = 0;
>  	struct irq_entry *irq = NULL;
> @@ -569,6 +569,15 @@ int wait_and_check_io_completion(int schid)
>  		goto end;
>  	}
>  
> +	if (pending) {
> +		if (!(pending & irq->irb.scsw.ctrl)) {
> +			report_info("%08x : %s", schid, dump_scsw_flags(irq->irb.scsw.ctrl));
> +			report_info("expect   : %s", dump_scsw_flags(pending));
> +			ret = -1;
> +			goto end;
> +		}
> +	}
> +
>  	/* clear and halt pending are valid even without secondary or primary status */
>  	if (irq->irb.scsw.ctrl & (SCSW_FC_CLEAR | SCSW_FC_HALT)) {
>  		ret = 0;
> diff --git a/s390x/css.c b/s390x/css.c
> index c340c53..a6a9773 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -94,7 +94,7 @@ static void test_sense(void)
>  		goto error;
>  	}
>  
> -	if (wait_and_check_io_completion(test_device_sid) < 0)
> +	if (wait_and_check_io_completion(test_device_sid, SCSW_FC_START) < 0)
>  		goto error;
>  
>  	/* Test transfer completion */
> @@ -137,7 +137,7 @@ static void sense_id(void)
>  {
>  	assert(!start_ccw1_chain(test_device_sid, ccw));
>  
> -	assert(wait_and_check_io_completion(test_device_sid) >= 0);
> +	assert(wait_and_check_io_completion(test_device_sid, SCSW_FC_START) >= 0);
>  }
>  
>  static void css_init(void)
> 


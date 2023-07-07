Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE6474ACD3
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 10:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbjGGIXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 04:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjGGIXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 04:23:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850901FE5;
        Fri,  7 Jul 2023 01:23:41 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3678GmEe025908;
        Fri, 7 Jul 2023 08:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0YOhBCQsLjPKJh0zzYUg3dAMTCUl/goqbTI9k3ENerw=;
 b=sqTpWSa6aUN1RbEjMEqjoG168akOi8BDmDKZjcEWVnOR+OnnyZuqhs4wZYiZpNj7UehX
 Te5X9L/2HCXnTXaWagV/DO3hq7UKkbmDXCFZ84eWQKcfRuyazEBkfAr1CItw46kYY/kO
 692TJ9egzyVCJlF0MPWo5DVeZ1ogguVu2yp27npnPvq679i8tsjg98ODb2kE32rRXBiv
 txV1NMubBrS98YE6arXkt7XgojHtB2J9iy5wq9c3blS5MrbhBjR2JbjQ5uCjhlQ9vDbi
 uruuAU/q2XBbAgZXO6u4ltW67MGz/gUAHvhrGvnwFMIlSuj7/M3FOD0Et2X8p3EIza3t GA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpf2a84dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 08:23:40 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3677lT6H022404;
        Fri, 7 Jul 2023 08:23:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4tuac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 08:23:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3678NZSS46268754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 08:23:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25BFC2014B;
        Fri,  7 Jul 2023 08:23:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF04C2014A;
        Fri,  7 Jul 2023 08:23:34 +0000 (GMT)
Received: from [9.171.49.82] (unknown [9.171.49.82])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 08:23:34 +0000 (GMT)
Message-ID: <c70d1b4c-f3d0-b1e7-8d67-aafe924a7eee@linux.ibm.com>
Date:   Fri, 7 Jul 2023 10:23:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] KVM: s390: Don't WARN on PV validities
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20230706145335.136910-1-frankja@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230706145335.136910-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g7Rp9iholK5cmbwhEjjS3-ySUxj5ga9-
X-Proofpoint-ORIG-GUID: g7Rp9iholK5cmbwhEjjS3-ySUxj5ga9-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307070073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 06.07.23 um 16:53 schrieb Janosch Frank:
> Validities usually indicate KVM errors and as such we want to print a
> message with a high priority to alert users that a validity
> occurred. With the introduction of Protected VMs it's become very easy
> to trigger validities via IOCTLs if the VM is in PV mode.
> 
> An optimal solution would be to return EINVALs to all IOCTLs that
> could result in such a situation. Unfortunately there are quite a lot
> of ways to trigger PV validities since the number of allowed SCB data
> combinations are very limited by FW in order to provide the guest's
> security.
> 
> Let's only log those validities to the KVM sysfs log and skip the
> WARN_ONCE(). This way we get a longish lasting log entry.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> 
> int -> ext:
>   * Fixed range
>   * Extended commit message
> 
> ---
>   arch/s390/kvm/intercept.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..f3c1220fd1e2 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -97,9 +97,15 @@ static int handle_validity(struct kvm_vcpu *vcpu)
>   	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
>   		  current->pid, vcpu->kvm);
>   
> -	/* do not warn on invalid runtime instrumentation mode */
> -	WARN_ONCE(viwhy != 0x44, "kvm: unhandled validity intercept 0x%x\n",
> -		  viwhy);
> +	/*
> +	 * Do not warn on:
> +	 *  - invalid runtime instrumentation mode
> +	 *  - PV related validities since they can be triggered by userspace
> +	 *    PV validities are in the 0x2XXX range
> +	 */
> +	WARN_ONCE(viwhy != 0x44 &&
> +		  ((viwhy < 0x2000) || (viwhy >= 0x3000)),
> +		  "kvm: unhandled validity intercept 0x%x\n", viwhy);
>   	return -EINVAL;
>   }
>   

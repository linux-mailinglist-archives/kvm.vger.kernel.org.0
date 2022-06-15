Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B837354C529
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 11:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiFOJxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 05:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346931AbiFOJxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 05:53:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF6745067;
        Wed, 15 Jun 2022 02:53:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25F8Begt002412;
        Wed, 15 Jun 2022 09:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ycRGs3DCD3L/JxYFtY4JF9d5o99iJE2z5YQkWg9ugKk=;
 b=P/T0kjImwOuyv8dRZlp/cLDL8w9yMpcW5WJWzyNL7LVsR3AFFMdJ/Na0EWvWABythwZV
 p7LC+AZoBa7YciNAOXpUJ0xrNC7paIeyY02yAx29AOLLmvDgN/+dltKrqM6+fAXbXgcW
 qsUHHciSLqDfg22GSeGKWNu3ZzoNFLpMKMmVLZx8XAPYEbx8VoCHabaRXrypgDmfqpPE
 1xb7Qo/6RzHRjic1AXt7MRmA8J6kuCki3IqlNDo00uX/mHDLMIRfBIvCTJi1Eo+I8fIp
 b2ndqbKc6LTtJHj2JCESPLuBLP5/wfZ0mXSBC9jhaN6eTd2QqujtDqxpjYsWl3O92P6U Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq77venu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:53:24 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25F9noUW011264;
        Wed, 15 Jun 2022 09:53:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpq77ven4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:53:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25F9oGC5006016;
        Wed, 15 Jun 2022 09:53:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3gmjp94bdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:53:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25F9rIT617891808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 09:53:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22D06AE04D;
        Wed, 15 Jun 2022 09:53:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A093FAE045;
        Wed, 15 Jun 2022 09:53:17 +0000 (GMT)
Received: from [9.145.158.83] (unknown [9.145.158.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jun 2022 09:53:17 +0000 (GMT)
Message-ID: <bcbfcc87-aef4-d151-8e34-4646f1533c25@linux.ibm.com>
Date:   Wed, 15 Jun 2022 11:53:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 07/19] KVM: s390: pv: module parameter to fence
 asynchronous destroy
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
 <20220603065645.10019-8-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220603065645.10019-8-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _rGPktb8Y2SkRvbuV74qrAj6w4SyO8z3
X-Proofpoint-GUID: N6BCO0CaEOnyEJw7GVyjKw8ORPlQGhKw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206150036
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 08:56, Claudio Imbrenda wrote:
> Add the module parameter "async_destroy", to allow the asynchronous
> destroy mechanism to be switched off.  This might be useful for
> debugging purposes.
> 
> The parameter is enabled by default.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Normally this would be one of the last patches in the series, no?

> ---
>   arch/s390/kvm/kvm-s390.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 76ad6408cb2c..49e27b5d7c3a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -206,6 +206,11 @@ unsigned int diag9c_forwarding_hz;
>   module_param(diag9c_forwarding_hz, uint, 0644);
>   MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
>   
> +/* allow asynchronous deinit for protected guests, enable by default */
> +static int async_destroy = 1;
> +module_param(async_destroy, int, 0444);
> +MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
> +
>   /*
>    * For now we handle at most 16 double words as this is what the s390 base
>    * kernel handles and stores in the prefix page. If we ever need to go beyond


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A356675257
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 11:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjATK0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 05:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjATK0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 05:26:09 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1561490853;
        Fri, 20 Jan 2023 02:26:07 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KANwNV029681;
        Fri, 20 Jan 2023 10:26:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i4So47I99J+eF/7VBWetdMeZwkPJ6zeJAlepJZdXUFI=;
 b=PpgqfgysUaFnRlMwdVw9L8Uv9o8jvP2+8+V2G0THOemL/+j8ZoFRahHTkmlRnhgfGr6E
 fTJN3QsSz3R4VDptN1VUBlnpkwy4t0X4WYGBOrG7IlmKTswFQpZleddsR+P2NLTMUdco
 cH682Ks58QGhJXcsZywMCIBK5m8PfFw3wuu4OWhCerY0+dCrE1EEl1B4VaS6txzKH8qM
 0ntO7QF3LVGCGL4mZDQifGHHSXWNjeLgeDWDba7FyOaDUhtdIUarmgk2g3h1aMJaYrur
 7fTPlUdOo7ZB+A/bfT9h17If/N/rj1w0uJ8lFJkWlH/IJEFInLJr03MbaCW+Kxxiokhm sA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7s5ug151-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 10:26:06 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30K9bHjh013061;
        Fri, 20 Jan 2023 10:26:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n3m16nq2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 10:26:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30KAQ08M24248744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 10:26:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A03702007A;
        Fri, 20 Jan 2023 10:26:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1133620079;
        Fri, 20 Jan 2023 10:26:00 +0000 (GMT)
Received: from [9.171.74.205] (unknown [9.171.74.205])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 10:25:59 +0000 (GMT)
Message-ID: <d8fe5146-def7-262d-15cb-0bb965102f3c@de.ibm.com>
Date:   Fri, 20 Jan 2023 11:25:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/6] improve AP queue reset processing
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xcvKSQdw7tJvFJE9-kS78h9vQndzAVQY
X-Proofpoint-ORIG-GUID: xcvKSQdw7tJvFJE9-kS78h9vQndzAVQY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_06,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxlogscore=790 clxscore=1011 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200090
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.01.23 um 21:31 schrieb Tony Krowiak:
> This series introduces several improvements to the function that performs
> AP queue resets:
> 
> * Breaks up reset processing into multiple smaller, more concise functions.
> 
> * Use TAPQ to verify completion of a reset in progress rather than mulitple
>    invocations of ZAPQ.
> 
> * Check TAPQ response codes when verifying successful completion of ZAPQ.
> 
> * Fix erroneous handling of some error response codes.
> 
> * Increase the maximum amount of time to wait for successful completion of
>    ZAPQ.
>   
> Change log v1 => v2:
> -------------------
> Remove patch 7/7 to restore original behavior since we don't know whether
> interrupts are disabled when an unexpected response code is returned from
> ZAPQ. (Halil)
> 
> Tony Krowiak (6):
>    s390/vfio-ap: verify reset complete in separate function
>    s390/vfio_ap: check TAPQ response code when waiting for queue reset
>    s390/vfio_ap: use TAPQ to verify reset in progress completes
>    s390/vfio_ap: verify ZAPQ completion after return of response code
>      zero
>    s390/vfio_ap: fix handling of error response codes
>    s390/vfio_ap: increase max wait time for reset verification
> 
>   drivers/s390/crypto/vfio_ap_ops.c | 104 +++++++++++++++++++++---------
>   1 file changed, 72 insertions(+), 32 deletions(-)
> 

Thanks applied and queued for CI and regression runs. Will likely go via s390 tree.

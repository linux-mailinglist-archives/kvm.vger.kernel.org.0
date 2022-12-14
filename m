Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E7864CCEF
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 16:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiLNPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 10:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiLNPRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 10:17:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909C6F18;
        Wed, 14 Dec 2022 07:17:41 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEFEhMM029717;
        Wed, 14 Dec 2022 15:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ifm5cje8JO86NL+EoVvyBX85qNpnytEUIdIWSk8yn8c=;
 b=s9qUQ0BZTcmMk7LQsWT0fcp4tQewYwHLEkD90hUBn0kk4PE89MBePlq68nnwMwc2RSx5
 jWzvR8V6FFvsvjfeS2XyTwDuA64UR27HXw7jEso+tJgA87upVMtWp+1FNg6TzzVPwO6W
 cgrrBcH2VC2Jecu7GmsD1htkdsnifl1MiMG4hT359ytrBsSLT7/0WdayT9PJm+BV1KTr
 2v8m3ZB/QzIksvHjTXtxYrhBCNjEuEU6mOoojfHWG0D6wy2/+gCvlYuIEMQYOWzEst+g
 NqbKfamjkgKEbSra7JERibGz+S2mFohHcrM0Zx5HhQrYAytGD35Y+rnCrUpEmWIujOwy Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfgy3r2e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 15:17:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEFFTUc032475;
        Wed, 14 Dec 2022 15:17:38 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfgy3r2du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 15:17:38 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEECIBo011612;
        Wed, 14 Dec 2022 15:16:38 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3meyyhpkjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 15:16:37 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEFGa5X6423056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 15:16:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E6C758043;
        Wed, 14 Dec 2022 15:16:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E86AF58059;
        Wed, 14 Dec 2022 15:16:34 +0000 (GMT)
Received: from [9.60.84.117] (unknown [9.60.84.117])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 15:16:34 +0000 (GMT)
Message-ID: <f528148d-0074-8173-09fc-c1b50bbabe75@linux.ibm.com>
Date:   Wed, 14 Dec 2022 10:16:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 0/7] improve AP queue reset processing
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: blB5BTZYyz-dDiNmQZdqEwo19HR3VuMd
X-Proofpoint-GUID: _ukCk9mC_AbRmHaQVbr10x66ZApubymO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/13/22 10:44 AM, Tony Krowiak wrote:
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
> * Always clean up IRQ resources when the ZAPQ response code indicates an
>    error.
> 
> * Consider reset complete when ZAPQ response code indicates the adapter to
>    which a queue is connected is deconfigured. All queues associated with an
>    adapter are reset when it is deconfigured.
> 
> Tony Krowiak (7):
>    s390/vfio-ap: verify reset complete in separate function
>    s390/vfio_ap: check TAPQ response code when waiting for queue reset
>    s390/vfio_ap: use TAPQ to verify reset in progress completes
>    s390/vfio_ap: verify ZAPQ completion after return of response code
>      zero
>    s390/vfio_ap: fix handling of error response codes
>    s390/vfio_ap: increase max wait time for reset verification
>    s390/vfio_ap: always clean up IRQ resources
> 
>   drivers/s390/crypto/vfio_ap_ops.c | 106 ++++++++++++++++++++----------
>   1 file changed, 73 insertions(+), 33 deletions(-)


This series largely matches what I've already reviewed. I like the way 
you broke this up, it does a better job telling the story.

Here's my R-b for the entire series.
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3E64CFE7
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiLNTKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbiLNTKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:10:51 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA2DECF;
        Wed, 14 Dec 2022 11:10:48 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEItBph014456;
        Wed, 14 Dec 2022 19:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wNHocLVtnP7ui1nRS4SlGlXjwBGfuXS/lh3VyLg7rfI=;
 b=QEkHS/1H5aNgWp6QVrLVxuaYk5vKCeRH30oNati8ivwX4aT2Emqx3N8DaCO4aXkZr0JJ
 DKOEl9mi4+RW+GiQYmJLyO8Zs+QSez7sMZ4aW8Oob13iDtbvFBHHJuS2ZX7qQo3DFMmt
 XYlO6huwXubxr6ss3WPJCOGzf8osrweGT/Ly6NUo7qxkDF8cTzV4o3RGZzxsWmeJ+LPa
 bT3syYnE/trvK296XmAXJnNjAHb6yIt5E+/4nCfMJ/u4cu2e8BpCJD3e8eI+yGz8GIoX
 QnToSJxUp+QTPV0dIt7gwbscqetY2NWnfR5MMPy3A1BOlPCSeWaIniLulluV4k/IH83Y pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfm690nn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 19:10:46 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEIuGin022457;
        Wed, 14 Dec 2022 19:10:45 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfm690nj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 19:10:45 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHgnlL017680;
        Wed, 14 Dec 2022 19:10:42 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3meyqkeh64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 19:10:42 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEJAeSD6750850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:10:41 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E75985803F;
        Wed, 14 Dec 2022 19:10:40 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ED0C5804E;
        Wed, 14 Dec 2022 19:10:39 +0000 (GMT)
Received: from [9.160.6.239] (unknown [9.160.6.239])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 19:10:39 +0000 (GMT)
Message-ID: <be4eda2c-5dea-4dd3-245f-f7effd3fa534@linux.ibm.com>
Date:   Wed, 14 Dec 2022 14:10:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 0/7] improve AP queue reset processing
Content-Language: en-US
To:     "Jason J. Herne" <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <f528148d-0074-8173-09fc-c1b50bbabe75@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <f528148d-0074-8173-09fc-c1b50bbabe75@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3XvQphZ8PRIAZ70O0Ecq6upeLOpvdChn
X-Proofpoint-GUID: YsGqSkV3o7OAeLZXV0_Cfe3kZgkXUUmg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_09,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212140155
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/14/22 10:16 AM, Jason J. Herne wrote:
>
> On 12/13/22 10:44 AM, Tony Krowiak wrote:
>> This series introduces several improvements to the function that 
>> performs
>> AP queue resets:
>>
>> * Breaks up reset processing into multiple smaller, more concise 
>> functions.
>>
>> * Use TAPQ to verify completion of a reset in progress rather than 
>> mulitple
>>    invocations of ZAPQ.
>>
>> * Check TAPQ response codes when verifying successful completion of 
>> ZAPQ.
>>
>> * Fix erroneous handling of some error response codes.
>>
>> * Increase the maximum amount of time to wait for successful 
>> completion of
>>    ZAPQ.
>>
>> * Always clean up IRQ resources when the ZAPQ response code indicates an
>>    error.
>>
>> * Consider reset complete when ZAPQ response code indicates the 
>> adapter to
>>    which a queue is connected is deconfigured. All queues associated 
>> with an
>>    adapter are reset when it is deconfigured.
>>
>> Tony Krowiak (7):
>>    s390/vfio-ap: verify reset complete in separate function
>>    s390/vfio_ap: check TAPQ response code when waiting for queue reset
>>    s390/vfio_ap: use TAPQ to verify reset in progress completes
>>    s390/vfio_ap: verify ZAPQ completion after return of response code
>>      zero
>>    s390/vfio_ap: fix handling of error response codes
>>    s390/vfio_ap: increase max wait time for reset verification
>>    s390/vfio_ap: always clean up IRQ resources
>>
>>   drivers/s390/crypto/vfio_ap_ops.c | 106 ++++++++++++++++++++----------
>>   1 file changed, 73 insertions(+), 33 deletions(-)
>
>
> This series largely matches what I've already reviewed. I like the way 
> you broke this up, it does a better job telling the story.
>
> Here's my R-b for the entire series.
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


Thanks for the review Jason.



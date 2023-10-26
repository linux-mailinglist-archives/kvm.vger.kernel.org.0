Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413F57D8362
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 15:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345039AbjJZNQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 09:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjJZNQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 09:16:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED34AAB;
        Thu, 26 Oct 2023 06:16:46 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDCNLp021682;
        Thu, 26 Oct 2023 13:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8DnR+oFhmG54u/HQGJZGYPMlJtnHjoR7fAtqQEIpjTU=;
 b=Y3gjc0W91UQaAqCn522VZNDuOow36jtKbQUz4gz0jtpi+zlr8ax9uJvxe+p+7HHQyh6U
 A2kWEyY5Lcdo+YwWQxbfRoIqHkY37xXBYghXGXAV9G077m8Xmb2moqz+l+C/vr7lJe4b
 jEHa7WBu2auAz95ehKNvGS13m+5ZODk8Wi8Fi8YMmfYfVWE3bWV6ti7mtwDfOPXLBsNA
 YWei9e9Yx4sm5xOuZ9NfNb4pE/lslI//h0YU288/Bnqs7lvUib7Dx8aPsbY6ePj6gYYw
 w/j4I11lWmOn5LJ5t8Gh1erHSOdef7EOpLf1lLG0Le3hJr5tw/ssU6QBf/i8Eu6PvbAU Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyrsu06dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:16:46 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QDCgMd024416;
        Thu, 26 Oct 2023 13:16:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyrsu06ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:16:45 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCoS4Z005011;
        Thu, 26 Oct 2023 13:16:44 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvtfkx1m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:16:44 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QDGh3931523284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 13:16:43 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8000258052;
        Thu, 26 Oct 2023 13:16:43 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B21C058056;
        Thu, 26 Oct 2023 13:16:42 +0000 (GMT)
Received: from [9.61.161.121] (unknown [9.61.161.121])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 13:16:42 +0000 (GMT)
Message-ID: <7ccf21c4-511c-4de6-bc02-4a936b020a10@linux.ibm.com>
Date:   Thu, 26 Oct 2023 09:16:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] s390/vfio-ap: unpin pages on gisc registration
 failure
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>, stable@vger.kernel.org
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-2-akrowiak@linux.ibm.com>
 <c6951c45-b091-11a6-5684-ba2ef0c94df3@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <c6951c45-b091-11a6-5684-ba2ef0c94df3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zNN3vk6XjNlzOo1Rza_ozeS7OK6HPoe_
X-Proofpoint-ORIG-GUID: axYE6XDmd1Z38OtZG7b8NsZfVzvz7qUy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_11,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/23 08:18, Christian Borntraeger wrote:
> 
> 
> Am 18.10.23 um 15:38 schrieb Tony Krowiak:
>> From: Anthony Krowiak <akrowiak@linux.ibm.com>
>>
>> In the vfio_ap_irq_enable function, after the page containing the
>> notification indicator byte (NIB) is pinned, the function attempts
>> to register the guest ISC. If registration fails, the function sets the
>> status response code and returns without unpinning the page containing
>> the NIB. In order to avoid a memory leak, the NIB should be unpinned 
>> before
>> returning from the vfio_ap_irq_enable function.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Where is Janoschs signed off coming from here?

Janosch found this and composed the patch originally. I just tweaked the 
description and posted it.

> 
>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the 
>> vfio_ap_irq_enable function")
>> Cc: <stable@vger.kernel.org>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 4db538a55192..9cb28978c186 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -457,6 +457,7 @@ static struct ap_queue_status 
>> vfio_ap_irq_enable(struct vfio_ap_queue *q,
>>           VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, 
>> isc=%d, apqn=%#04x\n",
>>                    __func__, nisc, isc, q->apqn);
>> +        vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>>           status.response_code = AP_RESPONSE_INVALID_GISA;
>>           return status;
>>       }

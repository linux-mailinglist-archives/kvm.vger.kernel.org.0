Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6847038B342
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhETP3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:29:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231483AbhETP3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:29:50 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KFJ6v7196091;
        Thu, 20 May 2021 11:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6KanNQpV9PTcjBRFZIoKPmZYHkfIM/LiWFpLoszHSPA=;
 b=nilyqwXsjzvgFLpYuLOZH88c8w+Wf49nWrd2LQ/B2TLDet0eYOGcNUyDmeTcMrRHHTF3
 s0Zd8sthuD1izM5X8nh+0snxPeg6FQiP1N1eW6UyufWXhJ2JrQou8K81ktfAQMGD0Ry3
 /0bJP7df+DQonfwUmc9UMfvWeHX2pTbKxABHCUgTdu4tYDuabirQ45nip6pm8gvmmr2P
 0x9evMlsQUjHwFZmU3RAyhyhhLFT4Mfr0zbnweFhrzAftIZWH2bU1gQ7rncyzZFd6k2V
 olO6Ft+vk75UT6PJHxDL6dyB7zvRb45nYS21On1yTXrS0Xrn3550Cw7dVhBApUzf4Jm8 lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nta8g6rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 11:28:27 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14KFLfjf016550;
        Thu, 20 May 2021 11:28:26 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nta8g6pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 11:28:26 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14KF3fSP023292;
        Thu, 20 May 2021 15:28:25 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 38j5xa2m13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 15:28:25 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14KFSN6h39059850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 15:28:23 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7797AC064;
        Thu, 20 May 2021 15:28:23 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52A6AAC05F;
        Thu, 20 May 2021 15:28:23 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.177.219])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 May 2021 15:28:23 +0000 (GMT)
Subject: Re: [PATCH v16 10/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Julian Wiedmann <jwi@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-11-akrowiak@linux.ibm.com>
 <f928022c-8549-9772-924c-37c0cab79b9d@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <16ade593-df69-b1e9-4ec1-b67b7a8510e1@linux.ibm.com>
Date:   Thu, 20 May 2021 11:28:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f928022c-8549-9772-924c-37c0cab79b9d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XgzsWX9vAa55v_xwL6cwmpOLj_U9sR0n
X-Proofpoint-ORIG-GUID: uPAdtrzJuGMuiV_0OapIdpcLeAo6DCTB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_03:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/21 7:58 AM, Julian Wiedmann wrote:
> On 10.05.21 19:44, Tony Krowiak wrote:
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. The callback
>> will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
>> attributes would result in one or more AP queues being removed from its
>> driver. If the callback responds in the affirmative for any driver
>> queried, the change to the apmask or aqmask will be rejected with a device
>> busy error.
>>
>> For this patch, only non-default drivers will be queried. Currently,
>> there is only one non-default driver, the vfio_ap device driver. The
>> vfio_ap device driver facilitates pass-through of an AP queue to a
>> guest. The idea here is that a guest may be administered by a different
>> sysadmin than the host and we don't want AP resources to unexpectedly
>> disappear from a guest's AP configuration (i.e., adapters and domains
>> assigned to the matrix mdev). This will enforce the proper procedure for
>> removing AP resources intended for guest usage which is to
>> first unassign them from the matrix mdev, then unbind them from the
>> vfio_ap device driver.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/ap_bus.c | 160 ++++++++++++++++++++++++++++++++---
>>   drivers/s390/crypto/ap_bus.h |   4 +
>>   2 files changed, 154 insertions(+), 10 deletions(-)
>>
> This doesn't touch the zcrypt drivers, so I _think_ the subject should
> rather be "s390/ap: driver callback to indicate resource in use". Harald?
>
> Same for patch 13.

Kind of a nit, but I can make the change.



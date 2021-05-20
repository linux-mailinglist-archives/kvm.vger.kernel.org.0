Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C15638AD3D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhETMAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:00:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16890 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243427AbhETL7f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 07:59:35 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KBY4Kv140010;
        Thu, 20 May 2021 07:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mjYigKp/ied+iQwpfx5RhDSraaHRQEHOe5sGSP8ZNcU=;
 b=FqbXE1xIpe8dMBRUynDPjmyEhZnIeprD8MUEMJWodXntem3VCcBn3zqfTQrZCP04ILxQ
 UmPFVbjVbBMbfBEpxrMEB/7X5cjoqhvajLiO8PNIrYB7qRlsoJ7RDRoEamcChC11oTMN
 cBNxsnGVeRGeJHNJlMkhxckhlwIg/03zc2AjNGMCFzxz2fM1H3baa1pmJk7ZuiV6XWqV
 7IOt6CBSnznZsdIxzmT6dvlRsrxegls6G32nWyyMgOSzCvQh2b0RMx7bC37KCid/X6qU
 sr/n+n5WGRPo7DKVAYD/r8NeSGoVKewBsDl71zo9/GYalowWaeleLTxVBzKr9q4aZQSD IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nnpd2ycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 07:58:10 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14KBp4NB070205;
        Thu, 20 May 2021 07:58:09 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38nnpd2yc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 07:58:09 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14KBw7g0010460;
        Thu, 20 May 2021 11:58:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 38m1gv0tgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 11:58:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14KBva6527656490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 11:57:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EBC442047;
        Thu, 20 May 2021 11:58:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91BD942045;
        Thu, 20 May 2021 11:58:03 +0000 (GMT)
Received: from funtu.home (unknown [9.145.190.178])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 May 2021 11:58:03 +0000 (GMT)
Subject: Re: [PATCH v16 10/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-11-akrowiak@linux.ibm.com>
 <f928022c-8549-9772-924c-37c0cab79b9d@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <a5826d8b-1eaf-a862-1270-48d69bc270dd@linux.ibm.com>
Date:   Thu, 20 May 2021 13:58:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f928022c-8549-9772-924c-37c0cab79b9d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wg10A4nBvE-t8sl8Kv30Tnzt_rv45ubY
X-Proofpoint-ORIG-GUID: O7xHuQ0-MQ_pvBayLpiEzE6Egt22kTZV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_03:2021-05-20,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.05.21 13:58, Julian Wiedmann wrote:
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
>>  drivers/s390/crypto/ap_bus.c | 160 ++++++++++++++++++++++++++++++++---
>>  drivers/s390/crypto/ap_bus.h |   4 +
>>  2 files changed, 154 insertions(+), 10 deletions(-)
>>
> This doesn't touch the zcrypt drivers, so I _think_ the subject should
> rather be "s390/ap: driver callback to indicate resource in use". Harald?
That's right - but really not a big issue.
>
> Same for patch 13.

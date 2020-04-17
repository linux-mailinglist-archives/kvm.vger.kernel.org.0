Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FC01ADC18
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 13:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgDQLXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 07:23:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729962AbgDQLXK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 07:23:10 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HB7cP6146451
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 07:23:10 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30fb0x0u1p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 07:23:09 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 Apr 2020 12:23:03 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 12:23:01 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03HBN4Ej49348674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 11:23:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BD7042045;
        Fri, 17 Apr 2020 11:23:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A244D42042;
        Fri, 17 Apr 2020 11:23:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.50])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 11:23:03 +0000 (GMT)
Subject: Re: [PATCH v7 04/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-5-akrowiak@linux.ibm.com>
 <20200416131845.3ef6b3b5.cohuck@redhat.com>
 <5cf7d611-e30c-226d-0d3d-d37170f117f4@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 17 Apr 2020 13:23:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5cf7d611-e30c-226d-0d3d-d37170f117f4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20041711-0028-0000-0000-000003F9DD10
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041711-0029-0000-0000-000024BF967F
Message-Id: <458e4bfe-6736-42b5-a510-21a4594df0e1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_03:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-16 16:45, Tony Krowiak wrote:
> 
> 
> On 4/16/20 7:18 AM, Cornelia Huck wrote:
>> On Tue,  7 Apr 2020 15:20:04 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> Let's implement the callback to indicate when an APQN
>>> is in use by the vfio_ap device driver. The callback is
>>> invoked whenever a change to the apmask or aqmask would
>>> result in one or more queue devices being removed from the driver. The
>>> vfio_ap device driver will indicate a resource is in use
>>> if the APQN of any of the queue devices to be removed are assigned to
>>> any of the matrix mdevs under the driver's control.
>>>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>   drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>>>   drivers/s390/crypto/vfio_ap_ops.c     | 47 +++++++++++++++++----------
>>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>>   3 files changed, 33 insertions(+), 17 deletions(-)
>>> @@ -1369,3 +1371,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue 
>>> *queue)
>>>       kfree(q);
>>>       mutex_unlock(&matrix_dev->lock);
>>>   }
>>> +
>>> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long 
>>> *aqm)
>>> +{
>>> +    bool in_use;
>>> +
>>> +    mutex_lock(&matrix_dev->lock);
>>> +    in_use = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm) ? true : 
>>> false;
>> Maybe
>>
>> in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
>>
>> ?
> 
> To be honest, I find the !! expression very confusing. Every time I see 
> it, I have
> to spend time thinking about what the result of !! is going to be. I think
> the statement should be left as-is because it more clearly expresses
> the intent.



In other places you use
"
         ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
         if (ret)
                 goto share_err;
"
then why use a boolean here?

If you want to return a boolean and you do not want to use !! you can do:

  ...
   ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
...
   return (ret) ? false : true;

> 
>>
>>> +    mutex_unlock(&matrix_dev->lock);
>>> +
>>> +    return in_use;
>>> +}
> 

-- 
Pierre Morel
IBM Lab Boeblingen


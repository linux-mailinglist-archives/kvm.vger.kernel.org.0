Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AEB1AC6DE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394637AbgDPOpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:45:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729317AbgDPOp1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 10:45:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03GEX89v008445;
        Thu, 16 Apr 2020 10:45:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30es39gpfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 10:45:24 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03GEZPSe016131;
        Thu, 16 Apr 2020 10:45:24 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30es39gpew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 10:45:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03GEeRs4003771;
        Thu, 16 Apr 2020 14:45:23 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 30b5h7dqmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 14:45:23 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03GEjLJW52101412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 14:45:21 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C64C4112061;
        Thu, 16 Apr 2020 14:45:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57650112070;
        Thu, 16 Apr 2020 14:45:20 +0000 (GMT)
Received: from cpe-172-100-172-46.stny.res.rr.com (unknown [9.85.128.208])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 16 Apr 2020 14:45:20 +0000 (GMT)
Subject: Re: [PATCH v7 04/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-5-akrowiak@linux.ibm.com>
 <20200416131845.3ef6b3b5.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <5cf7d611-e30c-226d-0d3d-d37170f117f4@linux.ibm.com>
Date:   Thu, 16 Apr 2020 10:45:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416131845.3ef6b3b5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_05:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=3 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/16/20 7:18 AM, Cornelia Huck wrote:
> On Tue,  7 Apr 2020 15:20:04 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Let's implement the callback to indicate when an APQN
>> is in use by the vfio_ap device driver. The callback is
>> invoked whenever a change to the apmask or aqmask would
>> result in one or more queue devices being removed from the driver. The
>> vfio_ap device driver will indicate a resource is in use
>> if the APQN of any of the queue devices to be removed are assigned to
>> any of the matrix mdevs under the driver's control.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>>   drivers/s390/crypto/vfio_ap_ops.c     | 47 +++++++++++++++++----------
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   3 files changed, 33 insertions(+), 17 deletions(-)
>> @@ -1369,3 +1371,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>>   	kfree(q);
>>   	mutex_unlock(&matrix_dev->lock);
>>   }
>> +
>> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>> +{
>> +	bool in_use;
>> +
>> +	mutex_lock(&matrix_dev->lock);
>> +	in_use = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm) ? true : false;
> Maybe
>
> in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
>
> ?

To be honest, I find the !! expression very confusing. Every time I see 
it, I have
to spend time thinking about what the result of !! is going to be. I think
the statement should be left as-is because it more clearly expresses
the intent.

>
>> +	mutex_unlock(&matrix_dev->lock);
>> +
>> +	return in_use;
>> +}


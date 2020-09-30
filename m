Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3627E95F
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgI3NUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 09:20:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbgI3NUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 09:20:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UD32EZ196315;
        Wed, 30 Sep 2020 09:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+4wBy/rox5ENbH0r0Oww+Ct1SMgUWQQGqCAqvAC6+iQ=;
 b=PnTIrywY9Eed6aEoOv7QKRJKB8NOttlJBiS6x4qo4UhgpBeF6st5pcd+TmTexXX8q876
 xiiOiVLcTnQmA+pSk5wGUStweGmaW0z+IPzE1yN1POsQUqMZYz63bOS3U+fUqJ2+zVZN
 vCNOyG+GZn+1/KVmtSyoQWy56hjCpYbtKqQgkw0MKQMclQW+qbOpD3xfIaS5Z3YQbKu8
 TtopAXFRwCMI+d7DTAolsEVShK5Ls4hWCSz5ij9B279owFKOYBRm9SOFJOfj38+TTi00
 QIpPIFc9X43bjKTkZ/3EkeUAyUbGiVLdXBLuCbYpJExKOC2jcuWg/5w7Ur4yZdECaEPT 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33vq8nfmrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 09:19:59 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08UD3psJ004325;
        Wed, 30 Sep 2020 09:19:59 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33vq8nfmr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 09:19:59 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08UDHDHu007694;
        Wed, 30 Sep 2020 13:19:58 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 33sw99pw7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 13:19:58 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08UDJoTU27198074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 13:19:50 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BDB0BE053;
        Wed, 30 Sep 2020 13:19:55 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA2F7BE04F;
        Wed, 30 Sep 2020 13:19:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 30 Sep 2020 13:19:51 +0000 (GMT)
Subject: Re: [PATCH v10 10/16] s390/vfio-ap: allow configuration of matrix
 mdev in use by a KVM guest
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-11-akrowiak@linux.ibm.com>
 <20200927020316.38bf3fa1.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d854afee-51bc-997b-26fc-72b9560f3a0f@linux.ibm.com>
Date:   Wed, 30 Sep 2020 09:19:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200927020316.38bf3fa1.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_07:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/26/20 8:03 PM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:10 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The current support for pass-through crypto adapters does not allow
>> configuration of a matrix mdev when it is in use by a KVM guest. Let's
>> allow AP resources - i.e., adapters, domains and control domains - to be
>> assigned to or unassigned from a matrix mdev while it is in use by a guest.
>> This is in preparation for the introduction of support for dynamic
>> configuration of the AP matrix for a running KVM guest.
> AFAIU this will let the user do the assign, which will however only take
> effect if the same mdev is re-used with a freshly constructed VM, or?
>
> This is however supposed to change real soon (in patch 11). From the
> perspective of bisectability we would end up with a single commit that
> acts funny.
>
> How about switching up patches 10 and 11. This way the changes you have
> in the current 11 would remain dormant until the changes in the current
> 10 enable the complete new feature (hotplug)?

I can do that, but maybe it makes more sense to squash patches 10
and 11 since they are completely dependent on each other. What say
you?

>
>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 24 ------------------------
>>   1 file changed, 24 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 24fd47e43b80..cf3321eb239b 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -773,10 +773,6 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   	struct mdev_device *mdev = mdev_from_dev(dev);
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> -	/* If the guest is running, disallow assignment of adapter */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &apid);
>>   	if (ret)
>>   		return ret;
>> @@ -828,10 +824,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>   	struct mdev_device *mdev = mdev_from_dev(dev);
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> -	/* If the guest is running, disallow un-assignment of adapter */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &apid);
>>   	if (ret)
>>   		return ret;
>> @@ -891,10 +883,6 @@ static ssize_t assign_domain_store(struct device *dev,
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
>>   
>> -	/* If the guest is running, disallow assignment of domain */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &apqi);
>>   	if (ret)
>>   		return ret;
>> @@ -946,10 +934,6 @@ static ssize_t unassign_domain_store(struct device *dev,
>>   	struct mdev_device *mdev = mdev_from_dev(dev);
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> -	/* If the guest is running, disallow un-assignment of domain */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &apqi);
>>   	if (ret)
>>   		return ret;
>> @@ -991,10 +975,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
>>   	struct mdev_device *mdev = mdev_from_dev(dev);
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   
>> -	/* If the guest is running, disallow assignment of control domain */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &id);
>>   	if (ret)
>>   		return ret;
>> @@ -1036,10 +1016,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>   	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
>>   
>> -	/* If the guest is running, disallow un-assignment of control domain */
>> -	if (matrix_mdev->kvm)
>> -		return -EBUSY;
>> -
>>   	ret = kstrtoul(buf, 0, &domid);
>>   	if (ret)
>>   		return ret;


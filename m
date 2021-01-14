Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755282F6CE9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbhANVL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:11:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbhANVL0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 16:11:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EL4VnO194445;
        Thu, 14 Jan 2021 16:10:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bOsMR9tx45nr2qDWQWpV6+rlOd9c6TAuViKqBEcb0+I=;
 b=oudJuLTaxL/bfOUUsKuzk4LFzrKByYvCrXEei1bTA63n9HDVYdopfmsEt+xHoaPPXsUD
 k9PWkHNshw2Rm1kir6dC07nto438JnY5n6cEsxIUgwweHtAzRFqtjDYDv8DS/qbBwHcm
 vx3fDXGB5RxP3a3h5ZowzP4h5X7Qn7a7nezdRcZ9twmkiNEaRK6KZ5W6zwVCPR7iA2M1
 8gY2aK7cT1gcl7q1DsuGd+Hp5pRDsJUY78byVwUuEko9sjHZaVem8+8QmjNtjjfwqYCA
 IZ7zA8pNxqRKppTkv6LqBe4OOKHHpNjPEGqLmh+g5YkqatCZMNxzEcs/ObVQQXFP/vlT jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362ucvm404-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 16:10:45 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EL4jPJ195828;
        Thu, 14 Jan 2021 16:10:45 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362ucvm3yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 16:10:45 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EL2LGF019765;
        Thu, 14 Jan 2021 21:10:43 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 362cwme0yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 21:10:43 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10ELAeVK7275216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 21:10:40 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8DCC136053;
        Thu, 14 Jan 2021 21:10:40 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C32A1136051;
        Thu, 14 Jan 2021 21:10:38 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 21:10:38 +0000 (GMT)
Subject: Re: [PATCH v13 05/15] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-6-akrowiak@linux.ibm.com>
 <20210111201752.21a41db4.pasic@linux.ibm.com>
 <8c701a5c-39f8-0c22-c936-aebbc3c8f60e@linux.ibm.com>
 <20210114035009.375c5496.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <e32ea832-8d4c-1069-9bd8-d92ae210a55a@linux.ibm.com>
Date:   Thu, 14 Jan 2021 16:10:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114035009.375c5496.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_08:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=928 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/13/21 9:50 PM, Halil Pasic wrote:
> On Wed, 13 Jan 2021 16:41:27 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 1/11/21 2:17 PM, Halil Pasic wrote:
>>> On Tue, 22 Dec 2020 20:15:56 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> Let's create links between each queue device bound to the vfio_ap device
>>>> driver and the matrix mdev to which the queue's APQN is assigned. The idea
>>>> is to facilitate efficient retrieval of the objects representing the queue
>>>> devices and matrix mdevs as well as to verify that a queue assigned to
>>>> a matrix mdev is bound to the driver.
>>>>
>>>> The links will be created as follows:
>>>>
>>>>      * When the queue device is probed, if its APQN is assigned to a matrix
>>>>        mdev, the structures representing the queue device and the matrix mdev
>>>>        will be linked.
>>>>
>>>>      * When an adapter or domain is assigned to a matrix mdev, for each new
>>>>        APQN assigned that references a queue device bound to the vfio_ap
>>>>        device driver, the structures representing the queue device and the
>>>>        matrix mdev will be linked.
>>>>
>>>> The links will be removed as follows:
>>>>
>>>>      * When the queue device is removed, if its APQN is assigned to a matrix
>>>>        mdev, the structures representing the queue device and the matrix mdev
>>>>        will be unlinked.
>>>>
>>>>      * When an adapter or domain is unassigned from a matrix mdev, for each
>>>>        APQN unassigned that references a queue device bound to the vfio_ap
>>>>        device driver, the structures representing the queue device and the
>>>>        matrix mdev will be unlinked.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>>>   
> [..]
>
>>>> +
>>>>    int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>>>    {
>>>>    	struct vfio_ap_queue *q;
>>>> @@ -1324,9 +1404,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>>>    	q = kzalloc(sizeof(*q), GFP_KERNEL);
>>>>    	if (!q)
>>>>    		return -ENOMEM;
>>>> +	mutex_lock(&matrix_dev->lock);
>>>>    	dev_set_drvdata(&apdev->device, q);
>>>>    	q->apqn = to_ap_queue(&apdev->device)->qid;
>>>>    	q->saved_isc = VFIO_AP_ISC_INVALID;
>>>> +	vfio_ap_queue_link_mdev(q);
>>>> +	mutex_unlock(&matrix_dev->lock);
>>>> +
>>> Does the critical section have to include more than just
>>> vfio_ap_queue_link_mdev()? Did we need the critical section
>>> before this patch?
>> We did not need the critical section before this patch because
>> the only function that retrieved the vfio_ap_queue via the queue
>> device's drvdata was the remove callback. I included the initialization
>> of the vfio_ap_queue object under lock because the
>> vfio_ap_find_queue() function retrieves the vfio_ap_queue object from
>> the queue device's drvdata so it might be advantageous to initialize
>> it under the mdev lock. On the other hand, I can't come up with a good
>> argument to change this.
>>
>>
> I was asking out of curiosity, not because I want it changed. I was
> also wondering if somebody could see a partially initialized device:
> we even first call dev_set_drvdata() and only then finish the
> initialization. Before 's390/vfio-ap: use new AP bus interface to search
> for queue devices', which is the previous patch, we had the klist code
> in between, which uses spinlocks, which I think ensure, that all
> effects of probe are seen when we get the queue from
> vfio_ap_find_queue(). But with patch 4 in place that is not the case any
> more. Or am I wrong?

You are correct insofar as patch 4 replaces the driver_find_device()
function call with a call to AP bus's ap_get_qdev() function which
does not use spinlocks. Without digging deeply into the probe call
chain I do not know whether or not  the use of spinlocks by the klist
code ensures all effects of the probe are seen when we get the
queue from vfio_ap_find_queue(). What I'm sure about is that since
both vfio_ap_find_queue() and the setting of the drvdata in the
probe function are always done under the mdev lock, consistency
should be maintained. What I did decide when thinking about your
previous review comment is that we should probably initialize the
vfio_ap_queue object before setting the drvdata, so I made that change.

>
> Regards,
> Halil


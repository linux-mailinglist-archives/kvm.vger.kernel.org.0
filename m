Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1C42DA6F6
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 04:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgLODxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 22:53:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgLODxE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 22:53:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BF3WgBa011154;
        Mon, 14 Dec 2020 22:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HgIIEZUoOsrF9FPTKfmyWLbNEgdybBkuXtAHFFWEIJ0=;
 b=i9vjmoyy9qWSDLtAJlzHHWGzxCTBbOnPhWArjKCr3lLxCrerAJLSNXNaCWC1kZbZVNvP
 HzO1iFky2FyQG/28EEyu5UhvEYL2SoaOVK4czh2ilblDKgcknwCfA/FnWlfbxSKkiwg4
 7APJlo5eAwG6/zGcd0q20j5vqgqBcBqYZYzC9409Ld6NrcKhRWvyaF+AwxcK1Cs8aNbD
 +yk4q42FSgIofn5XhR3NWOJCzd/CfXX87rVql6VjWGySSKMWcPcCTVDa8QTOFtyo1S6G
 5bhPaUJHVyAzYzVXjAiuk3leyfXKWBAD52S8yPXiF8/p5dsV2PCrlCSG+cY7V8FadCrL HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ekutt6ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 22:52:22 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BF3Wl3g011534;
        Mon, 14 Dec 2020 22:52:21 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ekutt6d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 22:52:21 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BF3qHA0023789;
        Tue, 15 Dec 2020 03:52:20 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 35cng920ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 03:52:20 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BF3qINr33948402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 03:52:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 652FEAE063;
        Tue, 15 Dec 2020 03:52:18 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8C8BAE05C;
        Tue, 15 Dec 2020 03:52:17 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Dec 2020 03:52:17 +0000 (GMT)
Subject: Re: [PATCH v12 07/17] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-8-akrowiak@linux.ibm.com>
 <20201126165431.6ef1457a.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <56ffa0c6-0518-907e-2635-ff3d7cf1f395@linux.ibm.com>
Date:   Mon, 14 Dec 2020 22:52:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201126165431.6ef1457a.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_03:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150015
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/26/20 10:54 AM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:06 -0500
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
>> There is potential for a deadlock condition between the matrix_dev->lock
>> used to lock the matrix device during assignment of adapters and domains
>> and the ap_perms_mutex locked by the AP bus when changes are made to the
>> sysfs apmask/aqmask attributes.
>>
>> Consider following scenario (courtesy of Halil Pasic):
>> 1) apmask_store() takes ap_perms_mutex
>> 2) assign_adapter_store() takes matrix_dev->lock
>> 3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
>>     to take matrix_dev->lock
>> 4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
>>     which tries to take ap_perms_mutex
>>
>> BANG!
>>
>> To resolve this issue, instead of using the mutex_lock(&matrix_dev->lock)
>> function to lock the matrix device during assignment of an adapter or
>> domain to a matrix_mdev as well as during the in_use callback, the
>> mutex_trylock(&matrix_dev->lock) function will be used. If the lock is not
>> obtained, then the assignment and in_use functions will terminate with
>> -EBUSY.
> Good news is: the final product is OK with regards to in_use(). Bad news
> is: this patch does not do enough. At this stage we are still racy.
>
> The problem is that the assign operations don't bother to take the
> ap_perms_mutex lock under the matrix_dev->lock.
>
> The scenario is the following:
> 1) apmask_store() takes ap_perms_mutex
> 2) apmask_store() calls vfio_ap_mdev_resource_in_use() which
>       takes matrix_dev->lock
> 3) vfio_ap_mdev_resource_in_use() releases matrix_dev->lock
>     and returns 0
> 4) assign_adapter_store() takes matrix_dev->lock does the
>     assign (the queues are still bound to vfio_ap) and releases
>     matrix_dev->lock
> 5) apmask_store() carries on, does the update to apask and releases
>     ap_perms_mutex
> 6) The queues get 'stolen' from vfio ap while used.

You're missing an interim step between 5 and 6 where the apmask_store()
function executes the device_reprobe() function which results in queues
to be taken from vfio_ap getting unbound. In this case, the
vfio_ap_mdev_remove_queue() function gets called to remove the
queues resulting in unplugging

>
> This gets fixed with "s390/vfio-ap: allow assignment of unavailable AP
> queues to mdev device". Maybe we can reorder these patches. I didn't
> look into that.
>
> We could also just ignore the problem, because it is just for a couple
> of commits, but I would prefer it gone.

Reordering the patches is not a trivial task, I perfer not to do it.

>
> Regards,
> Halil
>     
>
>


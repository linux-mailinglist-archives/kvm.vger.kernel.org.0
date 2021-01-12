Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476E42F32BB
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 15:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbhALOPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 09:15:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbhALOPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 09:15:00 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CEDVtI139121;
        Tue, 12 Jan 2021 09:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NhC+2A6g4JtvG1XOI5BVk8rvc/ED4H5GJ+BGYuxwPAs=;
 b=N9ZDMNU2SkbesXixOEV4HHG6i+c4P2JcPHJrfHRKUrzU7BGFOEgdHPaxTGGwnaOaQXiL
 zkmGv48jPHjqYapqHvyN6fh2oLRnjr1e03d0ASFULIVrWMHsk5mZ2Q/3lP588Ql8I0+/
 daDMKE4J4Yazxy3AzqSryfzPukmb9hE4VvzM/6qG7FmTfBhkA4wiZBniUZnI8IQPd0iZ
 /lzFJy0mwEFtwZs4kbC4nF47nkPSKW0dhwlbTl9u+5KqQp3ifYV1Pt0cz6eHV9YCCiLr
 3kZ/Ya6jiU36427echSyS00hcVN0vHTpy67q8+gUf25+Fh0m4e8UMHdjWcaSODPQ2iud Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361dbdg0p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 09:14:16 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CEDhuC139439;
        Tue, 12 Jan 2021 09:14:15 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361dbdg0na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 09:14:15 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CEBJbJ031305;
        Tue, 12 Jan 2021 14:14:13 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 35y448xh80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 14:14:13 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CEEAbk17367296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 14:14:10 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87FC06E052;
        Tue, 12 Jan 2021 14:14:10 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 936A96E053;
        Tue, 12 Jan 2021 14:14:08 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.159.40])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 14:14:08 +0000 (GMT)
Subject: Re: [PATCH v13 11/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-12-akrowiak@linux.ibm.com>
 <20210112022012.4bad464f.pasic@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <d717a554-6d0c-6075-38fd-e725b9622437@linux.ibm.com>
Date:   Tue, 12 Jan 2021 09:14:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112022012.4bad464f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 spamscore=0 impostorscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/21 8:20 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:16:02 -0500
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
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>>   drivers/s390/crypto/vfio_ap_ops.c     | 21 ++++++++++++++++++---
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   3 files changed, 21 insertions(+), 3 deletions(-)
>>
> [..]
>>   }
>> +
>> +int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
>> +{
>> +	int ret;
>> +
>> +	if (!mutex_trylock(&matrix_dev->lock))
>> +		return -EBUSY;
>> +	ret = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
> 
> If we detect that resources are in use, then we spit warnings to the
> message log, right?
> 
> @Matt: Is your userspace tooling going to guarantee that this will never
> happen?

Yes, but only when using the tooling to modify apmask/aqmask.  You would 
still be able to create such a scenario by bypassing the tooling and 
invoking the sysfs interfaces directly.



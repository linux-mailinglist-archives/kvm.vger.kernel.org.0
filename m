Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FB21A92E8
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 08:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441104AbgDOGIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 02:08:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389822AbgDOGId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 02:08:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03F64x7k137730
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 02:08:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30dnms1ge4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 02:08:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 15 Apr 2020 07:08:24 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Apr 2020 07:08:20 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03F68NQY40042614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 06:08:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D80E4203F;
        Wed, 15 Apr 2020 06:08:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D1442045;
        Wed, 15 Apr 2020 06:08:22 +0000 (GMT)
Received: from funtu.home (unknown [9.171.86.5])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Apr 2020 06:08:22 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Cornelia Huck <cohuck@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <20200414145851.562867ae.cohuck@redhat.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 15 Apr 2020 08:08:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200414145851.562867ae.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 20041506-0028-0000-0000-000003F881AF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041506-0029-0000-0000-000024BE329B
Message-Id: <82675d5c-4901-cbd8-9287-79133aa3ee68@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_01:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150041
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.04.20 14:58, Cornelia Huck wrote:
> On Tue,  7 Apr 2020 15:20:03 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. The intent of
>> this callback is to provide a driver with the means to prevent a root user
>> from inadvertently taking a queue away from a guest and giving it to the
>> host while the guest is still using it. The callback will
>> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
>> attributes would result in one or more AP queues being removed from its
>> driver. If the callback responds in the affirmative for any driver
>> queried, the change to the apmask or aqmask will be rejected with a device
>> in use error.
>>
>> For this patch, only non-default drivers will be queried. Currently,
>> there is only one non-default driver, the vfio_ap device driver. The
>> vfio_ap device driver manages AP queues passed through to one or more
>> guests and we don't want to unexpectedly take AP resources away from
>> guests which are most likely independently administered.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/ap_bus.c | 144 +++++++++++++++++++++++++++++++++--
>>  drivers/s390/crypto/ap_bus.h |   4 +
>>  2 files changed, 142 insertions(+), 6 deletions(-)
> (...)
>
>> @@ -1196,12 +1202,75 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>>  	return rc;
>>  }
>>  
>> +int __verify_card_reservations(struct device_driver *drv, void *data)
>> +{
>> +	int rc = 0;
>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>> +	unsigned long *newapm = (unsigned long *)data;
>> +
>> +	/*
>> +	 * If the reserved bits do not identify cards reserved for use by the
>> +	 * non-default driver, there is no need to verify the driver is using
>> +	 * the queues.
> I had to read that one several times... what about
>
> "No need to verify whether the driver is using the queues if it is the
> default driver."
>
> ?
>
>> +	 */
>> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
>> +		return 0;
>> +
>> +	/* The non-default driver's module must be loaded */
>> +	if (!try_module_get(drv->owner))
>> +		return 0;
> Is that really needed? I would have thought that the driver core's
> klist usage would make sure that the callback would not be invoked for
> drivers that are not registered anymore. Or am I missing a window?
The try_module_get() and module_put() is a result of review feedback from
my side. The ap bus core is static in the kernel whereas the
vfio dd is a kernel module. So there may be a race condition between
calling the callback function and removal of the vfio dd module.
There is similar code in zcrypt_api which does the same for the zcrypt
device drivers before using some variables or functions from the modules.
Help me, it this is outdated code and there is no need to adjust the
module reference counter any more, then I would be happy to remove
this code :-)
>
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> Can we log the offending apm somewhere, preferably with additional info
> that allows the admin to figure out why an error was returned?
>
>> +			rc = -EADDRINUSE;
>> +
>> +	module_put(drv->owner);
>> +
>> +	return rc;
>> +}
> (Same comments for the other changes further along in this patch.)
>


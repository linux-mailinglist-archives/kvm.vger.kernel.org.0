Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC07671F97
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjARO3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjARO2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:28:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECE0298FF;
        Wed, 18 Jan 2023 06:15:45 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IEEltD013534;
        Wed, 18 Jan 2023 14:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zNgauiiPSZAOPqccmEqKSs5PwauFDdxol+5ou+GSZXE=;
 b=UkS7CrSVtLatXqAjcrxnFJV9KKhc6wRKKds+JOamAtvMtICaxURVsjRa4Qe6ct2yusqe
 xynY3SpqA7xzI67LUeKJVzoVaIfiO9oJZ2Cg6KsSzl0r/Qia62iOAFQdaZuGLHfOieyB
 ovNEIHaAQewlWkSTUxkjgsjwRYtlcGIqHT5aBToZEkjxTGlDBIRmbq0jdaMOhW9IEPgr
 UdVE5SF9UJxJs7LtfNw9UofXHTpr8FlnrvuBrvlH6/cmTLFXg7NHG/P9kTpATl8jVXsm
 hCrOSyuWmzENzsVh41fgvhkvJOih3wDwPM5qEcv7m/py/f9HFFYG43D4UiwKphHCOFo2 WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jby80d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:15:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IEFaV7016694;
        Wed, 18 Jan 2023 14:15:36 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jby80cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:15:36 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ICLspE025481;
        Wed, 18 Jan 2023 14:15:36 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3n3m17wksp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:15:36 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IEFYXM59441642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 14:15:34 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADEA05805A;
        Wed, 18 Jan 2023 14:15:34 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 356505803F;
        Wed, 18 Jan 2023 14:15:33 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 14:15:33 +0000 (GMT)
Message-ID: <40a2c8c9-819f-b30e-e151-2ea224961a57@linux.ibm.com>
Date:   Wed, 18 Jan 2023 09:15:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4] vfio: fix potential deadlock on vfio group lock
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     pbonzini@redhat.com, jgg@nvidia.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
 <20230117142252.70cc85c7.alex.williamson@redhat.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230117142252.70cc85c7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rhYa3TPlqZKdPTjFC1c-e4g2VLiRQ4gO
X-Proofpoint-GUID: 1QCP2Bx7hgwGUlReO2Gu_589xvkUUhiw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/23 4:22 PM, Alex Williamson wrote:
> On Fri, 13 Jan 2023 19:03:51 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Currently it is possible that the final put of a KVM reference comes from
>> vfio during its device close operation.  This occurs while the vfio group
>> lock is held; however, if the vfio device is still in the kvm device list,
>> then the following call chain could result in a deadlock:
>>
>> kvm_put_kvm
>>  -> kvm_destroy_vm
>>   -> kvm_destroy_devices
>>    -> kvm_vfio_destroy
>>     -> kvm_vfio_file_set_kvm
>>      -> vfio_file_set_kvm
>>       -> group->group_lock/group_rwsem  
>>
>> Avoid this scenario by having vfio core code acquire a KVM reference
>> the first time a device is opened and hold that reference until right
>> after the group lock is released after the last device is closed.
>>
>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>> Reported-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>> Changes from v3:
>> * Can't check for open_count after the group lock has been dropped because
>>   it would be possible for the count to change again once the group lock
>>   is dropped (Jason)
>>   Solve this by stashing a copy of the kvm and put_kvm while the group
>>   lock is held, nullifying the device copies of these in device_close()
>>   as soon as the open_count reaches 0, and then checking to see if the
>>   device->kvm changed before dropping the group lock.  If it changed
>>   during close, we can drop the reference using the stashed kvm and put
>>   function after dropping the group lock.
>>
>> Changes from v2:
>> * Re-arrange vfio_kvm_set_kvm_safe error path to still trigger
>>   device_open with device->kvm=NULL (Alex)
>> * get device->dev_set->lock when checking device->open_count (Alex)
>> * but don't hold it over the kvm_put_kvm (Jason)
>> * get kvm_put symbol upfront and stash it in device until close (Jason)
>> * check CONFIG_HAVE_KVM to avoid build errors on architectures without
>>   KVM support
>>
>> Changes from v1:
>> * Re-write using symbol get logic to get kvm ref during first device
>>   open, release the ref during device fd close after group lock is
>>   released
>> * Drop kvm get/put changes to drivers; now that vfio core holds a
>>   kvm ref until sometime after the device_close op is called, it
>>   should be fine for drivers to get and put their own references to it.
>> ---
>>  drivers/vfio/group.c     | 23 +++++++++++++--
>>  drivers/vfio/vfio.h      |  9 ++++++
>>  drivers/vfio/vfio_main.c | 61 +++++++++++++++++++++++++++++++++++++---
>>  include/linux/vfio.h     |  2 +-
>>  4 files changed, 87 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
>> index bb24b2f0271e..b396c17d7390 100644
>> --- a/drivers/vfio/group.c
>> +++ b/drivers/vfio/group.c
>> @@ -165,9 +165,9 @@ static int vfio_device_group_open(struct vfio_device *device)
>>  	}
>>  
>>  	/*
>> -	 * Here we pass the KVM pointer with the group under the lock.  If the
>> -	 * device driver will use it, it must obtain a reference and release it
>> -	 * during close_device.
>> +	 * Here we pass the KVM pointer with the group under the lock.  A
>> +	 * reference will be obtained the first time the device is opened and
>> +	 * will be held until the open_count reaches 0.
>>  	 */
>>  	ret = vfio_device_open(device, device->group->iommufd,
>>  			       device->group->kvm);
>> @@ -179,9 +179,26 @@ static int vfio_device_group_open(struct vfio_device *device)
>>  
>>  void vfio_device_group_close(struct vfio_device *device)
>>  {
>> +	void (*put_kvm)(struct kvm *kvm);
>> +	struct kvm *kvm;
>> +
>>  	mutex_lock(&device->group->group_lock);
>> +	kvm = device->kvm;
>> +	put_kvm = device->put_kvm;
>>  	vfio_device_close(device, device->group->iommufd);
>> +	if (kvm == device->kvm)
>> +		kvm = NULL;
> 
> Hmm, so we're using whether the device->kvm pointer gets cleared in
> last_close to detect whether we should put the kvm reference.  That's a
> bit obscure.  Our get and put is also asymmetric.
> 
> Did we decide that we couldn't do this via a schedule_work() from the
> last_close function, ie. implementing our own version of an async put?
> It seems like that potentially has a cleaner implementation, symmetric
> call points, handling all the storing and clearing of kvm related
> pointers within the get/put wrappers, passing only a vfio_device to the
> put wrapper, using the "vfio_device_" prefix for both.  Potentially
> we'd just want an unconditional flush outside of lock here for
> deterministic release.
> 
> What's the downside?  Thanks,
> 


I did mention something like this as a possibility when discussing v3..  It's doable, the main issue with doing schedule_work() of an async put is that we can't actually use the device->kvm / device->put_kvm values during the scheduled work task as they become unreliable once we drop the group lock -- e.g. schedule_work() some put call while under the group lock, drop the group lock and then another thread gets the group lock and does a new open_device() before that async put task fires; device->kvm and (less likely) put_kvm might have changed in between.

I think in that case we would need to stash the kvm and put_kvm values in some secondary structure to be processed off a queue by the schedule_work task (an example of what I mean would be bio_dirty_list in block/bio.c).  Very unlikely that this queue would ever have more than 1 element in it.


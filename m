Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501691AC63C
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbgDPOgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:36:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728386AbgDPOgN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 10:36:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03GEY9Ow119503;
        Thu, 16 Apr 2020 10:35:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30er1uat0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 10:35:51 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03GEYInN120080;
        Thu, 16 Apr 2020 10:35:51 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30er1uat09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 10:35:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03GEZ9R6014158;
        Thu, 16 Apr 2020 14:35:50 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 30b5h6tv09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 14:35:50 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03GEZniB44827120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 14:35:49 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 506E6112061;
        Thu, 16 Apr 2020 14:35:48 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF8A112062;
        Thu, 16 Apr 2020 14:35:47 +0000 (GMT)
Received: from cpe-172-100-172-46.stny.res.rr.com (unknown [9.85.128.208])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 16 Apr 2020 14:35:47 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <20200414140838.54f777b8.cohuck@redhat.com>
 <0f193571-1ff6-08f3-d02d-b4f40d2930c8@linux.ibm.com>
 <20200416120544.053b38d8.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <78116a88-7571-1ac9-40e1-6c1081c81467@linux.ibm.com>
Date:   Thu, 16 Apr 2020 10:35:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416120544.053b38d8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_05:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=11 spamscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160101
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/16/20 6:05 AM, Cornelia Huck wrote:
> On Wed, 15 Apr 2020 13:10:18 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 4/14/20 8:08 AM, Cornelia Huck wrote:
>>> On Tue,  7 Apr 2020 15:20:03 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>> @@ -995,9 +996,11 @@ int ap_parse_mask_str(const char *str,
>>>>    	newmap = kmalloc(size, GFP_KERNEL);
>>>>    	if (!newmap)
>>>>    		return -ENOMEM;
>>>> -	if (mutex_lock_interruptible(lock)) {
>>>> -		kfree(newmap);
>>>> -		return -ERESTARTSYS;
>>>> +	if (lock) {
>>>> +		if (mutex_lock_interruptible(lock)) {
>>>> +			kfree(newmap);
>>>> +			return -ERESTARTSYS;
>>>> +		}
>>> This whole function is a bit odd. It seems all masks we want to
>>> manipulate are always guarded by the ap_perms_mutex, and the need for
>>> allowing lock == NULL comes from wanting to call this function with the
>>> ap_perms_mutex already held.
>>>
>>> That would argue for a locked/unlocked version of this function... but
>>> looking at it, why do we lock the way we do? The one thing this
>>> function (prior to this patch) does outside of the holding of the mutex
>>> is the allocation and freeing of newmap. But with this patch, we do the
>>> allocation and freeing of newmap while holding the mutex. Something
>>> seems a bit weird here.
>> Note that the ap_parse_mask function copies the newmap
>> to the bitmap passed in as a parameter to the function.
>> Prior to the introduction of this patch, the calling functions - i.e.,
>> apmask_store(), aqmask_store() and ap_perms_init() - passed
>> in the actual bitmap (i.e., ap_perms.apm or ap_perms aqm),
>> so the ap_perms were changed directly by this function.
>>
>> With this patch, the apmask_store() and aqmask_store()
>> functions now pass in a copy of those bitmaps. This is so
>> we can verify that any APQNs being removed are not
>> in use by the vfio_ap device driver before committing the
>> change to ap_perms. Consequently, it is now necessary
>> to take the lock for the until the changes are committed.
> Yes, but every caller actually takes the mutex before calling this
> function already :)

That is not a true statement, the ap_perms_init() function
does not take the mutex prior to calling this function. Keep in
mind, the ap_parse_mask function is not static and is exported,
I was precluded from removing the lock parameter from the function
definition.

>
>> Having explained that, you make a valid argument that
>> this calls for a locked/unlocked version of this function, so
>> I will modify this patch to that effect.
> Ok.
>
> The other thing I found weird is that the function does
> alloc newmap -> grab mutex -> do manipulation -> release mutex -> free newmap
> while the new callers do
> (mutex already held) -> alloc newmap
>
> so why grab/release the mutex the way the function does now? IOW, why
> not have an unlocked __ap_parse_mask_string() and do

In my last comment above, I agreed to create an unlocked version
of this function. Your example below is similar to what I
implemented after responding to your comment yesterday.

>
> int ap_parse_mask_string(...)
> {
> 	int rc;
>
> 	if (mutex_lock_interruptible(&ap_perms_mutex))
> 		return -ERESTARTSYS;
> 	rc = __ap_parse_mask_string(...);
>          mutex_unlock(&ap_perms_mutex);
> 	return rc;
> }


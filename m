Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30A9350275
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhCaOgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 10:36:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235835AbhCaOge (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 10:36:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VEWvYd149155;
        Wed, 31 Mar 2021 10:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rcCa/v/+J0NqSpgbBHqnlhizh/g5c/c8dt5640dLkIo=;
 b=VNjd6V9HaHhDmNjc8+ZYiQZXcnmFfjUaqk+A9lLhvkO7Q6qiYlTWscZrdpWYpkpEUdK/
 TLpiY8mYhtu0WoTeSi3WG5tXjOSNbEfaeWVl8TwFKO72kP9L+gr1Oe6QBPvR15ZRQT9O
 MkSBkU7GIxawBa/TeyzRtUkVThjWBPXC4FtlMjT/0yDczoo7Qw6JA2NGi6iVrqW2YShK
 ZUsHU+URUIpBdvKWowXCDFulbZIk7HAxfJTmw56tA4T1NrHXJwhlDMmI9dxUceUU4MX3
 dULbiS1x/sVLXispEImIKTNyTVUu7zvrpk0cQUNtAjgOjLcDZjOE2OWUVUIAWmbEhT7+ kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mt98hqf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 10:36:28 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VEY1jf157283;
        Wed, 31 Mar 2021 10:36:28 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mt98hqep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 10:36:27 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VELrI9015730;
        Wed, 31 Mar 2021 14:36:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 37maarwkgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 14:36:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VEaPXD9241498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 14:36:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 090B2112065;
        Wed, 31 Mar 2021 14:36:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C392112061;
        Wed, 31 Mar 2021 14:36:24 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.146.149])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 31 Mar 2021 14:36:24 +0000 (GMT)
Subject: Re: [PATCH v13 06/15] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-7-akrowiak@linux.ibm.com>
 <20210111214037.477f0f03.pasic@linux.ibm.com>
 <270e192b-b88d-b072-428c-6cbfc0f9a280@linux.ibm.com>
 <20210115024441.1d8f41bc.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <762bee4a-7daa-948a-2054-41b3e172fa8c@linux.ibm.com>
Date:   Wed, 31 Mar 2021 10:36:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210115024441.1d8f41bc.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZLXsEjiyn207Jpp_SaIZ_TdQVxW0s_qI
X-Proofpoint-ORIG-GUID: GcTU25s7Xa9-9JZAQP3tS2rzjxyjKl38
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_03:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103300000 definitions=main-2103310105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/21 8:44 PM, Halil Pasic wrote:
> On Thu, 14 Jan 2021 12:54:39 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>>    /**
>>>>     * vfio_ap_mdev_verify_no_sharing
>>>>     *
>>>> - * Verifies that the APQNs derived from the cross product of the AP adapter IDs
>>>> - * and AP queue indexes comprising the AP matrix are not configured for another
>>>> - * mediated device. AP queue sharing is not allowed.
>>>> + * Verifies that each APQN derived from the Cartesian product of the AP adapter
>>>> + * IDs and AP queue indexes comprising the AP matrix are not configured for
>>>> + * another mediated device. AP queue sharing is not allowed.
>>>>     *
>>>> - * @matrix_mdev: the mediated matrix device
>>>> + * @matrix_mdev: the mediated matrix device to which the APQNs being verified
>>>> + *		 are assigned.
>>>> + * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>>>> + * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
>>>>     *
>>>> - * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
>>>> + * Returns 0 if the APQNs are not shared, otherwise; returns -EBUSY.
>>>>     */
>>>> -static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>>> +static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>>>> +					  unsigned long *mdev_apm,
>>>> +					  unsigned long *mdev_aqm)
>>>>    {
>>>>    	struct ap_matrix_mdev *lstdev;
>>>>    	DECLARE_BITMAP(apm, AP_DEVICES);
>>>> @@ -523,20 +426,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>>>    		 * We work on full longs, as we can only exclude the leftover
>>>>    		 * bits in non-inverse order. The leftover is all zeros.
>>>>    		 */
>>>> -		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
>>>> -				lstdev->matrix.apm, AP_DEVICES))
>>>> +		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
>>>>    			continue;
>>>>    
>>>> -		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
>>>> -				lstdev->matrix.aqm, AP_DOMAINS))
>>>> +		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
>>>>    			continue;
>>>>    
>>>> -		return -EADDRINUSE;
>>>> +		vfio_ap_mdev_log_sharing_err(dev_name(mdev_dev(lstdev->mdev)),
>>>> +					     apm, aqm);
>>>> +
>>>> +		return -EBUSY;
>>> Why do we change -EADDRINUSE to -EBUSY? This gets bubbled up to
>>> userspace, or? So a tool that checks for the other mdev has it
>>> condition by checking for -EADDRINUSE, would be confused...
>> Back in v8 of the series, Christian suggested the occurrences
>> of -EADDRINUSE should be replaced by the more appropriate
>> -EBUSY (Message ID <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>),
>> so I changed it here. It does get bubbled up to userspace, so you make a
>> valid point. I will
>> change it back. I will, however, set the value returned from the
>> __verify_card_reservations() function in ap_bus.c to -EBUSY as
>> suggested by Christian.
> As long as the error code for an ephemeral failure due to can't take a
> lock right now, and the error code for a failure due to a sharing
> conflict are (which most likely requires admin action to be resolved)
> I'm fine.
>
> Choosing EBUSY for sharing conflict, and something else for can't take
> lock for the bus attributes, while choosing EADDRINUSE for sharing
> conflict, and EBUSY for can't take lock in the case of the mdev
> attributes (assign_*; unassign_*) sounds confusing to me, but is still
> better than collating the two conditions. Maybe we can choose EAGAIN
> or EWOULDBLOCK for the can't take the lock right now. I don't know.

I was in the process of creating the change log for v14 of
this patch series and realized I never addressed this.
I think EAGAIN would be a better return code for the
mutex_trylock failures in the mdev assign/unassign
operations.

>
> I'm open to suggestions. And if Christian wants to change this for
> the already released interfaces, I will have to live with that. But it
> has to be a conscious decision at least.
>
> What I consider tricky about EBUSY, is that according to my intuition,
> in pseudocode, object.operation(argument) returns -EBUSY probably tells
> me that object is busy (i.e. is in the middle of something incompatible
> with performing operation). In our case, it is not the object that is
> busy, but the resource denoted by the argument.
>
> Regards,
> Halil


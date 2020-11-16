Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC42B4BE3
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 17:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732353AbgKPQ60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 11:58:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730972AbgKPQ60 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 11:58:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGGWuhp157360;
        Mon, 16 Nov 2020 11:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3R5bS2vafexITrshh0F0yPt+8kiKgCE+0A96OagB+Mk=;
 b=E12EJbKW5GvEsIo0EyF5NCn+b4/ddbZHuQtn0y7c6P9gvSXbHb+nwBpnpWQHwKzTAL83
 roeOKHpmIJ0arFlob5udEpUOTvvgAsu+y3JQdZisK3nhPti4qLGt0uLgd8E4mt8q9xeA
 PbxTl8bHxAU1CqfvkdFEv/p7xCGngtsQglhSHObLNw0gmUwLyEEg9AGSUYHwibmLwpnW
 QM0zwP3/r78ZZ3Lfwp/NptXI/uItXaaYFKcU0jBJ2NV5v1cQsOEO/RTRXMt04dgZMire
 nuxciSlNXzLewigU18YFHritc1zf8MZtG1B+zcVP3b6GWKbIiKtATX0HDnd5tBzOUkAu +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uvwxgtn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:58:24 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AGGrQVZ102861;
        Mon, 16 Nov 2020 11:58:24 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uvwxgtmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:58:24 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGGsbfP019187;
        Mon, 16 Nov 2020 16:58:23 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 34t6v905ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 16:58:23 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGGwEm08520238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 16:58:14 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 093456E050;
        Mon, 16 Nov 2020 16:58:20 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 893B96E04E;
        Mon, 16 Nov 2020 16:58:18 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 16:58:18 +0000 (GMT)
Subject: Re: [PATCH v11 05/14] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-6-akrowiak@linux.ibm.com>
 <20201027142711.1b57825e.pasic@linux.ibm.com>
 <6a5feb16-46b5-9dca-7e85-7d344b0ffa24@linux.ibm.com>
 <20201114004722.76c999e0.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <cfa19823-5e75-1d4e-d174-eabaf9541788@linux.ibm.com>
Date:   Mon, 16 Nov 2020 11:58:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201114004722.76c999e0.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_08:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 suspectscore=3 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/13/20 6:47 PM, Halil Pasic wrote:
> On Fri, 13 Nov 2020 12:14:22 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> [..]
>>>>    }
>>>>    
>>>> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
>>>> +			 "already assigned to %s"
>>>> +
>>>> +static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
>>>> +					 unsigned long *apm,
>>>> +					 unsigned long *aqm)
>>>> +{
>>>> +	unsigned long apid, apqi;
>>>> +
>>>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>>>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
>>>> +			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);
>>> Isn't error rather severe for this? For my taste even warning would be
>>> severe for this.
>> The user only sees a EADDRINUSE returned from the sysfs interface,
>> so Conny asked if I could log a message to indicate which APQNs are
>> in use by which mdev. I can change this to an info message, but it
>> will be missed if the log level is set higher. Maybe Conny can put in
>> her two cents here since she asked for this.
>>
> I'm looking forward to Conny's opinion. :)
>
> [..]
>>>>    
>>>> @@ -708,18 +732,18 @@ static ssize_t assign_adapter_store(struct device *dev,
>>>>    	if (ret)
>>>>    		goto done;
>>>>    
>>>> -	set_bit_inv(apid, matrix_mdev->matrix.apm);
>>>> +	memset(apm, 0, sizeof(apm));
>>>> +	set_bit_inv(apid, apm);
>>>>    
>>>> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
>>>> +	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
>>>> +					     matrix_mdev->matrix.aqm);
>>> What is the benefit of using a copy here? I mean we have the vfio_ap lock
>>> so nobody can see the bit we speculatively flipped.
>> The vfio_ap_mdev_verify_no_sharing() function definition was changed
>> so that it can also be re-used by the vfio_ap_mdev_resource_in_use()
>> function rather than duplicating that code for the in_use callback. The
>> in-use callback is invoked by the AP bus which has no concept of
>> a mediated device, so I made this change to accommodate that fact.
> Seems I was not clear enough with my question. Here you pass a local
> apm which has the every bit 0 except the one corresponding to the
> adapter we are trying to assign. The matrix.apm actually may have
> more apm bits set. What we used to do, is set the matrix.apm bit,
> verify, and clear it if verification fails. I think that
> would still work.
>
> The computational complexity is currently the same. For
> some reason unknown to me ap_apqn_in_matrix_owned_by_def_drv() uses loops
> instead of using bitmap operations. But it won't do any less work
> if the apm argument is sparse. Same is true bitmap ops are used.
>
> What you do here is not wrong, because if the invariants, which should
> be maintained, are maintained, performing the check with the other
> bits set in the apm is superfluous. But as I said before, actually
> it ain't extra work, and if there was a bug, it could help us detect
> it (because the assignment, that should have worked would fail).
>
> Preparing the local apm isn't much extra work either, but I still
> don't understand the change. Why can't you pass in matrix.apm
> after set_bit_inv(apid, ...) like we use to do before?
>
> Again, no big deal, but I just prefer to understand the whys.

I think you misunderstood what I was saying, probably because
I didn't explain it very thoroughly or clearly. The change was not
made to reduce the amount of work done in the
vfio_ap_mdev_verify_no_sharing() function.


If the assignment functions were the only ones to call the
vfio_ap_mdev_verify_no_sharing() function, then you'd be correct;
there would be no good reason not to set the apid in the
matrix_mdev->matrix.apm/aqm as we used to. The modification
was made to accommodate the vfio_ap_mdev_resource_in_use() function.

The vfio_ap_mdev_resource_in_use() function is invoked by the
AP bus when a change is made to the apmask/aqmask that
will result in taking queues away from vfio_ap. This function
needs to verify that the affected APQNs are not assigned to
any matrix mdev. Rather than write a new function that duplicates
the logic in the vfio_ap_mdev_verify_no_sharing() function, I merely
changed the signature to take the apm/aqm specifying the APQNs to
verify rather than obtaining them from the matrix_mdev. The
reason for this is because the bitmaps passed to the in_use
callback are not specific to a particular matrix_mdev as is the
case with the assignment interfaces. Making this change allowed the
vfio_ap_mdev_verify_no_sharing() function to be used by both the
assignment functions as well as the in_use callback.

I suppose another option
would have been to create a phony matrix_mdev in the in_use
callback and copy the masks passed in to the function to the
phony matrix_mdev's apm/aqm. That would have eliminated
the need to change the signature of the vfio_ap_mdev_verify_no_sharing()
function, but I'm not sure it is worth the effort at this point.

>>> I've also pointed out in the previous patch that in_use() isn't
>>> perfectly reliable (at least in theory) because of a race.
>> We discussed that privately and determined that the sysfs assignment
>> interfaces will use mutex_trylock() to avoid races.
> I don't think, what we discussed is going to fix the race I'm referring
> to here. But I do look forward to v12.
>
> Regards,
> Halil


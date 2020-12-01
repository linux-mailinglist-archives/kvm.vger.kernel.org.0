Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55872C93CE
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbgLAAUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:20:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727373AbgLAAUd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 19:20:33 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B101ktQ030702;
        Mon, 30 Nov 2020 19:19:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4kqjVnTfUG35zYASfhjdjsLm/CbunhxxcqkwdknYhPQ=;
 b=dn3+ngPHbcLxjfFY25Hisa23mmrOLRrc79Omy/gUkin+zkjr1S4VN1FMYQbGcsgfxI2I
 vB1icZO9yGKdZtXBvNQZVAT+YdMG+lUkeEpvnhmdFIf/VW8NFXshUUJvm/u3lBSNNsyB
 J+9M0sd+1TAkFR4g0n5doOJ1sZRcewOIP7m7FIuCARLzQHdeADNrQzG7RffpWHhKzxSy
 ZoTHkrobZAIyx8TCeNA8WtMNO1OFQr6/KGR7mGQt1ZJCTINGGbP0GgPoLGTGEtxekgh7
 P6BsRCZmowqYDs6O/MVM2B8PLr4Bmjgst+ASev891xGY9wzikDtnTUVNBEI7Pmcnj4iS KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3558evmbw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 19:19:49 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B10AV7D073491;
        Mon, 30 Nov 2020 19:19:49 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3558evmbw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 19:19:49 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B10EPZe016197;
        Tue, 1 Dec 2020 00:19:48 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 353e68vm7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 00:19:48 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B10IV3l22741996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 00:18:32 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBE8EAC05B;
        Tue,  1 Dec 2020 00:18:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09E34AC05F;
        Tue,  1 Dec 2020 00:18:31 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.195.249])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 00:18:30 +0000 (GMT)
Subject: Re: [PATCH v12 12/17] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-13-akrowiak@linux.ibm.com>
 <20201129025250.16eb8355.pasic@linux.ibm.com>
 <103cbe02-2093-c950-8d65-d3dc385942ce@linux.ibm.com>
 <20201201003227.0c3696fc.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <65834705-347c-1e8d-f33f-b64bc2501b37@linux.ibm.com>
Date:   Mon, 30 Nov 2020 19:18:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201201003227.0c3696fc.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=3 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/30/20 6:32 PM, Halil Pasic wrote:
> On Mon, 30 Nov 2020 14:36:10 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>
>> On 11/28/20 8:52 PM, Halil Pasic wrote:
> [..]
>>>> * Unassign adapter from mdev's matrix:
>>>>
>>>>     The domain will be hot unplugged from the KVM guest if it is
>>>>     assigned to the guest's matrix.
>>>>
>>>> * Assign a control domain:
>>>>
>>>>     The control domain will be hot plugged into the KVM guest if it is not
>>>>     assigned to the guest's APCB. The AP architecture ensures a guest will
>>>>     only get access to the control domain if it is in the host's AP
>>>>     configuration, so there is no risk in hot plugging it; however, it will
>>>>     become automatically available to the guest when it is added to the host
>>>>     configuration.
>>>>
>>>> * Unassign a control domain:
>>>>
>>>>     The control domain will be hot unplugged from the KVM guest if it is
>>>>     assigned to the guest's APCB.
>>> This is where things start getting tricky. E.g. do we need to revise
>>> filtering after an unassign? (For example an assign_adapter X didn't
>>> change the shadow, because queue XY was missing, but now we unplug domain
>>> Y. Should the adapter X pop up? I guess it should.)
>> I suppose that makes sense at the expense of making the code
>> more complex. It is essentially what we had in the prior version
>> which used the same filtering code for assignment as well as
>> host AP configuration changes.
>>
> Will have to think about it some more. Making the user unplug and
> replug an adapter because at some point it got filtered, but there
> is no need to filter it does not feel right. On the other hand, I'm
> afraid I'm complaining in circles.
>
>>>
>>>> Note: Now that hot plug/unplug is implemented, there is the possibility
>>>>         that an assignment/unassignment of an adapter, domain or control
>>>>         domain could be initiated while the guest is starting, so the
>>>>         matrix device lock will be taken for the group notification callback
>>>>         that initializes the guest's APCB when the KVM pointer is made
>>>>         available to the vfio_ap device driver.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 190 +++++++++++++++++++++++++-----
>>>>    1 file changed, 159 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index 586ec5776693..4f96b7861607 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -631,6 +631,60 @@ static void vfio_ap_mdev_manage_qlinks(struct ap_matrix_mdev *matrix_mdev,
>>>>    	}
>>>>    }
>>>>    
>>>> +static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
>>>> +					unsigned long apid)
>>>> +{
>>>> +	unsigned long apqi, apqn;
>>>> +	unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
>>>> +
>>>> +	/*
>>>> +	 * If the APID is already assigned to the guest's shadow APCB, there is
>>>> +	 * no need to assign it.
>>>> +	 */
>>>> +	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
>>>> +		return false;
>>>> +
>>>> +	/*
>>>> +	 * If no domains have yet been assigned to the shadow APCB and one or
>>>> +	 * more domains have been assigned to the matrix mdev, then use
>>>> +	 * the domains assigned to the matrix mdev; otherwise, there is nothing
>>>> +	 * to assign to the shadow APCB.
>>>> +	 */
>>>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS)) {
>>>> +		if (bitmap_empty(matrix_mdev->matrix.aqm, AP_DOMAINS))
>>>> +			return false;
>>>> +
>>>> +		aqm = matrix_mdev->matrix.aqm;
>>>> +	}
>>>> +
>>>> +	/* Make sure all APQNs are bound to the vfio_ap driver */
>>>> +	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
>>>> +		apqn = AP_MKQID(apid, apqi);
>>>> +
>>>> +		if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
>>>> +			return false;
>>>> +	}
>>>> +
>>>> +	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>>>> +
>>>> +	/*
>>>> +	 * If we verified APQNs using the domains assigned to the matrix mdev,
>>>> +	 * then copy the APQIs of those domains into the guest's APCB
>>>> +	 */
>>>> +	if (bitmap_empty(matrix_mdev->shadow_apcb.aqm, AP_DOMAINS))
>>>> +		bitmap_copy(matrix_mdev->shadow_apcb.aqm,
>>>> +			    matrix_mdev->matrix.aqm, AP_DOMAINS);
>>>> +
>>>> +	return true;
>>>> +}
>>> What is the rationale behind the shadow aqm empty special handling?
>> The rationale was to avoid taking the VCPUs
>> out of SIE in order to make an update to the guest's APCB
>> unnecessarily. For example, suppose the guest is started
>> without access to any APQNs (i.e., all matrix and shadow_apcb
>> masks are zeros). Now suppose the administrator proceeds to
>> start assigning AP resources to the mdev. Let's say he starts
>> by assigning adapters 1 through 100. The code below will return
>> true indicating the shadow_apcb was updated. Consequently,
>> the calling code will commit the changes to the guest's
>> APCB. The problem there is that in order to update the guest's
>> VCPUs, they will have to be taken out of SIE, yet the guest will
>> not get access to the adapter since no domains have yet been
>> assigned to the APCB. Doing this 100 times - once for each
>> adapter 1-100 - is probably a bad idea.
>>
> Not yanking the VCPUs out of SIE does make a lot of sense. At least
> I understand your motivation now. I will think some more about this,
> but in the meanwhile, please try to answer one more question (see
> below).
>   
>>>    I.e.
>>> why not simply:
>>>
>>>
>>> static bool vfio_ap_assign_apid_to_apcb(struct ap_matrix_mdev *matrix_mdev,
>>>                                           unsigned long apid)
>>> {
>>>           unsigned long apqi, apqn;
>>>           unsigned long *aqm = matrix_mdev->shadow_apcb.aqm;
>>>                                                                                   
>>>           /*
>>>            * If the APID is already assigned to the guest's shadow APCB, there is
>>>            * no need to assign it.
>>>            */
>>>           if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm))
>>>                   return false;
>>>                                                                                   
>>>           /* Make sure all APQNs are bound to the vfio_ap driver */
>>>           for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
>>>                   apqn = AP_MKQID(apid, apqi);
>>>                                                                                   
>>>                   if (vfio_ap_mdev_get_queue(matrix_mdev, apqn) == NULL)
>>>                           return false;
>>>           }
>>>                                                                                   
>>>           set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
>>>                                                                                   
>>>           return true;
> Would
> s/return true/return !bitmap_empty(matrix_mdev->shadow_apcb.aqm,
> AP_DOMAINS)/
> do the trick?
>
> I mean if empty, then we would not commit the APCB, so we would
> not take the vCPUs out of SIE -- see below.

At first glance I'd say yes, it does the trick; but, I need to consider
all possible scenarios. For example, that will work fine when someone
either assigns all of the adapters or all of the domains first, then assigns
the other.

>
>>>> +
>>>> +static void vfio_ap_mdev_hot_plug_adapter(struct ap_matrix_mdev *matrix_mdev,
>>>> +					  unsigned long apid)
>>>> +{
>>>> +	if (vfio_ap_assign_apid_to_apcb(matrix_mdev, apid))
>>>> +		vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>>>> +}
>>>> +
> [..]
>
> Regards,
> Halil


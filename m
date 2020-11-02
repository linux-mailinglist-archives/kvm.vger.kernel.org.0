Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1408A2A2D10
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 15:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgKBOgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 09:36:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgKBOgA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 09:36:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2EWn0v048477;
        Mon, 2 Nov 2020 09:35:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b7I5sNXEMJ08KuQzqBBjubSlvLzoNo1iWKblvYCHXlE=;
 b=fA5wTIdH/DpCUT6/jNdfS1Yq9MbuWASpftXoqnx76IdB0VS4QYXO0BTiDsWbZiM20bia
 nxVM1RB9e8Cx6IfzETE17L45ZPdGX5Gi0VOLfI5fTlHKrQ7HKpDG7YcPs0tet21vWEI8
 NMdPab5/zubqCxZetAClf4SN2GXiGVK+e+KX0CfOS3bBosEENcz7IcTgRop07i2U6gHa
 r0L06OpEy21WyhSbbISXUpCiORkS9nBQ4svZAzcUhWft3l4Khlax1B2wtJ38rlrhlxvS
 zTiMOLtczoiG3O4pI60NeJf1zWl/qy2KFRUMfKe4rD+X0WBoNTPwBOySrIsMEMF2bDAZ Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34jfjpgwpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 09:35:52 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A2EXI2K052483;
        Mon, 2 Nov 2020 09:35:52 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34jfjpgwp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 09:35:52 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2EX3sg006891;
        Mon, 2 Nov 2020 14:35:51 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 34hs32e1ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:35:51 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2EZnB521627846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 14:35:49 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8FF9AE05C;
        Mon,  2 Nov 2020 14:35:49 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9766AE063;
        Mon,  2 Nov 2020 14:35:48 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 14:35:48 +0000 (GMT)
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-2-akrowiak@linux.ibm.com>
 <20201027074846.30ee0ddc.pasic@linux.ibm.com>
 <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
 <20201030184242.3bceee09.pasic@linux.ibm.com>
 <cb40a506-4a17-3562-728c-cbb57cd99817@linux.ibm.com>
 <20201031044329.77b5a249.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <76140b31-a747-0f4e-438f-835ba13752d5@linux.ibm.com>
Date:   Mon, 2 Nov 2020 09:35:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201031044329.77b5a249.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_07:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 phishscore=0 adultscore=0 suspectscore=11 impostorscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=989 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/20 11:43 PM, Halil Pasic wrote:
> On Fri, 30 Oct 2020 16:37:04 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 10/30/20 1:42 PM, Halil Pasic wrote:
>>> On Thu, 29 Oct 2020 19:29:35 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>>>> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>>>>>     			 */
>>>>>>     			if (ret)
>>>>>>     				rc = ret;
>>>>>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>>>>>> +			q = vfio_ap_get_queue(matrix_mdev,
>>>>>> +					      AP_MKQID(apid, apqi));
>>>>>> +			if (q)
>>>>>> +				vfio_ap_free_aqic_resources(q);
>>>>> Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
>>>>> think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
>>>>> in particular guarantee that the reset is actually done when we arrive
>>>>> here)? BTW, I think we have a similar problem with the current code as
>>>>> well.
>>>> If the return code from the vfio_ap_mdev_reset_queue() function
>>>> is zero, then yes, we are guaranteed the reset was done and the
>>>> queue is empty.
>>> I've read up on this and I disagree. We should discuss this offline.
>> Maybe you are confusing things here; my statement is specific to the return
>> code from the vfio_ap_mdev_reset_queue() function, not the response code
>> from the PQAP(ZAPQ) instruction. The vfio_ap_mdev_reset_queue()
>> function issues the PQAP(ZAPQ) instruction and if the status response code
>> is 0 indicating the reset was successfully initiated, it waits for the
>> queue to empty. When the queue is empty, it returns 0 to indicate
>> the queue is reset.
>> If the queue does not become empty after a period of
>> time,
>> it will issue a warning (WARN_ON_ONCE) and return 0. In that case, I suppose
>> there is no guarantee the reset was done, so maybe a change needs to be
>> made there such as a non-zero return code.
>>
> I've overlooked the wait for empty. Maybe that return 0 had a part in
> it. I now remember me insisting on having the wait code added when the
> interrupt support was in the make. Sorry!
>
> If we have given up on out of retries retries, we are in trouble anyway.
>   
>>>   
>>>>     The function returns a non-zero return code if
>>>> the reset fails or the queue the reset did not complete within a given
>>>> amount of time, so maybe we shouldn't free AQIC resources when
>>>> we get a non-zero return code from the reset function?
>>>>   
>>> If the queue is gone, or broken, it won't produce interrupts or poke the
>>> notifier bit, and we should clean up the AQIC resources.
>> True, which is what the code provided by this patch does; however,
>> the AQIC resources should be cleaned up only if the KVM pointer is
>> not NULL for reasons discussed elsewhere.
> Yes, but these should be cleaned up before the KVM pointer becomes
> null. We don't want to keep the page with the notifier byte pinned
> forever, or?

No, we do not want to keep the page forever. I probably should
have been clearer. There are times we do a reset - e.g., on remove
of the mdev - at which time there should be no KVM pointer, or
else the remove will not be allowed. Of course, we won't do the
reset either, so I guess you can ignore my comment. If there is
no KVM pointer yet a page remains pinned, something bad
happened.



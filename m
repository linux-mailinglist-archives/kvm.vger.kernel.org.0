Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD5A2A0F99
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgJ3UhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:37:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726917AbgJ3UhL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 16:37:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UKWIjh181410;
        Fri, 30 Oct 2020 16:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f70IDi3im0uFHhB0FE1ptDsP3gTes1jmkgkTotqey20=;
 b=RQutl5R53xbaO9CwRSErOhmPN+pEHSxKFEuf1O3F6k1l5Mx0IbHy/nG9AO0Tmeq7yfPo
 uh82S6hPJKeU1zs3Zvq6O6xD2t43UkNOwaB401uvPxVMQuzqvlgrEDe0mCU7qPqHCHqr
 D5PIRVAyKpCvA+eiqNAQRbZRQ6szUT8dOawnym2OnpU7S1DisRJYAxYUODsIUhJLg+Tk
 Cyi0jzYxiFfUMh2fJuKm8PxC1dkntUayMU/mzNwXZ6ClLyqdM2fcm7iI/WlZhGfuD0uS
 nKmFCuRmZ6tSw51AJ332wD7JG4iCIuD8mEzFj0rbv9wmA5kLJgHlLTLj3cdFxgWo3l4F Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gfp4ucfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 16:37:08 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UKXi9R188225;
        Fri, 30 Oct 2020 16:37:08 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gfp4ucfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 16:37:08 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UKZMkb016362;
        Fri, 30 Oct 2020 20:37:07 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 34dy04w0v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 20:37:07 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UKb5Ie54133058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 20:37:05 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA2A8112066;
        Fri, 30 Oct 2020 20:37:05 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01691112061;
        Fri, 30 Oct 2020 20:37:04 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 20:37:04 +0000 (GMT)
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <cb40a506-4a17-3562-728c-cbb57cd99817@linux.ibm.com>
Date:   Fri, 30 Oct 2020 16:37:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201030184242.3bceee09.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_10:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=11
 phishscore=0 impostorscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/20 1:42 PM, Halil Pasic wrote:
> On Thu, 29 Oct 2020 19:29:35 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>>>    			 */
>>>>    			if (ret)
>>>>    				rc = ret;
>>>> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>>>> +			q = vfio_ap_get_queue(matrix_mdev,
>>>> +					      AP_MKQID(apid, apqi));
>>>> +			if (q)
>>>> +				vfio_ap_free_aqic_resources(q);
>>> Is it safe to do vfio_ap_free_aqic_resources() at this point? I don't
>>> think so. I mean does the current code (and vfio_ap_mdev_reset_queue()
>>> in particular guarantee that the reset is actually done when we arrive
>>> here)? BTW, I think we have a similar problem with the current code as
>>> well.
>> If the return code from the vfio_ap_mdev_reset_queue() function
>> is zero, then yes, we are guaranteed the reset was done and the
>> queue is empty.
> I've read up on this and I disagree. We should discuss this offline.

Maybe you are confusing things here; my statement is specific to the return
code from the vfio_ap_mdev_reset_queue() function, not the response code
from the PQAP(ZAPQ) instruction. The vfio_ap_mdev_reset_queue()
function issues the PQAP(ZAPQ) instruction and if the status response code
is 0 indicating the reset was successfully initiated, it waits for the
queue to empty. When the queue is empty, it returns 0 to indicate
the queue is reset. If the queue does not become empty after a period of 
time,
it will issue a warning (WARN_ON_ONCE) and return 0. In that case, I suppose
there is no guarantee the reset was done, so maybe a change needs to be
made there such as a non-zero return code.

>
>>    The function returns a non-zero return code if
>> the reset fails or the queue the reset did not complete within a given
>> amount of time, so maybe we shouldn't free AQIC resources when
>> we get a non-zero return code from the reset function?
>>
> If the queue is gone, or broken, it won't produce interrupts or poke the
> notifier bit, and we should clean up the AQIC resources.

True, which is what the code provided by this patch does; however,
the AQIC resources should be cleaned up only if the KVM pointer is
not NULL for reasons discussed elsewhere.

>
>
>> There are three occasions when the vfio_ap_mdev_reset_queues()
>> is called:
>> 1. When the VFIO_DEVICE_RESET ioctl is invoked from userspace
>>       (i.e., when the guest is started)
>> 2. When the mdev fd is closed (vfio_ap_mdev_release())
>> 3. When the mdev is removed (vfio_ap_mdev_remove())
>>
>> The IRQ resources are initialized when the PQAP(AQIC)
>> is intercepted to enable interrupts. This would occur after
>> the guest boots and the AP bus initializes. So, 1 would
>> presumably occur before that happens. I couldn't find
>> anywhere in the AP bus or zcrypt code where a PQAP(AQIC)
>> is executed to disable interrupts, so my assumption is
>> that IRQ disablement is accomplished by a reset on
>> the guest. I'll have to ask Harald about that. So, 2 would
>> occur when the guest is about to terminate and 3
>> would occur only after the guest is terminated. In any
>> case, it seems that IRQ resources should be cleaned up.
>> Maybe it would be more appropriate to do that in the
>> vfio_ap_mdev_release() and vfio_ap_mdev_remove()
>> functions themselves?
> I'm a bit confused. But I think you are wrong. What happens when the
> guest reIPLs? I guess the subsystem reset should also do the
> VFIO_DEVICE_RESET ioctl, and that has to reset the queues and disable
> the interrupts. Or?

What did I say that is wrong? I think you are referring
to my statement about the VFIO_DEVICE_RESET ioctl.
I am not knowledgeable about all of the circumstances
under which the VFIO_DEVICE_RESET ioctl is invoked,
but I know for a fact that it is invoked when the guest is
started as I've verified that via tracing. On the other hand,
I suspect you are correct in assuming it is also invoked on
a subsystem reset from the guest, so that also argues for
cleaning up the IRQ resources after a reset as long as
the KVM pointer is valid.

>
> Regards,
> Halil
>


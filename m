Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849762A0FB3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 21:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgJ3Upo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 16:45:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25352 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgJ3Upo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 16:45:44 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UKWDKU135547;
        Fri, 30 Oct 2020 16:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VOkQSjnivK4KhbZjzb+9rNLE5wEpdz2pUCAHAP4sMqs=;
 b=Q3fBptPDeHz+mIlkcleENrK+YVDCVpY9OzJjPnfzlbac2PlxBAB7z2+9d6bkixTr9M9C
 KpdFKcBSF3DCuGXVixqo1Njlz864U2xSxudPwJIAeqYinvpicQZRzS5LYRpbqLlkbazA
 LKfvemskAvMMfGuh6HGHzhjZXjfVLe02mztZxLBH6sKJVX8u60zRuWeXT38SaJE6P72a
 x8Shbvxq6vMSVvcB+/MG2lyVddzKequxF24z2Id5moucPFp4W62tKyA8uBL0OcV5k8ZD
 HdtTIzcmc5KzHPn3owMd3mDTvQuzR+Btd8xuYPm+8VSHKlnv6/gAlIbqmcZpm9TLyt8M tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gm943nen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 16:45:41 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UKX4TL142611;
        Fri, 30 Oct 2020 16:45:41 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gm943ned-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 16:45:41 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UKhLLR026330;
        Fri, 30 Oct 2020 20:45:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 34dy04w2ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 20:45:40 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UKjcZJ30802334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 20:45:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3B13112061;
        Fri, 30 Oct 2020 20:45:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FB71112065;
        Fri, 30 Oct 2020 20:45:38 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 20:45:38 +0000 (GMT)
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
 <20201030182755.433e3e2d.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <9cc6be73-3ff2-3116-f1ab-f9b985d471e4@linux.ibm.com>
Date:   Fri, 30 Oct 2020 16:45:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201030182755.433e3e2d.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_10:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=4 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/20 1:27 PM, Halil Pasic wrote:
> On Thu, 29 Oct 2020 19:29:35 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 10/27/20 2:48 AM, Halil Pasic wrote:
>>> On Thu, 22 Oct 2020 13:11:56 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> The queues assigned to a matrix mediated device are currently reset when:
>>>>
>>>> * The VFIO_DEVICE_RESET ioctl is invoked
>>>> * The mdev fd is closed by userspace (QEMU)
>>>> * The mdev is removed from sysfs.
>>> What about the situation when vfio_ap_mdev_group_notifier() is called to
>>> tell us that our pointer to KVM is about to become invalid? Do we need to
>>> clean up the IRQ stuff there?
>> After reading this question, I decided to do some tracing using
>> printk's and learned that the vfio_ap_mdev_group_notifier()
>> function does not get called when the guest is shutdown. The reason
>> for this is because the vfio_ap_mdev_release() function, which is called
>> before the KVM pointer is invalidated, unregisters the group notifier.
>>
>> I took a look at some of the other drivers that register a group
>> notifier in the mdev_parent_ops.open callback and each unregistered
>> the notifier in the mdev_parent_ops.release callback.
>>
>> So, to answer your question, there is no need to cleanup the IRQ
>> stuff in the vfio_ap_mdev_group_notifier() function since it will
>> not get called when the KVM pointer is invalidated. The cleanup
>> should be done in the vfio_ap_mdev_release() function that gets
>> called when the mdev fd is closed.
> You say if vfio_ap_mdev_group_notifier() is called to tell us
> that KVM going away, then it is a bug?

If the notifier gets called after the notifier is unregistered then
yes, I would say that is a bug; however, my tracing showed that
the notifier does not get called precisely because it is unregistered
in the release callback.

>
> If that is the case, I would like that reflected in the code! By that I
> mean at logging an error at least (if not BUG_ON).

I do not know whether or not there are other circumstances under
which the notifier can get invoked before the release callback to
make notification that the KVM pointer has been invalidated, so
I don't think this would be appropriate. I think we should just
process the call by setting the matrix_mdev->kvm pointer to
NULL and decrement the reference count to kvm.

Maybe someone from the VFIO team can provide some better
insight.

>
> Regards,
> Halil


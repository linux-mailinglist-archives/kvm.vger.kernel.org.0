Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF763D1E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 23:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGIVL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 17:11:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbfGIVL1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jul 2019 17:11:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69L83Zx101361;
        Tue, 9 Jul 2019 17:11:24 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tn1bcjskg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 17:11:24 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x69L9eho030322;
        Tue, 9 Jul 2019 21:11:23 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk96fq36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 21:11:23 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69LBLiS36962590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 21:11:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 113D228059;
        Tue,  9 Jul 2019 21:11:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC6C82805C;
        Tue,  9 Jul 2019 21:11:20 +0000 (GMT)
Received: from [9.60.75.173] (unknown [9.60.75.173])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 21:11:20 +0000 (GMT)
Subject: Re: [PATCH v4 3/7] s390: zcrypt: driver callback to indicate resource
 in use
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
 <20190618182558.7d7e025a.cohuck@redhat.com>
 <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
 <20190701212643.0dd7d4ab.cohuck@redhat.com>
 <c771961d-f840-fe8a-09b7-a11b39a74d4c@linux.ibm.com>
 <20190709124920.3a910dca.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <089663dd-2e6d-cbb7-c1ef-a8a4b325abd3@linux.ibm.com>
Date:   Tue, 9 Jul 2019 17:11:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190709124920.3a910dca.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090253
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/19 6:49 AM, Cornelia Huck wrote:
> On Mon, 8 Jul 2019 10:27:11 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 7/1/19 3:26 PM, Cornelia Huck wrote:
>>> On Wed, 19 Jun 2019 09:04:18 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>>>> Allow me to first address your fear that a bad actor can hog
>>>> resources that can't be removed by root. With this enhancement,
>>>> there is nothing preventing a root user from taking resources
>>>> from a matrix mdev, it simply forces him/her to follow the
>>>> proper procedure. The resources to be removed must first be
>>>> unassigned from the matrix mdev to which they are assigned.
>>>> The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
>>>> sysfs attributes can then be edited to transfer ownership
>>>> of the resources to zcrypt.
>>>
>>> What is the suggested procedure when root wants to unbind a queue
>>> device? Find the mdev using the queue (is that easy enough?), unassign
>>> it, then unbind? Failing to unbind is a bit unexpected; can we point
>>> the admin to the correct mdev from which the queue has to be removed
>>> first?
>>
>> The proper procedure is to first unassign the adapter, domain, or both
>> from the mdev to which the APQN is assigned. The difficulty in finding
>> the queue depends upon how many mdevs have been created. I would expect
>> that an admin would keep records of who owns what, but in the case he or
>> she doesn't, it would be a matter of printing out the matrix attribute
>> of each mdev until you find the mdev to which the APQN is assigned.
> 
> Ok, so the information is basically available, if needed.
> 
>> The only means I know of for informing the admin to which mdev a given
>> APQN is assigned is to log the error when it occurs.
> 
> That might be helpful, if it's easy to do.
> 
>> I think Matt is
>> also looking to provide query functions in the management tool on which
>> he is currently working.
> 
> That also sounds helpful.
> 
> (...)
> 
>>>> * It forces the use of the proper procedure to change ownership of AP
>>>>      queues.
>>>
>>> This needs to be properly documented, and the admin needs to have a
>>> chance to find out why unbinding didn't work and what needs to be done
>>> (see my comments above).
>>
>> I will create a section in the vfio-ap.txt document that comes with this
>> patch set describing the proper procedure for unbinding queues. Of
>> course, we'll make sure the official IBM doc also more thoroughly
>> describes this.
> 
> +1 for good documentation.
> 
> With that, I don't really object to this change.

Then I will make the suggested changes and post v5 to the list.

> 


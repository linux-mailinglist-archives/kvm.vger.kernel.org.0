Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11F2A1004
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgJ3VNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:13:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbgJ3VNq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 17:13:46 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UL33lr025916;
        Fri, 30 Oct 2020 17:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+UCoz10mIKJN5QdeiOHCdJWdGEXY+xBbtN9gX1cbOmI=;
 b=YfPPzlSmi1aOozdN6kVWIJCVUzE/UaGvI4JOnBhPab3AKW6iwxmGueExemrdjKisqbzv
 e7+ODhhsvVm1vdaOxG0u4CRQei13WrcpnbhkvUMLd1Mm7qgIw5yDqCqY6+KvPO7kBbPH
 nGsUJZSW+yRkGGM66RUwv/wGWt4RuSqDMigDodFZqqAEwH0vOlqHxadp1drShSKGae4C
 YDapftjKQW6bi564DN/3KyCnlftqMcBc9JqOlq9/3cZebSWgQp5NZueSYoCpJRqZHfdN
 /Old1otEigyPUh48QuO0DG4odNqwWFJe8hNpT2J39W+KskJV7/pxbA8R8al0JJ5ez6Xj GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gtckr93x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:13:43 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UL5Ot7039103;
        Fri, 30 Oct 2020 17:13:42 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gtckr93k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:13:42 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09ULDa1c005372;
        Fri, 30 Oct 2020 21:13:41 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 34g1e25f4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 21:13:41 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09ULDd8r51970494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 21:13:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C142F112063;
        Fri, 30 Oct 2020 21:13:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DC91112061;
        Fri, 30 Oct 2020 21:13:39 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 21:13:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
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
 <20201030185406.7fa13fbe.pasic@linux.ibm.com>
 <d1aae333-3f10-bd21-257f-baf8f8df7a24@linux.ibm.com>
Message-ID: <684234fa-03a9-71cd-14f3-ddf9b06e7e2e@linux.ibm.com>
Date:   Fri, 30 Oct 2020 17:13:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d1aae333-3f10-bd21-257f-baf8f8df7a24@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_12:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=11 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/20 4:53 PM, Tony Krowiak wrote:
>
>
> On 10/30/20 1:54 PM, Halil Pasic wrote:
>> On Thu, 29 Oct 2020 19:29:35 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>>>> @@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct 
>>>>> mdev_device *mdev)
>>>>>                 */
>>>>>                if (ret)
>>>>>                    rc = ret;
>>>>> -            vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>>>>> +            q = vfio_ap_get_queue(matrix_mdev,
>>>>> +                          AP_MKQID(apid, apqi));
>>>>> +            if (q)
>>>>> +                vfio_ap_free_aqic_resources(q);
>> [..]
>>
>>>> Under what circumstances do we expect !q? If we don't, then we need to
>>>> complain one way or another.
>>> In the current code (i.e., prior to introducing the subsequent hot
>>> plug patches), an APQN can not be assigned to an mdev unless it
>>> references a queue device bound to the vfio_ap device driver; however,
>>> there is nothing preventing a queue device from getting unbound
>>> while the guest is running (one of the problems mostly resolved by this
>>> series). In that case, q would be NULL.
>> But if the queue does not belong to us any more it does not make sense
>> call vfio_ap_mdev_reset_queue() on it's APQN, or?
>
> This is precisely why we prevent a queue from being taken away
> from vfio_ap (the in-use callback) when its APQN is assigned to an
> mdev in this patch series. On the other hand, this is a very good
> point.
>
>>
>> I think we should have
>>
>> if(!q)
>>     continue;
>> at the very beginning of the loop body, or we want to be sure that q is
>> not null.
>
> I agree, I'll go ahead and make this change.

After thinking about this a bit more, I don't think it makes sense to make
this change in this patch. For the current implementation, it is incumbent
upon the system administrator to ensure that a queue device is not unbound
from the vfio_ap device driver if its APQN is assigned to an mdev, so the
assumption here is that any APQN assigned to the mdev is (or was) bound to
the vfio_ap driver. If it was erroneously unbound while in use by a guest,
then both the guest and possibly the zcrypt driver will have simultaneous
access (one of the things fixed by this patch series). In that case, I think
it ought to be reset regardless of whether it is bound to vfio_ap or not.

Having said that, I think it makes sense to make the change you recommend
in patch 03/14. In that patch, the vfio_ap_queue object is retrieved 
from the
matrix_mdev. Since these queue objects are linked only when the queue
device is probed and unlinked when the the queue device is removed and
a queue device can not get bound to another driver while its APQN is 
assigned
to an mdev, it would make perfect sense to forego reset of a queue when
its APQN is assigned to an mdev.

>
>
>
>
>>
>


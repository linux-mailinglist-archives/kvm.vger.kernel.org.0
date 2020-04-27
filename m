Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCF1BB177
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 00:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgD0WY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 18:24:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbgD0WY0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 18:24:26 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RMCmmD022616;
        Mon, 27 Apr 2020 18:24:23 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh6tmxjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 18:24:22 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03RMCvf9022847;
        Mon, 27 Apr 2020 18:24:22 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh6tmxj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 18:24:22 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RMKQ7u011028;
        Mon, 27 Apr 2020 22:24:21 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 30mcu6me2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 22:24:21 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RMOJIK54133022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 22:24:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B53A3124055;
        Mon, 27 Apr 2020 22:24:19 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40107124052;
        Mon, 27 Apr 2020 22:24:19 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.200.21])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 22:24:19 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <75bcbc06-f38f-1aff-138f-5d2a2dd3f7b6@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <162f7dbc-9dd0-0a42-0d1a-8412a9a848e7@linux.ibm.com>
Date:   Mon, 27 Apr 2020 18:24:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <75bcbc06-f38f-1aff-138f-5d2a2dd3f7b6@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_16:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=3 bulkscore=0 spamscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270175
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/27/20 4:20 AM, Pierre Morel wrote:
>
>
> On 2020-04-07 21:20, Tony Krowiak wrote:
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. The intent of
>> this callback is to provide a driver with the means to prevent a root 
>> user
>> from inadvertently taking a queue away from a guest and giving it to the
>> host while the guest is still using it.
>
> How can we know, at this point if the guest uses or not the queue?

The struct ap_matrix_mdev has a field, struct kvm *kvm, which holds a 
pointer to KVM when
the matrix mdev is in use by a guest. This patch series also introduces 
a shadow_crycb (soon to
be shadow_apcb) which holds the AP configuration for the guest. Between 
those two things,
the driver can detect when a queue is in use by a guest.

> Do you want to say that this prevents to take away a queue when it is 
> currently assigned to a VFIO device?
> and with a guest currently using this VFIO device?

No, I do not. The intent here is to enforce the proper procedure for 
giving up a queue so it is done
deliberately. Before taking a queue away from the matrix mdev, its APQN 
should be unassigned
from the matrix mdev. That is not to say that if there are major 
objections to this that we can't
base in_use upon the queue being in use by a guest at the time. Maybe 
that is preferable to
the community. I'll leave it to them to state their case.

>
>> The callback will
>> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
>> attributes would result in one or more AP queues being removed from its
>> driver. If the callback responds in the affirmative for any driver
>> queried, the change to the apmask or aqmask will be rejected with a 
>> device
>> in use error.
>
> AFAIU you mean that Linux's driver's binding and unbinding mechanism 
> is not sufficient to avoid this issue because unbind can not be 
> refused by the driver.

Correct!

>
>
> The reason why we do not want a single queue to be removed from the 
> VFIO driver is because the VFIO drivers works on a matrix, not on 
> queues, and for the matrix to be consistent it needs to acquire all 
> queues defined by the cross product of all APID and AQID assigned to 
> the matrix.

Not correct. The reason why is because we do not want a queue to be 
surreptitiously removed
without the guest administrator being aware of its removal.

>
> This functionality is valid for the host as for the guests and is 
> handled automatically by the firmware with the CRYCB.
> The AP bus uses QCI to retrieve the host CRYCB and build the hosts AP 
> queues.
>
> If instead to mix VFIO CRYCB matrix handling and queues at the same 
> level inside the AP bus we separate these different firmware entities 
> in two different software entities.
>
> If we make the AP bus sit above a CRYCB/Matrix bus, and in the way 
> virtualize the QCI and test AP queue instructions:
> - we can directly pass a matrix device to the guest though a VFIO 
> matrix device
> - the consistence will be automatic
> - the VFIO device and parent device will be of the same kind which 
> would make the design much more clearer.
> - there will be no need for these callback because the consistence of 
> the matrix will be guaranteed by firmware

As stated in my response above, the issue here is not consistency. While 
the design you describe
may be reasonable, it is a major departure from what is out in the 
field. In other words, that ship
has sailed.

>
>
>>
>> For this patch, only non-default drivers will be queried. Currently,
>> there is only one non-default driver, the vfio_ap device driver.
>
> You mean that the admin may take queues away from the "default 
> driver", while the queue is in use, to give it to an other driver?
> Why is it to avoid in one way and not in the other way?

Because the default drivers have direct control over the queues and can 
ensure they are empty
and reset before giving up control. The vfio driver does not have direct 
control over the queues
because they have been passed through to the guest.

>
>> The
>> vfio_ap device driver manages AP queues passed through to one or more
>> guests
>
> I read this as if a queue may be passed to several guest...
> please, rephrase or explain.

AP queues is plural, so it is true that AP queues can be passed through
to more than one guest. I see your point, however, so I'll reword that
to be more clear.

>
>> and we don't want to unexpectedly take AP resources away from
>> guests which are most likely independently administered.
>
> When you say "independently administered", you mean as a second admin 
> inside the host, don't you?

I mean that a guest can be administered by a different person than the 
host administrator.
Again, I'll try to clarify this.

>
>
> Regards,
> Pierre
>


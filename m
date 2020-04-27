Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4951B99E8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 10:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgD0IUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 04:20:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbgD0IUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 04:20:49 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R7XldU011092;
        Mon, 27 Apr 2020 04:20:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mhbh482f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 04:20:46 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03R7XwQs011724;
        Mon, 27 Apr 2020 04:20:46 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mhbh481m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 04:20:46 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03R8Je6s023801;
        Mon, 27 Apr 2020 08:20:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6ueuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 08:20:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03R8Kf9b721342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 08:20:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3DF9AE051;
        Mon, 27 Apr 2020 08:20:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D0AAE05A;
        Mon, 27 Apr 2020 08:20:41 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.191.241])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 08:20:41 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <75bcbc06-f38f-1aff-138f-5d2a2dd3f7b6@linux.ibm.com>
Date:   Mon, 27 Apr 2020 10:20:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407192015.19887-4-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_03:2020-04-24,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-07 21:20, Tony Krowiak wrote:
> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The intent of
> this callback is to provide a driver with the means to prevent a root user
> from inadvertently taking a queue away from a guest and giving it to the
> host while the guest is still using it.

How can we know, at this point if the guest uses or not the queue?
Do you want to say that this prevents to take away a queue when it is 
currently assigned to a VFIO device?
and with a guest currently using this VFIO device?

> The callback will
> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.

AFAIU you mean that Linux's driver's binding and unbinding mechanism is 
not sufficient to avoid this issue because unbind can not be refused by 
the driver.

The reason why we do not want a single queue to be removed from the VFIO 
driver is because the VFIO drivers works on a matrix, not on queues, and 
for the matrix to be consistent it needs to acquire all queues defined 
by the cross product of all APID and AQID assigned to the matrix.

This functionality is valid for the host as for the guests and is 
handled automatically by the firmware with the CRYCB.
The AP bus uses QCI to retrieve the host CRYCB and build the hosts AP 
queues.

If instead to mix VFIO CRYCB matrix handling and queues at the same 
level inside the AP bus we separate these different firmware entities in 
two different software entities.

If we make the AP bus sit above a CRYCB/Matrix bus, and in the way 
virtualize the QCI and test AP queue instructions:
- we can directly pass a matrix device to the guest though a VFIO matrix 
device
- the consistence will be automatic
- the VFIO device and parent device will be of the same kind which would 
make the design much more clearer.
- there will be no need for these callback because the consistence of 
the matrix will be guaranteed by firmware


> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver.

You mean that the admin may take queues away from the "default driver", 
while the queue is in use, to give it to an other driver?
Why is it to avoid in one way and not in the other way?

> The
> vfio_ap device driver manages AP queues passed through to one or more
> guests

I read this as if a queue may be passed to several guest...
please, rephrase or explain.

> and we don't want to unexpectedly take AP resources away from
> guests which are most likely independently administered.

When you say "independently administered", you mean as a second admin 
inside the host, don't you?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D56B935E
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 16:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393099AbfITOqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 10:46:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393093AbfITOqm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 10:46:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8KEk2VV121025;
        Fri, 20 Sep 2019 10:46:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4wjtgn5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:46:35 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8KEkMQc122421;
        Fri, 20 Sep 2019 10:46:34 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4wjtgn4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 10:46:33 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8KEjrcW007213;
        Fri, 20 Sep 2019 14:46:33 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 2v3vbuabrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 14:46:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8KEkSIc54001942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 14:46:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1142E78067;
        Fri, 20 Sep 2019 14:46:28 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 909287805C;
        Fri, 20 Sep 2019 14:46:26 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.85.141.73])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 14:46:26 +0000 (GMT)
Subject: Re: [PATCH v4 3/4] vfio: zpci: defining the VFIO headers
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, sebott@linux.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        pmorel@linux.ibm.com
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
 <1567815231-17940-4-git-send-email-mjrosato@linux.ibm.com>
 <20190919172009.71b1c246.cohuck@redhat.com>
 <0a62aba7-578a-6875-da4d-13e8b145cf9b@linux.ibm.com>
 <20190919162708.07d4eec4@x1.home> <20190919164904.579f9e9e@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <8d1adef2-a202-1143-8899-92c03b973d41@linux.ibm.com>
Date:   Fri, 20 Sep 2019 10:46:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919164904.579f9e9e@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/19 6:49 PM, Alex Williamson wrote:
> On Thu, 19 Sep 2019 16:27:08 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Thu, 19 Sep 2019 16:55:57 -0400
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> On 9/19/19 11:20 AM, Cornelia Huck wrote:  
>>>> On Fri,  6 Sep 2019 20:13:50 -0400
>>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>     
>>>>> From: Pierre Morel <pmorel@linux.ibm.com>
>>>>>
>>>>> We define a new device region in vfio.h to be able to
>>>>> get the ZPCI CLP information by reading this region from
>>>>> userland.
>>>>>
>>>>> We create a new file, vfio_zdev.h to define the structure
>>>>> of the new region we defined in vfio.h
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>> ---
>>>>>  include/uapi/linux/vfio.h      |  1 +
>>>>>  include/uapi/linux/vfio_zdev.h | 35 +++++++++++++++++++++++++++++++++++
>>>>>  2 files changed, 36 insertions(+)
>>>>>  create mode 100644 include/uapi/linux/vfio_zdev.h
>>>>>
>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>> index 8f10748..8328c87 100644
>>>>> --- a/include/uapi/linux/vfio.h
>>>>> +++ b/include/uapi/linux/vfio.h
>>>>> @@ -371,6 +371,7 @@ struct vfio_region_gfx_edid {
>>>>>   * to do TLB invalidation on a GPU.
>>>>>   */
>>>>>  #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
>>>>> +#define VFIO_REGION_SUBTYPE_ZDEV_CLP		(2)    
>>>>
>>>> Using a subtype is fine, but maybe add a comment what this is for?
>>>>     
>>>
>>> Fair point.  Maybe something like "IBM ZDEV CLP is used to pass zPCI
>>> device features to guest"  
>>
>> And if you're going to use a PCI vendor ID subtype, maintain consistent
>> naming, VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP or something.  Ideally there'd
>> also be a reference to the struct provided through this region
>> otherwise it's rather obscure to find by looking for the call to
>> vfio_pci_register_dev_region() and ops defined for the region.  I

Sure, will rename and add reference

>> wouldn't be opposed to defining the region structure here too rather
>> than a separate file, but I guess you're following the example set by
>> ccw.
>>

Indeed.

>>>>>  
>>>>>  /*
>>>>>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>>>>> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
>>>>> new file mode 100644
>>>>> index 0000000..55e0d6d
>>>>> --- /dev/null
>>>>> +++ b/include/uapi/linux/vfio_zdev.h
>>>>> @@ -0,0 +1,35 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>>>> +/*
>>>>> + * Region definition for ZPCI devices
>>>>> + *
>>>>> + * Copyright IBM Corp. 2019
>>>>> + *
>>>>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>>>>> + */
>>>>> +
>>>>> +#ifndef _VFIO_ZDEV_H_
>>>>> +#define _VFIO_ZDEV_H_
>>>>> +
>>>>> +#include <linux/types.h>
>>>>> +
>>>>> +/**
>>>>> + * struct vfio_region_zpci_info - ZPCI information.    
>>>>
>>>> Hm... probably should also get some more explanation. E.g. is that
>>>> derived from a hardware structure?
>>>>     
>>>
>>> The structure itself is not mapped 1:1 to a hardware structure, but it
>>> does serve as a collection of information that was derived from other
>>> hardware structures.
>>>
>>> "Used for passing hardware feature information about a zpci device
>>> between the host and guest" ?
>>>   
>>>>> + *
>>>>> + */
>>>>> +struct vfio_region_zpci_info {
>>>>> +	__u64 dasm;
>>>>> +	__u64 start_dma;
>>>>> +	__u64 end_dma;
>>>>> +	__u64 msi_addr;
>>>>> +	__u64 flags;
>>>>> +	__u16 pchid;
>>>>> +	__u16 mui;
>>>>> +	__u16 noi;
>>>>> +	__u16 maxstbl;
>>>>> +	__u8 version;
>>>>> +	__u8 gid;
>>>>> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1
> 
> Why is this defined so far away from the flags field?  I thought it was
> lost at first.  I also wonder what it means... brief descriptions?
> Thanks,
> 

Not sure why Pierre chose to put it here, but I have no issues moving it
up beneath flags.

Otherwise, I am getting the general gist of the feedback:  more comments
to explain what this is doing.

> Alex
> 
>>>>> +	__u8 util_str[];
>>>>> +} __packed;
>>>>> +
>>>>> +#endif    
>>
>> I'm half tempted to suggest that this struct could be exposed directly
>> through an info capability, the trouble is where.  It would be somewhat
>> awkward to pick an arbitrary BAR or config space region to expose this
>> info.  The VFIO_DEVICE_GET_INFO ioctl could include it, but we don't
>> support capabilities on that return structure and I'm not sure it's
>> worth implementing versus the solution here.  Just a thought.  Thanks,
>>
>> Alex
> 
> 


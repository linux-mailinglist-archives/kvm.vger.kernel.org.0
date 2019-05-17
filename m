Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BDA21D0C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 20:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfEQSFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 14:05:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfEQSFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 14:05:44 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HI2KEW142219
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 14:05:43 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sj1vt04u5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 14:05:42 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 19:04:39 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 19:04:36 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4HI4Y8p47644864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 18:04:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF81FAE051;
        Fri, 17 May 2019 18:04:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DBA4AE045;
        Fri, 17 May 2019 18:04:34 +0000 (GMT)
Received: from [9.145.153.112] (unknown [9.145.153.112])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 18:04:33 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
 <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
 <20190517104143.240082b5@x1.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 17 May 2019 20:04:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517104143.240082b5@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051718-0028-0000-0000-0000036ED32E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051718-0029-0000-0000-0000242E734F
Message-Id: <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=894 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/2019 18:41, Alex Williamson wrote:
> On Fri, 17 May 2019 18:16:50 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement the capability interface for VFIO_IOMMU_GET_INFO.
>>
>> When calling the ioctl, the user must specify
>> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and
>> must check in the answer if capabilities are supported.
>>
>> The iommu get_attr callback will be used to retrieve the specific
>> attributes and fill the capabilities.
>>
>> Currently two Z-PCI specific capabilities will be queried and
>> filled by the underlying Z specific s390_iommu:
>> VFIO_IOMMU_INFO_CAP_QFN for the PCI query function attributes
>> and
>> VFIO_IOMMU_INFO_CAP_QGRP for the PCI query function group.
>>
>> Other architectures may add new capabilities in the same way
>> after enhancing the architecture specific IOMMU driver.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 122 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 121 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index d0f731c..9435647 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1658,6 +1658,97 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>>   	return ret;
>>   }
>>   
>> +static int vfio_iommu_type1_zpci_fn(struct iommu_domain *domain,
>> +				    struct vfio_info_cap *caps, size_t size)
>> +{
>> +	struct vfio_iommu_type1_info_pcifn *info_fn;
>> +	int ret;
>> +
>> +	info_fn = kzalloc(size, GFP_KERNEL);
>> +	if (!info_fn)
>> +		return -ENOMEM;
>> +
>> +	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_FN,
>> +				    &info_fn->response);
> 
> What ensures that the 'struct clp_rsp_query_pci' returned from this
> get_attr remains consistent with a 'struct vfio_iommu_pci_function'?
> Why does the latter contains so many reserved fields (beyond simply
> alignment) for a user API?  What fields of these structures are
> actually useful to userspace?  Should any fields not be exposed to the
> user?  Aren't BAR sizes redundant to what's available through the vfio
> PCI API?  I'm afraid that simply redefining an internal structure as
> the API leaves a lot to be desired too.  Thanks,
> 
> Alex
> 
Hi Alex,

I simply used the structure returned by the firmware to be sure to be 
consistent with future evolutions and facilitate the copy from CLP and 
to userland.

If you prefer, and I understand that this is the case, I can define a 
specific VFIO_IOMMU structure with only the fields relevant to the user, 
leaving future enhancement of the user's interface being implemented in 
another kernel patch when the time has come.

In fact, the struct will have all defined fields I used but not the BAR 
size and address (at least for now because there are special cases we do 
not support yet with bars).
All the reserved fields can go away.

Is it more conform to your idea?

Also I have 2 interfaces:

s390_iommu.get_attr <-I1-> VFIO_IOMMU <-I2-> userland

Do you prefer:
- 2 different structures, no CLP raw structure
- the CLP raw structure for I1 and a VFIO specific structure for I2
- the same VFIO structure for both I1 and I2

Thank you if you could give me a direction for this.

Thanks for the comments, and thanks a lot to have answered so quickly.

Pierre







-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany


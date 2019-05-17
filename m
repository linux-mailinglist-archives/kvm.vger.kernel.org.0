Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C95121539
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfEQISm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:18:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728136AbfEQISl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 04:18:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H8GbnQ036564
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 04:18:40 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2shs428tch-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 04:18:40 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 09:18:38 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 09:18:35 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4H8IYlF28573942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 08:18:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23B9DAE068;
        Fri, 17 May 2019 08:18:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8153EAE05F;
        Fri, 17 May 2019 08:18:33 +0000 (GMT)
Received: from [9.145.153.112] (unknown [9.145.153.112])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 08:18:33 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 2/4] vfio: vfio_iommu_type1: Define
 VFIO_IOMMU_INFO_CAPABILITIES
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
 <1557476555-20256-3-git-send-email-pmorel@linux.ibm.com>
 <20190516123100.529f06be@x1.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 17 May 2019 10:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516123100.529f06be@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051708-0028-0000-0000-0000036EA8E8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051708-0029-0000-0000-0000242E46EB
Message-Id: <ce6c7c44-b406-00d1-cf40-0dae6a6ed563@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/2019 20:31, Alex Williamson wrote:
> On Fri, 10 May 2019 10:22:33 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> To use the VFIO_IOMMU_GET_INFO to retrieve IOMMU specific information,
>> we define a new flag VFIO_IOMMU_INFO_CAPABILITIES in the
>> vfio_iommu_type1_info structure and the associated capability
>> information block.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/uapi/linux/vfio.h | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 8f10748..8f68e0f 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -715,6 +715,16 @@ struct vfio_iommu_type1_info {
>>   	__u32	flags;
>>   #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
>>   	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
>> +#define VFIO_IOMMU_INFO_CAPABILITIES (1 << 1)  /* support capabilities info */
>> +	__u64   cap_offset;     /* Offset within info struct of first cap */
>> +};
>> +
>> +#define VFIO_IOMMU_INFO_CAP_QFN		1
>> +#define VFIO_IOMMU_INFO_CAP_QGRP	2
> 
> Descriptions?
> 
>> +
>> +struct vfio_iommu_type1_info_block {
>> +	struct vfio_info_cap_header header;
>> +	__u32 data[];
>>   };
>>   
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> 
> This is just a blob of data, what's the API?  How do we revision it?
> How does the user know how to interpret it?  Dumping kernel internal
> structures out to userspace like this is not acceptable, define a user
> API. Thanks,
> 
> Alex
> 

Thanks Alex for the comments.
I will add the decription and the user API for the next iteration.

Regards,
Pierre




-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany


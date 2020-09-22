Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F115274392
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIVN4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:56:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVN4B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:56:01 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MDngvT093881;
        Tue, 22 Sep 2020 09:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tJ7qfg5cVK2cVNVTi3DHQ2nDLrMgU8mKoi2z1b+/IB4=;
 b=J8Rkq4qbrXQ+RLDXqQ3Lpvq555ZJ5Jd1R7jhXE9ZQr+CH4W1m1q34Yd+Epam13QUtf/Y
 ZZbvybLuhSkUfjK0ps1+L+N8GOHnraqngMy6CyVzm3dUXxmSka1v/P9H1hXU5+talERZ
 PzHgtYNmnABe1wbJ3v+ikrIvk9DkLia2C+nGWzepCDbs6yw3SI7cfHedIRADBteHm16W
 XNKZlYZyAIZsbE+Eko/Y9SYFqEbQp5lWUwFlnBNk2lOk/a5NGLeSd+3Fznt/S6RBidvu
 EIeEIW+kYaLtuAxwozNmS5N16WfEqVUo6DZ9ZF0bh5KU5WtLzP8nMJjR/9S4RQbz07f/ dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qjgag6h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 09:55:59 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08MDq1Pp101353;
        Tue, 22 Sep 2020 09:55:59 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qjgag6gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 09:55:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08MDqbgR006853;
        Tue, 22 Sep 2020 13:55:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 33n9m9cx8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 13:55:58 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08MDtniL54657484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 13:55:49 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E339FC6055;
        Tue, 22 Sep 2020 13:55:54 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C3AC6057;
        Tue, 22 Sep 2020 13:55:53 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Sep 2020 13:55:53 +0000 (GMT)
Subject: Re: [PATCH 3/4] vfio-pci/zdev: define the vfio_zdev header
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-4-git-send-email-mjrosato@linux.ibm.com>
 <20200922125409.4127797c.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <b825731c-c2c5-ff17-014a-bc63fcc87927@linux.ibm.com>
Date:   Tue, 22 Sep 2020 09:55:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922125409.4127797c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_12:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/20 6:54 AM, Cornelia Huck wrote:
> On Sat, 19 Sep 2020 11:28:37 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> We define a new device region in vfio.h to be able to get the ZPCI CLP
>> information by reading this region from userspace.
>>
>> We create a new file, vfio_zdev.h to define the structure of the new
>> region defined in vfio.h
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   include/uapi/linux/vfio.h      |   5 ++
>>   include/uapi/linux/vfio_zdev.h | 116 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 121 insertions(+)
>>   create mode 100644 include/uapi/linux/vfio_zdev.h
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9204705..65eb367 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -326,6 +326,11 @@ struct vfio_region_info_cap_type {
>>    * to do TLB invalidation on a GPU.
>>    */
>>   #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
>> +/*
>> + * IBM zPCI specific hardware feature information for a devcie.  The contents
>> + * of this region are mapped by struct vfio_region_zpci_info.
>> + */
>> +#define VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP	(2)
> 
> This is not really for a 10de vendor, but for all pci devices accessed
> via zpci, isn't it?
s/10de/1014/ (10de is the set of regions prior to this one)

1014 == PCI_VENDOR_ID_IBM

But yes, this region is intended to be assigned to all pci devices 
accessed thru zpci.  But the next patch always assigns the region to the 
zpci device using type 1014 subtype 2 (and userspace always searches 
using that pair) -- So it should always be unique as I understand it 
unless someone re-defines another type 1014 subtype 2?

> We obviously want to avoid collisions here; not really sure how to
> cover all possible vendors. Maybe just pick a high number?
> 

I don't think this is necessary unless I'm misunderstanding something.

>>   
>>   /* sub-types for VFIO_REGION_TYPE_GFX */
>>   #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
>> new file mode 100644
>> index 0000000..c9e4891
>> --- /dev/null
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -0,0 +1,116 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Region definition for ZPCI devices
>> + *
>> + * Copyright IBM Corp. 2020
>> + *
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + *            Matthew Rosato <mjrosato@linux.ibm.com>
>> + */
>> +
>> +#ifndef _VFIO_ZDEV_H_
>> +#define _VFIO_ZDEV_H_
>> +
>> +#include <linux/types.h>
>> +
>> +/**
>> + * struct vfio_region_zpci_info - ZPCI information
>> + *
>> + * This region provides zPCI specific hardware feature information for a
>> + * device.
>> + *
>> + * The ZPCI information structure is presented as a chain of CLP features
> 
> "CLP features" == "features returned by the CLP instruction", I guess?
> Maybe mention that explicitly?

Yes, that's correct.  I'm trying to clarify that these things aren't a 
1:1 relationship to a CLP instruction payload.

> 
>> + * defined below. argsz provides the size of the entire region, and offset
>> + * provides the location of the first CLP feature in the chain.
>> + *
>> + */
>> +struct vfio_region_zpci_info {
>> +	__u32 argsz;		/* Size of entire payload */
>> +	__u32 offset;		/* Location of first entry */
>> +} __packed;
> 
> This '__packed' annotation seems redundant. I think that all of these
> structures should be defined in a way that packing is unneeded (which
> seems to be the case on a quick browse.)
> 
OK, I'll double-check and remove the __packed annotation.

>> +
>> +/**
>> + * struct vfio_region_zpci_info_hdr - ZPCI header information
>> + *
>> + * This structure is included at the top of each CLP feature to define what
>> + * type of CLP feature is presented / the structure version. The next value
>> + * defines the offset of the next CLP feature, and is an offset from the very
>> + * beginning of the region (vfio_region_zpci_info).
>> + *
>> + * Each CLP feature must have it's own unique 'id'.
> 
> s/it's/its/
> 
> Is the 'id' something that is already provided by the CLP instruction?
> 

No, these IDs correspond only to the API for the vfio region and don't 
directly relate to which CLP instruction they are associated with.  The 
term 'CLP feature' was intended to abstract these structures from 
individual CLP instructions.

So, it might help to explain the design a bit here -- The CLP 
instructions each return a specific, hardware-architected payload.  But 
we're not sending the entirety of that payload to the guest, rather 
identifying a subset to forward via the vfio region.  Currently, I've 
sub-divided it as follows:

1) query pci info we currently care about
2) query pci fg info we currently care about
3) utility string
4) function path

This was done in such a way that, when we need to add further CLP 
information to this region (ex: new device support, new zpci feature 
support, etc) we can do so by adding new 'CLP features' to the region. 
Those 'CLP features' could be additional parts of the query pci CLP, 
additional parts of the query pci fg CLP, or parts of some other CLP. 
Technically, #3 and #4 are part of query pci info, but the nature of the 
way they are sized made it more convenient to make them separate features.

Userspace can then scan the region only for the 'CLP features' it 
understands (or is enabled for) and pick only those (and use defaults 
and/or turn support off for 'CLP features' it cannot find but expected to).

>> + */
>> +struct vfio_region_zpci_info_hdr {
>> +	__u16 id;		/* Identifies the CLP type */
>> +	__u16	version;	/* version of the CLP data */
>> +	__u32 next;		/* Offset of next entry */
>> +} __packed;
>> +
>> +/**
>> + * struct vfio_region_zpci_info_qpci - Initial Query PCI information
>> + *
>> + * This region provides an initial set of data from the Query PCI Function
> 
> What does 'initial' mean in this context? Information you get for a
> freshly initialized function?
> 

So this goes back to my statement above about 'query pci info we 
currently care about' - It's not the entire query pci payload and I was 
trying to avoid implying it was to prevent future confusion.  So 
'initial' is more in a sense of 'what we initially care to send to 
userspace.'

But really, the vfio region API doesn't care which CLP the info came 
from / where userspace is planning to stick these fields -- Perhaps I 
should drop 'initial' and re-phrase without mentioning the CLP itself. 
This feature is providing basic descriptive information about the 
device, so maybe something like "Base zPCI device information"

>> + * CLP.
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_QPCI	1
>> +
>> +struct vfio_region_zpci_info_qpci {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u64 start_dma;	/* Start of available DMA addresses */
>> +	__u64 end_dma;		/* End of available DMA addresses */
>> +	__u16 pchid;		/* Physical Channel ID */
>> +	__u16 vfn;		/* Virtual function number */
>> +	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
>> +	__u8 pft;		/* PCI Function Type */
>> +	__u8 gid;		/* PCI function group ID */
>> +} __packed;
>> +
>> +
>> +/**
>> + * struct vfio_region_zpci_info_qpcifg - Initial Query PCI Function Group info
>> + *
>> + * This region provides an initial set of data from the Query PCI Function
>> + * Group CLP.
>> + */

And the same thing here -- It's the subset of query pci fg info we 
currently care about -- So I can rename and drop the 'Initial' bit. 
Something like "Base zPCI group information"

>> +#define VFIO_REGION_ZPCI_INFO_QPCIFG	2
>> +
>> +struct vfio_region_zpci_info_qpcifg {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u64 dasm;		/* DMA Address space mask */
>> +	__u64 msi_addr;		/* MSI address */
>> +	__u64 flags;
>> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
>> +	__u16 mui;		/* Measurement Block Update Interval */
>> +	__u16 noi;		/* Maximum number of MSIs */
>> +	__u16 maxstbl;		/* Maximum Store Block Length */
>> +	__u8 version;		/* Supported PCI Version */
>> +} __packed;
>> +
>> +/**
>> + * struct vfio_region_zpci_info_util - Utility String
>> + *
>> + * This region provides the utility string for the associated device, which is
>> + * a device identifier string.
> 
> Is there an upper boundary for this string?
> 
> Is this a classic NUL-terminated string, or a list of EBCDIC characters?
> 

EBCDIC characters.

So, there is indeed an upper-boundary for the string, CLP_UTIL_STR_LEN. 
It's coming from a hardware-architected field and shouldn't change size, 
but we send the length anyway so that the API can act independent of the 
CLP hardware region.  So the expectation is that userspace (qemu) would 
compare the provided size of the util_str with what it expects the CLP 
hardware payload to look like -- If it's too big, userspace can't use 
that string to properly emulate the CLP response so it would have to 
ignore this feature and use defaults.

>> + */
>> +#define VFIO_REGION_ZPCI_INFO_UTIL	3
>> +
>> +struct vfio_region_zpci_info_util {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u32 size;
>> +	__u8 util_str[];
>> +} __packed;
>> +
>> +/**
>> + * struct vfio_region_zpci_info_pfip - PCI Function Path
>> + *
>> + * This region provides the PCI function path string, which is an identifier
>> + * that describes the internal hardware path of the device.
> 
> Same question here.

Hex string bounded by CLP_PFIP_NR_SEGMENTS and again coming from a 
hardware-architected field that shouldn't change -- the rest of my 
answer from above applies here too.

> 
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_PFIP	4
>> +
>> +struct vfio_region_zpci_info_pfip {
>> +struct vfio_region_zpci_info_hdr hdr;
>> +	__u32 size;
>> +	__u8 pfip[];
>> +} __packed;
>> +
>> +#endif
> 


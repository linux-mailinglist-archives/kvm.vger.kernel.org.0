Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11B2836F4
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgJENwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 09:52:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgJENwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 09:52:33 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095DX3WC031074;
        Mon, 5 Oct 2020 09:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5Tu85tMvxAfJtn3MRQVpZy6Rxyaa7xa4ANZfREPO0JU=;
 b=ISIc+mk7tYR1ygGthTa3gCdWWknPd7fkpubn1HBPXkyDSaRuMQjbpv11zmLUo2ldaFJs
 h24VtZYJykrtFMzE5aDKWfrCSc6cjZQjIZXkaMZECIZJoVnByG+TjhrQbv9uZP7QUfbO
 G5N+rX2AV2CKdt7priGfdJYTONoxkp9NgyR8MSGGP92lN+yPxXsmy+CxgbJVvAYECWov
 XAKxHh6rMM476eOM9it2CTsUfFQhvP8xTFGti8MF3Oy2+MW/5SWqaRFdAdc1QAXhNDkT
 e1Yn2wuTCgJ7YDhKB1WjFFNUuMWOjburW9Cr45tbs13g9/blMDbUDKWNQSSz9UHzHmKW LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3403qwt7rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 09:52:31 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095DXc0W033785;
        Mon, 5 Oct 2020 09:52:30 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3403qwt7ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 09:52:30 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095DlO3x011710;
        Mon, 5 Oct 2020 13:52:29 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 33xgx93vf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 13:52:29 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095DqRY718415884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 13:52:28 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB014112061;
        Mon,  5 Oct 2020 13:52:27 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47EDD112064;
        Mon,  5 Oct 2020 13:52:26 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 13:52:26 +0000 (GMT)
Subject: Re: [PATCH v2 3/5] vfio-pci/zdev: define the vfio_zdev header
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
 <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
 <20201002154417.20c2a7ef@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <8a71af3b-f8fc-48b2-45c6-51222fd2455b@linux.ibm.com>
Date:   Mon, 5 Oct 2020 09:52:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002154417.20c2a7ef@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_07:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/20 5:44 PM, Alex Williamson wrote:
> On Fri,  2 Oct 2020 16:00:42 -0400
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
>>   include/uapi/linux/vfio_zdev.h | 118 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 123 insertions(+)
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
>>   
>>   /* sub-types for VFIO_REGION_TYPE_GFX */
>>   #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
>> new file mode 100644
>> index 0000000..1c8fb62
>> --- /dev/null
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -0,0 +1,118 @@
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
>> + * defined below. argsz provides the size of the entire region, and offset
>> + * provides the location of the first CLP feature in the chain.
>> + *
>> + */
>> +struct vfio_region_zpci_info {
>> +	__u32 argsz;		/* Size of entire payload */
>> +	__u32 offset;		/* Location of first entry */
>> +};
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
>> + */
>> +struct vfio_region_zpci_info_hdr {
>> +	__u16 id;		/* Identifies the CLP type */
>> +	__u16	version;	/* version of the CLP data */
>> +	__u32 next;		/* Offset of next entry */
>> +};
>> +
>> +/**
>> + * struct vfio_region_zpci_info_pci - Base PCI Function information
>> + *
>> + * This region provides a set of descriptive information about the associated
>> + * PCI function.
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_BASE	1
>> +
>> +struct vfio_region_zpci_info_base {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u64 start_dma;	/* Start of available DMA addresses */
>> +	__u64 end_dma;		/* End of available DMA addresses */
>> +	__u16 pchid;		/* Physical Channel ID */
>> +	__u16 vfn;		/* Virtual function number */
>> +	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
>> +	__u8 pft;		/* PCI Function Type */
>> +	__u8 gid;		/* PCI function group ID */
>> +};
>> +
>> +
>> +/**
>> + * struct vfio_region_zpci_info_group - Base PCI Function Group information
>> + *
>> + * This region provides a set of descriptive information about the group of PCI
>> + * functions that the associated device belongs to.
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_GROUP	2
>> +
>> +struct vfio_region_zpci_info_group {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u64 dasm;		/* DMA Address space mask */
>> +	__u64 msi_addr;		/* MSI address */
>> +	__u64 flags;
>> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
>> +	__u16 mui;		/* Measurement Block Update Interval */
>> +	__u16 noi;		/* Maximum number of MSIs */
>> +	__u16 maxstbl;		/* Maximum Store Block Length */
>> +	__u8 version;		/* Supported PCI Version */
>> +};
>> +
>> +/**
>> + * struct vfio_region_zpci_info_util - Utility String
>> + *
>> + * This region provides the utility string for the associated device, which is
>> + * a device identifier string made up of EBCDID characters.  'size' specifies
>> + * the length of 'util_str'.
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_UTIL	3
>> +
>> +struct vfio_region_zpci_info_util {
>> +	struct vfio_region_zpci_info_hdr hdr;
>> +	__u32 size;
>> +	__u8 util_str[];
>> +};
>> +
>> +/**
>> + * struct vfio_region_zpci_info_pfip - PCI Function Path
>> + *
>> + * This region provides the PCI function path string, which is an identifier
>> + * that describes the internal hardware path of the device. 'size' specifies
>> + * the length of 'pfip'.
>> + */
>> +#define VFIO_REGION_ZPCI_INFO_PFIP	4
>> +
>> +struct vfio_region_zpci_info_pfip {
>> +struct vfio_region_zpci_info_hdr hdr;
>> +	__u32 size;
>> +	__u8 pfip[];
>> +};
>> +
>> +#endif
> 
> Can you discuss why a region with embedded capability chain is a better
> solution than extending the VFIO_DEVICE_GET_INFO ioctl to support a
> capability chain and providing this info there?  This all appears to be
> read-only info, so what's the benefit of duplicating yet another

It is indeed read-only info, and the device region was defined as such.

I would not necessarily be opposed to extending VFIO_DEVICE_GET_INFO 
with these defined as capabilities; I'd say a primary motivating factor 
to putting these in their own region was to avoid stuffing a bunch of 
s390-specific capabilities into a general-purpose ioctl response.

But if you're OK with that notion, I can give that a crack in v3.

> capability chain in a region?  It would also be possible to define four
> separate device specific regions, one for each of these capabilities
> rather than creating this chain.  It just seems like a strange approach

I'm not sure if creating separate regions would be the right approach 
though; these are just the first 4.  There will definitely be additional 
capabilities in support of new zPCI features moving forward, I'm not 
sure how many regions we really want to end up with.  Some might be as 
small as a single field, which seems more in-line with capabilities vs 
an entire region.



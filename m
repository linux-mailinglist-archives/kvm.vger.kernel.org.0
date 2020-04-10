Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750EA1A3EBF
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 05:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDJD2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 23:28:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726595AbgDJD2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 23:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586489304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5RPEIscwNHHN6pKKXncPnUb9hPTGPGd0ih2LFmLYUI=;
        b=d6iAx+W+mekosaLQLdyN2xw55wdLKOnR65HgbcycBZG0noYiAIzR+9CII6MHvZd8rPPixd
        E4HIXA8Xehzy1rE+eGSRaj1cU7hO49a1YmOgGrFi7saS2GO24XxIOWf9NVGGnhlk7YtpIx
        BsMjUA4pUly6uW5hofb4kmnUnk3ZZo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-JjOVLH4jORmpBucW2yuYxw-1; Thu, 09 Apr 2020 23:28:19 -0400
X-MC-Unique: JjOVLH4jORmpBucW2yuYxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E915518AB2D3;
        Fri, 10 Apr 2020 03:28:17 +0000 (UTC)
Received: from [10.36.115.53] (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5A1660BFB;
        Fri, 10 Apr 2020 03:28:04 +0000 (UTC)
Subject: Re: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DB4E@SHSMSX104.ccr.corp.intel.com>
 <b47891b1-ece6-c263-9c07-07c09c7d3752@redhat.com>
 <20200403082305.GA1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A2249DF@SHSMSX104.ccr.corp.intel.com>
 <acf8c809-8d29-92d6-2445-3a94fc8b82fd@redhat.com>
 <20200409081442.GD2435@myrica>
 <A2975661238FB949B60364EF0F2C25743A229013@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <194923cd-666c-2244-bfc6-95a1c61d4d99@redhat.com>
Date:   Fri, 10 Apr 2020 05:28:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A229013@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/9/20 2:47 PM, Liu, Yi L wrote:
> Hi Jean,
> 
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Sent: Thursday, April 9, 2020 4:15 PM
>> Subject: Re: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
>> userspace
>>
>> On Wed, Apr 08, 2020 at 12:27:58PM +0200, Auger Eric wrote:
>>> Hi Yi,
>>>
>>> On 4/7/20 11:43 AM, Liu, Yi L wrote:
>>>> Hi Jean,
>>>>
>>>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>>> Sent: Friday, April 3, 2020 4:23 PM
>>>>> To: Auger Eric <eric.auger@redhat.com>
>>>>> userspace
>>>>>
>>>>> On Wed, Apr 01, 2020 at 03:01:12PM +0200, Auger Eric wrote:
>>>>>>>>>  	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
>>>>>>>>>
>> VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
>>>>> @@ -2254,6 +2309,7
>>>>>>>>> @@ static int vfio_iommu_info_add_nesting_cap(struct
>>>>>>>> vfio_iommu *iommu,
>>>>>>>>>  		/* nesting iommu type supports PASID requests (alloc/free)
>> */
>>>>>>>>>  		nesting_cap->nesting_capabilities |=
>> VFIO_IOMMU_PASID_REQS;
>>>>>>>> What is the meaning for ARM?
>>>>>>>
>>>>>>> I think it's just a software capability exposed to userspace, on
>>>>>>> userspace side, it has a choice to use it or not. :-) The reason
>>>>>>> define it and report it in cap nesting is that I'd like to make the
>>>>>>> pasid alloc/free be available just for IOMMU with type
>>>>>>> VFIO_IOMMU_TYPE1_NESTING. Please feel free tell me if it is not good
>>>>>>> for ARM. We can find a proper way to report the availability.
>>>>>>
>>>>>> Well it is more a question for jean-Philippe. Do we have a system wide
>>>>>> PASID allocation on ARM?
>>>>>
>>>>> We don't, the PASID spaces are per-VM on Arm, so this function should consult
>> the
>>>>> IOMMU driver before setting flags. As you said on patch 3, nested doesn't
>>>>> necessarily imply PASID support. The SMMUv2 does not support PASID but does
>>>>> support nesting stages 1 and 2 for the IOVA space.
>>>>> SMMUv3 support of PASID depends on HW capabilities. So I think this needs to
>> be
>>>>> finer grained:
>>>>>
>>>>> Does the container support:
>>>>> * VFIO_IOMMU_PASID_REQUEST?
>>>>>   -> Yes for VT-d 3
>>>>>   -> No for Arm SMMU
>>>>> * VFIO_IOMMU_{,UN}BIND_GUEST_PGTBL?
>>>>>   -> Yes for VT-d 3
>>>>>   -> Sometimes for SMMUv2
>>>>>   -> No for SMMUv3 (if we go with BIND_PASID_TABLE, which is simpler due to
>>>>>      PASID tables being in GPA space.)
>>>>> * VFIO_IOMMU_BIND_PASID_TABLE?
>>>>>   -> No for VT-d
>>>>>   -> Sometimes for SMMUv3
>>>>>
>>>>> Any bind support implies VFIO_IOMMU_CACHE_INVALIDATE support.
>>>>
>>>> good summary. do you expect to see any
>>>>
>>>>>
>>>>>>>>> +	nesting_cap->stage1_formats = formats;
>>>>>>>> as spotted by Kevin, since a single format is supported, rename
>>>>>>>
>>>>>>> ok, I was believing it may be possible on ARM or so. :-) will rename
>>>>>>> it.
>>>>>
>>>>> Yes I don't think an u32 is going to cut it for Arm :( We need to 
>>>>> describe all sorts
>> of
>>>>> capabilities for page and PASID tables (granules, GPA size, ASID/PASID size, HW
>>>>> access/dirty, etc etc.) Just saying "Arm stage-1 format" wouldn't mean much. I
>>>>> guess we could have a secondary vendor capability for these?
>>>>
>>>> Actually, I'm wondering if we can define some formats to stands for a set of
>>>> capabilities. e.g. VTD_STAGE1_FORMAT_V1 which may indicates the 1st level
>>>> page table related caps (aw, a/d, SRE, EA and etc.). And vIOMMU can parse
>>>> the capabilities.
>>>
>>> But eventually do we really need all those capability getters? I mean
>>> can't we simply rely on the actual call to VFIO_IOMMU_BIND_GUEST_PGTBL()
>>> to detect any mismatch? Definitively the error handling may be heavier
>>> on userspace but can't we manage.
>>
>> I think we need to present these capabilities at boot time, long before
>> the guest triggers a bind(). For example if the host SMMU doesn't support
>> 16-bit ASID, we need to communicate that to the guest using vSMMU ID
>> registers or PROBE properties. Otherwise a bind() will succeed, but if the
>> guest uses 16-bit ASIDs in its CD, DMA will result in C_BAD_CD events
>> which we'll inject into the guest, for no apparent reason from their
>> perspective.
>>
>> In addition some VMMs may have fallbacks if shared page tables are not
>> available. They could fall back to a MAP/UNMAP interface, or simply not
>> present a vIOMMU to the guest.
>>
> 
> Based on the comments, I think it would be a need to report iommu caps
> in detail. So I guess iommu uapi needs to provide something alike vfio
> cap chain in iommu uapi. Please feel free let me know your thoughts. :-)

Yes to me it sounds sensible.
> 
> In vfio, we can define a cap as below:
> 
> struct vfio_iommu_type1_info_cap_nesting {
> 	struct  vfio_info_cap_header header;
> 	__u64	iommu_model;
> #define VFIO_IOMMU_PASID_REQS		(1 << 0)
I still think the name shall be changed
> #define VFIO_IOMMU_BIND_GPASID		(1 << 1)
> #define VFIO_IOMMU_CACHE_INV		(1 << 2)
this operation seems mandated as soon as we have a nested paging based
implementation?
> 	__u32	nesting_capabilities;
> 	__u32	pasid_bits;
> #define VFIO_IOMMU_VENDOR_SUB_CAP	(1 << 3)
> 	__u32	flags;
> 	__u32	data_size;
> 	__u8	data[];  /*iommu info caps defined by iommu uapi */
> };
> 
> VFIO needs new iommu APIs to ask iommu driver whether PASID/bind_gpasid/
> cache_inv/bind_gpasid_table is available or not and also the pasid
> bits. After that VFIO will ask iommu driver about the iommu_cap_info
> and fill in the @data[] field.
> 
> iommu uapi:
> struct iommu_info_cap_header {
> 	__u16	id;		/* Identifies capability */
> 	__u16	version;		/* Version specific to the capability ID */
> 	__u32	next;		/* Offset of next capability */
> };
> 
> #define IOMMU_INFO_CAP_INTEL_VTD 1
> struct iommu_info_cap_intel_vtd {
> 	struct	iommu_info_cap_header header;
> 	__u32   vaddr_width;   /* VA addr_width*/
> 	__u32   ipaddr_width; /* IPA addr_width, input of SL page table */
> 	/* same definition with @flags instruct iommu_gpasid_bind_data_vtd */
> 	__u64	flags;
> };
> 
> #define IOMMU_INFO_CAP_ARM_SMMUv3 2
> struct iommu_info_cap_arm_smmuv3 {
> 	struct	iommu_info_cap_header header;
> 	...
> };

Thanks

Eric
> 
> Regards,
> Yi Liu
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD62830AE6B
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhBARux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:50:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232447AbhBARuC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 12:50:02 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111HX8in006167;
        Mon, 1 Feb 2021 12:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YY3ecy/Al7aUatw1iTYUmj9VR3WvKFhhLF5UQ16Krwc=;
 b=bSbnhHqprdj3obR7MYmF261CjZFtcGsq/f6YmrgDVoBE/rVi/BvyfsSqa+uT4eW87pxI
 bff6m++Eo4mQ5zhbsAVPjDjnwtZtW4wNWebDcl/e9z0H44/rNiRZ/2N1BhEStwQw7+Sq
 9OLsPFeYv8hJH65czipbX9FVwDpQhuc4JYPOOSfOEeazrUM1/zcjLugZA102D3fFvQdg
 wY7xg4uOhHgLkjzPWHUsXGVgDP2OMYvLANMGOBqa3+MN4GR1Y1i9/oEDFV47pGWzIIuf
 TIXWgbjYLYkWp10oucE0KxBR/qg8+Hcs7gsJH2nCWM8Qrz+mS8gStkcFA2Z08dyHV++s Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36endua4mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:49:20 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111HXF9h006989;
        Mon, 1 Feb 2021 12:49:20 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36endua4m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:49:20 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111HcHBg008753;
        Mon, 1 Feb 2021 17:49:18 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 36cy390ay2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 17:49:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111HnIYN29557098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 17:49:18 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E364112061;
        Mon,  1 Feb 2021 17:49:18 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5578112062;
        Mon,  1 Feb 2021 17:49:13 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.84.157])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 17:49:13 +0000 (GMT)
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
Date:   Mon, 1 Feb 2021 12:49:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201181454.22112b57.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_06:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/21 12:14 PM, Cornelia Huck wrote:
> On Mon, 1 Feb 2021 16:28:27 +0000
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> 
>> This patch doesn't change any logic but only align to the concept of
>> vfio_pci_core extensions. Extensions that are related to a platform
>> and not to a specific vendor of PCI devices should be part of the core
>> driver. Extensions that are specific for PCI device vendor should go
>> to a dedicated vendor vfio-pci driver.
> 
> My understanding is that igd means support for Intel graphics, i.e. a
> strict subset of x86. If there are other future extensions that e.g.
> only make sense for some devices found only on AMD systems, I don't
> think they should all be included under the same x86 umbrella.
> 
> Similar reasoning for nvlink, that only seems to cover support for some
> GPUs under Power, and is not a general platform-specific extension IIUC.
> 
> We can arguably do the zdev -> s390 rename (as zpci appears only on
> s390, and all PCI devices will be zpci on that platform), although I'm
> not sure about the benefit.

As far as I can tell, there isn't any benefit for s390 it's just 
"re-branding" to match the platform name rather than the zdev moniker, 
which admittedly perhaps makes it more clear to someone outside of s390 
that any PCI device on s390 is a zdev/zpci type, and thus will use this 
extension to vfio_pci(_core).  This would still be true even if we added 
something later that builds atop it (e.g. a platform-specific device 
like ism-vfio-pci).  Or for that matter, mlx5 via vfio-pci on s390x uses 
these zdev extensions today and would need to continue using them in a 
world where mlx5-vfio-pci.ko exists.

I guess all that to say: if such a rename matches the 'grand scheme' of 
this design where we treat arch-level extensions to vfio_pci(_core) as 
"vfio_pci_(arch)" then I'm not particularly opposed to the rename.  But 
by itself it's not very exciting :)

> 
>>
>> For now, x86 extensions will include only igd.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/vfio/pci/Kconfig                            | 13 ++++++-------
>>   drivers/vfio/pci/Makefile                           |  2 +-
>>   drivers/vfio/pci/vfio_pci_core.c                    |  2 +-
>>   drivers/vfio/pci/vfio_pci_private.h                 |  2 +-
>>   drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} |  0
>>   5 files changed, 9 insertions(+), 10 deletions(-)
>>   rename drivers/vfio/pci/{vfio_pci_igd.c => vfio_pci_x86.c} (100%)
> 
> (...)
> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index c559027def2d..e0e258c37fb5 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -328,7 +328,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>>   
>>   	if (vfio_pci_is_vga(pdev) &&
>>   	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
>> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
>> +	    IS_ENABLED(CONFIG_VFIO_PCI_X86)) {
>>   		ret = vfio_pci_igd_init(vdev);
> 
> This one explicitly checks for Intel devices, so I'm not sure why you
> want to generalize this to x86?
> 
>>   		if (ret && ret != -ENODEV) {
>>   			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
> 


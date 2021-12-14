Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7384745BB
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhLNO7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:59:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46888 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232616AbhLNO7X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 09:59:23 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEEmXYU021242;
        Tue, 14 Dec 2021 14:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MzM9dBEun0fHvPVR9vM3PuPGKzAZl/8OMytYz2PWxRo=;
 b=KDOqhKMlA4sYfoWlWwU6Gg/bMRYBJgf1wWQKk/ykRHa43QHjVm79FtqMzAF++ZntXcXT
 MknMk84RPdqS7iEhiPIXrV0I1k1yRfDJJfV6UxYCteR4b4stSjAkt9UY5eBvWMZ5hc2d
 RblxeNa+fQjy6sAKaXteILboy4mjpe3CwJJSkoQC7nX/NwakiF29FeOaoAr8QzA3dQOu
 +4hHLH8y7a1sAfpoNchB1RUfeCJjSxrD5ldWlGvxO81xDWnqcveOOFM8rv2d6LGEsWsL
 9B9sAOIsy4cuK0J86MFhRE/TBmzKKvmsYW5U3swZ4/ptumSPoCjq/qihhkjI8Ave1Dob 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9rafved-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:59:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEEwROh005839;
        Tue, 14 Dec 2021 14:59:21 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9rafvdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:59:21 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEEWBUJ014727;
        Tue, 14 Dec 2021 14:59:20 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3cvkmagd14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 14:59:20 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEExJjx50069914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 14:59:19 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F3F1AC075;
        Tue, 14 Dec 2021 14:59:19 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC5FAC060;
        Tue, 14 Dec 2021 14:59:13 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 14:59:13 +0000 (GMT)
Message-ID: <bb401f7d-7b2d-15ef-51c8-2c63be70f04c@linux.ibm.com>
Date:   Tue, 14 Dec 2021 09:59:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 30/32] vfio-pci/zdev: add DTSM to clp group capability
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-31-mjrosato@linux.ibm.com>
 <b54b2ee9-3d7f-11b7-9aa4-e5dafd01a086@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <b54b2ee9-3d7f-11b7-9aa4-e5dafd01a086@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hzmXHhR6DxiFNB1VzwWaSFX3vuC_vCxw
X-Proofpoint-ORIG-GUID: UPfsLR96wmCl1CfsA1dgUK9C7cBrYbnc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_06,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 4:58 AM, Pierre Morel wrote:
> 
> 
> On 12/7/21 21:57, Matthew Rosato wrote:
>> The DTSM, or designation type supported mask, indicates what IOAT formats
>> are available to the guest.  For an interpreted device, userspace will 
>> not
>> know what format(s) the IOAT assist supports, so pass it via the
>> capability chain.  Since the value belongs to the Query PCI Function 
>> Group
>> clp, let's extend the existing capability with a new version.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_zdev.c | 9 ++++++---
>>   include/uapi/linux/vfio_zdev.h   | 3 +++
>>   2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c 
>> b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 85be77492a6d..342b59ed36c9 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -45,19 +45,22 @@ static int zpci_group_cap(struct zpci_dev *zdev, 
>> struct vfio_info_cap *caps)
>>   {
>>       struct vfio_device_info_cap_zpci_group cap = {
>>           .header.id = VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
>> -        .header.version = 1,
>> +        .header.version = 2,
>>           .dasm = zdev->dma_mask,
>>           .msi_addr = zdev->msi_addr,
>>           .flags = VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH,
>>           .mui = zdev->fmb_update,
>>           .noi = zdev->max_msi,
>>           .maxstbl = ZPCI_MAX_WRITE_SIZE,
> 
> This, maxstbl, is not part of the patch but shouldn't we consider it too?
> The maxstbl is fixed for intercepted VFIO because the kernel is handling 
> the STBL instruction in behalf of the guest.
> Here the guest will use STBL directly.
> 
> I think we should report the right maxstbl value.
> 

I think we are OK, I think you missed the line that does this already, 
it was added in patch 27 when we wire up interpretive execution.  So, 
here we are defaulting to reporting ZPCI_MAX_WRITE_SIZE, and then ...

>> -        .version = zdev->version
>> +        .version = zdev->version,
>> +        .dtsm = 0
>>       };
>>       /* Some values are different for interpreted devices */
>> -    if (zdev->kzdev && zdev->kzdev->interp)
>> +    if (zdev->kzdev && zdev->kzdev->interp) {
>>           cap.maxstbl = zdev->maxstbl;

... Here we overwrite this with the hardware value only for interpreted 
devices.  Just like we are also now additionally doing for DTSM with 
this patch.

>> +        cap.dtsm = kvm_s390_pci_get_dtsm(zdev);
>> +    }
>>       return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>>   }
>> diff --git a/include/uapi/linux/vfio_zdev.h 
>> b/include/uapi/linux/vfio_zdev.h
>> index 1a5229b7bb18..b4c2ba8e71f0 100644
>> --- a/include/uapi/linux/vfio_zdev.h
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -47,6 +47,9 @@ struct vfio_device_info_cap_zpci_group {
>>       __u16 noi;        /* Maximum number of MSIs */
>>       __u16 maxstbl;        /* Maximum Store Block Length */
>>       __u8 version;        /* Supported PCI Version */
>> +    /* End of version 1 */
>> +    __u8 dtsm;        /* Supported IOAT Designations */
>> +    /* End of version 2 */
>>   };
>>   /**
>>
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CE492D7C
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbiARShX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:37:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244841AbiARShW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:37:22 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IGvHRn030232;
        Tue, 18 Jan 2022 18:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0IMeSBcFtQ6ENgaIyTd1O8tNJg337yrCQNAUAa9CNuM=;
 b=sBHjaKypymUFSYy66ch9aK9FRIYKyVGlpno3gOrNdB00yc82hxS0tjQ3WxpPrPdQ4O5t
 WULWOp0gUjT2s2RpDrrci8gr5Aa3S3CVsCjLgTt0BdSTEE8tPJNwfaxLj5dQptM9ZNzP
 HUCWsh4z2ISfopp0daX6tTOEMcl27Gz6Di3dFpRVnQ4YyHP4+zmtgn1gNtUs/ZsAzDpx
 tbF7A5Re9YxHHm1D61mL95Rb/2jekst+z/D2Wg2SoFp5eX1NzndclR5VSWungazvFXDc
 MIBOZOsGjNvlyK9EfnM8eDXWz+POGcUUu0Y7VXESdT57sXO/AFnGbEOlDh77WpN1FaC+ Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dp1h8aqr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:37:21 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IIPOwL008721;
        Tue, 18 Jan 2022 18:37:20 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dp1h8aqqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:37:20 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IIHn1o030733;
        Tue, 18 Jan 2022 18:37:20 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3dknwaqnqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:37:19 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IIbI2w17957168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:37:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC256E05B;
        Tue, 18 Jan 2022 18:37:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8E1F6E072;
        Tue, 18 Jan 2022 18:37:16 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:37:16 +0000 (GMT)
Message-ID: <104bb7a4-68e7-adb1-91f4-d6fce09b99e7@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:37:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 24/30] vfio-pci/zdev: wire up group notifier
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
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-25-mjrosato@linux.ibm.com>
 <0af94334-27ac-7e05-86ea-465857e9dadd@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0af94334-27ac-7e05-86ea-465857e9dadd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XNtEfXUqbmnCOA7Lp2BBSa6vf4wGX7Cs
X-Proofpoint-GUID: 075JrzAsHVnxKO0CpKjmRzrbnF9Ri7Y5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 12:34 PM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> KVM zPCI passthrough device logic will need a reference to the associated
>> kvm guest that has access to the device.  Let's register a group notifier
>> for VFIO_GROUP_NOTIFY_SET_KVM to catch this information in order to 
>> create
>> an association between a kvm guest and the host zdev.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h  |  2 ++
>>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>>   drivers/vfio/pci/vfio_pci_zdev.c | 46 ++++++++++++++++++++++++++++++++
>>   include/linux/vfio_pci_core.h    | 10 +++++++
>>   4 files changed, 60 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> index fa90729a35cf..97a90b37c87d 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -17,6 +17,7 @@
>>   #include <linux/kvm.h>
>>   #include <linux/pci.h>
>>   #include <linux/mutex.h>
>> +#include <linux/notifier.h>
>>   #include <asm/pci_insn.h>
>>   #include <asm/pci_dma.h>
>> @@ -33,6 +34,7 @@ struct kvm_zdev {
>>       u64 rpcit_count;
>>       struct kvm_zdev_ioat ioat;
>>       struct zpci_fib fib;
>> +    struct notifier_block nb;
>>   };
>>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index f948e6cd2993..fc57d4d0abbe 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -452,6 +452,7 @@ void vfio_pci_core_close_device(struct vfio_device 
>> *core_vdev)
>>       vfio_pci_vf_token_user_add(vdev, -1);
>>       vfio_spapr_pci_eeh_release(vdev->pdev);
>> +    vfio_pci_zdev_release(vdev);
>>       vfio_pci_core_disable(vdev);
>>       mutex_lock(&vdev->igate);
>> @@ -470,6 +471,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
>>   void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
>>   {
>>       vfio_pci_probe_mmaps(vdev);
>> +    vfio_pci_zdev_open(vdev);
>>       vfio_spapr_pci_eeh_open(vdev->pdev);
>>       vfio_pci_vf_token_user_add(vdev, 1);
>>   }
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c 
>> b/drivers/vfio/pci/vfio_pci_zdev.c
>> index ea4c0d2b0663..5c2bddc57b39 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/vfio_zdev.h>
>>   #include <asm/pci_clp.h>
>>   #include <asm/pci_io.h>
>> +#include <asm/kvm_pci.h>
>>   #include <linux/vfio_pci_core.h>
>> @@ -136,3 +137,48 @@ int vfio_pci_info_zdev_add_caps(struct 
>> vfio_pci_core_device *vdev,
>>       return ret;
>>   }
>> +
>> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>> +                    unsigned long action, void *data)
>> +{
>> +    struct kvm_zdev *kzdev = container_of(nb, struct kvm_zdev, nb);
>> +
>> +    if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
>> +        if (!data || !kzdev->zdev)
>> +            return NOTIFY_DONE;
>> +        kvm_s390_pci_attach_kvm(kzdev->zdev, data);
> 
> Why not just set kzdev->kvm = data ?
> 
> alternatively, define kvm_s390_pci_attach_kvm() as an inline instead of 
> a global function.
> 
> otherwise LGTM

At some point in the past this function did more than just set a 
pointer...  You are correct there's no need for this abstraction now, 
let's just set kzdev->kvm = data directly here and drop the 
kvm_s390_pci_attach_kvm function.


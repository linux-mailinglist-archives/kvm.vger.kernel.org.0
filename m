Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE4498356
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 16:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiAXPOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 10:14:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235417AbiAXPOb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 10:14:31 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OF8jGk019013;
        Mon, 24 Jan 2022 15:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YuH+d6eqJAJDwTu5s2YTJrOEVNgjYXK+6+dHM1ygMPU=;
 b=L4K4aO7vDuhe78y0fPUgo9VuftzFIee03SF9jgDdsbZwWAC4Ct/eD2d4nhihGPT7XYWU
 QyC1oO+UQxUk9FXYDkW0SrY06IlOs2Z6TEGJsigYygIgyMTzsp65cIqTIhT8qGVnpzxX
 ba8NF8IMdBdH9Kyxkg7Hs5nzAkxFCYKR2Fi0myieXKkZNG9gcPD2DxyKhxEyaGB1oqqG
 yBQCx6qp5acndp+LJI4T+u96GGQhHyw3cpVsENiSXWqUxgrscLipYgf9EZS563yYBUOO
 LfyFk7D9w7LKsMM4Fnzzi1yGX5xcxovg/k1De+pWhIJ0OE9rt65l8MPHuJf54VdSBTC6 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsx86gmqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:14:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OFA6Qo027355;
        Mon, 24 Jan 2022 15:14:29 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsx86gmq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:14:29 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OFDM6c007772;
        Mon, 24 Jan 2022 15:14:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 3dr9j9gabb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:14:27 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OFEQ557930178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 15:14:26 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7987C6A054;
        Mon, 24 Jan 2022 15:14:26 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EACE6A064;
        Mon, 24 Jan 2022 15:14:24 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 15:14:24 +0000 (GMT)
Message-ID: <1c5009ef-8ec1-ed0a-653a-1f490a9f8458@linux.ibm.com>
Date:   Mon, 24 Jan 2022 10:14:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 18/30] KVM: s390: pci: provide routines for
 enabling/disabling interpretation
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
 <20220114203145.242984-19-mjrosato@linux.ibm.com>
 <1c2a1e60-a4f6-2afa-6479-a2dbd0e6e849@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <1c2a1e60-a4f6-2afa-6479-a2dbd0e6e849@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d__wNOcehUX-3jkTfP3SGlcv-0Z1cO4m
X-Proofpoint-GUID: bfbQs_mK1859lu0Uw63JwRg2D8eqsZPq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_07,2022-01-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 9:36 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> These routines will be wired into the vfio_pci_zdev ioctl handlers to
>> respond to requests to enable / disable a device for zPCI Load/Store
>> interpretation.
>>
>> The first time such a request is received, enable the necessary 
>> facilities
>> for the guest.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h |  4 ++
>>   arch/s390/kvm/pci.c             | 99 +++++++++++++++++++++++++++++++++
>>   arch/s390/pci/pci.c             |  3 +
>>   3 files changed, 106 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> index aafee2976929..072401aa7922 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -26,4 +26,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>>   void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>>   void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>> +int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
>> +
>>   #endif /* ASM_KVM_PCI_H */
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index dae853da6df1..122d0992b521 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -12,7 +12,9 @@
>>   #include <asm/kvm_pci.h>
>>   #include <asm/pci.h>
>>   #include <asm/pci_insn.h>
>> +#include <asm/sclp.h>
>>   #include "pci.h"
>> +#include "kvm-s390.h"
>>   struct zpci_aift *aift;
>> @@ -143,6 +145,103 @@ int kvm_s390_pci_aen_init(u8 nisc)
>>       return rc;
>>   }
>> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
>> +{
>> +    /* Must have appropriate hardware facilities */
>> +    if (!(sclp.has_zpci_lsi && test_facility(69)))
> 
> Should'nt we also test the other facilities we need for the 
> interpretation like ARNI, AISII, ASI and GISA ?
> 
> Or are we sure they are always there when ZPCI load/store interpretation 
> is available?

I think some of these are implicit based on others but I think you're 
right that we should be testing for more than this to be safe.  I think 
additionally test for AENI, AISII, AISI -- basically we should match 
what we test for in patch 17.

> 
> 
>> +        return -EINVAL;
>> +
>> +    /* Must have a KVM association registered */
>> +    if (!zdev->kzdev || !zdev->kzdev->kvm)
>> +        return -EINVAL;
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_probe);
>> +
>> +int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
>> +{
>> +    u32 gd;
>> +    int rc;
>> +
>> +    if (!zdev->kzdev || !zdev->kzdev->kvm)
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * If this is the first request to use an interpreted device, 
>> make the
>> +     * necessary vcpu changes
>> +     */
>> +    if (!zdev->kzdev->kvm->arch.use_zpci_interp)
>> +        kvm_s390_vcpu_pci_enable_interp(zdev->kzdev->kvm);
>> +
>> +    /*
>> +     * In the event of a system reset in userspace, the GISA designation
>> +     * may still be assigned because the device is still enabled.
>> +     * Verify it's the same guest before proceeding.
>> +     */
>> +    gd = (u32)(u64)&zdev->kzdev->kvm->arch.sie_page2->gisa;
> 
> should use the virt_to_phys transformation ?

Yes

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DFE49B63E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579409AbiAYO1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:27:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1578903AbiAYOVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 09:21:35 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PDAMUt004305;
        Tue, 25 Jan 2022 14:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BWyFErJ1Xi2teG/3cp2YJJ7J41rYNrurkfiOgtjVstQ=;
 b=gpaHJW8erHex1Ak+4j+fXANjlH7zFw2Rk4QlSsZ48+unY/o1iDaaS9n2anOvPQ9aji0U
 ATpEXK/32E8b0DXMR0biSKioXud3s9v9wR8sftnxTL5x681qvZnRN0LCpKKkEaP52gsw
 8BZvwydBuqaou1WjIs+XpT+7576z5F+t1yOpGt2odz7z/Kctn530E2r4V+HPvWyB6/pb
 F8b7YHN0MM+Ah9pMsldCYdpn1NokNfQQRBzf8tInpG3EdccMgXCYXGQmyq4ttIHHd4AB
 8Ha++2cFWqfwCFnIVf/LJ2V05IbWKwV//a+RE/qYAqx0NOFAdS7LR3Oaf6IGFk6roqPm vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dthgusvxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:21:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PE7X8F000876;
        Tue, 25 Jan 2022 14:21:33 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dthgusvwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:21:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PEDmVd016227;
        Tue, 25 Jan 2022 14:21:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3dr9j9x2w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:21:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PELUol34406678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 14:21:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD9FBC6066;
        Tue, 25 Jan 2022 14:21:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04974C6057;
        Tue, 25 Jan 2022 14:21:29 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 14:21:28 +0000 (GMT)
Message-ID: <d9cd7c5f-4e3a-2814-eb96-6d3daefcefc0@linux.ibm.com>
Date:   Tue, 25 Jan 2022 09:21:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 25/30] vfio-pci/zdev: wire up zPCI interpretive
 execution support
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
 <20220114203145.242984-26-mjrosato@linux.ibm.com>
 <17ccab21-b654-636f-2dfa-57014f4cd4eb@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <17ccab21-b654-636f-2dfa-57014f4cd4eb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1UCz4G8bEN1lG4XGed0dfK8ezkgHm9e9
X-Proofpoint-ORIG-GUID: mvhauzxgP4Br9mPrZWiKEoUYhv5r0xyu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 8:01 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_INTERP, which is a new
>> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
>> s390x vfio-pci device wishes to enable/disable zPCI interpretive
>> execution, which allows zPCI instructions to be executed directly by
>> underlying firmware without KVM involvement.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h  |  1 +
>>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>>   drivers/vfio/pci/vfio_pci_zdev.c | 78 ++++++++++++++++++++++++++++++++
>>   include/linux/vfio_pci_core.h    | 10 ++++
>>   include/uapi/linux/vfio.h        |  7 +++
>>   include/uapi/linux/vfio_zdev.h   | 15 ++++++
>>   6 files changed, 113 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> index 97a90b37c87d..dc00c3f27a00 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -35,6 +35,7 @@ struct kvm_zdev {
>>       struct kvm_zdev_ioat ioat;
>>       struct zpci_fib fib;
>>       struct notifier_block nb;
>> +    bool interp;
> 
> NIT: s/interp/interpretation/ ?

OK

> 
>>   };
>>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index fc57d4d0abbe..2b2d64a2190c 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1172,6 +1172,8 @@ long vfio_pci_core_ioctl(struct vfio_device 
>> *core_vdev, unsigned int cmd,
>>               mutex_unlock(&vdev->vf_token->lock);
>>               return 0;
>> +        case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
>> +            return vfio_pci_zdev_feat_interp(vdev, feature, arg);
>>           default:
>>               return -ENOTTY;
>>           }
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c 
>> b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 5c2bddc57b39..4339f48b98bc 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -54,6 +54,10 @@ static int zpci_group_cap(struct zpci_dev *zdev, 
>> struct vfio_info_cap *caps)
>>           .version = zdev->version
>>       };
>> +    /* Some values are different for interpreted devices */
>> +    if (zdev->kzdev && zdev->kzdev->interp)
>> +        cap.maxstbl = zdev->maxstbl;
>> +
>>       return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>>   }
>> @@ -138,6 +142,72 @@ int vfio_pci_info_zdev_add_caps(struct 
>> vfio_pci_core_device *vdev,
>>       return ret;
>>   }
>> +int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>> +                  struct vfio_device_feature feature,
>> +                  unsigned long arg)
>> +{
>> +    struct zpci_dev *zdev = to_zpci(vdev->pdev);
>> +    struct vfio_device_zpci_interp *data;
>> +    struct vfio_device_feature *feat;
>> +    unsigned long minsz;
>> +    int size, rc;
>> +
>> +    if (!zdev || !zdev->kzdev)
>> +        return -EINVAL;
>> +
>> +    /* If PROBE specified, return probe results immediately */
>> +    if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
>> +        return kvm_s390_pci_interp_probe(zdev);
>> +
>> +    /* GET and SET are mutually exclusive */
>> +    if ((feature.flags & VFIO_DEVICE_FEATURE_GET) &&
>> +        (feature.flags & VFIO_DEVICE_FEATURE_SET))
>> +        return -EINVAL;
> 
> Isn't the check already done in VFIO core?

Oh, yes you are correct.  Then this can be removed for this patch as 
well as the next 2 patches.



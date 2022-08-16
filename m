Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FD859639A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 22:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiHPURJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 16:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiHPURH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 16:17:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9D386056;
        Tue, 16 Aug 2022 13:17:06 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GJiKuA026672;
        Tue, 16 Aug 2022 20:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tp1MHkI0UUSS9oO8IOYre52rIH7aIcpzcB8WlGj2wVI=;
 b=ZKxXe0w2g6mZWAdLSbbkt7lxXyL/HOZ7k1A1v3GMlRyJc+Hy87V+tTDkdDvADls/p68F
 rlbmSJnLjDI+yXUPRt6b2OETx8hpvjyBg99JWLuuo/USG9dBM4+QXhCmSGxevoDpKIoZ
 oSdbfzp+k2nn2BwV3nwcc8b36bhJBtlLB7Tnmxw+WBTni3xO+k1s07qmjjqencGuvQck
 VEzN7BQldXiqXOUCh+MvFtupfYcWpQ3GamW4ml1DYpWjTRIe5TTSDel/trE93Ffbio3j
 tUN5QZQ3BkpGUop5PRbpUXCkWyxO4jexsvU5MyBITK9Ztdtb5SzqmRmWma/3WwNgppV4 FQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0hne0r57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 20:17:01 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GK8UE0031280;
        Tue, 16 Aug 2022 20:16:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3hx3k8tpc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 20:16:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GKGurr25231648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 20:16:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68EA55204F;
        Tue, 16 Aug 2022 20:16:56 +0000 (GMT)
Received: from [9.171.18.167] (unknown [9.171.18.167])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 02DC15204E;
        Tue, 16 Aug 2022 20:16:55 +0000 (GMT)
Message-ID: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
Date:   Tue, 16 Aug 2022 22:22:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220814215154.32112-1-rdunlap@infradead.org>
 <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
 <5530ed1f-90ec-ce84-2348-80e484fa48cb@infradead.org>
 <47cfc72d-62f6-2bd3-db91-99f91591fc30@linux.ibm.com>
 <8809c67b-a9f6-07a6-307c-369cd391e9b5@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <8809c67b-a9f6-07a6-307c-369cd391e9b5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7yvMYbJzY7dLzaGKCdDAEbNPMRYJmLrW
X-Proofpoint-ORIG-GUID: 7yvMYbJzY7dLzaGKCdDAEbNPMRYJmLrW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/22 21:46, Matthew Rosato wrote:
> On 8/16/22 3:55 AM, Pierre Morel wrote:
>>
>>
>> On 8/16/22 08:04, Randy Dunlap wrote:
>>> Hi--
>>>
>>> On 8/15/22 02:43, Pierre Morel wrote:
>>>> Thank you Randy for this good catch.
>>>> However forcing KVM to be include statically in the kernel when using VFIO_PCI extensions is not a good solution for us I think.
>>>>
>>>> I suggest we better do something like:
>>>>
>>>> ----
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>> index 6287a843e8bc..1733339cc4eb 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -1038,7 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>>    #define __KVM_HAVE_ARCH_VM_FREE
>>>>    void kvm_arch_free_vm(struct kvm *kvm);
>>>>
>>>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>>>> +#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)
>>>
>>> This all looks good except for the line above.
>>> It should be:
>>>
>>> #if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
>>>
>>> Thanks.
>>
>> Yes, better, thanks.
>> How do we do? Should I repost it with reported-by you or do you want to post it?
>>
>> Pierre
> 
> Thanks for looking into this while I was away.
> 
> I think the issue is not just CONFIG_KVM=m && CONFIG_VFIO_PCI_ZDEV_KVM=y -- it also requires CONFIG_VFIO_PCI=y && CONFIG_VFIO_PCI_CORE=y.  This combination results in building in vfio_pci (which tries to link the calls to kvm_s390_pci_register_kvm and kvm_s390_pci_unregister_kvm which is not built in).
> 
> However... this tristate + IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) check in kvm_host.h will not solve the issue.  Rather, due to the #ifdef CONFIG_VFIO_PCI_ZDEV_KVM in include/linux/vfio_pci_core.h, this change will just cause us to never call kvm_s390_pci_register_kvm or kvm_s390_pci_unregister_kvm when CONFIG_VFIO_PCI_ZDEV_KVM=m, effectively treating CONFIG_VFIO_PCI_ZDEV_KVM=m as a 'n' and we don't get the zdev kvm extensions, which I don't think was the intent.
> 
> I'm still thinking & am open to other ideas, but one solution to avoiding building in KVM would be to go back to using symbol_get for these 2 interfaces (kvm_s390_pci_register_kvm and kvm_s390_pci_unregister_kvm) as was done in a prior version of this series like virt/kvm/vfio.c does and otherwise leave CONFIG_VFIO_PCI_ZDEV_KVM as-is.
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index e163aa9f6144..09c2758134c7 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -144,6 +144,8 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>   {
>          struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +       int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
> +       int rc;
>   
>          if (!zdev)
>                  return -ENODEV;
> @@ -151,15 +153,30 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>          if (!vdev->vdev.kvm)
>                  return 0;
>   
> -       return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
> +       fn = symbol_get(kvm_s390_pci_register_kvm);
> +       if (!fn)
> +               return -EPERM;
> +
> +       rc = fn(zdev, vdev->vdev.kvm);
> +
> +       symbol_put(kvm_s390_pci_register_kvm);
> +
> +       return rc;
>   }
>   
>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>   {
>          struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +       void (*fn)(struct zpci_dev *zdev);
>   
>          if (!zdev || !vdev->vdev.kvm)
>                  return;
>   
> -       kvm_s390_pci_unregister_kvm(zdev);
> +       fn = symbol_get(kvm_s390_pci_unregister_kvm);
> +       if (!fn)
> +               return;
> +
> +       fn(zdev);
> +
> +       symbol_put(kvm_s390_pci_unregister_kvm);
>   }
> 
> 


Hello Matt,

In between I came to another solution that seems to satisfy the 
dependencies.
Still need to check that the functionality is still intact :)

I send you the proposition as a reply.

Regards,
Pierre




-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE96596353
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 21:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiHPTqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 15:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiHPTqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 15:46:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4C674CC3;
        Tue, 16 Aug 2022 12:46:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GIpOAo029252;
        Tue, 16 Aug 2022 19:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FA/YZEorWGopm5U5huyhgTuqb3uMb4Ubp7IzrsXxATg=;
 b=OG9eapcr317HRe50bFJj4eSXe1E/ThbkGfb30+wl4WRxt8jJgQata5nMN5QMqH1sO4C7
 1JTMUUxf+oUlrtBon9v0RoKqOoDKwu2rK0VNms/nT59IjFww1UIkL7s61LSQNhtzdWBj
 Z6xj2JK/pD7sDV6OOVQiTQIT1BwrXewFOUn8Wo9gjiX0vyfnOCbOMIrVAloo7wrktQ69
 CBGuPriv/I9chLMiVWqkyJiTyTA0hiBssuTNP4ttaaLYZUh+HOCuoBys40tRRJj3zRLS
 i62QK7xOvwOR0iGoO7uH9vgMo2A127BmhF+keQ3EUYHvEgpWY820p1CXaZV5Ec9rPZBC Jg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0gvtheqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 19:46:28 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GJZstr021577;
        Tue, 16 Aug 2022 19:46:28 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 3hx3k9uy50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 19:46:28 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GJkRrM63308222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 19:46:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A46E6A04D;
        Tue, 16 Aug 2022 19:46:27 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3610A6A051;
        Tue, 16 Aug 2022 19:46:26 +0000 (GMT)
Received: from [9.211.113.217] (unknown [9.211.113.217])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 19:46:25 +0000 (GMT)
Message-ID: <8809c67b-a9f6-07a6-307c-369cd391e9b5@linux.ibm.com>
Date:   Tue, 16 Aug 2022 15:46:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <47cfc72d-62f6-2bd3-db91-99f91591fc30@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: owcYnHneUBOK5UU669Xqu_RZwQwNIgOz
X-Proofpoint-ORIG-GUID: owcYnHneUBOK5UU669Xqu_RZwQwNIgOz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/22 3:55 AM, Pierre Morel wrote:
> 
> 
> On 8/16/22 08:04, Randy Dunlap wrote:
>> Hi--
>>
>> On 8/15/22 02:43, Pierre Morel wrote:
>>> Thank you Randy for this good catch.
>>> However forcing KVM to be include statically in the kernel when using VFIO_PCI extensions is not a good solution for us I think.
>>>
>>> I suggest we better do something like:
>>>
>>> ----
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>> index 6287a843e8bc..1733339cc4eb 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -1038,7 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>   #define __KVM_HAVE_ARCH_VM_FREE
>>>   void kvm_arch_free_vm(struct kvm *kvm);
>>>
>>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>>> +#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)
>>
>> This all looks good except for the line above.
>> It should be:
>>
>> #if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
>>
>> Thanks.
> 
> Yes, better, thanks.
> How do we do? Should I repost it with reported-by you or do you want to post it?
> 
> Pierre

Thanks for looking into this while I was away.

I think the issue is not just CONFIG_KVM=m && CONFIG_VFIO_PCI_ZDEV_KVM=y -- it also requires CONFIG_VFIO_PCI=y && CONFIG_VFIO_PCI_CORE=y.  This combination results in building in vfio_pci (which tries to link the calls to kvm_s390_pci_register_kvm and kvm_s390_pci_unregister_kvm which is not built in).

However... this tristate + IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) check in kvm_host.h will not solve the issue.  Rather, due to the #ifdef CONFIG_VFIO_PCI_ZDEV_KVM in include/linux/vfio_pci_core.h, this change will just cause us to never call kvm_s390_pci_register_kvm or kvm_s390_pci_unregister_kvm when CONFIG_VFIO_PCI_ZDEV_KVM=m, effectively treating CONFIG_VFIO_PCI_ZDEV_KVM=m as a 'n' and we don't get the zdev kvm extensions, which I don't think was the intent.

I'm still thinking & am open to other ideas, but one solution to avoiding building in KVM would be to go back to using symbol_get for these 2 interfaces (kvm_s390_pci_register_kvm and kvm_s390_pci_unregister_kvm) as was done in a prior version of this series like virt/kvm/vfio.c does and otherwise leave CONFIG_VFIO_PCI_ZDEV_KVM as-is. 

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index e163aa9f6144..09c2758134c7 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -144,6 +144,8 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
 {
        struct zpci_dev *zdev = to_zpci(vdev->pdev);
+       int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
+       int rc;
 
        if (!zdev)
                return -ENODEV;
@@ -151,15 +153,30 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
        if (!vdev->vdev.kvm)
                return 0;
 
-       return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
+       fn = symbol_get(kvm_s390_pci_register_kvm);
+       if (!fn)
+               return -EPERM;
+
+       rc = fn(zdev, vdev->vdev.kvm);
+
+       symbol_put(kvm_s390_pci_register_kvm);
+
+       return rc;
 }
 
 void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 {
        struct zpci_dev *zdev = to_zpci(vdev->pdev);
+       void (*fn)(struct zpci_dev *zdev);
 
        if (!zdev || !vdev->vdev.kvm)
                return;
 
-       kvm_s390_pci_unregister_kvm(zdev);
+       fn = symbol_get(kvm_s390_pci_unregister_kvm);
+       if (!fn)
+               return;
+
+       fn(zdev);
+
+       symbol_put(kvm_s390_pci_unregister_kvm);
 }



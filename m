Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C1E55E486
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbiF1N3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346424AbiF1N2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:28:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08ABDBA;
        Tue, 28 Jun 2022 06:28:08 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDNAoT030332;
        Tue, 28 Jun 2022 13:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9g8LeguO+QAkdNpce2uyIpU26i1yVeR9+/lrxk/JDHo=;
 b=j8Xiz0YWwuirnRwF6TmAFVzrTCREgIIib12MMcbgjarwV8MdfMpirg+GylBexnYAcfi7
 wJbjdO5Vobj/GSedqggAxR+eTwDNYwlayMGPOtL1+WxuMY2AHu6KdU1LRSvr68c0UV7x
 f2Mmr09X0OlCT5d66h5OQfs7nATViHTAE1leH519jLoEV/RXB39r/fqzm+qREJce8lIk
 0dybbTbV+sNzIoqpZA95I8H1Kgtit0K6FnNcxOgpKjSkMWoMjCgYTXUGxBkpXDcs8B8e
 q7wkhrHsm9ja48BnC22ZjIXmPIhP9okYLw61xcicdcEMPZJmaB+NhvNLYeoHsz6Yvwa/ dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02fxg644-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:28:04 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDO3r1032642;
        Tue, 28 Jun 2022 13:28:03 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02fxg63d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:28:03 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDJkL4003023;
        Tue, 28 Jun 2022 13:28:03 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3gwt09wgyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:28:03 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDS2vQ7733562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:28:02 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74F26AC064;
        Tue, 28 Jun 2022 13:28:02 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD93DAC05B;
        Tue, 28 Jun 2022 13:27:56 +0000 (GMT)
Received: from [9.163.8.193] (unknown [9.163.8.193])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:27:56 +0000 (GMT)
Message-ID: <beff8d5e-a670-8015-028f-a704627a2b16@linux.ibm.com>
Date:   Tue, 28 Jun 2022 09:27:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 16/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-17-mjrosato@linux.ibm.com>
 <7a9990ca-b591-1351-8848-8d7c59449b12@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7a9990ca-b591-1351-8848-8d7c59449b12@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _iNB2a_hk9BxPqrJ8pJ-lOn4G88jWJ2o
X-Proofpoint-ORIG-GUID: A5RmqVfNa3oFbCqkZ09xv3u70fQU8Mqt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 6:53 AM, Pierre Morel wrote:
> 
> 
> On 6/6/22 22:33, Matthew Rosato wrote:
>> These routines will be invoked at the time an s390x vfio-pci device is
>> associated with a KVM (or when the association is removed), allowing
>> the zPCI device to enable or disable load/store intepretation mode;
>> this requires the host zPCI device to inform firmware of the unique
>> token (GISA designation) that is associated with the owning KVM.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  18 ++++
>>   arch/s390/include/asm/pci.h      |   1 +
>>   arch/s390/kvm/kvm-s390.c         |  15 +++
>>   arch/s390/kvm/pci.c              | 162 +++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h              |   5 +
>>   arch/s390/pci/pci.c              |   4 +
>>   6 files changed, 205 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index 8e381603b6a7..6e83d746bae2 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -19,6 +19,7 @@
>>   #include <linux/kvm.h>
>>   #include <linux/seqlock.h>
>>   #include <linux/module.h>
>> +#include <linux/pci.h>
>>   #include <asm/debug.h>
>>   #include <asm/cpu.h>
>>   #include <asm/fpu/api.h>
>> @@ -967,6 +968,8 @@ struct kvm_arch{
>>       DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>>       struct kvm_s390_gisa_interrupt gisa_int;
>>       struct kvm_s390_pv pv;
>> +    struct list_head kzdev_list;
>> +    spinlock_t kzdev_list_lock;
>>   };
>>   #define KVM_HVA_ERR_BAD        (-1UL)
>> @@ -1017,4 +1020,19 @@ static inline void 
>> kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>> +#define __KVM_HAVE_ARCH_VM_FREE
>> +void kvm_arch_free_vm(struct kvm *kvm);
>> +
>> +#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>> +void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>> +#else
>> +static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
>> +                        struct kvm *kvm)
>> +{
>> +    return -EPERM;
>> +}
>> +static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
>> +#endif
>> +
>>   #endif
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 322060a75d9f..85eb0ef9d4c3 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -194,6 +194,7 @@ struct zpci_dev {
>>       /* IOMMU and passthrough */
>>       struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>>       struct kvm_zdev *kzdev;
>> +    struct mutex kzdev_lock;
> 
> I guess that since it did not exist before the lock is not there to 
> protect the zpci_dev struct.

Right, not the zpci_dev itself but it is protecting the contents of the 
kzdev (including the pointer to the zdev e.g. kzdev->zdev)

> May be add a comment to say what it is protecting.

Sure

> 
> 
>>   };
>>   static inline bool zdev_enabled(struct zpci_dev *zdev)
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index a66da3f66114..4758bb731199 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2790,6 +2790,14 @@ static void sca_dispose(struct kvm *kvm)
>>       kvm->arch.sca = NULL;
>>   }
>> +void kvm_arch_free_vm(struct kvm *kvm)
>> +{
>> +    if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>> +        kvm_s390_pci_clear_list(kvm);
>> +
>> +    __kvm_arch_free_vm(kvm);
>> +}
>> +
>>   int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   {
>>       gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
>> @@ -2872,6 +2880,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned 
>> long type)
>>       kvm_s390_crypto_init(kvm);
>> +    if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
>> +        mutex_lock(&kvm->lock);
>> +        kvm_s390_pci_init_list(kvm);
>> +        kvm_s390_vcpu_pci_enable_interp(kvm);
>> +        mutex_unlock(&kvm->lock);
>> +    }
>> +
>>       mutex_init(&kvm->arch.float_int.ais_lock);
>>       spin_lock_init(&kvm->arch.float_int.lock);
>>       for (i = 0; i < FIRQ_LIST_COUNT; i++)
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index b232c8cbaa81..24211741deb0 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -12,7 +12,9 @@
>>   #include <asm/pci.h>
>>   #include <asm/pci_insn.h>
>>   #include <asm/pci_io.h>
>> +#include <asm/sclp.h>
>>   #include "pci.h"
>> +#include "kvm-s390.h"
>>   struct zpci_aift *aift;
>> @@ -423,6 +425,166 @@ static void kvm_s390_pci_dev_release(struct 
>> zpci_dev *zdev)
>>       kfree(kzdev);
>>   }
>> +
>> +/*
>> + * Register device with the specified KVM. If interpetation 
>> facilities are
>> + * available, enable them and let userspace indicate whether or not 
>> they will
>> + * be used (specify SHM bit to disable).
>> + */
>> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>> +{
>> +    int rc;
>> +
>> +    if (!zdev)
>> +        return -EINVAL;
>> +
>> +    mutex_lock(&zdev->kzdev_lock);
>> +
>> +    if (zdev->kzdev || zdev->gisa != 0 || !kvm) {
>> +        mutex_unlock(&zdev->kzdev_lock);
>> +        return -EINVAL;
>> +    }
>> +
>> +    kvm_get_kvm(kvm);
>> +
>> +    mutex_lock(&kvm->lock);
> 
> Why do we need to lock KVM here?

Hmm, good point, now that we get a reference this seems unnecessary

> 
> just a question, I do not think it is a big problem.
> 
>> +
>> +    rc = kvm_s390_pci_dev_open(zdev);
>> +    if (rc)
>> +        goto err;
>> +
>> +    /*
>> +     * If interpretation facilities aren't available, add the device to
>> +     * the kzdev list but don't enable for interpretation.
>> +     */
>> +    if (!kvm_s390_pci_interp_allowed())
>> +        goto out;
>> +
>> +    /*
>> +     * If this is the first request to use an interpreted device, 
>> make the
>> +     * necessary vcpu changes
>> +     */
>> +    if (!kvm->arch.use_zpci_interp)
>> +        kvm_s390_vcpu_pci_enable_interp(kvm);
>> +
>> +    if (zdev_enabled(zdev)) {
>> +        rc = zpci_disable_device(zdev);
>> +        if (rc)
>> +            goto err;
>> +    }
>> +
>> +    /*
>> +     * Store information about the identity of the kvm guest allowed to
>> +     * access this device via interpretation to be used by host CLP
>> +     */
>> +    zdev->gisa = (u32)virt_to_phys(&kvm->arch.sie_page2->gisa);
>> +
>> +    rc = zpci_enable_device(zdev);
>> +    if (rc)
>> +        goto clear_gisa;
>> +
>> +    /* Re-register the IOMMU that was already created */
>> +    rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
>> +                virt_to_phys(zdev->dma_table));
>> +    if (rc)
>> +        goto clear_gisa;
>> +
>> +out:
>> +    zdev->kzdev->kvm = kvm;
>> +
>> +    spin_lock(&kvm->arch.kzdev_list_lock);
>> +    list_add_tail(&zdev->kzdev->entry, &kvm->arch.kzdev_list);
>> +    spin_unlock(&kvm->arch.kzdev_list_lock);
>> +
>> +    mutex_unlock(&kvm->lock);
>> +    mutex_unlock(&zdev->kzdev_lock);
>> +    return 0;
>> +
>> +clear_gisa:
>> +    zdev->gisa = 0;
>> +err:
>> +    if (zdev->kzdev)
>> +        kvm_s390_pci_dev_release(zdev);
>> +    mutex_unlock(&kvm->lock);
>> +    mutex_unlock(&zdev->kzdev_lock);
>> +    kvm_put_kvm(kvm);
>> +    return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>> +
>> +void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>> +{
>> +    struct kvm *kvm;
>> +
>> +    if (!zdev)
>> +        return;
>> +
>> +    mutex_lock(&zdev->kzdev_lock);
>> +
>> +    if (WARN_ON(!zdev->kzdev)) {
> 
> When can this happen ?
> 

It cannot today, nor should it ever (hence the WARN_ON) -- if we do, 
it's a case of programming error introduced somewhere (vfio has a KVM 
reference but we never built a kzdev via kvm_s390_pci_register_kvm or 
lost it somehow)

>> +        mutex_unlock(&zdev->kzdev_lock);
>> +        return;
>> +    }
>> +
>> +    kvm = zdev->kzdev->kvm;
>> +    mutex_lock(&kvm->lock);
>> +
>> +    /*
>> +     * A 0 gisa means interpretation was never enabled, just remove the
>> +     * device from the list.
>> +     */
>> +    if (zdev->gisa == 0)
>> +        goto out;
>> +
>> +    /* Forwarding must be turned off before interpretation */
>> +    if (zdev->kzdev->fib.fmt0.aibv != 0)
>> +        kvm_s390_pci_aif_disable(zdev, true);
>> +
>> +    /* Remove the host CLP guest designation */
>> +    zdev->gisa = 0;
>> +
>> +    if (zdev_enabled(zdev)) {
>> +        if (zpci_disable_device(zdev))
>> +            goto out;
> 
> NIT debug trace ?

We should at least get a trace entry in from clp_disable_fh() if 
something goes wrong here.

> 
>> +    }
>> +
>> +    if (zpci_enable_device(zdev))
>> +        goto out;
> 
> NIT debug trace?

And similarly, a trace entry from clp_enable_fh() here.  So I think 
these are OK for now.

I am consdering a follow-on to add new s390dbf entries for 'kvm-pci' or 
so, these might make sense there for additional context, but let's leave 
that for after this series.

> 
> Only some questions, otherwise, LGTM
> 
> Acked-by: Pierre Morel <pmorel@linux.ibm.com>
> 

Thanks!


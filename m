Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF21D598734
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344179AbiHRPOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245145AbiHRPOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:14:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A317BDA;
        Thu, 18 Aug 2022 08:14:07 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IF0hfI006424;
        Thu, 18 Aug 2022 15:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gDfVvxaxVHJXxV9EK5iBt/ra3/IcYCP84dYse9Yc8BU=;
 b=Qfe4AbKjIBUTQh7a6yz+4corxNQv6LoYLDnC/8C0V2FS/soF7SZaUsPfmBPopas8t2e5
 NAwRMP/JXPialMtd+rrUc5vHXeYc4iqSYIHx6sg9nMk5aqY4WRgquN46wxBTKuk0qqC+
 64Jm9phS8qvg+YgyQLPt6Sk5bBivHig+y4WJNgZ0+Ll8KgpwNFS2458Aa4UJyxQYFAkm
 jwb3HH2396ZhKaLu+R4x6/msVVNdd83slrxIdPhb6E+TVYpabGvOqJXqyOGvR4aJSSBY
 4v+Q0IKFjsMdH8uFL1Wpx5veHePDx0nw4HUDnwjQawF0cVNcWFHyZ066enDohw5k0wf8 hQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1qpp0jjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:14:01 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IF77Kt004369;
        Thu, 18 Aug 2022 15:14:00 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3j1gh6t6kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:14:00 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IFDxDd5571208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 15:13:59 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C61D5124055;
        Thu, 18 Aug 2022 15:13:59 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A7C8124052;
        Thu, 18 Aug 2022 15:13:57 +0000 (GMT)
Received: from [9.211.138.234] (unknown [9.211.138.234])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 15:13:56 +0000 (GMT)
Message-ID: <d874d06d-359d-0cc2-283b-cf4cfd5789e9@linux.ibm.com>
Date:   Thu, 18 Aug 2022 11:13:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
 <20220818102305.250702-1-pmorel@linux.ibm.com>
 <f797373e-c420-718a-443d-ae98ea0368c7@linux.ibm.com>
 <25e2364a71c52651f5227c0bc3f43fd193bc2e08.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <25e2364a71c52651f5227c0bc3f43fd193bc2e08.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u2FA9kOwIFJVcrxFcCA5ntWtUiiJj-GL
X-Proofpoint-ORIG-GUID: u2FA9kOwIFJVcrxFcCA5ntWtUiiJj-GL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/22 10:20 AM, Niklas Schnelle wrote:
> On Thu, 2022-08-18 at 09:33 -0400, Matthew Rosato wrote:
>> On 8/18/22 6:23 AM, Pierre Morel wrote:
>>> We have a cross dependency between KVM and VFIO.
>>
>> maybe add something like 'when using s390 vfio_pci_zdev extensions for PCI passthrough'
>>
>>> To be able to keep both subsystem modular we add a registering
>>> hook inside the S390 core code.
>>>
>>> This fixes a build problem when VFIO is built-in and KVM is built
>>> as a module or excluded.
>>
>> s/or excluded//
>>
>> There's no problem when KVM is excluded, that forces CONFIG_VFIO_PCI_ZDEV_KVM=n because of the 'depends on S390 && KVM'.
>>
>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>>>  arch/s390/kvm/pci.c              | 10 ++++++----
>>>  arch/s390/pci/Makefile           |  2 ++
>>>  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>>>  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>>>  5 files changed, 31 insertions(+), 17 deletions(-)
>>>  create mode 100644 arch/s390/pci/pci_kvm_hook.c
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>> index f39092e0ceaa..8312ed9d1937 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
> 
> I added Janosch as second S390 KVM maintainer in case he wants to chime
> in.
> 
>>> @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>  #define __KVM_HAVE_ARCH_VM_FREE
>>>  void kvm_arch_free_vm(struct kvm *kvm);
>>>  
>>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>>> -#else
>>> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
>>> -					    struct kvm *kvm)
>>> -{
>>> -	return -EPERM;
>>> -}
>>> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
>>> -#endif
>>> +struct kvm_register_hook {
>>
>> Nit: zpci_kvm_register_hook ?  Just to make it clear it's for zpci.
> 
> Hmm, I guess one could re-use the same struct for another such KVM
> dependency but I lean towards the same thinking as Matt, for now this
> is for zpci so stay specific we can always generalize later.

Yes, let's keep this zpci-specific. 

> 
> Nit: For me hook and register together sound a bit redudant, maybe
> "zpci_kvm_register"? Also question for Matt as a native speaker, should
> it rather be "registration" when used as a noun here?
> 

Maybe just drop the 'register'.  If there is a need for a 3rd function later, for example, it might not be related to registration.

e.g. struct kvm_zpci_hook {
   ...
};

extern struct kvm_zpci_hook zpci_kvm;

> 
>>
>>> +	int (*kvm_register)(void *opaque, struct kvm *kvm);
>>> +	void (*kvm_unregister)(void *opaque);
> 
> I do wonder if this needs to be opague "struct zpci_dev" should be
> defined even if CONFIG_PCI is unset.
> 
> 
>>> +};
>>> +
>>> +extern struct kvm_register_hook kvm_pci_hook;
>>
>> Nit: kvm_zpci_hook ?
> 
> Analogous to zpci_kvm_regist(er|ration) I would call the variable
> simply zpci_kvm i.e. the type is a registration and the variable is the
> instance of it that links zpci and kvm.
> 

Yeah, see above.

>>
>>>  
>>>  #endif
>>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>>> index 4946fb7757d6..e173fce64c4f 100644
>>> --- a/arch/s390/kvm/pci.c
>>> +++ b/arch/s390/kvm/pci.c
>>> @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>>>   * available, enable them and let userspace indicate whether or not they will
>>>   * be used (specify SHM bit to disable).
>>>   */
>>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>>> +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
>>>  {
>>> +	struct zpci_dev *zdev = opaque;
>>>  	int rc;
>>>  
>>>  	if (!zdev)
>>> @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>>>  	kvm_put_kvm(kvm);
>>>  	return rc;
>>>  }
>>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>>>  
>>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>>> +static void kvm_s390_pci_unregister_kvm(void *opaque)
>>>  {
>>> +	struct zpci_dev *zdev = opaque;
>>>  	struct kvm *kvm;
>>>  
>>>  	if (!zdev)
>>> @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>>>  
>>>  	kvm_put_kvm(kvm);
>>>  }
>>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>>>  
>>>  void kvm_s390_pci_init_list(struct kvm *kvm)
>>>  {
>>> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>>>  
>>>  	spin_lock_init(&aift->gait_lock);
>>>  	mutex_init(&aift->aift_lock);
>>> +	kvm_pci_hook.kvm_register = kvm_s390_pci_register_kvm;
>>> +	kvm_pci_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>>>  
>>>  	return 0;
>>>  }
>>> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
>>> index bf557a1b789c..c02dbfb415d9 100644
>>> --- a/arch/s390/pci/Makefile
>>> +++ b/arch/s390/pci/Makefile
>>> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>>>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>>>  			   pci_bus.o
>>>  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>>> +
>>> +obj-y += pci_kvm_hook.o
>>
>> I guess it doesn't harm anything to add this unconditionally, but I think it would also be OK to just include this in the CONFIG_PCI list - vfio_pci_zdev and arch/s390/kvm/pci all rely on CONFIG_PCI via CONFIG_VFIO_PCI_ZDEV_KVM which implies PCI via VFIO_PCI.
>>
>>> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
>>> new file mode 100644
>>> index 000000000000..9d8799b72dbf
>>> --- /dev/null
>>> +++ b/arch/s390/pci/pci_kvm_hook.c
>>> @@ -0,0 +1,11 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * VFIO ZPCI devices support
>>> + *
>>> + * Copyright (C) IBM Corp. 2022.  All rights reserved.
>>> + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>>> + */
>>> +#include <linux/kvm_host.h>
>>> +
>>> +struct kvm_register_hook kvm_pci_hook;
>>> +EXPORT_SYMBOL_GPL(kvm_pci_hook);
>>
>> Following the comments above, zpci_kvm_register_hook, kvm_zpci_hook ?
>>
>> I'm not sure if this really needs to be in a separate file or if it could just go into arch/s390/pci.c with the zpci_aipb -- If going the route of a separate file, up to Niklas whether he wants this under the S390 PCI maintainership or added to the list for s390 vfio-pci like arch/kvm/pci* and vfio_pci_zdev.
> 
> I'm fine with a separate file, pci.c is long enough as it is. I also
> don't have a problem with having it maintained as part of S390 PCI but
> logically I think it does fall more under arch/kvm/pci* so one could
> argue it should be added in the MAINTAINERS file in that section.
> If you change the struct name as I proposed above I would probably go
> with "pci_kvm_register.c"

OK, no problem with me for a separate file then, or maintaining said file.  But I guess not pci_kvm_register.c per my comments above

> 
>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>>> index e163aa9f6144..3b7a707e2fe5 100644
>>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>>> @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>>  	if (!vdev->vdev.kvm)
>>>  		return 0;
>>>  
>>> -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
>>> +	if (kvm_pci_hook.kvm_register)
>>> +		return kvm_pci_hook.kvm_register(zdev, vdev->vdev.kvm);
>>> +
>>> +	return -ENOENT;
>>>  }
>>>  
>>>  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>> @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>>  	if (!zdev || !vdev->vdev.kvm)
>>>  		return;
>>>  
>>> -	kvm_s390_pci_unregister_kvm(zdev);
>>> +	if (kvm_pci_hook.kvm_unregister)
>>> +		return kvm_pci_hook.kvm_unregister(zdev);
>>
>> No need for the return here, this is a void function calling a void function.
>>
>>
>> Overall, this looks good to me and survives a series of compile and device passthrough tests on my end, just a matter of a few of these minor comments above.  Thanks for tackling this Pierre!
> 
> Yes I agree, overall this looks good to me though I'm admittedly not
> very knowledgable about how to best handle module dependencies like
> this. It does look cleaner than  the symbol_get() alternative we
> discussed. 
> 
> 


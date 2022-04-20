Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC71A508F34
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 20:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348933AbiDTSRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 14:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381451AbiDTSRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 14:17:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48335CCE;
        Wed, 20 Apr 2022 11:14:51 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KHkq5Z006711;
        Wed, 20 Apr 2022 18:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VrULSZDwQcqW2v9J2Ht5Th8h1TMcPcpzg0ef6YMWGp0=;
 b=NbnfSg6wI/2aBpu7LzGrm1aFDhwsfWwvNec7BKMvbw5vxKN9kj7pYAKJ+n5GkjRTRaQy
 XoEpr+13faKm1TL3jrFEypvTwXgcLB0obt/TaWootx2TW/SMphKWx8OMoyChFFtUvqlB
 vNUSbjFXG04sxm0W0qfUPzvlroI5pTUEz1ME/X0UQ8xw3Zri60weaYDrjiy6WdeuWSLK
 Wxe/YrCSRRmY/gV2M3PRp31KB45VGmGyD9cisgYEO9LRyHQHVGSGXs7MeYhtdWElL3ls
 nNuekM5jxM+eRHXoHwvtqRUlCRnj97oNV/ljnP+EeV8XvxeOOkIYPyFN4GdCOMA9uKTW nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsxrgny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:14:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KHoXcx027396;
        Wed, 20 Apr 2022 18:14:49 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjhsxrgna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:14:49 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KIDn9g015342;
        Wed, 20 Apr 2022 18:14:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u3rm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:14:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KIEskm8454846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 18:14:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75FABAE045;
        Wed, 20 Apr 2022 18:14:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43F43AE04D;
        Wed, 20 Apr 2022 18:14:42 +0000 (GMT)
Received: from [9.171.15.220] (unknown [9.171.15.220])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 18:14:42 +0000 (GMT)
Message-ID: <e46c1ff0-9afb-ee8b-0104-92a04b385081@linux.ibm.com>
Date:   Wed, 20 Apr 2022 20:18:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 19/21] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
 zPCI devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-20-mjrosato@linux.ibm.com>
 <de630458-f48a-1b97-2bd3-53284c7d2a5e@linux.ibm.com>
 <754b4f2e-00ba-07b0-b848-29b714c9d3b3@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <754b4f2e-00ba-07b0-b848-29b714c9d3b3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1OR0lOB1IdbY4op7401JCN90_48R4y_O
X-Proofpoint-GUID: 2i52rYo9NEuh7zBfFZj83QR4ZXiBxH3n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200107
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/22 16:10, Matthew Rosato wrote:
> On 4/19/22 6:07 AM, Pierre Morel wrote:
>>
>>
>> On 4/4/22 19:43, Matthew Rosato wrote:
>>> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
>>> hardware-assisted virtualization features for s390X zPCI passthrough.
>>> Add the first 2 operations, which can be used to enable/disable
>>> the specified device for Adapter Event Notification interpretation.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++++++
>>>   arch/s390/kvm/kvm-s390.c       | 23 ++++++++++++
>>>   arch/s390/kvm/pci.c            | 65 ++++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/pci.h            |  2 ++
>>>   include/uapi/linux/kvm.h       | 31 ++++++++++++++++
>>>   5 files changed, 166 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst 
>>> b/Documentation/virt/kvm/api.rst
>>> index d13fa6600467..474f502c2ea0 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -5645,6 +5645,51 @@ enabled with ``arch_prctl()``, but this may 
>>> change in the future.
>>>   The offsets of the state save areas in struct kvm_xsave follow the 
>>> contents
>>>   of CPUID leaf 0xD on the host.
>>> +4.135 KVM_S390_ZPCI_OP
>>> +--------------------
>>> +
>>> +:Capability: KVM_CAP_S390_ZPCI_OP
>>> +:Architectures: s390
>>> +:Type: vcpu ioctl
>>> +:Parameters: struct kvm_s390_zpci_op (in)
>>> +:Returns: 0 on success, <0 on error
>>> +
>>> +Used to manage hardware-assisted virtualization features for zPCI 
>>> devices.
>>> +
>>> +Parameters are specified via the following structure::
>>> +
>>> +  struct kvm_s390_zpci_op {
>>> +    /* in */
>>> +    __u32 fh;        /* target device */
>>> +    __u8  op;        /* operation to perform */
>>> +    __u8  pad[3];
>>> +    union {
>>> +        /* for KVM_S390_ZPCIOP_REG_AEN */
>>> +        struct {
>>> +            __u64 ibv;    /* Guest addr of interrupt bit vector */
>>> +            __u64 sb;    /* Guest addr of summary bit */
>>> +            __u32 flags;
>>> +            __u32 noi;    /* Number of interrupts */
>>> +            __u8 isc;    /* Guest interrupt subclass */
>>> +            __u8 sbo;    /* Offset of guest summary bit vector */
>>> +            __u16 pad;
>>> +        } reg_aen;
>>> +        __u64 reserved[8];
>>> +    } u;
>>> +  };
>>> +
>>> +The type of operation is specified in the "op" field.
>>> +KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
>>> +notification interpretation, which will allow firmware delivery of 
>>> adapter
>>> +events directly to the vm, with KVM providing a backup delivery 
>>> mechanism;
>>> +KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable 
>>> interpretation of
>>> +adapter event notifications.
>>> +
>>> +The target zPCI function must also be specified via the "fh" field. 
>>> For the
>>> +KVM_S390_ZPCIOP_REG_AEN operation, additional information to 
>>> establish firmware
>>> +delivery must be provided via the "reg_aen" struct.
>>> +
>>> +The "reserved" field is meant for future extensions.
>>>   5. The kvm_run structure
>>>   ========================
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 704d85214f4f..65a53e22f686 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -616,6 +616,12 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>> *kvm, long ext)
>>>       case KVM_CAP_S390_PROTECTED:
>>>           r = is_prot_virt_host();
>>>           break;
>>> +    case KVM_CAP_S390_ZPCI_OP:
>>> +        if (kvm_s390_pci_interp_allowed())
>>> +            r = 1;
>>> +        else
>>> +            r = 0;
>>> +        break;
>>>       default:
>>>           r = 0;
>>>       }
>>> @@ -2621,6 +2627,23 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>>               r = -EFAULT;
>>>           break;
>>>       }
>>> +    case KVM_S390_ZPCI_OP: {
>>> +        struct kvm_s390_zpci_op args;
>>> +
>>> +        r = -EINVAL;
>>> +        if (!IS_ENABLED(CONFIG_VFIO_PCI))
>>> +            break;
>>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>>> +            r = -EFAULT;
>>> +            break;
>>> +        }
>>> +        r = kvm_s390_pci_zpci_op(kvm, &args);
>>> +        if (r)
>>> +            break;
>>> +        if (copy_to_user(argp, &args, sizeof(args)))
>>> +            r = -EFAULT;
>>> +        break;
>>> +    }
>>>       default:
>>>           r = -ENOTTY;
>>>       }
>>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>>> index 66565f5f3f43..d941657bcb39 100644
>>> --- a/arch/s390/kvm/pci.c
>>> +++ b/arch/s390/kvm/pci.c
>>> @@ -588,6 +588,71 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
>>>           unregister_kvm(kzdev->zdev);
>>>   }
>>> +static struct kvm_zdev *get_kzdev_by_fh(struct kvm *kvm, u32 fh)
>>> +{
>>> +    struct kvm_zdev *kzdev, *retval = NULL;
>>> +
>>> +    spin_lock(&kvm->arch.kzdev_list_lock);
>>> +    list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
>>> +        if (kzdev->zdev->fh == fh) {
>>> +            retval = kzdev;
>>> +            break;
>>> +        }
>>> +    }
>>> +    spin_unlock(&kvm->arch.kzdev_list_lock);
>>> +
>>> +    return retval;
>>> +}
>>> +
>>> +static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
>>> +                     struct kvm_s390_zpci_op *args)
>>> +{
>>> +    struct zpci_fib fib = {};
>>> +
>>> +    fib.fmt0.aibv = args->u.reg_aen.ibv;
>>> +    fib.fmt0.isc = args->u.reg_aen.isc;
>>> +    fib.fmt0.noi = args->u.reg_aen.noi;
>>> +    if (args->u.reg_aen.sb != 0) {
>>> +        fib.fmt0.aisb = args->u.reg_aen.sb;
>>> +        fib.fmt0.aisbo = args->u.reg_aen.sbo;
>>> +        fib.fmt0.sum = 1;
>>> +    } else {
>>> +        fib.fmt0.aisb = 0;
>>> +        fib.fmt0.aisbo = 0;
>>> +        fib.fmt0.sum = 0;
>>> +    }
>>> +
>>> +    if (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST)
>>> +        return kvm_s390_pci_aif_enable(zdev, &fib, true);
>>> +    else
>>> +        return kvm_s390_pci_aif_enable(zdev, &fib, false);
>>> +}
>>> +
>>> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op 
>>> *args)
>>> +{
>>> +    struct kvm_zdev *kzdev;
>>> +    struct zpci_dev *zdev;
>>> +    int r;
>>> +
>>> +    kzdev = get_kzdev_by_fh(kvm, args->fh);
>>> +    if (!kzdev)
>>> +        return -ENODEV;
>>> +    zdev = kzdev->zdev;
>>> +
>>> +    switch (args->op) {
>>> +    case KVM_S390_ZPCIOP_REG_AEN:
>>> +        r = kvm_s390_pci_zpci_reg_aen(zdev, args);
>>> +        break;
>>> +    case KVM_S390_ZPCIOP_DEREG_AEN:
>>> +        r = kvm_s390_pci_aif_disable(zdev, false);
>>> +        break;
>>> +    default:
>>> +        r = -EINVAL;
>>> +    }
>>> +
>>> +    return r;
>>> +}
>>> +
>>>   int kvm_s390_pci_init(void)
>>>   {
>>>       aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>>> index cb5ec3208923..b053b50c0904 100644
>>> --- a/arch/s390/kvm/pci.h
>>> +++ b/arch/s390/kvm/pci.h
>>> @@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
>>>   void kvm_s390_pci_init_list(struct kvm *kvm);
>>>   void kvm_s390_pci_clear_list(struct kvm *kvm);
>>> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op 
>>> *args);
>>> +
>>>   int kvm_s390_pci_init(void);
>>>   static inline bool kvm_s390_pci_interp_allowed(void)
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 91a6fe4e02c0..014adb30d42c 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
>>>   #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>>>   #define KVM_CAP_PMU_CAPABILITY 212
>>>   #define KVM_CAP_DISABLE_QUIRKS2 213
>>> +#define KVM_CAP_S390_ZPCI_OP 214
>>>   #ifdef KVM_CAP_IRQ_ROUTING
>>> @@ -2060,4 +2061,34 @@ struct kvm_stats_desc {
>>>   /* Available with KVM_CAP_XSAVE2 */
>>>   #define KVM_GET_XSAVE2          _IOR(KVMIO,  0xcf, struct kvm_xsave)
>>> +/* Available with KVM_CAP_S390_ZPCI_OP */
>>> +#define KVM_S390_ZPCI_OP      _IOW(KVMIO,  0xd0, struct 
>>> kvm_s390_zpci_op)
>>> +
>>> +struct kvm_s390_zpci_op {
>>> +    /* in */
>>> +    __u32 fh;        /* target device */
>>> +    __u8  op;        /* operation to perform */
>>> +    __u8  pad[3];
>>> +    union {
>>> +        /* for KVM_S390_ZPCIOP_REG_AEN */
>>> +        struct {
>>> +            __u64 ibv;    /* Guest addr of interrupt bit vector */
>>> +            __u64 sb;    /* Guest addr of summary bit */
>>> +            __u32 flags;
>>> +            __u32 noi;    /* Number of interrupts */
>>> +            __u8 isc;    /* Guest interrupt subclass */
>>> +            __u8 sbo;    /* Offset of guest summary bit vector */
>>> +            __u16 pad;
>>> +        } reg_aen;
>>> +        __u64 reserved[8];
>>> +    } u;
>>> +};
>>> +
>>> +/* types for kvm_s390_zpci_op->op */
>>> +#define KVM_S390_ZPCIOP_REG_AEN        0
>>> +#define KVM_S390_ZPCIOP_DEREG_AEN    1
>>> +
>>> +/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
>>> +#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
>>> +
>>>   #endif /* __LINUX_KVM_H */
>>>
>>
>>
>> The purpose is to setup the IRQ for the zPCI device wouldn't it be 
>> more logical to go through VFIO_DEVICE_SET_IRQS and there jump to the 
>> zPCI handling, like it is done for the capabilities, instead to go 
>> directly through KVM?
>> We would also spare the research for the real FH in KVM.
>>
> 
> We need the host FH anyway -- for load/store intepretation, the guest 
> must be using the FH that the firmware expects.  Plus we need that FH 
> when issuing the MPCIFC op 2.  I guess maybe you mean the lookup (get 
> the exact device associated with this fd vs scanning the list of PCI 
> devices associated with this KVM).

Obvious ly we need to get the real FH, yes, and yes I was speaking of 
scanning the list-pci but t is not the main idea.
The main idea is that going through the VFIO device ioctl seems to me 
the right way to go to handle IRQ for a device.

One can argue that it is not really PCI specific.
Right but we have no possibility to intercept it inside the vfio code.

unless we add some arch specific hook in vfio_device_fops_unl_ioctl().

> 
> One of the issues here is that, with load/store interpretation enabled, 
> vfio in QEMU will never get the config space notifiers triggered; these 
> are the things that end up calling vfio_enable_vectors() which will in 
> turn issue the VFIO_DEVICE_SET_IRQS (instead these guest config space 
> writes are executed interpretively)

What I mean is to add in vfio_pci_core_ioctl() a treatment for 
VFIO_DEVICE_SET_IRQS like you did for VFIO_DEVICE_GET_INFO with a 
specific operation or flag to call kvm_s390_pci_zpci_reg_aen().

Then, in QEMU we add a new call to VFIO_DEVICE_SET_IRQS with this 
special operation/flag in s390_pci_kvm_aif_enable() / disable


> 
> I did play around with this for a while, but if we were to call 
> VFIO_DEVICE_SET_IRQS ourselves from QEMU s390-pci instead of relying on 
> the config space notifier, we still have the issue of associating the 
> previously-established routes with the host function - because at the 
> end of it we need to issue a MPCIFC(2) specifying the host FH and 
> including the forwarding information (e.g. the work done in 
> kvm_s390_pci_aif_enable).  AFAICT today we can't derive the FH from 
> routes, that's where I got stuck.  But if you have an idea please share.

As I said no change about getting the FH, so no change for the MPCIFC(2)

Anyway, it touches VFIO and/or VFIO_PCI so @alex do you think it is 
interesting?
Knowing that the current version works it could also be done later.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

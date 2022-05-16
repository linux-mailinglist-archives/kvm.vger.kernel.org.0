Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FB55288FA
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiEPPfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243266AbiEPPfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:35:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92803C701;
        Mon, 16 May 2022 08:35:38 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEp6n6014399;
        Mon, 16 May 2022 15:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N2lu4zl278nZzJsKMJWeZP1v67F6Y1uAgImUbk6sq9s=;
 b=C7cchwDWp63iplo3yGr28zyCc5UmPYGDi+jtSdfvVVLQFVM5S7MNxEdK/7LDRnCI0qD7
 BrFZgJELBOh5VzZ1vApC1I/rADhQcOI9OBVkIMXsxgp7fPAJSJW4AewXe0GSAazxxDp4
 i+DVj1qrAUbs8EFQ7v0Uit9K04rV/JFhCqZAprcA/hwGNGurC3bxBknlomIhPa0mT59J
 DcCD658kiwh6sCrNbVYf6PzhI+RdlwcEibrfmgl3Bn+Iyxj2ryuR5dPG+p/5G9I9SZQi
 76RlyLvGBKrouSFAh3NNNdHCuizQaxgjaEAdxVzHTgcBhmEHbaiqhhCueOpUZCbzBqcG Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3pp44g62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:35:35 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GFMjsq007792;
        Mon, 16 May 2022 15:35:35 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3pp44g4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:35:35 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GFSLhi009646;
        Mon, 16 May 2022 15:35:33 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3g2429y2ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:35:33 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GFZVYW37421434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:35:32 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9AD6BE05B;
        Mon, 16 May 2022 15:35:31 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64133BE065;
        Mon, 16 May 2022 15:35:29 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 15:35:29 +0000 (GMT)
Message-ID: <0c6a4f7b-f43a-8f4c-49bb-db10ca010f1f@linux.ibm.com>
Date:   Mon, 16 May 2022 11:35:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 20/22] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
 zPCI devices
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-21-mjrosato@linux.ibm.com>
 <7b13aca2-fb3e-3b84-8d3d-e94966fac5f2@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7b13aca2-fb3e-3b84-8d3d-e94966fac5f2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uordIsZRv0b3EiTCko55F41gwlvbiSG7
X-Proofpoint-ORIG-GUID: _yjQ558LC_VaMbmnl17Q_EVvhyIWSkcK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160090
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 5:52 AM, Thomas Huth wrote:
> On 13/05/2022 21.15, Matthew Rosato wrote:
>> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
>> hardware-assisted virtualization features for s390X zPCI passthrough.
> 
> s/s390X/s390x/
> 
>> Add the first 2 operations, which can be used to enable/disable
>> the specified device for Adapter Event Notification interpretation.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.c       | 23 ++++++++++
>>   arch/s390/kvm/pci.c            | 81 ++++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h            |  2 +
>>   include/uapi/linux/kvm.h       | 31 +++++++++++++
>>   5 files changed, 182 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst 
>> b/Documentation/virt/kvm/api.rst
>> index 4a900cdbc62e..a7cd5ebce031 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5645,6 +5645,51 @@ enabled with ``arch_prctl()``, but this may 
>> change in the future.
>>   The offsets of the state save areas in struct kvm_xsave follow the 
>> contents
>>   of CPUID leaf 0xD on the host.
>> +4.135 KVM_S390_ZPCI_OP
>> +--------------------
>> +
>> +:Capability: KVM_CAP_S390_ZPCI_OP
>> +:Architectures: s390
>> +:Type: vcpu ioctl
> 
> vcpu? ... you're wiring it up in  kvm_arch_vm_ioctl() later, so I assume 
> it's rather a VM ioctl?

Yup, VM ioctl, bad copy/paste job...

> 
>> +:Parameters: struct kvm_s390_zpci_op (in)
>> +:Returns: 0 on success, <0 on error
>> +
>> +Used to manage hardware-assisted virtualization features for zPCI 
>> devices.
>> +
>> +Parameters are specified via the following structure::
>> +
>> +  struct kvm_s390_zpci_op {
>> +    /* in */
> 
> If all is "in", why is there a copy_to_user() in the code later?
> 

Oh no, this is a leftover from a prior version...  Good catch.  There 
should no longer be a copy_to_user.

>> +    __u32 fh;        /* target device */
>> +    __u8  op;        /* operation to perform */
>> +    __u8  pad[3];
>> +    union {
>> +        /* for KVM_S390_ZPCIOP_REG_AEN */
>> +        struct {
>> +            __u64 ibv;    /* Guest addr of interrupt bit vector */
>> +            __u64 sb;    /* Guest addr of summary bit */
> 
> If this is really a vcpu ioctl, what kind of addresses are you talking 
> about here? virtual addresses? real addresses? absolute addresses?

It's a VM ioctl.  These are guest kernel physical addresses that are 
later pinned in arch/s390/kvm/pci.c:kvm_s390_pci_aif_enable() as part of 
handling the ioctl.

> 
>> +            __u32 flags;
>> +            __u32 noi;    /* Number of interrupts */
>> +            __u8 isc;    /* Guest interrupt subclass */
>> +            __u8 sbo;    /* Offset of guest summary bit vector */
>> +            __u16 pad;
>> +        } reg_aen;
>> +        __u64 reserved[8];
>> +    } u;
>> +  };
>> +
>> +The type of operation is specified in the "op" field.
>> +KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
>> +notification interpretation, which will allow firmware delivery of 
>> adapter
>> +events directly to the vm, with KVM providing a backup delivery 
>> mechanism;
>> +KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable 
>> interpretation of
>> +adapter event notifications.
>> +
>> +The target zPCI function must also be specified via the "fh" field.  
>> For the
>> +KVM_S390_ZPCIOP_REG_AEN operation, additional information to 
>> establish firmware
>> +delivery must be provided via the "reg_aen" struct.
>> +
>> +The "reserved" field is meant for future extensions.
> 
> Maybe also mention the "pad" fields? And add should these also be 
> initialized to 0 by the calling userspace program?

Sure, I can mention them.  And yes, I agree that userspace should 
initialize them to 0, I'll update the QEMU series accordingly.

> 
>>   5. The kvm_run structure
>>   ========================
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index b95b25490018..1af7cea9d579 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -618,6 +618,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_S390_PROTECTED:
>>           r = is_prot_virt_host();
>>           break;
>> +    case KVM_CAP_S390_ZPCI_OP:
>> +        if (kvm_s390_pci_interp_allowed())
>> +            r = 1;
>> +        else
>> +            r = 0;
> 
> Could be shortened to:
> 
>          r = kvm_s390_pci_interp_allowed();
> 
>> +        break;
>>       default:
>>           r = 0;
>>       }
>> @@ -2633,6 +2639,23 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>               r = -EFAULT;
>>           break;
>>       }
>> +    case KVM_S390_ZPCI_OP: {
>> +        struct kvm_s390_zpci_op args;
>> +
>> +        r = -EINVAL;
>> +        if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>> +            break;
>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>> +            r = -EFAULT;
>> +            break;
>> +        }
>> +        r = kvm_s390_pci_zpci_op(kvm, &args);
>> +        if (r)
>> +            break;
>> +        if (copy_to_user(argp, &args, sizeof(args)))
>> +            r = -EFAULT;
> 
> So this copy_to_user() indicates that information is returned to 
> userspace ... but below, the ioctl is declared with _IOW only ... this 
> does not match. Should it be declared with _IOWR or should the 
> copy_to_user() be dropped?

copy_to_user should be dropped.  Thanks!

> 
>> +        break;
>> +    }
>>       default:
>>           r = -ENOTTY;
>>       }
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index 1393a1604494..6e6254016be4 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -585,6 +585,87 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
>>       spin_unlock(&kvm->arch.kzdev_list_lock);
>>   }
>> +static struct zpci_dev *get_zdev_from_kvm_by_fh(struct kvm *kvm, u32 fh)
>> +{
>> +    struct zpci_dev *zdev = NULL;
>> +    struct kvm_zdev *kzdev;
>> +
>> +    spin_lock(&kvm->arch.kzdev_list_lock);
>> +    list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
>> +        if (kzdev->zdev->fh == fh) {
>> +            zdev = kzdev->zdev;
>> +            break;
>> +        }
>> +    }
>> +    spin_unlock(&kvm->arch.kzdev_list_lock);
>> +
>> +    return zdev;
>> +}
>> +
>> +static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
>> +                     struct kvm_s390_zpci_op *args)
>> +{
>> +    struct zpci_fib fib = {};
>> +
>> +    fib.fmt0.aibv = args->u.reg_aen.ibv;
>> +    fib.fmt0.isc = args->u.reg_aen.isc;
>> +    fib.fmt0.noi = args->u.reg_aen.noi;
>> +    if (args->u.reg_aen.sb != 0) {
>> +        fib.fmt0.aisb = args->u.reg_aen.sb;
>> +        fib.fmt0.aisbo = args->u.reg_aen.sbo;
>> +        fib.fmt0.sum = 1;
>> +    } else {
>> +        fib.fmt0.aisb = 0;
>> +        fib.fmt0.aisbo = 0;
>> +        fib.fmt0.sum = 0;
>> +    }
>> +
>> +    if (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST)
>> +        return kvm_s390_pci_aif_enable(zdev, &fib, true);
>> +    else
>> +        return kvm_s390_pci_aif_enable(zdev, &fib, false);
> 
> Alternatively (just a matter of taste):
> 
>      bool hostflag;
>      ...
>      hostflag = (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST);
>      return kvm_s390_pci_aif_enable(zdev, &fib, hostflag);
> 
>> +}
>> +
>> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
>> +{
>> +    struct kvm_zdev *kzdev;
>> +    struct zpci_dev *zdev;
>> +    int r;
>> +
>> +    zdev = get_zdev_from_kvm_by_fh(kvm, args->fh);
>> +    if (!zdev)
>> +        return -ENODEV;
>> +
>> +    mutex_lock(&zdev->kzdev_lock);
>> +    mutex_lock(&kvm->lock);
>> +
>> +    kzdev = zdev->kzdev;
>> +    if (!kzdev) {
>> +        r = -ENODEV;
>> +        goto out;
>> +    }
>> +    if (kzdev->kvm != kvm) {
>> +        r = -EPERM;
>> +        goto out;
>> +    }
>> +
>> +    switch (args->op) {
>> +    case KVM_S390_ZPCIOP_REG_AEN:
> 
> Please also check here that args->u.reg_aen.flags does not have any bits 
> set that we don't support here (otherwise, this could cause some trouble 
> when introducing additional flags later).

Good idea, will do

> 
>> +        r = kvm_s390_pci_zpci_reg_aen(zdev, args);
>> +        break;
>> +    case KVM_S390_ZPCIOP_DEREG_AEN:
>> +        r = kvm_s390_pci_aif_disable(zdev, false);
>> +        break;
>> +    default:
>> +        r = -EINVAL;
>> +    }
>> +
>> +out:
>> +    mutex_unlock(&kvm->lock);
>> +    mutex_unlock(&zdev->kzdev_lock);
>> +    return r;
>> +}
>> +
>>   int kvm_s390_pci_init(void)
>>   {
>>       aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index fb2b91b76e0c..0351382e990f 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
>>   void kvm_s390_pci_init_list(struct kvm *kvm);
>>   void kvm_s390_pci_clear_list(struct kvm *kvm);
>> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op 
>> *args);
>> +
>>   int kvm_s390_pci_init(void);
>>   void kvm_s390_pci_exit(void);
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6a184d260c7f..1d3d41523d10 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_DISABLE_QUIRKS2 213
>>   /* #define KVM_CAP_VM_TSC_CONTROL 214 */
>>   #define KVM_CAP_SYSTEM_EVENT_DATA 215
>> +#define KVM_CAP_S390_ZPCI_OP 216
>>   #ifdef KVM_CAP_IRQ_ROUTING
>> @@ -2068,4 +2069,34 @@ struct kvm_stats_desc {
>>   /* Available with KVM_CAP_XSAVE2 */
>>   #define KVM_GET_XSAVE2          _IOR(KVMIO,  0xcf, struct kvm_xsave)
>> +/* Available with KVM_CAP_S390_ZPCI_OP */
>> +#define KVM_S390_ZPCI_OP      _IOW(KVMIO,  0xd0, struct 
>> kvm_s390_zpci_op)
> 
> Please double-check whether this should be _IOWR instead (see above). >

As mentioned above, the copy_to_user() should be removed.

>> +struct kvm_s390_zpci_op {
>> +    /* in */
>> +    __u32 fh;        /* target device */
>> +    __u8  op;        /* operation to perform */
>> +    __u8  pad[3];
>> +    union {
>> +        /* for KVM_S390_ZPCIOP_REG_AEN */
>> +        struct {
>> +            __u64 ibv;    /* Guest addr of interrupt bit vector */
>> +            __u64 sb;    /* Guest addr of summary bit */
>> +            __u32 flags;
>> +            __u32 noi;    /* Number of interrupts */
>> +            __u8 isc;    /* Guest interrupt subclass */
>> +            __u8 sbo;    /* Offset of guest summary bit vector */
>> +            __u16 pad;
>> +        } reg_aen;
>> +        __u64 reserved[8];
>> +    } u;
>> +};
>> +
>> +/* types for kvm_s390_zpci_op->op */
>> +#define KVM_S390_ZPCIOP_REG_AEN        0
>> +#define KVM_S390_ZPCIOP_DEREG_AEN    1
>> +
>> +/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
>> +#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
>> +
>>   #endif /* __LINUX_KVM_H */
> 
>   Thomas
> 


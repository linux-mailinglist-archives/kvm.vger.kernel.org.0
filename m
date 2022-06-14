Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3023E54AC54
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355529AbiFNIr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242247AbiFNIpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:45:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAFB26F3;
        Tue, 14 Jun 2022 01:45:29 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E6x5hD030743;
        Tue, 14 Jun 2022 08:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4zxJa9F5EPuzusw5W/ArpOl9cOy89L1yV2FuFByKwgI=;
 b=asSK40xAFvkpdDV1mSi+34XrCXgaNyMW/F9z9F+46aNovxAEpf56+dcR++16RZRr11wq
 yzoM6XsU+3v+lKVvfuKa90QrEDXl3VTTdnJdz+COwS2Rm9VGJ9Zilf28IkiSWkTETOdt
 IwykKNBn5kPYiEIn0+UsjQgXPz5/7V6LCDso+Cjf/YnoVLhR9pyG7Vk+YN4K1VLR0ok8
 0J9FOXEhoIuz/9hhUkac6XyGGnFSEUNjZqwSKaS52IwwdK4bd2s8R30wfaGapW6HtZE9
 CZYJ79Pekrl/vU7tG0rCyrtzmPF08nK+D7kH1sy9N6LSgwksT6aGb5guN43TvxvkTGfE 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpeevhe6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:45:25 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25E8cqJH014847;
        Tue, 14 Jun 2022 08:45:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpeevhe60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:45:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25E8aLVs016549;
        Tue, 14 Jun 2022 08:45:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gmjajc2pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:45:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25E8jNpu22610252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 08:45:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18649AE051;
        Tue, 14 Jun 2022 08:45:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB0C9AE04D;
        Tue, 14 Jun 2022 08:45:18 +0000 (GMT)
Received: from [9.171.87.27] (unknown [9.171.87.27])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 08:45:18 +0000 (GMT)
Message-ID: <7fd7d517-d80a-bfab-bbd2-f92d8d572472@linux.ibm.com>
Date:   Tue, 14 Jun 2022 10:49:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 20/21] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
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
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-21-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220606203325.110625-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pV4KW1kpV_ebIhd5TlMiaj4yvVcyHccU
X-Proofpoint-GUID: _3NWkhAmeULgBU1gFe6uz7WSG4qBfxH-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140033
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/22 22:33, Matthew Rosato wrote:
> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
> hardware-assisted virtualization features for s390x zPCI passthrough.
> Add the first 2 operations, which can be used to enable/disable
> the specified device for Adapter Event Notification interpretation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Despite I really do not like passing the FH in the structure.
I think that if I admit that then this LGTM.

Acked-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   Documentation/virt/kvm/api.rst | 47 +++++++++++++++++++
>   arch/s390/kvm/kvm-s390.c       | 16 +++++++
>   arch/s390/kvm/pci.c            | 85 ++++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h            |  2 +
>   include/uapi/linux/kvm.h       | 31 +++++++++++++
>   5 files changed, 181 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..2eb604769dce 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5802,6 +5802,53 @@ of CPUID leaf 0xD on the host.
>   
>   This ioctl injects an event channel interrupt directly to the guest vCPU.
>   
> +4.136 KVM_S390_ZPCI_OP
> +--------------------
> +
> +:Capability: KVM_CAP_S390_ZPCI_OP
> +:Architectures: s390
> +:Type: vm ioctl
> +:Parameters: struct kvm_s390_zpci_op (in)
> +:Returns: 0 on success, <0 on error
> +
> +Used to manage hardware-assisted virtualization features for zPCI devices.
> +
> +Parameters are specified via the following structure::
> +
> +  struct kvm_s390_zpci_op {
> +	/* in */
> +	__u32 fh;		/* target device */
> +	__u8  op;		/* operation to perform */
> +	__u8  pad[3];
> +	union {
> +		/* for KVM_S390_ZPCIOP_REG_AEN */
> +		struct {
> +			__u64 ibv;	/* Guest addr of interrupt bit vector */
> +			__u64 sb;	/* Guest addr of summary bit */
> +			__u32 flags;
> +			__u32 noi;	/* Number of interrupts */
> +			__u8 isc;	/* Guest interrupt subclass */
> +			__u8 sbo;	/* Offset of guest summary bit vector */
> +			__u16 pad;
> +		} reg_aen;
> +		__u64 reserved[8];
> +	} u;
> +  };
> +
> +The type of operation is specified in the "op" field.
> +KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
> +notification interpretation, which will allow firmware delivery of adapter
> +events directly to the vm, with KVM providing a backup delivery mechanism;
> +KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable interpretation of
> +adapter event notifications.
> +
> +The target zPCI function must also be specified via the "fh" field.  For the
> +KVM_S390_ZPCIOP_REG_AEN operation, additional information to establish firmware
> +delivery must be provided via the "reg_aen" struct.
> +
> +The "pad" and "reserved" fields may be used for future extensions and should be
> +set to 0s by userspace.
> +
>   5. The kvm_run structure
>   ========================
>   
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 4758bb731199..f214e0fc62ed 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_PROTECTED:
>   		r = is_prot_virt_host();
>   		break;
> +	case KVM_CAP_S390_ZPCI_OP:
> +		r = kvm_s390_pci_interp_allowed();
> +		break;
>   	default:
>   		r = 0;
>   	}
> @@ -2629,6 +2632,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = -EFAULT;
>   		break;
>   	}
> +	case KVM_S390_ZPCI_OP: {
> +		struct kvm_s390_zpci_op args;
> +
> +		r = -EINVAL;
> +		if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> +			break;
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +		r = kvm_s390_pci_zpci_op(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 24211741deb0..4946fb7757d6 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -585,6 +585,91 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
>   	spin_unlock(&kvm->arch.kzdev_list_lock);
>   }
>   
> +static struct zpci_dev *get_zdev_from_kvm_by_fh(struct kvm *kvm, u32 fh)
> +{
> +	struct zpci_dev *zdev = NULL;
> +	struct kvm_zdev *kzdev;
> +
> +	spin_lock(&kvm->arch.kzdev_list_lock);
> +	list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
> +		if (kzdev->zdev->fh == fh) {
> +			zdev = kzdev->zdev;
> +			break;
> +		}
> +	}
> +	spin_unlock(&kvm->arch.kzdev_list_lock);
> +
> +	return zdev;
> +}
> +
> +static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
> +				     struct kvm_s390_zpci_op *args)
> +{
> +	struct zpci_fib fib = {};
> +	bool hostflag;
> +
> +	fib.fmt0.aibv = args->u.reg_aen.ibv;
> +	fib.fmt0.isc = args->u.reg_aen.isc;
> +	fib.fmt0.noi = args->u.reg_aen.noi;
> +	if (args->u.reg_aen.sb != 0) {
> +		fib.fmt0.aisb = args->u.reg_aen.sb;
> +		fib.fmt0.aisbo = args->u.reg_aen.sbo;
> +		fib.fmt0.sum = 1;
> +	} else {
> +		fib.fmt0.aisb = 0;
> +		fib.fmt0.aisbo = 0;
> +		fib.fmt0.sum = 0;
> +	}
> +
> +	hostflag = !(args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST);
> +	return kvm_s390_pci_aif_enable(zdev, &fib, hostflag);
> +}
> +
> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
> +{
> +	struct kvm_zdev *kzdev;
> +	struct zpci_dev *zdev;
> +	int r;
> +
> +	zdev = get_zdev_from_kvm_by_fh(kvm, args->fh);
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	mutex_lock(&zdev->kzdev_lock);
> +	mutex_lock(&kvm->lock);
> +
> +	kzdev = zdev->kzdev;
> +	if (!kzdev) {
> +		r = -ENODEV;
> +		goto out;
> +	}
> +	if (kzdev->kvm != kvm) {
> +		r = -EPERM;
> +		goto out;
> +	}
> +
> +	switch (args->op) {
> +	case KVM_S390_ZPCIOP_REG_AEN:
> +		/* Fail on unknown flags */
> +		if (args->u.reg_aen.flags & ~KVM_S390_ZPCIOP_REGAEN_HOST) {
> +			r = -EINVAL;
> +			break;
> +		}
> +		r = kvm_s390_pci_zpci_reg_aen(zdev, args);
> +		break;
> +	case KVM_S390_ZPCIOP_DEREG_AEN:
> +		r = kvm_s390_pci_aif_disable(zdev, false);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&zdev->kzdev_lock);
> +	return r;
> +}
> +
>   int kvm_s390_pci_init(void)
>   {
>   	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index fb2b91b76e0c..0351382e990f 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
>   void kvm_s390_pci_init_list(struct kvm *kvm);
>   void kvm_s390_pci_clear_list(struct kvm *kvm);
>   
> +int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
> +
>   int kvm_s390_pci_init(void);
>   void kvm_s390_pci_exit(void);
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5088bd9f1922..52cc12d53022 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_TSC_CONTROL 214
>   #define KVM_CAP_SYSTEM_EVENT_DATA 215
>   #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
> +#define KVM_CAP_S390_ZPCI_OP 217
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -2118,4 +2119,34 @@ struct kvm_stats_desc {
>   /* Available with KVM_CAP_XSAVE2 */
>   #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
>   
> +/* Available with KVM_CAP_S390_ZPCI_OP */
> +#define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
> +
> +struct kvm_s390_zpci_op {
> +	/* in */
> +	__u32 fh;               /* target device */
> +	__u8  op;               /* operation to perform */
> +	__u8  pad[3];
> +	union {
> +		/* for KVM_S390_ZPCIOP_REG_AEN */
> +		struct {
> +			__u64 ibv;      /* Guest addr of interrupt bit vector */
> +			__u64 sb;       /* Guest addr of summary bit */
> +			__u32 flags;
> +			__u32 noi;      /* Number of interrupts */
> +			__u8 isc;       /* Guest interrupt subclass */
> +			__u8 sbo;       /* Offset of guest summary bit vector */
> +			__u16 pad;
> +		} reg_aen;
> +		__u64 reserved[8];
> +	} u;
> +};
> +
> +/* types for kvm_s390_zpci_op->op */
> +#define KVM_S390_ZPCIOP_REG_AEN                0
> +#define KVM_S390_ZPCIOP_DEREG_AEN      1
> +
> +/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
> +#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
> +
>   #endif /* __LINUX_KVM_H */
> 

-- 
Pierre Morel
IBM Lab Boeblingen

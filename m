Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5917000E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBZNbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 08:31:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726867AbgBZNbs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 08:31:48 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QDUMUr000886
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 08:31:45 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ydcngeewx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 08:31:45 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 26 Feb 2020 13:31:43 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 13:31:40 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QDVaSW53149740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 13:31:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94FBB4C04A;
        Wed, 26 Feb 2020 13:31:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36F564C052;
        Wed, 26 Feb 2020 13:31:36 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.219])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 13:31:36 +0000 (GMT)
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
 <20200225214822.3611-1-borntraeger@de.ibm.com>
 <20200226132640.36c32fd3.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 26 Feb 2020 14:31:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226132640.36c32fd3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022613-0008-0000-0000-000003569E02
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022613-0009-0000-0000-00004A77BCEF
Message-Id: <dcd80ccd-2d66-502f-62a1-3c794cfcde65@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_04:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.02.20 13:26, Cornelia Huck wrote:
> On Tue, 25 Feb 2020 16:48:22 -0500
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> This contains 3 main changes:
>> 1. changes in SIE control block handling for secure guests
>> 2. helper functions for create/destroy/unpack secure guests
>> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
>> machines
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  24 ++-
>>  arch/s390/include/asm/uv.h       |  69 ++++++++
>>  arch/s390/kvm/Makefile           |   2 +-
>>  arch/s390/kvm/kvm-s390.c         | 209 +++++++++++++++++++++++-
>>  arch/s390/kvm/kvm-s390.h         |  33 ++++
>>  arch/s390/kvm/pv.c               | 269 +++++++++++++++++++++++++++++++
>>  include/uapi/linux/kvm.h         |  31 ++++
>>  7 files changed, 633 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/s390/kvm/pv.c
> 
> (...)
> 
>> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>> +{
>> +	int r = 0;
>> +	u16 dummy;
>> +	void __user *argp = (void __user *)cmd->data;
>> +
>> +	switch (cmd->cmd) {
>> +	case KVM_PV_ENABLE: {
>> +		r = -EINVAL;
>> +		if (kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		/*
>> +		 *  FMT 4 SIE needs esca. As we never switch back to bsca from
>> +		 *  esca, we need no cleanup in the error cases below
>> +		 */
>> +		r = sca_switch_to_extended(kvm);
>> +		if (r)
>> +			break;
>> +
>> +		r = kvm_s390_pv_init_vm(kvm, &cmd->rc, &cmd->rrc);
>> +		if (r)
>> +			break;
>> +
>> +		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
>> +		if (r)
>> +			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
>> +		break;
>> +	}
>> +	case KVM_PV_DISABLE: {
>> +		r = -EINVAL;
>> +		if (!kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
>> +		/*
>> +		 * If a CPU could not be destroyed, destroy VM will also fail.
>> +		 * There is no point in trying to destroy it. Instead return
>> +		 * the rc and rrc from the first CPU that failed destroying.
>> +		 */
>> +		if (r)
>> +			break;
>> +		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
>> +		break;
>> +	}
> 
> IIUC, we may end up in an odd state in the failure case, because we
> might not be able to free up the donated memory, depending on what goes
> wrong. Can userspace do anything useful with the vm if that happens?

The protected VM is still there. Depending on how many CPUs are still
available the secure guest can still run or not. But this is really
fine, no strange things will happen.
> 
> Even more important, userspace cannot cause repeated donations by
> repeatedly calling this ioctl, right?

No, we keep the handle exactly to avoid userspace to not be able
to do disable/enable in a loop.

> 
>> +	case KVM_PV_SET_SEC_PARMS: {
>> +		struct kvm_s390_pv_sec_parm parms = {};
>> +		void *hdr;
>> +
>> +		r = -EINVAL;
>> +		if (!kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		r = -EFAULT;
>> +		if (copy_from_user(&parms, argp, sizeof(parms)))
>> +			break;
>> +
>> +		/* Currently restricted to 8KB */
>> +		r = -EINVAL;
>> +		if (parms.length > PAGE_SIZE * 2)
>> +			break;
>> +
>> +		r = -ENOMEM;
>> +		hdr = vmalloc(parms.length);
>> +		if (!hdr)
>> +			break;
>> +
>> +		r = -EFAULT;
>> +		if (!copy_from_user(hdr, (void __user *)parms.origin,
>> +				    parms.length))
>> +			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length,
>> +						      &cmd->rc, &cmd->rrc);
>> +
>> +		vfree(hdr);
>> +		break;
>> +	}
>> +	case KVM_PV_UNPACK: {
>> +		struct kvm_s390_pv_unp unp = {};
>> +
>> +		r = -EINVAL;
>> +		if (!kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		r = -EFAULT;
>> +		if (copy_from_user(&unp, argp, sizeof(unp)))
>> +			break;
>> +
>> +		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak,
>> +				       &cmd->rc, &cmd->rrc);
>> +		break;
>> +	}
>> +	case KVM_PV_VERIFY: {
>> +		r = -EINVAL;
>> +		if (!kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>> +				  UVC_CMD_VERIFY_IMG, &cmd->rc, &cmd->rrc);
>> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x", cmd->rc,
>> +			     cmd->rrc);
>> +		break;
>> +	}
>> +	default:
>> +		return -ENOTTY;
> 
> Nit: why not r = -ENOTTY, so you get a single exit point?

can do.

> 
>> +	}
>> +	return r;
>> +}
>> +
>>  long kvm_arch_vm_ioctl(struct file *filp,
>>  		       unsigned int ioctl, unsigned long arg)
>>  {
>> @@ -2262,6 +2419,27 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>  		mutex_unlock(&kvm->slots_lock);
>>  		break;
>>  	}
>> +	case KVM_S390_PV_COMMAND: {
>> +		struct kvm_pv_cmd args;
>> +
>> +		r = 0;
>> +		if (!is_prot_virt_host()) {
>> +			r = -EINVAL;
>> +			break;
>> +		}
>> +		if (copy_from_user(&args, argp, sizeof(args))) {
>> +			r = -EFAULT;
>> +			break;
>> +		}
> 
> The api states that args.flags must be 0... better enforce that?


yes
@@ -2431,6 +2431,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
                        r = -EFAULT;
                        break;
                }
+               if (args.flags) {
+                       r = -EINVAL;
+                       break;
+               }
                mutex_lock(&kvm->lock);
                r = kvm_s390_handle_pv(kvm, &args);
                mutex_unlock(&kvm->lock);



> 
>> +		mutex_lock(&kvm->lock);
>> +		r = kvm_s390_handle_pv(kvm, &args);
>> +		mutex_unlock(&kvm->lock);
>> +		if (copy_to_user(argp, &args, sizeof(args))) {
>> +			r = -EFAULT;
>> +			break;
>> +		}
>> +		break;
>> +	}
>>  	default:
>>  		r = -ENOTTY;
>>  	}
> 
> (...)
> 
>> @@ -2558,10 +2741,19 @@ static void kvm_free_vcpus(struct kvm *kvm)
>>  
>>  void kvm_arch_destroy_vm(struct kvm *kvm)
>>  {
>> +	u16 rc, rrc;
> 
> Nit: missing empty line.

ack.

> 
>>  	kvm_free_vcpus(kvm);
>>  	sca_dispose(kvm);
>> -	debug_unregister(kvm->arch.dbf);
>>  	kvm_s390_gisa_destroy(kvm);
>> +	/*
>> +	 * We are already at the end of life and kvm->lock is not taken.
>> +	 * This is ok as the file descriptor is closed by now and nobody
>> +	 * can mess with the pv state. To avoid lockdep_assert_held from
>> +	 * complaining we do not use kvm_s390_pv_is_protected.
>> +	 */
>> +	if (kvm_s390_pv_get_handle(kvm))
>> +		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
>> +	debug_unregister(kvm->arch.dbf);
>>  	free_page((unsigned long)kvm->arch.sie_page2);
>>  	if (!kvm_is_ucontrol(kvm))
>>  		gmap_remove(kvm->arch.gmap);
> 
> (...)
> 
>> @@ -4540,6 +4744,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>  	if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
>>  		return -EINVAL;
>>  
>> +	/* When we are protected we should not change the memory slots */
> 
> s/protected/protected,/

ack.

> 
>> +	if (kvm_s390_pv_is_protected(kvm))
>> +		return -EINVAL;
>>  	return 0;
>>  }
>>  
> 
> (...)
> 
>> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>> +{
>> +	unsigned long base = uv_info.guest_base_stor_len;
>> +	unsigned long virt = uv_info.guest_virt_var_stor_len;
> 
> base_len and virt_len? Makes the code below less confusing.

this makes some lines longer than 80 for no obvious benefit. I think I will keep
the names.


> 
>> +	unsigned long npages = 0, vlen = 0;
>> +	struct kvm_memory_slot *memslot;
>> +
>> +	kvm->arch.pv.stor_var = NULL;
>> +	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
>> +	if (!kvm->arch.pv.stor_base)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Calculate current guest storage for allocation of the
>> +	 * variable storage, which is based on the length in MB.
>> +	 *
>> +	 * Slots are sorted by GFN
>> +	 */
>> +	mutex_lock(&kvm->slots_lock);
>> +	memslot = kvm_memslots(kvm)->memslots;
>> +	npages = memslot->base_gfn + memslot->npages;
>> +	mutex_unlock(&kvm->slots_lock);
>> +
>> +	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
>> +
>> +	/* Allocate variable storage */
>> +	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
>> +	vlen += uv_info.guest_virt_base_stor_len;
>> +	kvm->arch.pv.stor_var = vzalloc(vlen);
>> +	if (!kvm->arch.pv.stor_var)
>> +		goto out_err;
>> +	return 0;
>> +
>> +out_err:
>> +	kvm_s390_pv_dealloc_vm(kvm);
>> +	return -ENOMEM;
>> +}
>> +
>> +/* this should not fail, but if it does we must not free the donated memory */
> 
> s/does/does,/

ack


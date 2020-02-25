Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F516F157
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 22:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBYVox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 16:44:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726421AbgBYVox (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 16:44:53 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PLZTnE107779
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 16:44:50 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12ck817-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 16:44:50 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 25 Feb 2020 21:44:49 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 21:44:45 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PLhjEo43516414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 21:43:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2C6C52051;
        Tue, 25 Feb 2020 21:44:41 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.53.31])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 263BA5204E;
        Tue, 25 Feb 2020 21:44:41 +0000 (GMT)
Subject: Re: [PATCH v4 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
 <20200224114107.4646-10-borntraeger@de.ibm.com>
 <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 25 Feb 2020 22:44:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022521-0008-0000-0000-000003566501
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022521-0009-0000-0000-00004A7781E0
Message-Id: <24689dd9-139d-3a0b-a57c-9f13ebda142b@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_08:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=2
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.02.20 18:46, David Hildenbrand wrote:
> On 24.02.20 12:40, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> This contains 3 main changes:
>> 1. changes in SIE control block handling for secure guests
>> 2. helper functions for create/destroy/unpack secure guests
>> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
>> machines
> 
> side note: I really dislike such patch descriptions (lists!) and
> squashing a whole bunch of things that could be nicely split up into
> separat patches (with much nicer patch descriptions) into a single
> patch. E.g., enable/disable would be sufficiently complicated to review.
> 
> This makes review unnecessary complicated. But here we are in v4, so
> I'll try my best for (hopefully) the second last time ;)
> 
> [...]
> 
>> +static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	bool failed = false;
>> +	u16 rc, rrc;
>> +	int cc = 0;
>> +	int i;
>> +
>> +	/*
>> +	 * we ignore failures and try to destroy as many CPUs as possible.
> 
> nit: "We"

ack

> 
>> +	 * At the same time we must not free the assigned resources when
>> +	 * this fails, as the ultravisor has still access to that memory.
>> +	 * So kvm_s390_pv_destroy_cpu can leave a "wanted" memory leak
>> +	 * behind.
>> +	 * We want to return the first failure rc and rrc though.
> 
> nit, ", though".

ack
> 
>> +	 */
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		mutex_lock(&vcpu->mutex);
>> +		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !failed) {
>> +			*rcp = rc;
>> +			*rrcp = rrc;
>> +			cc = 1;
>> +			failed = true;
> 
> no need for "failed". Just check against cc != 0 instead.

ack

> 
>> +		}
>> +		mutex_unlock(&vcpu->mutex);
>> +	}
>> +	return cc;
> 
> The question will repeat a couple of times in the patch: Do we want to
> convert that to a proper error (e.g., EBUSY, EINVAL, EWHATSOEVER)
> instead of returning "1" to user space (whoch looks weird).

Not sure about the right error code. 
-EIO for cc == 1?



> 
>> +}
>> +
>> +static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +	int i, r = 0;
>> +	u16 dummy;
>> +
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		mutex_lock(&vcpu->mutex);
>> +		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
>> +		mutex_unlock(&vcpu->mutex);
>> +		if (r)
>> +			break;
>> +	}
>> +	if (r)
>> +		kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
>> +	return r;
>> +}
> 
> [...]
> 
>> @@ -0,0 +1,266 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Hosting Secure Execution virtual machines
> 
> Just wondering "Protected Virtualization" vs. "Secure Execution".

No name yet, will use protected virtual machines as an independent term.

> 
> [...]
> 
>> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>> +{
>> +	int cc = 0;
>> +
>> +	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
>> +		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
>> +				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
>> +
>> +		KVM_UV_EVENT(vcpu->kvm, 3,
>> +			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
>> +			     vcpu->vcpu_id, *rc, *rrc);
>> +		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
>> +			  *rc, *rrc);
>> +	}
> 
> /* Intended memory leak for something that should never happen. */

ack
> 
>> +	if (!cc)
>> +		free_pages(vcpu->arch.pv.stor_base,
>> +			   get_order(uv_info.guest_cpu_stor_len));
> 
> Should we clear arch.pv.handle?

this is done in the memset below
> 
> Also, I do wonder if it makes sense to
> 
> vcpu->arch.pv.stor_base = NULL;

same. We could do 4 single assignments instead, but the memset is probably ok?

> 
> So really remove any traces and act like the error never happened. Only
> skip the freeing. Makes sense? Then we're not stuck with a
> half-initialized VM state.

I think this is what we do with the memset.

> 
> 
>> +	vcpu->arch.sie_block->pv_handle_cpu = 0;
>> +	vcpu->arch.sie_block->pv_handle_config = 0;
>> +	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
>> +	vcpu->arch.sie_block->sdf = 0;
>> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>> +
>> +	return cc;
> 
> Convert to a proper error?

-EIO?

> 
>> +}
>> +
>> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>> +{
>> +	struct uv_cb_csc uvcb = {
>> +		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
>> +		.header.len = sizeof(uvcb),
>> +	};
>> +	int cc;
>> +
>> +	if (kvm_s390_pv_cpu_get_handle(vcpu))
>> +		return -EINVAL;
>> +
>> +	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL,
>> +						   get_order(uv_info.guest_cpu_stor_len));
>> +	if (!vcpu->arch.pv.stor_base)
>> +		return -ENOMEM;
>> +
>> +	/* Input */
>> +	uvcb.guest_handle = kvm_s390_pv_get_handle(vcpu->kvm);
>> +	uvcb.num = vcpu->arch.sie_block->icpua;
>> +	uvcb.state_origin = (u64)vcpu->arch.sie_block;
>> +	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	KVM_UV_EVENT(vcpu->kvm, 3,
>> +		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
>> +		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
>> +		     uvcb.header.rrc);
>> +
>> +	if (cc) {
>> +		u16 dummy;
>> +
>> +		kvm_s390_pv_destroy_cpu(vcpu, &dummy, &dummy);
>> +		return -EINVAL;
> 
> Ah, here we convert from cc to an actual error :)

also EIO then?
> 
>> +	}
>> +
>> +	/* Output */
>> +	vcpu->arch.pv.handle = uvcb.cpu_handle;
>> +	vcpu->arch.sie_block->pv_handle_cpu = uvcb.cpu_handle;
>> +	vcpu->arch.sie_block->pv_handle_config = kvm_s390_pv_get_handle(vcpu->kvm);
>> +	vcpu->arch.sie_block->sdf = 2;
>> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>> +	return 0;
>> +}
>> +
>> +/* only free resources when the destroy was successful */
> 
> s/destroy/deinit/

Not really. deinit is destroy + dealloc. And we only dealloc when destroy was ok.



> 
>> +static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
>> +{
>> +	vfree(kvm->arch.pv.stor_var);
>> +	free_pages(kvm->arch.pv.stor_base,
>> +		   get_order(uv_info.guest_base_stor_len));
>> +	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
>> +}
>> +
>> +static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>> +{
>> +	unsigned long base = uv_info.guest_base_stor_len;
>> +	unsigned long virt = uv_info.guest_virt_var_stor_len;
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
> 
> I remember I asked this question already, maybe I missed the reply :(
> 
> 1. What if we have multiple slots?

memslot 0 is the last one, so this should actually have the last memory address
so this should be ok.

> 2. What is expected to happen if new slots are added (e.g., memory
> hotplug in the future?)
> 
> Shouldn't you bail out if there is more than one slot and make sure that
> no new ones can be added as long as pv is active (I remember the latter
> should be very easy from an arch callback)?

Yes, that should be easy, something like the following I guess

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4744,6 +4744,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
        if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
                return -EINVAL;
 
+       /* When we are protected we should not change the memory slots */
+       if (kvm_s390_pv_is_protected(kvm))
+               return -EINVAL;
        return 0;
 }
 



I think we can extend that later to actually use
the memorysize from kvm->arch.mem_limit as long as this is reasonably small.
This should then be done when we implement memory hotplug.


> 
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
>> +int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +	int cc;
>> +
>> +	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>> +			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> 
> Could convert to
> 
> int cc = ...
there will be a call to s390_reset_acc in a later patch that sneaks in here.
> 
>> +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
>> +	atomic_set(&kvm->mm->context.is_protected, 0);
>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>> +	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
>> +	if (!cc)
>> +		kvm_s390_pv_dealloc_vm(kvm);
> 
> Similar to the VCPU path, should be set all pointers to NULL but skip
> the freeing? With a similar comment /* Inteded memory leak ... */

This is done in kvm_s390_pv_dealloc_vm. And I think it makes sense to keep
the VM thing linked to the KVM struct. This will prevent the user from doing
another PV_ENABLE on this guest.

> 
>> +	return cc;
> 
> Does it make more sense to translate that to a proper error? (EBUSY,
> EINVAL etc.) I'd assume we translate that to a proper error - if any.
> Returning e.g., "1" does not make too much sense IMHO.

-EIO?

> 
>> +}
>> +
>> +int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>> +{
>> +	u16 drc, drrc;
>> +	int cc, ret;
>> +
> 
> superfluous empty line.
> 

ack

>> +	struct uv_cb_cgc uvcb = {
>> +		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
>> +		.header.len = sizeof(uvcb)
>> +	};
> 
> maybe
> 
> int ret = kvm_s390_pv_alloc_vm(kvm);
> 
> no strong feelings.
> 
>> +
>> +	ret = kvm_s390_pv_alloc_vm(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Inputs */
>> +	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
>> +	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
>> +	uvcb.guest_asce = kvm->arch.gmap->asce;
>> +	uvcb.guest_sca = (unsigned long)kvm->arch.sca;
>> +	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
>> +	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
>> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
>> +



>> +	/* Outputs */
>> +	kvm->arch.pv.handle = uvcb.guest_handle;
>> +
>> +	if (cc && (uvcb.header.rc & UVC_RC_NEED_DESTROY)) {
> 
> So, in case cc!=0 and UVC_RC_NEED_DESTROY is not set, we would return an
> error (!=0 from this function) and not even try to deinit the vm?
> 
> This is honestly confusing stuff.
> 
>> +		if (!kvm_s390_pv_deinit_vm(kvm, &drc, &drrc))
>> +			kvm_s390_pv_dealloc_vm(kvm);
> 
> kvm_s390_pv_deinit_vm() will already call kvm_s390_pv_dealloc_vm().

right. Will do 

        if (cc) {
                if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
                        kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
                else
                        kvm_s390_pv_dealloc_vm(kvm);
                return -EIO;
        }



> 
>> +		return -EINVAL;
>> +	}
>> +	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
>> +	atomic_set(&kvm->mm->context.is_protected, 1);
>> +	return cc;
> 
> Convert to a proper error?

-EIO (I think I will keep -EINVAL for the mpstate ioctl).
> 
> 
> Feel free to send a new version of this patch only on top. I'll try to
> review it very fast :)
> 


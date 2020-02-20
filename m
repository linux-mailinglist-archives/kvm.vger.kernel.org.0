Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DE166760
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 20:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBTTom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 14:44:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728334AbgBTTom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 14:44:42 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KJiOir071771
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 14:44:40 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y9ytqscng-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 14:44:40 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 20 Feb 2020 19:44:38 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 19:44:35 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KJiWc454591658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 19:44:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E61E811C04C;
        Thu, 20 Feb 2020 19:44:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C28D11C052;
        Thu, 20 Feb 2020 19:44:31 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.146.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 19:44:31 +0000 (GMT)
Subject: Re: [PATCH v3 09/37] KVM: s390: protvirt: Add initial vm and cpu
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
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
 <20200220104020.5343-10-borntraeger@de.ibm.com>
 <1f0c2c5a-5964-dc34-73af-7b1776391276@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 20 Feb 2020 20:44:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1f0c2c5a-5964-dc34-73af-7b1776391276@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022019-0012-0000-0000-00000388BB45
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022019-0013-0000-0000-000021C55330
Message-Id: <b9aa96ce-9701-cefb-68d8-76d1cba4d5c7@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_16:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=2 clxscore=1015 mlxlogscore=999 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.02.20 14:02, David Hildenbrand wrote:
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
>> +		r = kvm_s390_pv_alloc_vm(kvm);
>> +		if (r)
>> +			break;
>> +
>> +		/* FMT 4 SIE needs esca */
>> +		r = sca_switch_to_extended(kvm);
>> +		if (r) {
>> +			kvm_s390_pv_dealloc_vm(kvm);
>> +			kvm_s390_vcpu_unblock_all(kvm);
> 
> You forgot to remove that.

ack.
> 
>> +			mutex_unlock(&kvm->lock);
> 
> That's certainly wrong as well.

ack.

> 
>> +			break;
>> +		}
>> +		r = kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
>> +		if (!r)
>> +			r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
>> +		if (r)
>> +			kvm_s390_pv_destroy_vm(kvm, &dummy, &dummy);
> 
> Should there be a kvm_s390_pv_dealloc_vm() as well?

Hmm yes. But only if destroy does not fail...... see below.

> 
>> +
>> +		break;
>> +	}
>> +	case KVM_PV_DISABLE: {
>> +		r = -EINVAL;
>> +		if (!kvm_s390_pv_is_protected(kvm))
>> +			break;
>> +
>> +		kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
>> +		r = kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
>> +		if (!r)
>> +			kvm_s390_pv_dealloc_vm(kvm);
> 
> Hm, if destroy fails, the CPUs would already have been removed.
> 
> Is there a way to make kvm_s390_pv_destroy_vm() never fail? The return
> value is always ignored except here ... which looks wrong.

This should not fail. But if it does we should not free the memory that
we donated to the ultravisor. We then do have a memory leak, but this is 
necessary to keep the integrity of the host. 
I will fix the other places to only call dealloc when destroy succeeded.

Same for VCPU destroy. If that fails I should not free arch.pv.stor_base
will fix.


> 
>> +		break;
>> +	}
> 
> [...]
> 
>> @@ -2558,10 +2724,21 @@ static void kvm_free_vcpus(struct kvm *kvm)
>>  
>>  void kvm_arch_destroy_vm(struct kvm *kvm)
>>  {
>> +	u16 rc, rrc;
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
>> +	if (kvm_s390_pv_get_handle(kvm)) {
> 
> I'd prefer something like kvm_s390_pv_is_protected_unlocked(), but I
> guess for these few use cases, this is fine.

yes lets leave it as is... :-)


> 
> 
>> +		kvm_s390_pv_destroy_vm(kvm, &rc, &rrc);
>> +		kvm_s390_pv_dealloc_vm(kvm);
>> +	}
>> +	debug_unregister(kvm->arch.dbf);
>>  	free_page((unsigned long)kvm->arch.sie_page2);
>>  	if (!kvm_is_ucontrol(kvm))
>>  		gmap_remove(kvm->arch.gmap);
>> @@ -2657,6 +2834,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
>>  	unsigned int vcpu_idx;
>>  	u32 scaol, scaoh;
>>  
>> +	if (kvm->arch.use_esca)
>> +		return 0;
>> +
>>  	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
>>  	if (!new_sca)
>>  		return -ENOMEM;
>> @@ -2908,6 +3088,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_vcpu *vcpu)
>>  static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>  {
>>  	int rc = 0;
>> +	u16 uvrc, uvrrc;
>>  
>>  	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
>>  						    CPUSTAT_SM |
>> @@ -2975,6 +3156,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>  
>>  	kvm_s390_vcpu_crypto_setup(vcpu);
>>  
>> +	mutex_lock(&vcpu->kvm->lock);
>> +	if (kvm_s390_pv_is_protected(vcpu->kvm))
>> +		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
>> +	mutex_unlock(&vcpu->kvm->lock);
> 
> Do we have to cleanup anything? (e.g., cmma page) I *think*
> kvm_arch_vcpu_destroy() is not called when kvm_arch_vcpu_create() fails ...

Right we need to call kvm_s390_vcpu_unsetup_cmma. To me it looks like
this can be done unconditionally if rc!=0:

@@ -3156,8 +3158,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
        kvm_s390_vcpu_crypto_setup(vcpu);
 
        mutex_lock(&vcpu->kvm->lock);
-       if (kvm_s390_pv_is_protected(vcpu->kvm))
+       if (kvm_s390_pv_is_protected(vcpu->kvm)) {
                rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
+               if (rc)
+                       kvm_s390_vcpu_unsetup_cmma(vcpu);
+       }
        mutex_unlock(&vcpu->kvm->lock);
 
        return rc;


Everything else looks ok, no need to deallocate or so.

[...]

 */
>>  int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
>>  void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>> new file mode 100644
>> index 000000000000..67ea9a18ed8f
>> --- /dev/null
>> +++ b/arch/s390/kvm/pv.c
>> @@ -0,0 +1,256 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Hosting Secure Execution virtual machines
>> + *
>> + * Copyright IBM Corp. 2019
>> + *    Author(s): Janosch Frank <frankja@linux.ibm.com>
> 
> I'd assume you're an author as well at this point ;)

I personally prefer to not have authors in files and after all
I am just cleaning up so that Janosch can take care of QEMU.
But I will at least fixup the Copyright year.


> 
> [...]
> 
>> +
>> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>> +			      u16 *rrc)
>> +{
>> +	struct uv_cb_ssc uvcb = {
>> +		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
>> +		.header.len = sizeof(uvcb),
>> +		.sec_header_origin = (u64)hdr,
>> +		.sec_header_len = length,
>> +		.guest_handle = kvm_s390_pv_get_handle(kvm),
>> +	};
>> +	int cc;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
> 
> int cc = ... could be done.
> 

ack. 
> 
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
>> +		     *rc, *rrc);
>> +	if (cc)
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2],
>> +		      u16 *rc, u16 *rrc)
>> +{
>> +	struct uv_cb_unp uvcb = {
>> +		.header.cmd = UVC_CMD_UNPACK_IMG,
>> +		.header.len = sizeof(uvcb),
>> +		.guest_handle = kvm_s390_pv_get_handle(kvm),
>> +		.gaddr = addr,
>> +		.tweak[0] = tweak[0],
>> +		.tweak[1] = tweak[1],
>> +	};
>> +	int ret;
>> +
>> +	ret = gmap_make_secure(kvm->arch.gmap, addr, &uvcb);
> 
> ... similarly, with ret.


ack

> 
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +
>> +	if (ret && ret != -EAGAIN)
>> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx with rc %x rrc %x",
>> +			     uvcb.gaddr, *rc, *rrc);
>> +	return ret;
>> +}
>> +
>> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>> +		       unsigned long tweak, u16 *rc, u16 *rrc)
>> +{
>> +	u64 tw[2] = {tweak, 0};
> 
> I have no idea what tweaks are in this context. So I have to trust you
> guys on the implementation, because I don't understand it.

Its the crypto term. Basically similar idea like salt or nonce.

> 
> Especially, why can't we simply have
> 
> s/tweak/tweak/

? 

> 
> offset = 0;
> 
> while (offset < size) {
> 	...
> 	ret = unpack_one(kvm, addr, tweak, offset, rc, rrc);
> 				    ^ no idea what tweak is
> 	...
> 	... offset +=  PAGE_SIZE;
> }
> 
> But maybe I am missing what the whole array is about.

Both values (the initial 64bit value and the address) form the 128 bit
tweak for the decryption. So the offset is actually part of the tweak.

So yes we could rewrite that using offset and not passing through an array
but tweak + offset as separate u64.

will check if this makes it any clearer
> 
>> +	int ret = 0;
>> +
>> +	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
>> +		return -EINVAL;
>> +
>> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
>> +		     addr, size);
>> +
>> +	while (tw[1] < size) {

> +		ret = unpack_one(kvm, addr, tw, rc, rrc);
>> +		if (ret == -EAGAIN) {
>> +			cond_resched();
>> +			if (fatal_signal_pending(current))
>> +				break;
>> +			continue;
>> +		}
>> +		if (ret)
>> +			break;
>> +		addr += PAGE_SIZE;
>> +		tw[1] += PAGE_SIZE;
>> +	}
>> +	if (!ret)
>> +		KVM_UV_EVENT(kvm, 3, "%s", "PROTVIRT VM UNPACK: successful");
>> +	return ret;
>> +}
> 
> [...]
>> +enum pv_cmd_id {
>> +	KVM_PV_ENABLE,
>> +	KVM_PV_DISABLE,
>> +	KVM_PV_VM_SET_SEC_PARMS,
>> +	KVM_PV_VM_UNPACK,
>> +	KVM_PV_VM_VERIFY,
> 
> I wonder if we should just drop "_VM" from all of these ...


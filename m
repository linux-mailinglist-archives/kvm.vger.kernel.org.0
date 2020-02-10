Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D0E1573D4
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgBJMG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:06:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgBJMG2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 07:06:28 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ABwxHw143736
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:06:27 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tpbcsev-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:06:27 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 10 Feb 2020 12:06:25 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 12:06:22 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AC5Qa327459938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 12:05:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7439CA405F;
        Mon, 10 Feb 2020 12:06:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05704A4040;
        Mon, 10 Feb 2020 12:06:20 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 12:06:19 +0000 (GMT)
Subject: Re: [PATCH/RFC] KVM: s390: protvirt: pass-through rc and rrc
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com
References: <62d5cd46-93d7-e272-f9bb-d4ec3c7a1f71@de.ibm.com>
 <20200210114526.134769-1-borntraeger@de.ibm.com>
To:     thuth@redhat.com
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 10 Feb 2020 13:06:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200210114526.134769-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20021012-0016-0000-0000-000002E5765C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021012-0017-0000-0000-0000334866E6
Message-Id: <a94f3d09-1474-29d2-a2d3-3118170e494e@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxlogscore=978 mlxscore=0 suspectscore=3 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

What about the following. I will rip out RC and RRC but add 
a 32bit flags field (which must be 0) and 3*64 bit reserved.


On 10.02.20 12:45, Christian Borntraeger wrote:
> This would be one variant to get the RC/RRC to userspace.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 34 +++++++++++++++++++++++++---------
>  arch/s390/kvm/kvm-s390.h | 15 ++++++++-------
>  arch/s390/kvm/pv.c       | 30 ++++++++++++++++++++++--------
>  include/uapi/linux/kvm.h |  4 ++--
>  4 files changed, 57 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e1bccbb41fdd..8dae9629b47f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2172,6 +2172,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  	int r = 0;
>  	void __user *argp = (void __user *)cmd->data;
>  
> +	cmd->rc = 0;
> +	cmd->rrc = 0;
>  	switch (cmd->cmd) {
>  	case KVM_PV_VM_CREATE: {
>  		r = -EINVAL;
> @@ -2192,7 +2194,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  			mutex_unlock(&kvm->lock);
>  			break;
>  		}
> -		r = kvm_s390_pv_create_vm(kvm);
> +		r = kvm_s390_pv_create_vm(kvm, cmd);
>  		kvm_s390_vcpu_unblock_all(kvm);
>  		mutex_unlock(&kvm->lock);
>  		break;
> @@ -2205,7 +2207,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		/* All VCPUs have to be destroyed before this call. */
>  		mutex_lock(&kvm->lock);
>  		kvm_s390_vcpu_block_all(kvm);
> -		r = kvm_s390_pv_destroy_vm(kvm);
> +		r = kvm_s390_pv_destroy_vm(kvm, cmd);
>  		if (!r)
>  			kvm_s390_pv_dealloc_vm(kvm);
>  		kvm_s390_vcpu_unblock_all(kvm);
> @@ -2237,7 +2239,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		r = -EFAULT;
>  		if (!copy_from_user(hdr, (void __user *)parms.origin,
>  				   parms.length))
> -			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length);
> +			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length, cmd);
>  
>  		vfree(hdr);
>  		break;
> @@ -2253,7 +2255,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		if (copy_from_user(&unp, argp, sizeof(unp)))
>  			break;
>  
> -		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
> +		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak, cmd);
>  		break;
>  	}
>  	case KVM_PV_VM_VERIFY: {
> @@ -2268,6 +2270,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  				  &ret);
>  		VM_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x",
>  			 ret >> 16, ret & 0x0000ffff);
> +		cmd->rc = ret >> 16;
> +		cmd->rrc = ret & 0xffff;
>  		break;
>  	}
>  	default:
> @@ -2385,6 +2389,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			break;
>  
>  		r = kvm_s390_handle_pv(kvm, &args);
> +
> +		if (copy_to_user(argp, &args, sizeof(args)))
> +			r = -EFAULT;
> +
>  		break;
>  	}
>  	default:
> @@ -2650,6 +2658,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_pv_cmd dummy;
> +
>  	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
>  	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
>  	kvm_s390_clear_local_irqs(vcpu);
> @@ -2663,7 +2673,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	if (vcpu->kvm->arch.use_cmma)
>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
>  	if (kvm_s390_pv_handle_cpu(vcpu))
> -		kvm_s390_pv_destroy_cpu(vcpu);
> +		kvm_s390_pv_destroy_cpu(vcpu, &dummy);
>  	free_page((unsigned long)(vcpu->arch.sie_block));
>  
>  	kvm_vcpu_uninit(vcpu);
> @@ -2688,11 +2698,13 @@ static void kvm_free_vcpus(struct kvm *kvm)
>  
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	struct kvm_pv_cmd dummy;
> +
>  	kvm_free_vcpus(kvm);
>  	sca_dispose(kvm);
>  	kvm_s390_gisa_destroy(kvm);
>  	if (kvm_s390_pv_is_protected(kvm)) {
> -		kvm_s390_pv_destroy_vm(kvm);
> +		kvm_s390_pv_destroy_vm(kvm, &dummy);
>  		kvm_s390_pv_dealloc_vm(kvm);
>  	}
>  	debug_unregister(kvm->arch.dbf);
> @@ -3153,6 +3165,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
> +	struct kvm_pv_cmd dummy;
>  	int rc = -EINVAL;
>  
>  	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
> @@ -3188,7 +3201,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  		goto out_free_sie_block;
>  
>  	if (kvm_s390_pv_is_protected(kvm)) {
> -		rc = kvm_s390_pv_create_cpu(vcpu);
> +		rc = kvm_s390_pv_create_cpu(vcpu, &dummy);
>  		if (rc) {
>  			kvm_vcpu_uninit(vcpu);
>  			goto out_free_sie_block;
> @@ -4511,19 +4524,22 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
>  	if (!kvm_s390_pv_is_protected(vcpu->kvm))
>  		return -EINVAL;
>  
> +	cmd->rc = 0;
> +	cmd->rrc = 0;
> +
>  	switch (cmd->cmd) {
>  	case KVM_PV_VCPU_CREATE: {
>  		if (kvm_s390_pv_handle_cpu(vcpu))
>  			return -EINVAL;
>  
> -		r = kvm_s390_pv_create_cpu(vcpu);
> +		r = kvm_s390_pv_create_cpu(vcpu, cmd);
>  		break;
>  	}
>  	case KVM_PV_VCPU_DESTROY: {
>  		if (!kvm_s390_pv_handle_cpu(vcpu))
>  			return -EINVAL;
>  
> -		r = kvm_s390_pv_destroy_cpu(vcpu);
> +		r = kvm_s390_pv_destroy_cpu(vcpu, cmd);
>  		break;
>  	}
>  	default:
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 32c0c01d5df0..b77d5f565b5c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -199,14 +199,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>  /* implemented in pv.c */
>  void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
>  int kvm_s390_pv_alloc_vm(struct kvm *kvm);
> -int kvm_s390_pv_create_vm(struct kvm *kvm);
> -int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
> -int kvm_s390_pv_destroy_vm(struct kvm *kvm);
> -int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
> -int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
> +int kvm_s390_pv_create_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd);
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd);
> +int kvm_s390_pv_destroy_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd);
> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd);
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length,
> +			      struct kvm_pv_cmd *cmd);
>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
> -		       unsigned long tweak);
> -int kvm_s390_pv_verify(struct kvm *kvm);
> +		       unsigned long tweak, struct kvm_pv_cmd *cmd);
> +int kvm_s390_pv_verify(struct kvm *kvm, struct kvm_pv_cmd *cmd);
>  
>  static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
>  {
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c1778cb3f8ac..381dc3fefac4 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -61,7 +61,7 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	return -ENOMEM;
>  }
>  
> -int kvm_s390_pv_destroy_vm(struct kvm *kvm)
> +int kvm_s390_pv_destroy_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  {
>  	int rc;
>  	u32 ret;
> @@ -72,10 +72,12 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
>  	atomic_set(&kvm->mm->context.is_protected, 0);
>  	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
>  		 ret >> 16, ret & 0x0000ffff);
> +	cmd->rc = ret >> 16;
> +	cmd->rrc = ret & 0xffff;
>  	return rc;
>  }
>  
> -int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
>  {
>  	int rc = 0;
>  	u32 ret;
> @@ -87,6 +89,8 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
>  
>  		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
>  			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +		cmd->rc = ret >> 16;
> +		cmd->rrc = ret & 0xffff;
>  	}
>  
>  	free_pages(vcpu->arch.pv.stor_base,
> @@ -98,7 +102,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
>  	return rc;
>  }
>  
> -int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
>  {
>  	int rc;
>  	struct uv_cb_csc uvcb = {
> @@ -124,9 +128,13 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
>  	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
>  		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
>  		   uvcb.header.rrc);
> +	cmd->rc = uvcb.header.rc;
> +	cmd->rrc = uvcb.header.rrc;
>  
>  	if (rc) {
> -		kvm_s390_pv_destroy_cpu(vcpu);
> +		struct kvm_pv_cmd dummy;
> +
> +		kvm_s390_pv_destroy_cpu(vcpu, &dummy);
>  		return -EINVAL;
>  	}
>  
> @@ -138,7 +146,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -int kvm_s390_pv_create_vm(struct kvm *kvm)
> +int kvm_s390_pv_create_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  {
>  	int rc;
>  
> @@ -162,12 +170,15 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
>  	VM_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
>  		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
>  		 uvcb.header.rrc);
> +	cmd->rc = uvcb.header.rc;
> +	cmd->rrc = uvcb.header.rrc;
>  
>  	/* Outputs */
>  	kvm->arch.pv.handle = uvcb.guest_handle;
>  
>  	if (rc && (uvcb.header.rc & UVC_RC_NEED_DESTROY)) {
> -		kvm_s390_pv_destroy_vm(kvm);
> +		struct kvm_pv_cmd dummy;
> +		kvm_s390_pv_destroy_vm(kvm, &dummy);
>  		return -EINVAL;
>  	}
>  	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> @@ -176,7 +187,7 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
>  }
>  
>  int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
> -			      void *hdr, u64 length)
> +			      void *hdr, u64 length, struct kvm_pv_cmd *cmd)
>  {
>  	int rc;
>  	struct uv_cb_ssc uvcb = {
> @@ -193,6 +204,9 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
>  	rc = uv_call(0, (u64)&uvcb);
>  	VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
>  		 uvcb.header.rc, uvcb.header.rrc);
> +	cmd->rc = uvcb.header.rc;
> +	cmd->rrc = uvcb.header.rrc;
> +
>  	if (rc)
>  		return -EINVAL;
>  	return 0;
> @@ -219,7 +233,7 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
>  }
>  
>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
> -		       unsigned long tweak)
> +		       unsigned long tweak, struct kvm_pv_cmd *cmd)
>  {
>  	int rc = 0;
>  	u64 tw[2] = {tweak, 0};
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eab741bc12c3..17c1a9556eac 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1508,8 +1508,8 @@ struct kvm_pv_cmd {
>  };
>  
>  /* Available with KVM_CAP_S390_PROTECTED */
> -#define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
> -#define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)
> +#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
> +#define KVM_S390_PV_COMMAND_VCPU	_IOWR(KVMIO, 0xc6, struct kvm_pv_cmd)
>  
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> 


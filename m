Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FA752050F
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiEITQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 15:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiEITQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 15:16:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B194E3BA;
        Mon,  9 May 2022 12:12:56 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249I9djS011658;
        Mon, 9 May 2022 19:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RbWT5rhVWas8QXCq+ubniSU8mnfGh5fBZzO8EM3wZAo=;
 b=pdFcEr+Bpc6U8MQcGP3FuC1s/Zv66bkXSAnUqdXVJlWFcbhy+h8KCDyp7ZaWgDcQkIj8
 +eifAbh3CYFdVdC3LulON9ZEu+t6G/zO7nBXPrQc78szwIl8PIAlYDz93B8whp2xN0nP
 V5UUQXPKxMBjzs4WdZbc2ar0YV/L+fJ8F3wWeEAmqlH4wW/YbIWj3e0hnJhUC4BbevhN
 /LoZ5zrWftOl5W2UwX2Rxo+/wW2uSknyT2GiulJU/u5X2jiQwVHirBxuOeNAdVX6EXcY
 5bTUkgbZVYhtb/SI6HI/TxlBDfktgSdy9+7y4xVcFBCU5/vm5YLhAc49e1uPfQOZiWeA pw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy6waaaxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 19:12:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249IvCHc029059;
        Mon, 9 May 2022 19:12:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j2xs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 19:12:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249JCZBM27525422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 19:12:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C37AE045;
        Mon,  9 May 2022 19:12:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC330AE04D;
        Mon,  9 May 2022 19:12:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 19:12:49 +0000 (GMT)
Date:   Mon, 9 May 2022 19:51:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 6/9] kvm: s390: Add configuration dump functionality
Message-ID: <20220509195135.3f04343f@p-imbrenda>
In-Reply-To: <20220428130102.230790-7-frankja@linux.ibm.com>
References: <20220428130102.230790-1-frankja@linux.ibm.com>
 <20220428130102.230790-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bOsOJoBDxt216Tkcz4NoXORtmg1W2w0b
X-Proofpoint-ORIG-GUID: bOsOJoBDxt216Tkcz4NoXORtmg1W2w0b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Apr 2022 13:00:59 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Sometimes dumping inside of a VM fails, is unavailable or doesn't
> yield the required data. For these occasions we dump the VM from the
> outside, writing memory and cpu data to a file.
> 
> Up to now PV guests only supported dumping from the inside of the
> guest through dumpers like KDUMP. A PV guest can be dumped from the
> hypervisor but the data will be stale and / or encrypted.
> 
> To get the actual state of the PV VM we need the help of the
> Ultravisor who safeguards the VM state. New UV calls have been added
> to initialize the dump, dump storage state data, dump cpu data and
> complete the dump process. We expose these calls in this patch via a
> new UV ioctl command.
> 
> The sensitive parts of the dump data are encrypted, the dump key is
> derived from the Customer Communication Key (CCK). This ensures that
> only the owner of the VM who has the CCK can decrypt the dump data.
> 
> The memory is dumped / read via a normal export call and a re-import
> after the dump initialization is not needed (no re-encryption with a
> dump key).
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |   1 +
>  arch/s390/kvm/kvm-s390.c         | 146 +++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h         |   2 +
>  arch/s390/kvm/pv.c               | 115 ++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  15 ++++
>  5 files changed, 279 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 766028d54a3e..a0fbe4820e0a 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -923,6 +923,7 @@ struct kvm_s390_pv {
>  	u64 guest_len;
>  	unsigned long stor_base;
>  	void *stor_var;
> +	bool dumping;
>  };
>  
>  struct kvm_arch{
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e327a5b8ef78..8984e8db33b4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,26 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_PROTECTED:
>  		r = is_prot_virt_host();
>  		break;
> +	case KVM_CAP_S390_PROTECTED_DUMP: {
> +		u64 pv_cmds_dump[] = {
> +			BIT_UVC_CMD_DUMP_INIT,
> +			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
> +			BIT_UVC_CMD_DUMP_CPU,
> +			BIT_UVC_CMD_DUMP_COMPLETE,
> +		};
> +		int i;
> +
> +		if (!is_prot_virt_host())
> +			return 0;
> +
> +		r = 1;
> +		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
> +			if (!test_bit_inv(pv_cmds_dump[i],
> +					  (unsigned long *)&uv_info.inst_calls_list))
> +				return 0;
> +		}
> +		break;
> +	}
>  	default:
>  		r = 0;
>  	}
> @@ -2271,6 +2291,101 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>  	}
>  }
>  
> +static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
> +			   struct kvm_s390_pv_dmp dmp)
> +{
> +	int r = -EINVAL;
> +	void __user *result_buff = (void __user *)dmp.buff_addr;
> +
> +	switch (dmp.subcmd) {
> +	case KVM_PV_DUMP_INIT: {
> +		if (kvm->arch.pv.dumping)
> +			break;
> +
> +		/*
> +		 * Block SIE entry as concurrent dump UVCs could lead
> +		 * to validities.
> +		 */
> +		kvm_s390_vcpu_block_all(kvm);
> +
> +		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
> +				  UVC_CMD_DUMP_INIT, &cmd->rc, &cmd->rrc);
> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP INIT: rc %x rrc %x",
> +			     cmd->rc, cmd->rrc);
> +		if (!r)
> +			kvm->arch.pv.dumping = true;
> +		else {
> +			kvm_s390_vcpu_unblock_all(kvm);
> +			r = -EINVAL;
> +		}
> +		break;
> +	}
> +	case KVM_PV_DUMP_CONFIG_STOR_STATE: {
> +		if (!kvm->arch.pv.dumping)
> +			break;
> +
> +		/*
> +		 * gaddr is an output parameter since we might stop
> +		 * early. As dmp will be copied back in our caller, we
> +		 * don't need to do it ourselves.
> +		 */
> +		r = kvm_s390_pv_dump_stor_state(kvm, result_buff, &dmp.gaddr, dmp.buff_len,
> +						&cmd->rc, &cmd->rrc);
> +		break;
> +	}
> +	case KVM_PV_DUMP_COMPLETE: {
> +		struct uv_cb_dump_complete complete = {
> +			.header.len = sizeof(complete),
> +			.header.cmd = UVC_CMD_DUMP_COMPLETE,
> +			.config_handle = kvm_s390_pv_get_handle(kvm),
> +		};
> +		u64 *compl_data;
> +
> +		r = -EINVAL;
> +		if (!kvm->arch.pv.dumping)
> +			break;
> +
> +		if (dmp.buff_len < uv_info.conf_dump_finalize_len)
> +			break;
> +
> +		/* Allocate dump area */
> +		r = -ENOMEM;
> +		compl_data = vzalloc(uv_info.conf_dump_finalize_len);
> +		if (!compl_data)
> +			break;
> +		complete.dump_area_origin = (u64)compl_data;
> +
> +		r = uv_call(0, (u64)&complete);
> +		cmd->rc = complete.header.rc;
> +		cmd->rrc = complete.header.rrc;
> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP COMPLETE: rc %x rrc %x",
> +			     complete.header.rc, complete.header.rrc);
> +
> +		if (!r) {
> +			/*
> +			 * kvm_s390_pv_dealloc_vm() will also (mem)set
> +			 * this to false on a reboot or other destroy
> +			 * operation for this vm.
> +			 */
> +			kvm->arch.pv.dumping = false;
> +			kvm_s390_vcpu_unblock_all(kvm);
> +			r = copy_to_user(result_buff, compl_data, uv_info.conf_dump_finalize_len);
> +			if (r)
> +				r = -EFAULT;
> +		}
> +		vfree(compl_data);
> +		if (r > 0)
> +			r = -EINVAL;
> +		break;
> +	}
> +	default:
> +		r = -ENOTTY;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
>  static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  {
>  	int r = 0;
> @@ -2447,6 +2562,28 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		r = 0;
>  		break;
>  	}
> +	case KVM_PV_DUMP: {
> +		struct kvm_s390_pv_dmp dmp;
> +
> +		r = -EINVAL;
> +		if (!kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&dmp, argp, sizeof(dmp)))
> +			break;
> +
> +		r = kvm_s390_pv_dmp(kvm, cmd, dmp);
> +		if (r)
> +			break;
> +
> +		if (copy_to_user(argp, &dmp, sizeof(dmp))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> @@ -4564,6 +4701,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	struct kvm_run *kvm_run = vcpu->run;
>  	int rc;
>  
> +	/*
> +	 * Running a VM while dumping always has the potential to
> +	 * produce inconsistent dump data. But for PV vcpus a SIE
> +	 * entry while dumping could also lead to a validity which we
> +	 * absolutely want to avoid.
> +	 */
> +	if (vcpu->kvm->arch.pv.dumping)
> +		return -EINVAL;
> +
>  	if (kvm_run->immediate_exit)
>  		return -EINTR;
>  
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 497d52a83c78..2868dd0bba25 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -250,6 +250,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>  		       unsigned long tweak, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
> +int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
> +				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
>  
>  static inline u64 kvm_s390_pv_get_handle(struct kvm *kvm)
>  {
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index cc7c9599f43e..d1635ed50078 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -298,3 +298,118 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
>  		return -EINVAL;
>  	return 0;
>  }
> +
> +/* Size of the cache for the storage state dump data. 1MB for now */
> +#define DUMP_BUFF_LEN HPAGE_SIZE
> +
> +/*
> + * kvm_s390_pv_dump_stor_state
> + *
> + * @kvm: pointer to the guest's KVM struct
> + * @buff_user: Userspace pointer where we will write the results to
> + * @gaddr: Starting absolute guest address for which the storage
> state
> + *         is requested. This value will be updated with the last
> + *         address for which data was written when returning to
> + *         userspace.
> + * @buff_user_len: Length of the buff_user buffer
> + * @rc: Pointer to where the uvcb return code is stored
> + * @rrc: Pointer to where the uvcb return reason code is stored
> + *
> + * Return:
> + *  0 on success
> + *  -ENOMEM if allocating the cache fails
> + *  -EINVAL if gaddr is not aligned to 1MB
> + *  -EINVAL if buff_user_len is not aligned to
> uv_info.conf_dump_storage_state_len
> + *  -EINVAL if the UV call fails, rc and rrc will be set in this case
> + *  -EFAULT if copying the result to buff_user failed
> + */
> +int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user
> *buff_user,
> +				u64 *gaddr, u64 buff_user_len, u16
> *rc, u16 *rrc) +{
> +	struct uv_cb_dump_stor_state uvcb = {
> +		.header.cmd = UVC_CMD_DUMP_CONF_STOR_STATE,
> +		.header.len = sizeof(uvcb),
> +		.config_handle = kvm->arch.pv.handle,
> +		.gaddr = *gaddr,
> +		.dump_area_origin = 0,
> +	};
> +	size_t buff_kvm_size;
> +	size_t size_done = 0;
> +	u8 *buff_kvm = NULL;
> +	int cc, ret;
> +
> +	ret = -EINVAL;
> +	/* UV call processes 1MB guest storage chunks at a time */
> +	if (*gaddr & ~HPAGE_MASK)
> +		goto out;
> +
> +	/*
> +	 * We provide the storage state for 1MB chunks of guest
> +	 * storage. The buffer will need to be aligned to
> +	 * conf_dump_storage_state_len so we don't end on a partial
> +	 * chunk.
> +	 */
> +	if (!buff_user_len ||
> +	    buff_user_len & (uv_info.conf_dump_storage_state_len -
> 1))

why not use the IS_ALIGNED macro?

> +		goto out;
> +
> +	/*
> +	 * Allocate a buffer from which we will later copy to the user process.
> +	 *
> +	 * We don't want userspace to dictate our buffer size so we limit it to DUMP_BUFF_LEN.
> +	 */
> +	ret = -ENOMEM;
> +	buff_kvm_size = buff_user_len <= DUMP_BUFF_LEN ? buff_user_len : DUMP_BUFF_LEN;
> +	buff_kvm = vzalloc(buff_kvm_size);
> +	if (!buff_kvm)
> +		goto out;
> +
> +	ret = 0;
> +	uvcb.dump_area_origin = (u64)buff_kvm;
> +	/* We will loop until the user buffer is filled or an error occurs */
> +	do {
> +		/* Get a page of data */

are you getting a page or a block of size conf_dump_storage_state_len ?

> +		cc = uv_call_sched(0, (u64)&uvcb);
> +
> +		/* All or nothing */
> +		if (cc) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		size_done += uv_info.conf_dump_storage_state_len;
> +		uvcb.dump_area_origin +=
> uv_info.conf_dump_storage_state_len;
> +		uvcb.gaddr += HPAGE_SIZE;
> +		buff_user_len -= PAGE_SIZE;

same here ^ (should it be -= uv_info.conf_dump_storage_state_len ?)

> +
> +		/* KVM Buffer full, time to copy to the process */
> +		if (!buff_user_len ||
> +		    uvcb.dump_area_origin == (uintptr_t)buff_kvm +
> buff_kvm_size) { +

why not  ... || size_done == DUMP_BUFF_LEN ?

> +			if (copy_to_user(buff_user, buff_kvm,
> +					 uvcb.dump_area_origin -
> (uintptr_t)buff_kvm)) {

aren't you trying to copy size_done bytes?

> +				ret = -EFAULT;
> +				break;
> +			}
> +
> +			buff_user += size_done;
> +			size_done = 0;
> +			uvcb.dump_area_origin = (u64)buff_kvm;
> +		}
> +	} while (buff_user_len);
> +
> +	/* Report back where we ended dumping */
> +	*gaddr = uvcb.gaddr;
> +
> +	/* Lets only log errors, we don't want to spam */
> +out:
> +	if (ret)
> +		KVM_UV_EVENT(kvm, 3,
> +			     "PROTVIRT DUMP STORAGE STATE: addr %llx
> ret %d, uvcb rc %x rrc %x",
> +			     uvcb.gaddr, ret, uvcb.header.rc,
> uvcb.header.rrc);
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	vfree(buff_kvm);
> +
> +	return ret;
> +}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2eba89d7ec29..b34850907291 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1645,6 +1645,20 @@ struct kvm_s390_pv_unp {
>  	__u64 tweak;
>  };
>  
> +enum pv_cmd_dmp_id {
> +	KVM_PV_DUMP_INIT,
> +	KVM_PV_DUMP_CONFIG_STOR_STATE,
> +	KVM_PV_DUMP_COMPLETE,
> +};
> +
> +struct kvm_s390_pv_dmp {
> +	__u64 subcmd;
> +	__u64 buff_addr;
> +	__u64 buff_len;
> +	__u64 gaddr;		/* For dump storage state */
> +	__u64 reserved[4];
> +};
> +
>  enum pv_cmd_info_id {
>  	KVM_PV_INFO_VM,
>  	KVM_PV_INFO_DUMP,
> @@ -1688,6 +1702,7 @@ enum pv_cmd_id {
>  	KVM_PV_PREP_RESET,
>  	KVM_PV_UNSHARE_ALL,
>  	KVM_PV_INFO,
> +	KVM_PV_DUMP,
>  };
>  
>  struct kvm_pv_cmd {


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E007511A64
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbiD0NBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 09:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiD0NBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 09:01:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65402C5303;
        Wed, 27 Apr 2022 05:58:11 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RCio6t013841;
        Wed, 27 Apr 2022 12:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wXCKYBOleYK5nPHugtXoU5XDgsJfZSe2PT0UwL/ThdU=;
 b=QjSVLvlG5fuSoH9ASPbA4dTeeSlt37+tXvDAHAfy9d327LHYKEZeFOrgkJqa6BM2aC4u
 f2VjoGH63g7gegT8+ZRGFAgXC0n5xk1wq1BIRr49Y6WJF0rVuI3e+aP6GhtQkrOSUXL8
 HAEe2m93/pBoaKq+6DY22TBt8NB5L1sBx/bmxq+6vPBfyuwYxALD5lGvuZ+QiRmmcn8m
 m4LUewLkWaV8ECI2KvW/q/AqAcea14kBeXU6oN4Q1BCfqmBJeuYUedjg5iS7xSpY041A
 l3m+W0C2hx52usNndm61+L1xgJB6cAVr8573patXRBdKys+5y3EslUwbrP+gYP8pDaIh qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpsdpnp33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:58:10 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RCioWU013845;
        Wed, 27 Apr 2022 12:58:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpsdpnp2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:58:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RCmksL010015;
        Wed, 27 Apr 2022 12:58:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3fm938vqam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:58:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RCw53149218004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 12:58:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0116D4C04E;
        Wed, 27 Apr 2022 12:58:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E10E4C040;
        Wed, 27 Apr 2022 12:58:04 +0000 (GMT)
Received: from [9.145.9.25] (unknown [9.145.9.25])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 12:58:04 +0000 (GMT)
Message-ID: <845a0959-2b54-02b2-1df2-c32df4ba2410@linux.ibm.com>
Date:   Wed, 27 Apr 2022 14:58:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
References: <20220310103112.2156-1-frankja@linux.ibm.com>
 <20220310103112.2156-7-frankja@linux.ibm.com>
 <20220427141409.37cd38df@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 6/9] kvm: s390: Add configuration dump functionality
In-Reply-To: <20220427141409.37cd38df@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 50Pc2xMZMyToIlKb29743pUz29OmzvgT
X-Proofpoint-GUID: ET112MBztjzUZSvAB6cDzfss0X9BFvg0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270082
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 14:14, Claudio Imbrenda wrote:
> On Thu, 10 Mar 2022 10:31:09 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Sometimes dumping inside of a VM fails, is unavailable or doesn't
>> yield the required data. For these occasions we dump the VM from the
>> outside, writing memory and cpu data to a file.
>>
>> Up to now PV guests only supported dumping from the inside of the
>> guest through dumpers like KDUMP. A PV guest can be dumped from the
>> hypervisor but the data will be stale and / or encrypted.
>>
>> To get the actual state of the PV VM we need the help of the
>> Ultravisor who safeguards the VM state. New UV calls have been added
>> to initialize the dump, dump storage state data, dump cpu data and
>> complete the dump process. We expose these calls in this patch via a
>> new UV ioctl command.
>>
>> The sensitive parts of the dump data are encrypted, the dump key is
>> derived from the Customer Communication Key (CCK). This ensures that
>> only the owner of the VM who has the CCK can decrypt the dump data.
>>
>> The memory is dumped / read via a normal export call and a re-import
>> after the dump initialization is not needed (no re-encryption with a
>> dump key).
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |   1 +
>>   arch/s390/kvm/kvm-s390.c         | 137 +++++++++++++++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.h         |   2 +
>>   arch/s390/kvm/pv.c               | 115 ++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h         |  15 ++++
>>   5 files changed, 270 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index a22c9266ea05..659bf4be6f04 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -921,6 +921,7 @@ struct kvm_s390_pv {
>>   	u64 guest_len;
>>   	unsigned long stor_base;
>>   	void *stor_var;
>> +	bool dumping;
>>   };
>>   
>>   struct kvm_arch{
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index c388d08b9626..817e18c4244d 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -606,6 +606,26 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_S390_PROTECTED:
>>   		r = is_prot_virt_host();
>>   		break;
>> +	case KVM_CAP_S390_PROTECTED_DUMP: {
>> +		u64 pv_cmds_dump[] = {
>> +			BIT_UVC_CMD_DUMP_INIT,
>> +			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
>> +			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
> 
> you have this twice ^

Yup, will fix

> 
>> +			BIT_UVC_CMD_DUMP_CPU,
>> +		};
>> +		int i;
>> +
>> +		if (!is_prot_virt_host())
>> +			return 0;
>> +
>> +		r = 1;
>> +		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
>> +			if (!test_bit_inv(pv_cmds_dump[i],
>> +					  (unsigned long *)&uv_info.inst_calls_list))
>> +				return 0;
>> +		}
>> +		break;
>> +	}
>>   	default:
>>   		r = 0;
>>   	}
>> @@ -2271,6 +2291,92 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>>   	}
>>   }
>>   
>> +static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
> 
> I am all for shortening long words, but dmp -> dump is only one extra
> byte

Sure, will fix

> 
>> +			   struct kvm_s390_pv_dmp dmp)
>> +{
>> +	int r = -EINVAL;
>> +	void __user *result_buff = (void __user *)dmp.buff_addr;
>> +
>> +	switch (dmp.subcmd) {
>> +	case KVM_PV_DUMP_INIT: {
>> +		if (kvm->arch.pv.dumping)
>> +			break;
>> +
>> +		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>> +				  UVC_CMD_DUMP_INIT, &cmd->rc, &cmd->rrc);
>> +		KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP INIT: rc %x rrc %x",
>> +			     cmd->rc, cmd->rrc);
>> +		if (!r)
>> +			kvm->arch.pv.dumping = true;
> 
> so at this point no guest CPUs should be running, right?
> below you add a check to prevent guest CPUs from being dispatched if we
> are in dump mode.
> 
> are there any checks to make sure all guest CPUs are stopped when
> issuing this command? could a guest CPU be running while this command
> is issued?

Seems like I have made changes to this but didn't send them yet.
There'll be a vcpu block before the init uv call.
The unblock will be done after the dump completion.

> 
>> +		else
>> +			r = -EINVAL;
>> +		break;
>> +	}
>> +	case KVM_PV_DUMP_CONFIG_STOR_STATE: {
>> +		if (!kvm->arch.pv.dumping)
>> +			break;
>> +
>> +		/*
>> +		 * GADDR is an output parameter since we might stop
> 
> why uppercase?

Will fix

[...]
>> +/*
>> + * kvm_s390_pv_dump_stor_state
>> + *
>> + * @kvm: pointer to the guest's KVM struct
>> + * @buff_user: Userspace pointer where we will write the results to
>> + * @gaddr: Starting absolute guest address for which the storage state
>> + *         is requested. This value will be updated with the last
>> + *         address for which data was written when returning to
>> + *         userspace.
>> + * @buff_user_len: Length of the buff_user buffer
>> + * @rc: Pointer to where the uvcb return code is stored
>> + * @rrc: Pointer to where the uvcb return reason code is stored
>> + *
>> + * Return:
>> + *  0 on success
>> + *  -ENOMEM if allocating the cache fails
>> + *  -EINVAL if gaddr is not aligned to 1MB
>> + *  -EINVAL if buff_user_len is not aligned to uv_info.conf_dump_storage_state_len
>> + *  -EINVAL if the UV call fails, rc and rrc will be set in this case
>> + *  -EFAULT if copying the result to buff_user failed
>> + */
>> +int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
>> +				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc)
>> +{
>> +	struct uv_cb_dump_stor_state uvcb = {
>> +		.header.cmd = UVC_CMD_DUMP_CONF_STOR_STATE,
>> +		.header.len = sizeof(uvcb),
>> +		.config_handle = kvm->arch.pv.handle,
>> +		.gaddr = *gaddr,
>> +		.dump_area_origin = 0,
>> +	};
>> +	size_t buff_kvm_size;
>> +	size_t size_done = 0;
>> +	u8 *buff_kvm = NULL;
>> +	int cc, ret;
>> +
>> +	ret = -EINVAL;
>> +	/* UV call processes 1MB guest storage chunks at a time */
>> +	if (*gaddr & ~HPAGE_MASK)
>> +		goto out;
> 
> so we only allow userspace to use starting addresses that are 1M
> aligned...

We're speaking about G2A addresses here...

> 
>> +
>> +	/*
>> +	 * We provide the storage state for 1MB chunks of guest
>> +	 * storage. The buffer will need to be aligned to
>> +	 * conf_dump_storage_state_len so we don't end on a partial
>> +	 * chunk.
>> +	 */
>> +	if (!buff_user_len ||
>> +	    buff_user_len & (uv_info.conf_dump_storage_state_len - 1))
>> +		goto out;
>> +
>> +	/*
>> +	 * Allocate a buffer from which we will later copy to the user process.
>> +	 *
>> +	 * We don't want userspace to dictate our buffer size so we limit it to DUMP_BUFF_LEN.
>> +	 */
>> +	ret = -ENOMEM;
>> +	buff_kvm_size = buff_user_len <= DUMP_BUFF_LEN ? buff_user_len : DUMP_BUFF_LEN;
> 
> ... and we allow the length to be less than 1M
> 
> meaning that userspace can request a small chunk, but won't be able to
> continue, it will have to request the chunk again with a larger buffer
> size if it wants to do any forward progess, is this correct?

...while buff_user and buff_user_len are QEMU G1V addresses.
1 page in the user buffer currently equals a megabyte of G2 storage state.

That's the UV API. You request the storage state (i.e. storage metadata 
needed for the decryption) for 1MB worth of guest 2 storage. The UV will 
write the metadata to a kernel buffer so we're basically only proxying.


> 
>> +	buff_kvm = vzalloc(buff_kvm_size);
>> +	if (!buff_kvm)
>> +		goto out;
>> +
>> +	ret = 0;
>> +	uvcb.dump_area_origin = (u64)buff_kvm;
>> +	/* We will loop until the user buffer is filled or an error occurs */
>> +	do {
>> +		/* Get a page of data */
>> +		cc = uv_call_sched(0, (u64)&uvcb);
>> +
>> +		/* All or nothing */
>> +		if (cc) {
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +
>> +		size_done += uv_info.conf_dump_storage_state_len;
>> +		uvcb.dump_area_origin += uv_info.conf_dump_storage_state_len;
>> +		uvcb.gaddr += HPAGE_SIZE;
>> +		buff_user_len -= PAGE_SIZE;
> 
> shouldn't this be HPAGE_SIZE ^ ?
> 
> what happens if buff_user_len is > 1M but not 1M aligned?

See above

> 
>> +
>> +		/* KVM Buffer full, time to copy to the process */
>> +		if (!buff_user_len ||
>> +		    uvcb.dump_area_origin == (uintptr_t)buff_kvm + buff_kvm_size) {
> 
> can't you use size_done here ? ^
> 
>> +
>> +			if (copy_to_user(buff_user, buff_kvm,
>> +					 uvcb.dump_area_origin - (uintptr_t)buff_kvm)) {
>> +				ret = -EFAULT;
>> +				break;
>> +			}
>> +
>> +			buff_user += size_done;
>> +			size_done = 0;
>> +			uvcb.dump_area_origin = (u64)buff_kvm;
>> +		}
>> +	} while (buff_user_len);
>> +
>> +	/* Report back where we ended dumping */
>> +	*gaddr = uvcb.gaddr;
>> +
>> +	/* Lets only log errors, we don't want to spam */
>> +out:
>> +	if (ret)
>> +		KVM_UV_EVENT(kvm, 3,
>> +			     "PROTVIRT DUMP STORAGE STATE: addr %llx ret %d, uvcb rc %x rrc %x",
>> +			     uvcb.gaddr, ret, uvcb.header.rc, uvcb.header.rrc);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	vfree(buff_kvm);
>> +
>> +	return ret;
>> +}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index eed2ae8397ae..6808ea0be648 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1643,6 +1643,20 @@ struct kvm_s390_pv_unp {
>>   	__u64 tweak;
>>   };
>>   
>> +enum pv_cmd_dmp_id {
>> +	KVM_PV_DUMP_INIT,
>> +	KVM_PV_DUMP_CONFIG_STOR_STATE,
>> +	KVM_PV_DUMP_COMPLETE,
>> +};
>> +
>> +struct kvm_s390_pv_dmp {
>> +	__u64 subcmd;
>> +	__u64 buff_addr;
>> +	__u64 buff_len;
>> +	__u64 gaddr;		/* For dump storage state */
>> +	__u64 reserved[4];
>> +};
>> +
>>   enum pv_cmd_info_id {
>>   	KVM_PV_INFO_VM,
>>   	KVM_PV_INFO_DUMP,
>> @@ -1686,6 +1700,7 @@ enum pv_cmd_id {
>>   	KVM_PV_PREP_RESET,
>>   	KVM_PV_UNSHARE_ALL,
>>   	KVM_PV_INFO,
>> +	KVM_PV_DUMP,
>>   };
>>   
>>   struct kvm_pv_cmd {
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9259152A39F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbiEQNjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240590AbiEQNjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:39:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C43D4CD68;
        Tue, 17 May 2022 06:39:21 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HDCfnC009438;
        Tue, 17 May 2022 13:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=380nLtz/2FKaZAkJ9R6yKII2gnhuoG3AUjP83YB/ihg=;
 b=EbiknmA/nX9lpXEISZwsgl5Y9nXkGXWqlx3f93pgYdVpLxclNeJa+jc+S8SKNauJBv+v
 4fGH0BcKuPzGcUGewzW8gTCN8tbMMx/o4L5GPrc0YAeIyUEDK3i30N1NKYcFV1DqrXgJ
 W5kXY5KzycZh7oz+uTq05rYCK4WVMF+R+CgHxO7S3utKUbGFzZhqvMhoukoj+z6iYnI+
 nUOigYrdZJvj/iF2TXUcYMRQamHkGSb1c1nTJQpHTQrlGAZ760jXXixbiHMtRQzo1kHp
 7ATnz++3sv7RBvF+7hbbpxc0p/YWNkAjfnfy8PVfERiTxZZbWT2GRE5z3pBD/Ca83S7Y zQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4cd18p96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 13:39:21 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HDWsxQ005114;
        Tue, 17 May 2022 13:39:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428uepv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 13:39:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HDdFoi55247294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 13:39:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8321DA404D;
        Tue, 17 May 2022 13:39:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 508C3A4051;
        Tue, 17 May 2022 13:39:15 +0000 (GMT)
Received: from [9.145.157.61] (unknown [9.145.157.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 13:39:15 +0000 (GMT)
Message-ID: <f8132cf7-9249-75b8-059d-fa1031973beb@linux.ibm.com>
Date:   Tue, 17 May 2022 15:39:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
 <20220516090817.1110090-7-frankja@linux.ibm.com>
 <20220517125907.685ffe44@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v5 06/10] kvm: s390: Add configuration dump functionality
In-Reply-To: <20220517125907.685ffe44@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T_dguJIhtsGATM8UmLIe_lCd3ocEmkOW
X-Proofpoint-GUID: T_dguJIhtsGATM8UmLIe_lCd3ocEmkOW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170083
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 12:59, Claudio Imbrenda wrote:
> On Mon, 16 May 2022 09:08:13 +0000
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

The cut code will be fixed according to your requests.

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
> 
> please add:
> 	Context: kvm->lock needs to be held

Sure

> 
> also explain that part of the user buffer might be written to even in
> case of failure (this also needs to go in the documentation)

Ok

> 
>> + * Return:
>> + *  0 on success
> 
> rc and rrc will also be set in case of success

But that's different from the return code of this function and would 
belong to the function description above, no?

> 
>> + *  -ENOMEM if allocating the cache fails
>> + *  -EINVAL if gaddr is not aligned to 1MB
>> + *  -EINVAL if buff_user_len is not aligned to uv_info.conf_dump_storage_state_len
>> + *  -EINVAL if the UV call fails, rc and rrc will be set in this case
> 
> have you considered a different code for UVC failure?
> so the caller can know that rc and rrc are meaningful
> 
> or just explain that rc and rrc will always be set; if the UVC is not
> performed, rc and rrc will be 0

If the UVC is not performed the rcs will not be *changed*, so it's 
advisable to set them to 0 to recognize a change.


Also:
While I generally like commenting as much as possible, this is starting 
to get out of hand, the comment header is now taking up a lot of space. 
I'll put the rc/rrc comment into the api documentation and I'm 
considering putting the partial write comment into there too.

> 
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
>> +	if (!IS_ALIGNED(*gaddr, HPAGE_SIZE))
>> +		goto out;
>> +
>> +	/*
>> +	 * We provide the storage state for 1MB chunks of guest
>> +	 * storage. The buffer will need to be aligned to
>> +	 * conf_dump_storage_state_len so we don't end on a partial
>> +	 * chunk.
>> +	 */
>> +	if (!buff_user_len ||
>> +	    !IS_ALIGNED(buff_user_len, uv_info.conf_dump_storage_state_len))
>> +		goto out;
>> +
>> +	/*
>> +	 * Allocate a buffer from which we will later copy to the user
>> +	 * process. We don't want userspace to dictate our buffer size
>> +	 * so we limit it to DUMP_BUFF_LEN.
>> +	 */
>> +	ret = -ENOMEM;
>> +	buff_kvm_size = min_t(u64, buff_user_len, DUMP_BUFF_LEN);
>> +	buff_kvm = vzalloc(buff_kvm_size);
>> +	if (!buff_kvm)
>> +		goto out;
>> +
>> +	ret = 0;
>> +	uvcb.dump_area_origin = (u64)buff_kvm;
>> +	/* We will loop until the user buffer is filled or an error occurs */
>> +	do {
>> +		/* Get 1MB worth of guest storage state data */
>> +		cc = uv_call_sched(0, (u64)&uvcb);
>> +
>> +		/* All or nothing */
>> +		if (cc) {
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +
>> +		size_done += uv_info.conf_dump_storage_state_len;
> 
> maybe save this in a local const variable with a shorter name? would be
> more readable? const u64 dump_len = uv_info.conf_dump_storage_state_len;
> 
>> +		uvcb.dump_area_origin += uv_info.conf_dump_storage_state_len;
>> +		buff_user_len -= uv_info.conf_dump_storage_state_len;
>> +		uvcb.gaddr += HPAGE_SIZE;
>> +
>> +		/* KVM Buffer full, time to copy to the process */
>> +		if (!buff_user_len || size_done == DUMP_BUFF_LEN) {
>> +			if (copy_to_user(buff_user, buff_kvm, size_done)) {
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
>> index bb2f91bc2305..1c60c2d314ba 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1653,6 +1653,20 @@ struct kvm_s390_pv_unp {
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
>> @@ -1696,6 +1710,7 @@ enum pv_cmd_id {
>>   	KVM_PV_PREP_RESET,
>>   	KVM_PV_UNSHARE_ALL,
>>   	KVM_PV_INFO,
>> +	KVM_PV_DUMP,
>>   };
>>   
>>   struct kvm_pv_cmd {
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9FD521CC4
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345070AbiEJOtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 10:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiEJOtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 10:49:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120CC6BFC6;
        Tue, 10 May 2022 07:07:54 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ADi9Dj029294;
        Tue, 10 May 2022 14:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XgdopWWo5YH8scmeOxinCb9Puoey9qeUs3YtaLtjB5k=;
 b=dBfb5mnTNJb6M1zZPDxctuwuNk7lpRGGhIoC69iqaHpbKUpdUkWSikv8AxARngfU1jeC
 LaRTOB4Q0bG5yYhlPOU+VNNLbl2sFHoG0BVBCb28pztcPu4i7TshTPMlF9D0uji7PnMN
 okxwiKSwCNZhjOc65DEjgWTK3C14Mcgvb1RDkFbTw3f0E0+lGhzuF8x26dmE2QPwDB1t
 wwuB1r5ZarMUOqHQ+1rqbTz8jbgVazoOFI4eWfp3XcpK53Jsoswz7bWoVjdmfjsGOohP
 pOlYEewk5zrJh8ndK+H1gb16z+GpgkBMwDVNkcVb5my/uQmS/HKwodvYB2R/biA0z/Pw rw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyqhq37rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 14:07:53 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AE03w0004312;
        Tue, 10 May 2022 14:07:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3fwgd8u8g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 14:07:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AE7lUd42992102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 14:07:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C513BA4060;
        Tue, 10 May 2022 14:07:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C795A405B;
        Tue, 10 May 2022 14:07:47 +0000 (GMT)
Received: from [9.145.38.155] (unknown [9.145.38.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 14:07:47 +0000 (GMT)
Message-ID: <0d503ca0-689b-3779-4708-c06fec3ccd44@linux.ibm.com>
Date:   Tue, 10 May 2022 16:07:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
References: <20220428130102.230790-1-frankja@linux.ibm.com>
 <20220428130102.230790-7-frankja@linux.ibm.com>
 <20220509195135.3f04343f@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 6/9] kvm: s390: Add configuration dump functionality
In-Reply-To: <20220509195135.3f04343f@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cyk5PQONA_Bm5Zx5nJOrv3WGUFWBhPWM
X-Proofpoint-ORIG-GUID: Cyk5PQONA_Bm5Zx5nJOrv3WGUFWBhPWM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205100065
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/22 19:51, Claudio Imbrenda wrote:
> On Thu, 28 Apr 2022 13:00:59 +0000
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
[...]
>> +/*
>> + * kvm_s390_pv_dump_stor_state
>> + *
>> + * @kvm: pointer to the guest's KVM struct
>> + * @buff_user: Userspace pointer where we will write the results to
>> + * @gaddr: Starting absolute guest address for which the storage
>> state
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
>> + *  -EINVAL if buff_user_len is not aligned to
>> uv_info.conf_dump_storage_state_len
>> + *  -EINVAL if the UV call fails, rc and rrc will be set in this case
>> + *  -EFAULT if copying the result to buff_user failed
>> + */
>> +int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user
>> *buff_user,
>> +				u64 *gaddr, u64 buff_user_len, u16
>> *rc, u16 *rrc) +{
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
>> +
>> +	/*
>> +	 * We provide the storage state for 1MB chunks of guest
>> +	 * storage. The buffer will need to be aligned to
>> +	 * conf_dump_storage_state_len so we don't end on a partial
>> +	 * chunk.
>> +	 */
>> +	if (!buff_user_len ||
>> +	    buff_user_len & (uv_info.conf_dump_storage_state_len -
>> 1))
> 
> why not use the IS_ALIGNED macro?

Habits.
I'll fix this one and the one above.

> 
>> +		goto out;
>> +
>> +	/*
>> +	 * Allocate a buffer from which we will later copy to the user process.
>> +	 *
>> +	 * We don't want userspace to dictate our buffer size so we limit it to DUMP_BUFF_LEN.
>> +	 */
>> +	ret = -ENOMEM;
>> +	buff_kvm_size = buff_user_len <= DUMP_BUFF_LEN ? buff_user_len : DUMP_BUFF_LEN;

This will be converted to min() to make it more readable.

>> +	buff_kvm = vzalloc(buff_kvm_size);
>> +	if (!buff_kvm)
>> +		goto out;
>> +
>> +	ret = 0;
>> +	uvcb.dump_area_origin = (u64)buff_kvm;
>> +	/* We will loop until the user buffer is filled or an error occurs */
>> +	do {
>> +		/* Get a page of data */
> 
> are you getting a page or a block of size conf_dump_storage_state_len ?

Will be changed to:
/* Get 1MB worth of guest storage state data */


I think that comment has historical reasons, we once discussed to always 
write one page instead of the "one 1MB worth of guest storage state".

> 
>> +		cc = uv_call_sched(0, (u64)&uvcb);
>> +
>> +		/* All or nothing */
>> +		if (cc) {
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +
>> +		size_done += uv_info.conf_dump_storage_state_len;
>> +		uvcb.dump_area_origin +=
>> uv_info.conf_dump_storage_state_len;
>> +		uvcb.gaddr += HPAGE_SIZE;
>> +		buff_user_len -= PAGE_SIZE;
> 
> same here ^ (should it be -= uv_info.conf_dump_storage_state_len ?)

Yes

> 
>> +
>> +		/* KVM Buffer full, time to copy to the process */
>> +		if (!buff_user_len ||
>> +		    uvcb.dump_area_origin == (uintptr_t)buff_kvm +
>> buff_kvm_size) { +
> 
> why not  ... || size_done == DUMP_BUFF_LEN ?
> 
>> +			if (copy_to_user(buff_user, buff_kvm,
>> +					 uvcb.dump_area_origin -
>> (uintptr_t)buff_kvm)) {
> 
> aren't you trying to copy size_done bytes?
> 
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
>> +			     "PROTVIRT DUMP STORAGE STATE: addr %llx
>> ret %d, uvcb rc %x rrc %x",
>> +			     uvcb.gaddr, ret, uvcb.header.rc,
>> uvcb.header.rrc);
>> +	*rc = uvcb.header.rc;
>> +	*rrc = uvcb.header.rrc;
>> +	vfree(buff_kvm);
>> +
>> +	return ret;
>> +}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 2eba89d7ec29..b34850907291 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1645,6 +1645,20 @@ struct kvm_s390_pv_unp {
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
>> @@ -1688,6 +1702,7 @@ enum pv_cmd_id {
>>   	KVM_PV_PREP_RESET,
>>   	KVM_PV_UNSHARE_ALL,
>>   	KVM_PV_INFO,
>> +	KVM_PV_DUMP,
>>   };
>>   
>>   struct kvm_pv_cmd {
> 


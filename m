Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C344D7FF0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 11:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiCNKf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 06:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiCNKfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 06:35:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01818275E8;
        Mon, 14 Mar 2022 03:34:45 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22E8WI8V019284;
        Mon, 14 Mar 2022 10:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tcfu5MGNXQLmRhnrj0ViqZIGQnW9H+Y9XMCycdN66p8=;
 b=Lok6JcLV7jzIygsZTzVxR7v+fxx22TRitvLbwH+lFEBI9xOD4Rc8N29jbv5n5PnGBvHr
 pIrdDqWL2WxVj4EiWRW/seVNpwmkiBR5BmgV5ikQwT0H1jT0SdJAJ69MhdTSgcSnj7If
 1LC3amBEXpYCqtdm9yS8tC4TPih8A75t6UutHtfxLOn6w9JMQPfOSesbhK95m3vctpOu
 fJaKThLHyIq5CRf8tj8IR0xg6Jjk0xmvCYk08lWObQkgW3EinJKwULIw+B/AMN0k5USO
 iGJtqYkrLSC8DV08jtaiBsu1j/30tW7klhbIkuxhZlKWShHusTF07nH38Jb90OUh8sm/ Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3es53qqjeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:34:45 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EAQGq0017601;
        Mon, 14 Mar 2022 10:34:45 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3es53qqje4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:34:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EAX7hn012923;
        Mon, 14 Mar 2022 10:34:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3erjshkcf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:34:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EAYcGM55378338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 10:34:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D499CA4846;
        Mon, 14 Mar 2022 10:34:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C585A4844;
        Mon, 14 Mar 2022 10:34:38 +0000 (GMT)
Received: from [9.145.181.26] (unknown [9.145.181.26])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 10:34:38 +0000 (GMT)
Message-ID: <0cb6bfd9-10c7-a9ec-6473-bb25c37fb91c@linux.ibm.com>
Date:   Mon, 14 Mar 2022 11:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 3/9] KVM: s390: pv: Add query interface
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
References: <20220310103112.2156-1-frankja@linux.ibm.com>
 <20220310103112.2156-4-frankja@linux.ibm.com>
 <20220311184059.25161d62@p-imbrenda>
 <0a39b94c-db5e-a8cc-b84b-ae17559f1091@linux.ibm.com>
 <20220314111718.2509a093@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220314111718.2509a093@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7I0TMGbqGJkJV_-8ZZFlm04PVD4ksm6B
X-Proofpoint-ORIG-GUID: ArTNi7yB5QMbTpt5LtJ6pdbwA_9UyIn4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_04,2022-03-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 11:17, Claudio Imbrenda wrote:
> On Mon, 14 Mar 2022 11:02:40 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 3/11/22 18:40, Claudio Imbrenda wrote:
>>> On Thu, 10 Mar 2022 10:31:06 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>    
>>>> Some of the query information is already available via sysfs but
>>>> having a IOCTL makes the information easier to retrieve.
>>>
>>> if I understand correctly, this will be forward-compatible but not
>>> backwards compatible.
>>>
>>> you return the amount of bytes written into the buffer, but only if the
>>> buffer was already big enough.
>>>
>>> a newer userspace will work with an older kernel, but an older
>>> userspace will not work with a newer kernel.
>>
>> I expect the first version of userspace to request a minimum length
>> hence I return -EINVAL if less space is given.
> 
> this makes sense
> 
>>
>> In the future the minimum will be a constant and we'll write between the
>> min and the new data length.
> 
> fair enough, but this means that future patches must be careful and not
> forget this.

Sure, I'll find a way to make this clearer.

> 
> it's probably easier to read, and more future proof, if you put a check
> for the minimum size (and perhaps also a comment to explain why), and
> not use sizeof(struct ...)
> 
>>
>> IMHO there's no sense in allowing to request less data than the v1 of
>> the interface will provide.
> 
> of course
> 
>>
>>
>>>
>>> a solution would be to return the size of the struct, so userspace can
>>> know how much of the buffer was written (if it was bigger than the
>>> struct), or that there are unwritten bits (if the buffer was smaller).
>>>
>>> and even if the buffer was too small, write back as much of it as
>>> possible to userspace.
>>>
>>> this way, an older userspace will get the information it expects.
>>>
>>>
>>> I am also not a big fan of writing the size in the input struct (I think
>>> returning it would be cleaner), but I do not have a strong opinion
>>>    
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
>>>>    include/uapi/linux/kvm.h | 25 +++++++++++++
>>>>    2 files changed, 101 insertions(+)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 020356653d1a..67e1e445681f 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -2224,6 +2224,42 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>>>>    	return r;
>>>>    }
>>>>    
>>>> +/*
>>>> + * Here we provide user space with a direct interface to query UV
>>>> + * related data like UV maxima and available features as well as
>>>> + * feature specific data.
>>>> + *
>>>> + * To facilitate future extension of the data structures we'll try to
>>>> + * write data up to the maximum requested length.
>>>> + */
>>>> +static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>>>> +{
>>>> +	ssize_t len;
>>>> +
>>>> +	switch (info->header.id) {
>>>> +	case KVM_PV_INFO_VM: {
>>>> +		len =  sizeof(info->header) + sizeof(info->vm);
>>>> +
>>>> +		if (info->header.len_max < len)
>>>> +			return -EINVAL;
>>>> +
>>>> +		memcpy(info->vm.inst_calls_list,
>>>> +		       uv_info.inst_calls_list,
>>>> +		       sizeof(uv_info.inst_calls_list));
>>>> +
>>>> +		/* It's max cpuidm not max cpus so it's off by one */
>>>> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
>>>> +		info->vm.max_guests = uv_info.max_num_sec_conf;
>>>> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
>>>> +		info->vm.feature_indication = uv_info.uv_feature_indications;
>>>> +
>>>> +		return len;
>>>> +	}
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +}
>>>> +
>>>>    static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>>>    {
>>>>    	int r = 0;
>>>> @@ -2360,6 +2396,46 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>>>    			     cmd->rc, cmd->rrc);
>>>>    		break;
>>>>    	}
>>>> +	case KVM_PV_INFO: {
>>>> +		struct kvm_s390_pv_info info = {};
>>>> +		ssize_t data_len;
>>>> +
>>>> +		/*
>>>> +		 * No need to check the VM protection here.
>>>> +		 *
>>>> +		 * Maybe user space wants to query some of the data
>>>> +		 * when the VM is still unprotected. If we see the
>>>> +		 * need to fence a new data command we can still
>>>> +		 * return an error in the info handler.
>>>> +		 */
>>>> +
>>>> +		r = -EFAULT;
>>>> +		if (copy_from_user(&info, argp, sizeof(info.header)))
>>>> +			break;
>>>> +
>>>> +		r = -EINVAL;
>>>> +		if (info.header.len_max < sizeof(info.header))
>>>> +			break;
>>>> +
>>>> +		data_len = kvm_s390_handle_pv_info(&info);
>>>> +		if (data_len < 0) {
>>>> +			r = data_len;
>>>> +			break;
>>>> +		}
>>>> +		/*
>>>> +		 * If a data command struct is extended (multiple
>>>> +		 * times) this can be used to determine how much of it
>>>> +		 * is valid.
>>>> +		 */
>>>> +		info.header.len_written = data_len;
>>>> +
>>>> +		r = -EFAULT;
>>>> +		if (copy_to_user(argp, &info, data_len))
>>>> +			break;
>>>> +
>>>> +		r = 0;
>>>> +		break;
>>>> +	}
>>>>    	default:
>>>>    		r = -ENOTTY;
>>>>    	}
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index a02bbf8fd0f6..21f19863c417 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -1643,6 +1643,30 @@ struct kvm_s390_pv_unp {
>>>>    	__u64 tweak;
>>>>    };
>>>>    
>>>> +enum pv_cmd_info_id {
>>>> +	KVM_PV_INFO_VM,
>>>> +};
>>>> +
>>>> +struct kvm_s390_pv_info_vm {
>>>> +	__u64 inst_calls_list[4];
>>>> +	__u64 max_cpus;
>>>> +	__u64 max_guests;
>>>> +	__u64 max_guest_addr;
>>>> +	__u64 feature_indication;
>>>> +};
>>>> +
>>>> +struct kvm_s390_pv_info_header {
>>>> +	__u32 id;
>>>> +	__u32 len_max;
>>>> +	__u32 len_written;
>>>> +	__u32 reserved;
>>>> +};
>>>> +
>>>> +struct kvm_s390_pv_info {
>>>> +	struct kvm_s390_pv_info_header header;
>>>> +	struct kvm_s390_pv_info_vm vm;
>>>> +};
>>>> +
>>>>    enum pv_cmd_id {
>>>>    	KVM_PV_ENABLE,
>>>>    	KVM_PV_DISABLE,
>>>> @@ -1651,6 +1675,7 @@ enum pv_cmd_id {
>>>>    	KVM_PV_VERIFY,
>>>>    	KVM_PV_PREP_RESET,
>>>>    	KVM_PV_UNSHARE_ALL,
>>>> +	KVM_PV_INFO,
>>>>    };
>>>>    
>>>>    struct kvm_pv_cmd {
>>>    
>>
> 


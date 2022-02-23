Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA84C131F
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbiBWMsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240586AbiBWMsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:48:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244B8A66C1;
        Wed, 23 Feb 2022 04:47:48 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NAYfQI026211;
        Wed, 23 Feb 2022 12:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cY60YIrh2mUl5vRn/ojR87bcyLOvTOaTLk+Rze0iK/I=;
 b=NiqeQ83kVF1ctdjN1SKrKRodVqxd8mLmiDsmf9Uhs9n0RtaSmRtOziNzl+XrCMOjokyc
 l21/pLlG95i62oJ3dqCEewy8FiLH5u+I5Jke2YkVfGVVNc3+YD6Pg4GL8jnbQ7AOt1BX
 XwvJCl1ssp+7NAr3j3Uorp95pqejM3fQ+pGEQEQp/KBcLm028KcWctMixN+cqPDssR+9
 nnGFFuFaGKwk9Bwq2ApVEl9QH23nDGH4/L+yw6xcr2r+YcEiSNR6JDoMJqWzUKn84M9I
 zP+RfuS+itS34fbBB7q496DkzPPIWNxWqEHXUT1AWiPqFpsnpRpsccP00oVrea2WQwTr NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct71xn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 12:47:47 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NCFI6V009581;
        Wed, 23 Feb 2022 12:47:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct71xmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 12:47:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NCh2uD018262;
        Wed, 23 Feb 2022 12:47:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear698bwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 12:47:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NClfjj40567116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 12:47:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82B4611C05B;
        Wed, 23 Feb 2022 12:47:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1650611C04C;
        Wed, 23 Feb 2022 12:47:41 +0000 (GMT)
Received: from [9.145.59.38] (unknown [9.145.59.38])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 12:47:41 +0000 (GMT)
Message-ID: <e1d6c8b8-9502-b67d-66cd-d4c283122f39@linux.ibm.com>
Date:   Wed, 23 Feb 2022 13:47:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220223092007.3163-1-frankja@linux.ibm.com>
 <20220223092007.3163-4-frankja@linux.ibm.com>
 <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
In-Reply-To: <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8GPXGT9cr6ecpITtqiVK72kjRRtyKGbf
X-Proofpoint-GUID: BP8uOrienpeAVewXifqefzCDmA0jucZX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 12:30, Thomas Huth wrote:
> On 23/02/2022 10.20, Janosch Frank wrote:
>> Some of the query information is already available via sysfs but
>> having a IOCTL makes the information easier to retrieve.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
>>    include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
>>    2 files changed, 70 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index faa85397b6fb..837f898ad2ff 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>>    	return r;
>>    }
>>    
>> +static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>> +{
>> +	u32 len;
>> +
>> +	switch (info->header.id) {
>> +	case KVM_PV_INFO_VM: {
>> +		len =  sizeof(info->header) + sizeof(info->vm);
>> +
>> +		if (info->header.len < len)
>> +			return -EINVAL;
>> +
>> +		memcpy(info->vm.inst_calls_list,
>> +		       uv_info.inst_calls_list,
>> +		       sizeof(uv_info.inst_calls_list));
>> +
>> +		/* It's max cpuidm not max cpus so it's off by one */
>> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
>> +		info->vm.max_guests = uv_info.max_num_sec_conf;
>> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
>> +		info->vm.feature_indication = uv_info.uv_feature_indications;
>> +
>> +		return 0;
>> +	}
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>    static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>    {
>>    	int r = 0;
>> @@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>    			     cmd->rc, cmd->rrc);
>>    		break;
>>    	}
>> +	case KVM_PV_INFO: {
>> +		struct kvm_s390_pv_info info = {};
>> +
>> +		if (copy_from_user(&info, argp, sizeof(info.header)))
>> +			return -EFAULT;
>> +
>> +		if (info.header.len < sizeof(info.header))
>> +			return -EINVAL;
>> +
>> +		r = kvm_s390_handle_pv_info(&info);
>> +		if (r)
>> +			return r;
>> +
>> +		r = copy_to_user(argp, &info, sizeof(info));
> 
> sizeof(info) is currently OK ... but this might break if somebody later
> extends the kvm_s390_pv_info struct, I guess? ==> Maybe also better use
> sizeof(info->header) + sizeof(info->vm) here, too? Or let
> kvm_s390_handle_pv_info() return the amount of bytes that should be copied here?

I'll have to take another look at this for multiple reasons.
Maybe we'll use the same semantics as the UV QUI command.

> 
>    Thomas
> 
> 
>> +		if (r)
>> +			return -EFAULT;
>> +		return 0;
>> +	}
>>    	default:
>>    		r = -ENOTTY;
>>    	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index dbc550bbd9fa..96fceb204a92 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
>>    	__u64 tweak;
>>    };
>>    
>> +enum pv_cmd_info_id {
>> +	KVM_PV_INFO_VM,
>> +};
>> +
>> +struct kvm_s390_pv_info_vm {
>> +	__u64 inst_calls_list[4];
>> +	__u64 max_cpus;
>> +	__u64 max_guests;
>> +	__u64 max_guest_addr;
>> +	__u64 feature_indication;
>> +};
>> +
>> +struct kvm_s390_pv_info_header {
>> +	__u32 id;
>> +	__u32 len;
>> +};
>> +
>> +struct kvm_s390_pv_info {
>> +	struct kvm_s390_pv_info_header header;
>> +	struct kvm_s390_pv_info_vm vm;
>> +};
>> +
>>    enum pv_cmd_id {
>>    	KVM_PV_ENABLE,
>>    	KVM_PV_DISABLE,
>> @@ -1650,6 +1672,7 @@ enum pv_cmd_id {
>>    	KVM_PV_VERIFY,
>>    	KVM_PV_PREP_RESET,
>>    	KVM_PV_UNSHARE_ALL,
>> +	KVM_PV_INFO,
>>    };
>>    
>>    struct kvm_pv_cmd {
> 


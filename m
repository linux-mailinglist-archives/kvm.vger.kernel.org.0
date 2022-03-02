Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB04D4CA03F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 10:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiCBJER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 04:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbiCBJEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 04:04:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C127CFD;
        Wed,  2 Mar 2022 01:03:26 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2227lWsJ016734;
        Wed, 2 Mar 2022 09:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HfpY3h/nGZl7bosmlI2EtRW7xvjB7/rtZiP7zmIJBzg=;
 b=JWfm2r0kCTF5ph034uM59LOKHxZKRXCsbpXQ9EYtlELkyXCaVPi/R/6q0mNbCiZIvIO6
 x8s+78Geo3aIWgAXYUmGFiVI8jYrG9h3gXE+IG2SyKypAqHT48ygUxNKHXf5H4TUKh0R
 gFoR8PWaF8IHbw7Kjd2+gSP8etz7jfZdoB9nWb9/x5VZkbvZH/ywV0I1bsa71zcWMvSy
 WNdfh2HYQDosL5SwxTCdC5MoTBQP8/3MrZeHOo6r7yC7CjnlCw9Fhpy5f16sNHhzTKzE
 aEkoh3Zi218b3tVFc5GGm5Y1MuTSFS3cW+r2IUbA3cdadNdRO87cBdZ/q70xrnkVo+ih kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej4gm1dmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 09:03:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2228caYo009756;
        Wed, 2 Mar 2022 09:03:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej4gm1dkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 09:03:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22292xrK009242;
        Wed, 2 Mar 2022 09:03:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3efbu94rxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 09:03:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22293KcL52691334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 09:03:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4F9F52051;
        Wed,  2 Mar 2022 09:03:19 +0000 (GMT)
Received: from [9.145.51.38] (unknown [9.145.51.38])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8761052054;
        Wed,  2 Mar 2022 09:03:19 +0000 (GMT)
Message-ID: <bafdc591-dbd9-57ab-136f-79aa27f982df@linux.ibm.com>
Date:   Wed, 2 Mar 2022 10:03:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
References: <20220223092007.3163-1-frankja@linux.ibm.com>
 <20220223092007.3163-4-frankja@linux.ibm.com>
 <b2fd362a-eefa-8fa7-1016-55bedd3fa6ee@redhat.com>
 <20220301183236.742e749b@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
In-Reply-To: <20220301183236.742e749b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gbV1YzdIad9DRmejXKTsdc551xeGcUkt
X-Proofpoint-ORIG-GUID: yVr6-Y4wAUvQYa_FzdVFiK1o_YeN15om
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:32, Claudio Imbrenda wrote:
> On Wed, 23 Feb 2022 12:30:36 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> On 23/02/2022 10.20, Janosch Frank wrote:
>>> Some of the query information is already available via sysfs but
>>> having a IOCTL makes the information easier to retrieve.
> 
> why not exporting this via sysfs too?
> 
> something like a sysfs file called "query_ultravisor_information_raw"
> 
> that way you don't even have a problem with sizes

I'd like to avoid having to rely on reading more files. IOCTLs are the 
most used way to communicate with KVM and don't require larger changes 
to QEMU.

This is information that's meant for the VMM so in this case KVM can 
control what it reports. If I'd add a raw interface then we can't 
control what's being passed to userspace.


Btw. the UV driver by Steffen provides raw QUI data but we can't 
guarantee that it will always be available to QEMU.

> 
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
>>>    include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
>>>    2 files changed, 70 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index faa85397b6fb..837f898ad2ff 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>>>    	return r;
>>>    }
>>>    
>>> +static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>>> +{
>>> +	u32 len;
>>> +
>>> +	switch (info->header.id) {
>>> +	case KVM_PV_INFO_VM: {
>>> +		len =  sizeof(info->header) + sizeof(info->vm);
>>> +
>>> +		if (info->header.len < len)
>>> +			return -EINVAL;
>>> +
>>> +		memcpy(info->vm.inst_calls_list,
>>> +		       uv_info.inst_calls_list,
>>> +		       sizeof(uv_info.inst_calls_list));
>>> +
>>> +		/* It's max cpuidm not max cpus so it's off by one */
>>> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
>>> +		info->vm.max_guests = uv_info.max_num_sec_conf;
>>> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
>>> +		info->vm.feature_indication = uv_info.uv_feature_indications;
>>> +
>>> +		return 0;
>>> +	}
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +}
>>> +
>>>    static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>>    {
>>>    	int r = 0;
>>> @@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>>    			     cmd->rc, cmd->rrc);
>>>    		break;
>>>    	}
>>> +	case KVM_PV_INFO: {
>>> +		struct kvm_s390_pv_info info = {};
>>> +
>>> +		if (copy_from_user(&info, argp, sizeof(info.header)))
>>> +			return -EFAULT;
>>> +
>>> +		if (info.header.len < sizeof(info.header))
>>> +			return -EINVAL;
>>> +
>>> +		r = kvm_s390_handle_pv_info(&info);
>>> +		if (r)
>>> +			return r;
>>> +
>>> +		r = copy_to_user(argp, &info, sizeof(info));
>>
>> sizeof(info) is currently OK ... but this might break if somebody later
>> extends the kvm_s390_pv_info struct, I guess? ==> Maybe also better use
>> sizeof(info->header) + sizeof(info->vm) here, too? Or let
>> kvm_s390_handle_pv_info() return the amount of bytes that should be copied here?
>>
>>    Thomas
>>
>>
>>> +		if (r)
>>> +			return -EFAULT;
>>> +		return 0;
>>> +	}
>>>    	default:
>>>    		r = -ENOTTY;
>>>    	}
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index dbc550bbd9fa..96fceb204a92 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
>>>    	__u64 tweak;
>>>    };
>>>    
>>> +enum pv_cmd_info_id {
>>> +	KVM_PV_INFO_VM,
>>> +};
>>> +
>>> +struct kvm_s390_pv_info_vm {
>>> +	__u64 inst_calls_list[4];
>>> +	__u64 max_cpus;
>>> +	__u64 max_guests;
>>> +	__u64 max_guest_addr;
>>> +	__u64 feature_indication;
>>> +};
>>> +
>>> +struct kvm_s390_pv_info_header {
>>> +	__u32 id;
>>> +	__u32 len;
>>> +};
>>> +
>>> +struct kvm_s390_pv_info {
>>> +	struct kvm_s390_pv_info_header header;
>>> +	struct kvm_s390_pv_info_vm vm;
>>> +};
>>> +
>>>    enum pv_cmd_id {
>>>    	KVM_PV_ENABLE,
>>>    	KVM_PV_DISABLE,
>>> @@ -1650,6 +1672,7 @@ enum pv_cmd_id {
>>>    	KVM_PV_VERIFY,
>>>    	KVM_PV_PREP_RESET,
>>>    	KVM_PV_UNSHARE_ALL,
>>> +	KVM_PV_INFO,
>>>    };
>>>    
>>>    struct kvm_pv_cmd {
>>
> 


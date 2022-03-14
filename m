Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2EA4D7F61
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 11:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbiCNKEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 06:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiCNKEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 06:04:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D313AEB1;
        Mon, 14 Mar 2022 03:03:01 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22E94vTA010203;
        Mon, 14 Mar 2022 10:03:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aChtE/qaugrhFXIl2pqpedUYn998D7sGnhXO/4oyv58=;
 b=GA+t90dNYotjf17I1Pt41/UbSLWYL4HHK2jW3Hadht2/HR+jmlro2plP4HkS48mgkuZ2
 b/q7OuaJvxeg7KX0iYDWFqUTuMokLR/uC3w1MQwH8avFdcOmCWpAkRQpn4toT3etvjh1
 428K8ULko7R9VHRJsSq/VsF2WhjviAY3uRY3YBo/La/aP5TYRto3i4zat6DBof3A+/Q2
 6cDQBSWzkD8lsE6fJavD51cBwzySTPlBEBVK8UijN4tKE/pBY/wOYyyZxK2XzBSWF8n6
 4jaJ/IptKGgbqFOLaOx+Y3S/SWXQYPBKWwVF7RzlxPm3wScp/hVQnDYf8MZmxl3IBBEt GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3es501evp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:03:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22E9lgiC038098;
        Mon, 14 Mar 2022 10:03:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3es501evn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:03:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22E9rApP005204;
        Mon, 14 Mar 2022 10:02:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3erk58utxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 10:02:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EA2tKS45416748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 10:02:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 746A8A4168;
        Mon, 14 Mar 2022 10:02:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41AF8A4190;
        Mon, 14 Mar 2022 10:02:41 +0000 (GMT)
Received: from [9.145.181.26] (unknown [9.145.181.26])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 10:02:41 +0000 (GMT)
Message-ID: <0a39b94c-db5e-a8cc-b84b-ae17559f1091@linux.ibm.com>
Date:   Mon, 14 Mar 2022 11:02:40 +0100
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
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220311184059.25161d62@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vcweE2HlHSvN2iAEYQwyV8uSXkyoKeSk
X-Proofpoint-ORIG-GUID: xXVuM66vRdzC1vTg4mnzbWaUbD-YRAU5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_04,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 18:40, Claudio Imbrenda wrote:
> On Thu, 10 Mar 2022 10:31:06 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Some of the query information is already available via sysfs but
>> having a IOCTL makes the information easier to retrieve.
> 
> if I understand correctly, this will be forward-compatible but not
> backwards compatible.
> 
> you return the amount of bytes written into the buffer, but only if the
> buffer was already big enough.
> 
> a newer userspace will work with an older kernel, but an older
> userspace will not work with a newer kernel.

I expect the first version of userspace to request a minimum length 
hence I return -EINVAL if less space is given.

In the future the minimum will be a constant and we'll write between the 
min and the new data length.

IMHO there's no sense in allowing to request less data than the v1 of 
the interface will provide.


> 
> a solution would be to return the size of the struct, so userspace can
> know how much of the buffer was written (if it was bigger than the
> struct), or that there are unwritten bits (if the buffer was smaller).
> 
> and even if the buffer was too small, write back as much of it as
> possible to userspace.
> 
> this way, an older userspace will get the information it expects.
> 
> 
> I am also not a big fan of writing the size in the input struct (I think
> returning it would be cleaner), but I do not have a strong opinion
> 
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h | 25 +++++++++++++
>>   2 files changed, 101 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 020356653d1a..67e1e445681f 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2224,6 +2224,42 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>>   	return r;
>>   }
>>   
>> +/*
>> + * Here we provide user space with a direct interface to query UV
>> + * related data like UV maxima and available features as well as
>> + * feature specific data.
>> + *
>> + * To facilitate future extension of the data structures we'll try to
>> + * write data up to the maximum requested length.
>> + */
>> +static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>> +{
>> +	ssize_t len;
>> +
>> +	switch (info->header.id) {
>> +	case KVM_PV_INFO_VM: {
>> +		len =  sizeof(info->header) + sizeof(info->vm);
>> +
>> +		if (info->header.len_max < len)
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
>> +		return len;
>> +	}
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>   static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>   {
>>   	int r = 0;
>> @@ -2360,6 +2396,46 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>>   			     cmd->rc, cmd->rrc);
>>   		break;
>>   	}
>> +	case KVM_PV_INFO: {
>> +		struct kvm_s390_pv_info info = {};
>> +		ssize_t data_len;
>> +
>> +		/*
>> +		 * No need to check the VM protection here.
>> +		 *
>> +		 * Maybe user space wants to query some of the data
>> +		 * when the VM is still unprotected. If we see the
>> +		 * need to fence a new data command we can still
>> +		 * return an error in the info handler.
>> +		 */
>> +
>> +		r = -EFAULT;
>> +		if (copy_from_user(&info, argp, sizeof(info.header)))
>> +			break;
>> +
>> +		r = -EINVAL;
>> +		if (info.header.len_max < sizeof(info.header))
>> +			break;
>> +
>> +		data_len = kvm_s390_handle_pv_info(&info);
>> +		if (data_len < 0) {
>> +			r = data_len;
>> +			break;
>> +		}
>> +		/*
>> +		 * If a data command struct is extended (multiple
>> +		 * times) this can be used to determine how much of it
>> +		 * is valid.
>> +		 */
>> +		info.header.len_written = data_len;
>> +
>> +		r = -EFAULT;
>> +		if (copy_to_user(argp, &info, data_len))
>> +			break;
>> +
>> +		r = 0;
>> +		break;
>> +	}
>>   	default:
>>   		r = -ENOTTY;
>>   	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index a02bbf8fd0f6..21f19863c417 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1643,6 +1643,30 @@ struct kvm_s390_pv_unp {
>>   	__u64 tweak;
>>   };
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
>> +	__u32 len_max;
>> +	__u32 len_written;
>> +	__u32 reserved;
>> +};
>> +
>> +struct kvm_s390_pv_info {
>> +	struct kvm_s390_pv_info_header header;
>> +	struct kvm_s390_pv_info_vm vm;
>> +};
>> +
>>   enum pv_cmd_id {
>>   	KVM_PV_ENABLE,
>>   	KVM_PV_DISABLE,
>> @@ -1651,6 +1675,7 @@ enum pv_cmd_id {
>>   	KVM_PV_VERIFY,
>>   	KVM_PV_PREP_RESET,
>>   	KVM_PV_UNSHARE_ALL,
>> +	KVM_PV_INFO,
>>   };
>>   
>>   struct kvm_pv_cmd {
> 


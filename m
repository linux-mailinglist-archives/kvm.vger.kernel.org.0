Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B834520E94
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiEJHh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 03:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241396AbiEJHbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 03:31:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408C245C75;
        Tue, 10 May 2022 00:27:35 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A6LpSb010145;
        Tue, 10 May 2022 07:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H8ot/ZITUFNIDJf3I2n4t65J/KIdyi8iIys0d6X5Qcs=;
 b=PtPI0ILyTQr1KC6GKRJHA9EgtW/TJ7UG2LPrh7snSP4tJIPvxlrSRUUt0tRBW/MRMfW+
 uxNL5RVubtfHldLSECOQtp5Y+qExXPP36uwuSDDrJfNEt44GrSRgKWJVYWeHwHk+sv91
 qor6wy72SwK1U38y2rFWoqKMkSjY0M1lR4G7lSy4U6TM7WBMRsCzyZk+8ZTLzxT7KlAW
 aYEpBeW5fOZPpLT0mawBBUEUUMdiOplTpvbvU+SJgzqLGCwhAce+vIFAY4lwvto0p3Sz
 2igqMOIkHS6JEpNSNTqxEsbR+Bbgh7grCP4FmH0kaFXcOZSPKHlJKedQQ5rfMYjbFbSn kA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyjqeh3hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:27:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24A7J7aA002741;
        Tue, 10 May 2022 07:27:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j3mqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:27:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24A7RTrq48824606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 07:27:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7915EA4051;
        Tue, 10 May 2022 07:27:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30150A4053;
        Tue, 10 May 2022 07:27:29 +0000 (GMT)
Received: from [9.145.53.142] (unknown [9.145.53.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 07:27:29 +0000 (GMT)
Message-ID: <d41cf210-ff83-43a1-7332-b0f00a40686c@linux.ibm.com>
Date:   Tue, 10 May 2022 09:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
References: <20220428130102.230790-1-frankja@linux.ibm.com>
 <20220428130102.230790-4-frankja@linux.ibm.com>
 <20220509172533.633a95ee@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220509172533.633a95ee@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _qXXtK8hyL_CQpk52lnow9atNr3om-jY
X-Proofpoint-ORIG-GUID: _qXXtK8hyL_CQpk52lnow9atNr3om-jY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205100028
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/22 17:25, Claudio Imbrenda wrote:
> On Thu, 28 Apr 2022 13:00:56 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Some of the query information is already available via sysfs but
>> having a IOCTL makes the information easier to retrieve.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h | 25 +++++++++++++
>>   2 files changed, 101 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 76ad6408cb2c..23352d45a386 100644
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
>> +	ssize_t len_min;
>> +
>> +	switch (info->header.id) {
>> +	case KVM_PV_INFO_VM: {
>> +		len_min =  sizeof(info->header) + sizeof(info->vm);
>> +
>> +		if (info->header.len_max < len_min)
>> +			return -EINVAL;
>> +
>> +		memcpy(info->vm.inst_calls_list,
>> +		       uv_info.inst_calls_list,
>> +		       sizeof(uv_info.inst_calls_list));
>> +
>> +		/* It's max cpuidm not max cpus so it's off by one */
> 
> s/cpuidm/cpuid,/ ? (and then also s/cpus/cpus,/)

Sure, will fix

> 
>> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
>> +		info->vm.max_guests = uv_info.max_num_sec_conf;
>> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
>> +		info->vm.feature_indication = uv_info.uv_feature_indications;
>> +
>> +		return len_min;
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
>> index 91a6fe4e02c0..59e4fb6c7a34 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1645,6 +1645,30 @@ struct kvm_s390_pv_unp {
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
>> @@ -1653,6 +1677,7 @@ enum pv_cmd_id {
>>   	KVM_PV_VERIFY,
>>   	KVM_PV_PREP_RESET,
>>   	KVM_PV_UNSHARE_ALL,
>> +	KVM_PV_INFO,
>>   };
>>   
>>   struct kvm_pv_cmd {
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE1521593
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbiEJMkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbiEJMkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:40:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44031D7375;
        Tue, 10 May 2022 05:36:20 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AC6BY0033111;
        Tue, 10 May 2022 12:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=T5Z22MTCRiUPWcFJJ/2U8ekxLY6TkTtRANd6EsIWawU=;
 b=lCLdNG9pSfRhsdiiM0ucvwzSG/EGkvmV3tnQN+kTSbmTJY72WQMnxn04bFKh1y3yvShr
 +7eQbAxi74R0GmaZeBBUivxHX3+Ip9/rfX46Favfa/VHz08lkXWN6mGC0wiwTm9K3c+M
 1IKl5ED446sgDRQQF+X2vXBwu8asSZL6kasyLINgsUkXyQMxucB/9GdhWT7g8bWHTdis
 6VXcSxkDX9uWXbih2p9DXfJYjSijCaqVdoClLnFsgaq56+wT3NgOYd9GqcS2fQrmFFF7
 FKB54Iz3+iMpp8Z8+daUT4kWKwQ83c5sIszgFvU/Yv2KZlxffR7qD/v/NiDIIDVkp1m9 xQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyp3btqbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:36:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24ACXDin026315;
        Tue, 10 May 2022 12:36:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j432h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:36:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24ACaEG357410004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 12:36:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA156A405C;
        Tue, 10 May 2022 12:36:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84307A4054;
        Tue, 10 May 2022 12:36:14 +0000 (GMT)
Received: from [9.145.38.155] (unknown [9.145.38.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 12:36:14 +0000 (GMT)
Message-ID: <7f50d80f-2508-59f6-cb2d-cc6bc1f3b551@linux.ibm.com>
Date:   Tue, 10 May 2022 14:36:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5/9] KVM: s390: pv: Add query dump information
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
References: <20220428130102.230790-1-frankja@linux.ibm.com>
 <20220428130102.230790-6-frankja@linux.ibm.com>
 <20220509172844.1195585b@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220509172844.1195585b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lJnwN0jkA1zN4vYQ2xXzJ7tgVRsH6sya
X-Proofpoint-GUID: lJnwN0jkA1zN4vYQ2xXzJ7tgVRsH6sya
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_01,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100057
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/22 17:28, Claudio Imbrenda wrote:
> On Thu, 28 Apr 2022 13:00:58 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> The dump API requires userspace to provide buffers into which we will
>> store data. The dump information added in this patch tells userspace
>> how big those buffers need to be.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>>   include/uapi/linux/kvm.h | 12 +++++++++++-
>>   2 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 23352d45a386..e327a5b8ef78 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2255,6 +2255,17 @@ static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>>   
>>   		return len_min;
>>   	}
>> +	case KVM_PV_INFO_DUMP: {
>> +		len_min =  sizeof(info->header) + sizeof(info->dump);
> 
> so the output will have some zero-padded stuff at the end?

In which situation?

> 
>> +
>> +		if (info->header.len_max < len_min)
>> +			return -EINVAL;
>> +
>> +		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
>> +		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
>> +		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
>> +		return len_min;
>> +	}
>>   	default:
>>   		return -EINVAL;
>>   	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 59e4fb6c7a34..2eba89d7ec29 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1647,6 +1647,13 @@ struct kvm_s390_pv_unp {
>>   
>>   enum pv_cmd_info_id {
>>   	KVM_PV_INFO_VM,
>> +	KVM_PV_INFO_DUMP,
>> +};
>> +
>> +struct kvm_s390_pv_info_dump {
>> +	__u64 dump_cpu_buffer_len;
>> +	__u64 dump_config_mem_buffer_per_1m;
>> +	__u64 dump_config_finalize_len;
>>   };
>>   
>>   struct kvm_s390_pv_info_vm {
>> @@ -1666,7 +1673,10 @@ struct kvm_s390_pv_info_header {
>>   
>>   struct kvm_s390_pv_info {
>>   	struct kvm_s390_pv_info_header header;
>> -	struct kvm_s390_pv_info_vm vm;
>> +	union {
>> +		struct kvm_s390_pv_info_dump dump;
>> +		struct kvm_s390_pv_info_vm vm;
>> +	};
>>   };
>>   
>>   enum pv_cmd_id {
> 


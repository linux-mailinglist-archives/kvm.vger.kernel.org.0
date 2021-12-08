Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A8046D4EE
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 14:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhLHOBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:01:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhLHOBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:01:37 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DmhNL027475;
        Wed, 8 Dec 2021 13:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3zYOLj3bQx7bNb/Z2+EGbbZo+1Qqq5+HN7guFjO/yqI=;
 b=RAcKU8aPh4CwI44uxJEHN4i+01ndDJ2bENEAqO26LU88YBrxHvHAfWKfxtFRzXdfEyy9
 l7LgGPnXlzXCsEeDReMrQ9g5zT+MXVM1jQwn1rZgDz9Wx1Zo4r9zDEYKrniX8c5HmLJM
 9NtJBVOjb349zFLdHe+Lz9y3q0KMLI2DCGUocv5lTXpNfUG1tk/DrodZMYlCymcuWiOX
 rn3uP/bOIBJqp8i469bfVWADabK/vZcvWJohvvRWFJax+Jkj/8GEqUFqZoZWvQEMt4Cs
 n2mZeuDW0DvmujfKf468O36VFZy0p1N/VQVPCsF8ACQNRep8SUYPcx0m3BboAPkrcjly hA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctwwnr5q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:58:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DrI01021019;
        Wed, 8 Dec 2021 13:58:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb08nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:58:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8Dvws224314322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 13:57:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E18AE053;
        Wed,  8 Dec 2021 13:57:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ADEAAE04D;
        Wed,  8 Dec 2021 13:57:58 +0000 (GMT)
Received: from [9.145.90.190] (unknown [9.145.90.190])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 13:57:58 +0000 (GMT)
Message-ID: <cdcb6c9c-ef24-08e5-8bc8-b4c83bcda3b3@linux.ibm.com>
Date:   Wed, 8 Dec 2021 14:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] s390: uv: Add offset comments to UV query struct
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
References: <20211207160510.1818-1-frankja@linux.ibm.com>
 <20211208091008.09874eba@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211208091008.09874eba@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rlieL2EliJ4l_XYuaf2HgK8zwaSpsTx9
X-Proofpoint-GUID: rlieL2EliJ4l_XYuaf2HgK8zwaSpsTx9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 09:10, Claudio Imbrenda wrote:
> On Tue,  7 Dec 2021 16:05:10 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Changes to the struct are easier to manage with offset comments so
>> let's add some.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/uv.h | 34 +++++++++++++++++-----------------
>>   1 file changed, 17 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 72d3e49c2860..235bd5cc8289 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -91,23 +91,23 @@ struct uv_cb_header {
>>   
>>   /* Query Ultravisor Information */
>>   struct uv_cb_qui {
>> -	struct uv_cb_header header;
>> -	u64 reserved08;
>> -	u64 inst_calls_list[4];
>> -	u64 reserved30[2];
>> -	u64 uv_base_stor_len;
>> -	u64 reserved48;
>> -	u64 conf_base_phys_stor_len;
>> -	u64 conf_base_virt_stor_len;
>> -	u64 conf_virt_var_stor_len;
>> -	u64 cpu_stor_len;
>> -	u32 reserved70[3];
>> -	u32 max_num_sec_conf;
>> -	u64 max_guest_stor_addr;
>> -	u8  reserved88[158 - 136];
>> -	u16 max_guest_cpu_id;
>> -	u64 uv_feature_indications;
>> -	u8  reserveda0[200 - 168];
>> +	struct uv_cb_header header;		/* 0x0000 */
>> +	u64 reserved08;				/* 0x0008 */
>> +	u64 inst_calls_list[4];			/* 0x0010 */
>> +	u64 reserved30[2];			/* 0x0030 */
>> +	u64 uv_base_stor_len;			/* 0x0040 */
>> +	u64 reserved48;				/* 0x0048 */
>> +	u64 conf_base_phys_stor_len;		/* 0x0050 */
>> +	u64 conf_base_virt_stor_len;		/* 0x0058 */
>> +	u64 conf_virt_var_stor_len;		/* 0x0060 */
>> +	u64 cpu_stor_len;			/* 0x0068 */
>> +	u32 reserved70[3];			/* 0x0070 */
>> +	u32 max_num_sec_conf;			/* 0x007c */
>> +	u64 max_guest_stor_addr;		/* 0x0080 */
>> +	u8  reserved88[158 - 136];		/* 0x0088 */
>> +	u16 max_guest_cpu_id;			/* 0x009e */
>> +	u64 uv_feature_indications;		/* 0x00a0 */
>> +	u8  reserveda0[200 - 168];		/* 0x00a8 */
> 
> since you're changing stuff, maybe fix the name?
> s/reserveda0/reserveda8/

Good catch

> 
> with that fixed:
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks

> 
>>   } __packed __aligned(8);
>>   
>>   /* Initialize Ultravisor */
> 


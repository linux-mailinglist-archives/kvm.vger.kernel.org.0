Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C63B803C
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhF3Jpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:45:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14228 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhF3Jpw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 05:45:52 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15U9X1bP131970;
        Wed, 30 Jun 2021 05:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lrR8+LlFgnmhP3OPqmREsSficOfGY2gB+Km5f1FVELA=;
 b=Y7a3mJbFEXHtLNYZyYDbEgJlGmqwHcycbIimL5WpOb8dwjFGw6HyXjo63Cq46za6kP0d
 55sVBVd/nEetUKyTPNT2UKgzskjikdfjoVkMybzArt6fx3l36MK+VgfhhGtWkxNjI/4L
 u++4+dG7PalUfXZEOo5NaF6Fk63P1jfS+pqIP6TpYBB4pFDRhyRowagkKyt8H41Xa0N7
 9aOHKyc1YzviIFoK3/NMs3t/g+UTzSiJxI4btyXwxaBBJ70buErDonQgyXYUg4k8EiEB
 ckVcplUW/newOkh0vC5KOG4hSRoh/Ukv33Ez5TrV6n9V9BS1CEs+Ypsnzy0nz3r68XQC zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gntrgnfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 05:43:23 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15U9X5sR132326;
        Wed, 30 Jun 2021 05:43:22 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gntrgnen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 05:43:22 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15U9hLTA018909;
        Wed, 30 Jun 2021 09:43:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39g91yr90s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 09:43:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15U9hI3t30933312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 09:43:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E3EAE059;
        Wed, 30 Jun 2021 09:43:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B80FAE068;
        Wed, 30 Jun 2021 09:43:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.148.53])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 09:43:18 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 4/5] lib: s390x: uv: Add offset comments to
 uv_query and extend it
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-5-frankja@linux.ibm.com> <87o8bnlo10.fsf@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b4b7d415-4238-afc1-9df5-d862656ea448@linux.ibm.com>
Date:   Wed, 30 Jun 2021 11:43:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87o8bnlo10.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6aeXzNKDu00Ne4jpAgIPsZTj6PPGjYN_
X-Proofpoint-ORIG-GUID: gYyj9Xpdhb4OdRgpCjzlcsHfN1Wcf2qm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_02:2021-06-29,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/21 11:06 AM, Cornelia Huck wrote:
> On Tue, Jun 29 2021, Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> The struct is getting longer, let's add offset comments so we know
>> where we change things when we add struct members.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h | 33 +++++++++++++++++----------------
>>  1 file changed, 17 insertions(+), 16 deletions(-)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 96a2a7e..5ff98b8 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -86,22 +86,23 @@ struct uv_cb_init {
>>  } __attribute__((packed))  __attribute__((aligned(8)));
>>  
>>  struct uv_cb_qui {
>> -	struct uv_cb_header header;
>> -	uint64_t reserved08;
>> -	uint64_t inst_calls_list[4];
>> -	uint64_t reserved30[2];
>> -	uint64_t uv_base_stor_len;
>> -	uint64_t reserved48;
>> -	uint64_t conf_base_phys_stor_len;
>> -	uint64_t conf_base_virt_stor_len;
>> -	uint64_t conf_virt_var_stor_len;
>> -	uint64_t cpu_stor_len;
>> -	uint32_t reserved70[3];
>> -	uint32_t max_num_sec_conf;
>> -	uint64_t max_guest_stor_addr;
>> -	uint8_t  reserved88[158 - 136];
>> -	uint16_t max_guest_cpus;
>> -	uint8_t  reserveda0[200 - 160];
>> +	struct uv_cb_header header;		/* 0x0000 */
>> +	uint64_t reserved08;			/* 0x0008 */
>> +	uint64_t inst_calls_list[4];		/* 0x0010 */
>> +	uint64_t reserved30[2];			/* 0x0030 */
>> +	uint64_t uv_base_stor_len;		/* 0x0040 */
>> +	uint64_t reserved48;			/* 0x0048 */
>> +	uint64_t conf_base_phys_stor_len;	/* 0x0050 */
>> +	uint64_t conf_base_virt_stor_len;	/* 0x0058 */
>> +	uint64_t conf_virt_var_stor_len;	/* 0x0060 */
>> +	uint64_t cpu_stor_len;			/* 0x0068 */
>> +	uint32_t reserved70[3];			/* 0x0070 */
>> +	uint32_t max_num_sec_conf;		/* 0x007c */
>> +	uint64_t max_guest_stor_addr;		/* 0x0080 */
>> +	uint8_t  reserved88[158 - 136];		/* 0x0088 */
>> +	uint16_t max_guest_cpus;		/* 0x009e */
>> +	uint64_t uv_feature_indications;	/* 0x00a0 */
>> +	uint8_t  reserveda0[200 - 168];		/* 0x00a8 */
> 
> Should this rather be reserveda8? The other reserveds encode their
> position properly.
> 


Oops

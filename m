Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18394203B0B
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgFVPha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:37:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21314 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729494AbgFVPh3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 11:37:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MFWPRY001791;
        Mon, 22 Jun 2020 11:37:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31sj0c0w15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 11:37:27 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MFWgrH003183;
        Mon, 22 Jun 2020 11:37:27 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31sj0c0w0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 11:37:27 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MFZElX025905;
        Mon, 22 Jun 2020 15:37:26 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 31sa38mr9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:37:26 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MFbMCh47513938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 15:37:22 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8790BE058;
        Mon, 22 Jun 2020 15:37:22 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEFE0BE04F;
        Mon, 22 Jun 2020 15:37:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.169.243])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Jun 2020 15:37:21 +0000 (GMT)
Subject: Re: [PATCH v8 1/2] s390/setup: diag 318: refactor struct
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200618222222.23175-1-walling@linux.ibm.com>
 <20200618222222.23175-2-walling@linux.ibm.com>
 <e3edb120-33cb-9f3a-bf05-79b3a48613fe@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <de3ace0b-4f84-aa33-5f95-0f8ec308c865@linux.ibm.com>
Date:   Mon, 22 Jun 2020 11:37:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e3edb120-33cb-9f3a-bf05-79b3a48613fe@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0 cotscore=-2147483648
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 10:56 AM, Christian Borntraeger wrote:
> 
> On 19.06.20 00:22, Collin Walling wrote:
>> The diag 318 struct introduced in include/asm/diag.h can be
>> reused in KVM, so let's condense the version code fields in the
>> diag318_info struct for easier usage and simplify it until we
>> can determine how the data should be formatted.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Series looks good to me. Can you respin the 2nd patch regarding the VSIE things
> and I can then apply it.
> 
> 

Will do. Thanks.

>> ---
>>  arch/s390/include/asm/diag.h | 6 ++----
>>  arch/s390/kernel/setup.c     | 3 +--
>>  2 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
>> index 0036eab14391..ca8f85b53a90 100644
>> --- a/arch/s390/include/asm/diag.h
>> +++ b/arch/s390/include/asm/diag.h
>> @@ -298,10 +298,8 @@ struct diag26c_mac_resp {
>>  union diag318_info {
>>  	unsigned long val;
>>  	struct {
>> -		unsigned int cpnc : 8;
>> -		unsigned int cpvc_linux : 24;
>> -		unsigned char cpvc_distro[3];
>> -		unsigned char zero;
>> +		unsigned long cpnc : 8;
>> +		unsigned long cpvc : 56;
>>  	};
>>  };
>>  
>> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
>> index 5853c9872dfe..878cacfc9c3e 100644
>> --- a/arch/s390/kernel/setup.c
>> +++ b/arch/s390/kernel/setup.c
>> @@ -1021,8 +1021,7 @@ static void __init setup_control_program_code(void)
>>  {
>>  	union diag318_info diag318_info = {
>>  		.cpnc = CPNC_LINUX,
>> -		.cpvc_linux = 0,
>> -		.cpvc_distro = {0},
>> +		.cpvc = 0,
>>  	};
>>  
>>  	if (!sclp.has_diag318)
>>


-- 
Regards,
Collin

Stay safe and stay healthy

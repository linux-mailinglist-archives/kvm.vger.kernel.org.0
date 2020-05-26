Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118041E214D
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgEZLvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:51:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728151AbgEZLvk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 07:51:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QBVD05101350;
        Tue, 26 May 2020 07:51:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wevckd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:51:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QBWMX5104639;
        Tue, 26 May 2020 07:51:38 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 316wevckce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 07:51:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QBpaDI004548;
        Tue, 26 May 2020 11:51:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 316uf8abj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 11:51:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QBoKrZ51773798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 11:50:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294F64204B;
        Tue, 26 May 2020 11:51:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFFA942049;
        Tue, 26 May 2020 11:51:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.178.226])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 11:51:33 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 03/12] s390x: Move control register bit
 definitions and add AFP to them
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-4-git-send-email-pmorel@linux.ibm.com>
 <7614689a-62e6-944e-6162-93aa72407a90@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d47305f9-7366-eccc-c202-d324236196f2@linux.ibm.com>
Date:   Tue, 26 May 2020 13:51:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7614689a-62e6-944e-6162-93aa72407a90@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_01:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 suspectscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005260083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-25 20:57, Thomas Huth wrote:
> On 18/05/2020 18.07, Pierre Morel wrote:
>> While adding the definition for the AFP-Register control bit, move all
>> existing definitions for CR0 out of the C zone to the assmbler zone to
>> keep the definitions concerning CR0 together.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 11 ++++++-----
>>   s390x/cstart64.S         |  2 +-
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 820af93..54ffd0b 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -19,17 +19,18 @@
>>   
>>   #define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
>>   
>> +#define CR0_EXTM_SCLP			0X0000000000000200UL
>> +#define CR0_EXTM_EXTC			0X0000000000002000UL
>> +#define CR0_EXTM_EMGC			0X0000000000004000UL
>> +#define CR0_EXTM_MASK			0X0000000000006200UL
>> +#define CR0_AFP_REG_CRTL		0x0000000000040000UL
>> +
>>   #ifndef __ASSEMBLER__
>>   struct psw {
>>   	uint64_t	mask;
>>   	uint64_t	addr;
>>   };
>>   
>> -#define CR0_EXTM_SCLP			0X0000000000000200UL
>> -#define CR0_EXTM_EXTC			0X0000000000002000UL
>> -#define CR0_EXTM_EMGC			0X0000000000004000UL
>> -#define CR0_EXTM_MASK			0X0000000000006200UL
> 
> This patch does not apply anymore due to commit f7df29115f736b ...
> please switch to lower-case "0x"s in the next version.
> 
>   Thanks,
>    Thomas
> 

OK, I will rebase.
Thanks,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen

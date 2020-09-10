Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B464264ED9
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 21:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgIJT1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 15:27:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgIJT1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 15:27:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AJPLWu188691;
        Thu, 10 Sep 2020 19:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jL2yVWe9tWysab0EvEA6kkJifBYKIbsNhJFCgt8NKCs=;
 b=wgT7J+WKiHVKwmiUk664oOjqZ48vs1XLOkFgw0aSExft5HdrKPca0+M8zlYMkbS0p3AI
 3AKnsuEsWTLng2aQqgCyEgA0EzhI39jHnCU0/jj1yHiCCmqSkoExOI0+3r2NguqEPsO8
 h4fgeg4qZy/OXndYY45X7l6oFLMIe90IUAm4d7r4RpzE/YRHULTIVwzRVej1kda9rCRj
 SJdm93vlWPJmjlS8lKEoHXN3RFbQzRFwp1vRJ3ysxm+y9GRnkrKd17ZzXYqAoJjhYXKa
 Sc7CMFb9xpl4r1GDl/vxp04klnq8LTmTkNGlT+8t/xqM0KywNbG9RIQsT27gRd3iV0of aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33c23ra7sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 19:27:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AJPfBe056757;
        Thu, 10 Sep 2020 19:27:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33dacnph4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 19:27:36 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AJRaWS019628;
        Thu, 10 Sep 2020 19:27:36 GMT
Received: from localhost.localdomain (/10.159.235.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 12:27:36 -0700
Subject: Re: [PATCH 2/3 v2] KVM: SVM: Add hardware-enforced cache coherency as
 a CPUID feature
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
 <20200910022211.5417-3-krish.sadhukhan@oracle.com>
 <fdf8b289-1e6d-9f3e-3d76-f48fcee2b236@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <88c2c23d-c2d9-66e2-1778-6f81d1eef04a@oracle.com>
Date:   Thu, 10 Sep 2020 12:27:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <fdf8b289-1e6d-9f3e-3d76-f48fcee2b236@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/10/20 7:45 AM, Tom Lendacky wrote:
> On 9/9/20 9:22 PM, Krish Sadhukhan wrote:
>> Some AMD hardware platforms enforce cache coherency across encryption 
>> domains.
>> Add this hardware feature as a CPUID feature to the kernel.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/include/asm/cpufeatures.h | 1 +
>>   arch/x86/kernel/cpu/amd.c          | 3 +++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h 
>> b/arch/x86/include/asm/cpufeatures.h
>> index 81335e6fe47d..0e5b27ee5931 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -293,6 +293,7 @@
>>   #define X86_FEATURE_FENCE_SWAPGS_USER    (11*32+ 4) /* "" LFENCE in 
>> user entry SWAPGS path */
>>   #define X86_FEATURE_FENCE_SWAPGS_KERNEL    (11*32+ 5) /* "" LFENCE 
>> in kernel entry SWAPGS path */
>>   #define X86_FEATURE_SPLIT_LOCK_DETECT    (11*32+ 6) /* #AC for 
>> split lock */
>> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD 
>> hardware-enforced cache coherency */
>>     /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), 
>> word 12 */
>>   #define X86_FEATURE_AVX512_BF16        (12*32+ 5) /* AVX512 
>> BFLOAT16 instructions */
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 4507ededb978..698884812989 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -632,6 +632,9 @@ static void early_detect_mem_encrypt(struct 
>> cpuinfo_x86 *c)
>>            */
>>           c->x86_phys_bits -= (cpuid_ebx(CPUID_AMD_SME) >> 6) & 0x3f;
>>   +        if (cpuid_eax(CPUID_AMD_SME) & 0x400)
>> +            set_cpu_cap(c, X86_FEATURE_HW_CACHE_COHERENCY);
>
> Why not add this to arch/x86/kernel/cpu/scattered.c?


The reason why I put it in amd.c is because it's AMD-specific, though I 
know we have SME and SEV in scattered.c. Shouldn't SME and SEV features 
be ideally placed in AMD-specific files and scattered.c be used for 
common CPUID features ?


>
> Thanks,
> Tom
>
>> +
>>           if (IS_ENABLED(CONFIG_X86_32))
>>               goto clear_all;
>>

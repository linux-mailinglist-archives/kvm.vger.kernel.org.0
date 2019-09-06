Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB9AC190
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389747AbfIFUny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 16:43:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732085AbfIFUny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 16:43:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86KYnnf147820;
        Fri, 6 Sep 2019 20:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GarEwQV/q5HH7Od2Cal8C5S+M8JWXoKzec+ORCS2vWk=;
 b=ZSfhfTJGRJ71v96r7/fsD6RFzFBGA9t6xZdolzdPhT2R5ZKy5849kTNbCKP/3hf5alwP
 baTGAtz5eb0I3yyTe/WZuawaFCxbcT0LwKkuMIiprdVMBVC2uTJ4VkdpiK+iBHryTjfA
 6rU0PnBUPMWdvan/C/f8ndvegDS6jtNMQFgVIQ8Yluv8k8MLc54nKUaVNUVKTFoKVj6j
 beqiqmaxYVCgDx/n8+SFzcGhc9WnEJ6RhVP81VojYywz6ZVcEYV89qfsprsWgGaZtsQ5
 NMazL2poGW63V4uNHOfxuGieKFBk51+Z5Bi+iLhW9cCSKXoTMorm50dGymuUHQMCGd8s yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuxm1g15q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 20:43:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86Kh6ke062686;
        Fri, 6 Sep 2019 20:43:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7pwhkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 20:43:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x86KhoLr029934;
        Fri, 6 Sep 2019 20:43:50 GMT
Received: from [10.159.158.81] (/10.159.158.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 13:43:50 -0700
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>
References: <20190821182004.102768-1-jmattson@google.com>
 <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com>
 <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
Date:   Fri, 6 Sep 2019 13:43:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060210
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/6/19 1:30 PM, Jim Mattson wrote:
> On Fri, Sep 6, 2019 at 12:59 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 9/6/19 9:48 AM, Jim Mattson wrote:
>>
>> On Wed, Aug 21, 2019 at 11:20 AM Jim Mattson <jmattson@google.com> wrote:
>>
>> These MSRs should be enumerated by KVM_GET_MSR_INDEX_LIST, so that
>> userspace knows that these MSRs may be part of the vCPU state.
>>
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Eric Hankland <ehankland@google.com>
>> Reviewed-by: Peter Shier <pshier@google.com>
>>
>> ---
>>   arch/x86/kvm/x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 93b0bd45ac73..ecaaa411538f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1140,6 +1140,42 @@ static u32 msrs_to_save[] = {
>>          MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>>          MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>>          MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>> +       MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
>> +       MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
>> +       MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
>> +       MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> +       MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 6, MSR_ARCH_PERFMON_PERFCTR0 + 7,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
>> +       MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
>> +       MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
>> +       MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
>>   };
>>
>>
>> Should we have separate #defines for the MSRs that are at offset from the base MSR?
> How about macros that take an offset argument, rather than a whole
> slew of new macros?


Yes, that works too.


>
>>   static unsigned num_msrs_to_save;
>> @@ -4989,6 +5025,11 @@ static void kvm_init_msr_list(void)
>>          u32 dummy[2];
>>          unsigned i, j;
>>
>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
>> +                        "Please update the fixed PMCs in msrs_to_save[]");
>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
>> +                        "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
>>
>>
>> Just curious how the condition can ever become false because we are comparing two static numbers here.
> Someone just has to change the macros. In fact, I originally developed
> this change on a version of the kernel where INTEL_PMC_MAX_FIXED was
> 3, and so I had:
>
>> +       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 3,
>> +                        "Please update the fixed PMCs in msrs_to_save[]")
> When I cherry-picked the change to Linux tip, the BUILD_BUG_ON fired,
> and I updated the fixed PMCs in msrs_to_save[].
>
>> +
>>          for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
>>                  if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
>>                          continue;
>> --
>> 2.23.0.187.g17f5b7556c-goog
>>
>> Ping.
>>
>>
>> Also, since these MSRs are Intel-specific, should these be enumerated via 'intel_pmu_ops' ?
> msrs_to_save[] is filtered to remove MSRs that aren't supported on the
> host. Or are you asking something else?


I am referring to the fact that we are enumerating Intel-specific MSRs 
in the generic KVM code. Should there be some sort of #define guard to 
not compile the code on AMD ?



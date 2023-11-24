Return-Path: <kvm+bounces-2391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2427F6ACB
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 04:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B2811C20C6F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 03:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266BB3C1C;
	Fri, 24 Nov 2023 03:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C36F101
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 19:01:48 -0800 (PST)
X-ASG-Debug-ID: 1700794904-1eb14e538c1e890001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id drTLcCUqm6PEvl2P (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 24 Nov 2023 11:01:44 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 24 Nov
 2023 11:01:44 +0800
Received: from [10.28.66.55] (10.28.66.55) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 24 Nov
 2023 11:01:43 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Message-ID: <0dbf5f15-8165-420e-ae0e-5d7aac7053ff@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.55
Date: Thu, 23 Nov 2023 22:01:42 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
Subject: PING: VMX controls setting patch for backward compatibility
To: Zhao Liu <zhao1.liu@intel.com>
X-ASG-Orig-Subj: PING: VMX controls setting patch for backward compatibility
CC: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>
References: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
 <ZTnbFJrHeKhoUA6F@intel.com>
 <eb9a08b2-a7c4-c45c-edd8-0585037194aa@zhaoxin.com>
 <a75f0b92-4894-bee9-ecbd-78b849702f61@zhaoxin.com>
Content-Language: en-US
In-Reply-To: <a75f0b92-4894-bee9-ecbd-78b849702f61@zhaoxin.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1700794904
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 7581
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.117174
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Hi Zhao Liu and QEMU/KVM Community,

I hope this email finds you well. I am writing to follow up on the
conversation we had a month ago regarding my patch submission for
refining the VMX controls setting for backward compatibility on
QEMU-KVM.

On October 27, I responded to the feedback and suggestions provided
by Zhao Liu, making necessary corrections and improvements to the
patch. However, since then, I haven't received any further responses
or reviews.

I understand that everyone is busy, and I appreciate the time and
effort that goes into reviewing these submissions. I just wanted to
check if there are any updates, additional feedback, or steps I should
take next. I am more than willing to make further changes if needed.

Please let me know if there is anything else required from my side for
this patch to move forward. Thank you for your time and attention. I
look forward to hearing from you.

Best regards,
Ewan Hai

On 10/27/23 02:08, Ewan Hai wrote:
> Hi Zhao,
>
> since I found last email contains non-plain-text content, 
> andkvm@vger.kernel.org
> rejected to receive my mail, so just re-send last mail here, to follow 
> the rule of qemu
> /kvm community.
>
> On 10/25/23 23:20, Zhao Liu wrote:
>> On Mon, Sep 25, 2023 at 03:14:53AM -0400, EwanHai wrote:
>>> Date: Mon, 25 Sep 2023 03:14:53 -0400
>>> From: EwanHai<ewanhai-oc@zhaoxin.com>
>>> Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for 
>>> backward
>>>   compatibility
>>> X-Mailer: git-send-email 2.34.1
>>>
>>> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
>>> execution controls") implemented a workaround for hosts that have
>>> specific CPUID features but do not support the corresponding VMX
>>> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
>>>
>>> In detail, commit 4a910e1 introduced a flag 
>>> `has_msr_vmx_procbased_clts2`.
>>> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
>>> use KVM's settings, avoiding any modifications to this MSR.
>>>
>>> However, this commit (4a910e1) didn’t account for cases in older Linux
>> s/didn’t/didn't/
>
> I'll fix it.
>
>>> kernels(e.g., linux-4.19.90) where `MSR_IA32_VMX_PROCBASED_CTLS2` is
>> For this old kernel, it's better to add the brief lifecycle note (e.g.,
>> lts, EOL) to illustrate the value of considering such compatibility
>> fixes.
>
> I've checked the linux-stable repo, found that
> MSR_IA32_VMX_PROCBASED_CTLS2 is not included in kvm regular msr list
> until linux-5.3, and in linux-4.19.x(EOL:Dec,2024), there is also no
> MSR_IA32_VMX_PROCBASED_CTLS2 in kvm regular msr list.
>
> So maybe this is an important compatibility fix for kernel < 5.3.
>
>>> in `kvm_feature_msrs`—obtained by 
>>> ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
>> s/—obtained/-obtained/
>
> I'll fix it.
>
>>> but not in `kvm_msr_list`—obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
>> s/—obtained/-obtained/
>
> I'll fix it.
>
>>> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
>>> on `kvm_msr_list` alone, even though KVM maintains the value of this 
>>> MSR.
>>>
>>> This patch supplements the above logic, ensuring that
>>> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
>>> lists, thus maintaining compatibility with older kernels.
>>>
>>> Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
>>> ---
>>>   target/i386/kvm/kvm.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index af101fcdf6..6299284de4 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>>>   static int kvm_get_supported_feature_msrs(KVMState *s)
>>>   {
>>>       int ret = 0;
>>> +    int i;
>>>         if (kvm_feature_msrs != NULL) {
>>>           return 0;
>>> @@ -2377,6 +2378,11 @@ static int 
>>> kvm_get_supported_feature_msrs(KVMState *s)
>>>           return ret;
>>>       }
>> It's worth adding a comment here to indicate that this is a
>> compatibility fix.
>>
>> -Zhao
>>
>>>   +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
>>> +        if (kvm_feature_msrs->indices[i] == 
>>> MSR_IA32_VMX_PROCBASED_CTLS2) {
>>> +            has_msr_vmx_procbased_ctls2 = true;
>>> +        }
>>> +    }
>>>       return 0;
>>>   }
>>>   --
>>> 2.34.1
>>>
> Plan to use patch bellow, any more suggestion?
>
>>  From a3006fcec3615d98ac1eb252a61952d44aa5029b Mon Sep 17 00:00:00 2001
>> From: EwanHai<ewanhai-oc@zhaoxin.com>
>> Date: Mon, 25 Sep 2023 02:11:59 -0400
>> Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for 
>> backward
>>   compatibility
>>
>> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
>> execution controls") implemented a workaround for hosts that have
>> specific CPUID features but do not support the corresponding VMX
>> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
>>
>> In detail, commit 4a910e1 introduced a flag 
>> `has_msr_vmx_procbased_clts2`.
>> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
>> use KVM's settings, avoiding any modifications to this MSR.
>>
>> However, this commit (4a910e1) didn't account for cases in older Linux
>> kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
>> `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
>> but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
>> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
>> on `kvm_msr_list` alone, even though KVM maintains the value of this 
>> MSR.
>>
>> This patch supplements the above logic, ensuring that
>> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
>> lists, thus maintaining compatibility with older kernels.
>>
>> Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
>> ---
>>   target/i386/kvm/kvm.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index af101fcdf6..3cf95f8579 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>>   static int kvm_get_supported_feature_msrs(KVMState *s)
>>   {
>>       int ret = 0;
>> +    int i;
>>
>>       if (kvm_feature_msrs != NULL) {
>>           return 0;
>> @@ -2377,6 +2378,19 @@ static int 
>> kvm_get_supported_feature_msrs(KVMState *s)
>>           return ret;
>>       }
>>
>> +    /*
>> +     * Compatibility fix:
>> +     * Older Linux kernels(<5.3) include the 
>> MSR_IA32_VMX_PROCBASED_CTLS2
>> +     * only in feature msr list, but not in regular msr list. This 
>> lead to
>> +     * an issue in older kernel versions where QEMU, through the 
>> regular
>> +     * MSR list check, assumes the kernel doesn't maintain this msr,
>> +     * resulting in incorrect settings by QEMU for this msr.
>> +     */
>> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
>> +        if (kvm_feature_msrs->indices[i] == 
>> MSR_IA32_VMX_PROCBASED_CTLS2) {
>> +            has_msr_vmx_procbased_ctls2 = true;
>> +        }
>> +    }
>>       return 0;
>>   }
>>
>> -- 
>> 2.34.1
>
> Best regards.
>


Return-Path: <kvm+bounces-54569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E706CB244A3
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 10:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9304D3B0469
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 08:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD282EBB99;
	Wed, 13 Aug 2025 08:45:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D02E9EBF
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755074735; cv=none; b=vCMZIkJM+y+1gEbDvHSskZQDcV5zhkExUfp5k3KpVk9/JGxvLAbAVZxGJ8FkELun+Dd9871WdtBin+O/AkfSVnDNH6h1BTVo9uQcCC4GUfJLeoOFfrLweH/PfVfI/0ZsBqahu5sl1BdRG4/CYJ7pw9Rae0zyj12ND0YuTo3lcUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755074735; c=relaxed/simple;
	bh=Ldh16fh8fFa2OPBjVcPdSLU3OlKaSqrsIvKxgPe106A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IbP63Vy0R6u4aqqLSrJEpZqIc8etmdrxHNKkPvAmtSrd3rVDyQX1Q8WR3xxaJwPClfxexekT+VYEXt1zRcqRprVv2exJ1ba6tkaQl9ENfCy8r7BnTH1wiOX2jbncXiZ7ht/kHroqEOJL/OePDz8NOoTZKVdkePDsISnkpALtFPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1755074720-086e2329551d6fb0001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id hEfWBgoDxOb7YNE1 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 13 Aug 2025 16:45:21 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 13 Aug
 2025 16:45:20 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f]) by
 ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f%7]) with mapi id
 15.01.2507.044; Wed, 13 Aug 2025 16:45:20 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from [10.28.24.128] (10.28.24.128) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 13 Aug
 2025 16:38:39 +0800
Message-ID: <ed29e030-63f2-493f-af74-d1d0e1fb09e4@zhaoxin.com>
Date: Wed, 13 Aug 2025 04:38:26 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai"
 vendor
To: Sean Christopherson <seanjc@google.com>
X-ASG-Orig-Subj: Re: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai"
 vendor
CC: <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>, <leoliu@zhaoxin.com>,
	<lyleli@zhaoxin.com>
References: <20250811013558.332940-1-ewanhai-oc@zhaoxin.com>
 <aJtYlfuBSWhXS3dW@google.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
Content-Language: en-US
In-Reply-To: <aJtYlfuBSWhXS3dW@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 8/13/2025 4:45:19 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1755074721
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 4987
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.145685
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 8/12/25 11:07, Sean Christopherson wrote:
> On Sun, Aug 10, 2025, Ewan Hai wrote:
>> rename the local constant CENTAUR_CPUID_SIGNATURE to ZHAOXIN_CPUID_SIGNATURE.
> Why?  I'm not inclined to rename any of the Centaur references, as I don't see
> any point in effectively rewriting history.  If we elect to rename things, then
> it needs to be done in a separate patch, there needs to be proper justification,
> and _all_ references should be converted, e.g. converting just this one macro
> creates discrepancies even with cpuid.c, as there are multiple comments that
> specifically talk about Centaur CPUID leaves.
>
Okay, it seems I oversimplified the situation.

My initial thought was that, since there will no longer be separate handling for
"Centaurhauls," nearly all new software and hardware features will be applied to
both "Centaurhauls" and "  Shanghai  " vendors in parallel. This would gradually
lead to more and more occurrences of if (vendor == centaur || vendor ==
shanghai) in the kernel code. In that case, introducing an is_zhaoxin_vendor()
helper could significantly reduce the number of repetitive if (xx || yy) checks.

However, it appears that this "duplication issue" is not a real concern for now.
We can revisit it later when it becomes a practical problem.

For the current matter, there are two possible approaches. Which one do you
prefer? Or, if you have other suggestions, please let me know and I will
incorporate your recommendation into the v2 patch.

## Version 1 ##
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1820,7 +1820,8 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
         int r;

         if (func == CENTAUR_CPUID_SIGNATURE &&
-           boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+           boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
+           boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)
                 return 0;

         r = do_cpuid_func(array, func, type);

## Version 2 ##
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1812,6 +1812,7 @@ static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
  }

  #define CENTAUR_CPUID_SIGNATURE 0xC0000000
+#define ZHAOXIN_CPUID_SIGNATURE 0xC0000000

  static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
                           unsigned int type)
@@ -1819,8 +1820,10 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
         u32 limit;
         int r;

-       if (func == CENTAUR_CPUID_SIGNATURE &&
-           boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+       if ((func == CENTAUR_CPUID_SIGNATURE &&
+            boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR) ||
+           (func == ZHAOXIN_CPUID_SIGNATURE &&
+            boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN))
                 return 0;

         r = do_cpuid_func(array, func, type);

>> The constant is used only inside cpuid.c, so the rename is NFC outside this
>> file.
>>
>> Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index e2836a255b16..beb83eaa1868 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1811,7 +1811,7 @@ static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>>        return __do_cpuid_func(array, func);
>>   }
>>
>> -#define CENTAUR_CPUID_SIGNATURE 0xC0000000
>> +#define ZHAOXIN_CPUID_SIGNATURE 0xC0000000
>>
>>   static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>>                          unsigned int type)
>> @@ -1819,8 +1819,9 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>>        u32 limit;
>>        int r;
>>
>> -     if (func == CENTAUR_CPUID_SIGNATURE &&
>> -         boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
>> +     if (func == ZHAOXIN_CPUID_SIGNATURE &&
>> +             boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
>> +             boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)
> Align indentation.

Will fix in v2.

>
>          if (func == CENTAUR_CPUID_SIGNATURE &&
>              boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
>              boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)
>                  return 0;
>
>>                return 0;
>>
>>        r = do_cpuid_func(array, func, type);
>> @@ -1869,7 +1870,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>>                            unsigned int type)
>>   {
>>        static const u32 funcs[] = {
>> -             0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
>> +             0, 0x80000000, ZHAOXIN_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
>>        };
>>
>>        struct kvm_cpuid_array array = {
>> --
>> 2.34.1
>>



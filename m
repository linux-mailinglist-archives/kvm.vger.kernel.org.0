Return-Path: <kvm+bounces-49220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C85AD66A2
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 06:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06D3C17A28A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6D71F3FE2;
	Thu, 12 Jun 2025 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ndRNcXpT"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDF31CD215;
	Thu, 12 Jun 2025 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749701065; cv=none; b=P81CBr8lGorlV0Gdhk1LesAxyuQwOU32Eeu7Er4r8VdO/kqFRt7hY8Yf/TZMR/Pfmv3IUmnyALY0VLJwrso1FoKRTpYiaiIB/8wycCW4rzFuI80CmPBrMEgQEsE5wP4/kFYPmaww658IDvV2zWUFJASfImxqXzk+lz626ivZb0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749701065; c=relaxed/simple;
	bh=xKb9o3o0Pi6obermwftLLvTLAPVUA0XdFF0PKpcd6Hg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XlutbEcKOpNkq/Vwg+DM0PmGr+GgydKBEe0Kg2U53nvIPe/qAVKX6YFRIqQSfyp03co8PRU+o8jYQunnTm3LgqGAE/qG7elu8oT4x+FwxVLOao0rOESokrkalE2z7sYfAzzNy8C6p22WzKuz7oxQR8gJFp7POttsNFnivIb534A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ndRNcXpT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.79.224.160] (unknown [4.194.122.136])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9E734201C751;
	Wed, 11 Jun 2025 21:04:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9E734201C751
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749701062;
	bh=hZxHlFKTBoWfN8DHCEcobl8Oo+xVuthLLtzu+mVgeVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ndRNcXpTBHVObj5m7WQoqXHz/EYR70Qu93sBwuIDmQKLNZuWZWE/KAjGQWeEDwetN
	 0/XSIIwxjZ9vCcOnGUDoI2e8T0q+CheoUIMUz/JLawaeWJPR1x5yfmGLyGxNkiGLXI
	 qs75fC4J2K24CeMcQM1jjXSXp1iTLATqMe3Kq978=
Message-ID: <426e8d83-1cc9-4812-b1c5-488d252350ec@linux.microsoft.com>
Date: Thu, 12 Jun 2025 09:34:09 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] KVM: x86: hyper-v: Fix warnings for missing export.h
 header inclusion
To: Sean Christopherson <seanjc@google.com>
Cc: "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Konstantin Taranov <kotaranov@microsoft.com>,
 Leon Romanovsky <leon@kernel.org>, Long Li <longli@microsoft.com>,
 Shiraz Saleem <shirazsaleem@microsoft.com>,
 Shradha Gupta <shradhagupta@linux.microsoft.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
 Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org, linux-pci@vger.kernel.org
References: <20250611100459.92900-1-namjain@linux.microsoft.com>
 <20250611100459.92900-4-namjain@linux.microsoft.com>
 <aEl9kO81-kp0hhw0@google.com>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <aEl9kO81-kp0hhw0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:28 PM, Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Naman Jain wrote:
>> Fix below warning in Hyper-V drivers
> 
> KVM is quite obviously not a Hyper-V driver.
> 
>> that comes when kernel is compiled with W=1 option. Include export.h in
>> driver files to fix it.  * warning: EXPORT_SYMBOL() is used, but #include
>> <linux/export.h> is missing
> 
> NAK.  I agree with Heiko[*], this is absurd.  And if the W=1 change isn't reverted
> for some reason, I'd rather "fix" all of KVM in one shot, not update random files
> just because of their name.
> 
> Sorry.
> 
> [*] https://lore.kernel.org/all/20250611075533.8102A57-hca@linux.ibm.com
> 

Sure, thanks for reviewing.

Regards,
Naman

>> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
>> ---
>>   arch/x86/kvm/hyperv.c       | 1 +
>>   arch/x86/kvm/kvm_onhyperv.c | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 24f0318c50d7..09f9de4555dd 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -33,6 +33,7 @@
>>   #include <linux/sched/cputime.h>
>>   #include <linux/spinlock.h>
>>   #include <linux/eventfd.h>
>> +#include <linux/export.h>
>>   
>>   #include <asm/apicdef.h>
>>   #include <asm/mshyperv.h>
>> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
>> index ded0bd688c65..ba45f8364187 100644
>> --- a/arch/x86/kvm/kvm_onhyperv.c
>> +++ b/arch/x86/kvm/kvm_onhyperv.c
>> @@ -5,6 +5,7 @@
>>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>   
>>   #include <linux/kvm_host.h>
>> +#include <linux/export.h>
>>   #include <asm/mshyperv.h>
>>   
>>   #include "hyperv.h"
>> -- 
>> 2.34.1
>>



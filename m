Return-Path: <kvm+bounces-50780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB58AE9364
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6FB4A4B7C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E0615ADB4;
	Thu, 26 Jun 2025 00:25:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCB139579
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750897527; cv=none; b=sBTqDPVcOjFfu+Rysf9yUi/yKvGsAcrQBa8ZtSdJWcNuRbCi5DjMg+LhTFKVV8iU/TMNqJozh64Xq4r1iAb6B49kS7/tlrajMH/sh8gBQHc8hB2qsLWsPX1hH0wZhbl/ZfFcuZo4hFHFRWpCmy+7FufbGoNsvvIpZwyMhSMNI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750897527; c=relaxed/simple;
	bh=5glaJYClkEJRDJXNd36NlkI3O4vAJGqaeXBSMvXyj/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lh6fE7LbiUdp+TFEC0BhjFlM8v4pIoPJYMs8ZZQakLdOrBLZAYvkOJ5tiXDJQhdD3bcE5LQKMvsnt0cWr6ljsr+zZ6W93DdrC3XukJ9xuqVFrWqSkaZnrMfgVTT9xEHCxN7johedtlrU1k0G4JHUVbqQspHCdz+xJmqRcUoxu1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1750897517-1eb14e1c381a7c0001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx2.zhaoxin.com with ESMTP id f3HA5r8FA8vqbh79 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 26 Jun 2025 08:25:17 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Thu, 26 Jun
 2025 08:25:17 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Thu, 26 Jun 2025
 08:25:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 25 Jun
 2025 18:05:46 +0800
Message-ID: <4833e1be-b38d-4f80-abb7-aff2782efcfb@zhaoxin.com>
Date: Wed, 25 Jun 2025 18:05:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
To: Zhao Liu <zhao1.liu@intel.com>
X-ASG-Orig-Subj: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Babu Moger
	<babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Tejus GK
	<tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>, Manish Mishra
	<manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <cobechen@zhaoxin.com>,
	<yeeli@zhaoxin.com>, <MaryFeng@zhaoxin.com>, <Runaguo@zhaoxin.com>,
	<Xanderchen@zhaoxin.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
 <fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com>
 <aFu/EED7BNJgIXqH@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <aFu/EED7BNJgIXqH@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 6/26/2025 8:25:15 AM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1750897517
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3356
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -0.81
X-Barracuda-Spam-Status: No, SCORE=-0.81 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA085b, DATE_IN_PAST_12_24, DATE_IN_PAST_12_24_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.143396
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 DATE_IN_PAST_12_24     Date: is 12 to 24 hours before Received: date
	0.40 BSF_SC0_SA085b         Custom Rule SA085b
	0.80 DATE_IN_PAST_12_24_2   DATE_IN_PAST_12_24_2



On 6/25/25 5:19 PM, Zhao Liu wrote:
> 
> 
> Just want to confirm with the "lines_per_tag" field, which is related
> about how to handle current "assert(lines_per_tag > 0)":
> 
>> --- patch prototype start ---
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 7b223642ba..8a17e5ffe9 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -2726,6 +2726,66 @@ static const CPUCaches xeon_srf_cache_info = {
>>       },
>>   };
>>
>> +static const CPUCaches yongfeng_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
> 
> This fits AMD APM, and is fine.
> 
>> +        .inclusive = false,
>> +        .self_init = true,
>> +        .no_invd_sharing = false,
>> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 64 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 16,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
> 
> Fine, too.
> 
>> +        .inclusive = false,
>> +        .self_init = true,
>> +        .no_invd_sharing = false,
>> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>> +    },
>> +    .l2_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 2,
>> +        .size = 256 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 512,
>> +        .lines_per_tag = 1,
> 
> SDM reserves this field:
> 
> For 0x80000006 ECX:
> 
> Bits 11-08: Reserved.
> 
> So I think this field should be 0, to align with "Reserved".

I agree. For Zhaoxin, the "lines-per-tag" field appears only in CPUID leaf 
0x80000005. Because Zhaoxin follows AMD behavior on this leaf, and the AMD 
manual states that it reports L1 cache/TLB information, so any "lines-per-tag" 
value for levels other than L1 should be omitted or set to zero.

> 
> In this patch:
> 
> https://lore.kernel.org/qemu-devel/20250620092734.1576677-9-zhao1.liu@intel.com/
> 
> I add an argument (lines_per_tag_supported) in encode_cache_cpuid80000006(),
> and for the case that lines_per_tag_supported=false, I assert
> "lines_per_tag == 0" to align with "Reserved".
> 
>> +        .inclusive = true,
>> +        .self_init = true,
>> +        .no_invd_sharing = false,
>> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>> +    },
>> +    .l3_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 3,
>> +        .size = 8 * MiB,
>> +        .line_size = 64,
>> +        .associativity = 16,
>> +        .partitions = 1,
>> +        .sets = 8192,
>> +        .lines_per_tag = 1,
> 
> The 0x80000006 EDX is also reserved in SDM. So I think this field should
> be 0, too.
> 
> Do you agree?

Ditto.>
>> +        .self_init = true,
>> +        .inclusive = true,
>> +        .no_invd_sharing = true,
>> +        .complex_indexing = false,
>> +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
>> +    },
>> +};
>> +



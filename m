Return-Path: <kvm+bounces-44246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C5F4A9BE2B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E0659A03C1
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 05:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA3C22A7E8;
	Fri, 25 Apr 2025 05:50:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC02610957
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745560237; cv=none; b=EWB9olQ9JPlnbRldc1VSBY9z7OkimGJI4o3oNWup9MAqDUBjjOlkStlxhmcl0odvF/TMT6gEX37/iXrKkislbkLErKMwq/b7DEU828K8basBRJXiomosF0OWzGCWPsxhpWr2iATbxsFfFBh6azaTWlBpHKkWDPJA8VfGIexkHGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745560237; c=relaxed/simple;
	bh=g9CkTpcU6Wjrz309PAXUi9zHKV8t5ROZ05wDlvea+vI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HSKxQ+mfo1WdsSPDLbsgUz6ri50v2HFbqrtcff32m/wNp80ehfye1CLupRw2T2H/xOCQhPdOUvSQdv3XeaonjeEaKOTsTRegxWCImAWvsP6ezArEuVbMjygwF9uiXUXKPSabNLb73vYV0KkGlc8cY+LF4P1tYO3UJVAaaIMryUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1745560220-086e234ccebe3a0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id CzmEFEBrOJKbujBo (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 25 Apr 2025 13:50:20 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX3.zhaoxin.com (10.28.252.165) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Fri, 25 Apr
 2025 13:50:20 +0800
Received: from ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2]) by
 ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2%6]) with mapi id
 15.01.2507.044; Fri, 25 Apr 2025 13:50:20 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Thu, 24 Apr
 2025 21:44:35 +0800
Message-ID: <c522ebb5-04d5-49c6-9ad8-d755b8998988@zhaoxin.com>
Date: Thu, 24 Apr 2025 21:44:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>
X-ASG-Orig-Subj: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
CC: Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Tejus
 GK" <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>, Manish Mishra
	<manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <20250423114702.1529340-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 4/25/2025 1:50:19 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1745560220
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2968
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.140462
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 4/23/25 7:46 PM, Zhao Liu wrote:
> 
> Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
> "assert" check blocks adding new cache model for non-AMD CPUs.
> 
> Therefore, check the vendor and encode this leaf as all-0 for Intel
> CPU. And since Zhaoxin mostly follows Intel behavior, apply the vendor
> check for Zhaoxin as well.

Thanks for taking Zhaoxin CPUs into account.

Zhaoxin follows AMD's definition for CPUID leaf 0x80000005, so this leaf is 
valid on our CPUs rather than reserved. We do, however, follow Intel's 
definition for leaf 0x80000006.

> Note, for !vendor_cpuid_only case, non-AMD CPU would get the wrong
> information, i.e., get AMD's cache model for Intel or Zhaoxin CPUs.
> For this case, there is no need to tweak for non-AMD CPUs, because
> vendor_cpuid_only has been turned on by default since PC machine v6.1.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1b64ceaaba46..8fdafa8aedaf 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7248,11 +7248,23 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
>           break;
>       case 0x80000005:
> -        /* cache info (L1 cache) */
> -        if (cpu->cache_info_passthrough) {
> +        /*
> +         * cache info (L1 cache)
> +         *
> +         * For !vendor_cpuid_only case, non-AMD CPU would get the wrong
> +         * information, i.e., get AMD's cache model. It doesn't matter,
> +         * vendor_cpuid_only has been turned on by default since
> +         * PC machine v6.1.
> +         */
> +        if (cpu->vendor_cpuid_only &&
> +            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {

Given that, there is no need to add IS_ZHAOXIN_CPU(env) to the 0x80000005 path. 
Note that the L1 TLB constants for the YongFeng core differ from the current 
values in target/i386/cpu.c(YongFeng defaults shown in brackets):

#define L1_DTLB_2M_ASSOC       1 (4)
#define L1_DTLB_2M_ENTRIES   255 (32)
#define L1_DTLB_4K_ASSOC       1 (6)
#define L1_DTLB_4K_ENTRIES   255 (96)

#define L1_ITLB_2M_ASSOC       1 (4)
#define L1_ITLB_2M_ENTRIES   255 (32)
#define L1_ITLB_4K_ASSOC       1 (6)
#define L1_ITLB_4K_ENTRIES   255 (96)

I am still reviewing how these constants flow through cpu_x86_cpuid() for leaf 
0x80000005, so I'm not yet certain whether they are overridden.

For now, the patchset can ignore Zhaoxin in leaf 0x80000005. Once I have traced 
the code path, I will send an update if needed. Please include Zhaoxin in the 
handling for leaf 0x80000006.

I should have sent this after completing my review, but I did not want to delay 
your work. Sorry for the noise.

Thanks again for your work.



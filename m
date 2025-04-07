Return-Path: <kvm+bounces-42835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C00B1A7DB63
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 12:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CBCE188C36F
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D8D236A9F;
	Mon,  7 Apr 2025 10:43:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450207DA7F
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744022607; cv=none; b=D/DBzXH617HGe4LForg7QJ+hU8KQKrUk1tdEmG1RMLJKk7RIPDPeBHmXuxK18y2iz6PepUsuEEzVA8/khV4CmfiKJYMbu4IFWD4It/AT3mtZhF1p3VcxN0Rr4J5ccwOYDIawuV0WBUEIX26UaGhsvmlRhCGCvoAdX56ho1itB1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744022607; c=relaxed/simple;
	bh=ul7hq6IFDRo98yOCGnCAGxjXuqWlZ6y3OyUWg3t3RIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mABnQa5xyEE/ymxROd0gWoVXCvA52YkCvngQASQT3HW4T4aLJ0Hlo0+IPAL2wShhK4L8r2ldU8p5/KOs34IlRqbRY53jR2ZqKP+7I9kKqxWTqEFg0DDYdbOsNk5JICbSZtlqLh2QaTutkv7yIAg3z+D5IodNP5UCHC7qGSAzKfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1744022597-1eb14e119e08610001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id ONaZwJBZzTrNwFRq (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 07 Apr 2025 18:43:17 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX3.zhaoxin.com (10.28.252.165) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 7 Apr
 2025 18:43:17 +0800
Received: from ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2]) by
 ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2%6]) with mapi id
 15.01.2507.044; Mon, 7 Apr 2025 18:43:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Mon, 7 Apr
 2025 17:33:15 +0800
Message-ID: <94e8451f-1b44-4e22-8e3f-378c8490cf00@zhaoxin.com>
Date: Mon, 7 Apr 2025 17:33:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Zhao Liu <zhao1.liu@intel.com>
X-ASG-Orig-Subj: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
CC: Dongli Zhang <dongli.zhang@oracle.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <pbonzini@redhat.com>, <mtosatti@redhat.com>,
	<sandipan.das@amd.com>, <babu.moger@amd.com>, <likexu@tencent.com>,
	<like.xu.linux@gmail.com>, <zhenyuw@linux.intel.com>, <groug@kaod.org>,
	<khorenko@virtuozzo.com>, <alexander.ivanov@virtuozzo.com>,
	<den@virtuozzo.com>, <davydov-max@yandex-team.ru>, <xiaoyao.li@intel.com>,
	<dapeng1.mi@linux.intel.com>, <joe.jin@oracle.com>, <ewanhai@zhaoxin.com>,
	<cobechen@zhaoxin.com>, <louisqi@zhaoxin.com>, <liamni@zhaoxin.com>,
	<frankzhu@zhaoxin.com>, <silviazhao@zhaoxin.com>, <yeeli@zhaoxin.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
 <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
 <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
 <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
 <65a6e617-8dd8-46ee-b867-931148985e79@zhaoxin.com>
 <Z/OSEw+yJkN89aDG@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <Z/OSEw+yJkN89aDG@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 4/7/2025 6:43:15 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1744022597
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2128
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=TRACK_DBX_001
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.139615
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 TRACK_DBX_001          Custom rule TRACK_DBX_001



On 4/7/25 4:51 PM, Zhao Liu wrote:

> 
> On Tue, Apr 01, 2025 at 11:35:49AM +0800, Ewan Hai wrote:
>> Date: Tue, 1 Apr 2025 11:35:49 +0800
>> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
>> Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers
>>   during VM reset
>>
>>>> [2] As mentioned in [1], QEMU always sets the vCPU's vendor to match the host's
>>>> vendor
>>>> when acceleration (KVM or HVF) is enabled. Therefore, if users want to emulate a
>>>> Zhaoxin CPU on an Intel host, the vendor must be set manually.Furthermore,
>>>> should we display a warning to users who enable both vPMU and KVM acceleration
>>>> but do not manually set the guest vendor when it differs from the host vendor?
>>>
>>> Maybe not? Sometimes I emulate AMD on Intel host, while vendor is still the
>>> default :)
>>
>> Okay, handling this situation can be rather complex, so let's keep it
>> simple. I have added a dedicated function to capture the intended behavior
>> for potential future reference.
>>
>> Anyway, Thanks for taking Zhaoxin's situation into account, regardless.
>>
> 
> Thanks for your code example!!
> 
> Zhaoxin implements perfmon v2, so I think checking the vendor might be
> overly complicated. If a check is needed, it seems more reasonable to
> check the perfmon version rather than the vendor, similar to how avx10
> version is checked in x86_cpu_filter_features().
> 
> I understand Ewan's concern is that if an Intel guest requires a higher
> perfmon version that the Zhaoxin host doesn't support, there could be
> issues (although I think this situation doesn't currently exist in KVM-QEMU,
> one reason is QEMU uses the pmu_version in 0xa queried from KVM directly,
> which means QEMU currently doesn't support custom pmu_version).

Yeah, that's exactly what I was concerned about.
Thanks for clearing that up!

perfmon_version is a great idea --- I might add it as a property to the QEMU 
vCPU template in the future, so it can adjust based on user input and host support.
Can't promise a timeline yet, but it's definitely something I'll keep in mind.


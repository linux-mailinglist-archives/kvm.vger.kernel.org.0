Return-Path: <kvm+bounces-47780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AACA8AC4BE5
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 12:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 055533B9452
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD15E254841;
	Tue, 27 May 2025 10:00:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4925A2BF
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748340014; cv=none; b=TVUZWOSgi53nZwMMCZXIY+K0QLD0v2IYrSexA/tk+giukNRGJxG2jnFJ+KYDNRa1TvsozW5+MsWCiuCUFrNaO6cO4mwRwdX2+f8BOtlWuo5jwGwRUrEBs/MkeFmF8YLNdE2SMM+NqCAKSOFXXBr/pWGEiahUVE7GjQo4nFviIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748340014; c=relaxed/simple;
	bh=2lKKRF+LQL7Cj9GToriW2IHmoXsLaxOR20OkV5idBI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cvFuf9FySHyyh1uQvTNBn6+5BnqMP/lGS0xjS9UIviB2dYVHcDor5kIcRwrpXI4GpMMa/sjyCkl42CL3ydkNh65K4M3NA7WJqK9XZ7dQzuhlg6LlT8KG5Rm1qsFxkHLEUSvO7gJTCbRpR5EQhwfS17Bbn6vrShK3rc+weSRD/I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1748340008-1eb14e386e34fda0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id u4jmqXkKdH8W3DKk (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 27 May 2025 18:00:08 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 27 May
 2025 18:00:08 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Tue, 27 May 2025
 18:00:08 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Tue, 27 May
 2025 17:58:28 +0800
Message-ID: <2799f5e0-cb70-4f10-a472-b47e2c3011d4@zhaoxin.com>
Date: Tue, 27 May 2025 17:58:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo
 CPUID enhencement
To: Zhao Liu <zhao1.liu@intel.com>
X-ASG-Orig-Subj: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo
 CPUID enhencement
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Babu Moger
	<babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Tejus GK
	<tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>, Manish Mishra
	<manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <c3ecc32c-badd-487e-a2df-0594661bc65e@zhaoxin.com>
 <aDWDvygfMR/cHJx2@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <aDWDvygfMR/cHJx2@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 5/27/2025 6:00:07 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1748340008
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1309
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.141989
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 5/27/25 5:19 PM, Zhao Liu wrote:
> 
> On Mon, May 26, 2025 at 06:52:41PM +0800, Ewan Hai wrote:
>> Date: Mon, 26 May 2025 18:52:41 +0800
>> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
>> Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model &
>>   topo CPUID enhencement
>>
>>
>>
>> On 4/23/25 7:46 PM, Zhao Liu wrote:
>>> Hi all,
>>>
>>> (Since patches 1 and 2 involve changes to x86 vendors other than Intel,
>>> I have also cc'd friends from AMD and Zhaoxin.)
>>>
>>> These are the ones I was going to clean up a long time ago:
>>>    * Fixup CPUID 0x80000005 & 0x80000006 for Intel (and Zhaoxin now).
>>>    * Add cache model for Intel CPUs.
>>>    * Enable 0x1f CPUID leaf for specific Intel CPUs, which already have
>>>      this leaf on host by default.
>>
>> If you run into vendor specific branches while refactoring the
>> topology-related code, please feel free to treat Intel and Zhaoxin as one
>> class. For every topology CPUID leaf(0x0B, 0x1F, ...) so far, Zhaoxin has
>> followed the Intel SDM definition exactly.
> 
> Thank you for your confirmation. I'll post v2 soon (If things go well,
> it'll be in the next two weeks. :-) )

No rush, everyone is busy, maintainers especially so. Just handle it whenever it 
best fits your schedule.



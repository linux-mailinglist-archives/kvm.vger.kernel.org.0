Return-Path: <kvm+bounces-47706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03AEBAC3E4D
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BDCC3B9C77
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E081F8744;
	Mon, 26 May 2025 11:07:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069201F9F70
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 11:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748257649; cv=none; b=F7BA5qYLhkDlNVwl9mt15256KsHsmkLkHw2VR4dIHma78JANC92wBfEXwllZJsah8lhPoL1bAE78TpxTD9Sk63wSQKvIwWmDEhfzCxu+t04B7A/LwdXcU4c9rokd+T/HFOIlwImn4vPNfJEud9OpTRJdGrI9KjgKNTahWy42qdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748257649; c=relaxed/simple;
	bh=eLlTCJIRE/RO6kjebWn2knKMyHtL/Q3krWiIXjG5yDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QUwclBO8YXGgFlnMC9WhEZqSCX6jvOLpiDQQbcF3r1v34kyX3+4ShUlvRuK3II8yL6uxLEjHWj6GqnMu8rjFP0aR5gz/6asT5kD1tIU/EkTcfpf5L85EmCWuXPhinFOJAbP3ZFoh/hRpCIiSUzWNHnl6CZAATW2/771sgBvTrJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1748257637-1eb14e386d34be70001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id ePyeVfIWlE4kHRXn (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 26 May 2025 19:07:17 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 26 May
 2025 19:07:16 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Mon, 26 May 2025
 19:07:16 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 26 May
 2025 18:52:42 +0800
Message-ID: <c3ecc32c-badd-487e-a2df-0594661bc65e@zhaoxin.com>
Date: Mon, 26 May 2025 18:52:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo
 CPUID enhencement
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>
X-ASG-Orig-Subj: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo
 CPUID enhencement
CC: Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Tejus
 GK" <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>, Manish Mishra
	<manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 5/26/2025 7:07:15 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1748257637
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 734
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.141943
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 4/23/25 7:46 PM, Zhao Liu wrote:
> Hi all,
> 
> (Since patches 1 and 2 involve changes to x86 vendors other than Intel,
> I have also cc'd friends from AMD and Zhaoxin.)
> 
> These are the ones I was going to clean up a long time ago:
>   * Fixup CPUID 0x80000005 & 0x80000006 for Intel (and Zhaoxin now).
>   * Add cache model for Intel CPUs.
>   * Enable 0x1f CPUID leaf for specific Intel CPUs, which already have
>     this leaf on host by default.

If you run into vendor specific branches while refactoring the topology-related 
code, please feel free to treat Intel and Zhaoxin as one class. For every 
topology CPUID leaf(0x0B, 0x1F, ...) so far, Zhaoxin has followed the Intel SDM 
definition exactly.


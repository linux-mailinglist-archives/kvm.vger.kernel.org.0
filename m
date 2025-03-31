Return-Path: <kvm+bounces-42264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEBDA76F67
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11404164288
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 20:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300C121ADC5;
	Mon, 31 Mar 2025 20:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Z4KFFf20"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A51BBBFD;
	Mon, 31 Mar 2025 20:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743453232; cv=none; b=saBpqFedm541IzygEb6UJknwe2Ix/rqlHWUSSyDptRDtvqDoxNM6pxBYYtFH9MPH762MGfvcxYPfBylv4/4dExYg76IrQOCiWCk9P7OpSndsOnWml6XJDQsuuRVCHCCP+HG9k2IsTqNb+W55XfiI/O8kB4aPQrpJto4meTITl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743453232; c=relaxed/simple;
	bh=c2UV0LQ0uKecBVFY2BqHPj+KlQwpu911b6y9CvieRMM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=a1RJrp0dnaW4a2o36MPkwWXZ2OFxtmgfcJSgEFRA2z6XckTkrCZ/+XxVACOWYJ/rQidYIDOVjDq0S8YEwBm+dRcdVu920zbvCaQvqZQIYg5fVHk7NNar0YlHIHRXNF6wCIZyDnpDz0nVda11FJuke3OpVFT64hhdKDuvR/ONZZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Z4KFFf20; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52VKX0M73412381
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 31 Mar 2025 13:33:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52VKX0M73412381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743453183;
	bh=x7/smMOdPkYBe+t7QfoSlZKr+k8BBZp4ioXVR2T0his=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Z4KFFf201sZydaNbvnLKcIFsMDrRsRhjp8bCSzYq7irlJscPCzdUI+8Dh4pqCCfV4
	 ma0aiKDH5Cg73nGZwNOvjvhtZagcXOcQ9p2pYNsCc45pMH4VWAZVeIr/shFTXOyoJT
	 59zF4BynSpJMyvMuqGTq9ieFHT39HOkA0HdIKxpHd/yvEWkvuEK7rGz99DeXh2OChY
	 Zn0hvSP59z7ec+xOZ7nTecOJAXBz/IE20VtgatRaj322fOCOFRQHF4aywsa6ze8XYD
	 fG5J1+Jt7zMsFRAlcpYJxihjmqzIyqp5Hnp/IhNJbmgWmvn330XKZNgzjeZAZMX0yB
	 LqLmBrw0GOEjQ==
Date: Mon, 31 Mar 2025 13:32:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v1_01/15=5D_x86/msr=3A_Re?=
 =?US-ASCII?Q?place_=5F=5Fwrmsr=28=29_with_native=5Fwrmsrl=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Z-pruogreCuU66wm@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-2-xin@zytor.com> <Z-pruogreCuU66wm@gmail.com>
Message-ID: <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 31, 2025 3:17:30 AM PDT, Ingo Molnar <mingo@kernel=2Eorg> wrote:
>
>* Xin Li (Intel) <xin@zytor=2Ecom> wrote:
>
>> -	__wrmsr      (MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3, val >> 32);
>> +	native_wrmsrl(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
>
>This is an improvement=2E
>
>> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
>> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)plr->closid << 32 | rmid_p);
>
>> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
>> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)closid_p << 32 | rmid_p);
>
>This is not an improvement=2E
>
>Please provide a native_wrmsrl() API variant where natural [rmid_p, closi=
d_p]
>high/lo parameters can be used, without the shift-uglification=2E=2E=2E
>
>Thanks,
>
>	Ingo

Directing this question primarily to Ingo, who is more than anyone else th=
e namespace consistency guardian:

On the subject of msr function naming =2E=2E=2E *msrl() has always been mi=
sleading=2E The -l suffix usually means 32 bits; sometimes it means the C t=
ype "long" (which in the kernel is used instead of size_t/uintptr_t, which =
might end up being "fun" when 128-bit architectures appear some time this c=
entury), but for a fixed 64-but type we normally use -q=2E

Should we rename the *msrl() functions to *msrq() as part of this overhaul=
?


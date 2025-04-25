Return-Path: <kvm+bounces-44331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F4AA9CCFD
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 17:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DDFB7B2536
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88268289367;
	Fri, 25 Apr 2025 15:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iQ+XMvqc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBB2749C3;
	Fri, 25 Apr 2025 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745594991; cv=none; b=p+2/m9aoGWyvqjTN27hyjPk/68HMxh2ps09+P8FguZNx5ANXLB27zszEavWFrnslIJvTpF7yZZRGZ8iGFMTcOv+GhEGMf/qZFWtLUFtpQRdb1NFmSKssTHI7jlrwYJ733LJs0BBjDIyFr4eT+yc38PvVoGYocOhwM6JWRwor2AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745594991; c=relaxed/simple;
	bh=HV6VAWyHmVnGscrHkhlxywgfLhBCIOaIqAHKg4TF8Ww=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=CEjI/BhOkBNCXCHHp73i1NJ05iqWhLndGemJFozDQq/4pl/MLffrYcsh5dYMJivH6IPoaaiCoOkgLFI+5pzEeo8rKHBa6W4ByJbRBhcf93TubsbxQGbMCFwyw7juPSUAWuWzuc08qyZXwt1wsVjKEAb/WtJss6YMqM6pPa/URDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iQ+XMvqc; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53PFTBaV2880069
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 25 Apr 2025 08:29:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53PFTBaV2880069
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745594953;
	bh=HV6VAWyHmVnGscrHkhlxywgfLhBCIOaIqAHKg4TF8Ww=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=iQ+XMvqcZNxnOa/I9EZR/mshfDVcYq+cePk2TG9e54uOwCvKB3Jjm1xPdmYlOwRHP
	 DQZfYPcgHJ15ycfkCO44CHxAPNtKlEpwO+e3HbxLS3WN5m2GlJgLqWvrW6B8D4o5ub
	 Zes9COz/AXoKuLU158cfbQSbTaxvthVom0W4PheBM19CU1DpvbPqSU/MWFk1vVebut
	 H1I+EYvdBYhAeTwxxohUMZyQi5+jbZbMqhhRx83ibCp8qGgDSmy4rn/uqaOKU2J8Xd
	 bhvIxW5HPWNJCE2YRbuH/hDPmgfebrJ9qBuyd4/X+QvQ9OurZ3B/Ph0cuuoO0f3nvo
	 c91K5uZbr30YA==
Date: Fri, 25 Apr 2025 08:29:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
CC: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
        andrew.cooper3@citrix.com, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v2_21/34=5D_x86/msr=3A_Utiliz?=
 =?US-ASCII?Q?e_the_alternatives_mechanism_to_write_MSR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20250425123317.GB22125@noisy.programming.kicks-ass.net>
References: <20250422082216.1954310-1-xin@zytor.com> <20250422082216.1954310-22-xin@zytor.com> <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com> <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com> <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com> <20250425123317.GB22125@noisy.programming.kicks-ass.net>
Message-ID: <E1BAF52C-A955-466A-B5A2-DE12876FBFCF@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 25, 2025 5:33:17 AM PDT, Peter Zijlstra <peterz@infradead=2Eorg> w=
rote:
>On Wed, Apr 23, 2025 at 06:05:19PM +0200, J=C3=BCrgen Gro=C3=9F wrote:
>
>> > It's not a major change, but when it is patched to use the immediate
>> > form MSR write instruction, it's straightforwardly streamlined=2E
>>=20
>> It should be rather easy to switch the current wrmsr/rdmsr paravirt pat=
ching
>> locations to use the rdmsr/wrmsr instructions instead of doing a call t=
o
>> native_*msr()=2E
>
>Right, just make the Xen functions asm stubs that expect the instruction
>registers instead of C-abi and ALT_NOT_XEN the thing=2E
>
>Shouldn't be hard at all=2E

And that's what we will be doing=2E We already have code for that=2E


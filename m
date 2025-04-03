Return-Path: <kvm+bounces-42538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1B3A79BB7
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7BEF188FD4D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CBC1A23A6;
	Thu,  3 Apr 2025 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WPP0bDZK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B498CA6B;
	Thu,  3 Apr 2025 06:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743660142; cv=none; b=p4sfFHd9+kJL3f50t1VWdW12YAoWKvGSwO159N27wUsSr0104EF4FLPB5BazBdQyJiYSR+HZXTohbIxVWitIQxwDQgMruTJMzSyvUKohs8zlRCfMpIE+CXNnMA1KDYQ6cZcaZxY1N2h6TGC8Pl8XFUfQVev1GuZFC2hO4x2vjgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743660142; c=relaxed/simple;
	bh=HBSjt3ceb+310hVs/mwgzhbbqG3Jl2AAvf0AdIVfBLA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=cqLCGjA2TT1uRNQ9h92X4RE/a1m0ws/XvpB5KSy/cK6dfrlCx13MyyAxWq78IG8YKInLGnsVU2Wz9bbZzB44Dlnw/t1sCpV5NgH0r95e3dty9OjBHWEBAEY7NXd6OptmLIb9jvMq8B5YCWTsYz5BAt3lhH7xQHrS9NRZ2B8AE5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WPP0bDZK; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53361TVl369646
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 2 Apr 2025 23:01:30 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53361TVl369646
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743660093;
	bh=dlct/QjME2ZRc2GbrZa4+YEUwLyiwmon1oWoqtApkXY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WPP0bDZK1lApqNXdOtF12S5ARISaib9mLKSdGhnx3gf+KvTavErQMB5tHsDboEZaM
	 dLsgA/Wr4k2VPAKvg4Q/jtE0gFB4ojRvE+oKmyqXmPeIVyoZtruCTjMkDVanwskwS+
	 jiuGUYw2dmNjKOKZNCiNGXO9zxp8lWX1y5seDxftNeQHvt8RBeGECAiOxqTKUMgh1b
	 zD9Kyl+NSFQ59y87oScNqVpMXyezROjMwevUzZS+FRy/CxOc3SftPfgsBUCB4x+623
	 2LcVsu0VnYA1sp4yMqo6TRQHgTa6YRFjMp5wTke1MjTH1hw4LpEw+MZO87TrcY7Ja6
	 ziwf36ftnA50g==
Date: Wed, 02 Apr 2025 23:01:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Ingo Molnar <mingo@kernel.org>
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
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v1_01/15=5D_x86/msr=3A_Re?=
 =?US-ASCII?Q?place_=5F=5Fwrmsr=28=29_with_native=5Fwrmsrl=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <c316a6c6-b97c-48b2-9598-d44e2ec72fbc@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-2-xin@zytor.com> <Z-pruogreCuU66wm@gmail.com> <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com> <Z-ubVFyoOzwKhI53@gmail.com> <c316a6c6-b97c-48b2-9598-d44e2ec72fbc@zytor.com>
Message-ID: <580DD4EE-8694-4525-AA73-A6823126FF9F@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 2, 2025 10:09:21 PM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/1/2025 12:52 AM, Ingo Molnar wrote:
>>> Should we rename the *msrl() functions to *msrq() as part of this
>>> overhaul?
>> Yeah, that's a good idea, and because talk is cheap I just implemented
>> this in the tip:WIP=2Ex86/msr branch with a couple of other cleanups in
>> this area (see the shortlog & diffstat below), but the churn is high:
>>=20
>>    144 files changed, 1034 insertions(+), 1034 deletions(-)
>
>Hi Ingo,
>
>I noticed that you keep the type of MSR index in these patches as
>"unsigned int"=2E
>
>I'm thinking would it be better to standardize it as "u32"?
>
>Because:
>1) MSR index is placed in ECX to execute MSR instructions, and the
>   high-order 32 bits of RCX are ignored on 64-bit=2E
>2) MSR index is encoded as a 32-bit immediate in the new immediate form
>   MSR instructions=2E
>
>Thanks!
>    Xin

"unsigned int" and "u32" are synonymous, but the latter is more explicit a=
nd would be better=2E


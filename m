Return-Path: <kvm+bounces-61983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F62C31A00
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 15:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21E651896854
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 14:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF80330B37;
	Tue,  4 Nov 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BR6iMq/o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A12E33030C;
	Tue,  4 Nov 2025 14:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762267614; cv=none; b=dLuhmDqYwYEt0ni9OBrfFmwUCqXuHr0B7xIbaISvmYAckvxfvs2wg2//AHjT+hdlNjO/cGI8x/Sha7aTk7ZbYEarmkfqc59sWScyCjEgwG823ivCDOM/bQeqWcFFp4yj9LMWTJ6MYwaFY7zCoCeIzUWlfn+b2C3dUSR2kDP1Ktc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762267614; c=relaxed/simple;
	bh=p5hPIDaRZCzt92kFfvg6R3vu6oORTHx9zKqVYsgt6JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCfXGKVBPE5WvG6+pBCmxM3/PllHuUDJkPd3EpeXa1Z7GL59SpoeQb56CQJD+BPghjEsFHMLbzaN7Raaf2hQTtu77ukg0gggWpxLW6ssC4wvLNYf1jdakH18gTHRijhiQDj1C+PaNnP5kJsOEzl3WYWjPJtonA+ULppBLrHTLQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BR6iMq/o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10EC4CEF7;
	Tue,  4 Nov 2025 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762267614;
	bh=p5hPIDaRZCzt92kFfvg6R3vu6oORTHx9zKqVYsgt6JI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BR6iMq/oPyikLtPw6az2lrms+Ge4xlCbIe4fTtTyY4tHC2n45aUuCaBWJvcHF/A2p
	 KG+L13PEc2RsLTe2Mk23kete59d+Q1weoVYh9oZ41Lcj9tYM2y+3AgeUK0+VINu39M
	 +JpI0LM2k4BtTsZKgmnBxnJEAXybPeg27TbBNKLF9yugOPhB0NVxSo6HVchUeXfVAF
	 qRNmKshZFjj0DiPJkSKfZkszZJmfsbrYupU4l4zs45YfAOANDcda1F7Ts/8j3ypxQY
	 +7Cw7rjtPK5Q40NkqYq8PGtP20CMcQreJOx9l0FiifHdkN4FehAdO4R06gT/JgzvpB
	 p/l0PIqbrDxMw==
Date: Tue, 4 Nov 2025 09:46:51 -0500
From: Sasha Levin <sashal@kernel.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"alexandre.f.demers@gmail.com" <alexandre.f.demers@gmail.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"coxu@redhat.com" <coxu@redhat.com>,
	"Chen, Farrah" <farrah.chen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH AUTOSEL 6.17] x86/kexec: Disable kexec/kdump on platforms
 with TDX partial write erratum
Message-ID: <aQoR27GYadapWwhy@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-288-sashal@kernel.org>
 <834a33d34c5c3bf659c94cefc374b0b7a52ee1a6.camel@intel.com>
 <e15710b10ff4a5ddb62b4c2124700b1ab1c6763d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e15710b10ff4a5ddb62b4c2124700b1ab1c6763d.camel@intel.com>

On Mon, Nov 03, 2025 at 09:26:38AM +0000, Huang, Kai wrote:
>On Sun, 2025-10-26 at 22:24 +0000, Huang, Kai wrote:
>> On Sat, 2025-10-25 at 11:58 -0400, Sasha Levin wrote:
>> > From: Kai Huang <kai.huang@intel.com>
>> >
>> > [ Upstream commit b18651f70ce0e45d52b9e66d9065b831b3f30784 ]
>> >
>> >
>>
>> [...]
>>
>> > ---
>> >
>> > LLM Generated explanations, may be completely bogus:
>> >
>> > YES
>> >
>> > **Why This Fix Matters**
>> > - Prevents machine checks during kexec/kdump on early TDX-capable
>> >   platforms with the “partial write to TDX private memory” erratum.
>> >   Without this, the new kernel may hit an MCE after the old kernel
>> >   jumps, which is a hard failure affecting users.
>>
>> Hi,
>>
>> I don't think we should backport this for 6.17 stable.  Kexec/kdump and
>> TDX are mutually exclusive in Kconfig in 6.17, therefore it's not possible
>> for TDX to impact kexec/kdump.
>>
>> This patch is part of the series which enables kexec/kdump together with
>> TDX in Kconfig (which landed in 6.18) and should not be backported alone.
>
>Hi Sasha,
>
>Just a reminder that this patch should be dropped from stable kernel too
>(just in case you missed, since I didn't get any further notice).

Now dropped, thanks!

-- 
Thanks,
Sasha


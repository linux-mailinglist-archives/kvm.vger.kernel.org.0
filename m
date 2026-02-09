Return-Path: <kvm+bounces-70628-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBLjMXMdimmtHAAAu9opvQ
	(envelope-from <kvm+bounces-70628-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:46:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 813631132F1
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBA6D30205EE
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509EB30DEA7;
	Mon,  9 Feb 2026 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K6jt0sSv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E49469D;
	Mon,  9 Feb 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659178; cv=none; b=ix/Xa/apLXwq+Xadlov0agQIYWaDfb1WrZ8xYdxau9DKUWk83T6M+Xt8MYvGdCgMAbqcvGN29e8lBpnuLvotDMSeePX0ILUNZI6k0MRR9K2hXzLKhlYjxDGIkyKycLG6Vm6hwjC2sGqm4SJhDsDh2eHW4ztCfWV4m992B3bfpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659178; c=relaxed/simple;
	bh=Aafl29YCpY9wL9VpWAuhlnYGQvdJhfos3x4bcokfCqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFUAtVw9zaB6kCHyuPND1rpGVa8WYKazNJhEXIkaxOQHHTt2yGrEJBgr9UwgP2+fcrxO3ihTApZeXTFY7scRITAs5ScWFxv8fhXfeECe507h3TZku1rmzBOPyFFPBX8hUPe0KKPDg0ZPX7Hisjx6PWmLUCwRgkIO6CfNpw7pkKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K6jt0sSv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 14D6540E035F;
	Mon,  9 Feb 2026 17:46:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OYgnUfpnbzad; Mon,  9 Feb 2026 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770659172; bh=Mo4BiC8iK3Fxr4SmIv16+TFf9sfdghs1TCw0pO7CiXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6jt0sSv0v4HH5NmN5IwPu52GKfZy/9bn/56Q7Q4Hmcqq0wMix8d7YNTxyb9nr3z1
	 ABBYwZu0uihU9JY1Z3cK3Z3wg2yJcjFd5VmtBCFTuZd/Ij1oDkXiM9gnKtZ2tkT7de
	 qojhrbvFljsAvIVOszzZ9DASBw/Qz/0XM+jhCf7M0IKMvhLUH04XaPzQLnXxMqr110
	 9g4gTrludxmngiTDU+nPIE7aGR8fthwbLtaDZKWVDxWVppyFjATRUSHgLYpAFexUur
	 3sJdYg52fDEoXRSMVf7W0GrAuF2h5RfLwQ10wnq4cHcukIU5IexXwZ1ZWH0bPjmRHv
	 WRXbX71r+tEiZFJkcxVrSawhbiPwTGZ1xVUmcpivD1Wx1Dcm26KPw5bVVgrJfyPAm7
	 nUAoJcw4dOkE9MZsvitLxx322KfVRo25WK3bJdoKZOiLGZ3mJK4QDB/f380EyYW73W
	 V4Vt/UEn1cEchnOsK+sWr2uWb8f5bO7+lXOsPJxes3MrzgcTSUlk2evlwFX4wpHYgU
	 mQ1QBpt+6ykRrdcrh5MqNratSzoAigOquViPQpLZ8O1jeajLoyFmVPNQV+BvT1TfsV
	 RDp3+inVwdvQ0aXE/1FcQwzp4kaJBX3nAmI1AzIRljeLDsyfQc2rrHXLUehPnmy77w
	 1L0v7Ecm91hMiRcriRwYlS94=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id AC13740E02E5;
	Mon,  9 Feb 2026 17:46:00 +0000 (UTC)
Date: Mon, 9 Feb 2026 18:45:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	Babu Moger <bmoger@amd.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
Message-ID: <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
References: <20260208164233.30405-1-clopez@suse.de>
 <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
 <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
 <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
 <aYoLcPkjJChCQM7E@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYoLcPkjJChCQM7E@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70628-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[alien8.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,fat_crate.local:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 813631132F1
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 08:29:36AM -0800, Sean Christopherson wrote:
> Nope.  KVM cares about what KVM can virtualize/emulate, and about helping userspace
> accurately represent the virtual CPU that will be enumerated to the guest.

So why don't you key on that in those macros instead of how they're defined?

	EXPOSE_TO_GUEST_F()

and then underneath we can figure out how to expose them.

We could have a helper table which determines what each feature is and how it
should interact with raw host CPUID or something slicker.

>   F               : Features that must be present in boot_cpu_data and raw CPUID
>   SCATTERED_F     : Same as F(), but are scattered by the kernel
>   X86_64_F        : Same as F(), but are restricted to 64-bit kernels
>   EMULATED_F      : Always supported; the feature is unconditionally emulated in software
>   SYNTHESIZED_F   : Features that must be present in boot_cpu_data, but may or
>                     may not be in raw CPUID.  May also be scattered.
>   PASSTHROUGH_F   : Features that must be present in raw CPUID, but may or may
>                     not be present in boot_cpu_data
>   ALIASED_1_EDX_F : Features in 0x8000_0001.EDX that are duplicates of identical 0x1.EDX features
>   VENDOR_F        : Features that are controlled by vendor code, often because
>                     they are guarded by a vendor specific module param.  Rules
>                     vary, but typically they are handled like basic F() features
>   RUNTIME_F       : Features that KVM dynamically sets/clears at runtime, but that
>                     are never adveristed to userspace.  E.g. OSXSAVE and OSPKE.

And for the time being, I'd love if this were somewhere in
arch/x86/kvm/cpuid.c so that it is clear how one should use those macros.

The end goal of having the user not care about which macro to use would be the
ultimate, super-duper thing tho.

I'd say.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


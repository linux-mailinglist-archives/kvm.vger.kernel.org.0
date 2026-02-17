Return-Path: <kvm+bounces-71198-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONboDWn0lGlzJQIAu9opvQ
	(envelope-from <kvm+bounces-71198-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:06:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA66D151B15
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0596E3048EF7
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1684D311950;
	Tue, 17 Feb 2026 23:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="H7T1aObd";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="gKf5CcAV"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD42F288515;
	Tue, 17 Feb 2026 23:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771369570; cv=none; b=c5K52b3QkmjLQ7jyrUCkFKHxhuQMgl8GWYJ1sUcVeg+xFRlVaxvd68550FAyzzPjaFQ6GdxVvFYxsdswttWbg1I8joYe8ajgsES+HXwTa0+LJohMisKyqf6Daz3LTFsoRzkZRI9k+NQY0LN80dxa9b2wALeTOykH4WMdpt8+YYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771369570; c=relaxed/simple;
	bh=voEUFe+URCU/W7tP1KlFEWjroRti5RzAXNVbUvqJ5Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtR3JHZdF3cLO/7R9+CShdnW0Gvhtdn/g3t8dGVwXnjShGFmOVbRWjZ7TIg/4Vbn5L3PMhF4QLhsAPNFTphNIQ4sQCuIL+IXXhrr6t5vVAIjEuZfCiNTVeK+LxIwOKUYeOussrJ+b9b6qn5vlf4y7HpcSji549PMkosT/i9FjvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=H7T1aObd; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=gKf5CcAV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Wed, 18 Feb 2026 00:06:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1771369565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ms7AidgKAQSYVI89FnNz/F74tlPjPQwU3Bd1a/zwrxw=;
	b=H7T1aObdRb5iXT+9KTDPt+6EMu0+FVO8qVqlegURpQoEB8bObxgtyjbkj+CJoz8h1bEaBV
	eqCdCRbBZE4YOXt9OjVYo+2hVWwjGUBT1RkbS7oO46PaO5MwqDUtK/+7wUogOVWlN1vza3
	kpdoZJqeJdazyHrpZRDxqsd8rMdGq3f97B94gDjKYRHBe6zFExFrVycE0yj5NwLzzU8qzF
	C1+C/GjwjIvQvUtkH7dxoDFTfS18Fi5BeiJjb/ui0Rtih3cVdPeoq8EZw5bNFJoxSbSwxI
	oMdfmrjE/6ifmbeVwKhn2LHStvfVotHsTigOoeYLAxQV7vz8uSwccHV+pbekMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1771369565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ms7AidgKAQSYVI89FnNz/F74tlPjPQwU3Bd1a/zwrxw=;
	b=gKf5CcAV8mpxQBL+7eYmDz44/Beu8CEc6oVJ4lquJmQrQqsa9wVBOeodsKdXAiSAi7y37a
	NMk9xrgr1oHdfgDw==
From: "Ahmed S. Darwish" <darwi@linutronix.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH 1/6] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature
 flag
Message-ID: <aZT0W9jcgplWHpvQ@lx-t490>
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <6e004cd8c4deb4660bc5887309fc64aece0a5b25.1771321114.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e004cd8c4deb4660bc5887309fc64aece0a5b25.1771321114.git.ashish.kalra@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	TAGGED_FROM(0.00)[bounces-71198-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[darwi@linutronix.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linutronix.de:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linutronix.de:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,gitlab.com:url]
X-Rspamd-Queue-Id: AA66D151B15
X-Rspamd-Action: no action

On Tue, 17 Feb 2026, Ashish Kalra wrote:
>
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -65,6 +65,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
>  	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
>  	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
> +	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
>  	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
>  	{ 0, 0, 0, 0, 0 }

CPUID(0x80000025).EDX is documented as reserved in the latest public
version of the APM, volume 3 (2025-07-02.)

I'll add it to the upcoming x86-cpuid-db release:

    https://gitlab.com/x86-cpuid.org/x86-cpuid-db

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH


Return-Path: <kvm+bounces-71195-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPe9Bh7vlGnUIwIAu9opvQ
	(envelope-from <kvm+bounces-71195-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:43:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA4C15198A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB8A43050D47
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578C631B832;
	Tue, 17 Feb 2026 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="m/oNgBd+";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rBLyS3en"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA2313555;
	Tue, 17 Feb 2026 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368172; cv=none; b=T3eooCCtNLXR7PWroC6o5I4t+1O86dn4UQJRT1y9LlwpNm9tkwzTnqXkyKphZ7sxO70S/rzECYZUryMkcxEDeC2zvYeHWcLuPhR+FQlA7ZP9BA2KSPoGLLD5Pl3N/lM3MVFgvvR/V3nWKWsPJSBL19MoKnpSm92pMorwjn/MDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368172; c=relaxed/simple;
	bh=7QXGFyY689kd5+XpKHFqSqVlXq3y6dnDjuNEpj8uWGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiZ+yrZTJaO4f30acJhlQov87RAFrlOB8mhywnHI4q8lRrcdr/n5ba7Nhw4IGBbV9yUYhzJoMjxr+v6oD9wOAaJfUOrXJs/gVdTI3G/KfMxoVuSY/RjuUTjRo51VRL+lZeX2eGC90zfDWGfWAxRB/uEQnGVTC3PcgUpo3amNHzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=m/oNgBd+; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=rBLyS3en; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Tue, 17 Feb 2026 23:42:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1771368169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U++0aDUqNNet0ZYol2+KI6FhNrHF0UaLhL65z6G/IrE=;
	b=m/oNgBd++d1uBGYmLmfxD0WP/lduuNHPVO2FlzaPeQ4VGRaIiM1hAG19ZeV1PLI+KDMQLC
	glTRtjGFryLT+h8QfsYA9FAPlU7Mtl2tWPDhKaSFzjb9nIWoIXm2IyEtQLxlZXpShndDS8
	YsjtFBhWAWMjxL4fwdXgtgeDm42CVUkmahLuBTUj5zpPa7yREILbq/Z4n2dmvcFlYbf2ME
	wkTQWLtRHS2qEOZ2exEnpEWycHIe6VI8UkjWM53TrkFt/vxFF23WI3PQFhVM+7qIFwN7RC
	xj+ZPEO9MMzOFOAH1i5J+7SWOpKPRJZbpTx+p/L7p08V0d0GUZ+Ci8phXnfyOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1771368169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U++0aDUqNNet0ZYol2+KI6FhNrHF0UaLhL65z6G/IrE=;
	b=rBLyS3envI5p1g6SEekL1uPJzKRpt9PAZCKPXllHs7a50XZBZIv7BRWquX5NhYCQd9V4i/
	5fMxh63ES5idZuCg==
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
Subject: Re: [PATCH 6/6] x86/sev: Add debugfs support for RMPOPT
Message-ID: <aZTu5uNEkYj3WFZa@lx-t490>
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <f34a0d2804bbe7b320bb6c203960aaa3139dd57a.1771321114.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f34a0d2804bbe7b320bb6c203960aaa3139dd57a.1771321114.git.ashish.kalra@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[33];
	TAGGED_FROM(0.00)[bounces-71195-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[darwi@linutronix.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linutronix.de:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linutronix.de:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6EA4C15198A
X-Rspamd-Action: no action

On Tue, 17 Feb 2026, Ashish Kalra wrote:
>
> To dump the per-CPU RMPOPT status for all system RAM:
>
> /sys/kernel/debug/rmpopt# cat rmpopt-table
>
...
> +
> +static void rmpopt_debugfs_setup(void)
> +{
> +	rmpopt_debugfs = debugfs_create_dir("rmpopt", NULL);
> +

For mainline, this should be under /sys/kernel/debug/x86/ instead:

    dir = debugfs_create_dir("rmpopt", arch_debugfs_dir);

Thanks,
Ahmed


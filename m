Return-Path: <kvm+bounces-69745-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOoxFu/wfGndPQIAu9opvQ
	(envelope-from <kvm+bounces-69745-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:57:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E59B4BD88D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8E03B300B590
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA2836999A;
	Fri, 30 Jan 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AiV0L1WT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862852DB788;
	Fri, 30 Jan 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769795812; cv=none; b=U3zSz+rqXSEough/0SgtMg4S7oCm9nmcqZJsccHnd2bq4wInmMFs9CNlIcFmWnoU0puHCVd8WsCoNiBfL79eB6YYBsQIHG3hoCCO410tLf6x7sfISTG3AC7mMQ6PNVeXEWGKcMxu5MObfoCnYyVaq2kBXx8zCan7D9E1t2hS/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769795812; c=relaxed/simple;
	bh=9Ha2py9eyOE42PnrBMlY9K3gPpWDc4Z4f0VHi5d8NPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2hrXp23WolFohtnTMQ0YPCeEGcGXMJOc74siAya4gE2WLZJcXDcpiwMVoiF/TczZMWeT6NA8kYNx1/hxHUnot+Ix9Crw9dsShlVmLyqdVyOXM2bAOn1j6PzsD9JTQknxJkGnY428aY5MpVJfwYfYVz3T8BTP20FOj9AnrycHDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AiV0L1WT; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DA3D640E01AC;
	Fri, 30 Jan 2026 17:56:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id d_pxrSNcwjuh; Fri, 30 Jan 2026 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769795798; bh=H4xGvJGf5D3xbkk6wzbtP23A/WwQ3L7MV4zJsXF6XJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AiV0L1WTO2JU3zVDpzrDHNq2XUP6oO2X8wfqLOAUu5OSJR6MCG4J8FtDuo2Pkye0M
	 ugI2BkvRjUfe3BN7qHR6QlVdIsWs4wIQyt75xVD3vaBH+HXiaVRqsspZRnwvNN2pTJ
	 4GvgNxTXlscP7GOT2MRg2wLgCMwBTv2V8bjlMoNtOewW4ZQ1H8lQWfK6OX+jvbe+c4
	 pFDxCvqvikawC4Nka1WiDo/DvoyUB9Q/yfQnVHfxmRTn7x1C6oVtHIaRjRPyfCMBWX
	 ZMzxa1UEd/y3c9gijLsUdiU8/Em3wu5afl7cKCgPsYAfDvkNfGNPu0Hvy/XhGlwqBo
	 YZu4I1cvfPwlyqMrLi5XTAJeYDfhAZ90EbpL+7F2bQnREk2fAx18M8jaBSIg7JwXxt
	 LiQVjyYjmopaNNR63lnz0yMGpzjSCTg18Wah8PMZ6xXLhDMbRwNJBiOrdDfvaev1ZV
	 54R5Ai3Q89QcxQP3Bh0eZYYBpgk6WnnNH9i9Q/6gSKy2s6Hvj3fwHIhZ6K+tNWdYFT
	 pt6tj+rucqraVd0i988p32y4vtYOEdQLnggSnPFFarlz8PG0EBxsenHkQWERtr7Lz3
	 3ZIGa1LH2BBZgFcpyX88mBUGA/cY+xP5YzgN6sBsLezBELCdIUtuAvgQfryus1V4fm
	 cU4UmSshJ2PDtGVWhgxyGtSU=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id A194640E0028;
	Fri, 30 Jan 2026 17:56:19 +0000 (UTC)
Date: Fri, 30 Jan 2026 18:56:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
	chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Subject: Re: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
Message-ID: <20260130175613.GDaXzwvZob7k5UAel_@fat_crate.local>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-7-xin@zytor.com>
 <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
 <78858200-FE67-491E-89C6-5906233C860D@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78858200-FE67-491E-89C6-5906233C860D@zytor.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69745-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,fat_crate.local:mid]
X-Rspamd-Queue-Id: E59B4BD88D
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 08:35:50AM -0800, Xin Li wrote:
> What is the right order of rename and refactor?

You can rename it when you do the export. The name should be more sensible, as
said.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


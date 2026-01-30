Return-Path: <kvm+bounces-69700-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AmYJSKlfGnCOAIAu9opvQ
	(envelope-from <kvm+bounces-69700-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:33:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D30BA8DB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC2013038A6C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 12:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710EE378D9D;
	Fri, 30 Jan 2026 12:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jIrEqhmt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1C23EAA1;
	Fri, 30 Jan 2026 12:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769776397; cv=none; b=JhxNGuj/zMfPTlCcOZazLVXsr2LVRQDSDxtcmi8EIq9mO7e/uP8razTx+ifNOEJD3h2q6u4p1ZHd/YjEJwVQYm1YTjqJTfP5djVj7WDLULbfPp75pEJO2ce9nYNcnPhvwtPkmQlh9flQplFJcNfN8h4HZRCDttFG+T3Z/IJzkMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769776397; c=relaxed/simple;
	bh=jJnTKRus1VH9ByRP4dCVWUmlwN8Ml9AobfbOzad7QIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDE6L6uycV83iG5O3wLU1ddAaoHL63NrrRqHC+1jiBjIDcHAGKIlXedfP2Bl1eOIiEDM0x2uTb9PzwQqFWDZPE7KGy6MYQ1fxVrDG++NDvdz/L/4/TJw5lGsQmU1Ai8qp4QfIgqocN8pSG7U8oxVy5Ojej/fVJ8zyC+zdSAaeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jIrEqhmt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 247D340E0028;
	Fri, 30 Jan 2026 12:33:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uRJQ7lZ5xULN; Fri, 30 Jan 2026 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769776387; bh=i5i6PvjHca4PxvY6snJ+kbO8pp9maV47C3kOX6ifmzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIrEqhmtYUks/uW1gx/QvKBABSi4kWxojyTs6Fi0kBHkGuQQpUEh9iqC5t+0/81Kq
	 Af0wB4yeI6JC30CPirGKzDLjXzh+d4eniu8TB3pmEsFxf1ohMJqi5wuQTAAlPUdnlg
	 HeGNaAC9KRl09omdxLVj7R8qyWdaQovGZqdaEgYvkx5T5z0JqYf7OrrZGpzXSd308Y
	 HnVlyEVhNWpYmVuiuadpM3has0rhCs8epJ7iFTwpHcFOdNVNfPOQK1lL40+JyksIOx
	 ges2jFyqXosHB/SnAlgCN79t9VHUHnnnKUgDw1DGg4waTALOJXPdkNUVqWy9cJ+Yqb
	 wsxih1HaTZ+s0fgg9UhgseDFlMb675VLxktUKNSS3jBIqwi4VdvujVt70goG4TQuWc
	 EaZbJCVttmKAJwN307Uzd+TPBBb+E+WQSQ7S/IwG7Yop0phi6Wuao/9IhXqR9rUy0/
	 5G/r5s9n/LXQSoM5V3SrfpSBlKxGx22W9iQ8BM2gySZA4ha4opgJF+PyQTHQ4vKtbl
	 KJOkSaa44yUF4NX9qMTvf0LZjaVW/24c8yh4NfHnbJvzmDh2SMLiYQ9Go+v5RqR3vD
	 c6REsjbbpMo8FMuYZzHEzaPOKUZkKrTWWjOep/TBKfiMSczn+MliHWhRKPEN7AskY0
	 ldM9XaPDx0b+TkXCrgN9huR4=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2849240E00DE;
	Fri, 30 Jan 2026 12:32:53 +0000 (UTC)
Date: Fri, 30 Jan 2026 13:32:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Message-ID: <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69700-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fat_crate.local:mid]
X-Rspamd-Queue-Id: 41D30BA8DB
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 04:32:49PM -0600, Kim Phillips wrote:
> Not *all* SNP features are implemented in all guest kernel versions, and,
> well, for those that don't require explicit guest code support, perhaps it's
> because they aren't necessarily well defined and validated in all hardware
> versions...

Ok, can you add *this* feature to SNP_FEATURES_PRESENT? If not, why not?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


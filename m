Return-Path: <kvm+bounces-69871-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HhZMLfHgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69871-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:50:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D409CE6DB
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3885A301980F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7B825333F;
	Mon,  2 Feb 2026 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Xb1zTVrE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324245948;
	Mon,  2 Feb 2026 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047405; cv=none; b=jElx8rHdjlK3LtoNPfqIWa//39vUNyK10ROmrsKGrWw3nKsZYPdHH6kYA51cVVmeRoE8cHnRgyQSvFoEMFIVglP81vBpIPH+ALyR+v6tb3Y3aIDm0QrHwIQwNF5UjoC8GAqe86Fu+7F1MPuwiVIHtxGpAT8c3vjoil6nj+mk5tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047405; c=relaxed/simple;
	bh=78OIZ+u03jGK9bYa5rgrVwJo4W69eY8NZ/BqfhahfvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuE2iqOzni6RPylwHTfpyvBbK9f5U8pq7d2v1R34e1JkxZAivdoPEAqgJ9apqKext4GDGmak85pY0Jznl9mxnoXxHSi/uvM7avynEuiVPX889t6xv3a6k+l2bLqRDB6YVJqnVnbMVX3LQw2UBNF5PZ7HaAuEBQvfHAzR1BfDtfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Xb1zTVrE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5FC7340E01A2;
	Mon,  2 Feb 2026 15:50:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HT1Ca_f21OqT; Mon,  2 Feb 2026 15:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770047397; bh=P/FOzvnP8ehuSxLVvHDHZ9/fkeBtzrPeegEjdKJuwUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xb1zTVrE8KqpFZQCay8Jq6DNzjBzyHItO26dePERDpiUR7+knyNOf4T4/B4mPoGey
	 JJU1zKpyozjZ6dMxWf3jGzOr5Jhz3/SFJRKM7L9YQ1JIJrwYgpXsAR6XErM+nBQRCn
	 sRGSu2Kysrt2QGXKsao1Yi6pA3rSnYYB1OJFNhE3nCEUuH7s2MxJ04olR9fHhwl7Xl
	 Vj4DrDTg/42hKl4wkxoOa00baRO9HRltalpK+LaXzZnz3/OhfYMAtTiw1FmAjMuSX3
	 mxBBnp4gBjJSGtlYqwrN+47korhKwqQ8iAqp2cPduOVT+911WtY7bzIwlpW0xlkmUt
	 9/m4wRI03sCv2u8n6/loJM+vI157eOYVw5SIEcdHCRgzw5NvpV7dWY/0u2dozXMKhV
	 zdTHZTiXIgpsvXIJHBtYY85aJiFJys/g3m37Df24tRIrCH3VaeRrAg/EGLEZMZVppb
	 eyABmE/A1omLUxtYtYbMxRcghyGiCZoBh9XSxWWBr3K08KBjHxsGmWouelJatCSMK2
	 1gt81gRID0vlKvYn31bP6ksZihAbEbnjwK/zJnDFxLqR4ghNJIfIfh78CD3udCtp3N
	 60UpeTOe0K6urxDunnFoiehZVEHW86ycFPwv00XDgGZQ2HEvECV2YC9X5A56qa/T3k
	 3me3Ax9j12WaBRxvIEKTODvE=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8A0DB40E035C;
	Mon,  2 Feb 2026 15:49:43 +0000 (UTC)
Date: Mon, 2 Feb 2026 16:49:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Message-ID: <20260202154936.GAaYDHkOMpjFpoBe5m@fat_crate.local>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
 <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
 <2295adbc-835f-4a84-934b-b7aba65137a8@amd.com>
 <20260130154534.GCaXzSHgkEFnk5mX14@fat_crate.local>
 <6556bacb-2e81-4aa8-92e4-0ff8642f4ec9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6556bacb-2e81-4aa8-92e4-0ff8642f4ec9@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69871-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fat_crate.local:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D409CE6DB
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 09:38:50AM -0600, Tom Lendacky wrote:
> I guess it really depends on the persons point of view. I agree that
> renaming the SNP_FEATURES_PRESENT to SNP_FEATURES_IMPL(EMENTED) would
> match up nicely with SNP_FEATURES_IMPL_REQ. Maybe that's all that is
> needed...

I guess...

I still think it would be useful to have a common place that says which things
in SEV_STATUS are supported and present in a guest, no?

Or are we going to dump that MSR like Joerg's patch from a while ago and
that'll tell us what the guest supports?

Hmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


Return-Path: <kvm+bounces-69719-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIS4Amq2fGm7OQIAu9opvQ
	(envelope-from <kvm+bounces-69719-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:47:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DFABB521
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9A32430106BA
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684D330F957;
	Fri, 30 Jan 2026 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Wc+3DTR9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC322ECD34;
	Fri, 30 Jan 2026 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780564; cv=none; b=UurHtHi/a8sfiefgavCH+pPq70aVbCDGBQzMHNOn+4iQW3pgJjzAdR+vVBgC/50+ImL/xaOYDXi/Nv7VTJsPH0YmZQIrOPimi1LO5D70JDPIMr4nokpZc2p0uXVtZYIRdx5eagOLdTaJfOMmhjGUd0iY1zvBdjJLZx5hpoCdDps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780564; c=relaxed/simple;
	bh=ZdwfXVDKrptF6zEBnycSM2xt2oyuwZwAE3tj/VXJTDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ixF3u0IjcYowjZuWl1ZN1s87O73GEDmaMiCTPGG02+UeOJM8UWYi/ZJUKLppM/DcKyXjMVhSRQZycukLyjXw4e0gojYjk6NZeKevIW6R3+Xu3TYm66jwqaoHwvAVvph29jRs8xIUYmXnkAS8XMZPdXQktRe0bXXUAA4M6zfbxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Wc+3DTR9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9307440E01AC;
	Fri, 30 Jan 2026 13:42:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HGucyxo1SEAf; Fri, 30 Jan 2026 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769780556; bh=80KzFPZyd2K++cpKjokXAKYgQ1cNBdJ37gjAwS22QHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wc+3DTR9Z1ohoGrqoLyNftmnXVoKLQdwgFMi5ITZt/U6akuVpZ13goXx+qZy+Hd/Q
	 /Ryxs7q6Tkl7QGXmvBxPJDKhZgxQFKe4lTiGroq9fWhUW9XfjX9VMfhWOzCwVH6D5B
	 LVsfJuf5xEKgRwwFrli7+BUFIWVA5x4D5y7UkxZkxML3kJ5Uxffua7WjgZ/qd1nFev
	 MAYUJ50T5hh8Z3hTKTm35gHBGcu/GonLsQAw5G5loeC3zqRO7ehL1ArpMR5T3p4SsH
	 Jwoi9LjDIukf/q2Gq9VeYnKBmFFKjWjYBNrvGn/MgdiBoWrTUOrZydJPyIiRDpJkrS
	 tZxdZNkzUa0vv4VupEi2qyJvlN4EeGhTOma0CA8AsDTv8rXlhamIzVjrGz0CbpHzaO
	 n3h1vJzYTiW4f3Zvfc0k5xl5OpKWYtdDeb7RtCzj5y0ovXFwZIzTKusDQNPgSeZQAv
	 5lLMAJAukJBFoY/OxACc+0a+SeTvSOE55XIE9oZaZ9nfJ1vHM1VH6d6AvA7mrxjO/p
	 ON2rgClkNW7r6Y1i5OujGBLIWiGRNRoqplVrWF4ezpuFFs+cxAVILZ3Et1vc/wu8zj
	 ppmielMxovDY070NlD2FWLzaITDT2ckBk7qnrWyuLAHdQOudHNUqx2KG6MPd9H8ZHp
	 pcVA0aYEvSakm86Mp82dPIA8=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D1C1F40E00DE;
	Fri, 30 Jan 2026 13:42:17 +0000 (UTC)
Date: Fri, 30 Jan 2026 14:42:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
	chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Subject: Re: [PATCH v9 05/22] x86/cea: Use array indexing to simplify
 exception stack access
Message-ID: <20260130134211.GTaXy1M4oB2R7rvTfF@fat_crate.local>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-6-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-6-xin@zytor.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69719-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,fat_crate.local:mid]
X-Rspamd-Queue-Id: 23DFABB521
X-Rspamd-Action: no action

On Sun, Oct 26, 2025 at 01:18:53PM -0700, Xin Li (Intel) wrote:
> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
> +{

You better check this @stack is within the array bounds of event_stacks[].

> +	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


Return-Path: <kvm+bounces-70604-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMxtBnb/iWluFQAAu9opvQ
	(envelope-from <kvm+bounces-70604-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:38:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 83936111F9B
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5934F30659D4
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5392437FF47;
	Mon,  9 Feb 2026 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iXfGv0E1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7445295DAC;
	Mon,  9 Feb 2026 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770651189; cv=none; b=gJQzscqcM0PpllPRnKNlWN31HhMLftYE5LXSoJ4wc+YSZ0gCei6UA1LHBJ4lMQwz2Xp6ppaL5EVK7M/0w2qUk6+KabCDrwIFg4iaA4Ld2TxYebjVAjrW67xIERx6Zo0BlTY6qic4B7r2lKRqBgsGf3+2qd9h8KCqorV06/EvV/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770651189; c=relaxed/simple;
	bh=crgwD2IGcIO+TYQE6IQNQMcPD8UUiLhWtlto6FfRzPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUSbJh15lM5P6nRrP9ApGlfZ/c6FZ+FCZVihVZ8/zvn0+qGzRpy0yTeYB15WjWkuQI7ZEtfg3RP+0O6UPPyCyeLTcllb1n/vQNhToMy7uH3Ju2V42PIrTlJgwfENcgA3OftCa8tqx9dRFou/jwJDo4cBY4c0cGbqPR0YncQbR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iXfGv0E1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ACDC340E0367;
	Mon,  9 Feb 2026 15:33:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id plzlYSqkyjNm; Mon,  9 Feb 2026 15:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770651182; bh=mXWpZe6OE6ukMdZfOSRQ0GnI9uP34AEFcy4bdiTSiqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iXfGv0E1DSaxunbQk/PvhXS2LQqNRsgb/ojeYzl1iXGSgYz2b/ASgEeQlLU+r1nLr
	 JXRdywNVp3NepOLNNzjQ426hPj8HOpW+cJ2P+SP5OJwJi80ZdiuZonmEi1symgFbcu
	 4mmh0D52XHHc3y/D1qJv5uIbCnsnoPExJpPZZNBrt/8+c3FGkf+kQ9fTVVzgLwdUiN
	 /zJF9kPo5WDeX/JgVtc2fLJC7qjzRjE0PMx5ONULbE5X77LiefSL9Gv7OBItI166Es
	 3dNtM0Sc3Kv6rNmkK0h3957RG6sF5zALrkeqf1pKTQAZgL8XfaAKmz/S3N8wI5l4Bw
	 Azcooda1UTl/YBj6L5YPb76iiXH4xpOEYpIBcbI6/ilOKh47Zhe0C+skEum6j0xF1x
	 bAPTS3MIuuw2a8G/VpGVAcs9rjFjfIl2ynQdSkk/LhxHU9PkGREOt3AiHFIwKlTbdX
	 /+1gZ3CF8MEXz53uT/Y/kuWnIP+elPN+Icle6hG7RCqFNMX1C1OGV2jFynAMv98+N8
	 NZ25n5lWXSWuZXA3Ys+aPJbpofxFpBb2J57X8pAMRzWPzT4q/FwaeNSp/PtvK8/voE
	 xCLa4Jqsu+H1GvsRRlveauF8iLXeuP3jGv/tEyQqtpR5BYxpdvYPBboRZGy5tjc5Sv
	 U+msCt8sTSXqkPTD3ZsI3nTE=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C3BFA40E035A;
	Mon,  9 Feb 2026 15:32:49 +0000 (UTC)
Date: Mon, 9 Feb 2026 16:32:43 +0100
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
Message-ID: <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
References: <20260208164233.30405-1-clopez@suse.de>
 <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
 <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
 <aYn3_PhRvHPCJTo7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYn3_PhRvHPCJTo7@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70604-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[alien8.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:dkim,fat_crate.local:mid]
X-Rspamd-Queue-Id: 83936111F9B
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 07:06:36AM -0800, Sean Christopherson wrote:
> Maybe I could add a table showing how the XXX_F() macros map to various controls?

Perhaps start first, please, with explaining the difference between
SYNTHESIZED_F and SCATTERED_F and why you even need it?

I mean, KVM and guests only care whether X86_FEATURE flags are set or not, no?
Not how they get defined underneath...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


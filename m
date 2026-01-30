Return-Path: <kvm+bounces-69720-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCYnD9e2fGm7OQIAu9opvQ
	(envelope-from <kvm+bounces-69720-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:49:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBC3BB55F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7839301467D
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51F2313273;
	Fri, 30 Jan 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e3GTC6n9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916382C0260;
	Fri, 30 Jan 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780831; cv=none; b=RQhHwgcqGJEkuVsMRfK2CWT/QBKQpXVSmqV49DdpcRH1dWGKUHw4VOZ7RroztKvyVpcGcKCYlubF2Y5k0PMjKMELJpvDWPH5oVZav3qf9vRuV9C0b8+z4eHKcFbv7RQvLHKBuskS7cTtJ8pyy5sSYdEb1yR9AGgsf6PwuJGlmF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780831; c=relaxed/simple;
	bh=ZE5d87JshOncqJzlSy+8uRTDRBflFPCxaVMqz5DcnVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=deHuKiV6g4j5TINBcO8Hj/omiyEK34cQU/7YI5VTiP1qH8oQVrOFbLTy2/j8aL5jKuaw1JPonjG4RtGhFpSNi4165u2oqc3iPrMrQCHCBgIn6Xp1jaXrGN+sY8ES3PpIf9oFsECXjEQr+UwzeZD+aXdsi/d/jN8s0qRSJVAdLss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e3GTC6n9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1A12940E02F6;
	Fri, 30 Jan 2026 13:47:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mJ3GVzswKEju; Fri, 30 Jan 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769780824; bh=tbK64VAS+TKV8/+vesZQCZ0qjUSJ/whVstsl3PLf/h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e3GTC6n9jtRX6sAvWpEQTNrxykDOKl6alx9J5jhnjcRsSSpDmABeeSCUgDRJP+I0o
	 fUA9XARqF68Aq3faQOgsUu9Ne2Gp1ZMeG4LRED7dQMPx0+rGi9FNv3qwYYeq3dt5Rb
	 MbE/ca6ttduvJJhbAbd36tTEDefmnbak/yxDf1obpgddInYrf3f1T8KbJermHuFpwO
	 y3yx98STahUfhL9zSQaKo+JVefSJpsgXJqFs7olrxOilskxzGfXnMgcC51MmpTLGpZ
	 wjhatgpfU8Uu4llOhsLWsW+5Pr2ZAdDa72NdOvK2bS6CiIiHoGIyZ5/GWCL1uXwchm
	 SNladOAPJF3KLNR/Bpc+mHt5yhXRe0Thsr8ENEhcvOOiSZOf0ynnJPKwqFmyQ09Xz/
	 ZXHXmzZntIiPm3feLDl8CfHmYBxiCsxZ7+Ll8JvUdnSG2LI2xL/7yJt4xspeZ+xhi1
	 JwTA8aBLv6Xz8jnh9f/Y/cCrVWH4xJ54slSvK95KLF9DSXCDattMxQcejF1xKJah/+
	 LTh48HN6TDQ9tSlz/omWaX7ArliyinT30jpvfFrgI/I//dKa/EDb6ZMx0VSog83Yul
	 3PskoFBiaIsFVgl8zAtSUByQeUff0rEo2LCZlgjNeWP7FFFK7hSfHmfd9f/MspIb0J
	 JvTB1ralfk2XoGnAmiB7VWgw=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C8D2240E0028;
	Fri, 30 Jan 2026 13:46:45 +0000 (UTC)
Date: Fri, 30 Jan 2026 14:46:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
	chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Subject: Re: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
Message-ID: <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-7-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-7-xin@zytor.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69720-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,fat_crate.local:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9EBC3BB55F
X-Rspamd-Action: no action

On Sun, Oct 26, 2025 at 01:18:54PM -0700, Xin Li (Intel) wrote:
> @@ -36,6 +41,7 @@ noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
>  {
>  	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
>  }
> +EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_va, "kvm-intel");

Why is this function name still kept with the "__" prefix but it is being
exported at the same time?

It looks to me like we're exporting the wrong thing as the "__" kinda says it
is an internal helper.

Just drop the prefix and call it something more sensible please. The caller
couldn't care less about "ist_top_va".

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


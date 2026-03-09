Return-Path: <kvm+bounces-73329-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFAFMmXzrmnZKgIAu9opvQ
	(envelope-from <kvm+bounces-73329-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:20:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB3523C9EA
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B33F3312E509
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DC03E0C65;
	Mon,  9 Mar 2026 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aDWB06hX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186683ACA4B;
	Mon,  9 Mar 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072946; cv=none; b=HT7C4JKZvHuzO/WXdwDnU/tBofLj1K6f8Nfds9jMEdktrkQmtirqCo9Pz9rO8XClq/T1RL/Ypf6fwJZ3oXXmW5mMvaKsaxr087kTzYCWM6qNBK46wUwdi2JTM+3uHAnxDv9H5eonNnoOTyU2GBswIuxf+P57RuEduMBYtw/9ipQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072946; c=relaxed/simple;
	bh=yQSLMuQUX5iJPfSQbFk1a80EGmPvnDvhYl7QtpOpYBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/R+oeA+Rdkan6QN5PSFvLhgvGrQkVPAKGP69VqYJ8f9CzMPdiqZRaZ+hw5wWByYmtlX75zqjFN104MbFBg6PsMNGLRHGzsk9fg92k2v6LARuWvrEQ8Rv3zGS8Xetgry9jlpIdeBhUFziK5+U94Z2ByA02fqYsYRg5XraNz4DAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aDWB06hX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C014040E019E;
	Mon,  9 Mar 2026 16:15:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kdfn2eWI_Wus; Mon,  9 Mar 2026 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1773072938; bh=wDOgwQHa9dM89g18EjRxabd3hUL4dE5CEFiGPJNIB5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aDWB06hXQduq+gB3hSnI7ISFptiFpDQDuseuPoZLXUkhqwdX2q4jXFZ1Cm0tifCG3
	 fcg5IqKjcupeIZQ1J+aLuty+/6Rz2TDP6d9u/uWDuCTt4UMlx7wQdQRwtKjtMbnwc/
	 KPgSrjEpVeGC560n4iKUGH/MeBmRipgaztMiOWFsz6bPpv3FBE261uGnbCK9qwhh2i
	 3r1pYCMlaYOSBwtfXPjlouX907NB0rvboRx+7fRuOj22hd2H9O1dhPTYlGy/p+xCC9
	 SVnBSh9/NZimNINbbdRM2feFQl//r0Jtq29qhVQu2TbAZTUlvotK41RqZLvTvqc4lT
	 lOCzDhuf2+2dz8rtZ+SqOSeRQ3RDF1RPZ+rvf4AKFqa0RtHVCtIZ08F1xy+CJ1KM2t
	 Ubt/SirZ+w4isAT8lO7zOjMU16/iRXYhbsmgdl8Y9BL7t2n0x8YwxP2rn+6vYo+kiq
	 LA5ETTBiF1sKg9CIrJNO2Vb247iJIy4c93BNOhOqmydVPVLdBeFdQOmkGY5U2kxipL
	 0YVnxSJyr2iEQdB6JBw99jq8FRtVeHp07rIPBPYbNIC2PdzP1VeAw2oaimVS4If3sZ
	 Zb5lY8zZpoVc8ex8m/38cHCYJLrEpnse53Oa4eFrpdqq1HCKWsgzVBUJ0zyJHgy1cP
	 YX8rlfjpQwJer8utTVz+x1F8=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 57B0040E01A8;
	Mon,  9 Mar 2026 16:15:23 +0000 (UTC)
Date: Mon, 9 Mar 2026 17:15:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, thomas.lendacky@amd.com, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	x86@kernel.org, sohil.mehta@intel.com, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/2] x86/cpu: Disable CR pinning during CPU bringup
Message-ID: <20260309161516.GAaa7yFMulhdzNQ-pt@fat_crate.local>
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-2-nikunj@amd.com>
 <20260309134640.GOaa7PQJli_C9QATGB@fat_crate.local>
 <cde957ba-3579-4063-9d17-3630e79ea388@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cde957ba-3579-4063-9d17-3630e79ea388@intel.com>
X-Rspamd-Queue-Id: 2BB3523C9EA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73329-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.995];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,fat_crate.local:mid]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 08:38:10AM -0700, Dave Hansen wrote:
> On 3/9/26 06:46, Borislav Petkov wrote:
> > My SNP guest stops booting with this right:
> 
> Could you dump out CR4 at wakeup_cpu_via_vmgexit() before and after this
> patch? Right here:
> 
>         /* CR4 should maintain the MCE value */
>         cr4 = native_read_cr4() & X86_CR4_MCE;
> 
> It's got to be some delta there.

Looks the same to me:

before:      31  SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0

That's 31 CPUs - no BSP with the CR4 value above.

after: [    3.354326] SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0

That stops after CPU1, i.e., the first AP. But the CR4 value is the same.

> The other possibility is that some CR4 bit becomes no longer pinned when
> the CPU comes up, and the *pinning* was what caused the secondary CPU's
> CR4 bit to get set, not its actual initialization.
> 
> Basically, the secondary boot code didn't explicitly set a bit and
> counted on the pinning code to do it instead.
> 
> It's probably exacerbated by the "novel" way that SEV-SNP CPUs get
> brought up and all the assembly that *only* runs there.

I guess I can start commenting out things to see what happens. Hmmm...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


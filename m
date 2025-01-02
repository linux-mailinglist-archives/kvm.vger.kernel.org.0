Return-Path: <kvm+bounces-34475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7659FF73F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95A3C18824BE
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EE61993A3;
	Thu,  2 Jan 2025 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OK7JP7pC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB61922F5;
	Thu,  2 Jan 2025 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735808882; cv=none; b=KZbuzLXhBjSf4VLxPPoXJ5GGHqXR+9aM8eMDayL96avLgKj2dWOTXLux6f4to2n/YeQ1TiYQO8Hjrz2rn9VmUs8Myyb3zsWE+kiHBFVDznzvo+PmrFWX+1HtYGJh88bYTxk7jGTwnEr9H6LRuAiGW1PK/1l6ggzXI2RUw6TipWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735808882; c=relaxed/simple;
	bh=wja998xFpF8Iz5kFTIVrBvIq0Tmf0sp8qjK/aZq7gTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADBV+27ZdLwQDjTnNbv2//govcpJkIVKu6/ROwANPRAr/owlsVCoJvwqB+JZCfzcc33h2fnz+jEsOFPsIlzIjxkO0XL2trcPsOCXqsn2NuGYgtavV4OWeYN16ca7/l9s/7n7hQr4oIhzGc6uzzdkY4myDlWIQVik+CzFqNcAGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OK7JP7pC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2A27140E02C0;
	Thu,  2 Jan 2025 09:07:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SY2LtAcyf2tx; Thu,  2 Jan 2025 09:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735808873; bh=cr8Zs/1KHxjA8uyv9k9WE3SzohdXZrg2wLeUYrtCJ6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OK7JP7pCcRVDARAC3z7wH3VoHs2MEuWFSw0WFhC5eaTGOwE2VmzH+JFyQNpSYJdrM
	 ryxg23sGvViazKjgVCeZVqdDfF01f0tVlZm9q1bajfkuH91v+Z1lLfV4ti9plolKCf
	 BrlBG5SQ1flVfpxYM7qjTFp5hBuXD62EP58Q6TCi1dTXwHlf6XGuhTf1BWg8+TsSpL
	 6wZ+eveuY6o9p5DFp3HWKZNuewhsA9Xlk9xCB/UBt4zzdgh3vTxCss/SoYhjtAtz1E
	 PaAdNPPGaURxiMNqjmdTFuhDhfdbqEC+CDr/ZtJDRns/91p29nDkAYHaK2mnLQr4G+
	 ToeXGcg0DDIlLtijL8GhKuUl9+wu9Mn27tMvZBA1SPlp73QF62icOUB+DULZX4XPia
	 R8cgMNZ6oSs85wpqNE6Whhdpbx6uAyY9IpsPNrULsY2WyMq+DHh6sL7lyNVaol5lkr
	 5kbSX1rMlQYC7uSiZv5nVAg0ZoJFg+5WvpW51Yrz1bpI5YjEZISXve2oHzkZOQNLKN
	 TNbGhGIW8nla9F5NRLYbPr1Hmj13ia91SfT4scY32+wAnaew6hs5lN4OSz38BObbqB
	 8eK+nLLE3YFEQpW55+aIr7Ewa/wRjlVOWG82m2rvyzW26MFmMLbx7c9LfsZaIsVeV7
	 SG6kHG+WrvtVKGsCoxwVOeX8=
Received: from zn.tnic (p200300ea971F93de329C23FFfeA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93de:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 42E4640E0289;
	Thu,  2 Jan 2025 09:07:42 +0000 (UTC)
Date: Thu, 2 Jan 2025 10:07:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20250102090734.GBZ3ZXVqpo0OgEwbrQ@fat_crate.local>
References: <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
 <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
 <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>

On Thu, Jan 02, 2025 at 10:33:26AM +0530, Nikunj A. Dadhania wrote:
> I think we are dragging this a little too far

What does that mean?

Is there some time limit I don't know about, on how long patches should be
reviewed on the mailing list?

> and the implementation[3] that I gave is good without any side effects.

Well, apparently not good enough - otherwise I won't say anything, would I?
And I wouldn't review your patches on my holiday, would I?

Geez.

Now lemme try again, this time in greater detail with the hope it is more
clear.

If you handle TSC MSRs and then you have a function __vc_handle_msr_tsc() then
*all* handling should happen there! There should not be if-conditionals in the
switch-case which makes following the code flow harder. That's why I'm asking
you to push the conditional inside. So that everything is concentrated
in a single function!

But there's this thing with handling TSC MSRs and non-STSC guests and that
needs special, later handling and decision.

So *that* needs to be made obvious.

As in: I will handle the TSC MSRs for STSC guests and the other flow for
non-STSC guests should remain. For now.

And make that goddamn explicit.

One possible way to do that is this:

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 6235286a0eda..61100532c259 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1439,7 +1439,7 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
  * Reads:  Reads of MSR_IA32_TSC should return the current TSC
  *         value, use the value returned by RDTSC.
  */
-static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
+static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
 {
 	u64 tsc;
 
@@ -1477,7 +1477,9 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	case MSR_IA32_TSC:
 	case MSR_AMD64_GUEST_TSC_FREQ:
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
-			return __vc_handle_msr_tsc(regs, write);
+			return __vc_handle_secure_tsc_msrs(regs, write);
+		else
+			break;
 	default:
 		break;
 	}
---

You can still push the if-conditional inside the function but that'll need
more surgery as you need a different retval to tell vc_handle_msr() to
fall-through to the GHCB HV call instead of returning, yadda, yadda so this
version above is shorter.

And it can be revisited later, when we decide what we wanna do with TSC MSRs
on !STSC guests.

IOW, the code is still clear and there's enough breadcrumbs left to know what
needs to happen there in the future.

Versus: lemme drop my enablement patches and disappear and the maintainers can
mop up after me. Who cares! :-(

I hope this makes it a lot more clear now.

And again, if this takes too long for you, just lemme know: I have absolutely
no problem if someone else who's faster reviews your code - I have more than
enough TODOs on my plate so not dealing with this would be more than welcome
for me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


Return-Path: <kvm+bounces-31251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2481D9C1B0F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 11:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A7391C24CB1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4981E32B6;
	Fri,  8 Nov 2024 10:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DodnUcfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C30B1DFE3F;
	Fri,  8 Nov 2024 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731062968; cv=none; b=ZJFyDzR0oWWcdUAeQTKu26EAU6Z30JbYEVGPs+GwNKs9SOlyQ+N+UlPsCnab6OT1WD4DRC76P7wP6ZXYGR8DIdgmeSon+yP6wZfUxXp8BpG3scQKn2WI+Ls8NLQIuCoVmErNnp2qt5JUgs1zOeDuGH3YkQEf9+9OmunZ75lsRyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731062968; c=relaxed/simple;
	bh=ozwVj7uZahEunmFExKYJY1wW+RltDVyh8WtJONRSTOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PETwweuvP6VOnnyscVmXyV8JbbA8Op1wUjqPaGq4uORv6qHAUjyoRQl9/bUP9UkRRfMSwmluIPK0sLFKsjzUFB8uYIJwlU6Y9WsEA30ymBY43T5C0MXodt/9LFr5xZA08RnyAP0Hf8u6PW2HavnUgP066NmUmPoGVJBKrEzVkPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DodnUcfb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A87BD40E0265;
	Fri,  8 Nov 2024 10:49:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iGUgEPO1jTLv; Fri,  8 Nov 2024 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731062956; bh=RG8wtCmFa6QztVhedOOyUmVvDmXz9HCGpwDD3/xxUBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DodnUcfb+exUji5T3xRPKHCPr9N+j+w0jz/NXmP1gm6UrMINi3DbPKZZlBuNWqA2Z
	 ZjVpFKbDxsO0T81Wkt1Zk9N2nXYB9a54CX2WTiBEWiMiDQwReH2QtfQ0H+twNWwF1I
	 jIfwA2k7TgFF+57t765QqDzLiDKG7gunGKM1Db2jFHBfBvC2QTI0zQ3q2Di6vadSaw
	 Mn0OLflggFuLKRtcUsSkef4Lmt04i6lDnzWluDpz4ijDyty2fbP7GkE713CGAicvPb
	 jV17IWdPs7eNSYv23UpTEMMV7eJf/+HEAsCICkGmJA6HvY8oDXZNaayzscEVHe2wc9
	 jVWiQcurGUPwHAXDMaYn0/yJKStiOVX5uTkcHVq0MR9OW6y2b468wJU7V3Nc1R1vSQ
	 9aE0w/2lDW+pnq5SQV/+IDbBnVZ6/tgC+j7NHv/yMqnFRjtsPExdqIcxNnYRMAXX49
	 76MXN2haXGtUVrMo5jUMt9mMPFhR4hxg2LWX6aZBp/IAdY3JvjNtHIg/ZkP/Hg09gP
	 U08FfEfbDByXQZYxmtN/LkabL2e8uTWh1a4xtk/7cMDr1u8xRDvjKUTBkm9sTUUCX7
	 gjfg7KUKQoFLszLo33OeyTpAbakW6fRFlIE0J3WwWHqrOtHXqwvtNALpAZxm97EqBW
	 XdhnMHVcbdpM9AHCX/7JXm98=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C4B3640E0191;
	Fri,  8 Nov 2024 10:48:58 +0000 (UTC)
Date: Fri, 8 Nov 2024 11:48:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
Message-ID: <20241108104850.GAZy3skueAeYIgqf1W@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
 <72878fd9-6b04-4336-a409-8118c4306171@amd.com>
 <20241107142856.GBZyzOqHvusxcskYR1@fat_crate.local>
 <2f10fdf6-a0c7-4fa4-9180-56a3b35cc147@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2f10fdf6-a0c7-4fa4-9180-56a3b35cc147@amd.com>

On Fri, Nov 08, 2024 at 02:29:03PM +0530, Neeraj Upadhyay wrote:
> From the APIC architecture details in APM and SDM, I see these gaps are reserved

What I actually meant here is whether SAVIC enablement is going to keep adding
more and more entries here so that it becomes practically *all* possible, each
spelled out explicitly.

But I went further in your patchset and it doesn't look like it so meh, ok.

> I would ask, does above reasoning convince you with the current switch-case layout
> or you want it to be range-based?

That's fine, let's keep them like they are now and we can always revisit if
the list grows too ugly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


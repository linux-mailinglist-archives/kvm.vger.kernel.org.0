Return-Path: <kvm+bounces-34460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 984899FF486
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 17:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 590043A1FB9
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 16:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A901E2606;
	Wed,  1 Jan 2025 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SKZr7m7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839141854;
	Wed,  1 Jan 2025 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735748382; cv=none; b=DJx7byU6FhCRQzbUVEkE0oulsM8ED0a2C9o/qU2fxwVs68lFpjLXIPPuzThGB2a1sh0Xm5brJYDBmfzVJAHVMjgcCaNKQwGaWXGccEx16zvV/oVVUB8q/2hbFfYCf4xBzZpAicIfau8lh7aia468+HbNCBbbzTlpY2xxSyUgZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735748382; c=relaxed/simple;
	bh=KjvHnLXwxg4ZwuEmijGOMHK9cIkqWOfklw0xOuaEeaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0W4HrsnTmCi8lJDAu/SXoO3dlgA+GCWlAmfWYG/M2vNnYYSOY8D5WY0rgcnVjv9ICa+MkztLEAZIVLstRilUQQUJTzIAIWqwnEUTZ4zKcqy421Y/QVVY4/JTGBDG8XU987nfuStKNFs03ud08r2Wf7JPaoXAFXZqlvTg0Fes28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SKZr7m7E; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7BBA440E02D7;
	Wed,  1 Jan 2025 16:19:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Vj5v1BeU8lAT; Wed,  1 Jan 2025 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735748375; bh=nTd4/Dqu5Gm156Un7nzGz6514AtN1uWqbCpzZlDfl7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SKZr7m7EzR0l77vcZnLsDnUhxZV9Ld2ffeFmD4XzHNp7YRyeeXm8u3gwXSTkW5rJD
	 KjDndgB0UfKTVfz5weBxrCIBLnERqUFjlsXnOvRRMacKCtCPvuJhBokXiX4ijpmD90
	 E2bQCS9GVY8eTNN3EVOHTrleTVOL0hEAPWIkv8ZWHBG8BGRNJyROzGf+FFJKSkrVO7
	 don3mzJkm4w4m46gqn4DdIuUYLnSHn0Vjl1/zpULAxo57BcR1GXrEbTbj6tvzJSNiK
	 e28nxDr7PD/9vBo/JlaFd53vX8UgvQ7E9ByFslOYGNzp65Zd6q+hUAQo1f71qCVnnN
	 V/8ZbVMPuSS+HAxdjhqKcoSarpmD/NTxb48DhBKxqRAgy+VA+Jk6eLsML56soqIp0F
	 YgNz8Rwmo3rUbcS85DfeiS+qq/TO8/F6LBjLCiCrailVxGUClrKaxgeAabVlU7v55j
	 3RqWwdcSnQ/p0FaQodckDBpIcRxd2NM7ufTFu7fDeZxtrAc247klJPdOnZnLPUBukE
	 QKdqNheK2z+q6geeQPbDENKRuMxBa0Jyry0V45M1Y8NYX+fZbNsNYnapvGpRdr6EJy
	 9TYgImDGM288Xv3e0zYr622m9jtP8sxfjyUQr3PJphXIQjtSJiLD/m0+8VxM/3m3Fl
	 exUKN1bz1jOFLgOtMSDyyINk=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2130640E02C4;
	Wed,  1 Jan 2025 16:19:24 +0000 (UTC)
Date: Wed, 1 Jan 2025 17:19:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
Message-ID: <20250101161923.GDZ3VrC9C7tWjRT8xR@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
 <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
 <f46f0581-1ea8-439e-9ceb-6973d22e94d2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f46f0581-1ea8-439e-9ceb-6973d22e94d2@amd.com>

On Wed, Jan 01, 2025 at 03:14:12PM +0530, Nikunj A. Dadhania wrote:
> I can drop this patch, and if the admin wants to change the clock 
> source to kvm-clock from Secure TSC, that will be permitted.

Why would the admin want that and why would we even support that?

Your commit message starts with:

"SecureTSC enabled guests should use TSC as the only clock source, terminate
the guest with appropriate code when clock source switches to hypervisor
controlled kvmclock."

So what are we even doing here?

You do notice that you're missing answering the "why" question on all those,
which is kinda the most important one. You're adding support for something but
the supported use cases are not really clear...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


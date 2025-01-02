Return-Path: <kvm+bounces-34482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D562E9FF85C
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 11:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FE141882EC5
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D110C1ACEB4;
	Thu,  2 Jan 2025 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Hyi/zEc0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994A91A8F80;
	Thu,  2 Jan 2025 10:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735814750; cv=none; b=tdmyHoQBIFfU1UO/NNOrruJeVp8/ZtvPGCDkw9e7f22h3DFPmuOEqr74X7co8icMdT9Y8vsei4sq5zA5FWT7jDLuemhmOrhn5cufDPFUCYjTdDq0x87o4gbb9R9G0vSrGWLY+xp5lzf6ZWIQ5Pg7TFlwNaNIhVtq8frm28jVYm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735814750; c=relaxed/simple;
	bh=0NLpT75d1j/NcgFlW328VcuOwO74zf5a1WxGDKDqe4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdsW/xxeG+6Yru14E2le3y4mPzXv3tETxOlrsZ/OV4rueiLx8y57WlWlRYvGT2KSaTMWXeUZNSZQIzTc3Y3p08QgmcqUxp6GTKlQr3ry4VHECMGdfTfcuUP3ukZp4yh6OGvrpdXWX2jLHycM9dy6joBzbjElBbTERBXec/mWT3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Hyi/zEc0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C74B540E02BF;
	Thu,  2 Jan 2025 10:45:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z0DggfzsFbX8; Thu,  2 Jan 2025 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735814736; bh=aaPxCe6g1qb4UJiUOsNaRXE4hX1ZsObr26RWNTbx77I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hyi/zEc0LEog1REm1qXc6vfhsEmfJFtBwBE48P7jqIvzsQPwDZGx3Xr1PcLQg5xYR
	 jWeQzD9EBgjBVWXF/YFeB9awzdywBHJ0AAXb2V9qFhUxNvvSOzLcfIjxaODABF8QzG
	 GgR8hmaFPRxPla5UTzsyRaWClclhalZjb7PKZAsdrplzV+riJmbyUgOHtsXFyLO34U
	 ISnDyDDmHRgEHr0PkEdWAhkMFBFxXcyS6VWWfzdiDIkqeYPhMdXCloUkH5Z2ip0TYH
	 braxJe2qcUSL0VvntEK9vY6xeKL/YHrwYVsZ8D0ucyRYRqT3FDU5bWt+PzF+IiN89R
	 NIFKSGCPCa8mvsGlKt9/WwPa7tLfCIWx0mUSowg9lZ/y6DBRfT4tJbMOzKjHWGD9g7
	 vNjBxa5cyB70gD5dZLx+d75hmflKKAvLSISMRfgcHZ9mg5P461pAzbYiwQcif47Ccs
	 hS5TBcKOxN/1OzxuI6Fe2IqTzywfQu4cL/reJQnMOt9K84h4A3hSdZ7F7nOsTrQNJ+
	 o2R+L1kL5ho+PM0xAvDpz4ln6pjGa2404FyM4U0l+qLjUItgPdhCK57z1L9iY2ASCO
	 FyRu5OgztHPR10OBKhk18nRysZdIZpWCqG13EnPc9B8pldc7mg/IDAVVKBWntdPACC
	 iZaHcn8omzu6O6bcp4JVuv1g=
Received: from zn.tnic (p200300EA971f93DE329c23FFFea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93de:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D564C40E0163;
	Thu,  2 Jan 2025 10:45:24 +0000 (UTC)
Date: Thu, 2 Jan 2025 11:45:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for
 discovering TSC frequency
Message-ID: <20250102104519.GFZ3ZuPx8z57jowOWr@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
 <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
 <20250102091722.GCZ3ZZosVREObWSfX_@fat_crate.local>
 <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cc8acb94-04e7-4ef3-a5a7-12e62a6c0b3d@amd.com>

On Thu, Jan 02, 2025 at 03:31:49PM +0530, Nikunj A. Dadhania wrote:
> Sure, how about the below:
> 
> For SecureTSC enabled guests, TSC frequency should be obtained from the platform 
> provided GUEST_TSC_FREQ MSR (C001_0134h). As paravirt clock(kvm-clock) has over-ridden 
> x86_platform.calibrate_cpu() and x86_platform.calibrate_tsc() callbacks, 
> SecureTSC needs to override them with its own callbacks.

Not really.

It's like you're in a contest of "how to write a commit message which is the
shortest and has as less information as possible."

Go back, read the subthread and summarize, please, what has been discussed
here and for patch 12.

I'm missing the big picture about the relationship between kvmclock and TSC
in STSC guests. 

After asking so many questions, it sounds to me like this patch and patch 12
should be merged into one and there it should be explained what the strategy
is when a STSC guest loads and how kvmclock is supposed to be handled, what is
allowed, what is warned about, when the guest terminates what is tainted,
yadda yadda. 

This all belongs in a single patch logically.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


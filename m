Return-Path: <kvm+bounces-29938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E41B9B47BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AE801C23037
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2B7209687;
	Tue, 29 Oct 2024 10:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IECSQ7VW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5EA205AAA;
	Tue, 29 Oct 2024 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730199296; cv=none; b=boXqBvJYorsUoxWwxa8nez3GPnOz1H/BmTMqCp0tZZHDRHpSXoHdx93XYaKTEn9Q8KREINmhUQvvyLq6uiQASaMBKJ2UlEhjQkNAhgB3b0SzDMEGwXXsUnETer1MmxvtHJEpaPdQgB4wf/bNaz4jQeJjlDeVO6yO/3IY0sADOJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730199296; c=relaxed/simple;
	bh=gC+H7QLm15C/agBjYj1dg+mSd1RCF3UqqE+HwpGQ5uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gs1EaC8rQV+LCZusaAzFRYbsoSXE1KK6qoN/nsArcejcBTeJk/Vu+lpO0AeNkmvZ0fdIB6hzF+JwpfHHTUMHQMKCV7Cwz+hFonmH+HigrlrQiLIWlxRivarBemInpwkBO6J/1ajaKV+VY+D46NXFAKbl9YTfVBJ1K9NXZXXS/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IECSQ7VW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B790940E01A5;
	Tue, 29 Oct 2024 10:54:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cM-l5HXxrpYq; Tue, 29 Oct 2024 10:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730199287; bh=byUhKSSIy0fCTI2TJ1gZ89qaz0/uVMw9sRcXB4nUZTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IECSQ7VW+mO3nzDiIktCZC4N0NlxQ4yfP4jWsCjapb/H8AjKSVsYqqWDN6wrwGr3n
	 KimryU5vhe7WNvvN7RfEgrYfxQtq2zyrNLJZMrSOznZyPEG0JMwsthtIPyKLuv7ek9
	 9q9oAhlpe9bBpNUGTOHMYnYRy32vE9JMTXXOLgSiQP6vszpJBZHGWQl5gtL2kK/YBK
	 /9iFqMGYqcHPMqz1T6nU/pzT6mp62sG48g2sSd00QgjVlTGNN/w+3QES2whagBW4Bl
	 Jndqv7q3N7AnUwYfyuA1bojGnYQspzX1UZGgPwiaCiImbQ6hXTIK5rw5auqVdQhL/J
	 6cDDBHJNW2l7I4hlphd9CCDT4y+XDmDUOCB6cSlFHh2uVskXNPKNYApLWF94AjQMWP
	 gTKbfOjdhl9NhIiwz0/SdVUlnDNNxQDRjkn8Yp16WjAv580hfWOQnU4fHWLD3hhrAy
	 zIxVu5jYEWjHYxDovetxWVP1BQxRoW0pP1hRNGum9pSy6fH2LRaaJDJ0v29MS90H0E
	 nECohKYrSZfjZbQp9lvmFIaPseAL2KbmfGXwHewiFLhqwkTg1JwifzlYe14UhZv3T1
	 fqIt3ZEKUqxMcf7Yn1b/7HzfX8Ojh9hXo/xeCzD+S8T9m9Iz9VKKwtBIpreSbUy5BJ
	 EnuP6TpeiLvMyzLwb5+EKJkw=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3F54C40E0191;
	Tue, 29 Oct 2024 10:54:29 +0000 (UTC)
Date: Tue, 29 Oct 2024 11:54:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <20241029105424.GCZyC-4MMd52Hup1jK@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
 <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>

On Tue, Oct 29, 2024 at 03:54:24PM +0530, Neeraj Upadhyay wrote:
> Thanks! I plan to do something like below patch for the next version.
> Verified Secure AVIC guest kexec with this.

Sure, if you're adding a ->setup anyway, then it better have a counterpart.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


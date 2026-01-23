Return-Path: <kvm+bounces-68961-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDrXCJl2c2kEwAAAu9opvQ
	(envelope-from <kvm+bounces-68961-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:24:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBAA76343
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FAA730309AD
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 13:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D16296BA4;
	Fri, 23 Jan 2026 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Sep5riP8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4FD27FD5A;
	Fri, 23 Jan 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769174627; cv=none; b=NvWW/49d94PI2K8GlpUPcNhApALtNaCn/6BMcOvLdXbHanGRX1Pyoxq5pYjovT3fSJDGgj+15INjPML1VIc1nJpAN5PTsmAPOTP5URdZg7XGVjSxiBvqKkTohBMjCKOzPkDvWuiY9y5AJYrGWRn+SyKyoVmLrukku3wxSA9kkwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769174627; c=relaxed/simple;
	bh=qsIbjSD/QCL31YE4FtdxI22fFQbZy2O2Rk/s9JIRMxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNmU0L6wCRYd8m3coTdQ6O//QBBP4+X0S9uRVHApIgk7KEcfX7huhXelEEluyDD4FSzDVpu5RGaSP2oUnoHDUPJ1qUOIHEemd6/av+NTjN87axgVvHm6vWehXhL/JWLr0rgmfk1S3M6gE3XwAY79gKO23iYbjrlqAeDneiw96K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Sep5riP8; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 24C7240E00DE;
	Fri, 23 Jan 2026 13:23:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Xr94glA78beu; Fri, 23 Jan 2026 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769174616; bh=o0kEo4ZwY4p09KgcnIV+D87rW2bafjS++aMh3puVmBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sep5riP8nIoE145T8Qf8hQWYnP1k1bwfbNBTL0vDq97uE6LMQBfpzEFIlAa/p3bOx
	 5QgJ/x4PW+4DI5AYhOpVMwoGoWQ36mw2Qkfg59/B5giPo2rIHceI58OrFiyftST6Fk
	 JuycA8T3n4Akl7VEcozobrxVs9isOUGkG5gvPEiRR0LeWodZf0x15BGC0jfrblGctw
	 GWhO6l5ecEsl818j4gLlq9ld5EPAVYDTHwelI6pRGMr8jeQK/sK97PO/Q8rBHB99vU
	 FdUgmtOkRz2+nhMW1T4OGI3UvklxeIdlxEvT63rs4pUzjTp3k6UjYcEoh5i4v5Ti1q
	 ATvM2x/JKvur/Z4WTkZnxJyAKkH17Fy2MfPsZLFn4DLfV7WmJBMUde/6QSxRDa9H95
	 owWLc5PvS3hqZFhdJ1NQmPv1mkSwaUPJOs2Y7z+VArNFHQDH/vWeJr8MisxEEbNeln
	 cpAbIYBJoPZFTVTusR4qV1Sq8nHO66OYLwFKMbPfArOCmIqOUablt7818Kx2O6dCWV
	 E+efY3MX5+ZX7QpHsFVoulGNM4Iet3RjNtxxTEwFfCUTLxnELdPrcFFTz+wvPgN2Hx
	 hd3TTtiPcH5KLRM9g5FotbQkqiz4e5Bqipx491cq7rJn2UrgllZc6k4133fYwdvnj0
	 b9tymy3BvresnVpOpJTQBAyY=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 77D4140E02E7;
	Fri, 23 Jan 2026 13:23:31 +0000 (UTC)
Date: Fri, 23 Jan 2026 14:23:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Message-ID: <20260123132323.GAaXN2S0WQxm9o6EBG@fat_crate.local>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
 <CABgObfaxsOA301j1hb1jSEZie3v3bzsW=03PcjqQ5RWynSN1aQ@mail.gmail.com>
 <20260122111257.GAaXIGORy84Y1IedxR@fat_crate.local>
 <CABgObfZcCNyYxX+_VHhfCkYqvWyDcsJd85qpEAQCWOME6kjivg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABgObfZcCNyYxX+_VHhfCkYqvWyDcsJd85qpEAQCWOME6kjivg@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-68961-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,fat_crate.local:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CBBAA76343
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 01:00:27PM +0100, Paolo Bonzini wrote:
> I agree - as I wrote below, I judged that this was _not_ solo
> considering that (while not including any x86 maintainers) there were
> multiple people intervening and building on each other's analysis.
> Yes, there was no x86 maintainer, I obviously knew that, but my
> judgment call was that all these people together had looked at the
> code more than it deserved. In the previous mail I said the
> probability of a disagreement was small, it was even practically
> nonexistent.

This all doesn't matter. Because when it comes down to cleaning up the mess
people have left behind, it is always we who end up mopping after everyone.
And everyone esle skedaddles into their next feature enablement.

And I do appreciate more than anyone when people make an effort to review
patches. You still need a maintainer ack though.

And it is not hard - you just need to ping us/send us a private mail even call
us if you want. :-)

> I don't think you can say that this is routine, for example in commit
> eb4441864e03 ("KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA
> time", 2024-04-11) I explicitly sought an ack for just an
> EXPORT_SYMBOL change. Knowing that x86 maintainers want to tightly
> control the API boundary of arch/x86/kernel/fpu, I considered that to
> require the attention of you guys *even more* than a code change!

Much appreciated, this is how it should always work. So let's make that the
default workflow please.

> I appreciate a lot the support that Thomas and other arch/x86/ people
> put in to help Linux run well and without hacks as a hypervisor. At
> the same time I think it's fine for both sides to acknowledge that in
> extremely rare cases the lines can be blurred.

If we don't reply for a week or so, sure. But if you really need an x86
maintainer ack, I'm sure you'll get one in time.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


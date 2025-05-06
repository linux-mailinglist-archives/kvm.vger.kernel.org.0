Return-Path: <kvm+bounces-45609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C0790AACAAF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD6C17A8960
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003A1283129;
	Tue,  6 May 2025 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YncQSRNZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2303F4B1E6E;
	Tue,  6 May 2025 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548169; cv=none; b=Q8uhSo0Y6jikKFlN38hTwGwVgiDriMe+NlIkCQ0JNA/66uS81YM3J1LtBknP9ZfPs1ul10gZpn47Ha4W6lBRLS9C+EmMC71yoJYoAcPDgoMJjNxVkyJrG/9S0SB0iSlX4+H+0X7kYuEWHhkMPqmxmMupm0EdTlzRRnzSAqpX1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548169; c=relaxed/simple;
	bh=zITazA5WWfeIFTzFeyrWOa8sigVntFrqs5PW7bcdz4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3GvQjcNTEE7nGoqG0E636BtZoZCwaivfNnmTOebdq/dtPw+vCh754g1oMr1x2pF8Qsp/Id0X4ajE8+AJ/PF1Q0QtSEsaa9M5DrpsKFAcMEkQZYITYOCHTdieL0Iqv075cyKl2IuZ7NSWFfKcDdLqOWqKFjPcWTcgKA15lkWeIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YncQSRNZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EFC4CEE4;
	Tue,  6 May 2025 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746548168;
	bh=zITazA5WWfeIFTzFeyrWOa8sigVntFrqs5PW7bcdz4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YncQSRNZUvsmkJzY/MZ2wsaMNar7mg9c1WHgDHaDbzW04yL1p8iVgTC1YxE5yPcbA
	 gJDdnkKg7Z2yyZyD/mz0h9wrMVu73dmYMZf0Y0c+3bMItDf02E7ZItPLDjSnrNVJMR
	 k0+myTEWmAtKN2Ulc4aK4zk9abUxvmJc4FYsZmBysezGqPLPbNU5Crfax4HD3gHKLI
	 cJKUorPPRu94LMDIlu6JRxCvAEFhTQ1lLKNVT/sJF+UNCSxqr0aY7a2ou//NiBTc8c
	 gy1zwRXv635ukfwH0PHAy4khbMyd+jDATbz0azN37GufexNG6z/UTYGVjoED/H8DsI
	 a8UBnActHKGNg==
Date: Tue, 6 May 2025 18:16:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, xin@zytor.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/6] x86/kvm: Rename the KVM private read_msr() function
Message-ID: <aBo1w0tRoM2JUtW_@gmail.com>
References: <20250506092015.1849-1-jgross@suse.com>
 <20250506092015.1849-3-jgross@suse.com>
 <aBoUdApwSgnr3r9V@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBoUdApwSgnr3r9V@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> On Tue, May 06, 2025, Juergen Gross wrote:
> > Avoid a name clash with a new general MSR access helper after a future
> > MSR infrastructure rework by renaming the KVM specific read_msr() to
> > kvm_read_msr().
> > 
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 2 +-
> >  arch/x86/kvm/vmx/vmx.c          | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9c971f846108..308f7020dc9d 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2275,7 +2275,7 @@ static inline void kvm_load_ldt(u16 sel)
> >  }
> >  
> >  #ifdef CONFIG_X86_64
> > -static inline unsigned long read_msr(unsigned long msr)
> 
> Ewwww.  Eww, eww, eww.  I forgot this thing existed.
> 
> Please just delete this and use rdmsrq() directly (or is it still rdmsrl()? at
> this point?).

Both will work, so code-in-transition isn't build-broken unnecessarily:

  arch/x86/include/asm/msr.h:#define rdmsrl(msr, val) rdmsrq(msr, val)

:-)

Thanks,

	Ingo


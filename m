Return-Path: <kvm+bounces-57490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1271EB55E88
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 07:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C58CC3BBDEC
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 05:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA852E2DDA;
	Sat, 13 Sep 2025 05:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="DfFHlaZt"
X-Original-To: kvm@vger.kernel.org
Received: from out28-149.mail.aliyun.com (out28-149.mail.aliyun.com [115.124.28.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40218E20;
	Sat, 13 Sep 2025 05:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757740011; cv=none; b=rqEcMbmEET+UZbPaI69apw4Zy5yIFgteYR2+6A5XhA1p/nrG5Fx8yyDnZg68J7kgTN29ogpR33OrYqRTsLQl0cmIcMdWLtONtcRb4zVdoDcjZ3KZhG3/OWKKW7G8E65KARCZu5N8O+d7cJhyP9zUjMRU1g5gUWUIWhRRB9x+sDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757740011; c=relaxed/simple;
	bh=Z3Bsk4yeuSaWiOfI2QPSAKBu+5jfsIQ/9hW08Kg+oas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpOvhSCpVfI7XfujAw35DWB0jw8IjddEp/iVYiKI4Lx11IF4h6ft8kim03Whrh130/ngakVo8YKBf9hGDHdTmm0N6x6pmdYxzXZi1qLc1IGBMWWboPbE9cW21IOR+vEe2QduUq0U0EnJR+jgWdSK4pokZuYyjvWnv0cECLLScb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=DfFHlaZt; arc=none smtp.client-ip=115.124.28.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757740004; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=r1khi3w4XkNENikcoeGAA5mHsJaRYmGZ2SI2OOjmJew=;
	b=DfFHlaZtiR1yCRRQCD9IbEHH1VvxMt0Fjux6W4JZEaZOcZF7pLsuKjgPLWZ2fhkkjXU0nS1DJmqzERNexy5HO6MxCjtJAqurRyu98htIME3p5oLy9ONPJmxQz2Uyb28Vdy5GcGhqJC6gI/FeVEGukBDk1jDrW8JjSo3QAGtVJzk=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ee6pIz1_1757740003 cluster:ay29)
          by smtp.aliyun-inc.com;
          Sat, 13 Sep 2025 13:06:44 +0800
Date: Sat, 13 Sep 2025 13:06:43 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove outdated comments and code in
 kvm_on_user_return()
Message-ID: <20250913050643.GA50691@k08j02272.eu95sqa>
References: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
 <aMPbNBofTCFGTCs6@intel.com>
 <20250912093822.GA10794@k08j02272.eu95sqa>
 <20250912141132.GA85606@k08j02272.eu95sqa>
 <aMQw67a7Ku7wXTXO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMQw67a7Ku7wXTXO@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Sep 12, 2025 at 07:40:43AM -0700, Sean Christopherson wrote:
> On Fri, Sep 12, 2025, Hou Wenlong wrote:
> > On Fri, Sep 12, 2025 at 05:38:22PM +0800, Hou Wenlong wrote:
> > > On Fri, Sep 12, 2025 at 04:35:00PM +0800, Chao Gao wrote:
> > > > On Fri, Sep 12, 2025 at 03:35:29PM +0800, Hou Wenlong wrote:
> > > > >The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
> > > > >loop") moved fire_user_return_notifiers() into the section with
> > > > >interrupts disabled, so the callback kvm_on_user_return() cannot be
> > > > >interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
> > > > >remove the outdated comments and local_irq_save()/local_irq_restore()
> > > > >code in kvm_on_user_return().
> > > > >
> > > > >Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > > >---
> > > > > arch/x86/kvm/x86.c | 16 +++++-----------
> > > > > 1 file changed, 5 insertions(+), 11 deletions(-)
> > > > >
> > > > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > >index 33fba801b205..10afbacb1851 100644
> > > > >--- a/arch/x86/kvm/x86.c
> > > > >+++ b/arch/x86/kvm/x86.c
> > > > >@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> > > > > 	struct kvm_user_return_msrs *msrs
> > > > > 		= container_of(urn, struct kvm_user_return_msrs, urn);
> > > > > 	struct kvm_user_return_msr_values *values;
> > > > >-	unsigned long flags;
> > > > >
> > > > >-	/*
> > > > >-	 * Disabling irqs at this point since the following code could be
> > > > >-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> > > > >-	 */
> > > > >-	local_irq_save(flags);
> > > > >-	if (msrs->registered) {
> > > > >-		msrs->registered = false;
> > > > >-		user_return_notifier_unregister(urn);
> > > > >-	}
> > > > >-	local_irq_restore(flags);
> > > > >+	lockdep_assert_irqs_disabled();
> > > > 
> > > > kvm_offline_cpu() may call into this function. But I am not sure if interrupts
> > > > are disabled in that path.
> > > >
> > > Thanks for pointing that out. I see that interrupts are enabled in the
> > > callback during the CPU offline test. I'll remove the
> > > lockdep_assert_irqs_disabled() here.
> > >
> > 
> > Upon a second look, can we just disable interrupts in kvm_cpu_offline()?
> > The other paths that call kvm_disable_virtualization_cpu() are all in an
> > interrupt-disabled state, although it seems that
> > kvm_disable_virtualization_cpu() cannot be reentered.
> 
> Why do we care?  I.e. what is the motivation for changing this code?  I'm hesitant
> to touch this code without good reason given its fragility and subtlety.
Hi, Sean.

I'm just reworking the shared MSRs part in our inner multi-KVM. First, I
noticed that the comment mentions that kvm_on_user_return() can be
interrupted or reentered, which is a little confusing to me. Then, I
found that the comment is outdated, so I decided to remove it and also
make changes to the code. I agree that this code is fragile, maybe
just change the comment?

Thanks!


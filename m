Return-Path: <kvm+bounces-57403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A8AB55082
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D03B1D6453B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C549310763;
	Fri, 12 Sep 2025 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="g8QQNTLX"
X-Original-To: kvm@vger.kernel.org
Received: from out28-149.mail.aliyun.com (out28-149.mail.aliyun.com [115.124.28.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD9F3101BF;
	Fri, 12 Sep 2025 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757686305; cv=none; b=kITeEjGNSi+vEa1juPnZSgETkZWLHD5Ss5avMv7JMsf8aZrIkxsg07wNhGQz3EqAWwV2gmcW18BMZyQYvO5Gn8AEgsN/tQ53IQc+8qjWqX2otpt8wF4TTwZtiyJVeReZ9pr1cQ+w/dINZFmumS3zibHRNe/en/Gjc3c3i2PY/Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757686305; c=relaxed/simple;
	bh=nwrLxuf2JDHzduz/GUiOciAIp0jv1qISMxsSQFowyfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDZ32x0BIzKJIRThqlf3a8Dg8l++jggRgLDsVNU/At6Su5VS5xCbKxOVrsQO0D6wvAokAhtlXa4ZvV4wljEo5Y60qu26yggFct5cxH/S52WlWYWFMNIT0V9no2gccoXWRjV8cKEMAJ2JOHKO1vSiPHDHATFmv0hrh3mX9/uVq6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=g8QQNTLX; arc=none smtp.client-ip=115.124.28.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757686293; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=I6T3awF45z8Oj7L53ozAA+eDlKnbLqdaFZSi9rTl9jk=;
	b=g8QQNTLX1NkJRSL1SF4ug2CsJqnLm9mI4rgiBk6+4AhpZUtSeHCBRU0E0P+1bjhYu+5yYAG5dpinQo6nGvWAZaPhpu0ZMzYwD9tJKymGA1Hxc/VUNamCLtidY8o2eef56WLUVexBlw6/J0dIRkRDopVXcQTIRZX9DJpXzACZSWA=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.edkF-5f_1757686292 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 22:11:32 +0800
Date: Fri, 12 Sep 2025 22:11:32 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove outdated comments and code in
 kvm_on_user_return()
Message-ID: <20250912141132.GA85606@k08j02272.eu95sqa>
References: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
 <aMPbNBofTCFGTCs6@intel.com>
 <20250912093822.GA10794@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912093822.GA10794@k08j02272.eu95sqa>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Sep 12, 2025 at 05:38:22PM +0800, Hou Wenlong wrote:
> On Fri, Sep 12, 2025 at 04:35:00PM +0800, Chao Gao wrote:
> > On Fri, Sep 12, 2025 at 03:35:29PM +0800, Hou Wenlong wrote:
> > >The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
> > >loop") moved fire_user_return_notifiers() into the section with
> > >interrupts disabled, so the callback kvm_on_user_return() cannot be
> > >interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
> > >remove the outdated comments and local_irq_save()/local_irq_restore()
> > >code in kvm_on_user_return().
> > >
> > >Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > >---
> > > arch/x86/kvm/x86.c | 16 +++++-----------
> > > 1 file changed, 5 insertions(+), 11 deletions(-)
> > >
> > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >index 33fba801b205..10afbacb1851 100644
> > >--- a/arch/x86/kvm/x86.c
> > >+++ b/arch/x86/kvm/x86.c
> > >@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
> > > 	struct kvm_user_return_msrs *msrs
> > > 		= container_of(urn, struct kvm_user_return_msrs, urn);
> > > 	struct kvm_user_return_msr_values *values;
> > >-	unsigned long flags;
> > >
> > >-	/*
> > >-	 * Disabling irqs at this point since the following code could be
> > >-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> > >-	 */
> > >-	local_irq_save(flags);
> > >-	if (msrs->registered) {
> > >-		msrs->registered = false;
> > >-		user_return_notifier_unregister(urn);
> > >-	}
> > >-	local_irq_restore(flags);
> > >+	lockdep_assert_irqs_disabled();
> > 
> > kvm_offline_cpu() may call into this function. But I am not sure if interrupts
> > are disabled in that path.
> >
> Thanks for pointing that out. I see that interrupts are enabled in the
> callback during the CPU offline test. I'll remove the
> lockdep_assert_irqs_disabled() here.
>

Upon a second look, can we just disable interrupts in kvm_cpu_offline()?
The other paths that call kvm_disable_virtualization_cpu() are all in an
interrupt-disabled state, although it seems that
kvm_disable_virtualization_cpu() cannot be reentered.
  
> > Documentation/core-api/cpu_hotplug.rst says that callbacks in the ONLINE section
> > are invoked with interrupts and preemption enabled.
> > 
> > >+
> > >+	msrs->registered = false;
> > >+	user_return_notifier_unregister(urn);
> > >+
> > > 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
> > > 		values = &msrs->values[slot];
> > > 		if (values->host != values->curr) {
> > >--
> > >2.31.1
> > >
> > >


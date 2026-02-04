Return-Path: <kvm+bounces-70165-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEdfBNMOg2kBhQMAu9opvQ
	(envelope-from <kvm+bounces-70165-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:18:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D7CE3B90
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3D3B83025E76
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4003A1E9B;
	Wed,  4 Feb 2026 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="wGdUrGti"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B56221FAC;
	Wed,  4 Feb 2026 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770196666; cv=none; b=tdeobr/s9pEsfKlJz/uZXtKH6vV0so/UxgUKvC5wj8+nNqH8bGIvpQGisVfnIkN1HpBpHDDTR9F9dDl4gl8NDPhEhk/z7FE/Xjii7PlNuXv+bQErdMRLYtktIYHTL2vBA558fv/ah9aTTtcix79AVrj9DzM+iOMybTDdI6v4xpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770196666; c=relaxed/simple;
	bh=rTjzOHeWG9eHm33rQDOPGTZZySKoFz1aHEHitCndjIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h10BqJxe1xVjNI7J4mmAdJT8j767N5d15sbzUBvp1WYUhAZ9v3fSx7C2skkkf0OeZXZzLzMDmF7HKC6hwsxvnYY6kIMxMyqgjQSM/Y5TG7jAcBZfJrER+W0xRw7nsvRF7BKf0EBnttb5WhTq+yd5nz+7DJshhr3Pcelhg+9nnF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=wGdUrGti; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770196666; x=1801732666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gSpoUwnGMiw8Hd9rxHOb3HRj7lon6L0Wu64wAWcD0ZA=;
  b=wGdUrGtij/1vJJHOHvHifJnnQT/Mqo8Mv1OcrGQfdnucIZ2OUraYOxXB
   i00Wkq7A7tcQ+v8CnaQ1hHWFZKiAYZ6jRO/J/2A9MQWnnxiIdg5okicub
   m14Sxr9yKkH3D2BNMxCrVGGAOw3WXx2QT92x2mprGiTgtyXyy1eVyK+hV
   Tc6J8NK4vAL3dy8MMj+qaOTlWK+t3WL4vVnFqsC5FpcIb0aeVQSmkZYXp
   DOobgdaM+s/Q06ZSXn86C/2ngj7p1OOF8Ne6K5Ze+/zbYAwyCaIm2XzRx
   6OZ9aoSCMze5TUm9HDUJuvidckZ4JzM0cb8iHzGH7+wZbP4S0eIIT1VMW
   g==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 18:17:39 +0900
X-IronPort-AV: E=Sophos;i="6.21,272,1763391600"; 
   d="scan'208";a="608110368"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 18:17:38 +0900
Date: Wed, 4 Feb 2026 18:17:29 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <aYMOqXTYMJ_IlEFA@JPC00244420>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70165-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[sony.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C5D7CE3B90
X-Rspamd-Action: no action

Hi Sohil,

On Tue, Feb 03, 2026 at 01:08:39PM -0800, Sohil Mehta wrote:
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index d93f87f29d03..cc64d61f82cf 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -2456,6 +2456,12 @@ static void lapic_resume(void *data)
> >  	if (x2apic_mode) {
> >  		__x2apic_enable();
> >  	} else {
> > +		/*
> > +		 * x2apic may have been re-enabled by the
> > +		 * firmware on resuming from s2ram
> > +		 */
> > +		__x2apic_disable();
> > +
> 
> We should likely only disable x2apic on platforms that support it and
> need the disabling. How about?
> 
> ...
> } else {
> 	/*
> 	 *
> 	 */
> 	if (x2apic_enabled())
> 		__x2apic_disable();

__x2apic_disable disables x2apic only if boot_cpu_has(X86_FEATURE_APIC)
and x2apic is already enabled. x2apic_enabled also does the same checks,
the only difference being, it uses rdmsrq_safe instead of just rdmsrq,
which is what __x2apic_disable uses. The safe version is because of
Boris' suggestion [1]. If that's applicable here as well, then rdmsrq in
__x2apic_disable should be changed to rdmsrq_safe.

> I considered if an error message should be printed along with this. But,
> I am not sure if it can really be called a firmware issue. It's probably
> just that newer CPUs might have started defaulting to x2apic on.
> 
> Can you specify what platform you are encountering this?


I'm not sure it's the CPU defaulting to x2apic on. As per Section
12.12.5.1 of the Intel SDM:

	On coming out of reset, the local APIC unit is enabled and is in
	the xAPIC mode: IA32_APIC_BASE[EN]=1 and IA32_APIC_BASE[EXTD]=0.

So, the CPU should be turning on in xapic mode. In fact, when x2apic is
disabled in the firmware, this problem doesn't happen.

Either way, a pr_warn maybe helpful. How about "x2apic re-enabled by the
firmware during resume. Disabling\n"?

[1] https://lore.kernel.org/all/20150116095927.GA18880@pd.tnic/


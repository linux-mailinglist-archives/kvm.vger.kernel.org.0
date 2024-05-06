Return-Path: <kvm+bounces-16757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EF28BD48F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF4E01F21920
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439F3158A2C;
	Mon,  6 May 2024 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="nS0GtGqJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49B0158856
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715020006; cv=none; b=eQtO531AspTENNz9/eOQt6un6gG4546HdZPRfIODGxDFp3WdI4/f4QcX6BDcK+PHvIw+hdVpyN71TuAPhgMNvKunbVwzy/P/XJzSAhUOF7mnaAzW7cbQwZS9NZN01qfVeC7H0A5ltM0Bzv2/33iJ4QNGfKlQeS605So1HHyMz18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715020006; c=relaxed/simple;
	bh=TWG8EkL2xqhBxJYP5JorfJKSVUeeorU/e0Bn10TkM0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5HoskUgwf9qMaTOb6oPpFCb2AjcwcId7pFh4vAZ6fHQJkBbOuD76IrJ31R1LU+cW/sfuA9uY8tbJY94aaSZUnpZ7J+I7YNG+NGroRtaKtFhh154OJVVGpAJFHr3gy9mYyxGmV5njznojxx74MOEySgjUiGEzdg8wf40ikmwGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=nS0GtGqJ; arc=none smtp.client-ip=84.16.66.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VY8xq5t57zQcT;
	Mon,  6 May 2024 20:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1715019999;
	bh=TWG8EkL2xqhBxJYP5JorfJKSVUeeorU/e0Bn10TkM0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nS0GtGqJE2QABWAONc3BNDXfSWleNpgLX87Hhy6Icd35ImRg2804yi0AOn3k7HkdW
	 3S/oSteTfVZrqSBeSwWVP/y143t4qZfC9pCOc7acbtN6VPYD9GQAfktSavIwWarLnj
	 NUS3efLdwhAN/+0EZ/SuIKzmo1AxaRkbfxbUZ+5M=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VY8xq1gWSzpGb;
	Mon,  6 May 2024 20:26:39 +0200 (CEST)
Date: Mon, 6 May 2024 20:26:38 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	James Morris <jamorris@linux.microsoft.com>, kvm@vger.kernel.org, 
	Thara Gopinath <tgopinath@linux.microsoft.com>, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Subject: Re: 2024 HEKI discussion: LPC microconf / KVM Forum?
Message-ID: <20240506.eBegohcheM0a@digikod.net>
References: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com>
 <ZjV0vXZJJ2_2p8gz@google.com>
 <F301C3DE-2248-4E73-B694-07DC4FB6AE80@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <F301C3DE-2248-4E73-B694-07DC4FB6AE80@redhat.com>
X-Infomaniak-Routing: alpha

On Sat, May 04, 2024 at 03:10:33AM GMT, Paolo Bonzini wrote:
> 
> 
> Il 4 maggio 2024 01:35:25 CEST, Sean Christopherson <seanjc@google.com> ha scritto:
> >The most contentious aspects of HEKI are the guest changes, not the KVM changes.
> >The KVM uAPI and guest ABI will require some discussion, but I don't anticipate
> >those being truly hard problems to solve.
> 
> I am not sure I agree... The problem with HEKI as of last November was that it's not clear what it protects against. What's the attack and how it's prevented.

The initial goal of Heki is to "duplicate" the guest's kernel self
protections in a higher level privilege component (i.e. the hypervisor),
and potentially to make it possible to add new protections.

> Pinning CR0/CR4 bits is fine and okay it helps for SMEP/SMAP/WP, but it's not the interesting part.

I though we agree that we need to start with something small and
incrementally build on top of that, hence this patch series [1].

[1] https://lore.kernel.org/r/20240503131910.307630-1-mic@digikod.net

> 
> For example, it is nice to store all the kernel text in memory that is not writable except during module loading and patching, but it doesn't add much to the security of the system if writability is just a hypercall away. So for example you could map the module loading and patching code so that it has access to read-only data (enforced by the hypervisor system-wide) but on the other hand can write to the kernel text.

Exactly, that's why we implemented immutability for the guest to only be
able to add more constraints to itself.  This is still the case for the
new CR-pinning patch series.  However, as you mention, we also need to
handle dynamic memory changes such as module loading.  We are actively
working on this and we have promising results.  Madhavan can explain in
more details but I think it would be wise to delay that discussion when
we'll send a dedicated patch series and when we'll have agree on the
current CR-pinning one.

> 
> So a potential API could be: 
> - a hypercall to register a key to be used for future authentication
> - a hypercall to copy something to that region of memory only if the data passes some HMAC or signature algorithm
> - introduce a VTL-like mechanism for permissions on a region of memory, e.g.: memory that is never writable except from more privileged code (kernel text), memory that is never writable except through a hypercall.
> 
> And that is not necessarily a good idea or even something implementable :) but at least it has an attack model and a strategy to prevent it 
> 
> Otherwise the alternative would be to use VTLs for Linux and adopt a similar API in KVM. That is more generic, but it is probably even more controversial for guest side changes and therefore it needs even more a clear justification of the attack model and how it's mitigated.

Because Hyper-V has VTLs, we implemented the same protections on Hyper-V
with this mechanism.  There is not such thing with KVM (and other
hypervisors), and we'd like to implement practical protection not
relying on hypothetical future features.  If/when KVM get a feature
similar to VTLs, we could then use it for some advanced protections.
Anyway, as mentioned by Sean, KVM's userspace still need to
manage/control a big part of the guest protection, at least the
CR-pinning and memory permission, and this would probably not change
with VTLs but only add more complexity.

At the end I think the current hypercall and VM exit interfaces,
enhanced with full userspace control as requested by Sean, are good.
What do you think?

> 
> Paolo 
> 
> > And if you really want to get HEKI
> >moving, I would advise you not wait until September to hash out the KVM side of
> >things, e.g. I'd be more than happy to talk about HEKI in a PUCK[3] session.

Sure!


Return-Path: <kvm+bounces-68869-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICgpFt37cWmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68869-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:28:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3476541A
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BCFE0864915
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE7133BBCC;
	Thu, 22 Jan 2026 10:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1P/WZwR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BF1225409;
	Thu, 22 Jan 2026 10:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769077187; cv=none; b=XPg+jtKaSGDzXFU15kl0Ncf/MiOiwFEs1nmhu2sYi2w7hPGQA0Kme8GSRZr4MnpnpxA4OXUUwucycq1ONp+i5W2Ou6cYo/IDZNTEJjpOh6uXAjW4uC4TtYAJQk1b9K5ttGPALqB4iCrspZg482ELE0IQYhi5E6p9bSpfA/lXo0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769077187; c=relaxed/simple;
	bh=L3IZIC+janpa8bX+oY0ioO1Giiv4Fy8ez5t+eXi0T44=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqQRVe+OHgvSuM1ThOXFMlGyDXBMyYCHpmv7RQBwazJDsDVNZokksLUoFIwPx93EBQpVzUPHAQL3OKUDsYX15zHQ4bKsweitI7ZanrvuqNMrYYj61bH+EW7DNgAgPBR32qM9SfaTq9ebPdr4wsqGU/kmIjKK5uW//UgM/1oTDbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1P/WZwR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92310C116C6;
	Thu, 22 Jan 2026 10:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769077186;
	bh=L3IZIC+janpa8bX+oY0ioO1Giiv4Fy8ez5t+eXi0T44=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N1P/WZwRllaQdaCucmkBP+pPH7El0CU0NjCzFfOIfRnIiBl7Szv1Y+ZjV79tzN9xn
	 ajY4po3Ld1ovsW50CNxyjMjN5JvsynFADJNZk3qATuDLQ3ml0m+U0rwL3X47A+ouUt
	 mwh0kEwcMyyGHlw4E3c2iNeL8c7etpIeoDwmlB2skGqjXE1Rs1H1qtFAbbTmnP5CgD
	 mF/MVPNvgLVcKYukr0STFjfmUVhlW/TWfdoqi3CWowxRQ8YugXv//iesAKhGqaI/Cj
	 /v6WsfPEpsZJydwSHS/3/q9H+77I3G58POJU8n+jo9ozUSxRl6zKcBcvYHgjwUV5UK
	 IUGABtKslDErg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1virmy-00000004do1-0e5m;
	Thu, 22 Jan 2026 10:19:44 +0000
Date: Thu, 22 Jan 2026 10:19:43 +0000
Message-ID: <86v7guar0g.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>,
	Naveen Rao <Naveen.Rao@amd.com>,
	Crystal Wood <crwood@redhat.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock across IRTE updates in IOMMU)
In-Reply-To: <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
References: <20250611224604.313496-2-seanjc@google.com>
	<20250611224604.313496-40-seanjc@google.com>
	<njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
	<42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
	<874iovu742.ffs@tglx>
	<87pl7jsrdg.ffs@tglx>
	<5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, tglx@kernel.org, Ankit.Soni@amd.com, seanjc@google.com, oliver.upton@linux.dev, joro@8bytes.org, dwmw2@infradead.org, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, sarunkod@amd.com, vasant.hegde@amd.com, mlevitsk@redhat.com, joao.m.martins@oracle.com, francescolavra.fl@gmail.com, dmatlack@google.com, Naveen.Rao@amd.com, crwood@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,amd.com,google.com,linux.dev,8bytes.org,infradead.org,linux.intel.com,lists.infradead.org,lists.linux.dev,vger.kernel.org,redhat.com,oracle.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-68869-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: BB3476541A
X-Rspamd-Action: no action

On Wed, 21 Jan 2026 18:13:43 +0000,
Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> Sorry, not sure how the previous email ended up encrypted.
>=20
> On 1/8/26 22:53, Thomas Gleixner wrote:
> > On Thu, Jan 08 2026 at 22:28, Thomas Gleixner wrote:
> >> On Mon, Dec 22 2025 at 15:09, Paolo Bonzini wrote:
> >>> Of the three, the most sketchy is (a); notably, __setup_irq() calls
> >>> wake_up_process outside desc->lock.  Therefore I'd like so much to tr=
eat
> >>> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix=
 is
> >>=20
> >> It's not more sketchy than VIRT assuming that it can do what it wants
> >> under rq->lock. =F0=9F=99=82
> >=20
> > And just for the record, that's not the only place in the irq core which
> > has that lock chain.
> >=20
> > irq_set_affinity_locked()       // invoked with desc::lock held
> >     if (desc->affinity_notify)
> >        schedule_work()           // Ends up taking rq::lock
> >=20
> > and that's the case since cd7eab44e994 ("genirq: Add IRQ affinity
> > notifiers"), which was added 15 years ago.
> >=20
> > Are you still claiming that this is a kernel/irq bug?
>=20
> Not really, I did say I'd like to treat it as a kernel/irq bug...
> but certainly didn't have hopes high enough to "claim" that.
> I do think that it's ugly to have locks that are internal,
> non-leaf and held around callbacks; but people smarter than
> me have thought about it and you can't call it a bug anyway.
>=20
> For x86/AMD we have a way to fix it, so that part is not a problem.
>=20
> For the call(*) to irq_set_affinity() in arch/arm64/kvm/'s
> vgic_v4_load() I think it can be solved as well.
> kvm_make_request(KVM_REQ_RELOAD_GICv4) will delay vgic_v4_load()
> to a safe spot, so just cache the previous smp_processor_id() and,
> if it is different, do the kvm_make_request() and return instead
> of calling irq_set_affinity().
>=20
> vgic_v3_load() is the only place that calls it from the preempt
> notifier, so this behavior can be tied to a "bool delay_set_affinity"
> argument to vgic_v4_load() or placed in a different function.
>=20
> Marc/Oliver, does that sound doable?

Potentially. But there are a few gotchas that may need surgery beyond
KVM itself, all the way down to the ITS code that abstract the
differences between v4.0 and v4.1.

I'll have a look over the weekend.

Thanks,

	M.

--=20
Without deviation from the norm, progress is not possible.


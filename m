Return-Path: <kvm+bounces-72101-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MI/zOOfRoGlHnAQAu9opvQ
	(envelope-from <kvm+bounces-72101-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:06:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9315B1B0BD9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBB2530AA01B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F68449EAF;
	Thu, 26 Feb 2026 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeP18rNY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2A330652;
	Thu, 26 Feb 2026 23:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147128; cv=none; b=Cl5/mhc7gT4BcyS4Sc6RqNEsitFUdBR5Luq03S1dpH1QwZqvqL/KgaGCYE2iTNrimraoeRbtCPXggb88H4iDyvjAAZHocu4Ip+49b56tBK4bitXLCJ+io85UleQuZaAX9GhdLmSnId5IsIpDNtRzKmcdbPGQ8krgdcwChaypJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147128; c=relaxed/simple;
	bh=sPgCA9ohTSBtInSypJVYHZRcpxI7ECO568juyPVkSGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hpk23p/CCLgiwEO5aHBNXcYY/6AtHZ8cN4bmfL2GaspSU8AH1ftQo5uTgcGiwC2MZmHBmhgGN1jwMrUzIeSAWM5sNz5IVCPj9K7G1a0bZyJ37yiv0nAAI+tWu8LyJu7BYHZUW79yQTyDJWdTOwhDpDC5iYHW09s/8N6dFwnqjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YeP18rNY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6D6C116C6;
	Thu, 26 Feb 2026 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772147128;
	bh=sPgCA9ohTSBtInSypJVYHZRcpxI7ECO568juyPVkSGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YeP18rNY4v9IeLt8Tz/aP65S/WVUS3VEjY1QKawXIf1Nk5G71+7pMmVetSqkS9Q83
	 0aijxsp+XOMgFv3a18rx+7GGF0VwnER0oGPweSOxg2P5g9LhHWVkoezJwJWuw+a7zS
	 i14cRm9d/dAZavB2jqY63wD5ajUgGYZkMaxzM9CWoSq+eIMzcF7KTeIDpdECTeA13J
	 h+ET67UrLkDQ9UjphbVmystA/twgma7lp67O0awlIDs37JG+vaSiMPGcU5YAipSD95
	 O8tSVKKUbwU0s53DRvnjQYDCDmJ48d2cRmzgtF3PL28twpYDZIXEGgHn1aO6fFi/93
	 toB83PzGWCIuA==
Date: Thu, 26 Feb 2026 15:05:26 -0800
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Message-ID: <aaDRtkdU85kULqwm@kernel.org>
References: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
 <20260225-hybrid-v3-1-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
 <aaA0gn9O8QAf9Gpu@kernel.org>
 <fbcadab4-676b-44e4-8afa-b8bd095f8981@rsg.ci.i.u-tokyo.ac.jp>
 <b81cbeb7-6541-4a1f-b08e-2b5c9ee66b69@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b81cbeb7-6541-4a1f-b08e-2b5c9ee66b69@rsg.ci.i.u-tokyo.ac.jp>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72101-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oupton@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9315B1B0BD9
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 11:47:54PM +0900, Akihiko Odaki wrote:
> On 2026/02/26 23:43, Akihiko Odaki wrote:
> > On 2026/02/26 20:54, Oliver Upton wrote:
> > > Hi Akihiko,
> > > 
> > > On Wed, Feb 25, 2026 at 01:31:15PM +0900, Akihiko Odaki wrote:
> > > > @@ -629,6 +629,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
> > > > *vcpu, int cpu)
> > > >           kvm_vcpu_load_vhe(vcpu);
> > > >       kvm_arch_vcpu_load_fp(vcpu);
> > > >       kvm_vcpu_pmu_restore_guest(vcpu);
> > > > +    if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY,
> > > > &vcpu- >kvm->arch.flags))
> > > > +        kvm_make_request(KVM_REQ_CREATE_PMU, vcpu);
> > > 
> > > We only need to set the request if the vCPU has migrated to a different
> > > PMU implementation, no?
> > 
> > Indeed. I was too lazy to implement such a check since it won't affect
> > performance unless the new feature is requested, but having one may be
> > still nice.

I'd definitely like to see this.

> > > 
> > > >       if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> > > >           kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> > > > @@ -1056,6 +1058,9 @@ static int check_vcpu_requests(struct
> > > > kvm_vcpu *vcpu)
> > > >           if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> > > >               kvm_vcpu_reload_pmu(vcpu);
> > > > +        if (kvm_check_request(KVM_REQ_CREATE_PMU, vcpu))
> > > > +            kvm_vcpu_create_pmu(vcpu);
> > > > +
> > > 
> > > My strong preference would be to squash the migration handling into
> > > kvm_vcpu_reload_pmu(). It is already reprogramming PMU events in
> > > response to other things.
> > 
> > Can you share a reason for that?
> > 
> > In terms of complexity, I don't think it will help reducing complexity
> > since the only common things between kvm_vcpu_reload_pmu() and
> > kvm_vcpu_create_pmu() are the enumeration of enabled counters, which is
> > simple enough.

I prefer it in terms of code organization. We should have a single
helper that refreshes the backing perf events when something has
globally changed for the vPMU.

Besides this, "create" is confusing since the vPMU has already been
instantiated.

> > In terms of performance, I guess it is better to keep
> > kvm_vcpu_create_pmu() small since it is triggered for each migration.

I think the surrounding KVM code for iterating over the counters is
inconsequential compared to the overheads of calling into perf to
recreate the PMU events. Since we expect this to be slow, we should only
set the request when absolutely necessary.

> > > > +static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
> > > > +{
> > > > +    struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> > > > +
> > > > +    return kvm_pmu_enabled_counter_mask(vcpu) & BIT(pmc->idx);
> > > >   }
> > > 
> > > You're churning a good bit of code, this needs to happen in a separate
> > > patch (if at all).
> > 
> > It makes sense. The next version will have a separate patch for this.

If I have the full picture right, you may not need it with a common
request handler.

> > > 
> > > > @@ -689,6 +710,14 @@ static void
> > > > kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
> > > >       int eventsel;
> > > >       u64 evtreg;
> > > > +    if (!arm_pmu) {
> > > > +        arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
> > > 
> > > kvm_pmu_probe_armpmu() takes a global mutex, I'm not sure that's what we
> > > want.
> > > 
> > > What prevents us from opening a PERF_TYPE_RAW event and allowing perf to
> > > work out the right PMU for this CPU?
> > 
> > Unfortunately perf does not seem to have a capability to switch to the
> > right PMU. tools/perf/Documentation/intel-hybrid.txt says the perf tool
> > creates events for each PMU in a hybird configuration, for example.
> 
> I think I misunderstood what you meant. Letting
> perf_event_create_kernel_counter() to figure out what a PMU to use may be a
> good idea. I'll give a try with the next version.

Yep, this is what I was alluding to.

> > 
> > > 
> > > > +        if (!arm_pmu) {
> > > > +            vcpu_set_on_unsupported_cpu(vcpu);
> > > 
> > > At this point it seems pretty late to flag the CPU as unsupported. Maybe
> > > instead we can compute the union cpumask for all the PMU implemetations
> > > the VM may schedule on.
> > 
> > This is just a safe guard and it is a responsibility of the userspace to
> > schedule the VCPU properly. It is conceptually same with what
> > kvm_arch_vcpu_load() does when migrating to an unsupported CPU.

I agree with you that we need to have some handling for this situation.

What I don't like about this is userspace doesn't discover its mistake
until the guest actually programs a PMC. I'd much rather preserve the
existing ABI where KVM proactively rejects running a vCPU on an
unsupported CPU.

> > > > +    case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
> > > > +        lockdep_assert_held(&vcpu->kvm->arch.config_lock);
> > > > +        if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY,
> > > > &vcpu->kvm->arch.flags))
> > > > +            return 0;
> > > 
> > > We don't need a getter for this, userspace should remember how it
> > > provisioned the VM.
> > 
> > The getter is useful for debugging and testing. The selftest will use it
> > to query the current state.

That's fine for debugging this on your own kernel but we don't need it
upstream. There's several other vPMU attributes that are write-only,
like KVM_ARM_VCPU_PMU_V3_SET_PMU.

Thanks,
Oliver


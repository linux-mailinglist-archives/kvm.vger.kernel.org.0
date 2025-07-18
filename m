Return-Path: <kvm+bounces-52877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6F6B0A0B1
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 12:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A31C5A6BC0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 10:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C361FDA8C;
	Fri, 18 Jul 2025 10:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OETsJ0mo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7D829DB7F;
	Fri, 18 Jul 2025 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752834606; cv=none; b=CsMIBHQBIMR94c4DpThZW6iQmqSZuYlxIOpyFbZZ5Zo6/inxJyi1mTVGNXQV2/4PQTeAqLytrCVgW2E0qq4tlQfkxukSgfjH6QsGBeJuqFwySdngaCg02N/sXx73q2EoL3S6Gy9TWiBGAz5qLB/QWiiV9KTp5LKMQ3QwSQVjG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752834606; c=relaxed/simple;
	bh=ECufaz3871xjNxFASxSlshlsoO0I2L3TinnHPyAHoH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCWwxSKErz6GYF3TvLKHtj4blulcurvXOVh968FItMGAHZnzuZo5jte6NO/o+/kO5x1Zxms5K9z5v58h+2oy+k8HeJQ7ItXYTkPGlKQpNTKe6BQFgRtwboYoCXy9LWaCw3RsfSTmZgeZsFA2iuf9cjFk46bGW8Qx1LH8keC+kpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OETsJ0mo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D757DC4CEEB;
	Fri, 18 Jul 2025 10:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752834606;
	bh=ECufaz3871xjNxFASxSlshlsoO0I2L3TinnHPyAHoH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OETsJ0moZ6UUQ5VVS6FKHQ0GVASAecxj02ZCPspgLvYExmYff6rz54ujUVyaWEbK+
	 SXiDwp++tr5uvcJghyqN8gZUFOzy5dQGfVBgFe+KNdqhFdKA10405n2GxeA6iW90XF
	 locIl2orBvZ2ulwLHQ7pEtw7TjG9zzGCzY2nO1S0yFYDKhb05qGdKPzSK5USlwySCA
	 wpeInCSJW+WJdsibbk4cUlwx0OmkMUqqv8nvs8AD8SNR/g5sJZvsrmRtU5TsZs5G9A
	 L2ocIzPP0zdI0mMB8NVhqpECRpfrEUdqTuMTt5bcqB3QUATBeYsnm+w07R5Vq+x2C6
	 ffco8s0G2tM8w==
Date: Fri, 18 Jul 2025 15:51:35 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
Message-ID: <6dl4vsf3k7qhx2aunc5vdhvtxpnwqp45lilpdsp4jksxtgdu6t@kubfenz4bdey>
References: <cover.1740036492.git.naveen@kernel.org>
 <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
 <aFngeQ5x6QiP7SsK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFngeQ5x6QiP7SsK@google.com>

On Mon, Jun 23, 2025 at 04:17:13PM -0700, Sean Christopherson wrote:
> On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> > From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > 
> > Newer AMD platforms enhance x2AVIC feature to support up to 4096 vcpus.
> > This capatility is detected via CPUID_Fn8000000A_ECX[x2AVIC_EXT].
> > 
> > Modify the SVM driver to check the capability. If detected, extend bitmask
> > for guest max physical APIC ID to 0xFFF, increase maximum vcpu index to
> > 4095, and increase the size of the Phyical APIC ID table from 4K to 32K in
> > order to accommodate up to 4096 entries.
> 
> Kinda silly, but please split this into (at least) two patches.  One to introduce
> the variables to replace the macros, and then one to actually implement support
> for 4096 entries.  That makes it a _lot_ easier to review each change (I'm having
> trouble teasing out what's actually changing for 4k support).

Sure, let me re-work the patches.

> 
> The changelog also needs more info.  Unless I'm misreading the diff, only the
> physical table is being expanded?  How does that work?  (I might be able to
> figure it out if I think hard, but I shouldn't have to think that hard).

Right - it is primarily just the physical ID table being expanded to 
allow AVIC hardware to lookup APIC IDs for vCPUs beyond 511.

As an aside, updated APM covering 4k vCPU support (and other updates) 
has now been published:
https://docs.amd.com/v/u/en-US/24593_3.43

> > @@ -1218,8 +1224,19 @@ bool avic_hardware_setup(void)
> >  
> >  	/* AVIC is a prerequisite for x2AVIC. */
> >  	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> > -	if (x2avic_enabled)
> > -		pr_info("x2AVIC enabled\n");
> > +	if (x2avic_enabled) {
> > +		x2avic_4k_vcpu_supported = !!(cpuid_ecx(0x8000000a) & 0x40);
> 
> No, add an X86_FEATURE_xxx for this, don't open code the CPUID lookup.  I think
> I'd even be tempted to use helpers instead of  

Ack.

> 
> > +		if (x2avic_4k_vcpu_supported) {
> > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
> > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
> > +		} else {
> > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
> > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
> > +		}
> > +
> > +		pr_info("x2AVIC enabled%s\n",
> > +			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
> 
> Maybe print the max number of vCPUs that are supported?  That way there is clear
> signal when 4k *isn't* supported (and communicating the max number of vCPUs in
> the !4k case would be helpful too).

I'm tempted to go the opposite way and not print that 4k vCPUs are 
supported by x2AVIC. As it is, there are many reasons AVIC may be 
inhibited and lack of 4k vCPU support is just one other reason, but only
for large VMs.

Most users shouldn't have to care: where possible, AVIC will be enabled 
by default (once that patch series lands). Users who truly care about 
AVIC will anyway need to confirm AVIC isn't inhibited since looking at 
the kernel log won't be sufficient. Those users can very well use cpuid 
to figure out if 4k vCPU support is present.


Thanks,
Naveen



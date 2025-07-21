Return-Path: <kvm+bounces-52992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48274B0C616
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CBD45434E3
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDA62D9EE5;
	Mon, 21 Jul 2025 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6gBUFyi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005202877F4;
	Mon, 21 Jul 2025 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107645; cv=none; b=VAToTsU7PRe0iivNShZyuRnWe6P03tS+AGwVVSnuZB9l9isNcaSxSrWOyW7oFEznBhUvdMmUwXLcaH/WtMAb9RiKvY/U3CLP1EbgcjqWKjrKT/pbaAK3tmCqtJUvgI8B6gMZg7y9xDuH02Na6o2XgJiWSOGWBLQHR9HwiqaAG3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107645; c=relaxed/simple;
	bh=VFhkdEutks50ceezsDDEQiy4eCWTl8NC39/R5H30lv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOtzYGUaqAkVHZ5eYdNa9GmJSVHMGfVOF3mDVLlEbsiyRi5AIy1vmC+K9vnoxzrz5Yv7/zdjHC6B8qp1bPGi9h9WlTruFP8yRZwtGPjRPfAINzt1nBUGilOtG/MoMHqd8eH4sC3fAS71LGBMeaDLHui10bgCQ/Toos7lTQbZ3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6gBUFyi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E40FC4CEED;
	Mon, 21 Jul 2025 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753107644;
	bh=VFhkdEutks50ceezsDDEQiy4eCWTl8NC39/R5H30lv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l6gBUFyisDwBcRNDCEBtEVt+QEUEutN+9azpgSj9gTi8C/HlGtoGs1wmpNjQf8O4g
	 kH5FmuFDevorX9F6YsE/bOUbOrnZS3V/VTVa4kgIIpHOYUrZbf650IBubGHda2tewa
	 qZsXohyYPw2KnBUZ29x/7DJmBzFzjxfrbSyFgJ3DSGCpN5AKZXwygqukD+2i86lqHs
	 604oNvJxrJ64uO7/8AFY03TO/qIJ+vKn2DF43HqoQOKmFwJKSYoHNHM9Ofpt5g3SsS
	 7gv6KtdPkoUjzqQpWhvLXocmnvEv3Vq5qAi4IHS/QPYydQf7oaKyLC8fYC1zsbz3Vv
	 L8xIoY92qkMkA==
Date: Mon, 21 Jul 2025 19:41:24 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
Message-ID: <7t5qpdpc7cvkyvgj7i2fes56pvpfvrqcpbbdqqrhu3vgqgtjw2@6mpuc4ljmiey>
References: <cover.1740036492.git.naveen@kernel.org>
 <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
 <aFngeQ5x6QiP7SsK@google.com>
 <6dl4vsf3k7qhx2aunc5vdhvtxpnwqp45lilpdsp4jksxtgdu6t@kubfenz4bdey>
 <aHpZD6sKamnPv9BG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHpZD6sKamnPv9BG@google.com>

On Fri, Jul 18, 2025 at 07:24:15AM -0700, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Naveen N Rao wrote:
> > On Mon, Jun 23, 2025 at 04:17:13PM -0700, Sean Christopherson wrote:
> > > On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> > > > +		if (x2avic_4k_vcpu_supported) {
> > > > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
> > > > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
> > > > +		} else {
> > > > +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
> > > > +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
> > > > +		}
> > > > +
> > > > +		pr_info("x2AVIC enabled%s\n",
> > > > +			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
> > > 
> > > Maybe print the max number of vCPUs that are supported?  That way there is clear
> > > signal when 4k *isn't* supported (and communicating the max number of vCPUs in
> > > the !4k case would be helpful too).
> > 
> > I'm tempted to go the opposite way and not print that 4k vCPUs are 
> > supported by x2AVIC. As it is, there are many reasons AVIC may be 
> > inhibited and lack of 4k vCPU support is just one other reason, but only
> > for large VMs.
> 
> This isn't just about AVIC being inhibited though, it's about communicating
> hardware support to the admin/user.  While I usually advocate *against* using
> printk to log information, I find SVM's pr_info()s about what is/isn't enabled
> during module load to be extremely useful, e.g. as sanity checks.  I (re)load
> kvm-amd.ko on various hardware configurations on a regular basis, and more than
> once the prints have helped me "remember" which platforms do/don't have SEV-ES,
> AVIC, etc, and/or detect that I loaded kvm-amd.ko with the wrong overrides.

Sure, if you are finding it helpful, that's fine.

> 
> > Most users shouldn't have to care: where possible, AVIC will be enabled 
> > by default (once that patch series lands). Users who truly care about 
> > AVIC will anyway need to confirm AVIC isn't inhibited since looking at 
> > the kernel log won't be sufficient. Those users can very well use cpuid 
> > to figure out if 4k vCPU support is present.
> 
> If there wasn't already an "x2AVIC enabled" print, I would probably lean toward
> doing nothing.  But since pr_info("x2AVIC enabled\n") already exists, and has
> plently of free space for adding extra information, there's basically zero downside
> to printing out the number of supported CPUs.  And it's not just a binary yes/no,
> e.g. I would wager most people couldn't state the number of vCPUs supported by
> the "old" x2AVIC.

Ok, this is what I have now. Let me know if you prefer different 
wording:

	/* AVIC is a prerequisite for x2AVIC. */
        x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-       if (x2avic_enabled)
-               pr_info("x2AVIC enabled\n");
+       if (x2avic_enabled) {
+               if (cpu_feature_enabled(X86_FEATURE_X2AVIC_EXT))
+                       x2avic_max_physical_id = X2AVIC_4K_MAX_PHYSICAL_ID;
+               pr_info("x2AVIC enabled (upto %lld vCPUs)\n", x2avic_max_physical_id + 1);
+       }


- Naveen


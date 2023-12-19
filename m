Return-Path: <kvm+bounces-4756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 227B6817F58
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 02:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 488C91C2301B
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 01:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E091872;
	Tue, 19 Dec 2023 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nG4BN8I7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432645253;
	Tue, 19 Dec 2023 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702950047; x=1734486047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j9LmI93wLucAqn3ykIcZ4njCWMyiil+5OfByZZ4Dj/Y=;
  b=nG4BN8I70NMVZ/QUSCBDeKkgdS+Au29Qp4XkYwg3h16dTG7hq9KKg4cd
   o/YKieMJVliOkxSeVJJX6nuZncu9r+RI9bV9iS/scNlbdTpn7WPhBwe2N
   4JebH3XHZ9ETBxsCYsWM+V68s/9tpw700KZJ/3qSxQkBNCFRBQWpB0cGx
   hcmCgvfJqwaONHtWQCKPTlvdOQwynyLWZi7gdbVAmyzUeVelD/do4blKl
   n0yBm3Nu//DARKg1aDdob6LKmu3r4CoJ+y0qjnHDRS5mn3rKNR6moHExx
   bmbeOPSp2t++dXuc1f7ffoZT6o8rf2v7knnBn8qJ8OlFx3sGGMqkNRMEb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="399426475"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="399426475"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 17:40:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="919458015"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="919458015"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 17:40:46 -0800
Date: Mon, 18 Dec 2023 17:40:45 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency
 vm variable
Message-ID: <20231219014045.GA2639779@ls.amr.corp.intel.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com>
 <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
 <ZXswR04H9Tl7xlyj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZXswR04H9Tl7xlyj@google.com>

On Thu, Dec 14, 2023 at 08:41:43AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> > On Wed, 2023-12-13 at 15:10 -0800, Sean Christopherson wrote:
> > > Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
> > > for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
> > > CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
> > > needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
> > > the TDX guest core crystal frequency of 25Mhz.
> > 
> > I assume that TDX doesn't allow to change the CPUID 0x15 leaf.
> 
> Correct.  I meant to call that out below, but left my sentence half-finished.  It
> was supposed to say:
> 
>   I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
>   use 1Ghz as the base frequency or to allow configuring the base frequency
>   advertised to the guest.
> 
> > > I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
> > > use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
> > > dying on since the KVM changes are relatively simple.
> > > 
> > > https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com
> > > 
> > 
> > Best regards,
> > 	Maxim Levitsky

The followings are the updated version of the commit message.


KVM: x86: Make the hardcoded APIC bus frequency VM variable

The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
CPUID leaf 0x15.  The
TDX mandates it to be exposed and doesn't allow the VMM to override
its value.  The KVM APIC timer emulation hard-codes the frequency to
1GHz.  It doesn't unconditionally enumerate it to the guest unless the
user space VMM sets the CPUID leaf 0x15 by KVM_SET_CPUID.

If the CPUID leaf 0x15 is enumerated, the guest kernel uses it as the
APIC bus frequency.  If not, the guest kernel measures the frequency
based on other known timers like the ACPI timer or the legacy PIT.
The TDX guest kernel gets timer interrupt more times by 1GHz / 25MHz.

To ensure that the guest doesn't have a conflicting view of the APIC
bus frequency, allow the userspace to tell KVM to use the same
frequency that TDX mandates instead of the default 1Ghz.

There are several options to address this.
1. Make the KVM able to configure APIC bus frequency (This patch).
   Pros: It resembles the existing hardware.  The recent Intel CPUs
   adapts 25MHz.
   Cons: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID 0x15 to configurable
   frequency or not enumerate it.
   Pros: Any APIC bus frequency is allowed.
   Cons: Deviation from the real hardware.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Cons: The kernel ignores CPUID leaf 0x15.


-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>


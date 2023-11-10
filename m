Return-Path: <kvm+bounces-1400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DAB37E75F0
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 434251C20D74
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F80D643;
	Fri, 10 Nov 2023 00:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cDjwMwSq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11F366
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:29:55 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0A2D7C;
	Thu,  9 Nov 2023 16:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699576194; x=1731112194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RXQEk8DTnU62l10vBMRLP0Yzm/Zzrw5CoP6dtFdQlqY=;
  b=cDjwMwSq0bd4++enIL+e4q1XVoVh3humWpsqE73mR0JqcfCbGX25DwQS
   ak8Rf7k0yz//07jWtpXsGwn9D1g+2XgOFlE/TKqcmqmBnToIr2B2jLmK6
   Vs/vhh0TGHI9hamtE0YAbm/1aMmaoc7KJ14tLaLEKbwEADEMW1P0S4HYW
   3FCCw8+zF5Srg601I7zqX50OhtRWJCoCyQ6UUjVm3YoT65iejrBeXJdxc
   FuC22ase8Wh8wlrKVbTD51AmH1QL6fUXg9W1+103HOwhnMUclFjCOtaoy
   MpMwHpvYjgIphGHNgJfJaJjorv3IwQINxgY26w4ghGMVFrvl64ggiuqIt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="369437727"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="369437727"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 16:29:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="792716398"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="792716398"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 16:29:54 -0800
Date: Thu, 9 Nov 2023 16:29:53 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Jim Mattson <jmattson@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Vishal Annapurve <vannapurve@google.com>
Subject: Re: KVM: X86: Make bus clock frequency for vapic timer (bus lock ->
 bus clock) (was Re: [PATCH 0/2] KVM: X86: Make bus lock frequency for vapic
 timer) configurable
Message-ID: <20231110002953.GB1102144@ls.amr.corp.intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
 <20231107192933.GA1102144@ls.amr.corp.intel.com>
 <CALMp9eR8Jnn0g0XBpTKTfKKOtRmFwAWuLAKcozuOs6KAGZ6MQQ@mail.gmail.com>
 <20231108235456.GB1132821@ls.amr.corp.intel.com>
 <ZU0BASXWcck85r90@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZU0BASXWcck85r90@google.com>

On Thu, Nov 09, 2023 at 07:55:45AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Nov 08, 2023, Isaku Yamahata wrote:
> > On Tue, Nov 07, 2023 at 12:03:35PM -0800, Jim Mattson <jmattson@google.com> wrote:
> > > I think I know the answer, but do you have any tests for this new feature?
> > 
> > If you mean kvm kselftest, no.
> > I have
> > - TDX patched qemu
> > - kvm-unit-tests: test_apic_timer_one_shot() @ kvm-unit-tests/x86/apic.c
> >   TDX version is found at https://github.com/intel/kvm-unit-tests-tdx
> >   We're planning to upstream the changes for TDX
> > 
> > How far do we want to go?
> > - Run kvm-unit-tests with TDX. What I have right now.
> > - kvm-unit-tests: extend qemu for default VM case and update
> >   test_apic_timer_one_host()
> 
> Hrm, I'm not sure that we can do a whole lot for test_apic_timer_one_shot().  Or
> rather, I'm not sure it's worth the effort to try and add coverage beyond what's
> already there.
> 
> As for TDX, *if* we extend KUT, please don't make it depend on TDX.  Very few people
> have access to TDX platforms and anything CoCo is pretty much guaranteed to be harder
> to debug.

It made the test cases work with TDX + UEFI bios by adjusting command line to
invoke qemu.  And skip unsuitable tests.
Maybe we can generalize the way to twist qemu command line.


> > - kselftest
> >   Right now kvm kselftest doesn't have test cases even for in-kernel IRQCHIP
> >   creation.
> 
> Selftests always create an in-kernel APIC.  And I think selftests are perfectly
> suited to complement the coverage provided by KUT.  Specifically, the failure
> scenario for this is that KVM emulates at 1Ghz whereas TDX advertises 25Mhz, i.e.
> the test case we want is to verify that the APIC timer doesn't expire early.
> 
> There's no need for any APIC infrastructure, e.g. a selftest doesn't even need to
> handle an interrupt.  Get the TSC frequency from KVM, program up an arbitrary APIC
> bus clock frequency, set TMICT such that it expires waaaay in the future, and then
> verify that the APIC timer counts reasonably close to the programmed frequency.
> E.g. if the test sets the bus clock to 25Mhz, the "drift" due to KVM counting at
> 1Ghz should be super obvious.

Oh, only check the register value without interrupt. Good idea.  Let me give it
a try.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>


Return-Path: <kvm+bounces-1288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FD37E6139
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 00:55:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F3A2812E4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 23:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CA238DE8;
	Wed,  8 Nov 2023 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AHsiVOFQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80726374E7
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:54:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058A225BC;
	Wed,  8 Nov 2023 15:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699487697; x=1731023697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=RlYUE+lkNESY4winlQ/vFKHJhVPBJgGJcSYFyVCXbTY=;
  b=AHsiVOFQC0PdptDClECaiqvLKQp7KXbAQZJDp6pAP2yz3rkiLGBOwgi1
   ZPgke1Zeqc7Yr26n1D46YA6Q0w1oY/SLjSx2uklDadRf3Fl+h4fgbxyFo
   fAqMJ0Y1qF5jM7DK9N/Qn/k9Yvy8Kwm1AUvSO3GS6/yVeU+G0W8IceAwe
   IY7eu/iRyDEcoyZPmhrGb8V1O7171+uPT6WlroYMfzJf0Ygkz11/xtIkG
   nQgGj9BJt7ZoSxkbLXcuW3dgJWIaISCIg/cIEW+K95a1iiC3p8tQD2Eby
   mnZJC+DtAbyAayb/9J9b3JXx5tBN6crP99esKAhmi8CO2FwZxTUOmP8FA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="370086260"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="370086260"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 15:54:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="906948872"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="906948872"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 15:54:56 -0800
Date: Wed, 8 Nov 2023 15:54:56 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: KVM: X86: Make bus clock frequency for vapic timer (bus lock ->
 bus clock) (was Re: [PATCH 0/2] KVM: X86: Make bus lock frequency for vapic
 timer) configurable
Message-ID: <20231108235456.GB1132821@ls.amr.corp.intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
 <20231107192933.GA1102144@ls.amr.corp.intel.com>
 <CALMp9eR8Jnn0g0XBpTKTfKKOtRmFwAWuLAKcozuOs6KAGZ6MQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eR8Jnn0g0XBpTKTfKKOtRmFwAWuLAKcozuOs6KAGZ6MQQ@mail.gmail.com>

On Tue, Nov 07, 2023 at 12:03:35PM -0800,
Jim Mattson <jmattson@google.com> wrote:

> On Tue, Nov 7, 2023 at 11:29 AM Isaku Yamahata
> <isaku.yamahata@linux.intel.com> wrote:
> >
> > I meant bus clock frequency, not bus lock. Sorry for typo.
> >
> > On Tue, Nov 07, 2023 at 11:22:32AM -0800,
> > isaku.yamahata@intel.com wrote:
> >
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> > > crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
> > > KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
> > > frequency.  When using this capability, the user space VMM should configure
> > > CPUID[0x15] to advertise the frequency.
> > >
> > > TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
> > > x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
> > > causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
> > > APIC timer emulation uses hrtimer, whose unit is nanosecond.
> > >
> > > There are options to reconcile the mismatch.  1) Make apic bus clock frequency
> > > configurable (this patch).  2) TDX KVM code adjusts TMICT value.  This is hacky
> > > and it results in losing MSB bits from 32 bit width to 30 bit width.  3). Make
> > > the guest kernel use tsc deadline timer instead of acpi oneshot/periodic timer.
> > > This is guest kernel choice.  It's out of control of VMM.
> > >
> > > [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> > >
> > > Isaku Yamahata (2):
> > >   KVM: x86: Make the hardcoded APIC bus frequency vm variable
> > >   KVM: X86: Add a capability to configure bus frequency for APIC timer
> 
> I think I know the answer, but do you have any tests for this new feature?

If you mean kvm kselftest, no.
I have
- TDX patched qemu
- kvm-unit-tests: test_apic_timer_one_shot() @ kvm-unit-tests/x86/apic.c
  TDX version is found at https://github.com/intel/kvm-unit-tests-tdx
  We're planning to upstream the changes for TDX

How far do we want to go?
- Run kvm-unit-tests with TDX. What I have right now.
- kvm-unit-tests: extend qemu for default VM case and update
  test_apic_timer_one_host()
- kselftest
  Right now kvm kselftest doesn't have test cases even for in-kernel IRQCHIP
  creation.
  - Add test cases to create/destory in-kernel IRQCHIP
  - Add KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREQUENCY_CONTROL) test cases
  - Test if apic timer frequency is as spcified.

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>


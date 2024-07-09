Return-Path: <kvm+bounces-21208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF0492BDCA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 17:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EC371C21BF0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0D719D8B7;
	Tue,  9 Jul 2024 15:05:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04C519D892
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537542; cv=none; b=tA7AdnKBN6yVLVbCthPKOaGtsjCbWSQk8d3obIwHApbyonc67hOot0oA5wgcUz2E3od7JvfzBP8uG50uYXE/EREazzcbxw/uJ9kdL9vGh4M/sTdEuHyI+Q/qofnbf2VcWPsYjddlPIJJRQfNHUrK2T8765cQDH+UpoWdWAdDX6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537542; c=relaxed/simple;
	bh=Tl5boR0zVv0zxFqG5qiovPt7OTv/ylzAIQXvmUT+8wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrSqK5sI31qX0yuqpwwsU+5rQeCk66cLY4Ke7BziE02jNAkIClDclJOo+zkGVwzKzvw+hmzRExijCdiR/bUQoAmSfufxjxnkvpuRgCGwU4Wxc6CDdRnjNNFZ1OHYDs9zvAaT3Kdm36XqRK/WQJBmDjOzabuoMk7PuFn+6MiV5/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B02312FC;
	Tue,  9 Jul 2024 08:06:03 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77DF53F766;
	Tue,  9 Jul 2024 08:05:35 -0700 (PDT)
Date: Tue, 9 Jul 2024 16:05:32 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, pbonzini@redhat.com,
	drjones@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
	qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
	maz@kernel.org, Anders Roxell <anders.roxell@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU
 introspection test if missing
Message-ID: <Zo1RvCdNDhaZHKMb@arm.com>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org>
 <Zoz7sQNoC9ePXH7w@arm.com>
 <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
 <87ed82slt8.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ed82slt8.fsf@draig.linaro.org>

Hi,

On Tue, Jul 09, 2024 at 03:05:07PM +0100, Alex Bennée wrote:
> Peter Maydell <peter.maydell@linaro.org> writes:
> 
> > On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>
> >> Hi,
> >>
> >> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Bennée wrote:
> >> > The test for number of events is not a substitute for properly
> >> > checking the feature register. Fix the define and skip if PMUv3 is not
> >> > available on the system. This includes emulator such as QEMU which
> >> > don't implement PMU counters as a matter of policy.
> >> >
> >> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> > Cc: Anders Roxell <anders.roxell@linaro.org>
> >> > ---
> >> >  arm/pmu.c | 7 ++++++-
> >> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/arm/pmu.c b/arm/pmu.c
> >> > index 9ff7a301..66163a40 100644
> >> > --- a/arm/pmu.c
> >> > +++ b/arm/pmu.c
> >> > @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
> >> >  #define ID_AA64DFR0_PERFMON_MASK  0xf
> >> >
> >> >  #define ID_DFR0_PMU_NOTIMPL  0b0000
> >> > -#define ID_DFR0_PMU_V3               0b0001
> >> > +#define ID_DFR0_PMU_V3               0b0011
> >> >  #define ID_DFR0_PMU_V3_8_1   0b0100
> >> >  #define ID_DFR0_PMU_V3_8_4   0b0101
> >> >  #define ID_DFR0_PMU_V3_8_5   0b0110
> >> > @@ -286,6 +286,11 @@ static void test_event_introspection(void)
> >> >               return;
> >> >       }
> >> >
> >> > +     if (pmu.version < ID_DFR0_PMU_V3) {
> >> > +             report_skip("PMUv3 extensions not supported, skip ...");
> >> > +             return;
> >> > +     }
> >> > +
> >>
> >> I don't get this patch - test_event_introspection() is only run on 64bit. On
> >> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
> >> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fails if
> >> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result, if
> >> test_event_introspection() is executed, then a PMUv3 is present.
> >>
> >> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than the cycle
> >> counter)?
> 
> The other option I have is this:
> 
> --8<---------------cut here---------------start------------->8---
> arm/pmu: event-introspection needs icount for TCG
> 
> The TCG accelerator will report a PMU (unless explicitly disabled with
> -cpu foo,pmu=off) however not all events are available unless you run
> under icount. Fix this by splitting the test into a kvm and tcg
> version.

As far as I can tell, if test_event_introspection() fails under TCG without
icount then there are two possible explanations for that:

1. Not all the events whose presence is checked by test_event_introspection()
are actually required by the architecture.

2. TCG without icount is not implementing all the events required by the
architecture.

If 1, then test_event_introspection() should be fixed. I had a look and the
function looked correct to me (except that the event name is not INST_PREC,
it's INST_SPEC in the Arm DDI0487J.A and K.a, but that's not relevant for
correctness).

From what I can tell from what Peter and you have said, explanation 2 is the
correct one, because TCG cannot implement all the required events when icount is
not specified. As far as test_event_introspection() is concerned, I consider
this to be the expected behaviour: it fails because the required events are not
implemented. I don't think the function should be changed to work around how
QEMU was invoked. Do you agree?

If you know that the test will fail without special command line parameters when
accel is TCG, then I think what you are suggesting looks correct to me: the
original test is skipped if KVM is not present, and when run under TCG, the
correct parameters are passed to QEMU.

Thanks,
Alex

> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> 1 file changed, 8 insertions(+)
> arm/unittests.cfg | 8 ++++++++
> 
> modified   arm/unittests.cfg
> @@ -52,8 +52,16 @@ extra_params = -append 'cycle-counter 0'
>  file = pmu.flat
>  groups = pmu
>  arch = arm64
> +accel = kvm
>  extra_params = -append 'pmu-event-introspection'
>  
> +[pmu-event-introspection-icount]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +accel = tcg
> +extra_params = -icount shift=1 -append 'pmu-event-introspection'
> +
>  [pmu-event-counter-config]
>  file = pmu.flat
>  groups = pmu
> --8<---------------cut here---------------end--------------->8---
> 
> which just punts icount on TCG to its own test (note there are commented
> out versions further down the unitests.cfg file)
> 
> -- 
> Alex Bennée
> Virtualisation Tech Lead @ Linaro


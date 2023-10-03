Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A37B5E61
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 02:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbjJCAxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJCAxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 20:53:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47040B4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 17:53:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c5b80fe118so3556085ad.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696294393; x=1696899193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fGxNGV3zFHEKCKCtbi91VI3bPEN8a8y7A2TBvxaAZLw=;
        b=jXIYlTaOmP4EbhxNElv0dYQ2M6GMZliMY9zzRg4iJ19/NUYXl5fGPNLG0Fo0NTy4Z/
         e0p1yDymDQ7Ra7izw8/o+qUX4f0ej/Y7WV0zuqqpl9V8EQzwCEOC18Oh5QmremRQu8Uw
         ejOBaSvnjH3T9UWtrvrI8mvqnbTEZ7cKlGLaFXLk2F32pgst7NT8bwYDf6Yq0ZxyYYDW
         L22hIN+fyFPzKk1MxJ7PgwOcbVOk42fBgx+YtNHfSeHmMT2IBffG9Y2tNkxuk9qXfN3c
         F6FcKcU5HIojAlG+SjLapmqms3YE5+NojJ8VDTQEp/nScufcm75+AGnzBTYMcDwKR66P
         otYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696294393; x=1696899193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fGxNGV3zFHEKCKCtbi91VI3bPEN8a8y7A2TBvxaAZLw=;
        b=NNCu+Mij7J4Gak9vGOmtBEPaUR+oro+H5yxmdYYhOgxSX/2tQBU0mp25yzMG0DCkRu
         txRWufHh1bffN0RnZL2jDjUD2eiyLbiAtZ6gVh9OxVzywirM7B/4bxBBo1JUwcYe8BWw
         BfJ/YWWboIltzJKdx1DB7So1NRxfUjvCAtwfv8wzubDyW85Kx0f3Zz+xt60EdCVjuGhq
         FjH+fBNa1L/RhM0rciTIIgbVs5u2lQZHbVXhqpdNGWYFXjX9kHtedAyuh0NJUt+PIqo8
         SbaNmtP3s43cO0BTJYjJPkXm6gnrgLiw4NeeTLnLF59U1Bwex2c1nXfkfr/PLTVROerQ
         q15g==
X-Gm-Message-State: AOJu0Yz+VMjqym5ZaZDnzvP7CV94Jr8mRpeQuhW6YSbNLqZj7glmidND
        ItBF/b6nFmizx4SB8Gm6JDN/ZuJ5L/s=
X-Google-Smtp-Source: AGHT+IHLZ8a/M8CjatROO80yPekYyYwfVMsuGz2ZCKlbQoHa+u2C3FcsRTjT+/u//wte3ntKIuN1sOkULBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d2:b0:1bc:2547:b17c with SMTP id
 o18-20020a170902d4d200b001bc2547b17cmr204487plg.1.1696294392673; Mon, 02 Oct
 2023 17:53:12 -0700 (PDT)
Date:   Mon, 2 Oct 2023 17:53:11 -0700
In-Reply-To: <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
Message-ID: <ZRtl94_rIif3GRpu@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, David Woodhouse wrote:
> On Mon, 2023-10-02 at 09:37 -0700, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, David Woodhouse wrote:
> > > On Fri, 2023-09-29 at 13:15 -0700, Dongli Zhang wrote:
> > > > 
> > > > 1. The vcpu->hv_clock (kvmclock) is based on its own mult/shift/equation.
> > > > 
> > > > 2. The raw monotonic (tsc_clocksource) uses different mult/shift/equation.
> > > > 
> > > 
> > > That just seems wrong. I don't mean that you're incorrect; it seems
> > > *morally* wrong.
> > > 
> > > In a system with X86_FEATURE_CONSTANT_TSC, why would KVM choose to use
> > > a *different* mult/shift/equation (your #1) to convert TSC ticks to
> > > nanoseconds than the host CLOCK_MONOTONIC_RAW does (your #2).
> > > 
> > > I understand that KVM can't track the host's CLOCK_MONOTONIC, as it's
> > > adjusted by NTP. But CLOCK_MONOTONIC_RAW is supposed to be consistent.
> > > 
> > > Fix that, and the whole problem goes away, doesn't it?
> > > 
> > > What am I missing here, that means we can't do that?
> > 
> > I believe the answer is that "struct pvclock_vcpu_time_info" and its math are
> > ABI between KVM and KVM guests.
> > 
> > Like many of the older bits of KVM, my guess is that KVM's behavior is the product
> > of making things kinda sorta work with old hardware, i.e. was probably the least
> > awful solution in the days before constant TSCs, but is completely nonsensical on
> > modern hardware.
> 
> I still don't understand. The ABI and its math are fine. The ABI is just
>  "at time X the TSC was Y, and the TSC frequency is Z"
> 
> I understand why on older hardware, those values needed to *change*
> occasionally when TSC stupidity happened. 
> 
> But on newer hardware, surely we can set them precisely *once* when the
> VM starts, and never ever have to change them again? Theoretically not
> even when we pause the VM, kexec into a new kernel, and resume the VM!
> 
> But we *are* having to change it, because apparently
> CLOCK_MONOTONIC_RAW is doing something *other* than incrementing at
> precisely the frequency of the known and constant TSC.
>
> But *why* is CLOCK_MONOTONIC_RAW doing that? I thought that the whole
> point of CLOCK_MONOTONIC_RAW was to be consistent and not adjusted by
> NTP etc.? Shouldn't it run at precisely the same rate as the kvmclock,
> with no skew at all?

IIUC, the issue is that the paravirt clock ends up mixing time domains, i.e. is
a weird bastardization of the host's monotonic raw clock and the paravirt clock.

Despite a name that suggests otherwise (to me at least), __pvclock_read_cycles()
counts "cycles" in nanoseconds, not TSC ticks.
 
  u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
  {
	u64 delta = tsc - src->tsc_timestamp;
	u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
					     src->tsc_shift);
	return src->system_time + offset;
  }

In the above, "offset" is computed in the kvmclock domain, whereas system_time
comes from the host's CLOCK_MONOTONIC_RAW domain by way of master_kernel_ns.
The goofy math is much more obvious in __get_kvmclock(), i.e. KVM's host-side
retrieval of the guest's view of kvmclock:

  hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;

The two domains use the same "clock" (constant TSC), but different math to compute
nanoseconds from a given TSC value.  For decently large TSC values, this results
in CLOCK_MONOTONIC_RAW and kvmclock computing two different times in nanoseconds.

When KVM decides to refresh the masterclock, e.g. vCPU hotplug in Dongli's case,
it resets the base time, a.k.a. system_time.  I.e. KVM takes all of the time that
was accumulated in the kvmclock domain and recomputes it in the CLOCK_MONOTONIC_RAW
domain.  The more time that passes between refreshes, the bigger the time jump
from the guest's perspective.

E.g. IIUC, your proposed patch to use a single RDTSC[*] eliminates the drift by
undoing the CLOCK_MONOTONIC_RAW crap using the same TSC value on both the "add"
and the "subtract", but the underlying train wreck of mixing time domains is
still there.

Without a constant TSC, deferring the reference time to the host's computation
makes sense (or at least, is less silly), because the effective TSC would be per
physical CPU, whereas the reference time is per VM.

[*] https://lore.kernel.org/all/ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org

> And if CLOCK_MONOTONIC_RAW is not what I thought it was... do we really
> have to keep resetting the kvmclock to it at all? On modern hardware
> can't the kvmclock be defined by the TSC alone?

I think there is still use for synchronizing with the host's view of time, e.g.
to deal with lost time across host suspend+resume.

So I don't think we can completely sever KVM's paravirt clocks from host time,
at least not without harming use cases that rely on the host's view to keep
accurate time.  And honestly at that point, the right answer would be to stop
advertising paravirt clocks entirely.

But I do think we can address the issues that Dongli and David are obversing
where guest time drifts even though the host kernel's base time hasn't changed.
If I've pieced everything together correctly, the drift can be eliminated simply
by using the paravirt clock algorithm when converting the delta from the raw TSC
to nanoseconds.

This is *very* lightly tested, as in it compiles and doesn't explode, but that's
about all I've tested.

---
 arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6573c89c35a9..3ba7edfca47c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2417,6 +2417,9 @@ static void kvm_get_time_scale(uint64_t scaled_hz, uint64_t base_hz,
 static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
 #endif
 
+static u32 host_tsc_to_system_mul;
+static s8 host_tsc_shift;
+
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 static unsigned long max_tsc_khz;
 
@@ -2812,27 +2815,18 @@ static u64 read_tsc(void)
 static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
 			  int *mode)
 {
-	u64 tsc_pg_val;
-	long v;
+	u64 ns, v;
 
 	switch (clock->vclock_mode) {
 	case VDSO_CLOCKMODE_HVCLOCK:
-		if (hv_read_tsc_page_tsc(hv_get_tsc_page(),
-					 tsc_timestamp, &tsc_pg_val)) {
-			/* TSC page valid */
+		if (hv_read_tsc_page_tsc(hv_get_tsc_page(), tsc_timestamp, &v))
 			*mode = VDSO_CLOCKMODE_HVCLOCK;
-			v = (tsc_pg_val - clock->cycle_last) &
-				clock->mask;
-		} else {
-			/* TSC page invalid */
+		else
 			*mode = VDSO_CLOCKMODE_NONE;
-		}
 		break;
 	case VDSO_CLOCKMODE_TSC:
 		*mode = VDSO_CLOCKMODE_TSC;
-		*tsc_timestamp = read_tsc();
-		v = (*tsc_timestamp - clock->cycle_last) &
-			clock->mask;
+		v = *tsc_timestamp = read_tsc();
 		break;
 	default:
 		*mode = VDSO_CLOCKMODE_NONE;
@@ -2840,8 +2834,36 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
 
 	if (*mode == VDSO_CLOCKMODE_NONE)
 		*tsc_timestamp = v = 0;
+	else
+		v = (v - clock->cycle_last) & clock->mask;
 
-	return v * clock->mult;
+	ns = clock->base_cycles;
+
+	/*
+	 * When the clock source is a raw, constant TSC, do the conversion to
+	 * nanoseconds using the paravirt clock math so that the delta in ns is
+	 * consistent regardless of whether the delta is converted in the host
+	 * or the guest.
+	 *
+	 * The base for paravirt clocks is the kernel's base time in ns, plus
+	 * the delta since the last sync.   E.g. if a masterclock update occurs,
+	 * KVM will shift some amount of delta from the guest to the host.
+	 * Conversions from TSC to ns for the hosts's CLOCK_MONOTONIC_RAW and
+	 * paravirt clocks aren't equivalent, and so shifting the delta can
+	 * cause time to jump from the guest's view of the paravirt clock.
+	 * This only works for a constant TSC, otherwise the calculation would
+	 * only be valid for the current physical CPU, whereas the base of the
+	 * clock must be valid for all vCPUs in the VM.
+	 */
+	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    *mode == VDSO_CLOCKMODE_TSC && clock == &pvclock_gtod_data.raw_clock) {
+		ns >>= clock->shift;
+		ns += pvclock_scale_delta(v, host_tsc_to_system_mul, host_tsc_shift);
+	} else {
+		ns += v * clock->mult;
+		ns >>= clock->shift;
+	}
+	return ns;
 }
 
 static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
@@ -2853,9 +2875,7 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
 
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
-		ns = gtod->raw_clock.base_cycles;
-		ns += vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
-		ns >>= gtod->raw_clock.shift;
+		ns = vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
 		ns += ktime_to_ns(ktime_add(gtod->raw_clock.offset, gtod->offs_boot));
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	*t = ns;
@@ -2873,9 +2893,7 @@ static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_sec;
-		ns = gtod->clock.base_cycles;
-		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
-		ns >>= gtod->clock.shift;
+		ns = vgettsc(&gtod->clock, tsc_timestamp, &mode);
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
@@ -12185,6 +12203,10 @@ int kvm_arch_hardware_enable(void)
 	if (ret != 0)
 		return ret;
 
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		kvm_get_time_scale(NSEC_PER_SEC, tsc_khz * 1000LL,
+				   &host_tsc_shift, &host_tsc_to_system_mul);
+
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
 	list_for_each_entry(kvm, &vm_list, vm_list) {

base-commit: e2c8c2928d93f64b976b9242ddb08684b8cdea8d
-- 


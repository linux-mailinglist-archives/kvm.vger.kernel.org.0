Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6107CB2F5
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbjJPStX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjJPStV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:49:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BBDAB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:49:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b9e83b70so36150687b3.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697482157; x=1698086957; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OAcCmmrGQB8I/RvBQ4RW2J7O69twzM6FPTQwq9j0qgo=;
        b=sQUXwWJB4uLiO8XNHOFB1l5FoizPEo+PZbBKASXQ6PvNmJgNQRz43U4wwj7Svj/WSO
         jzSuKhlJhzRgk3AIDZGD9KaSNM/ow5w8TLMXkKrHbmveoKmm8ek8FupGZ56qG1bLx36s
         Sn1oKWb0WDx/QYEGs+aEsAR3J0n9wf29zLsRM3YaKrnsbcyXMpZMFIVxk0USrJ6Ua3nR
         y1H53b0VTdZbor9LVRCitechTNkhf3NSCWtw/Uxm0Di4AWfe6VKXJJ8o3Ow/QywmTX4s
         xcr956MmQSPvfFTdXeD5NIXek4APw04zWSlLh0gVBRkdYn1tbhjHJLYPmRehOMWux/bh
         PXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697482157; x=1698086957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAcCmmrGQB8I/RvBQ4RW2J7O69twzM6FPTQwq9j0qgo=;
        b=PH0gAAYG3FhQbyrjCZyWcLnp/747+6R3Y9/+6wXiBGdprUnLq/tHvS9R8/rzP+OmKz
         sTbS4JBL1kpdso6Y3ik+LIrTT45e8PvCA+vTCk4tSnvSNoz4llzmy+Kpl21hr/5Ws8Ui
         RuR8fmPHl58vn8tiGUc62R4jIhqN2jVIiKTEsoGM4OUZHVjJwIdTLmlOiXTWBtiJr1nB
         W+dCKLlX170AqXfTOL2nXjqJYB9YPvUTSzC9s99UZtpiKZa8IFDc52ccKOceDgAyuGC/
         bZQ8MlWsgA7beMAHMTtgizjgpFCHloFYgssSnQwoOQv95bq/6RnQ2UQ6AZXcDTZ8df84
         OxNw==
X-Gm-Message-State: AOJu0YyGcq/qhnpX93zay0+kKZzTZWfRlWqCVL8j6aGMeGRX6meCQ0ku
        I3B56OGd8pC0rgCjKmd7FXb7UpT182k=
X-Google-Smtp-Source: AGHT+IG9+k+RbsCROZVMJf5NZBS/xEIj+i8wumNbqzyCoFYfIMSmQua6kuhoqp8NAL+vNDBuwq8EBWv8n0s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c20e:0:b0:595:8166:7be with SMTP id
 z14-20020a81c20e000000b00595816607bemr12527ywc.0.1697482157142; Mon, 16 Oct
 2023 11:49:17 -0700 (PDT)
Date:   Mon, 16 Oct 2023 11:49:15 -0700
In-Reply-To: <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
Mime-Version: 1.0
References: <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com> <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com> <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
 <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com> <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
Message-ID: <ZS2Fq5dr2CeZaBok@google.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, David Woodhouse wrote:
> On Mon, 2023-10-16 at 08:47 -0700, Dongli Zhang wrote:
> > Suppose we are discussing a non-permanenet solution, I would suggest:
> > 
> > 1. Document something to accept that kvm-clock (or pvclock on KVM, including Xen
> > on KVM) is not good enough in some cases, e.g., vCPU hotplug.
> 
> I still don't understand the vCPU hotplug case.
> 
> In the case where the TSC is actually sane, why would we need to reset
> the masterclock on vCPU hotplug? 
> 
> The new vCPU gets its TSC synchronised to the others, and its kvmclock
> parameters (mul/shift/offset based on the guest TSC) can be *precisely*
> the same as the other vCPUs too, can't they? Why reset anything?

Aha!  I think I finally figured out why KVM behaves the way it does.

The unnecessary masterclock updates effectively came from:

  commit 7f187922ddf6b67f2999a76dcb71663097b75497
  Author: Marcelo Tosatti <mtosatti@redhat.com>
  Date:   Tue Nov 4 21:30:44 2014 -0200

    KVM: x86: update masterclock values on TSC writes
    
    When the guest writes to the TSC, the masterclock TSC copy must be
    updated as well along with the TSC_OFFSET update, otherwise a negative
    tsc_timestamp is calculated at kvm_guest_time_update.
    
    Once "if (!vcpus_matched && ka->use_master_clock)" is simplified to
    "if (ka->use_master_clock)", the corresponding "if (!ka->use_master_clock)"
    becomes redundant, so remove the do_request boolean and collapse
    everything into a single condition.

Before that, KVM only re-synced the masterclock if it was enabled or disabled,
i.e. KVM behaved as we want it to behave.  Note, at the time of the above commit,
VMX synchronized TSC on *guest* writes to MSR_IA32_TSC:

	case MSR_IA32_TSC:
        	kvm_write_tsc(vcpu, msr_info);
	        break;

That got changed by commit 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization
on guest writes"), but I don't think the guest angle is actually relevant to the
fix.  AFAICT, a write from the host would suffer the same problem.  But knowing
that KVM synced on guest writes is crucial to understanding the changelog.

In kvm_write_tsc(), except for KVM's wonderful "less than 1 second" hack, KVM
snapshotted the vCPU's current TSC *and* the current time in nanoseconds, where
kvm->arch.cur_tsc_nsec is the current host kernel time in nanoseconds.

	ns = get_kernel_ns();

	...

        if (usdiff < USEC_PER_SEC &&
            vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
		...
        } else {
                /*
                 * We split periods of matched TSC writes into generations.
                 * For each generation, we track the original measured
                 * nanosecond time, offset, and write, so if TSCs are in
                 * sync, we can match exact offset, and if not, we can match
                 * exact software computation in compute_guest_tsc()
                 *
                 * These values are tracked in kvm->arch.cur_xxx variables.
                 */
                kvm->arch.cur_tsc_generation++;
                kvm->arch.cur_tsc_nsec = ns;
                kvm->arch.cur_tsc_write = data;
                kvm->arch.cur_tsc_offset = offset;
                matched = false;
                pr_debug("kvm: new tsc generation %llu, clock %llu\n",
                         kvm->arch.cur_tsc_generation, data);
        }

	...

        /* Keep track of which generation this VCPU has synchronized to */
        vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
        vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
        vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;

Note that the above sets matched to false!  But because kvm_track_tsc_matching()
looks for matched+1, i.e. doesn't require the first vCPU to match itself, KVM
would immediately compute vcpus_matched as true for VMs with a single vCPU.  As
a result, KVM would skip the masterlock update, even though a new TSC generation
was created.

        vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
                         atomic_read(&vcpu->kvm->online_vcpus));

        if (vcpus_matched && gtod->clock.vclock_mode == VCLOCK_TSC)
                if (!ka->use_master_clock)
                        do_request = 1;

        if (!vcpus_matched && ka->use_master_clock)
                        do_request = 1;

        if (do_request)
                kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);

On hardware without TSC scaling support, vcpu->tsc_catchup is set to true if the
guest TSC frequency is faster than the host TSC frequency, even if the TSC is
otherwise stable.  And for that mode, kvm_guest_time_update(), by way of
compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the kernel time at the
last TSC write, to compute the guest TSC relative to kernel time:

  static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
  {
	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
				      vcpu->arch.virtual_tsc_mult,
				      vcpu->arch.virtual_tsc_shift);
	tsc += vcpu->arch.this_tsc_write;
	return tsc;
  }

Except the @kernel_ns passed to compute_guest_tsc() isn't the current kernel time,
it's the masterclock snapshot!

        spin_lock(&ka->pvclock_gtod_sync_lock);
        use_master_clock = ka->use_master_clock;
        if (use_master_clock) {
                host_tsc = ka->master_cycle_now;
                kernel_ns = ka->master_kernel_ns;
        }
        spin_unlock(&ka->pvclock_gtod_sync_lock);

	if (vcpu->tsc_catchup) {
		u64 tsc = compute_guest_tsc(v, kernel_ns);
		if (tsc > tsc_timestamp) {
			adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
			tsc_timestamp = tsc;
		}
	}

And so the "kernel_ns-vcpu->arch.this_tsc_nsec" is *guaranteed* to generate a
negative value, because this_tsc_nsec was captured after ka->master_kernel_ns.

Forcing a masterclock update essentially fudged around that problem, but in a
heavy handed way that introduced undesirable side effects, i.e. unnecessarily
forces a masterclock update when a new vCPU joins the party via hotplug.

Compile tested only, but the below should fix the vCPU hotplug case.  Then
someone (not me) just needs to figure out why kvm_xen_shared_info_init() forces
a masterclock update.

I still think we should clean up the periodic sync code, but I don't think we
need to periodically sync the masterclock.

---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c54e1133e0d3..f0a607b6fc31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
 }
 #endif
 
-static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
+static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
 {
 #ifdef CONFIG_X86_64
-	bool vcpus_matched;
 	struct kvm_arch *ka = &vcpu->kvm->arch;
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
-			 atomic_read(&vcpu->kvm->online_vcpus));
+	/*
+	 * To use the masterclock, the host clocksource must be based on TSC
+	 * and all vCPUs must have matching TSCs.  Note, the count for matching
+	 * vCPUs doesn't include the reference vCPU, hence "+1".
+	 */
+	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
+				 atomic_read(&vcpu->kvm->online_vcpus)) &&
+				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
 
 	/*
-	 * Once the masterclock is enabled, always perform request in
-	 * order to update it.
-	 *
-	 * In order to enable masterclock, the host clocksource must be TSC
-	 * and the vcpus need to have matched TSCs.  When that happens,
-	 * perform request to enable masterclock.
+	 * Request a masterclock update if the masterclock needs to be toggled
+	 * on/off, or when starting a new generation and the masterclock is
+	 * enabled (compute_guest_tsc() requires the masterclock snaphot to be
+	 * taken _after_ the new generation is created).
 	 */
-	if (ka->use_master_clock ||
-	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
+	if ((ka->use_master_clock && new_generation) ||
+	    (ka->use_master_clock != use_master_clock))
 		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 
 	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
@@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
-	kvm_track_tsc_matching(vcpu);
+	kvm_track_tsc_matching(vcpu, !matched);
 }
 
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)

base-commit: dfdc8b7884b50e3bfa635292973b530a97689f12
-- 

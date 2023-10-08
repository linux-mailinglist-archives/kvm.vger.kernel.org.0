Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C0A7BCBC6
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 04:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344300AbjJHCx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 22:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjJHCx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 22:53:56 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59260BA;
        Sat,  7 Oct 2023 19:53:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c60778a3bfso28726575ad.1;
        Sat, 07 Oct 2023 19:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696733635; x=1697338435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IOZ0izDUQq2XHlRLxr0WYfVNec458EhRnc7Qad7kB7k=;
        b=iz7EmdzHnd68e9J+fcME7K7K+K+YsC2uvbJgIc1mAhfX9yanpjDGiX65FR9IERnQPt
         kmcehoiMKubOOSpmJh2UDjpSsbDL4HCQJFBtLPN2q4g2iBkLyjVF4DC8G4sXBavnCHoT
         rVc+KXj7kZ6VBHuWk+5aIATudfNjfuR1uOhAs6fjpnfmjx0/cW5n7KEQg9tDsmIOVlPm
         q5xlFOmT9KAdgRLLH+GykcMCulSyPyRCmwx2U7PrXbKfN+ENc2K+lSIyC20jj6jRLO3w
         k8sUE+zwVZ4rYyucs5/fSo6vkvupzsJaRhhKtvgg1PGizUuD0kvRfd5128tHPMOqkUUx
         rQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696733635; x=1697338435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IOZ0izDUQq2XHlRLxr0WYfVNec458EhRnc7Qad7kB7k=;
        b=R9eVaTDiTaPumYs8+GZFdKl3xg4Ybqg7pOxiJn5UrZuTsF94yvQXOw7LQG9KY8o/k5
         BWaKrfEAa2IBuM15Cq4xXt2RiNW5JW22g+bTmTxAzchVklpdpY6xDPQQZCXWOki3SMIY
         A1L5Bvst7vHoLA5q6jp9NBvPPbjRgh+fxwAVqv5EIJQ8Ub/+ipxH0LUg4lGZoeJ9jNyO
         GvwQZTpOqdU9Vf3WlmT9DHoxGR15DtxjfGi0ZtgOVIo6lBMvY/5Ze0vJ+1VT9+AHweOj
         6PEGzVaalJf/HUd/DY65boWOCsRUsFRk7+wj4F1qRt12jAcR1Gj4ReDk1K947QEpyZVL
         egIg==
X-Gm-Message-State: AOJu0Yz/E/ITsbzKaWoGh0yjMOlNDghKozPkOp7IjtXDDyuOIBekhEdh
        TsHg0m/feGwpx9QEwoVZuTU=
X-Google-Smtp-Source: AGHT+IFqHllGcgY99+doWW3ny+cZRDsD+x6Xv4s28BgC/qLCdFiulZopC/PLDJ5DS2IcPw4qwYpDnw==
X-Received: by 2002:a17:903:2791:b0:1c6:c8d:6b4b with SMTP id jw17-20020a170903279100b001c60c8d6b4bmr10603527plb.59.1696733634655;
        Sat, 07 Oct 2023 19:53:54 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001c877f27d1fsm6628090plb.11.2023.10.07.19.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Oct 2023 19:53:53 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7] KVM: x86/tsc: Don't sync user-written TSC against startup values
Date:   Sun,  8 Oct 2023 10:53:35 +0800
Message-ID: <20231008025335.7419-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The legacy API for setting the TSC is fundamentally broken, and only
allows userspace to set a TSC "now", without any way to account for
time lost to preemption between the calculation of the value, and the
kernel eventually handling the ioctl.

To work around this we have had a hack which, if a TSC is set with a
value which is within a second's worth of a previous vCPU, assumes that
userspace actually intended them to be in sync and adjusts the newly-
written TSC value accordingly.

Thus, when a VMM restores a guest after suspend or migration using the
legacy API, the TSCs aren't necessarily *right*, but at least they're
in sync.

This trick falls down when restoring a guest which genuinely has been
running for less time than the 1 second of imprecision which we allow
for in the legacy API. On *creation* the first vCPU starts its TSC
counting from zero, and the subsequent vCPUs synchronize to that. But
then when the VMM tries to set the intended TSC value, because that's
within a second of what the last TSC synced to, KVM just adjusts it
to match that.

But we can pile further hacks onto our existing hackish ABI, and
declare that the *first* value written by userspace (on any vCPU)
should not be subject to this 'correction' to make it sync up with
values that only come from the kernel's default vCPU creation.

To that end: Add a flag in kvm->arch.user_set_tsc, protected by
kvm->arch.tsc_write_lock, to record that a TSC for at least one vCPU in
this KVM *has* been set by userspace. Make the 1-second slop hack only
trigger if that flag is already set.

Note that userspace can explicitly request a *synchronization* of the
TSC by writing zero. For the purpose of this patch, this counts as
"setting" the TSC. If userspace then subsequently writes an explicit
non-zero value which happens to be within 1 second of the previous
value, it will be 'corrected'. For that case, this preserves the prior
behaviour of KVM (which always applied the 1-second 'correction'
regardless of user vs. kernel).

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Tested-by: Yong He <alexyonghe@tencent.com>
---
V6 -> V7 Changelog:
- Refine commit message and comments to make more sense; (David & Sean)
- A @user_value of '0' would still force synchronization; (Sean)
V6: https://lore.kernel.org/kvm/20230913103729.51194-1-likexu@tencent.com/
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 34 +++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 41558d13a9a6..7c228ae05df0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1334,6 +1334,7 @@ struct kvm_arch {
 	int nr_vcpus_matched_tsc;
 
 	u32 default_tsc_khz;
+	bool user_set_tsc;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdb2b0e61c43..776506a77e1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2709,8 +2709,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 {
+	u64 data = user_value ? *user_value : 0;
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
@@ -2725,25 +2726,37 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	if (vcpu->arch.virtual_tsc_khz) {
 		if (data == 0) {
 			/*
-			 * detection of vcpu initialization -- need to sync
-			 * with other vCPUs. This particularly helps to keep
-			 * kvm_clock stable after CPU hotplug
+			 * Force synchronization when creating a vCPU, or when
+			 * userspace explicitly writes a zero value.
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: when a user-initiated TSC write has
+			 * a small delta (1 second) of virtual cycle time against the
+			 * previously set vCPU, we assume that they were intended to be
+			 * in sync and the delta was only due to the racy nature of the
+			 * legacy API.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * come from the kernel's default vCPU creation. Make the 1-second
+			 * slop hack only trigger if the user_set_tsc flag is already set.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;
 		}
 	}
 
+	if (user_value)
+		kvm->arch.user_set_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3869,7 +3882,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, &data);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -5639,6 +5652,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
 		ns = get_kvmclock_base_ns();
 
+		kvm->arch.user_set_tsc = true;
 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
 		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
@@ -12073,7 +12087,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, NULL);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

base-commit: 86701e115030e020a052216baa942e8547e0b487
-- 
2.42.0


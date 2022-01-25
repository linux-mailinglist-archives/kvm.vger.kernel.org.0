Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839AE49B154
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbiAYKFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbiAYJ77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:59 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F526C061763;
        Tue, 25 Jan 2022 01:59:59 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id k17so1216444plk.0;
        Tue, 25 Jan 2022 01:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9H2RK8DHWUQ8flbtobvjjEJWkT4wxuUh6nAS0SNRdvM=;
        b=LYVSwsR5VkUmnzLoKDW0Dh5QOI7K7kPhc0fcFv74Z6QR/gjEnpEvmD0RhwikT3W+HO
         sjbN/N9zwH2JJtzPrGmLiWm/FWlDNbj0exJG2+e+b61AjIfX2bQ2iLscQd2OvLEm739u
         VdNo1rmcOHrdpnU6mfcAeiljwxcZCG0b58J8JIYyQV2hzRez5s4ZhHeV+poWSie6L1R+
         lk8G6BXQMj1/pQgQoFCSC/zoywMtilUbEshVKKwKQEXh5q3R3SwZN545iW0A/AwtUJMV
         f+9J7bnuqk4k5v8Z+qGw4EytTBbjU+c1EsyCSiii8TxQVs7XOzT2JyT4sZtHn4dMgvOe
         Kmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9H2RK8DHWUQ8flbtobvjjEJWkT4wxuUh6nAS0SNRdvM=;
        b=lDyb4qO8XV+Epr9VIk6GUkvXW1DT+01W/pnrvnxkni+F1XRmfFb/uVqZnbw3IDnrA6
         ondmmzCcx0AVpgBbE721gZzmdkUVk0rbbVH9PEL4sUGF1htGdkMX3dJJMf7dsS3mKKXe
         KFt83N63pPe9ozS9iZoiPMoJTw3EAq18RsHcH1VxLFZff3z0XnstqcF9Z//eY03VJA60
         6OEwSbbgPS1Cpj1fQ8hN1IYIjYQstgf+WMn2dTwRMVW+ox3QJa/CvWFWnGwPfQGoz1Kw
         KlBmxKd6HMiNuh7sJAr+OVoBzxJ3+uuSMyWs5OsvFtDl0Pi1V4AZ0KgIx3Dkttdw1gH7
         qUYw==
X-Gm-Message-State: AOAM533iTPOF1yT4pswxM3Gt4fQExun7G7c22/C3mKvMrc7Cx/isqfut
        klzI3NC2wbwA8hU9yKpzLDQ=
X-Google-Smtp-Source: ABdhPJwnM1BWbeIyfdBw0xYAlNuKBZp8Mw+OlA1cAca3g7ZZEQ6dQFfFo22ViVxDGGmCmNT9thHhag==
X-Received: by 2002:a17:90b:1806:: with SMTP id lw6mr2678516pjb.124.1643104798690;
        Tue, 25 Jan 2022 01:59:58 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:58 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] KVM: x86: Remove unused "vcpu" of kvm_scale_tsc()
Date:   Tue, 25 Jan 2022 17:59:07 +0800
Message-Id: <20220125095909.38122-18-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of kvm_scale_tsc() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/x86.c              | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 682ad02a4e58..ebd5a1e8db77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1871,7 +1871,7 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
 	return kvm_find_user_return_msr(msr) >= 0;
 }
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio);
+u64 kvm_scale_tsc(u64 tsc, u64 ratio);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier);
 u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 22b73b918884..4e438e009ba9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2397,7 +2397,7 @@ static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 	return mul_u64_u64_shr(tsc, ratio, kvm_tsc_scaling_ratio_frac_bits);
 }
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, u64 ratio)
+u64 kvm_scale_tsc(u64 tsc, u64 ratio)
 {
 	u64 _tsc = tsc;
 
@@ -2412,7 +2412,7 @@ static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
-	tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio);
+	tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio);
 
 	return target_tsc - tsc;
 }
@@ -2420,7 +2420,7 @@ static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
 	return vcpu->arch.l1_tsc_offset +
-		kvm_scale_tsc(vcpu, host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
+		kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
@@ -2623,7 +2623,7 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
 	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
-	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment,
+	adjustment = kvm_scale_tsc((u64) adjustment,
 				   vcpu->arch.l1_tsc_scaling_ratio);
 	adjust_tsc_offset_guest(vcpu, adjustment);
 }
@@ -3043,7 +3043,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	if (kvm_has_tsc_control)
-		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz,
+		tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
 					    v->arch.l1_tsc_scaling_ratio);
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
@@ -3854,7 +3854,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			ratio = vcpu->arch.tsc_scaling_ratio;
 		}
 
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc(), ratio) + offset;
+		msr_info->data = kvm_scale_tsc(rdtsc(), ratio) + offset;
 		break;
 	}
 	case MSR_MTRRcap:
@@ -5067,7 +5067,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 			   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
 			   kvm->arch.last_tsc_offset == offset);
 
-		tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
+		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
 		ns = get_kvmclock_base_ns();
 
 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
-- 
2.33.1


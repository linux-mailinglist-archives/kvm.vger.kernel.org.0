Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F3849B152
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbiAYKFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238620AbiAYKAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 05:00:01 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7139C061765;
        Tue, 25 Jan 2022 02:00:01 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h12so19432438pjq.3;
        Tue, 25 Jan 2022 02:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0kf51n6IyPfulhV98Cqhgqk8V87O+wD98aCTABuT/8=;
        b=jxR3fSQn2SIOlSqeCo0N4ZF4EkoASI2lwdGuP9rf9m1fJRMjfg1gyQHvNgwRQN9Psx
         1ULXx5VA5jTv3Nic5RlnjtaL7qRGmO1JDJhJhVGwh8YZ26vKoFMqYEkkYyUoByz4eCkH
         Xv6VccQ6B4VdpJKMxBMuv6iPcBzk1pGZaDqzRKp7kwFlhznvGbgxk2/ICzabqGzGn4Ju
         P5lb5GiSPo6vHew/568KAKWY93c8Gx3gQKUDgRDCCxwoXi98FOyCvRkNORyeLnGXrg83
         uiP5ZE0CRIRfPIevbdrCdh8H34TvUL+yayZKocQRGLMr2gPKpES1QLVI4nslpkyrFiAb
         YU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0kf51n6IyPfulhV98Cqhgqk8V87O+wD98aCTABuT/8=;
        b=hrRJO3GX+J1TWv1R9rsbF31R7IaVhT4qDOU33O4SrZJ40l3hReIP+gX/OdKuu65Zxa
         v5rSmbkWkrDFMVNFycBluPXBauHJDQs5NDlTw9n0MYsWWHZ44sCLK7ZcA+QI2tMMeYFv
         TB2Tg8F+TGl/zIhJjA2YNXBOkOuJFnsW/6M2/jLyfBrm0naMOZqdU0kRHdnoAqpv223t
         QnXzO05NVfveGTBkld3SIFsOqfc6xmv/Drp7nBv62ReqhMuh+Ff8HAyFpAkL0s15UeVg
         2PFq8OUwXEidVM/INafkaIiXmx6ATltCu8HpLW3p57HKm14VCUTe1ZWMGzrgOJwv6fg4
         c05w==
X-Gm-Message-State: AOAM531xn651WwW9GGV9O3vzBVaUETbapKz0ik4FL1N1CJw5wkotFXBJ
        SEsETtTNY23Gmzq4q2aiCL0=
X-Google-Smtp-Source: ABdhPJwvw6KfDKluuJS1i0sjUTcygJqrxm6knMaK2EAZYsPwW48EwE90DjtJqiENVqCTovgNum5t0A==
X-Received: by 2002:a17:90b:1d92:: with SMTP id pf18mr2658168pjb.162.1643104801241;
        Tue, 25 Jan 2022 02:00:01 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 02:00:00 -0800 (PST)
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
Subject: [PATCH 18/19] KVM: Remove unused "kvm" of kvm_make_vcpu_request()
Date:   Tue, 25 Jan 2022 17:59:08 +0800
Message-Id: <20220125095909.38122-19-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm *kvm" parameter of kvm_make_vcpu_request() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 virt/kvm/kvm_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5a1164483e6c..1c98a47c8908 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -246,9 +246,8 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 	return true;
 }
 
-static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
-				  unsigned int req, struct cpumask *tmp,
-				  int current_cpu)
+static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
+				  struct cpumask *tmp, int current_cpu)
 {
 	int cpu;
 
@@ -291,7 +290,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		vcpu = kvm_get_vcpu(kvm, i);
 		if (!vcpu)
 			continue;
-		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+		kvm_make_vcpu_request(vcpu, req, cpus, me);
 	}
 
 	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
@@ -317,7 +316,7 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu == except)
 			continue;
-		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+		kvm_make_vcpu_request(vcpu, req, cpus, me);
 	}
 
 	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
-- 
2.33.1


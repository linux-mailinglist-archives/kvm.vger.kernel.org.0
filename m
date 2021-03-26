Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4AE34A676
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhCZL2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 07:28:54 -0400
Received: from m12-14.163.com ([220.181.12.14]:37540 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhCZL2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 07:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=VqcQ3
        QwxKEEaQnL4ibnWt3XJl6W8pH63gUjHJUgNVrA=; b=Kq6ECmXkpn9wM1Iy7VpGJ
        zzSFR4RDnUBZrQvPXR4jAOEQ1Cx78rJoz9dptuOwy2J/e5zsA+lrR9tEqPnGItMd
        rW2p2C77FpgM/6WJw0DU1ayhR4v+vVF2k29cKrmXTDQH+sq/pMhcHNspBR6MLa2m
        38C5cnwRalQ5JQgy3zPcMo=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp10 (Coremail) with SMTP id DsCowADHaXwexV1gLKxVAQ--.32339S2;
        Fri, 26 Mar 2021 19:27:31 +0800 (CST)
From:   zuoqilin1@163.com
To:     mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] x86: Simplify the return expression
Date:   Fri, 26 Mar 2021 19:27:24 +0800
Message-Id: <20210326112724.1563-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADHaXwexV1gLKxVAQ--.32339S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF1fXw4xCryUXw15XFyrJFb_yoW3Xrg_Ja
        13Ww45KFZa93y7Aw17Aws5KF1S9w4kXry5Xa18Kay5trn0ya98Za1kKF4fXrW2grW3KFWf
        X3yDGry7Cr4UWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnhSdPUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/1tbiZQNhiV8ZNb3ALAAAss
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Simplify the return expression of kvm_compute_tsc_offset().

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 arch/x86/kvm/x86.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe806e8..3906c1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2209,11 +2209,7 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 
 static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
-	u64 tsc;
-
-	tsc = kvm_scale_tsc(vcpu, rdtsc());
-
-	return target_tsc - tsc;
+	return target_tsc - kvm_scale_tsc(vcpu, rdtsc());
 }
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
-- 
1.9.1


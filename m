Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8529A49B14D
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbiAYKEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiAYJ75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:57 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C33C061762;
        Tue, 25 Jan 2022 01:59:56 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id z5so4853359plg.8;
        Tue, 25 Jan 2022 01:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YnN/7fp1e87Xkb15yeqSf2q+9XCvC4rYSD1MfFhGDFg=;
        b=Bb7ez8ndfUaWuwAE5qwgFjDjKsFfdcKEcLWJ21pvJsV+7H40n2LLgR+wbaEcEFJnYK
         t0Wcjc69jL7xc+uVD/cOq88PAMXcCcMFEwmcMvTuXDJK0DnDu6nuQ2N5ViPk+oDxF9ud
         fr4s7Emv6ybchbE0aSqVCnQHOC+MP22XFTV5HTap2T+t4kuxB6PTP2Ab/X6f5UaXNtKk
         tjgNBWhtKzyDl8GEg+Dobl06vZXkhEKdVZe7gYr4v4RKsCfNpzr+RbFqGmLWFMarWB+i
         NFS3DiG74nRvai2QhAcFlS/arZVn+qE/PRqAWfCXuLa1w7BZK6ocXvaWXCyjVuOShzRh
         OCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YnN/7fp1e87Xkb15yeqSf2q+9XCvC4rYSD1MfFhGDFg=;
        b=YIDMgE5Bf2pxwwNYnbHqfWVCG6oZhGXboju0b8GKuNbwJzaIQloMG5zM4vMwIAhCwg
         zyn/0IIQ9xZxS9U9go0c1esyuTB6QDRgF92I3c5vDPyAFBwMfJxObWTaF1C+NU6/6/Ma
         2rB7HjQ3kGmPXg9sRTAI1lgCSZzFg3AAGEFwGHOVtKQemLh/kUab4CkhVeA1rCXt2Jij
         2MldRw2jZa9rnQe/EqMV479pqOebk4p9Ddnp75SXb1CtL+48vEOUfI5q0TszuDLT26ju
         hsknWjX7W7vxIABebEVgZVk+9TBU2OLoA0KOMHP6ipu/7frriL15vk5Mpu1NOBD+b2T8
         jQJg==
X-Gm-Message-State: AOAM5313FYP6dv/21I9bJKoOPf87jDsDEDeZIrcPv+sTGk2x9sC4L7yk
        k5wpnUyRJBVa+4/9tueSIy0=
X-Google-Smtp-Source: ABdhPJw8R5DkDfp8TLbsqdtNRklBVYWp57XWzVzCBV18mZEznh+5aak3Hh+XKXheTJPyoak47oCAMQ==
X-Received: by 2002:a17:90a:7891:: with SMTP id x17mr2699783pjk.112.1643104796316;
        Tue, 25 Jan 2022 01:59:56 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:56 -0800 (PST)
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
Subject: [PATCH 16/19] KVM: x86: Remove unused "vcpu" of kvm_arch_tsc_has_attr()
Date:   Tue, 25 Jan 2022 17:59:06 +0800
Message-Id: <20220125095909.38122-17-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of kvm_arch_tsc_has_attr()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df46d0737b85..22b73b918884 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5003,8 +5003,7 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
-				 struct kvm_device_attr *attr)
+static int kvm_arch_tsc_has_attr(struct kvm_device_attr *attr)
 {
 	int r;
 
@@ -5099,7 +5098,7 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 
 	switch (ioctl) {
 	case KVM_HAS_DEVICE_ATTR:
-		r = kvm_arch_tsc_has_attr(vcpu, &attr);
+		r = kvm_arch_tsc_has_attr(&attr);
 		break;
 	case KVM_GET_DEVICE_ATTR:
 		r = kvm_arch_tsc_get_attr(vcpu, &attr);
-- 
2.33.1


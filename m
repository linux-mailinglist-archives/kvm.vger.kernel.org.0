Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2952745115
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 03:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfFNBP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 21:15:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43419 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFNBP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 21:15:57 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so258307plb.10;
        Thu, 13 Jun 2019 18:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=V/tSLdlcdF/I9PVXC5pN0h7p2wTnOWmfYhxeqpqdV+OGOuOnilPRH8RGUtKAoKn1Uk
         JlqEtaNylSDgvsiamuMRXR9NPxJKtPzCH9t7l2cI5LYhDn/3c/3s8eW+N8JDSlIG5n+G
         8W1AMkySTDk4H7eYRtl7B/iEwqWH6A/tZNRdSDRwbekoeYA39q6EYUtu7jGMX4VxMBJ9
         PBwg8rjjdCQ6eRrYK5sSGkVqtIP/oWsayrApY1fBBCmpcu43XRbs29OJGo98xKKSMm9E
         US8Ul+9pRk7ALbRDGi5ReQJqxdhcAKyVEDNmL7ive+U2Isk7BPDis91h7+pf8L8/T/T4
         f6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=KxkwsB18SmULYqmC365ShGjufeJLTHnBBvksPUUCQsfBog1PQWaoCEMyASZ/WHl688
         LTCqjJcvtuOQ+0TOPw9xM6EPTEjJ+l1kGwfdHQG3ZX/1DqUlaFcSNm8mVfmrUhD/98JP
         Rt5QgpNHolKv5DQtdzh0cK+pt2lDWH2o0KJoQexpddxiWzlw3ebHFpAtywfVx1pzDZcc
         4TynjekraZYFDJOLvmpGrbrsuvJPh2yqLL4MTRvkUVEw3WcodhhdFKWSXCYmTpL8J/8W
         2u9B3KuZEBTKYpKG0IJvcvIrYVXObOXU+DNCPeZjHVTlwmizFp13+vWGpH6q8JP/N3kp
         bixw==
X-Gm-Message-State: APjAAAXCZkojfxVq75hUChuI0hk8/Rchb9p6038p3y8IQoFUGqlNXxMV
        eMq+tY54rmobB/yms38nC0lAt20e
X-Google-Smtp-Source: APXvYqww3t8b6nDvXq8xiL8DNNCHMn8aHXG7Uimi7pMeKPGBeIBQvzQxRtOmyoxFnnPuBOv9w9Untg==
X-Received: by 2002:a17:902:b213:: with SMTP id t19mr16203305plr.163.1560474957020;
        Thu, 13 Jun 2019 18:15:57 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k3sm907424pgo.81.2019.06.13.18.15.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 18:15:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 2/2] KVM: LAPIC: remove the trailing newline used in the fmt parameter of TP_printk
Date:   Fri, 14 Jun 2019 09:15:48 +0800
Message-Id: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The trailing newlines will lead to extra newlines in the trace file
which looks like the following output, so remove it.

qemu-system-x86-15695 [002] ...1 15774.839240: kvm_hv_timer_state: vcpu_id 0 hv_timer 1

qemu-system-x86-15695 [002] ...1 15774.839309: kvm_hv_timer_state: vcpu_id 0 hv_timer 1

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d47a26..b5c831e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1365,7 +1365,7 @@ TRACE_EVENT(kvm_hv_timer_state,
 			__entry->vcpu_id = vcpu_id;
 			__entry->hv_timer_in_use = hv_timer_in_use;
 			),
-		TP_printk("vcpu_id %x hv_timer %x\n",
+		TP_printk("vcpu_id %x hv_timer %x",
 			__entry->vcpu_id,
 			__entry->hv_timer_in_use)
 );
-- 
2.7.4


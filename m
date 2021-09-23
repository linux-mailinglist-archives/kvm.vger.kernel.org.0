Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D884165CF
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbhIWTRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbhIWTRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68354C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x185-20020a25e0c2000000b005b53ab9f5e9so298551ybg.22
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dkhhhARdJNItMKxiO8fcGRSgRnnWwiZ+q9GZvF1SajQ=;
        b=fSTmJxItQ0Esp6edjHZ8XsCfQWYHWKgn2MDQr6xhIU/ioCwoXCgLyZPcUWoOb7i8i7
         4X97ySbmn8RyA0zkhhXz1njQPPCykyZyalZLQqQsLLyUfNrazWj5Dr/dSCDZDipWFeOZ
         afxmhjQ8lo8oLO+HlThsMGn6g+hmC8AIP7jl/E0d/fAu91N/vJpQGLIcwRf31aCSFfMV
         M62AMOTGVsRa7mldVqkgUXLTCcXTgx6GLJxJyIn8jno3AmK6Ovp9nbjAzJNkxpXr7P4z
         VpoCpRzO1LByDRPW3pWWB8Iv1Z2XMpaXrJETCelkEsp9RdY4DYRFtPYrOjSQz+C1ZD16
         vZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dkhhhARdJNItMKxiO8fcGRSgRnnWwiZ+q9GZvF1SajQ=;
        b=Rb1/4fVJZ887sac/V9nDdD8wwGaM9/pNa7GQpZyUORGG48tGtWf+wZEeYnZTBiEE3N
         YfYFfnkT8cYFjDIZeKXA2fHBbrVUGLq3G8GZNTaPCQH+iis+hHUJl+HFKByJR57TmILx
         PmaR8pyemmkrQ3UPcTJGhvOj5SEIaH6cO6Ul9+L9hgmzWS93jhXdoYM3J+niZcBFkDIT
         g8iOo84g+tem59v5VHIOdYx92QOYGbCiWmY/WmmvUzBer1bC6eoz5xmAkL9l9TcDtBKh
         t7fqE+XUbiVXsRJ1QxDE/hCFPyd6mW4WG5PK4qnQ52SVRIDxJZVOGp6LX3G/wLxG0W4Q
         9TdA==
X-Gm-Message-State: AOAM532I4MaoI3DD5FG+WkvgPjXclHVidq87JJw4f8Czo/fKJBWhE1VE
        gVzu6oGYO3ZIxqZoz8wRIy4sKNEjv6A=
X-Google-Smtp-Source: ABdhPJx9mCky5M8FDvxeXJD6cDUieD2bDPTUWqI3NhMeXKbuooMw9pu1tjzha9gnLbeS3TGZ0fVM66DuUw0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:61c8:: with SMTP id v191mr7593036ybb.472.1632424580561;
 Thu, 23 Sep 2021 12:16:20 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:03 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-5-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 04/11] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The naming of the kvm_req_sleep function is confusing: the function
itself sleeps the vCPU, it does not request such an event. Rename the
function to make its purpose more clear.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..3d4acd354f94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -649,7 +649,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -679,7 +679,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.33.0.685.g46640cef36-goog


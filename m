Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195EF7B258B
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjI1Svk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjI1Svi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:51:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B44194
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d84acda47aeso22639357276.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695927095; x=1696531895; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d95p3oGQiycVKkc//04hSmYmUQWwwXTfWr/75IirAoA=;
        b=uKfMIZPcaL1qVMfUwefCm8yAY/NQWT6U2oWEsw+x4cP/tDwhWPykbdxGAq4uiLkJ7Z
         x/5+nQBLEXKzKx0NWV9urPUrEona3Z+EDx34qCXVg7Bi0qlVj5XHgLjwxVcOH7qLPP0A
         U4zv5a3fqiWIfMM6rYKT+PKEC26LwweqkS885IBFrYBDa/A53NWbdpBzPsbSxL4kq/g5
         KxF6LMdSbWd99fHJJ9aEYuBj12yUMGnhXVwu+VISaSdrulTt+vICBx9L92nhvsmzX2yL
         doh0LNlM9AJsLkIge6F64RjIZII2oKbGOjZLKfrZwQ9Zhl/UEp6/OkBvMFQ3FUsi67bb
         DQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695927095; x=1696531895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d95p3oGQiycVKkc//04hSmYmUQWwwXTfWr/75IirAoA=;
        b=Y2hu10TJlojcei7nHg7dPpVRvlynYZHLObI6gXEj1rQinEIKQm5ap88lKTirzp9+vU
         4K8QCXjm8jVVVfQh1RzGq/j600yM5eJbUDIGUt9TXbsNQ6ju6C6yhM9mEWj8plMXRYON
         gnr56c6y4RPGZGN+yzN3tFCepJZUTU372XOCjSqjWGISp6kgm1T52HSYtTkjTAuivZ/v
         3ooe/ElSFkGooIPLCEzLwRZxY4m8Ox8hZmm5cXEVUUm+V2QRi2bPqAoX/8UJ+7uOgPfT
         h2sfhY6r4ux35fSfo8yCthWafddgNPacqIfunks31Bga04ZxVQmmtqIEqUDlNZkYxvoj
         N+kg==
X-Gm-Message-State: AOJu0Yx8Ie/6wCYO3209clkHcTKKl6FycZHFMyrmcdsSgjPZMRAJ7L9h
        RKKEJnuWjU/qfJ7nlCofXrGspJLQjAvolhwocgdbvT7yofMfQXl5eoHL1N+r0wrIccd6EhALVjw
        FTyMEtqLVlR/io+hiS8IFHHjmSCMveHxl/VKHGHXdcjUXBRqqB4rajeS0NmVZS88=
X-Google-Smtp-Source: AGHT+IEELcyV78L1izUyWbokGVkkVnuPI0Hxp8AdEJ/q7NL+TWVsxiisq4bHAGf52JPQmU7w6XUfytL6acjY1Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:cb03:0:b0:d77:f7c3:37db with SMTP id
 b3-20020a25cb03000000b00d77f7c337dbmr29812ybg.8.1695927095117; Thu, 28 Sep
 2023 11:51:35 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:51:27 -0700
In-Reply-To: <20230928185128.824140-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230928185128.824140-3-jmattson@google.com>
Subject: [PATCH v3 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
set. If it isn't set, they complain:
	[Firmware Bug]: TSC doesn't count with P0 frequency!

Allow userspace to set this bit in the virtual HWCR to eliminate the
above complaint.

Attempts to clear this bit from within the guest are ignored, to match
the behavior of modern AMD processors.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a323cae219c..9209fc0d1a51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3700,11 +3700,26 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
-		/* Handle McStatusWrEn */
-		if (data & ~BIT_ULL(18)) {
+		/*
+		 * Ignore guest attempts to set TscFreqSel.
+		 */
+		if (!msr_info->host_initiated)
+			data &= ~BIT_ULL(24);
+
+		/*
+		 * Allow McStatusWrEn and (from the host) TscFreqSel.
+		 */
+		if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+
+		/*
+		 * TscFreqSel is read-only from within the
+		 * guest. Attempts to clear it are ignored.
+		 */
+		if (!msr_info->host_initiated)
+			data |= vcpu->arch.msr_hwcr & BIT_ULL(24);
 		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
-- 
2.42.0.582.g8ccd20d70d-goog


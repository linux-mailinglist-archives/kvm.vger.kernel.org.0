Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0047AE197
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 00:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjIYWP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 18:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjIYWPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 18:15:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76E2BC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c12d31d04so139716927b3.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695680118; x=1696284918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8KY3E5PT2qGB4K4AEG6XG9m05XP6zN0evwT9MyG9uE=;
        b=gyighJ7pP2gOT7e1IFfQ3o03WFiunVZaUM4vnYVUIOpzPi7vKGYVfxsZc+DYrIC6ze
         H8Y9+NLzHOH/Rx2kAa2N4mtwJadJ9unyikbVEW1C5dbNtTIKf3/+GSBPSNP5Du+dqOh3
         8PtRdtxR9erOTNSu+Cr5iqeQDt0qpgKLv6XK7qsJrTXiXcl7RYaQZ6tZA1Yhfnn2BevQ
         Ky4PI3tt2tpuRMb0i2Z8YXw2l0hRJ6oSVE0QQ4k5DFVF57DX7FU9dW5CtCp7aySvkHqc
         AsFGrIYZkDAl23VSJYfiBGOZJVKbpJh6E2p2U6J2O74PUi0x6Eg27DcEdDBmLziL1eus
         hlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695680118; x=1696284918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r8KY3E5PT2qGB4K4AEG6XG9m05XP6zN0evwT9MyG9uE=;
        b=aN1mg+HbYQCH5cSHwpWaLf8ivkMEkV/wpFD6O6Fzq4sUWJSkRZdj4kPncQMOUkruXN
         UpwRXrVCXaVFlUvqrpLskY16e0b6fr8noLVT+yPOUfv4qtDy437Wt20OM/scK+i1FTtw
         buGPy08AqZz3rjz3rwnweohEpqS5sG9bid4CQE8HerKkZnVsr0QIEJSIYwSNR9VcEiN9
         GpE0RNZ7vmfr7maf51Llt1pilC7ChDcoKckqby2w4gh/+AbKMZbtjifV7xt+kT6j3Y2I
         GuMneph7WIkD2keWAIaoUnHC+1csPQlGoRDP2tKkwLrNXt/8I+nNRLb4+cXxe8/M57Z6
         ApWg==
X-Gm-Message-State: AOJu0Yy0bdXGNQQSICfZXekMy4aZRaS3OF91SiEmGwcXOFYkc543wMMH
        hbMpjzz2ERivcGoMaK4+tYTyBB6b9d0gWJS5JfW8u/CxcgQzzss9OYLzWFTYc4vqilNxATwKpuO
        dsRl8bXXLM5kxItVLACPr0NCnhp+djqtyaZ21YU/CDxsSWNJAAaYb9KShfvH3JUA=
X-Google-Smtp-Source: AGHT+IH8h8Bt+Y+xBeJtT0VeSEUIVwy4MWluKGM2sM/aVSGF5seIDqVs1K5bdQ7tT4Jcw2slHfYOc7qteJ/xEw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:e30d:0:b0:59b:eea4:a5a6 with SMTP id
 q13-20020a81e30d000000b0059beea4a5a6mr95785ywl.0.1695680118044; Mon, 25 Sep
 2023 15:15:18 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:15:10 -0700
In-Reply-To: <20230925221512.3817538-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230925221512.3817538-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925221512.3817538-2-jmattson@google.com>
Subject: [PATCH v2 1/3] KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
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

When HWCR is set to 0, store 0 in vcpu->arch.msr_hwcr.

Fixes: 191c8137a939 ("x86/kvm: Implement HWCR support")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..1a323cae219c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,12 +3701,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
 		/* Handle McStatusWrEn */
-		if (data == BIT_ULL(18)) {
-			vcpu->arch.msr_hwcr = data;
-		} else if (data != 0) {
+		if (data & ~BIT_ULL(18)) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
-- 
2.42.0.515.g380fc7ccd1-goog


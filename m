Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7074AA270
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiBDVmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbiBDVmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:10 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B216C061401
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:10 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id mn21-20020a17090b189500b001b4fa60efcbso9399906pjb.2
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jqW8hPDdRJB2oQW7EYj+6p3+zfKz+RTL9qmY/jYFQRo=;
        b=mxpLoHZxxceqi0+lhEctMV52m3RcDvRtmSBrb5iQNPZmk36kIhoWNYnpPLBkWg+K27
         rBdNv2dsoikUnJEgFdv1P01vGeP2JV1ZFV9xJvjVHfBJSlYxAjExg1wGpYBcKt5OvbbQ
         6Lg4wzTvrvDOs9R/4BB8EtBaixgrzcpu2qhhe7nwStgd5OKv0k/xsNM+T0HIKyUSE78m
         0GGqLbq99uPd74uNMoKl+x0z6q/YaS+TBUJ/r9T4iDCJLPS9lXHaOnVVxNRdIe0eqKfh
         Ewjj0OJG8ISl90B3zHt2FufYFyJ7rFbhNs0/yZq6bFrPO2tYcUSuXBwysy0g15Ha1dZs
         i3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jqW8hPDdRJB2oQW7EYj+6p3+zfKz+RTL9qmY/jYFQRo=;
        b=h2Vtc8vsF8oaDlLv61sh8risiiChnRr0EyMZrQ9CZkaNUL2mk3jCxEulgsJyJf411N
         5Z0kkm828RhSz8MUMBTaN3zYScign8a7wATyP0OmFf3a0SNCPiQzbiUUOyHNZ3t8Rrmm
         vzPCw3OjFZC+LDkqnfuDsQt75ugcGpQg0lFJQYAYo05D4kDhLsKjsccHL8LBYQodGqPn
         Tn/5iqPZ2siLeu4duD5KFR1kPnvM/zgrULXu2LHlDYQwbXIMruhynUFBopA3n3PF49Vh
         arwwKRnGskGfro2DoKDh+4/PMc2zh2TcRMcCsbzYx26ZZGcU/od/ZaCOJsBB1PDnE+Tu
         zjpQ==
X-Gm-Message-State: AOAM532rTwbF1AW8iBZ9e6b9J6OvN473RbiTcstJmYZuJLEuMuU8wrDA
        o2g1Rc7CNtNnolV/xXKArjMaDOxAJKU=
X-Google-Smtp-Source: ABdhPJybgJWW84dSDuUusL/JqKhOMbJauGmywX5GZ5VlYfiLzIbOHnENEI2942xqrRjXywil9uRm2TS2XJk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b403:: with SMTP id
 x3mr5343641plr.61.1644010929602; Fri, 04 Feb 2022 13:42:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:55 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 01/11] Revert "svm: Add warning message for AVIC IPI invalid target"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a WARN on an "AVIC IPI invalid target" exit, the WARN is trivial
to trigger from guest as it will fail on any destination APIC ID that
doesn't exist from the guest's perspective.

Don't bother recording anything in the kernel log, the common tracepoint
for kvm_avic_incomplete_ipi() is sufficient for debugging.

This reverts commit 37ef0c4414c9743ba7f1af4392f0a27a99649f2a.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..ecc81c48c0ca 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -345,8 +345,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
-			  index, vcpu->vcpu_id, icrh, icrl);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
-- 
2.35.0.263.gb82422642f-goog


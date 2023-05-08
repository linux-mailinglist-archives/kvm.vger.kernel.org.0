Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137486FB445
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbjEHPtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbjEHPtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0086FA5C4
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:34 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-965f7bdab6bso636477866b.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560899; x=1686152899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUQiJBVRFOYwj3LFo9SqD7kqRZqQ+2PxKuM6BL7h40I=;
        b=Qfm6+G4WvzVL4wrVGrBvOtN403UmyKKYwxYYgKaEkA29qU3EzzjNXgmq03iV1V8h71
         SqCK9fw/OojzEhmOzvGEFHvCQ00fFTm+hdpGYzsFLMQgAS/gkgx24bzx3xh21uMCmPVN
         ZELaHmpBnIXPwhP23WYRQuaqkb3VVrD5td6E5rrikmJsJuI3CaDHvRxoECGOTWhhwJJ8
         QLS+1XYB+FasfYecpneaj5iK0eD1w2tzZ3rTozm36rXcpokp7i4CqkvmrjWS8YnpgcWW
         IH5FCeyXgsNPMGiEVD5O0MmLxKqrM8Zp9VvYuk6mHKFNo4ojmMA2+SnFh/w1a7oeWe6T
         KMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560899; x=1686152899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUQiJBVRFOYwj3LFo9SqD7kqRZqQ+2PxKuM6BL7h40I=;
        b=ewGuWTX28/LN223ZgnXa0Er5z0LgOlCd3SuqHggHUGweyjVnJYJthimFWX1UL32KQS
         AOY0jRskp7kp0ab2to8v0x/a/I49iz1vPjHvyB43SR10V1K41CpOidtAt9G7EVkSpkz+
         VLWSfmf248r1ERrXdnfh8u7CL8xEBOOszQVR90YXtlN4VbO6hr5Fzfoeq2//1xL8/GVT
         yRDyzDKxurRKGKW/M/KgNYaH6iLR/xJD03JG6RK+mS+lCaa+CMJ7Ekg27DdI2+W5Ojfc
         ha+W7mWQu8cX9p8bA3Xdht3yNYcLx72DD27lv4szIFSaghe58KCIZz2wBQy1G80IUooB
         kA/g==
X-Gm-Message-State: AC+VfDy32lIdqLgQ6wUA0Z+baf9hfGzm72sFcfcgJpKvHDbQmcDCHbv9
        fMxDlgdfp+E4rMWXaRZ02fQZbw==
X-Google-Smtp-Source: ACHHUZ51bGDLCusY1s0Fw64gaWk1STV7958l6+QhX6BFFSIn00DTnVNGi67ePeXiI6vOFYMh9Cbh9Q==
X-Received: by 2002:a17:907:6eaa:b0:94f:81c:725e with SMTP id sh42-20020a1709076eaa00b0094f081c725emr11354436ejc.59.1683560898712;
        Mon, 08 May 2023 08:48:18 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:18 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.10 02/10] KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled
Date:   Mon,  8 May 2023 17:47:56 +0200
Message-Id: <20230508154804.30078-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ Upstream commit 01b31714bd90be2784f7145bf93b7f78f3d081e1 ]

There is no need to unload the MMU roots with TDP enabled when only
CR0.WP has changed -- the paging structures are still valid, only the
permission bitmap needs to be updated.

One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
implement kernel W^X.

The optimization brings a huge performance gain for this case as the
following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
grsecurity L1 VM shows (runtime in seconds, lower is better):

                       legacy     TDP    shadow
kvm-x86/next@d8708b     8.43s    9.45s    70.3s
             +patch     5.39s    5.63s    70.2s

For legacy MMU this is ~36% faster, for TDP MMU even ~40% faster. Also
TDP and legacy MMU now both have a similar runtime which vanishes the
need to disable TDP MMU for grsecurity.

Shadow MMU sees no measurable difference and is still slow, as expected.

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-3-minipli@grsecurity.net
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
- account for different kvm_init_mmu() arguments

 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7464ca3806fa..bd4d64c1bdf9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -868,6 +868,18 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
+	/*
+	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
+	 * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata needs
+	 * to be updated, e.g. so that emulating guest translations does the
+	 * right thing, but there's no need to unload the root as CR0.WP
+	 * doesn't affect SPTEs.
+	 */
+	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {
+		kvm_init_mmu(vcpu, false);
+		return 0;
+	}
+
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8F4E461D
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiCVShR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbiCVShP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:37:15 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C613DA7A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:47 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id o17-20020a92c691000000b002c2c04aebe7so9671511ilg.8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lGW+qCdwzMwtGGlVg3y2ePu73Q+JTzIqWyWeB9h5azY=;
        b=Q4h5St4bE4rOW155Wn3EO80R//PDfJqRJZaeS2M2PHHwYAb5zLlzGAVLgI+8KcM5ue
         vASo5TsEVfEDWKQe/g/0ORUybF8ztFa/MVDOQTAcoaq+H538ch/z0Yxpf5sxOtMhO/mj
         1NvKR21tAZKlMkbhpGRqDnpFi0D2OUA2wDtnJwJEzaeaHmJNhVRNzuckM5UlO7U51Ccc
         YITlUK4lhH8zzVZtT2cDQSglIjKg4ygFpPgqjdjQ65imS+SRIzOc+5z7sPxPB2ce2sdq
         735gTDGZlMN8ChNHrTDGsmrGpERbIKbMzkO6tB3B2eNNL7XLUe98wL3O7tuwW3BJpocx
         qdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lGW+qCdwzMwtGGlVg3y2ePu73Q+JTzIqWyWeB9h5azY=;
        b=ooXIwnblbDe4uxG66DcnUSER/2yn3Bz1P01bOp+f6uZan6cRy/wAwr2ZfhuzkposEY
         W9n6J/7Vr/Z0jnCbGzyBt+yCvJAv93MhetBJ2AEmrIbjXkUgrvWWYXnDDtYEou+o6KWK
         EDDKfs5v4vFB+FBvmonFDr1yiAyJT9OqJkPhrsMooWcoCnCRZMq9j9avT6vIqH8g4PVs
         bII2blV9nez09WOwvt6g838vsA83jL7SYPJwpnT8s0Tww3vYw3Ag+m92MVN8KZtctJyI
         j2PTrEhrzP5Mp/x7Ib6vP2VRGMFaeTwzZJbWZc5EnB/Nx5FjhZVVBrlUSed7WqhnV3W8
         uWlA==
X-Gm-Message-State: AOAM53143WJUHJZA4JLiiDRYxYj8MXwotdlfuIpIKYDqA3gJcgDZ65rE
        O/IY+FpdVIHYiqEuF2RLDOwMol9AxQg=
X-Google-Smtp-Source: ABdhPJxYqKXNgdI2Nn0wjD8p/zp8eXY/Rgm3sPEio6NQXm4jTPjyEFh8n9PKO7v2VGbk1KOuPT1TekwRGKE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:d486:0:b0:2c7:b549:ede7 with SMTP id
 p6-20020a92d486000000b002c7b549ede7mr12361089ilg.84.1647974147115; Tue, 22
 Mar 2022 11:35:47 -0700 (PDT)
Date:   Tue, 22 Mar 2022 18:35:38 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-4-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 3/3] KVM: arm64: Drop unneeded minor version check from
 PSCI v1.x handler
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already sanitize the guest's PSCI version when it is being written by
userspace, rejecting unsupported version numbers. Additionally, the
'minor' parameter to kvm_psci_1_x_call() is a constant known at compile
time for all callsites.

Though it is benign, the additional check against the
PSCI kvm_psci_1_x_call() is unnecessary and likely to be missed the next
time KVM raises its maximum PSCI version. Drop the check altogether and
rely on sanitization when the PSCI version is set by userspace.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d24ccc77500b..0b1b588f1f9b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -310,9 +310,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	unsigned long val;
 	int ret = 1;
 
-	if (minor > 1)
-		return -EINVAL;
-
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
-- 
2.35.1.894.gb6a874cedc-goog


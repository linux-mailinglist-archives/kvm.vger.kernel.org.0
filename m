Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9507C6D3B1F
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 02:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjDCAh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 20:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDCAh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 20:37:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3E29754
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 17:37:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y144-20020a253296000000b00b69ce0e6f2dso27249959yby.18
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 17:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482246;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7cbkKDYMk+VvT0sZcvXM38Hovglc7Ib8g99EWCrwY8c=;
        b=p3KcxgWW4f/5Zh38+7KQO1Ua2tlTD3GFa5IiommfGPumeywuZB56OGE2Sm3Gg8KtOs
         DVw+a6q3PbfhCGIEQXuk4/kJPHTfowjYfiBhjkwS+oRdkexXorj/RXOLxZrm1negFJS5
         EdIJVhXDbBL4qcFWsl6opQCMzf9c5NwrV81m7drR/EwA+pefSHG4EOaeZl3wrBwlXFgI
         ODu8X4C50h8/x3cbBIUHrnTLugQoUJWN+Qq6oTTYF4J2vM0EXdvaVyHEJGLtn8Jnn6zH
         uhuGuLFUlX9XUQNyarsZ0H7kpMXV3b+QXh+ce0U+PNz3+OJiT5g0Fv12vHnOHXbrmm7g
         H/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482246;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7cbkKDYMk+VvT0sZcvXM38Hovglc7Ib8g99EWCrwY8c=;
        b=qfU6c5QpSxl8E1Pzfvc/Dc48NSRbu+MEv0p3k8RTuytK+JzeZ7MpzLJiAVf1ZgAE2A
         qfmdEjnGOGyYAI2lHzi7O3bbFkEeS31TY9YaNxgaauG7Uu+6BiGx7c2l8Ir3/GDWA/9x
         NXxPjjhuZwtN/dxUj4/LLWy/uzO4xapRNHqZdRk0AWmzWutfuage9Ov7rYL2CZBnh2F6
         LHY/a6CK2wlaR6G+oVtADDFxMH41QPxB4BMWDsZ14gxOkzgmtsJnTLoAwOB8RPlma84S
         +LblRaabInvips6sjof/8/ahSagtjDECdj6JMpC5Vxgk8ahOyjjazjczAbIHqT7BoRwv
         O+Dw==
X-Gm-Message-State: AAQBX9ci8xziqvU6yxSRamM2LjkKtVrBt2xqW8B7OA5VT5Letg7QQc0K
        lb8jlOFB5Xw5kVLdBd15Cp3Nm6ycHq6G0QH415k21uUCcTRx7yONwMDNG5OzKFz3URbu7eJVgWY
        uZzo5hmw8LQAKpuXfP6zdTkEhkGEArCU13OJdzgolW8U35mFqZ7WD8dRiWlAuNag8FATlulY=
X-Google-Smtp-Source: AKy350ad/EeyiNhWuRLhO4Zw2rF2u3v9HNXTPPROAH2x+Andj0LdaNnvp3Qch0+QUfKMPzbj0KuRy0LBjqwLON7Emg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:722:b0:a09:314f:a3ef with
 SMTP id l2-20020a056902072200b00a09314fa3efmr22360648ybt.12.1680482245950;
 Sun, 02 Apr 2023 17:37:25 -0700 (PDT)
Date:   Mon,  3 Apr 2023 00:37:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-1-jingzhangos@google.com>
Subject: [PATCH v2 0/2] Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on a previous patch series which adds the
infrastructure to allow enabling writable from userspace for CPU ID register
easily. That patch series is at [1].

---

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com

---

Jing Zhang (2):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1

 arch/arm64/kvm/id_regs.c | 79 +++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 37 deletions(-)


base-commit: 921048c77a673221e27f4777a82661248465bad0
-- 
2.40.0.348.gf938b09366-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2DF6C9207
	for <lists+kvm@lfdr.de>; Sun, 26 Mar 2023 03:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCZBT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 21:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZBTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 21:19:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCB3AD0C
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a6-20020aa795a6000000b006262c174d64so2621102pfk.7
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 18:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793594;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4AdblhZEHm//uRFsWabYDVuAv1CTU23Gx2a5/zWd7Zk=;
        b=fuP6m9MTHjiXuIxZrs+rh6MP6B5q/xQ2kqA0PIoEZ2Kc1YPpTzP5b7EJnxJ3DSRVDw
         oVcvFgbAAe6sZh/yB+8/Z4WXOlyqNfZRD5yt9ZlfYVBhz3csTlZbTg2KWt+EG5V+A922
         G4bgNh8hJCgy3RWhR9YJS3yxCcn/HxqWyLBiWa0xIKW+FSs9epyTryCmfhYkgK3xWVUX
         9yXZR7ynRBuibZ3xRX0Y7208PLarQk2jiF7Y/BItI+43QnPgzHAG29hHauGmuQvcBfrF
         Et8CKAUS3PMl3vjiAfEIo9+Ar5b9YDUxPnn9Ajrm/RSJWy3v/2APdzpvkCrm478le8d0
         Qmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793594;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4AdblhZEHm//uRFsWabYDVuAv1CTU23Gx2a5/zWd7Zk=;
        b=GxvNb/xzBqRSbktcRpaPAkKUXnhiPMbhwEfWDhY3fEzM3b9bYCHt7jw1pwVOzfggkW
         0KHmlwevk/A3JnPU7TBXcP+tcpj6QQuOVBEKs0/ga8KgGjknY9wpo3UOB7aFfeXzS83X
         oEZgZuZPQ9hqzaIXSMu5vYkwTMTHfz8cE3SfIkXzBeSR8yDMfB0Itp3ghWPBC+W+5r7u
         Qu/ArlL9HsTlAIzAANPmdA+LxwTmJp+27RtecLuCvsjSwi0f4IAgI+799J9SMRxYqjS6
         IBQ/P5ldJDMzIyaZDfS0lbitnPGlyzX0pZYb5pYiUEi/VB2TY63mVGcby70/IqeYKtDp
         RBYg==
X-Gm-Message-State: AAQBX9fNQxz9EQwy/FG0CkwLc2pxrwEmITivX2gxn8NTB7EcsdtOFDdM
        fScB5KyfZ9WYHsQgl+neEMm6R7lAVnQfEF61kwar4crGHOx7hl5RbKvefmfMhlm/0eMJvCJD8Vw
        h4fERlB94/jr1TSPO2YTfRJtqXU4P7vDZrzZpLuNFUose1S5RCS0bmFVy1ti/HKaYAWsn6FY=
X-Google-Smtp-Source: AKy350bE3Sf1p2xK3QENi7/awHWmwhm0zLowXbSZSUe3G/TX+QbyZk6Fvzag/iBkznD4HhUrxqLGGHPAlupyq9aHLg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:4955:0:b0:50f:8d8d:60f0 with SMTP
 id y21-20020a634955000000b0050f8d8d60f0mr1867213pgk.10.1679793594164; Sat, 25
 Mar 2023 18:19:54 -0700 (PDT)
Date:   Sun, 26 Mar 2023 01:19:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-1-jingzhangos@google.com>
Subject: [PATCH v1 0/3] Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
        Ricardo Koller <ricarkol@google.com>,
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

This patch series is based on a previous patch series which adds the framework
to allow enabling writable from userspace for CPU ID register easily. That patch
series is at https://lore.kernel.org/all/20230317050637.766317-1-jingzhangos@google.com.

This patch series shows how easy to enable writable for feature fields with
dependencies and enable writable for a bunch of feature fields in an ID register.

---

Jing Zhang (3):
  KVM: arm64: Enable writable for BRPs and CTX_CMPs for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for remaining fields for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for all fields in ID_DFR0_EL1

 arch/arm64/kvm/id_regs.c | 45 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)


base-commit: 020e96f196a31bf5c5aa2549cdfc4a401a8cf478
-- 
2.40.0.348.gf938b09366-goog


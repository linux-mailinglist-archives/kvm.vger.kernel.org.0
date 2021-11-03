Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC924449FB
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhKCVCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKCVCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 17:02:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6C7C061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 13:59:24 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v63-20020a632f42000000b002cc65837088so2152085pgv.1
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BMHD8eN/O84RgpdWn1MOyBM5EFOHI83uTO00cZyWAQg=;
        b=bitU5eJ0Kmr+2sMFWR6KiGanApf+TfANTZ4UIqGCuZAu4cCIiFg11yEBfRTnxj1p9f
         qTJOohwMSHAqmldQfCNXUqcpsGOKlt9Ng/ZlKXmZ7iacrqxVrgEx6UcuNY1WCdea3U4Z
         yJNW7y4KeI8bhJBpDhCPwTfamRrs3FQdyULOP9bcG+ffz2ZMFEBSwQjb8t1rThTu5xU1
         7tTgBIw2pWaZ8Od+4mQtRbcMJqqosp8eNt2WLXCh3yDKYGNtiqnA0YrR3KFAWHCVSLO8
         yjr/DGC8uFS5IP22MFYLeaKRVgJs1bSG1WKijR4rG/VELDVOcEy79QE67RDlEAmdpxw2
         VBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BMHD8eN/O84RgpdWn1MOyBM5EFOHI83uTO00cZyWAQg=;
        b=ji/lCN5z4lAi9BMdK0AcLytFoEM6zWs6Dcw0fsoPlueocamXusTPbYnOGuACrginQy
         leVgZ9DlT7A68oUanrXxjUhoza2DxeE1NIAF4whtyQwDIwEjJBfU3hQ65It0pr5JZNZd
         LbGF2j1B/n4ez4aHPENt8bL3DY6jDkW6/BsMD2dxAxf+c/qoDM13YbspbG0pvIp6bcBJ
         +7HMi1iiFuzkwj6yUe+UbyX1SZ0jddJnqJwI8Gn/Mng9+f0OdaVMx3iLT5tnEVthEc0E
         vvBgJvivcUEnW0XUo4tOKFKPGNqt/+L85bnoZnwwJ7U6a1S7Ap7WZ8spKewy7dVTHNte
         /cVA==
X-Gm-Message-State: AOAM532lVfCeVZyoqBPiBgtb0tXBWZlUnu3TdVX5Hr7qhRFTZjIVrtFT
        uZw3EDSFqgxvFmAPJETurJhWIAYfvpFX
X-Google-Smtp-Source: ABdhPJycohYurV0YgV4j0h4Pa3cBGqvA0DposxHWAUB3TD0QVjBIO//mFQ1hqfqBPAJA+AQe+SHpkIKVD89O
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:26cd:b0:493:ff3f:8083 with SMTP
 id p13-20020a056a0026cd00b00493ff3f8083mr1378391pfw.19.1635973164192; Wed, 03
 Nov 2021 13:59:24 -0700 (PDT)
Date:   Wed,  3 Nov 2021 20:59:09 +0000
Message-Id: <20211103205911.1253463-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v3 0/2] Add wrapper to read GPR of INVPCID, INVVPID, and INVEPT
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

v3 is similar to v2 except that the commit message of "PATCH v3 2/2" is now
clearer and detailed.

VMX code to handle INVPCID, INVVPID, and INVEPT read the same GPR index
in VM exit info. This patch series improves that handling by adding a
common wrapper function for them.

Patch 2 makes a sublte change in INVPCID type check. Unlike INVVPID and
INVEPT, INVPCID is not explicitly documented to check the type before
reading the operand from memory. So, this patch moves INVPCID type check
to the common switch statement instead of VMX and SVM validating it
individually.

Changes in v3:
- Patch 2's commit message is more detailed now.

Changes in v2:
- Keeping the register read visible in the functions.
- Removed INVPCID type check hardcoding and moved error condition to common 
  function.

[v2] https://lore.kernel.org/lkml/20211103183232.1213761-1-vipinsh@google.com/
[v1] https://lore.kernel.org/lkml/20211011194615.2955791-1-vipinsh@google.com/

Vipin Sharma (2):
  KVM: VMX: Add a wrapper to read index of GPR for INVPCID, INVVPID, and
    INVEPT
  KVM: Move INVPCID type check from vmx and svm to the common
    kvm_handle_invpcid()

 arch/x86/kvm/svm/svm.c    |  5 -----
 arch/x86/kvm/vmx/nested.c | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c    |  9 +++------
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 arch/x86/kvm/x86.c        |  3 ++-
 5 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog


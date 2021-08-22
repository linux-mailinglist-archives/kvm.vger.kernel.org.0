Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C833F4019
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhHVOpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhHVOpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:45:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BEAA61246;
        Sun, 22 Aug 2021 14:45:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mHoiZ-006VES-9H; Sun, 22 Aug 2021 15:44:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH 0/3] target/arm: Reduced-IPA space and highmem=off fixes
Date:   Sun, 22 Aug 2021 15:44:38 +0100
Message-Id: <20210822144441.1290891-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the availability of a fruity range of arm64 systems, it becomes
obvious that QEMU doesn't deal very well with limited IPA ranges when
used as a front-end for KVM.

This short series aims at making usable on such systems:
- the first patch makes the creation of a scratch VM IPA-limit aware
- the second one actually removes the highmem devices from the
computed IPA range when highmem=off
- the last one addresses an imprecision in the documentation for the
highmem option

This has been tested on an M1-based Mac-mini running Linux v5.14-rc6.

Marc Zyngier (3):
  hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE when creating
    scratch VM
  hw/arm/virt: Honor highmem setting when computing highest_gpa
  docs/system/arm/virt: Fix documentation for the 'highmem' option

 docs/system/arm/virt.rst |  6 +++---
 hw/arm/virt.c            | 10 +++++++---
 target/arm/kvm.c         |  7 ++++++-
 3 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.30.2


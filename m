Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326D31F365B
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 10:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgFIIto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 04:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgFIItl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 04:49:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B054207C3;
        Tue,  9 Jun 2020 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591692581;
        bh=DTLwx+4FGcD1qdI1v5kAz9K25967wcxylJEAbdulMwk=;
        h=From:To:Cc:Subject:Date:From;
        b=ytgOPaxFBmwQdjr6FKBkwvu6yN10vCR0Bl4hXjVrLMhediqGY6bm+xtmxvKssX6yG
         vgYgCLA1k/s5X94SWV05hls/Gwxob2+qr0O8bTxRogYBzetvlxU54RihVoy56OoEoF
         1KLUpYDyXrc3KCdw6rwhEh5rFK9RbnH4RWcCzOAc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiZwx-001PEa-J5; Tue, 09 Jun 2020 09:49:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/2] KVM: arm64: Additional 32bit fixes
Date:   Tue,  9 Jun 2020 09:49:19 +0100
Message-Id: <20200609084921.1448445-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's a couple of patches that address the issues that James
mentionned in [1], affecting 32bit guests.

I lack a BE-capable host to properly test the first patch, but it is
obviously correct (ha! ;-).

[1] https://lore.kernel.org/r/20200526161834.29165-1-james.morse@arm.com

Marc Zyngier (2):
  KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
  KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception

 arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
 arch/arm64/kvm/aarch32.c          | 28 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

-- 
2.26.2


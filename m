Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2319962A
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgCaMRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgCaMRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:17:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5465220838;
        Tue, 31 Mar 2020 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657038;
        bh=/G1FsF/xAq6LA4+vlGRopU41c40Jo/k3MSVldBBWBqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ulh7YDCfhdwEa+BcT3Nbcx2jbGR8r5bsa20eUBd7s6q7NAnd+NKS7LkitoHxHlQbj
         JfLaHFQwUyevjcub3cZQxsOZu1ya9bXqOG7i51B9aMRt5LIY+MntyfCPpMaBwBk6DV
         15uTOPRrG4AYrUGa97pvXRw4zgt97pOIoXitQTTs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpU-00HBlI-Jn; Tue, 31 Mar 2020 13:17:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 08/15] MAINTAINERS: RIP KVM/arm
Date:   Tue, 31 Mar 2020 13:16:38 +0100
Message-Id: <20200331121645.388250-9-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de, linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the KVM/arm entries from the MAINTAINERS file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6158a143a13e..e84a94e5a336 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9164,7 +9164,7 @@ F:	virt/kvm/*
 F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
 
-KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
+KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
 R:	Julien Thierry <julien.thierry.kdev@gmail.com>
@@ -9173,9 +9173,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 S:	Maintained
-F:	arch/arm/include/uapi/asm/kvm*
-F:	arch/arm/include/asm/kvm*
-F:	arch/arm/kvm/
 F:	arch/arm64/include/uapi/asm/kvm*
 F:	arch/arm64/include/asm/kvm*
 F:	arch/arm64/kvm/
-- 
2.25.0


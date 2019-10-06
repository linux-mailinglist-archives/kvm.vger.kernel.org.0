Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A868CD160
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfJFKq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 06:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfJFKq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Oct 2019 06:46:58 -0400
Received: from localhost.localdomain (82-132-217-85.dab.02.net [82.132.217.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D232084D;
        Sun,  6 Oct 2019 10:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570358818;
        bh=5F1vOMzribkWPxS/i0/IDvYHGJESKxSllK/Tnob7QXY=;
        h=From:To:Cc:Subject:Date:From;
        b=xQlAvOWUndDfG+W9cFUCIMRr1I1Cp8uID0IDvLC6gmS8Y6pIi8kJYXLoYh7HYL3cD
         LC8H8dKP2tMYEGIMPAwrR/ssMZxpyd0ctFBtf+TbFXMYaCjl6nDMp1RD77NchJx70P
         V78sQp7xBgsYCEjDFcg62KQhDwSESd5erSE+aY44=
From:   maz@kernel.org
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] KVM: arm64: Assorted PMU emulation fixes
Date:   Sun,  6 Oct 2019 11:46:33 +0100
Message-Id: <20191006104636.11194-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

I recently came across a number of PMU emulation bugs, all which can
result in unexpected behaviours in an unsuspecting guest. The first
two patches already have been discussed on the list, but I'm including
them here as part of a slightly longer series. The last patch fixes an
issue that has been here from day one, where we confuse architectural
overflow of a counter and perf sampling period.

If nobody disagrees, I'll send them upstream shortly.

Marc Zyngier (3):
  KVM: arm64: pmu: Fix cycle counter truncation
  arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
  KVM: arm64: pmu: Reset sample period on overflow handling

 arch/arm64/kvm/sys_regs.c |  4 ++++
 virt/kvm/arm/pmu.c        | 34 ++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

-- 
2.20.1


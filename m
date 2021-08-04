Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974393E0124
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhHDM04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235639AbhHDM0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 08:26:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FED760E8D;
        Wed,  4 Aug 2021 12:26:43 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mBFyr-002urw-Ht; Wed, 04 Aug 2021 13:26:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     Quentin Perret <qperret@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Prevent kmemleak from accessing HYP data
Date:   Wed,  4 Aug 2021 13:26:37 +0100
Message-Id: <162807998838.4077325.1915601762078271589.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210802123830.2195174-1-maz@kernel.org>
References: <20210802123830.2195174-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org, kvm@vger.kernel.org, qperret@google.com, catalin.marinas@arm.com, suzuki.poulose@arm.com, will@kernel.org, kernel-team@android.com, james.morse@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Aug 2021 13:38:28 +0100, Marc Zyngier wrote:
> This is a rework of the patch previously posted at [1].
> 
> The gist of the problem is that kmemleak can legitimately access data
> that has been removed from the kernel view, for two reasons:
> 
> (1) .hyp.rodata is lumped together with the BSS
> (2) there is no separation of the HYP BSS from the kernel BSS
> 
> [...]

Applied to next, thanks!

[1/2] arm64: Move .hyp.rodata outside of the _sdata.._edata range
      commit: eb48d154cd0dade56a0e244f0cfa198ea2925ed3
[2/2] KVM: arm64: Unregister HYP sections from kmemleak in protected mode
      commit: 47e6223c841e029bfc23c3ce594dac5525cebaf8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



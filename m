Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385D64307BF
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241737AbhJQKNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 06:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234709AbhJQKNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 06:13:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64660603E7;
        Sun, 17 Oct 2021 10:11:37 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mc38h-00HJ9I-1p; Sun, 17 Oct 2021 11:11:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 0/5] KVM: arm64: Assorted vgic-v3 fixes
Date:   Sun, 17 Oct 2021 11:11:32 +0100
Message-Id: <163446547856.1611056.6126339357800795046.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010150910.2911495-1-maz@kernel.org>
References: <20211010150910.2911495-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, eric.auger@redhat.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 10 Oct 2021 16:09:05 +0100, Marc Zyngier wrote:
> Here's a bunch of vgic-v3 fixes I have been sitting on for some
> time. None of them are critical, though some are rather entertaining.
> 
> The first one is a leftover from the initial Apple-M1 enablement,
> which doesn't advertise the GIC support via ID_AA64PFR0_EL1 (which is
> expected, as it only has half a GIC...). We address it by forcefully
> advertising the feature if the guest has a GICv3.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
      commit: 562e530fd7707aad7fed953692d1835612238966
[2/5] KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
      commit: df652bcf1136db7f16e486a204ba4b4fc4181759
[3/5] KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when possible
      commit: 0924729b21bffdd0e13f29ea6256d299fc807cff
[4/5] KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
      commit: f87ab682722299cddf8cf5f7bc17053d70300ee0
[5/5] KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the pseudocode
      commit: 9d449c71bd8f74282e84213c8f0b8328293ab0a7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



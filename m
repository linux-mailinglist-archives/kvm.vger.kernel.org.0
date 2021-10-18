Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1247C4323F6
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhJRQjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 12:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231896AbhJRQjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 12:39:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E8260E0C;
        Mon, 18 Oct 2021 16:37:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcVdM-0001We-Pq; Mon, 18 Oct 2021 17:37:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, qperret@google.com, mark.rutland@arm.com,
        tabba@google.com, pbonzini@redhat.com, will@kernel.org,
        suzuki.poulose@arm.com, oupton@google.com, james.morse@arm.com,
        drjones@redhat.com, kernel-team@android.com
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Date:   Mon, 18 Oct 2021 17:37:02 +0100
Message-Id: <163457498602.1692816.17093273443605618000.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com> <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alexandru.elisei@arm.com, qperret@google.com, mark.rutland@arm.com, tabba@google.com, pbonzini@redhat.com, will@kernel.org, suzuki.poulose@arm.com, oupton@google.com, james.morse@arm.com, drjones@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Oct 2021 13:03:35 +0100, Marc Zyngier wrote:
> This is an update on Fuad's series[1].
> 
> Instead of going going back and forth over a series that has seen a
> fair few versions, I've opted for simply writing a set of fixes on
> top, hopefully greatly simplifying the handling of most registers, and
> moving things around to suit my own taste (just because I can).
> 
> [...]

Applied to next, thanks!

[12/22] KVM: arm64: Fix early exit ptrauth handling
        commit: 8a049862c38f0c78b0e01ab5d36db1bffc832675
[13/22] KVM: arm64: pkvm: Use a single function to expose all id-regs
        commit: ce75916749b8cb5ec795f1157a5c426f6765a48c
[14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
        commit: 8ffb41888334c1247bd9b4d6ff6c092a90e8d0b8
[15/22] KVM: arm64: pkvm: Drop AArch32-specific registers
        commit: 3c90cb15e2e66bcc526d25133747b2af747f6cd8
[16/22] KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
        commit: f3d5ccabab20c1be5838831f460f320a12e5e2c9
[17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
        commit: cbca19738472be8156d854663ed724b01255c932
[18/22] KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
        commit: 271b7286058da636ab6f5f47722e098ca3a0478b
[19/22] KVM: arm64: pkvm: Consolidate include files
        commit: 3061725d162cad0589b012fc6413c9dd0da8f02a
[20/22] KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
        commit: 746bdeadc53b0d58fddea6442591f5ec3eeabe7d
[21/22] KVM: arm64: pkvm: Pass vpcu instead of kvm to kvm_get_exit_handler_array()
        commit: 0c7639cc838263b6e38b3af76755d574f15cdf41
[22/22] KVM: arm64: pkvm: Give priority to standard traps over pvm handling
        commit: 07305590114af81817148d181f1eb0af294e40d6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



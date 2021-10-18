Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D4E4323F8
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhJRQmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 12:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhJRQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 12:42:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715726108E;
        Mon, 18 Oct 2021 16:40:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcVg7-0001a3-9H; Mon, 18 Oct 2021 17:39:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Fuad Tabba <tabba@google.com>
Cc:     alexandru.elisei@arm.com, will@kernel.org, oupton@google.com,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        christoffer.dall@arm.com, suzuki.poulose@arm.com,
        james.morse@arm.com, kvm@vger.kernel.org, drjones@redhat.com,
        qperret@google.com, mark.rutland@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH v8 00/11] KVM: arm64: Fixed features for protected VMs
Date:   Mon, 18 Oct 2021 17:39:56 +0100
Message-Id: <163457515280.1693002.15246533081868685262.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
References: <20211010145636.1950948-1-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, tabba@google.com, alexandru.elisei@arm.com, will@kernel.org, oupton@google.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, kvm@vger.kernel.org, drjones@redhat.com, qperret@google.com, mark.rutland@arm.com, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 10 Oct 2021 15:56:25 +0100, Fuad Tabba wrote:
> Changes since v7 [1]:
> - Fix build warnings
> 
> This patch series adds support for restricting CPU features for protected VMs
> in KVM (pKVM). For more background, please refer to the previous series [2].
> 
> This series is based on 5.15-rc4. You can find the applied series here [3].
> 
> [...]

Applied to next, thanks!

[01/11] KVM: arm64: Move __get_fault_info() and co into their own include file
        commit: 7dd9b5a157485ae8c48f76f087b1867ace016613
[02/11] KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
        commit: cc1e6fdfa92b82902883b70dafa729d3bd427b80
[03/11] KVM: arm64: Move early handlers to per-EC handlers
        commit: 8fb2046180a0ad347f2e5bcae760dca67e65aa73
[04/11] KVM: arm64: Pass struct kvm to per-EC handlers
        commit: 3b1a690eda0dc1891e8fc93991b122bff6fabf8c
[05/11] KVM: arm64: Add missing field descriptor for MDCR_EL2
        commit: 53868390778270f2890621f4498a53587719a3ff
[06/11] KVM: arm64: Simplify masking out MTE in feature id reg
        commit: 16dd1fbb12f72effcd3539561c2a94aed3ab6581
[07/11] KVM: arm64: Add handlers for protected VM System Registers
        commit: 6c30bfb18d0b7d09593f204c936493cfcd153956
[08/11] KVM: arm64: Initialize trap registers for protected VMs
        commit: 2a0c343386ae1a6826e1b9d751bfc14f4711c2de
[09/11] KVM: arm64: Move sanitized copies of CPU features
        commit: 72e1be120eaaf82a58c81fcf173cdb1d7a5dcfbb
[10/11] KVM: arm64: Trap access to pVM restricted features
        commit: 1423afcb411780c7a6a68f801fdcfb6920ad6f06
[11/11] KVM: arm64: Handle protected guests at 32 bits
        commit: 5f39efc42052b042c4d7ba6fd77934e8de43e10c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



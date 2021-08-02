Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD23DD74A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhHBNja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhHBNj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:39:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B5D60F6D;
        Mon,  2 Aug 2021 13:39:19 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mAYA1-002SiR-T6; Mon, 02 Aug 2021 14:39:18 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 0/4] kvm-arm64: Fix PMU reset values (and more)
Date:   Mon,  2 Aug 2021 14:39:10 +0100
Message-Id: <162791148977.3441299.3278138161976148684.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719123902.1493805-1-maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, drjones@redhat.com, robin.murphy@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, linux@arm.linux.org.uk, kernel-team@android.com, suzuki.poulose@arm.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Jul 2021 13:38:58 +0100, Marc Zyngier wrote:
> This is the second version of the series initially posted at [1].
> 
> * From v1:
>   - Simplified masking in patch #1
>   - Added a patch dropping PMSWINC_EL0 as a shadow register, though it
>     is still advertised to userspace for the purpose of backward
>     compatibility of VM save/restore
>   - Collected ABs/RBs, with thanks
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
      commit: 0ab410a93d627ae73136d1a52c096262360b7992
[2/4] KVM: arm64: Drop unnecessary masking of PMU registers
      commit: f5eff40058a856c23c5ec2f31756f107a2b1ef84
[3/4] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
      commit: ca4f202d08ba7f24cc97dce14c6d20ec7a679135
[4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
      commit: 7a3ba3095a32f9c4ec8f30d680fea5150e12c3f3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



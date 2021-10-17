Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD04307D7
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 12:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhJQKXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 06:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhJQKW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 06:22:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26BE861245;
        Sun, 17 Oct 2021 10:20:47 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mc3HY-00HJDU-TG; Sun, 17 Oct 2021 11:20:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix reporting of endianess when the access originates at EL0
Date:   Sun, 17 Oct 2021 11:20:41 +0100
Message-Id: <163446603338.1611630.15916963665127612942.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211012112312.1247467-1-maz@kernel.org>
References: <20211012112312.1247467-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, tabba@google.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Oct 2021 12:23:12 +0100, Marc Zyngier wrote:
> We currently check SCTLR_EL1.EE when computing the address of
> a faulting guest access. However, the fault could have occured at
> EL0, in which case the right bit to check would be SCTLR_EL1.E0E.
> 
> This is pretty unlikely to cause any issue in practice: You'd have
> to have a guest with a LE EL1 and a BE EL0 (or the other way around),
> and have mapped a device into the EL0 page tables.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix reporting of endianess when the access originates at EL0
      commit: 69adec18e94ff3ca20447916a3bd23ab1d06b878

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE693F177B
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 12:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbhHSKsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 06:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238318AbhHSKsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 06:48:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2194461154;
        Thu, 19 Aug 2021 10:47:32 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mGfa6-005x1C-0z; Thu, 19 Aug 2021 11:47:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        kvmarm@lists.cs.columbia.edu
Cc:     jingzhangos@google.com, pshier@google.com, oupton@google.com,
        james.morse@arm.com, rananta@google.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, drjones@redhat.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
Date:   Thu, 19 Aug 2021 11:47:24 +0100
Message-Id: <162937003857.598624.13282260461070232329.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818213205.598471-1-ricarkol@google.com>
References: <20210818213205.598471-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, ricarkol@google.com, kvmarm@lists.cs.columbia.edu, jingzhangos@google.com, pshier@google.com, oupton@google.com, james.morse@arm.com, rananta@google.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, drjones@redhat.com, reijiw@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Aug 2021 14:32:05 -0700, Ricardo Koller wrote:
> vgic_get_irq(intid) is used all over the vgic code in order to get a
> reference to a struct irq. It warns whenever intid is not a valid number
> (like when it's a reserved IRQ number). The issue is that this warning
> can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> 
> Drop the WARN call from vgic_get_irq.

Applied to next, thanks!

[1/1] KVM: arm64: vgic: drop WARN from vgic_get_irq
      commit: b9a51949cebcd57bfb9385d9da62ace52564898c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



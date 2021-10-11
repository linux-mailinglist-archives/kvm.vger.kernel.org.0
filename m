Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74805428984
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 11:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhJKJUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 05:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhJKJUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 05:20:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BAB960EB6;
        Mon, 11 Oct 2021 09:18:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mZrRb-00FyGH-Lk; Mon, 11 Oct 2021 10:18:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        David Brazdil <dbrazdil@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow KVM to be disabled from the command line
Date:   Mon, 11 Oct 2021 10:18:00 +0100
Message-Id: <163394386541.587062.2414212384225711646.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001170553.3062988-1-maz@kernel.org>
References: <20211001170553.3062988-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alexandru.elisei@arm.com, will@kernel.org, dbrazdil@google.com, suzuki.poulose@arm.com, kernel-team@android.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Oct 2021 18:05:53 +0100, Marc Zyngier wrote:
> Although KVM can be compiled out of the kernel, it cannot be disabled
> at runtime. Allow this possibility by introducing a new mode that
> will prevent KVM from initialising.
> 
> This is useful in the (limited) circumstances where you don't want
> KVM to be available (what is wrong with you?), or when you want
> to install another hypervisor instead (good luck with that).

Applied to next, thanks!

[1/1] KVM: arm64: Allow KVM to be disabled from the command line
      commit: b6a68b97af23cc75781bed38221ce73144ac2e39

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



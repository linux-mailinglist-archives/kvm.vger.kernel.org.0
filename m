Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029533392A7
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhCLQE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231636AbhCLQEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:04:21 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339AC64FFE;
        Fri, 12 Mar 2021 16:04:21 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lKkGx-001GFM-15; Fri, 12 Mar 2021 16:04:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: Assorted IPA size fixes
Date:   Fri, 12 Mar 2021 16:04:12 +0000
Message-Id: <161556504005.3921077.277089202831479241.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311100016.3830038-1-maz@kernel.org>
References: <20210311100016.3830038-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, maz@kernel.org, drjones@redhat.com, suzuki.poulose@arm.com, james.morse@arm.com, will@kernel.org, eric.auger@redhat.com, julien.thierry.kdev@gmail.com, kernel-team@android.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Mar 2021 10:00:14 +0000, Marc Zyngier wrote:
> This is a rework of an initial patch posted a couple of days back[1]
> 
> While working on enabling KVM on "reduced IPA size" systems, I realise
> we have a couple of issues, some of while do impact userspace.
> 
> The first issue is that we accept the creation of a "default IPA size"
> VM (40 bits) even when the HW doesn't support it. Not good.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Reject VM creation when the default IPA size is unsupported
      commit: 7d717558dd5ef10d28866750d5c24ff892ea3778
[2/2] KVM: arm64: Fix exclusive limit for IPA size
      commit: 262b003d059c6671601a19057e9fe1a5e7f23722

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



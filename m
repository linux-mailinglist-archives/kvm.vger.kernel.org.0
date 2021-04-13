Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14735E0EC
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbhDMOGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237811AbhDMOGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:06:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1C261242;
        Tue, 13 Apr 2021 14:05:47 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lWJfl-007FMf-M4; Tue, 13 Apr 2021 15:05:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     james.morse@arm.com, eric.auger.pro@gmail.com,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        alexandru.elisei@arm.com, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>, suzuki.poulose@arm.com
Cc:     gshan@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
Date:   Tue, 13 Apr 2021 15:05:41 +0100
Message-Id: <161832273337.3709196.17485368965759835272.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412150034.29185-1-eric.auger@redhat.com>
References: <20210412150034.29185-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, eric.auger.pro@gmail.com, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, alexandru.elisei@arm.com, kvm@vger.kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, gshan@redhat.com, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Apr 2021 17:00:34 +0200, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
> 
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.

Applied to kvm-arm64/vgic-5.13, thanks!

[1/1] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
      commit: 94ac0835391efc1a30feda6fc908913ec012951e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



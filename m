Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2524831B
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 12:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHRKe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 06:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgHRKe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 06:34:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5842B2075E;
        Tue, 18 Aug 2020 10:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597746865;
        bh=4RQGb2A7yfUC/cTbElTMskDSYGMeQDBt6Q0bd2Jz0tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxVcWajoVivmrZvy6C50qbHAiEH2qP1eq0Sm3P+CT2LbvmV0bs+lT1eHK5bIJaKKP
         y8rE8XEqQEhXCcaM/um0atmR2cFUleRSuOnG3x8SLCrKti3aBLHGtcz1DK7Sp7Iinh
         a+mNp7UzQEdsunWDcLTp4z04FJmUb9vY4scDFy8U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7ywh-003rus-OC; Tue, 18 Aug 2020 11:34:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
Date:   Tue, 18 Aug 2020 11:34:20 +0100
Message-Id: <159774684758.2661110.9212490740883121538.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200811102725.7121-1-will@kernel.org>
References: <20200811102725.7121-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com, pbonzini@redhat.com, james.morse@arm.com, sean.j.christopherson@intel.com, tsbogend@alpha.franken.de, paulus@ozlabs.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Aug 2020 11:27:23 +0100, Will Deacon wrote:
> While stress-testing my arm64 stage-2 page-table rewrite [1], I ran into
> a sleeping while atomic BUG() during OOM that I can reproduce with
> mainline.
> 
> The problem is that the arm64 page-table code periodically calls
> cond_resched_lock() when unmapping the stage-2 page-tables, but in the
> case of OOM, this occurs in atomic context.
> 
> [...]

Applied to kvm-arm64/pt-rework-base, thanks!

[1/2] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
      commit: 462a296d8a2004063ab3c6b4df07d6f165786734
[2/2] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
      commit: 78dcf128f9bb3a6a3950a21cf097cdc48cf3f505

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



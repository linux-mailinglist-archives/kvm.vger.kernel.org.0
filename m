Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC67B332DB9
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 19:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhCISBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 13:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhCISBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 13:01:23 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BBB65228;
        Tue,  9 Mar 2021 18:01:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lJgfY-000blB-TY; Tue, 09 Mar 2021 18:01:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>
Cc:     kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
Date:   Tue,  9 Mar 2021 18:01:05 +0000
Message-Id: <161531284779.3772144.1323992258111335863.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303164505.68492-1-maz@kernel.org>
References: <20210303164505.68492-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org, kernel-team@android.com, catalin.marinas@arm.com, james.morse@arm.com, mark.rutland@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Mar 2021 16:45:05 +0000, Marc Zyngier wrote:
> It recently became apparent that the ARMv8 architecture has interesting
> rules regarding attributes being used when fetching instructions
> if the MMU is off at Stage-1.
> 
> In this situation, the CPU is allowed to fetch from the PoC and
> allocate into the I-cache (unless the memory is mapped with
> the XN attribute at Stage-2).
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
      commit: 01dc9262ff5797b675c32c0c6bc682777d23de05

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E42E20385A
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 15:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgFVNlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 09:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgFVNle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 09:41:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9894620679;
        Mon, 22 Jun 2020 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592833294;
        bh=fkXQsaOSzx4yB37RUmOsulqQkA6onP56sqW6f4bDFLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnP+HYGe6cMUYj1jWv5mhPgK2qpJKRJ8rreJIKC7anLxC9JfhBKu2TXOan5mRHkxq
         7VYB/drLVp103R0n5XR02uuBUzDm9n8mmD8RoosF769dYeoOYR4ZN0qpQ2AdM+pQSM
         7IwmSQrtbbvtKR2UEdh1D8jxvHbOyxviqTru1pCI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnMhZ-005KkL-2j; Mon, 22 Jun 2020 14:41:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH] arm64: kvm: Annotate hyp NMI-related functions as __always_inline
Date:   Mon, 22 Jun 2020 14:41:26 +0100
Message-Id: <159283326373.239821.1231019851371158870.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618171254.1596055-1-alexandru.elisei@arm.com>
References: <20200618171254.1596055-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jun 2020 18:12:54 +0100, Alexandru Elisei wrote:
> The "inline" keyword is a hint for the compiler to inline a function.  The
> functions system_uses_irq_prio_masking() and gic_write_pmr() are used by
> the code running at EL2 on a non-VHE system, so mark them as
> __always_inline to make sure they'll always be part of the .hyp.text
> section.
> 
> This fixes the following splat when trying to run a VM:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Annotate hyp NMI-related functions as __always_inline
      commit: 7733306bd593c737c63110175da6c35b4b8bb32c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



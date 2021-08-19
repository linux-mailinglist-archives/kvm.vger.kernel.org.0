Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012243F1744
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 12:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhHSK27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 06:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237889AbhHSK27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 06:28:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1531B60ED3;
        Thu, 19 Aug 2021 10:28:23 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mGfHZ-005wq0-4o; Thu, 19 Aug 2021 11:28:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Guangyu Shi <guangyus@google.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: Use generic guest entry infrastructure
Date:   Thu, 19 Aug 2021 11:28:16 +0100
Message-Id: <162936887458.598180.10185839299725357336.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
References: <20210802192809.1851010-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, peterz@infradead.org, luto@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com, shakeelb@google.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, james.morse@arm.com, guangyus@google.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, pshier@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Aug 2021 19:28:06 +0000, Oliver Upton wrote:
> The arm64 kernel doesn't yet support the full generic entry
> infrastructure. That being said, KVM/arm64 doesn't properly handle
> TIF_NOTIFY_RESUME and could pick this up by switching to the generic
> guest entry infrasturture.
> 
> Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
> exits to userspace.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Record number of signal exits as a vCPU stat
      commit: fe5161d2c39b8c2801f0e786631460c6e8a1cae4
[2/3] entry: KVM: Allow use of generic KVM entry w/o full generic support
      commit: e1c6b9e1669e44fb7f9688e34e460b759e3b9187
[3/3] KVM: arm64: Use generic KVM xfer to guest work function
      commit: 6caa5812e2d126a0aa8a17816c1ba6f0a0c2b309

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



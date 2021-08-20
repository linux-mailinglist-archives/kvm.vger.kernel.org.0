Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE903F2A26
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 12:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhHTKfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 06:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhHTKfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 06:35:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8481861106;
        Fri, 20 Aug 2021 10:34:26 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mH1qy-006AHg-Bb; Fri, 20 Aug 2021 11:34:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Fuad Tabba <tabba@google.com>
Cc:     oupton@google.com, james.morse@arm.com, drjones@redhat.com,
        mark.rutland@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, suzuki.poulose@arm.com, will@kernel.org,
        pbonzini@redhat.com, christoffer.dall@arm.com, qperret@google.com
Subject: Re: [PATCH v4 00/15] KVM: arm64: Fixed features for protected VMs
Date:   Fri, 20 Aug 2021 11:34:20 +0100
Message-Id: <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
References: <20210817081134.2918285-1-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, tabba@google.com, oupton@google.com, james.morse@arm.com, drjones@redhat.com, mark.rutland@arm.com, alexandru.elisei@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, suzuki.poulose@arm.com, will@kernel.org, pbonzini@redhat.com, christoffer.dall@arm.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> Changes since v3 [1]:
> - Redid calculating restricted values of feature register fields, ensuring that
>   the code distinguishes between unsigned and (potentially in the future)
>   signed fields (Will)
> - Refactoring and fixes (Drew, Will)
> - More documentation and comments (Oliver, Will)
> - Dropped patch "Restrict protected VM capabilities", since it should come with
>   or after the user ABI series for pKVM (Will)
> - Carried Will's acks
> 
> [...]

I've taken the first 10 patches of this series in order to
progress it. I also stashed a fixlet on top to address the
tracepoint issue.

Hopefully we can resolve the rest of the issues quickly.

[01/15] KVM: arm64: placeholder to check if VM is protected
        commit: 2ea7f655800b00b109951f22539fe2025add210b
[02/15] KVM: arm64: Remove trailing whitespace in comment
        commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
[03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
        commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
[04/15] KVM: arm64: Fix names of config register fields
        commit: dabb1667d8573302712a75530cccfee8f3ffff84
[05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
        commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
[06/15] KVM: arm64: Restore mdcr_el2 from vcpu
        commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
[07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
        commit: 12849badc6d2456f15f8f2c93037628d5176810b
[08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
        commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
[09/15] KVM: arm64: Add feature register flag definitions
        commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
[10/15] KVM: arm64: Add config register bit definitions
        commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BAAA0883
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfH1Rcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1Rcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:32:39 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F3222CF8;
        Wed, 28 Aug 2019 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567013558;
        bh=g4OCrTwVa9bGHj9tnxdp3jF6CcqJ8f1XiF9bSopoU3g=;
        h=Date:From:To:Cc:Subject:From;
        b=a3rf4aOlbouRot3H7YWNOPjdMdjcSi4kuaOwn9XEDNdNwloLChRW0NRPbuHXR9PXS
         C6MgP0i2QWJTMl2Pk08Rc1N/ScAAM4oPGmcweVwXtZ/63yqisTC31BDdQGAwJFmL4V
         GPPOqjrUiOAnRHK07SzjdAwi+63PljkdrwKkNN/A=
Date:   Wed, 28 Aug 2019 18:32:33 +0100
From:   Will Deacon <will@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     catalin.marinas@arm.com, marc.zyngier@arm.com, pbonzini@redhat.com,
        rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] arm64: Fixes for -rc7
Message-ID: <20190828173233.zqwm5nd4p5xa4jxi@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

Hot on the heels of our last set of fixes are a few more for -rc7. Two
of them are fixing issues with our virtual interrupt controller
implementation in KVM/arm, while the other is a longstanding but
straightforward kallsyms fix which was been acked by Masami and resolves
an initialisation failure in kprobes observed on arm64.

Please pull, thanks.

Will

--->8

The following changes since commit b6143d10d23ebb4a77af311e8b8b7f019d0163e6:

  arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side (2019-08-16 17:40:03 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 82e40f558de566fdee214bec68096bbd5e64a6a4:

  KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI (2019-08-28 11:21:42 +0100)

----------------------------------------------------------------
arm64 fixes for -rc7

- Fix GICv2 emulation bug (KVM)

- Fix deadlock in virtual GIC interrupt injection code (KVM)

- Fix kprobes blacklist init failure due to broken kallsyms lookup

----------------------------------------------------------------
Heyi Guo (1):
      KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is long

Marc Zyngier (2):
      kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving the first symbol
      KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI

 kernel/kallsyms.c             |  6 ++++--
 virt/kvm/arm/vgic/vgic-mmio.c | 18 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |  5 ++++-
 virt/kvm/arm/vgic/vgic-v3.c   |  5 ++++-
 virt/kvm/arm/vgic/vgic.c      |  7 +++++++
 5 files changed, 37 insertions(+), 4 deletions(-)

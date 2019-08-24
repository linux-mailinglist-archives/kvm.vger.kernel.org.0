Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A639BD93
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2019 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfHXMNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Aug 2019 08:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfHXMNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Aug 2019 08:13:01 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0742146E;
        Sat, 24 Aug 2019 12:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566648780;
        bh=pgQ5Ieucz1re8Y5x9mZNInXpje3w1mq20odaNn+SSIg=;
        h=Date:From:To:Cc:Subject:From;
        b=0sVRhMLveGErFokACfC8K6gIMaNqREenHEwTEMdROoQ9NAr6UvnKr0ys68pi9hVzh
         qG+nnyoD833+wo9ytWfMAkTh1+1dX4+K8eOA5+Z1+4DWvb4PZxlxpy42kX2xf/hzx0
         siwNtoKHGrBEC53KPvI7tHNjUm0OFqXihr0n9wug=
Date:   Sat, 24 Aug 2019 13:12:55 +0100
From:   Will Deacon <will@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     catalin.marinas@arm.com, marc.zyngier@arm.com, pbonzini@redhat.com,
        rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] arm64: Fixes for -rc6
Message-ID: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

Please pull these two KVM/arm fixes for -rc6. Unusually, we're routing them
via the arm64 tree as per Paolo's request on the list:

  https://lore.kernel.org/kvm/21ae69a2-2546-29d0-bff6-2ea825e3d968@redhat.com/

We don't actually have any other arm64 fixes pending at the moment (touch
wood), so I've pulled from Marc, written a merge commit, tagged the
result and run it through my build/boot/bisect scripts.

Cheers,

Will

--->8

The following changes since commit d1abaeb3be7b5fa6d7a1fbbd2e14e3310005c4c1:

  Linux 5.3-rc5 (2019-08-18 14:31:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 087eeea9adcbaef55ae8d68335dcd3820c5b344b:

  Merge tag 'kvmarm-fixes-for-5.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm/fixes (2019-08-24 12:46:30 +0100)

----------------------------------------------------------------
arm64 fixes for -rc6

- Two KVM fixes for MMIO emulation and UBSAN

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity

Andrew Jones (1):
      KVM: arm/arm64: Only skip MMIO insn once

Will Deacon (1):
      Merge tag 'kvmarm-fixes-for-5.3-3' of git://git.kernel.org/.../kvmarm/kvmarm into kvm/fixes

 virt/kvm/arm/mmio.c           |  7 +++++++
 virt/kvm/arm/vgic/vgic-init.c | 30 ++++++++++++++++++++----------
 2 files changed, 27 insertions(+), 10 deletions(-)

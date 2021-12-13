Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD7473331
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhLMRri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhLMRrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:47:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A92DC061574;
        Mon, 13 Dec 2021 09:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E8BE6101C;
        Mon, 13 Dec 2021 17:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A43AC34602;
        Mon, 13 Dec 2021 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639417655;
        bh=Z5mKUjX/EI3zw/gxI/460309v1N2oeVgepxYPylYca8=;
        h=From:To:Cc:Subject:Date:From;
        b=cOBVGvj/fUXemWpSu8UB78KDcIpSsmzo2yHI8WQDBumIPbukMsRP97DkGRgSDhtrk
         Y3fcKyD5RuvAbTgo++rof7gPiRK/iIVAENO6aeLawXuNJmU0tb+n6y/jeT2u093nF7
         m+5EzCcRQg4yp2dwjCZ7P99HaCVHthMWJLeR1+tdo+yzEuyVaWOLkzsgab/A+M2vis
         3NlSitBiYKnoj/YUtIiunr90a0texRBOyB+ngNyz/nCwFfCt6YcbK3ymNAUXv8unTS
         zl+zVSN1CL8BO099H+U3UVfuLSxgTk0HPO9W+X511R4mbRzqnz1MQwX+f0pDSpUQ6+
         rsELETkr+05mQ==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Date:   Mon, 13 Dec 2021 17:46:28 +0000
Message-Id: <20211213174628.178270-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/arm64/kvm/Makefile

between commit:

  17ed14eba22b3 ("KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c")

from the tip tree and commit:

  d8f6ef45a623d ("KVM: arm64: Use Makefile.kvm for common files")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/arm64/kvm/Makefile
index 0bcc378b79615,04a53f71a6b63..0000000000000
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@@ -10,9 -10,7 +10,7 @@@ include $(srctree)/virt/kvm/Makefile.kv
  obj-$(CONFIG_KVM) += kvm.o
  obj-$(CONFIG_KVM) += hyp/
  
- kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
- 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
- 	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 -kvm-y += arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
++kvm-y := arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
  	 inject_fault.o va_layout.o handle_exit.o \
  	 guest.o debug.o reset.o sys_regs.o \
  	 vgic-sys-reg-v3.o fpsimd.o pmu.o \

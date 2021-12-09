Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A201D46F636
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 22:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhLIVzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 16:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhLIVzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 16:55:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F59C061746;
        Thu,  9 Dec 2021 13:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 625CACE28C0;
        Thu,  9 Dec 2021 21:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D69BC004DD;
        Thu,  9 Dec 2021 21:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639086718;
        bh=4+4lPuCdbXqfVpn7bgWrwanLBHcGR1e/UbC82rh+KsY=;
        h=From:To:Cc:Subject:Date:From;
        b=LbikyW4mg48hheFkscyzxtG8A2jvMRI+gv2CLJIT53WlxnX21JsX+Z+oBPXsCaSWy
         t255IUT7iPWp7PdRWYCpkExZGWaItcQC75CNPShI86fwt1fcL9kVyD2zG9IuGj0zoe
         NJEsqptC46C3rrYfLqp+6nvgKkARd15oKkQThrBTuEXDZa78ag/jR6v1CF5lgka+We
         mCZYommH3a00CejfbgFrjvFNhKl6gEz2dcftC88BXupHBn19DNAkrb0HDyITR2WNYc
         u9qLw10iSokE1scDdSgO6+4xNLAVfmnI3NHBZahizs+KmKZstaG/ikygdzrYCs28mT
         lbD6YIDH8cLXA==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the perf tree
Date:   Thu,  9 Dec 2021 21:51:49 +0000
Message-Id: <20211209215149.2661929-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/arm64/kvm/Kconfig

between commit:

  2aef6f306b39b ("perf: Force architectures to opt-in to guest callbacks")

from the perf tree and commit:

  ed922739c9199 ("KVM: Use interval tree to do fast hva lookup in memslots")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/arm64/kvm/Kconfig
index e9761d84f982e,f1f8fc069a970..0000000000000
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@@ -39,7 -39,7 +39,8 @@@ menuconfig KV
  	select HAVE_KVM_IRQ_BYPASS
  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
  	select SCHED_INFO
 +	select GUEST_PERF_EVENTS if PERF_EVENTS
+ 	select INTERVAL_TREE
  	help
  	  Support hosting virtualized guest machines.
  

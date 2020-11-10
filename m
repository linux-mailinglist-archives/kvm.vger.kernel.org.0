Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1E2ADDD8
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 19:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgKJSJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 13:09:51 -0500
Received: from foss.arm.com ([217.140.110.172]:59508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJSJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 13:09:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 556CF1063;
        Tue, 10 Nov 2020 10:09:50 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53EEB3F7BB;
        Tue, 10 Nov 2020 10:09:49 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] arm: MMU extentions to enable litmus7
Date:   Tue, 10 Nov 2020 18:09:22 +0000
Message-Id: <20201110180924.95106-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

litmus7 [1][2], a tool that we develop and use to test the memory
model on hardware, is building on kvm-unit-tests to encapsulate full
system tests and control address translation. This series extends the
kvm-unit-tests arm MMU API and adds two memory attributes to MAIR_EL1
to make them available to the litmus tests.

[1]: http://diy.inria.fr/doc/litmus.html
[2]: https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/expanding-memory-model-tools-system-level-architecture

v1: https://lore.kernel.org/kvm/20201102115311.103750-1-nikos.nikoleris@arm.com/T/
v2: https://lore.kernel.org/kvm/20201110144207.90693-1-nikos.nikoleris@arm.com/T/#u

Changes in v3:
  - Moved comment on break-before make

Changes in v2:
  - Add comment on break-before-make in get_mmu_pte()
  - Signed-off-by tag from all co-authors
  - Minor formatting changes

Thanks,

Nikos

Luc Maranget (1):
  arm: Add mmu_get_pte() to the MMU API

Nikos Nikoleris (1):
  arm: Add support for the DEVICE_nGRE and NORMAL_WT memory types

 lib/arm/asm/mmu-api.h         |  1 +
 lib/arm64/asm/pgtable-hwdef.h |  2 ++
 lib/arm/mmu.c                 | 32 +++++++++++++++++++++-----------
 arm/cstart64.S                |  6 +++++-
 4 files changed, 29 insertions(+), 12 deletions(-)

-- 
2.17.1


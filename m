Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904C82A64CA
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 14:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgKDND4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 08:03:56 -0500
Received: from foss.arm.com ([217.140.110.172]:36812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDND4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 08:03:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2714E139F;
        Wed,  4 Nov 2020 05:03:55 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 269693F719;
        Wed,  4 Nov 2020 05:03:54 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] arm64: Add support for configuring the translation granule
Date:   Wed,  4 Nov 2020 13:03:50 +0000
Message-Id: <20201104130352.17633-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

One more update to the series that allows us to configure the
translation granule in arm64. Again, thanks to Drew and Alex for
their reviews and their suggestions.

v1: 
https://lore.kernel.org/kvm/006a19c0-cdf7-e76c-8335-03034bea9c7e@arm.com/T
v2: 
https://lore.kernel.org/kvm/20201102113444.103536-1-nikos.nikoleris@arm.com/


Changes in v3:
  - Re-ordered the two changes in the series
  - Moved much of the code to check the configured granule from the C
    preprocessor to run time.
  - Avoid block mappings at the PUD level (Thanks Alex!)
  - Formatting changes

Changes in v2:
  - Change the configure option from page-shift to page-size
  - Check and warn if the configured granule is not supported

Thanks,

Nikos


Nikos Nikoleris (2):
  arm64: Check if the configured translation granule is supported
  arm64: Add support for configuring the translation granule

 configure                     | 27 ++++++++++++++
 lib/arm/asm/page.h            |  4 +++
 lib/arm/asm/pgtable-hwdef.h   |  4 +++
 lib/arm/asm/pgtable.h         |  6 ++++
 lib/arm/asm/thread_info.h     |  4 ++-
 lib/arm64/asm/page.h          | 35 ++++++++++++++----
 lib/arm64/asm/pgtable-hwdef.h | 42 +++++++++++++++++-----
 lib/arm64/asm/pgtable.h       | 68 +++++++++++++++++++++++++++++++++--
 lib/arm64/asm/processor.h     | 36 +++++++++++++++++++
 lib/libcflat.h                | 20 ++++++-----
 lib/arm/mmu.c                 | 31 ++++++++++------
 arm/cstart64.S                | 10 +++++-
 12 files changed, 249 insertions(+), 38 deletions(-)

-- 
2.17.1


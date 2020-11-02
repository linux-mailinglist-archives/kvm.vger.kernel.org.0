Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93D42A299A
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgKBLet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 06:34:49 -0500
Received: from foss.arm.com ([217.140.110.172]:58090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgKBLet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 06:34:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D270101E;
        Mon,  2 Nov 2020 03:34:47 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C2D53F66E;
        Mon,  2 Nov 2020 03:34:46 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] arm64: Add support for configuring the translation granule
Date:   Mon,  2 Nov 2020 11:34:42 +0000
Message-Id: <20201102113444.103536-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This is an update to the patch that allows a user to change the
translation granule in arm64. Special thanks to Drew and Alex for
having a look at the code and their suggestions.

v1: https://lore.kernel.org/kvm/006a19c0-cdf7-e76c-8335-03034bea9c7e@arm.com/T

Changes in v2:
 - Change the configure option from page-shift to page-size
 - Check and warn if the configured granule is not supported

Thanks,

Nikos

Nikos Nikoleris (2):
  arm64: Add support for configuring the translation granule
  arm64: Check if the configured translation granule is supported

 configure                     | 26 +++++++++++++
 lib/arm/asm/page.h            |  4 ++
 lib/arm/asm/pgtable-hwdef.h   |  4 ++
 lib/arm/asm/pgtable.h         |  6 +++
 lib/arm/asm/thread_info.h     |  4 +-
 lib/arm64/asm/page.h          | 25 ++++++++++---
 lib/arm64/asm/pgtable-hwdef.h | 38 +++++++++++++------
 lib/arm64/asm/pgtable.h       | 69 +++++++++++++++++++++++++++++++++--
 lib/arm64/asm/processor.h     | 65 +++++++++++++++++++++++++++++++++
 lib/arm/mmu.c                 | 29 ++++++++++-----
 arm/cstart64.S                | 10 ++++-
 11 files changed, 248 insertions(+), 32 deletions(-)

-- 
2.17.1


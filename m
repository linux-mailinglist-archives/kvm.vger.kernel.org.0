Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C784B5786
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343818AbiBNQ6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiBNQ6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:58:30 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C377065155
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:58:22 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8974213D5;
        Mon, 14 Feb 2022 08:58:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 577363F70D;
        Mon, 14 Feb 2022 08:58:21 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, pierre.gondois@arm.com
Subject: [PATCH kvmtool 0/3] Misc fixes
Date:   Mon, 14 Feb 2022 16:58:27 +0000
Message-Id: <20220214165830.69207-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are a handful of small fixes for random stuff which I found while
using kvmtool.

Patch #1 is actually needed to use kvmtool as a test runner for
kvm-unit-tests (more detailed explanation in the commit message).

Patch #2 is more like a quality of life improvement for users.

Patch #3 is for something that I found when a Linux guest complained that
"msi-parent" was referencing an invalid phandle (I don't remember the
kernel version, defconfig and VM configuration that I used, couldn't
reproduce it with a v5.16 guest); it was also reported to me by Pierre, so
I figured it deserves a fix.

Alexandru Elisei (3):
  Remove initrd magic check
  arm: Use pr_debug() to print memory layout when loading a firmware
    image
  arm: pci: Generate "msi-parent" property only with a MSI controller

 arm/fdt.c                    |  2 +-
 arm/include/arm-common/pci.h |  3 ++-
 arm/kvm.c                    |  8 +++++---
 arm/pci.c                    |  8 ++++++--
 kvm.c                        | 22 ----------------------
 5 files changed, 14 insertions(+), 29 deletions(-)

-- 
2.31.1


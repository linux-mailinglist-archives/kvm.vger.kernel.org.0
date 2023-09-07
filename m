Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64D797A11
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbjIGR2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244019AbjIGR2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:28:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1639E173B
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 10:28:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F9571042;
        Thu,  7 Sep 2023 10:17:32 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 016BD3F67D;
        Thu,  7 Sep 2023 10:16:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        andre.przywara@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com
Subject: [PATCH kvmtool 0/3] Change what --nodefaults does and a revert
Date:   Thu,  7 Sep 2023 18:16:52 +0100
Message-Id: <20230907171655.6996-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first two patches revert "virtio-net: Don't print the compat warning
for the default device" because using --network mode=none disables the
device and lets the user know that it can use that to disable the default
virtio-net device. I don't think the changes are controversial.

And the last patch is there to get the conversation going about changing
what --nodefaults does. Details in the patch.

Alexandru Elisei (3):
  Revert "virtio-net: Don't print the compat warning for the default
    device"
  builtin-run: Document mode=none for -n/--network
  builtin-run: Have --nodefaults disable the default virtio-net device

 builtin-run.c |  6 +++---
 virtio/net.c  | 11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.42.0


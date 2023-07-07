Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577E774B3D8
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjGGPLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 11:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjGGPLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 11:11:43 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9652B124
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 08:11:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 519D8D75;
        Fri,  7 Jul 2023 08:12:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7E023F762;
        Fri,  7 Jul 2023 08:11:39 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 0/4] Add --loglevel argument
Date:   Fri,  7 Jul 2023 16:11:15 +0100
Message-ID: <20230707151119.81208-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool can be unnecessarily verbose at times, and Will proposed in a chat
we had a while ago to add a --loglevel command line argument to choose
which type of messages to silence. This is me taking a stab at it.

Build tested for all arches and run tested lightly on a rockpro64 and my
x86 machine.

Base commit is 3b1cdcf9e78f ("virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM").

Changelog in each patch.

Alexandru Elisei (4):
  util: Make pr_err() return void
  Replace printf/fprintf with pr_* macros
  util: Use __pr_debug() instead of pr_info() to print debug messages
  Add --loglevel argument for the run command

 arm/gic.c            |  5 ++--
 builtin-run.c        | 69 ++++++++++++++++++++++++++++++--------------
 builtin-setup.c      | 16 +++++-----
 guest_compat.c       |  2 +-
 include/kvm/util.h   | 14 ++++++---
 kvm-cpu.c            | 12 ++++----
 mmio.c               |  2 +-
 util/parse-options.c | 28 ++++++++++--------
 util/util.c          | 27 +++++++++++++++--
 9 files changed, 116 insertions(+), 59 deletions(-)

-- 
2.41.0


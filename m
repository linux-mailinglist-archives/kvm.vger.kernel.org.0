Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1D64C1362
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiBWM5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240684AbiBWM5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:57:44 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 398B0B850
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:57:14 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C22EED1;
        Wed, 23 Feb 2022 04:57:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E283F70D;
        Wed, 23 Feb 2022 04:57:12 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 0/3] configure changes and rename --target-efi
Date:   Wed, 23 Feb 2022 12:55:34 +0000
Message-Id: <20220223125537.41529-1-alexandru.elisei@arm.com>
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

The first two patches are fixes for stuff I found while working on patch
#3.

Patch #3 ("Rename --target-efi to --[enable|disable]-efi") is where the
configure option --target-efi gets renamed.

Changes in v2:

* Dropped what was patch #3, which made arm/arm64 configure option
  --target available to all architectures.

* Renamed --target-efi to --[enable|disable]-efi instead of --efi-payload.

Alexandru Elisei (3):
  configure: Fix whitespaces for the --gen-se-header help text
  configure: Restrict --target-efi to x86_64
  Rename --target-efi to --[enable|disable]-efi

 Makefile             | 10 +++-------
 configure            | 22 +++++++++++++++-------
 lib/x86/acpi.c       |  4 ++--
 lib/x86/amd_sev.h    |  4 ++--
 lib/x86/asm/page.h   |  8 ++++----
 lib/x86/asm/setup.h  |  4 ++--
 lib/x86/setup.c      |  4 ++--
 lib/x86/vm.c         | 12 ++++++------
 scripts/runtime.bash |  4 ++--
 x86/Makefile.common  |  6 +++---
 x86/Makefile.x86_64  |  6 +++---
 x86/access_test.c    |  2 +-
 x86/efi/README.md    |  2 +-
 x86/efi/run          |  2 +-
 x86/run              |  4 ++--
 15 files changed, 49 insertions(+), 45 deletions(-)

-- 
2.35.1


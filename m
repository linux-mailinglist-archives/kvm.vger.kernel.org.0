Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617734E6297
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 12:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbiCXLk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 07:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiCXLk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 07:40:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E916F53E38
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 04:39:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC84E11FB;
        Thu, 24 Mar 2022 04:39:24 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F4783F73D;
        Thu, 24 Mar 2022 04:39:23 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, steven.price@arm.com
Subject: [kvmtool PATCH v2 0/2] arm64: Add MTE support
Date:   Thu, 24 Mar 2022 11:39:40 +0000
Message-Id: <20220324113942.24217-1-alexandru.elisei@arm.com>
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

Add Memory Tagging Extension (MTE) support in kvmtool.

Changes since v1:

* Update headers to v5.17
* MTE capability is now enabled by default and the command line option
  --disable-mte has been added.

Alexandru Elisei (2):
  update_headers.sh: Sync ABI headers with Linux v5.17
  aarch64: Add support for MTE

 arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
 arm/aarch64/include/asm/kvm.h             |  5 +++++
 arm/aarch64/include/kvm/kvm-arch.h        |  1 +
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
 arm/aarch64/kvm.c                         | 23 +++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 |  2 ++
 include/linux/kvm.h                       | 18 ++++++++++++++++++
 x86/include/asm/kvm.h                     | 19 ++++++++++++++++++-
 9 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.35.1


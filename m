Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177764E2C39
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350221AbiCUP3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345124AbiCUP3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:29:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA71813CD2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:28:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DAD31042;
        Mon, 21 Mar 2022 08:28:07 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F19B13F73D;
        Mon, 21 Mar 2022 08:28:05 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        steven.price@arm.com, vladimir.murzin@arm.com
Subject: [kvmtool PATCH 0/2] arm64: Add MTE support
Date:   Mon, 21 Mar 2022 15:28:18 +0000
Message-Id: <20220321152820.246700-1-alexandru.elisei@arm.com>
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

This series does what it says on the can: adds Memory Tagging Extension
(MTE) support in kvmtool.

Alexandru Elisei (2):
  update_headers: Sync ABI headers with Linux v5.17-rc8
  aarch64: Add support for MTE

 arm/aarch32/include/kvm/kvm-arch.h        |  3 +++
 arm/aarch64/include/asm/kvm.h             |  5 +++++
 arm/aarch64/include/kvm/kvm-arch.h        |  1 +
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
 arm/aarch64/kvm.c                         | 13 +++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 |  3 +++
 include/linux/kvm.h                       | 18 ++++++++++++++++++
 x86/include/asm/kvm.h                     | 19 ++++++++++++++++++-
 9 files changed, 64 insertions(+), 1 deletion(-)

-- 
2.35.1


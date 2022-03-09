Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AA74D34BD
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 17:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiCIQ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiCIQVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:21:51 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B08AF3A5
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:20:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DF89168F;
        Wed,  9 Mar 2022 08:20:52 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 762AA3F7F5;
        Wed,  9 Mar 2022 08:20:51 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] arm: 32 bit tests improvements
Date:   Wed,  9 Mar 2022 16:21:15 +0000
Message-Id: <20220309162117.56681-1-alexandru.elisei@arm.com>
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

First patch is to allow the 32 bit tests to run under kvmtool; second patch
fixes running the 32 bit tests on an arm64 machine with KVM. Both patches
came out of a discussion on the list [1].

[1] https://www.spinics.net/lists/kvm/msg267391.html

Alexandru Elisei (1):
  arm: Change text base address for 32 bit tests when running under
    kvmtool

Andrew Jones (1):
  arm/run: Fix using qemu-system-aarch64 to run aarch32 tests on aarch64

 arm/Makefile.arm | 6 ++++++
 arm/run          | 5 +++++
 2 files changed, 11 insertions(+)

-- 
2.35.1


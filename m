Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0C2610C4B
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 10:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJ1IfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJ1IfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 04:35:14 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0257DC4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 01:35:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666946110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yf+n15Bb2ai4QCnL88CYPPcwLq0iceY6iN9pF2k3P5Q=;
        b=j4kJJ3RLELiXfnfiOSev4HcPjbiLyo2ZYe9906cwpPEHi5GeHTEmxSnwfS96sVLJ7mjH1M
        UaQJZZS5mhInspdE4rPozTxnSUFZd4Se2DfO9BGIgRVW1UWkzvnbbQtjWa4twTwUAeFDEN
        JGF0EqGst0zc7IPKVcnxshyf3KI15Bo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
        Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: pKVM memory transitions cleanup
Date:   Fri, 28 Oct 2022 08:34:46 +0000
Message-Id: <20221028083448.1998389-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to help resolve my own bikeshedding on the outstanding pKVM
patches [1], small deck of patches to polish up the existing memory
transitions. Mainly:

 - Rejig the layout of pkvm_mem_transition
 - Stop using out pointers to get at the 'completer' addr
 - Use better-fitting terminology (source/target) to describe the
   addresses involved in a memory transition

Applies to 6.1-rc2. Politely compile tested, and that's just about it.

Oliver Upton (2):
  KVM: arm64: Clean out the odd handling of completer_addr
  KVM: arm64: Redefine pKVM memory transitions in terms of source/target

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 124 +++++++++++---------------
 1 file changed, 52 insertions(+), 72 deletions(-)


base-commit: 247f34f7b80357943234f93f247a1ae6b6c3a740
-- 
2.38.1.273.g43a17bfeac-goog


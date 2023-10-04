Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3183D7B98E8
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbjJDXuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 19:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243199AbjJDXuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 19:50:11 -0400
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85180D8
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 16:50:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696463405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zrlS9qShL+VBMvCHeJefZmgBz6EH2IBmaUJdenIoZgI=;
        b=d1j923p0/uoPLgf2+CYvNqHe8Bz0muO4MALTRk1ZmYuvZ4pvS62fhzQcb98xMUzlo0BpSW
        nx+NGceMhJe4+yEqS54WNR+kFJxyZD9U7pE4IXXdrNsNYXYZVee7pUgge7TB5hQiox1gy+
        J9A+TYmZO3wtqpKLX4+h7TuelArSszc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Cleanups for managing SMCCC filter maple tree
Date:   Wed,  4 Oct 2023 23:49:44 +0000
Message-ID: <20231004234947.207507-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small series to clean up the way KVM manages the maple tree
representation of the SMCCC filter, only allocating nodes in the tree if
the SMCCC filter is used.

The other ugly bit that this fixes is the error path when 'reserved'
ranges cannot be inserted into the maple tree, instead returning an
error to userspace.

Oliver Upton (3):
  KVM: arm64: Add a predicate for testing if SMCCC filter is configured
  KVM: arm64: Only insert reserved ranges when SMCCC filter is used
  KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured

 arch/arm64/include/asm/kvm_host.h |  4 +---
 arch/arm64/kvm/hypercalls.c       | 34 ++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 15 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.609.gbb76f46606-goog


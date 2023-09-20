Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7337A7529
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 10:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjITIB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjITIBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 04:01:55 -0400
Received: from out-227.mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213AC97
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 01:01:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695196907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MLW7qwdJIvj48Ety8MOzco+OBQsuiHw84jgrxmlkBac=;
        b=l2IgLoEqC/yOBo3Y5qEWPHQFyk0P8rAUR+VVbIDFcNfvcfqJaJN30zb2w511oSCcn1yONr
        EK9Z89DSDG9VbxGJKPjiUQiCC2zG9MRAhnAzmsA/NOUcwot8DT1+2o5IZLIDEzojmu/GUj
        WJLfDeXFG1wKtwR3dGVEHWKEUto/hVA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Address soft lockups due to I-cache CMOs
Date:   Wed, 20 Sep 2023 08:01:31 +0000
Message-ID: <20230920080133.944717-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small series to address the soft lockups that Gavin hits when running
KVM guests w/ hugepages on an Ampere Altra Max machine. While I
absolutely loathe "fixing" the issue of slow I-cache CMOs in this way,
I can't really think of an alternative.

Oliver Upton (2):
  arm64: tlbflush: Rename MAX_TLBI_OPS
  KVM: arm64: Avoid soft lockups due to I-cache maintenance

 arch/arm64/include/asm/kvm_mmu.h  | 37 ++++++++++++++++++++++++++-----
 arch/arm64/include/asm/tlbflush.h |  8 +++----
 2 files changed, 35 insertions(+), 10 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.459.ge4e396fd5e-goog


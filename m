Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E307BA896
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjJESDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 14:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjJESDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 14:03:49 -0400
Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31E90
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 11:03:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696529026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Tureg2m9XbvXMu5THHgF3eRFwznEfRjXAAD0FdkzkLo=;
        b=Uzgc9b0uCw1rPM/5/bI9rx+0ms7sEWeBrThOZwMJ1sOKo3tblQr7qosDLovH7xUPOpnhwd
        thuyI92s3Es6QzinXVu8YJTPEjeKMgAftMMgE/0pikHc9IWvRTn5G4ZPe62p6iPzedyqi4
        Nm882lSOyb+zZJuqRkN5En9lZyC+mjg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] tools: arm64: Sync sysreg.h with the kernel
Date:   Thu,  5 Oct 2023 18:03:22 +0000
Message-ID: <20231005180325.525236-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM selftests needs to use the full set of sysreg definitions for an
upcoming change [1]. We took a stab at copying the entire sysreg
generation infrastructure into the tools directory, but that exploded
and broke the build for perf, oops [2].

Short of better build infrastructure in tools for handling common
prerequisite tasks, this series takes the lazy route and copies the
generated output of the sysreg infra from the kernel.

Plan is to apply this series as part of the 'writable' ID register
series, replacing the broken change.

[1]: https://lore.kernel.org/kvmarm/20231003230408.3405722-13-oliver.upton@linux.dev/
[2]: https://lore.kernel.org/linux-next/20231005123159.1b7dff0f@canb.auug.org.au/

Jing Zhang (1):
  tools: arm64: Sync sysreg.h with the kernel source

Oliver Upton (1):
  tools: arm64: Add a copy of sysreg-defs.h generated from the kernel

 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg-defs.h    | 6806 +++++++++++++++++
 tools/arch/arm64/include/asm/sysreg.h         |  839 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 7 files changed, 7038 insertions(+), 661 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/include/asm/sysreg-defs.h

-- 
2.42.0.609.gbb76f46606-goog


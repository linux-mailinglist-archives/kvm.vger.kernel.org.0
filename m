Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7226AA11B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCCVZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjCCVZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:25:52 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CDC6150E
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:25:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 12EAC37E2A809D
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:25:50 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QOLd1w9P585b for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:25:49 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 6D8CD37E2A809A
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:25:49 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 6D8CD37E2A809A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677878749; bh=l2RwrVn9v7KdAdAvwAZbBQP9/y9muMHD96LRsWXpO18=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=DC66f0CkI02ASAnR/jObeAW5HnBO77xUvclJBt1CN3If9vn+lrMy7NIA/oHrMsms4
         eaJMoVP7qQwh/l7nAuPvPp188PZkCWeSJJMaDk8i/QNRG1QSSjw4l4kdh/mu6C38a6
         26KwiNoz5g/v0rtnHTeL2US8orjzMZzqaRra3Rsc=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TkzUhKhUyJCZ for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:25:49 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 4733637E2A8097
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:25:49 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:25:47 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm@vger.kernel.org
Message-ID: <1719306309.16280446.1677878747538.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 0/5] Reenable VFIO support on POWER systems
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: YGDmlSLW5Lf5tTL/GSA6EYoZk1NX+Q==
Thread-Topic: Reenable VFIO support on POWER systems
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series reenables VFIO support on POWER systems.  It
is based on Alexey Kardashevskiys's patch series, rebased and
successfully tested under QEMU with a Marvell PCIe SATA controller
on a POWER9 Blackbird host.

Alexey Kardashevskiy (4):
  KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support platform dependent
  powerpc/iommu: Add "borrowing" iommu_table_group_ops
  powerpc/pci_64: Init pcibios subsys a bit later
  powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
    domains

Timothy Pearson (1):
  Add myself to MAINTAINERS for Power VFIO support

 MAINTAINERS                               |   5 +
 arch/arm64/kvm/arm.c                      |   3 +
 arch/mips/kvm/mips.c                      |   3 +
 arch/powerpc/include/asm/iommu.h          |   6 +-
 arch/powerpc/include/asm/pci-bridge.h     |   7 +
 arch/powerpc/kernel/iommu.c               | 247 +++++++++++++++++++++-
 arch/powerpc/kernel/pci_64.c              |   2 +-
 arch/powerpc/kvm/powerpc.c                |   6 +
 arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
 arch/powerpc/platforms/pseries/iommu.c    |  27 +++
 arch/powerpc/platforms/pseries/pseries.h  |   4 +
 arch/powerpc/platforms/pseries/setup.c    |   3 +
 arch/riscv/kvm/vm.c                       |   3 +
 arch/s390/kvm/kvm-s390.c                  |   3 +
 arch/x86/kvm/x86.c                        |   3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
 virt/kvm/kvm_main.c                       |   1 -
 17 files changed, 360 insertions(+), 95 deletions(-)

-- 
2.30.2

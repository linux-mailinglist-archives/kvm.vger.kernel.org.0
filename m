Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0B957468A
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiGNISl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 04:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiGNISj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 04:18:39 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E37ADE1;
        Thu, 14 Jul 2022 01:18:36 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 58DA2804CB;
        Thu, 14 Jul 2022 04:18:26 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Deming Wang <wangdeming@inspur.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 0/3] powerpc/iommu: Add iommu_ops to report capabilities and allow blocking domains
Date:   Thu, 14 Jul 2022 18:18:19 +1000
Message-Id: <20220714081822.3717693-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is another take on iommu_ops on POWER to make VFIO work
again on POWERPC64.

The tree with all prerequisites is here:
https://github.com/aik/linux/tree/kvm-fixes-wip

The previous discussion is here:
https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220707135552.3688927-1-aik@ozlabs.ru/
https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/

Please comment. Thanks.



Alexey Kardashevskiy (3):
  powerpc/iommu: Add "borrowing" iommu_table_group_ops
  powerpc/pci_64: Init pcibios subsys a bit later
  powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
    domains

 arch/powerpc/include/asm/iommu.h          |   6 +-
 arch/powerpc/include/asm/pci-bridge.h     |   7 +
 arch/powerpc/platforms/pseries/pseries.h  |   5 +
 arch/powerpc/kernel/iommu.c               | 257 +++++++++++++++++++++-
 arch/powerpc/kernel/pci_64.c              |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  36 ++-
 arch/powerpc/platforms/pseries/iommu.c    |  27 +++
 arch/powerpc/platforms/pseries/setup.c    |   3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++------
 9 files changed, 345 insertions(+), 94 deletions(-)

-- 
2.30.2


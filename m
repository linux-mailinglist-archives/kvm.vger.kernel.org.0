Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C065BE6A7
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiITNFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiITNFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:05:11 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77EF513D78;
        Tue, 20 Sep 2022 06:05:10 -0700 (PDT)
Received: from ole.1.ozlabs.ru (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 212C282ECC;
        Tue, 20 Sep 2022 09:05:07 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH kernel v2 0/3] powerpc/iommu: Add iommu_ops to report capabilities and allow blocking domains
Date:   Tue, 20 Sep 2022 23:04:54 +1000
Message-Id: <20220920130457.29742-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is another take on iommu_ops on POWER to make VFIO work
again on POWERPC64. Tested on PPC, kudos to Fred!

The tree with all prerequisites is here:
https://github.com/aik/linux/tree/kvm-fixes-wip

The previous discussion is here:
https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220707135552.3688927-1-aik@ozlabs.ru/
https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/
https://lore.kernel.org/all/20220714081822.3717693-3-aik@ozlabs.ru/T/

Please comment. Thanks.


This is based on sha1
ce888220d5c7 Linus Torvalds "Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi".

Please comment. Thanks.



Alexey Kardashevskiy (3):
  powerpc/iommu: Add "borrowing" iommu_table_group_ops
  powerpc/pci_64: Init pcibios subsys a bit later
  powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
    domains

 arch/powerpc/include/asm/iommu.h          |   6 +-
 arch/powerpc/include/asm/pci-bridge.h     |   7 +
 arch/powerpc/platforms/pseries/pseries.h  |   4 +
 arch/powerpc/kernel/iommu.c               | 247 +++++++++++++++++++++-
 arch/powerpc/kernel/pci_64.c              |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
 arch/powerpc/platforms/pseries/iommu.c    |  27 +++
 arch/powerpc/platforms/pseries/setup.c    |   3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
 9 files changed, 334 insertions(+), 94 deletions(-)

-- 
2.37.3


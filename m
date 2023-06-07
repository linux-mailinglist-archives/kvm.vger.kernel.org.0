Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4132D725296
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 05:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbjFGDyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 23:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240890AbjFGDxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 23:53:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A6819BD;
        Tue,  6 Jun 2023 20:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686110005; x=1717646005;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=075khLrPsaylNwjI1Hcf0TEQzPBC5O5WohuQUXG8IA0=;
  b=UvfTorsDXha8HtMW9LW3vowDlWQ65QYPVcbC3Qcgq6hDtEq4KGmlah/7
   SbkabWTKOf554J1ZOV+ZsYIL/7QYyOe6ymn8Xww+gFI5j63Im/RO8/UrX
   G0sEJoULAUL+Q1nENiiZaLeWqLyHj4BO3C6ERoQIUzPc+Afgr4dQhkg1P
   h78hBEr1qCrJ7s4kKqqAjgmMYKGk0gr9661iuDBMCXkArohtg8UP3dtuL
   v7JOyPx26m9fhZNCzAlch8yGnIHpBm+63uC8Ws8oy2KTZet6MVma7ZGBB
   VXnpOjw27v+H349O5AhDz2O3vqYjq9ik/Ixi1lxGlJQ83zJe5Wa8Bz/Ju
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385186333"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="385186333"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:53:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="799125349"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="799125349"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 20:53:22 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 0/2] Prevent RESV_DIRECT devices from user assignment
Date:   Wed,  7 Jun 2023 11:51:43 +0800
Message-Id: <20230607035145.343698-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are follow-up patches on this discussion:

https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com

I just summarized the ideas and code into a real patch series. Please
help to review and merge.

Best regards,
baolu

Lu Baolu (2):
  iommu: Prevent RESV_DIRECT devices from blocking domains
  iommu/vt-d: Remove rmrr check in domain attaching device path

 include/linux/iommu.h       |  2 ++
 drivers/iommu/intel/iommu.c | 58 -------------------------------------
 drivers/iommu/iommu.c       | 39 ++++++++++++++++++-------
 3 files changed, 31 insertions(+), 68 deletions(-)

-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BDE543073
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiFHMbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiFHMbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC621285C9
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691501; x=1686227501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tSB2DyD8BeADWS4sEGxP5x5vma8/I3aEjte+rXvo4Lw=;
  b=LVKNL5bYHPLU+kN1t6CMy4N8sdhJEu3ILL5Kn630sXXQShSCprECMHSS
   Q5CmbCSM3vLTHH3NDwXQugf7xNWUGlFOjnIIQ9GmjuwY0trcalp1wmjKv
   mJmrieva67FzKspXLH7OUsZUhs9xx/exwl6WVZ1NsFrzZ8Icd721dl/pN
   21t6B9tKZcPwUh1EtEhSNe0FCeFjhnetB2EmA19p9XOnbO9LWafYZRNHh
   L3NlNMR1vcr/AeDu0R8AzftihJIhd1MywRVr9MeVtr3dcQYb/L1yR8YJr
   eXWjeny7PH0WPO4W9efH83/0+4pYqP1fvv4LdRNN43+zKivHTvGQi26eJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302237981"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302237981"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529692"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:40 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com
Subject: [RFC v2 01/15] scripts/update-linux-headers: Add iommufd.h
Date:   Wed,  8 Jun 2022 05:31:25 -0700
Message-Id: <20220608123139.19356-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220608123139.19356-1-yi.l.liu@intel.com>
References: <20220608123139.19356-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Update the script to import iommufd.h

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 scripts/update-linux-headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
index 839a5ec614..a89b83e6d6 100755
--- a/scripts/update-linux-headers.sh
+++ b/scripts/update-linux-headers.sh
@@ -160,7 +160,7 @@ done
 
 rm -rf "$output/linux-headers/linux"
 mkdir -p "$output/linux-headers/linux"
-for header in kvm.h vfio.h vfio_ccw.h vfio_zdev.h vhost.h \
+for header in kvm.h vfio.h iommufd.h vfio_ccw.h vfio_zdev.h vhost.h \
               psci.h psp-sev.h userfaultfd.h mman.h; do
     cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
 done
-- 
2.27.0


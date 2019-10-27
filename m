Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48251E6119
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 07:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJ0GZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 02:25:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:35281 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfJ0GZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 02:25:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 23:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,235,1569308400"; 
   d="scan'208";a="282645914"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 26 Oct 2019 23:25:53 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iObzt-000J3d-R6; Sun, 27 Oct 2019 14:25:53 +0800
Date:   Sun, 27 Oct 2019 14:24:57 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [RFC PATCH] vfio/mdev: mdev_type_attr_aggregation can be static
Message-ID: <20191027062456.xn45q5nnahymvpi5@4978f4969bb8>
References: <20191024050829.4517-3-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024050829.4517-3-zhenyuw@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Fixes: b335e826b3eb ("vfio/mdev: Add "aggregation" attribute for supported mdev type")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 mdev_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index acd3ec2900b5c..2f4faef85858d 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -105,7 +105,7 @@ aggregation_show(struct kobject *kobj, struct device *dev, char *buf)
 	else
 		return sprintf(buf, "%u\n", m);
 }
-MDEV_TYPE_ATTR_RO(aggregation);
+static MDEV_TYPE_ATTR_RO(aggregation);
 
 static void mdev_type_release(struct kobject *kobj)
 {

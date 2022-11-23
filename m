Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4612635BD2
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbiKWLd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbiKWLdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:33:19 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED6286CF;
        Wed, 23 Nov 2022 03:33:07 -0800 (PST)
Received: from frapeml100007.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NHJsC4fH9z67Zm0;
        Wed, 23 Nov 2022 19:33:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:33:05 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:33:00 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [PATCH 0/4] hisi_acc_vfio_pci: Add PRE_COPY migration feature support 
Date:   Wed, 23 Nov 2022 11:32:32 +0000
Message-ID: <20221123113236.896-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The optional PRE_COPY state support for migration feature is introduced
by this series here[1](Thanks for that!). This is something HiSilicon
ACC driver can make use for early dev compatibility checks and have
made an attempt in the past here[2].

Adding this will speed up reporting the compatibility error early in
the migration process without the need to wait for complete data
transfer. This is sanity tested on a HiSilicon Platform.

Please take a look.

Regards,
Shameer

1.https://lore.kernel.org/all/20221106174630.25909-1-yishaih@nvidia.com/
2.https://lore.kernel.org/kvm/20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com/

Shameer Kolothum (4):
  hisi_acc_vfio_pci: Add support for precopy IOCTL
  hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions
  hisi_acc_vfio_pci: Move the dev compatibility tests for early check
  hisi_acc_vfio_pci: Enable PRE_COPY flag

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 147 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   2 +
 2 files changed, 133 insertions(+), 16 deletions(-)

-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABF27996AD
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245358AbjIIHKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 03:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjIIHKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 03:10:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3201BF9
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 00:09:56 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RjPCS5L91zNnHM;
        Sat,  9 Sep 2023 15:06:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 9 Sep
 2023 15:09:53 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH 0/3] vfio: Fix the null-ptr-deref bugs in samples of vfio-mdev
Date:   Sat, 9 Sep 2023 15:09:49 +0800
Message-ID: <20230909070952.80081-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a null-ptr-deref bug in strchr() of device_add(), if the kstrdup()
fails in kobject_set_name_vargs() in dev_set_name(). This patchset fix
the issues.

Jinjie Ruan (3):
  vfio/mdpy: Fix the null-ptr-deref bug in mdpy_dev_init()
  vfio/mtty: Fix the null-ptr-deref bug in mtty_dev_init()
  vfio/mbochs: Fix the null-ptr-deref bug in mbochs_dev_init()

 samples/vfio-mdev/mbochs.c | 4 +++-
 samples/vfio-mdev/mdpy.c   | 4 +++-
 samples/vfio-mdev/mtty.c   | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.34.1


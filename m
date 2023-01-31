Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8557F6837FC
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjAaUzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAaUzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ADA5AA65
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrrCusHrxGksK5WpkDYQdcyLeYMKmiIvMtxnx2+xeiI=;
        b=XeISdidzJZONn2RSWzzD23Hh004RtakZeWneTLX5HzBRfkND8JB3W+IAD4r3G0LzKTCFPO
        Ah7p9wD+ibT0MAgvxJRMo1nVyE4EXkqJem6t8Uagpxz1GxT9FYqagFYDKJxpCXFjbl0TxN
        DL8UJhjO31kcVk2holzN4bkNjQKtRTc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-L2Rpa-aYM62bEnhIZ7L51A-1; Tue, 31 Jan 2023 15:53:56 -0500
X-MC-Unique: L2Rpa-aYM62bEnhIZ7L51A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01E3B85CCE3;
        Tue, 31 Jan 2023 20:53:56 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9ECC40C2064;
        Tue, 31 Jan 2023 20:53:49 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 06/18] vfio/common: Rename into as.c
Date:   Tue, 31 Jan 2023 21:52:53 +0100
Message-Id: <20230131205305.2726330-7-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

As the file mostly contains code related to VFIOAddressSpaces and
MemoryListeners, let's rename it into as.c

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/{common.c => as.c} | 0
 hw/vfio/meson.build        | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename hw/vfio/{common.c => as.c} (100%)

diff --git a/hw/vfio/common.c b/hw/vfio/as.c
similarity index 100%
rename from hw/vfio/common.c
rename to hw/vfio/as.c
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 2a6912c940..7937dab078 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -1,7 +1,7 @@
 vfio_ss = ss.source_set()
 vfio_ss.add(files(
   'helpers.c',
-  'common.c',
+  'as.c',
   'container.c',
   'spapr.c',
   'migration.c',
-- 
2.37.3


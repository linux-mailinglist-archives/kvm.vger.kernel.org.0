Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9324B1E5398
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 04:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgE1CBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 22:01:21 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:42390 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgE1CBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 22:01:18 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 49XWC12Mpkz9vYBT
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 02:01:17 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BYkVvTmJVylL for <kvm@vger.kernel.org>;
        Wed, 27 May 2020 21:01:17 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 49XWC10fKwz9vFPQ
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 21:01:17 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p5.oit.umn.edu 49XWC10fKwz9vFPQ
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p5.oit.umn.edu 49XWC10fKwz9vFPQ
Received: by mail-io1-f69.google.com with SMTP id g3so6981624ioc.20
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 19:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BPs8LVcxoxf1YiKvvhf741vH5cSBxCq2p6KwCVlZJlU=;
        b=FQLUT3B1eErsvZ0Ocp4xVAs2C/j0jxi7sjHyq2fkRKXxUD5n5X0POfT2PAglwf+v0w
         F8TztGOERRorjskQK4YnoXOqcy7C2EBJ9tekEsCR0JWnPzY9v1QvriPPVUJL/I9BeHef
         Hy690sImJpeFn/YpIhEaeHhPaNZq7lCq6qM0f8X0wo6Q/j8NPNRM+OJCbUVXs9a/j2P9
         fXRb9V1JKefP3wwfANb+iq2lAfa/rdKKGKtR6P+c3vmdiAsVeD+4vhX5Bd+MxH6SsY2o
         S1z/esmZIrHRqbThvG3XVWtAXZtT0ln+pqjjM1jvyX/g/BPXvrME6Y9G+FvmpQqlqrox
         xx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BPs8LVcxoxf1YiKvvhf741vH5cSBxCq2p6KwCVlZJlU=;
        b=pGyn1Quk+glBdFvm77g1Jv37P/p+Py0sntw+aEGbsR0ZOH/zPBJ5OdNYInNov+ygCT
         VMKPq2fNW2SU3U5AYdu/tCLHSoCIY2XykuVUIDpGwunuFZrWqyoaWWmEBMXF1xiIYIks
         ZjSZTq/5z2i2/s7bwynp6VyjpI1Pej4SxqsJp15lMRqxgo53LwGNisbOeJFuVr0ZVZ4T
         G2yRdYyAOvy+pnMK/936SDQ8dPXhgKSs6P3sPDt6XcfyLxj5IZgI5cE0ZT8MWA2C6l+a
         7CJPBkW9wEsit6hOVWiLFZsVbE38wXIOQU/OMGOV2iPez1KrVr3dfIG8cvYlXIsRD48T
         Kmfg==
X-Gm-Message-State: AOAM533hdmYUNvwi8mKxVe5kk9abL7Mijvx++CWFscsEkt7Y8+ptEmyt
        iEd2qt09ce/L13eH02lmNWrrw/S1eNIWJtn/LGjeqDvlHJ3t9CR0JmdtvpakKLqN1ySys0IdZvc
        C7jwvLEnd4GmZpXQ3
X-Received: by 2002:a92:b001:: with SMTP id x1mr931331ilh.18.1590631276457;
        Wed, 27 May 2020 19:01:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzseNODZL7xc5OcagCl2EGQR0kxsq3pWzWLytnWDMqV+TXhfavKonxOJKsgZL6Q5ghdTnh/g==
X-Received: by 2002:a92:b001:: with SMTP id x1mr931315ilh.18.1590631276118;
        Wed, 27 May 2020 19:01:16 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id z12sm1965088iol.15.2020.05.27.19.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 19:01:15 -0700 (PDT)
From:   wu000273@umn.edu
To:     kjlu@umn.edu
Cc:     wu000273@umn.edu, Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/mdev: Fix reference count leak in add_mdev_supported_type.
Date:   Wed, 27 May 2020 21:01:09 -0500
Message-Id: <20200528020109.31664-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Thus,
replace kfree() by kobject_put() to fix this issue. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 8ad14e5c02bf..917fd84c1c6f 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 				   "%s-%s", dev_driver_string(parent->dev),
 				   group->name);
 	if (ret) {
-		kfree(type);
+		kobject_put(&type->kobj);
 		return ERR_PTR(ret);
 	}
 
-- 
2.17.1


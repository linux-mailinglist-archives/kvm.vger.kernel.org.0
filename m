Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBC4D8C20
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243910AbiCNTQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiCNTP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:15:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D00139688
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647285286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=z1uQSR/wU6/VDM/YhWDXbRd14pQqRJkq5gumoQhYWHI=;
        b=DAhIFaxh5SlgI8eRJm27sW58XxaCHA5IsdNJH72dm0f6BgcgJhtyVzWwaXUe/L/Z6kLHHh
        Rvht7YRK2sE6YX7rgerolPNFHd3Bzo4SlQ8hed69Ajm/vqYzAA13pnbJyCP1s+fo0W+MpG
        QIMtM7q0fYU3rZN44zt6gHKUsinVoiI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-oiA1B2uXPjO5QQ_skZsuxg-1; Mon, 14 Mar 2022 15:14:45 -0400
X-MC-Unique: oiA1B2uXPjO5QQ_skZsuxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D616811E7A;
        Mon, 14 Mar 2022 19:14:44 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.17.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4681EC28103;
        Mon, 14 Mar 2022 19:14:42 +0000 (UTC)
Subject: [PATCH v2] vfio-pci: Provide reviewers and acceptance criteria for
 vendor drivers
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net
Date:   Mon, 14 Mar 2022 13:14:41 -0600
Message-ID: <164728518026.40450.7442813673746870904.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vendor or device specific extensions for devices exposed to userspace
through the vfio-pci-core library open both new functionality and new
risks.  Here we attempt to provided formalized requirements and
expectations to ensure that future drivers both collaborate in their
interaction with existing host drivers, as well as receive additional
reviews from community members with experience in this area.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2:

Added Yishai

v1:

Per the proposal here[1], I've collected those that volunteered and
those that I interpreted as showing interest (alpha by last name).  For
those on the reviewers list below, please R-b/A-b to keep your name as a
reviewer.  More volunteers are still welcome, please let me know
explicitly; R-b/A-b will not be used to automatically add reviewers but
are of course welcome.  Thanks,

Alex

[1]https://lore.kernel.org/all/20220310134954.0df4bb12.alex.williamson@redhat.com/
 .../vfio/vfio-pci-vendor-driver-acceptance.rst     |   35 ++++++++++++++++++++
 MAINTAINERS                                        |   10 ++++++
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst

diff --git a/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
new file mode 100644
index 000000000000..3a108d748681
--- /dev/null
+++ b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Acceptance criteria for vfio-pci device specific driver variants
+================================================================
+
+Overview
+--------
+The vfio-pci driver exists as a device agnostic driver using the
+system IOMMU and relying on the robustness of platform fault
+handling to provide isolated device access to userspace.  While the
+vfio-pci driver does include some device specific support, further
+extensions for yet more advanced device specific features are not
+sustainable.  The vfio-pci driver has therefore split out
+vfio-pci-core as a library that may be reused to implement features
+requiring device specific knowledge, ex. saving and loading device
+state for the purposes of supporting migration.
+
+In support of such features, it's expected that some device specific
+variants may interact with parent devices (ex. SR-IOV PF in support of
+a user assigned VF) or other extensions that may not be otherwise
+accessible via the vfio-pci base driver.  Authors of such drivers
+should be diligent not to create exploitable interfaces via such
+interactions or allow unchecked userspace data to have an effect
+beyond the scope of the assigned device.
+
+New driver submissions are therefore requested to have approval via
+Sign-off/Acked-by/etc for any interactions with parent drivers.
+Additionally, drivers should make an attempt to provide sufficient
+documentation for reviewers to understand the device specific
+extensions, for example in the case of migration data, how is the
+device state composed and consumed, which portions are not otherwise
+available to the user via vfio-pci, what safeguards exist to validate
+the data, etc.  To that extent, authors should additionally expect to
+require reviews from at least one of the listed reviewers, in addition
+to the overall vfio maintainer.
diff --git a/MAINTAINERS b/MAINTAINERS
index 4322b5321891..7f6b14013412 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20314,6 +20314,16 @@ F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
 
+VFIO PCI VENDOR DRIVERS
+R:	Jason Gunthorpe <jgg@nvidia.com>
+R:	Yishai Hadas <yishaih@nvidia.com>
+R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
+R:	Kevin Tian <kevin.tian@intel.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+P:	Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
+F:	drivers/vfio/pci/*/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org



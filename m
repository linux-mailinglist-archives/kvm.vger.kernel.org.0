Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904194DA128
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345617AbiCORbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349378AbiCORbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:31:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A21D56C01
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647365408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pz5UPpl4j3XPTUhZRFMRyVJBOf0cLUBPAWfU9mPDU+A=;
        b=IkYLu4/4/nSJ7hRtLeTiRgOyNRbDh4ap53hwB3A2rsTJs1YR4zW9lotaID9vhze98uDmdA
        2v+oBa+gX+DtLScM3HMzCgi4pAvEdizTkwUx43BeSYEmxYQsU1+9UXSO1S+8YwdEs0nYFk
        vs382KrOHhCda7ZaxGxK8LeUmAkCJ8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-7kaFxLv5PjGJpW9ea0qqLg-1; Tue, 15 Mar 2022 13:30:03 -0400
X-MC-Unique: 7kaFxLv5PjGJpW9ea0qqLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA896106655A;
        Tue, 15 Mar 2022 17:30:02 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.17.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7309330B80;
        Tue, 15 Mar 2022 17:29:57 +0000 (UTC)
Subject: [PATCH v4] vfio-pci: Provide reviewers and acceptance criteria for
 variant drivers
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        hch@infradead.org
Date:   Tue, 15 Mar 2022 11:29:57 -0600
Message-ID: <164736509088.181560.2887686123582116702.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Device specific extensions for devices exposed to userspace through
the vfio-pci-core library open both new functionality and new risks.
Here we attempt to provided formalized requirements and expectations
to ensure that future drivers both collaborate in their interaction
with existing host drivers, as well as receive additional reviews
from community members with experience in this area.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Acked-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v4:

Banish the word "vendor", replace with "device specific"
Minor wording changes in docs file
Add sign-offs from Kevin and Yishai

I'll drop Jason from reviewers if there's no positive approval
after this round.

v3:

Relocate to Documentation/driver-api/
Include index.rst reference
Cross link from maintainer-entry-profile
Add Shameer's Ack

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

 Documentation/driver-api/index.rst                 |    1 +
 .../vfio-pci-device-specific-driver-acceptance.rst |   35 ++++++++++++++++++++
 .../maintainer/maintainer-entry-profile.rst        |    1 +
 MAINTAINERS                                        |   10 ++++++
 4 files changed, 47 insertions(+)
 create mode 100644 Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index c57c609ad2eb..a7b0223e2886 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -103,6 +103,7 @@ available subsections can be seen below.
    sync_file
    vfio-mediated-device
    vfio
+   vfio-pci-device-specific-driver-acceptance
    xilinx/index
    xillybus
    zorro
diff --git a/Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst b/Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
new file mode 100644
index 000000000000..b7b99b876b50
--- /dev/null
+++ b/Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
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
+should be diligent not to create exploitable interfaces via these
+interactions or allow unchecked userspace data to have an effect
+beyond the scope of the assigned device.
+
+New driver submissions are therefore requested to have approval via
+sign-off/ack/review/etc for any interactions with parent drivers.
+Additionally, drivers should make an attempt to provide sufficient
+documentation for reviewers to understand the device specific
+extensions, for example in the case of migration data, how is the
+device state composed and consumed, which portions are not otherwise
+available to the user via vfio-pci, what safeguards exist to validate
+the data, etc.  To that extent, authors should additionally expect to
+require reviews from at least one of the listed reviewers, in addition
+to the overall vfio maintainer.
diff --git a/Documentation/maintainer/maintainer-entry-profile.rst b/Documentation/maintainer/maintainer-entry-profile.rst
index 5d5cc3acdf85..93b2ae6c34a9 100644
--- a/Documentation/maintainer/maintainer-entry-profile.rst
+++ b/Documentation/maintainer/maintainer-entry-profile.rst
@@ -103,3 +103,4 @@ to do something different in the near future.
    ../nvdimm/maintainer-entry-profile
    ../riscv/patch-acceptance
    ../driver-api/media/maintainer-entry-profile
+   ../driver-api/vfio-pci-device-specific-driver-acceptance
diff --git a/MAINTAINERS b/MAINTAINERS
index 4322b5321891..fb71542c46d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20314,6 +20314,16 @@ F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
 
+VFIO PCI DEVICE SPECIFIC DRIVERS
+R:	Jason Gunthorpe <jgg@nvidia.com>
+R:	Yishai Hadas <yishaih@nvidia.com>
+R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
+R:	Kevin Tian <kevin.tian@intel.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+P:	Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
+F:	drivers/vfio/pci/*/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org



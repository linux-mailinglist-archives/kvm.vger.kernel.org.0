Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7534D88D8
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiCNQK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242896AbiCNQKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:10:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7A803E0C3
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647274153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eRrQObFUahcLPQZ/TYAwN/v6sVBzI0WsVdJ7+dwE/Wg=;
        b=Kd8o1baarO9Sgmk21ok2sH9Gp9igIzgdffOuhQOdDgUq57WAkJXWCodL4dy769iJrmsz/S
        OBSTcPK3m7Tykw8KuSKsavs9FOWzckET9T5n8am3H5a6w2flZlcxDY6eeaA+l4tHGPh9Zv
        jMVSGD4uxmHsd+ASTWLGaLWu42XGUv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-B0yzMFd_PC2rL0ngtCkrlw-1; Mon, 14 Mar 2022 12:09:09 -0400
X-MC-Unique: B0yzMFd_PC2rL0ngtCkrlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4084B833959;
        Mon, 14 Mar 2022 16:09:09 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.17.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9606F404C31A;
        Mon, 14 Mar 2022 16:09:08 +0000 (UTC)
Subject: [PATCH] vfio-pci: Provide reviewers and acceptance criteria for
 vendor drivers
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net
Date:   Mon, 14 Mar 2022 10:09:08 -0600
Message-ID: <164727326053.17467.1731353533389014796.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

Per the proposal here[1], I've collected those that volunteered and
those that I interpreted as showing interest (alpha by last name).  For
those on the reviewers list below, please R-b/A-b to keep your name as a
reviewer.  More volunteers are still welcome, please let me know
explicitly; R-b/A-b will not be used to automatically add reviewers but
are of course welcome.  Thanks,

Alex

[1]https://lore.kernel.org/all/20220310134954.0df4bb12.alex.williamson@redhat.com/

 .../vfio/vfio-pci-vendor-driver-acceptance.rst     |   35 ++++++++++++++++++++
 MAINTAINERS                                        |    9 +++++
 2 files changed, 44 insertions(+)
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
index 4322b5321891..7847b1492586 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20314,6 +20314,15 @@ F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
 
+VFIO PCI VENDOR DRIVERS
+R:	Jason Gunthorpe <jgg@nvidia.com>
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



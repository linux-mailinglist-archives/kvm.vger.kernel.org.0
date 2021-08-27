Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B363F9BEF
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245461AbhH0Pur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:50:47 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:13434 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244505AbhH0Puq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630079398; x=1661615398;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jM5HWpAgaAGUm0ZTlF5dSI4DfZdrcVUcl7z0PrVtwIc=;
  b=H1GS5T9NOnNfl3bJXhLGZ+eLDU3CTeItcnYosf7ZBsZ3C8V5mR7RmQG5
   WqKFXKU18mdnXgnTiwkBfAGR4yKb2zpcdJZ56ntojRPuNJ4HOAQsH2i8j
   o3HE3AvFPJ70XBrN+QX1JfH8R2P4vt9QMqUy8Pgj8dONqsTuwT9gp+hf7
   E=;
X-IronPort-AV: E=Sophos;i="5.84,357,1620691200"; 
   d="scan'208";a="132769059"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 27 Aug 2021 15:49:49 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 3D3161A54D8;
        Fri, 27 Aug 2021 15:49:48 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 15:49:41 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Alexandru Vasile" <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v3 0/7] nitro_enclaves: Add support for Arm64
Date:   Fri, 27 Aug 2021 18:49:23 +0300
Message-ID: <20210827154930.40608-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kernel config of the Nitro Enclaves kernel driver to enable Arm64
support. Add Arm64 specific references to its documentation.

While at it, fix a set of reports from checkpatch and kernel-doc scripts.

Thank you,
Andra

---

Patch Series Changelog

The patch series is built on top of v5.14-rc7.

GitHub repo branch for the latest version of the patch series:

* https://github.com/andraprs/linux/tree/ne-driver-arm-support-v3

v1 -> v2

* Add information about supported architectures for the NE kernel driver.
* Update comments for send / receive buffer sizes for the NE PCI device.
* Split patch 3 that includes fixes for the checkpatch and kernel-doc reports
  into multiple ones.
* v1: https://lore.kernel.org/lkml/20210826173451.93165-1-andraprs@amazon.com/

v2 -> v3

* Move changelog after the "---" line in all commits from the patch series.
* v2: https://lore.kernel.org/lkml/20210827133230.29816-1-andraprs@amazon.com/

---

Andra Paraschiv (7):
  nitro_enclaves: Enable Arm64 support
  nitro_enclaves: Update documentation for Arm64 support
  nitro_enclaves: Add fix for the kernel-doc report
  nitro_enclaves: Update copyright statement to include 2021
  nitro_enclaves: Add fixes for checkpatch match open parenthesis
    reports
  nitro_enclaves: Add fixes for checkpatch spell check reports
  nitro_enclaves: Add fixes for checkpatch blank line reports

 Documentation/virt/ne_overview.rst        | 21 +++++++++++++--------
 drivers/virt/nitro_enclaves/Kconfig       |  8 ++------
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  2 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  8 ++++++--
 include/uapi/linux/nitro_enclaves.h       | 10 +++++-----
 samples/nitro_enclaves/ne_ioctl_sample.c  |  7 +++----
 7 files changed, 39 insertions(+), 34 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


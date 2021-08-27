Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624AE3F9A36
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbhH0Ndl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 09:33:41 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:37225 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhH0Ndl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 09:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630071172; x=1661607172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zxYwY/HPK3XxwBzaETzcaS/QD3RxQ/CQo8EN3IHr37g=;
  b=pPsmEdWDxMJsAoa9SKBX3b5aL/wIdpsvA6wXvR5nAKOWD3dqVmEEGb+d
   yt7LVZnLkgE+QG19Lak6YeNA6mwXaHmnADtTFWlxBGQUf0yosZjjYoM2E
   /n0bApX61uDMtO5b0Hgwq5yBK7IyzhO1pk5z2QuwMEoEUorPS6PpFh8yo
   M=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="953537386"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Aug 2021 13:32:45 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 525B1A0717;
        Fri, 27 Aug 2021 13:32:45 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.176) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 13:32:38 +0000
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
Subject: [PATCH v2 0/7] nitro_enclaves: Add support for Arm64
Date:   Fri, 27 Aug 2021 16:32:23 +0300
Message-ID: <20210827133230.29816-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.161.176]
X-ClientProxiedBy: EX13d09UWA004.ant.amazon.com (10.43.160.158) To
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

* https://github.com/andraprs/linux/tree/ne-driver-arm-support-v2

v1 -> v2

* Add information about supported architectures for the NE kernel driver.
* Update comments for send / receive buffer sizes for the NE PCI device.
* Split patch 3 that includes fixes for the checkpatch and kernel-doc reports
  into multiple ones.
* v1: https://lore.kernel.org/lkml/20210826173451.93165-1-andraprs@amazon.com/

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


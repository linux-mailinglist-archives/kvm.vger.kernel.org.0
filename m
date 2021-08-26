Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E0F3F8D1F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhHZRgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:36:12 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:43685 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhHZRgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 13:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1629999324; x=1661535324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tf5R3X1W/IlvbJR/N4laWKcz9O54jmptu5JEWRORKko=;
  b=oZnScmPUoPVwMZhn5aQ87hBsxh0sAeoe19JhVWBjcaacmj+8j6yvmGF3
   Zn8tAsdMpRdP1GeUZ6LL1cmvo0dB31IT8qaA9gwBjNSdN+Vb318r5Ukro
   p7pPuGrGFB+f4LqEVweWAF1S6ZYDBf3UBRIffqzA+ZuEStIzx8C8YXh3k
   0=;
X-IronPort-AV: E=Sophos;i="5.84,354,1620691200"; 
   d="scan'208";a="22208295"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 26 Aug 2021 17:35:12 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id D9B0DC1DC6;
        Thu, 26 Aug 2021 17:35:08 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 26 Aug 2021 17:35:03 +0000
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
Subject: [PATCH v1 0/3] nitro_enclaves: Add support for Arm64
Date:   Thu, 26 Aug 2021 20:34:48 +0300
Message-ID: <20210826173451.93165-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D38UWC004.ant.amazon.com (10.43.162.204) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kernel config of the Nitro Enclaves kernel driver to enable Arm
support. Add Arm specific references to its documentation.

While at it, fix a set of reports from checkpatch and kernel-doc scripts.

Thank you,
Andra

---

Patch Series Changelog

The patch series is built on top of v5.14-rc7.

GitHub repo branch for the latest version of the patch series:

* https://github.com/andraprs/linux/tree/ne-driver-arm-support-v1

---

Andra Paraschiv (3):
  nitro_enclaves: Enable Arm support
  nitro_enclaves: Update documentation for Arm support
  nitro_enclaves: Add fixes for checkpatch and docs reports

 Documentation/virt/ne_overview.rst        |  8 +++++---
 drivers/virt/nitro_enclaves/Kconfig       |  8 ++------
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 17 +++++++++--------
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  2 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  8 ++++++--
 include/uapi/linux/nitro_enclaves.h       | 10 +++++-----
 samples/nitro_enclaves/ne_ioctl_sample.c  |  7 +++----
 7 files changed, 31 insertions(+), 29 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


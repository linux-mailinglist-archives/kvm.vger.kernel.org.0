Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DFC3F9BF3
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbhH0Pu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:50:57 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58551 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbhH0Pu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630079408; x=1661615408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=132fDTJVcUgyrb7oL8RLbS1a3enhEpPRNU/veMUkQ1E=;
  b=FH3V3x2L6RzehnitxpyGvtiznfrQk1dQAFpfXH/TE0em5J183DOg3mJS
   5U9qAcNcid/HjIloWr1OLpYE1i2jpWskPhcDBt2cxxMmxwX7AqRoQ6/iL
   rIEowwX15vxorIlco7jzwo79MnYQKax62lDMy0DnhLydR/IXFvQwdVBcz
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,357,1620691200"; 
   d="scan'208";a="135809672"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 27 Aug 2021 15:50:00 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id E6355A18A2;
        Fri, 27 Aug 2021 15:49:58 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 15:49:52 +0000
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
Subject: [PATCH v3 2/7] nitro_enclaves: Update documentation for Arm64 support
Date:   Fri, 27 Aug 2021 18:49:25 +0300
Message-ID: <20210827154930.40608-3-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210827154930.40608-1-andraprs@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.52]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add references for hugepages and booting steps for Arm64.

Include info about the current supported architectures for the
NE kernel driver.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v1 -> v2

* Add information about supported architectures for the NE kernel
driver.

v2 -> v3

* Move changelog after the "---" line.
---
 Documentation/virt/ne_overview.rst | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 39b0c8fe2654a..74c2f5919c886 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -14,12 +14,15 @@ instances [1].
 For example, an application that processes sensitive data and runs in a VM,
 can be separated from other applications running in the same VM. This
 application then runs in a separate VM than the primary VM, namely an enclave.
+It runs alongside the VM that spawned it. This setup matches low latency
+applications needs.
 
-An enclave runs alongside the VM that spawned it. This setup matches low latency
-applications needs. The resources that are allocated for the enclave, such as
-memory and CPUs, are carved out of the primary VM. Each enclave is mapped to a
-process running in the primary VM, that communicates with the NE driver via an
-ioctl interface.
+The current supported architectures for the NE kernel driver, available in the
+upstream Linux kernel, are x86 and ARM64.
+
+The resources that are allocated for the enclave, such as memory and CPUs, are
+carved out of the primary VM. Each enclave is mapped to a process running in the
+primary VM, that communicates with the NE kernel driver via an ioctl interface.
 
 In this sense, there are two components:
 
@@ -43,8 +46,8 @@ for the enclave VM. An enclave does not have persistent storage attached.
 The memory regions carved out of the primary VM and given to an enclave need to
 be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
 this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
-user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
-The enclave memory and CPUs need to be from the same NUMA node.
+user space [2][3][7]. The memory size for an enclave needs to be at least
+64 MiB. The enclave memory and CPUs need to be from the same NUMA node.
 
 An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
 available for the primary VM. A CPU pool has to be set for NE purposes by an
@@ -61,7 +64,7 @@ device is placed in memory below the typical 4 GiB.
 The application that runs in the enclave needs to be packaged in an enclave
 image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
 enclave VM. The enclave VM has its own kernel and follows the standard Linux
-boot protocol [6].
+boot protocol [6][8].
 
 The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
 Enclave Image Format (EIF); plus an EIF header including metadata such as magic
@@ -93,3 +96,5 @@ enclave process can exit.
 [4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
 [5] https://man7.org/linux/man-pages/man7/vsock.7.html
 [6] https://www.kernel.org/doc/html/latest/x86/boot.html
+[7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
+[8] https://www.kernel.org/doc/html/latest/arm64/booting.html
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


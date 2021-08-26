Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA73F8D23
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhHZRgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:36:20 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:47455 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243191AbhHZRgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 13:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1629999331; x=1661535331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jZKS2leLLiICe6MhvYhlq+VBXWbGj69GCZ6/vDcyL7E=;
  b=K4fsjKzZEu4WqqZHnzBo6/911Db7IMCZHfAEexSisrXN0v4j2QN2mgQk
   SIpYUf636zCMTiBon8YdGVs7HIZPxnoZStvsp3DNh8PextsgWHO5UpMkD
   wC4WVzWpNABHQDUio+6zSROKDqldSTBwgk3Sg3QVOuub8w9yn78kGrTGE
   E=;
X-IronPort-AV: E=Sophos;i="5.84,354,1620691200"; 
   d="scan'208";a="155388453"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 26 Aug 2021 17:35:23 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id F3D18A1D6A;
        Thu, 26 Aug 2021 17:35:20 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 26 Aug 2021 17:35:14 +0000
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
Subject: [PATCH v1 2/3] nitro_enclaves: Update documentation for Arm support
Date:   Thu, 26 Aug 2021 20:34:50 +0300
Message-ID: <20210826173451.93165-3-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210826173451.93165-1-andraprs@amazon.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D38UWC004.ant.amazon.com (10.43.162.204) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add references for hugepages and booting steps for Arm.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 Documentation/virt/ne_overview.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 39b0c8fe2654a..2777da1fb0ad1 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -43,8 +43,8 @@ for the enclave VM. An enclave does not have persistent storage attached.
 The memory regions carved out of the primary VM and given to an enclave need to
 be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
 this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
-user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
-The enclave memory and CPUs need to be from the same NUMA node.
+user space [2][3][7]. The memory size for an enclave needs to be at least
+64 MiB. The enclave memory and CPUs need to be from the same NUMA node.
 
 An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
 available for the primary VM. A CPU pool has to be set for NE purposes by an
@@ -61,7 +61,7 @@ device is placed in memory below the typical 4 GiB.
 The application that runs in the enclave needs to be packaged in an enclave
 image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
 enclave VM. The enclave VM has its own kernel and follows the standard Linux
-boot protocol [6].
+boot protocol [6][8].
 
 The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
 Enclave Image Format (EIF); plus an EIF header including metadata such as magic
@@ -93,3 +93,5 @@ enclave process can exit.
 [4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
 [5] https://man7.org/linux/man-pages/man7/vsock.7.html
 [6] https://www.kernel.org/doc/html/latest/x86/boot.html
+[7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
+[8] https://www.kernel.org/doc/html/latest/arm64/booting.html
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


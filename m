Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E8D204107
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgFVUGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:06:41 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:4349 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgFVUGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856399; x=1624392399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5NQtaTiMevcaQ+sp3fKL6TE/9DbvBIh3M7C7sH12mw=;
  b=qIwdiu3MDBUQHiIzFW2EvqbPcYsKC3oVUUZlnNrMK2JgevhIvpasX7RZ
   cBmqxTJJJGvq7rQ1WnS1KsSs5bzTh0BcDjt+u4+PdkRQOV+otNUfduD7i
   qIUFfrT8SMi+3ira6QotYaZQsQlyZuw8vwtfYhP91r5MooNDYrOLp2Flm
   0=;
IronPort-SDR: 8fiABPIzGo5kI0otC6kCGWFlYOdOAY7Zwkaiu4wmwh7i/2IYyUFZwEFn7pcV9EYdYrEbQOeV3Y
 pszAECsGKu7Q==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="37805355"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Jun 2020 20:06:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 4EA61A044E;
        Mon, 22 Jun 2020 20:06:36 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:06:35 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:06:27 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v4 17/18] nitro_enclaves: Add overview documentation
Date:   Mon, 22 Jun 2020 23:03:28 +0300
Message-ID: <20200622200329.52996-18-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Update doc type from .txt to .rst.
* Update documentation based on the changes from v4.

v2 -> v3

* No changes.

v1 -> v2

* New in v2.
---
 Documentation/nitro_enclaves/ne_overview.rst | 87 ++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/nitro_enclaves/ne_overview.rst

diff --git a/Documentation/nitro_enclaves/ne_overview.rst b/Documentation/nitro_enclaves/ne_overview.rst
new file mode 100644
index 000000000000..21b4ba932000
--- /dev/null
+++ b/Documentation/nitro_enclaves/ne_overview.rst
@@ -0,0 +1,87 @@
+Nitro Enclaves
+==============
+
+Nitro Enclaves (NE) is a new Amazon Elastic Compute Cloud (EC2) capability
+that allows customers to carve out isolated compute environments within EC2
+instances [1].
+
+For example, an application that processes sensitive data and runs in a VM,
+can be separated from other applications running in the same VM. This
+application then runs in a separate VM than the primary VM, namely an enclave.
+
+An enclave runs alongside the VM that spawned it. This setup matches low latency
+applications needs. The resources that are allocated for the enclave, such as
+memory and CPU, are carved out of the primary VM. Each enclave is mapped to a
+process running in the primary VM, that communicates with the NE driver via an
+ioctl interface.
+
+In this sense, there are two components:
+
+1. An enclave abstraction process - a user space process running in the primary
+VM guest  that uses the provided ioctl interface of the NE driver to spawn an
+enclave VM (that's 2 below).
+
+There is a NE emulated PCI device exposed to the primary VM. The driver for this
+new PCI device is included in the NE driver.
+
+The ioctl logic is mapped to PCI device commands e.g. the NE_START_ENCLAVE ioctl
+maps to an enclave start PCI command. The PCI device commands are then
+translated into  actions taken on the hypervisor side; that's the Nitro
+hypervisor running on the host where the primary VM is running. The Nitro
+hypervisor is based on core KVM technology.
+
+2. The enclave itself - a VM running on the same host as the primary VM that
+spawned it. Memory and CPUs are carved out of the primary VM and are dedicated
+for the enclave VM. An enclave does not have persistent storage attached.
+
+The memory regions carved out of the primary VM and given to an enclave need to
+be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
+this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
+user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
+The enclave memory and CPUs need to be from the same NUMA node.
+
+An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
+available for the primary VM. A CPU pool has to be set for NE purposes by an
+user with admin capability. See the cpu list section from the kernel
+documentation [4] for how a CPU pool format looks.
+
+An enclave communicates with the primary VM via a local communication channel,
+using virtio-vsock [5]. The primary VM has virtio-pci vsock emulated device,
+while the enclave VM has a virtio-mmio vsock emulated device. The vsock device
+uses eventfd for signaling. The enclave VM sees the usual interfaces - local
+APIC and IOAPIC - to get interrupts from virtio-vsock device. The virtio-mmio
+device is placed in memory below the typical 4 GiB.
+
+The application that runs in the enclave needs to be packaged in an enclave
+image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
+enclave VM. The enclave VM has its own kernel and follows the standard Linux
+boot protocol.
+
+The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
+Enclave Image Format (EIF); plus an EIF header including metadata such as magic
+number, eif version, image size and CRC.
+
+Hash values are computed for the entire enclave image (EIF), the kernel and
+ramdisk(s). That's used, for example, to check that the enclave image that is
+loaded in the enclave VM is the one that was intended to be run.
+
+These crypto measurements are included in a signed attestation document
+generated by the Nitro Hypervisor and further used to prove the identity of the
+enclave; KMS is an example of service that NE is integrated with and that checks
+the attestation doc.
+
+The enclave image (EIF) is loaded in the enclave memory at offset 8 MiB. The
+init process in the enclave connects to the vsock CID of the primary VM and a
+predefined port - 9000 - to send a heartbeat value - 0xb7. This mechanism is
+used to check in the primary VM that the enclave has booted.
+
+If the enclave VM crashes or gracefully exits, an interrupt event is received by
+the NE driver. This event is sent further to the user space enclave process
+running in the primary VM via a poll notification mechanism. Then the user space
+enclave process can exit.
+
+[1] https://aws.amazon.com/ec2/nitro/nitro-enclaves/
+[2] https://www.kernel.org/doc/Documentation/vm/hugetlbpage.txt
+[3] https://lwn.net/Articles/807108/
+[4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
+[5] https://man7.org/linux/man-pages/man7/vsock.7.html
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


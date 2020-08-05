Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A5C23C8EE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHEJOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:14:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:17102 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbgHEJNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618812; x=1628154812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9/Q4bajHeIOI+qTC1FyiXHBmKemabTCT0826vPyU9hU=;
  b=FcSHxZfVykoRPEhWRo+aKfZJTkVnJC7mXonnGdSXZ9uHgtwWI96wur7I
   AOsFUB6Fc3x0l4IKkRC5CUkLz69z4xubRqxvhrcBuhZn/alW/RlG2sEFg
   OX2tKv8wkLfHXEXz34TpASdgM0xLhUavIOBLZzKCvOPjyPGXWQx+BUnoE
   o=;
IronPort-SDR: Kd/hvwUI7U6M6OILOuOI+lvShd1MuvwC8pKrveoLSTdyaaFhK61/ZNOhxMKNUPsUppbsRAf5mQ
 XSVP89RLIILA==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="57531168"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 Aug 2020 09:13:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 10807A282F;
        Wed,  5 Aug 2020 09:13:31 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:13:30 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.192) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:13:20 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v6 17/18] nitro_enclaves: Add overview documentation
Date:   Wed, 5 Aug 2020 12:10:16 +0300
Message-ID: <20200805091017.86203-18-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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

v5 -> v6

* No changes.

v4 -> v5

* No changes.

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
index 000000000000..9cc7a2720955
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
+memory and CPUs, are carved out of the primary VM. Each enclave is mapped to a
+process running in the primary VM, that communicates with the NE driver via an
+ioctl interface.
+
+In this sense, there are two components:
+
+1. An enclave abstraction process - a user space process running in the primary
+VM guest that uses the provided ioctl interface of the NE driver to spawn an
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


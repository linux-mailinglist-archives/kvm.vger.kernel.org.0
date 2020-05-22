Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD631DDFF8
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgEVGcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:32:52 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:41619 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgEVGcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129171; x=1621665171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q2uQ4KONMuRjyhlvAaG5QSJTMRYNPu4HnVm7hH7LvkA=;
  b=LSsIGhBx76m7eNX0r5r9l04KJi20M6+g5Lfocz+qjd7mIiSpVvBcQ5Q2
   GnxSOoSNEq6m8x2scTUVWfOWLa/51eEdSURq2gxf2B+cRAbfcjQIVVUg5
   N5jMe844B34y3aUfaLniHF7mwVvxRBWke9h83oDh0hPoLOylPShOx24F0
   I=;
IronPort-SDR: wUxGTDuEzdIPxsYGPggLv9Uk322dLEDlIZN9vSgVlYZEQkrwXfMZuMIINoaTv5W0jJHvD2r8s7
 c+w9+5pfhApw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="45244417"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 06:32:50 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 10EB2A236E;
        Fri, 22 May 2020 06:32:48 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:47 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:32:38 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v2 17/18] nitro_enclaves: Add overview documentation
Date:   Fri, 22 May 2020 09:29:45 +0300
Message-ID: <20200522062946.28973-18-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 Documentation/nitro_enclaves/ne_overview.txt | 86 ++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 Documentation/nitro_enclaves/ne_overview.txt

diff --git a/Documentation/nitro_enclaves/ne_overview.txt b/Documentation/nitro_enclaves/ne_overview.txt
new file mode 100644
index 000000000000..be8bb3d84132
--- /dev/null
+++ b/Documentation/nitro_enclaves/ne_overview.txt
@@ -0,0 +1,86 @@
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
+How does all gets to an enclave VM running on the host?
+
+There is a NE emulated PCI device exposed to the primary VM. The driver for this
+new PCI device is included in the NE driver.
+
+The ioctl logic is mapped to PCI device commands e.g. the NE_START_ENCLAVE ioctl
+maps to an enclave start PCI command or the KVM_SET_USER_MEMORY_REGION maps to
+an add memory PCI command. The PCI device commands are then translated into
+actions taken on the hypervisor side; that's the Nitro hypervisor running on the
+host where the primary VM is running. The Nitro hypervisor is based on core KVM
+technology.
+
+2. The enclave itself - a VM running on the same host as the primary VM that
+spawned it. Memory and CPUs are carved out of the primary VM and are dedicated
+for the enclave VM. An enclave does not have persistent storage attached.
+
+An enclave communicates with the primary VM via a local communication channel,
+using virtio-vsock [2]. The primary VM has virtio-pci vsock emulated device,
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
+The NE driver for enclave lifetime management provides an ioctl interface to the
+user space. It includes the NE PCI device driver that is the means of
+communication with the hypervisor running on the host where the primary VM and
+the enclave are launched.
+
+The proposed solution is following the KVM model and uses KVM ioctls to be able
+to create and set resources for enclaves. Additional NE ioctl commands, besides
+the ones provided by KVM, are used to start an enclave and get memory offset for
+in-memory enclave image loading.
+
+[1] https://aws.amazon.com/ec2/nitro/nitro-enclaves/
+[2] http://man7.org/linux/man-pages/man7/vsock.7.html
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.


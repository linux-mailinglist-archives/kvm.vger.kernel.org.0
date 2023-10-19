Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9257CFE37
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346430AbjJSPlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346360AbjJSPlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7AC124
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DyY8I/ZKbCu/w/L7sfs0qQaOI3alzNFdd8No8uZAwJY=; b=poV1WGsApzadUT0xdj1lGj07Ks
        IIjmyFgyyhHHCCa4ppA7c3EQcnUM8KZHHQBeW/ta/PnFbfeVmW8WJYyEFhxgqunegGZQFI7xbD1/7
        fPB4Yk2ZzuW8AcHkoFs3T9n+3rkqi+i8aAB+lpJyNQkcsIVG+tH0I8kSL4/8hilNGyqXxt4nKc4F2
        1VYruLsoyPt9sV7drShBs2y4THHGaJUyrvKdv6jl+1jv58sLf+4BCkRLWbDjZmOpshREMjTG1A2K+
        gLfK01j5TZVqkaR5DV0hssWj6h3UaFyg+QWj3v0veF2O6ukerNiljYRn81Xjatg7EQZWYHHVwm/lz
        kfBK08xg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8O-009yD7-0P;
        Thu, 19 Oct 2023 15:40:28 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8N-000PvR-1m;
        Thu, 19 Oct 2023 16:40:27 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v2 24/24] docs: update Xen-on-KVM documentation
Date:   Thu, 19 Oct 2023 16:40:20 +0100
Message-Id: <20231019154020.99080-25-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Add notes about console and network support, and how to launch PV guests.
Clean up the disk configuration examples now that that's simpler, and
remove the comment about IDE unplug on q35/AHCI now that it's fixed.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 docs/system/i386/xen.rst | 100 ++++++++++++++++++++++++++++-----------
 1 file changed, 72 insertions(+), 28 deletions(-)

diff --git a/docs/system/i386/xen.rst b/docs/system/i386/xen.rst
index f06765e88c..6214c4571e 100644
--- a/docs/system/i386/xen.rst
+++ b/docs/system/i386/xen.rst
@@ -15,46 +15,24 @@ Setup
 -----
 
 Xen mode is enabled by setting the ``xen-version`` property of the KVM
-accelerator, for example for Xen 4.10:
+accelerator, for example for Xen 4.17:
 
 .. parsed-literal::
 
-  |qemu_system| --accel kvm,xen-version=0x4000a,kernel-irqchip=split
+  |qemu_system| --accel kvm,xen-version=0x40011,kernel-irqchip=split
 
 Additionally, virtual APIC support can be advertised to the guest through the
 ``xen-vapic`` CPU flag:
 
 .. parsed-literal::
 
-  |qemu_system| --accel kvm,xen-version=0x4000a,kernel-irqchip=split --cpu host,+xen_vapic
+  |qemu_system| --accel kvm,xen-version=0x40011,kernel-irqchip=split --cpu host,+xen-vapic
 
 When Xen support is enabled, QEMU changes hypervisor identification (CPUID
 0x40000000..0x4000000A) to Xen. The KVM identification and features are not
 advertised to a Xen guest. If Hyper-V is also enabled, the Xen identification
 moves to leaves 0x40000100..0x4000010A.
 
-The Xen platform device is enabled automatically for a Xen guest. This allows
-a guest to unplug all emulated devices, in order to use Xen PV block and network
-drivers instead. Under Xen, the boot disk is typically available both via IDE
-emulation, and as a PV block device. Guest bootloaders typically use IDE to load
-the guest kernel, which then unplugs the IDE and continues with the Xen PV block
-device.
-
-This configuration can be achieved as follows
-
-.. parsed-literal::
-
-  |qemu_system| -M pc --accel kvm,xen-version=0x4000a,kernel-irqchip=split \\
-       -drive file=${GUEST_IMAGE},if=none,id=disk,file.locking=off -device xen-disk,drive=disk,vdev=xvda \\
-       -drive file=${GUEST_IMAGE},index=2,media=disk,file.locking=off,if=ide
-
-It is necessary to use the pc machine type, as the q35 machine uses AHCI instead
-of legacy IDE, and AHCI disks are not unplugged through the Xen PV unplug
-mechanism.
-
-VirtIO devices can also be used; Linux guests may need to be dissuaded from
-umplugging them by adding 'xen_emul_unplug=never' on their command line.
-
 Properties
 ----------
 
@@ -63,7 +41,10 @@ The following properties exist on the KVM accelerator object:
 ``xen-version``
   This property contains the Xen version in ``XENVER_version`` form, with the
   major version in the top 16 bits and the minor version in the low 16 bits.
-  Setting this property enables the Xen guest support.
+  Setting this property enables the Xen guest support. If Xen version 4.5 or
+  greater is specified, the HVM leaf in Xen CPUID is populated. Xen version
+  4.6 enables the vCPU ID in CPUID, and version 4.17 advertises vCPU upcall
+  vector support to the guest.
 
 ``xen-evtchn-max-pirq``
   Xen PIRQs represent an emulated physical interrupt, either GSI or MSI, which
@@ -83,8 +64,71 @@ The following properties exist on the KVM accelerator object:
   through simultaneous grants. For guests with large numbers of PV devices and
   high throughput, it may be desirable to increase this value.
 
-OS requirements
----------------
+Xen paravirtual devices
+-----------------------
+
+The Xen PCI platform device is enabled automatically for a Xen guest. This
+allows a guest to unplug all emulated devices, in order to use paravirtual
+block and network drivers instead.
+
+Those paravirtual Xen block, network (and console) devices can be created
+through the command line, and/or hot-plugged.
+
+To provide a Xen console device, define a character device and then a device
+of type ``xen-console`` to connect to it. For the Xen console equivalent of
+the handy ``-serial mon:stdio`` option, for example:
+
+.. parsed-literal::
+   -chardev -chardev stdio,mux=on,id=char0,signal=off -mon char0 \\
+   -device xen-console,chardev=char0
+
+The Xen network device is ``xen-net-device``, which becomes the default NIC
+model for emulated Xen guests, meaning that just the default ``-nic user``
+should automatically work and present a Xen network device to the guest.
+
+Disks can be configured with '``-drive file=${GUEST_IMAGE},if=xen``' and will
+appear to the guest as ``xvda`` onwards.
+
+Under Xen, the boot disk is typically available both via IDE emulation, and
+as a PV block device. Guest bootloaders typically use IDE to load the guest
+kernel, which then unplugs the IDE and continues with the Xen PV block device.
+
+This configuration can be achieved as follows:
+
+.. parsed-literal::
+
+  |qemu_system| --accel kvm,xen-version=0x40011,kernel-irqchip=split \\
+       -drive file=${GUEST_IMAGE},if=xen \\
+       -drive file=${GUEST_IMAGE},file.locking=off,if=ide
+
+VirtIO devices can also be used; Linux guests may need to be dissuaded from
+umplugging them by adding '``xen_emul_unplug=never``' on their command line.
+
+Booting Xen PV guests
+---------------------
+
+Booting PV guest kernels is possible by using the Xen PV shim (a version of Xen
+itself, designed to run inside a Xen HVM guest and provide memory management
+services for one guest alone).
+
+The Xen binary is provided as the ``-kernel`` and the guest kernel itself (or
+PV Grub image) as the ``-initrd`` image, which actually just means the first
+multiboot "module". For example:
+
+.. parsed-literal::
+
+  |qemu_system| --accel kvm,xen-version=0x40011,kernel-irqchip=split \\
+       -chardev stdio,id=char0 -device xen-console,chardev=char0 \\
+       -display none  -m 1G  -kernel xen -initrd bzImage \\
+       -append "pv-shim console=xen,pv -- console=hvc0 root=/dev/xvda1" \\
+       -drive file=${GUEST_IMAGE},if=xen
+
+The Xen image must be built with the ``CONFIG_XEN_GUEST`` and ``CONFIG_PV_SHIM``
+options, and as of Xen 4.17, Xen's PV shim mode does not support using a serial
+port; it must have a Xen console or it will panic.
+
+Host OS requirements
+--------------------
 
 The minimal Xen support in the KVM accelerator requires the host to be running
 Linux v5.12 or newer. Later versions add optimisations: Linux v5.17 added
-- 
2.40.1


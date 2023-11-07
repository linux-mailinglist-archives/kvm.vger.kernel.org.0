Return-Path: <kvm+bounces-857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A22B27E37C2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56DAE280F54
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185622D034;
	Tue,  7 Nov 2023 09:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+6KCPtf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97529414
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:22:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA43110A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ucdObmILc+svUFlf4s5gX1kFp4HY4wFKGOFMUEIZPls=; b=m+6KCPtfywuMzy0JoQbV+w7wmx
	f7rodZuTJgm0KJbtmp/wN+QtcVXg+E8CDbH9YBcHNyNsPTeHgHjGttf72Y5StBlCBkJeFuJKeJGXb
	cl9bQVwLyEbA2dkQiy/UIc8G8lw7//JhMhp6ofCqa2KKM8uNoJimYu3m+xyrv2zXcGKrY/EhpQuvB
	C0PHzW/axS3b2NdJD9/M0JoZOkny5KUgMK+k5qEvWgypdKO1FtPt97zCe1s88WY1PEioJciMuFWP8
	6DxNZS0fu17GIhvk7inm5TktSxQGHv4u7H/pOcO5ddtUJ2cFCVuvdzOOQYUlMSgJqol+xfuGi5f5t
	SewKbTpw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0IHN-00BPkH-8E; Tue, 07 Nov 2023 09:21:50 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1r0IHN-001hJr-1M;
	Tue, 07 Nov 2023 09:21:49 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-block@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org
Subject: [PULL 00/15] xenfv.for-upstream queue
Date: Tue,  7 Nov 2023 09:21:32 +0000
Message-ID: <20231107092149.404842-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The following changes since commit 8aba939e77daca10eac99d9d467f65ba7df5ab3e:

  Merge tag 'pull-riscv-to-apply-20231107' of https://github.com/alistair23/qemu into staging (2023-11-07 11:08:16 +0800)

are available in the Git repository at:

  git://git.infradead.org/users/dwmw2/qemu.git tags/pull-xenfv.for-upstream-20231107

for you to fetch changes up to cc9d10b9e89f0325c1a14955534d6b28ea586fba:

  docs: update Xen-on-KVM documentation (2023-11-07 08:58:02 +0000)

----------------------------------------------------------------
Xen PV guest support for 8.2

Add Xen PV console and network support, the former of which enables the
Xen "PV shim" to be used to support PV guests.

Also clean up the block support and make it work when the user passes
just 'drive file=IMAGE,if=xen' on the command line.

Update the documentation to reflect all of these, taking the opportunity
to simplify what it says about q35 by making unplug work for AHCI.

Ignore the VCPU_SSHOTTMR_future timer flag, and advertise the 'fixed'
per-vCPU upcall vector support, as newer upstream Xen do.

----------------------------------------------------------------
David Woodhouse (15):
      i386/xen: Ignore VCPU_SSHOTTMR_future flag in set_singleshot_timer()
      hw/xen: Clean up event channel 'type_val' handling to use union
      include: update Xen public headers to Xen 4.17.2 release
      i386/xen: advertise XEN_HVM_CPUID_UPCALL_VECTOR in CPUID
      hw/xen: populate store frontend nodes with XenStore PFN/port
      hw/xen: automatically assign device index to block devices
      hw/xen: add get_frontend_path() method to XenDeviceClass
      hw/xen: do not repeatedly try to create a failing backend device
      hw/xen: update Xen console to XenDevice model
      hw/xen: add support for Xen primary console in emulated mode
      hw/xen: only remove peers of PCI NICs on unplug
      hw/xen: update Xen PV NIC to XenDevice model
      hw/i386/pc: support '-nic' for xen-net-device
      xen-platform: unplug AHCI disks
      docs: update Xen-on-KVM documentation

 MAINTAINERS                                    |   2 +-
 blockdev.c                                     |  15 +-
 docs/system/i386/xen.rst                       | 107 +++--
 hw/block/xen-block.c                           | 118 ++++-
 hw/char/trace-events                           |   8 +
 hw/char/xen_console.c                          | 572 +++++++++++++++++++------
 hw/i386/kvm/meson.build                        |   1 +
 hw/i386/kvm/trace-events                       |   2 +
 hw/i386/kvm/xen-stubs.c                        |   8 +
 hw/i386/kvm/xen_evtchn.c                       | 151 +++----
 hw/i386/kvm/xen_gnttab.c                       |   7 +-
 hw/i386/kvm/xen_primary_console.c              | 193 +++++++++
 hw/i386/kvm/xen_primary_console.h              |  23 +
 hw/i386/kvm/xen_xenstore.c                     |  23 +-
 hw/i386/pc.c                                   |  11 +-
 hw/i386/pc_piix.c                              |   2 +-
 hw/i386/pc_q35.c                               |   2 +-
 hw/i386/xen/xen_platform.c                     |  77 ++--
 hw/net/meson.build                             |   2 +-
 hw/net/trace-events                            |  11 +
 hw/net/xen_nic.c                               | 484 ++++++++++++++++-----
 hw/xen/xen-backend.c                           |  27 +-
 hw/xen/xen-bus.c                               |  23 +-
 hw/xen/xen-legacy-backend.c                    |   1 -
 hw/xen/xen_devconfig.c                         |  28 --
 hw/xenpv/xen_machine_pv.c                      |  10 -
 include/hw/i386/pc.h                           |   4 +-
 include/hw/xen/interface/arch-arm.h            |  37 +-
 include/hw/xen/interface/arch-x86/cpuid.h      |  31 +-
 include/hw/xen/interface/arch-x86/xen-x86_32.h |  19 +-
 include/hw/xen/interface/arch-x86/xen-x86_64.h |  19 +-
 include/hw/xen/interface/arch-x86/xen.h        |  26 +-
 include/hw/xen/interface/event_channel.h       |  19 +-
 include/hw/xen/interface/features.h            |  19 +-
 include/hw/xen/interface/grant_table.h         |  19 +-
 include/hw/xen/interface/hvm/hvm_op.h          |  19 +-
 include/hw/xen/interface/hvm/params.h          |  19 +-
 include/hw/xen/interface/io/blkif.h            |  27 +-
 include/hw/xen/interface/io/console.h          |  19 +-
 include/hw/xen/interface/io/fbif.h             |  19 +-
 include/hw/xen/interface/io/kbdif.h            |  19 +-
 include/hw/xen/interface/io/netif.h            |  25 +-
 include/hw/xen/interface/io/protocols.h        |  19 +-
 include/hw/xen/interface/io/ring.h             |  49 +--
 include/hw/xen/interface/io/usbif.h            |  19 +-
 include/hw/xen/interface/io/xenbus.h           |  19 +-
 include/hw/xen/interface/io/xs_wire.h          |  36 +-
 include/hw/xen/interface/memory.h              |  30 +-
 include/hw/xen/interface/physdev.h             |  23 +-
 include/hw/xen/interface/sched.h               |  19 +-
 include/hw/xen/interface/trace.h               |  19 +-
 include/hw/xen/interface/vcpu.h                |  19 +-
 include/hw/xen/interface/version.h             |  19 +-
 include/hw/xen/interface/xen-compat.h          |  19 +-
 include/hw/xen/interface/xen.h                 |  19 +-
 include/hw/xen/xen-backend.h                   |   1 +
 include/hw/xen/xen-bus.h                       |   5 +-
 include/hw/xen/xen-legacy-backend.h            |   1 -
 qemu-options.hx                                |  12 +-
 target/i386/kvm/kvm.c                          |   4 +
 target/i386/kvm/xen-emu.c                      |  43 +-
 61 files changed, 1640 insertions(+), 983 deletions(-)
 create mode 100644 hw/i386/kvm/xen_primary_console.c
 create mode 100644 hw/i386/kvm/xen_primary_console.h


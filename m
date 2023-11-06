Return-Path: <kvm+bounces-653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67ED47E1EA0
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5A49B20C45
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B111A72A;
	Mon,  6 Nov 2023 10:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HsrZzoi7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641EC1A701
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:34 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA07DB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8hFASJ6FJkP5+9JiryopkqrFh+wE1Upzc1d8akCwXKw=; b=HsrZzoi7oxWmojvdJbVOfncH0N
	LbE/oaY1cF3jW518bYSyd7CXECURPhDuOuFEE8NyoL8eFV3GGox+Hzctzdk+/TrfqieRU1enW9yFr
	9QS6NRkLSjfqmAQLbcdxS3Gb1+iD4xJilLEbyoaeMSg2pJ4JawL966SDpIEVrq04r+qmKAXrLxj4e
	ZX45hY+bYHsbjDE//upJSGdIXJBW9tqgCeakGBy0fTLvjj0NoQi92EG8h6lsFZHgKf7HrBEqMiegB
	Myb8iENcsbB7PG7qHQYJleGczojpxfri7o1i2f3titfD/eMwazbQ+Pf+kPbTTzWI8D2JtXw0NnvD8
	By83/WAw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qzx1R-00ARzt-0U;
	Mon, 06 Nov 2023 10:39:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1P-000qFu-2O;
	Mon, 06 Nov 2023 10:39:55 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	qemu-stable@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 0/7] xenfv-stable queue
Date: Mon,  6 Nov 2023 10:39:48 +0000
Message-ID: <20231106103955.200867-1-dwmw2@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

The following changes since commit d762bf97931b58839316b68a570eecc6143c9e3e:

  Merge tag 'pull-target-arm-20231102' of https://git.linaro.org/people/pmaydell/qemu-arm into staging (2023-11-03 10:04:12 +0800)

are available in the Git repository at:

  git://git.infradead.org/users/dwmw2/qemu.git tags/pull-xenfv-stable-20231106

for you to fetch changes up to a1c1082908dde4867b1ac55f546bea0c17d52318:

  hw/xen: use correct default protocol for xen-block on x86 (2023-11-06 10:03:45 +0000)

----------------------------------------------------------------
Bugfixes for emulated Xen support

Selected bugfixes for mainline and stable, especially to the per-vCPU
local APIC vector delivery mode for event channel notifications, which
was broken in a number of ways.

The xen-block driver has been defaulting to the wrong protocol for x86
guest, and this fixes that — which is technically an incompatible change
but I'm fairly sure nobody relies on the broken behaviour (and in
production I *have* seen guests which rely on the correct behaviour,
which now matches the blkback driver in the Linux kernel).

A handful of other simple fixes for issues which came to light as new
features (qv) were being developed.

----------------------------------------------------------------
David Woodhouse (7):
      i386/xen: Don't advertise XENFEAT_supervisor_mode_kernel
      i386/xen: fix per-vCPU upcall vector for Xen emulation
      hw/xen: select kernel mode for per-vCPU event channel upcall vector
      hw/xen: don't clear map_track[] in xen_gnttab_reset()
      hw/xen: fix XenStore watch delivery to guest
      hw/xen: take iothread mutex in xen_evtchn_reset_op()
      hw/xen: use correct default protocol for xen-block on x86

 hw/block/xen-block.c       | 10 +++++++---
 hw/i386/kvm/xen_evtchn.c   |  7 +++++++
 hw/i386/kvm/xen_gnttab.c   |  2 --
 hw/i386/kvm/xen_xenstore.c |  8 +++++---
 include/sysemu/kvm_xen.h   |  1 +
 target/i386/kvm/xen-emu.c  | 16 +++++++++++-----
 6 files changed, 31 insertions(+), 13 deletions(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E81D603D
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgEPKLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:11:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:36845 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgEPKLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:11:12 -0400
IronPort-SDR: 0SRmrP/0Mpcx1779BeoB8gcYhmnBJfKz49nlAPjHO4RRvZS2l64UU/1k9U3PXl3pyq2ksZ+383
 LikHoqsDmtQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:11:11 -0700
IronPort-SDR: 03dWaqsXdpDzWN7Oa9pHZFvzEXoel2BZjYmTkqM5J2N8WtgYMyReHi5yTPeYZmgzllhSVKj+Tp
 UUy0h0BGJzRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281484323"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 03:11:10 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH 0/6] Add a vhost RPMsg API
Date:   Sat, 16 May 2020 12:11:03 +0200
Message-Id: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux supports RPMsg over VirtIO for "remote processor" /AMP use
cases. It can however also be used for virtualisation scenarios,
e.g. when using KVM to run Linux on both the host and the guests.
This patch set adds a wrapper API to facilitate writing vhost
drivers for such RPMsg-based solutions. The first use case is an
audio DSP virtualisation project, currently under development, ready
for review and submission, available at
https://github.com/thesofproject/linux/pull/1501/commits
A further patch for the ADSP vhost RPMsg driver will be sent
separately for review only since it cannot be merged without audio
patches being upstreamed first.

Thanks
Guennadi

Guennadi Liakhovetski (6):
  vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
  vhost: (cosmetic) remove a superfluous variable initialisation
  rpmsg: move common structures and defines to headers
  rpmsg: update documentation
  vhost: add an rpmsg API
  rpmsg: add a device ID to also bind to the ADSP device

 Documentation/rpmsg.txt          |   2 +-
 drivers/rpmsg/virtio_rpmsg_bus.c |  79 +--------
 drivers/vhost/Kconfig            |   8 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/rpmsg.c            | 372 +++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c            |   2 +-
 drivers/vhost/vhost_rpmsg.h      |  74 ++++++++
 include/linux/virtio_rpmsg.h     |  81 +++++++++
 include/uapi/linux/rpmsg.h       |   3 +
 include/uapi/linux/vhost.h       |   4 +-
 10 files changed, 549 insertions(+), 79 deletions(-)
 create mode 100644 drivers/vhost/rpmsg.c
 create mode 100644 drivers/vhost/vhost_rpmsg.h
 create mode 100644 include/linux/virtio_rpmsg.h

-- 
1.9.3


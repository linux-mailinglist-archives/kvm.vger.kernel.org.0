Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7544264564
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgIJLhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 07:37:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:26476 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgIJLOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 07:14:40 -0400
IronPort-SDR: 7KUKGb/2324GcA35o8NX9pdty2hZB4oQBpCboVdd/KGcEtRu4JXXpPmQIC/9Bwo815ZQvoQC1H
 ulsFmZqpxQaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="176571446"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="176571446"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 04:14:01 -0700
IronPort-SDR: wVpIj/zGXtQNpFmAtAkeu91MGzSCLz/mzpLVf5KGOI2rCOahfd+o78fB05ua33jwPqEYLvwIqf
 lsXS7DYoJQ1w==
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="286530910"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.39.14])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 04:13:58 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH v7 0/3] Add a vhost RPMsg API
Date:   Thu, 10 Sep 2020 13:13:48 +0200
Message-Id: <20200910111351.20526-1-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Next update:

v7:
- remove documentation update to be send separately
- address comments from Mathieu Poirier (thanks)

v6:
- rename include/linux/virtio_rpmsg.h -> include/linux/rpmsg/virtio.h

v5:
- don't hard-code message layout

v4:
- add endianness conversions to comply with the VirtIO standard

v3:
- address several checkpatch warnings
- address comments from Mathieu Poirier

v2:
- update patch #5 with a correct vhost_dev_init() prototype
- drop patch #6 - it depends on a different patch, that is currently
  an RFC
- address comments from Pierre-Louis Bossart:
  * remove "default n" from Kconfig

Linux supports RPMsg over VirtIO for "remote processor" / AMP use
cases. It can however also be used for virtualisation scenarios,
e.g. when using KVM to run Linux on both the host and the guests.
This patch set adds a wrapper API to facilitate writing vhost
drivers for such RPMsg-based solutions. The first use case is an
audio DSP virtualisation project, currently under development, ready
for review and submission, available at
https://github.com/thesofproject/linux/pull/1501/commits

Thanks
Guennadi

Guennadi Liakhovetski (3):
  vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
  rpmsg: move common structures and defines to headers
  vhost: add an RPMsg API

 drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
 drivers/vhost/Kconfig            |   7 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/rpmsg.c            | 370 +++++++++++++++++++++++++++++++
 drivers/vhost/vhost_rpmsg.h      |  74 +++++++
 include/linux/rpmsg/virtio.h     |  83 +++++++
 include/uapi/linux/rpmsg.h       |   3 +
 include/uapi/linux/vhost.h       |   4 +-
 8 files changed, 545 insertions(+), 77 deletions(-)
 create mode 100644 drivers/vhost/rpmsg.c
 create mode 100644 drivers/vhost/vhost_rpmsg.h
 create mode 100644 include/linux/rpmsg/virtio.h

-- 
2.28.0


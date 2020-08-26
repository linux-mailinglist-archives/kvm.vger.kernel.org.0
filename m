Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADA253617
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 19:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgHZRql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 13:46:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:49544 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgHZRqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 13:46:40 -0400
IronPort-SDR: gpce1UmP34tPutiLd6xAsI70/cckO4WHcFg4mgpJVMcM1r/4+y8Ll/1UP2jFdhFWcdLiC2k3pm
 Im9ForHRWGhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="220607111"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="220607111"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 10:46:40 -0700
IronPort-SDR: NvVKc6XJtzEuvejT10T0ZfgUmLOsrZhgFX0TcsLcHbcsrq3JnXyqD5FwhmIvmidyChl+uEYnqe
 KndxEbdQSPsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="299553450"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.54.141])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2020 10:46:37 -0700
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
Subject: [PATCH v5 0/4] Add a vhost RPMsg API
Date:   Wed, 26 Aug 2020 19:46:32 +0200
Message-Id: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Next update:

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

Guennadi Liakhovetski (4):
  vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
  rpmsg: move common structures and defines to headers
  rpmsg: update documentation
  vhost: add an RPMsg API

 Documentation/rpmsg.txt          |   6 +-
 drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
 drivers/vhost/Kconfig            |   7 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/rpmsg.c            | 373 +++++++++++++++++++++++++++++++
 drivers/vhost/vhost_rpmsg.h      |  74 ++++++
 include/linux/virtio_rpmsg.h     |  83 +++++++
 include/uapi/linux/rpmsg.h       |   3 +
 include/uapi/linux/vhost.h       |   4 +-
 9 files changed, 551 insertions(+), 80 deletions(-)
 create mode 100644 drivers/vhost/rpmsg.c
 create mode 100644 drivers/vhost/vhost_rpmsg.h
 create mode 100644 include/linux/virtio_rpmsg.h

-- 
2.28.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521CA2B094
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 10:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfE0Isp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 04:48:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:65534 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfE0Isp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 04:48:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 01:48:44 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2019 01:48:41 -0700
From:   Tina Zhang <tina.zhang@intel.com>
Cc:     Tina Zhang <tina.zhang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, alex.williamson@redhat.com,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: [PATCH 0/2] Deliver vGPU page flip event to userspace
Date:   Mon, 27 May 2019 16:43:10 +0800
Message-Id: <20190527084312.8872-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces VFIO_DEVICE_SET_GFX_FLIP_EVENTFD ioctl command to
set the eventfd based signaling mechanism in vfio display. vGPU can use
this eventfd to deliver the framebuffer page flip event to userspace.


Tina Zhang (2):
  vfio: ABI for setting mdev display flip eventfd
  drm/i915/gvt: Support delivering page flip event to userspace

 drivers/gpu/drm/i915/gvt/dmabuf.c   | 31 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/dmabuf.h   |  1 +
 drivers/gpu/drm/i915/gvt/gvt.c      |  1 +
 drivers/gpu/drm/i915/gvt/gvt.h      |  2 ++
 drivers/gpu/drm/i915/gvt/handlers.c |  2 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c    |  7 +++++++
 include/uapi/linux/vfio.h           | 12 +++++++++++
 7 files changed, 56 insertions(+)

-- 
2.17.1


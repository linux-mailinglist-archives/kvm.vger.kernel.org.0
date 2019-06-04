Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513993439F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfFDKBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 06:01:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:46146 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfFDKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 06:01:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:01:14 -0700
X-ExtLoop1: 1
Received: from gvt.bj.intel.com ([10.238.158.187])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2019 03:01:11 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v2 0/3] Deliver vGPU page flip events to userspace
Date:   Tue,  4 Jun 2019 17:55:31 +0800
Message-Id: <20190604095534.10337-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series tries to send the vGPU page flip events to userspace, which
can be used by QEMU UI for rendering and display with the latest guest
framebuffers.

v2: Use VFIO irq chain to get eventfds from userspace instead of adding
a new ABI. (Alex)

v1: https://patchwork.kernel.org/cover/10962341/


Tina Zhang (3):
  vfio: Use capability chains to handle device specific irq
  drm/i915/gvt: Leverage irq capability chain to get eventfd
  drm/i915/gvt: Send plane flip events to user space

 drivers/gpu/drm/i915/gvt/display.c   |  10 +-
 drivers/gpu/drm/i915/gvt/gvt.h       |   4 +
 drivers/gpu/drm/i915/gvt/handlers.c  |  20 ++-
 drivers/gpu/drm/i915/gvt/hypercall.h |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     | 208 +++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/mpt.h       |  16 +++
 include/uapi/linux/vfio.h            |  23 ++-
 7 files changed, 268 insertions(+), 14 deletions(-)

-- 
2.17.1


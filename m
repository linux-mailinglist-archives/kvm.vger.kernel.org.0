Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619473CB250
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhGPGUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhGPGUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:20:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0768BC06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hXKXpHy9bGS1uK5ljrzn6TAqp0ZG8VouCBfEiDPy5WA=; b=GJEd673PlZ7AR7tV1dxC6wtjsA
        UVpNI30sgXvL/Ry0x/2wOpyL+R4hVH7b+FVk44+PcY2U23pbL9UsP7EVpXGN28XR9ttgeZiV2z7Am
        M3G9wLjcCf2+hUP7WWVUU5LYENQtqKW1m5VSe50ac7qmR7lIuZzI70dS71V7szcjFa9XCDPjltDGt
        MA7CqwCSw51SF4wN865Znt0Hi4BzkaXSHseL8hTa+yAMz/tGzmHdNxoZKtZrtEEB090i6RWKUZrWU
        hDhdPWeWoFSbSQo5ZxZ8BT+70Qh/GL4QAscek3l89/HjCwtXLGYQ5m+z4m+sqS4y3VTKswXFV3PZa
        OtpHoarg==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4H9G-004CpP-Od; Fri, 16 Jul 2021 06:16:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: misc vgaarb cleanups
Date:   Fri, 16 Jul 2021 08:16:27 +0200
Message-Id: <20210716061634.2446357-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

this series cleans up a bunch of lose ends in the vgaarb code.

Diffstat:
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 +-
 drivers/gpu/drm/drm_irq.c                  |    4 
 drivers/gpu/drm/i915/display/intel_vga.c   |    9 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c      |    8 -
 drivers/gpu/drm/radeon/radeon_device.c     |   11 +-
 drivers/gpu/vga/vgaarb.c                   |   67 +++++-----------
 drivers/vfio/pci/vfio_pci.c                |   11 +-
 include/linux/vgaarb.h                     |  118 ++++++++++-------------------
 8 files changed, 93 insertions(+), 146 deletions(-)
